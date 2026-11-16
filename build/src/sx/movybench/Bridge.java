package sx.movybench;

import android.content.Context;
import android.content.SharedPreferences;

import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.NetworkInterface;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.Enumeration;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Forbindelsen til MovieBridge paa X280. Finder X280 automatisk paa
 * hjemmenetvaerket (UDP-broadcast) og beder den om at hente + omdanne streamen.
 */
public final class Bridge {

    private static final int DISC_PORT = 8098;
    private static volatile String host;            // "ip:port"
    private static volatile boolean discovering;
    private static volatile long lastDiscover;
    public static volatile String lastStatus = "ikke proevet endnu";

    // svar fra den seneste /api/prepare (bruges af fjernbetjeningen)
    public static volatile String lastId = "";
    public static volatile String lastPlayUrl = "";
    public static volatile boolean lastSame;
    public static volatile double lastStart;
    public static volatile double lastDuration;
    public static volatile String lastSub = "";
    public static volatile String[] lastTracks = new String[0];

    // fjernbetjeningen beder om en genstart (spol / skift undertekster)
    public static volatile boolean pendingRestart;
    public static volatile double pendingStart;
    public static volatile String pendingSubtrack = "";
    public static volatile String pendingSubs = "";

    /** Dansk tekstspor (subs_da.vtt) fra broens seneste /api/prepare. */
    public static volatile String lastSubUrl = "";

    private Bridge() {
    }

    // ------------------------------------------------------------ discovery

    private static final class DiscoverJob implements Runnable {
        @Override
        public void run() {
            try {
                String h = discoverNow(1500);
                if (h != null) remember(h);
            } finally {
                discovering = false;
            }
        }
    }

    /** Start en stille soegning i baggrunden (kaldes tidligt, fx naar en side indlaeses). */
    static void discoverAsync() {
        if (discovering) return;
        if (host != null && System.currentTimeMillis() - lastDiscover < 10 * 60 * 1000L) return;
        discovering = true;
        lastDiscover = System.currentTimeMillis();
        Thread t = new Thread(new DiscoverJob(), "bridge-discover");
        t.setDaemon(true);
        t.start();
    }

    static String discoverNow(int timeoutMs) {
        DatagramSocket s = null;
        try {
            s = new DatagramSocket();
            s.setBroadcast(true);
            s.setSoTimeout(timeoutMs);
            byte[] q = "MOVIEBRIDGE?".getBytes("UTF-8");
            Set<InetAddress> targets = new LinkedHashSet<InetAddress>();
            try {
                Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
                while (en != null && en.hasMoreElements()) {
                    NetworkInterface ni = en.nextElement();
                    if (!ni.isUp() || ni.isLoopback()) continue;
                    for (InterfaceAddress ia : ni.getInterfaceAddresses()) {
                        if (ia.getBroadcast() != null) targets.add(ia.getBroadcast());
                    }
                }
            } catch (Exception ignore) {
                // brug kun global broadcast
            }
            targets.add(InetAddress.getByName("255.255.255.255"));
            for (InetAddress a : targets) {
                try {
                    s.send(new DatagramPacket(q, q.length, a, DISC_PORT));
                } catch (Exception ignore) {
                    // proev naeste
                }
            }
            byte[] buf = new byte[256];
            DatagramPacket p = new DatagramPacket(buf, buf.length);
            s.receive(p);
            String txt = new String(p.getData(), 0, p.getLength(), "UTF-8").trim();
            if (!txt.startsWith("MOVIEBRIDGE ")) return null;
            String[] parts = txt.split(" ");
            int port = Integer.parseInt(parts[1]);
            String h = p.getAddress().getHostAddress() + ":" + port;
            lastStatus = "X280 fundet paa " + h;
            return h;
        } catch (SocketTimeoutException e) {
            lastStatus = "X280 svarede ikke";
            return null;
        } catch (Exception e) {
            lastStatus = "soegning fejlede: " + e;
            return null;
        } finally {
            if (s != null) s.close();
        }
    }

    private static void remember(String h) {
        host = h;
        try {
            Context c = CastProxy.appContext();
            if (c != null) {
                c.getSharedPreferences("moviebridge", Context.MODE_PRIVATE)
                        .edit().putString("host", h).apply();
            }
        } catch (Throwable ignore) {
            // ingen
        }
    }

    private static String saved() {
        try {
            Context c = CastProxy.appContext();
            if (c == null) return null;
            SharedPreferences sp = c.getSharedPreferences("moviebridge", Context.MODE_PRIVATE);
            return sp.getString("host", null);
        } catch (Throwable t) {
            return null;
        }
    }

    // -------------------------------------------------------------- prepare

    private static final class PrepareJob implements Runnable {
        private final String url;
        private final Map<String, String> headers;
        private final AtomicReference<String> out;

        PrepareJob(String url, Map<String, String> headers, AtomicReference<String> out) {
            this.url = url;
            this.headers = headers;
            this.out = out;
        }

        @Override
        public void run() {
            String h = host;
            if (h == null) h = saved();
            if (h == null) {
                h = discoverNow(1200);
                if (h != null) remember(h);
            }
            if (h == null) return;
            String r = post(h, url, headers);
            if (r == null) {
                // X280 kan have faaet ny IP - soeg igen og proev en gang til
                String again = discoverNow(1200);
                if (again != null) {
                    remember(again);
                    r = post(again, url, headers);
                }
            }
            out.set(r);
        }
    }

    /** Returnerer X280's afspilningslink, eller null hvis X280 ikke kan bruges. */
    static String prepare(String url, Map<String, String> headers, long waitMs) {
        AtomicReference<String> out = new AtomicReference<String>(null);
        Thread t = new Thread(new PrepareJob(url, headers, out), "bridge-prepare");
        t.setDaemon(true);
        t.start();
        try {
            t.join(waitMs);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        return out.get();
    }

    /** Hvor langt X280 er kommet (sekunder omdannet mm.), eller null. */
    static JSONObject progress(String id) {
        String h = host;
        if (h == null || id == null || id.length() == 0) return null;
        HttpURLConnection c = null;
        try {
            c = (HttpURLConnection) new URL("http://" + h + "/api/progress?id=" + id).openConnection();
            c.setConnectTimeout(1500);
            c.setReadTimeout(2500);
            InputStream in = c.getInputStream();
            ByteArrayOutputStream bo = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int r;
            while ((r = in.read(buf)) > 0) bo.write(buf, 0, r);
            JSONObject o = new JSONObject(new String(bo.toByteArray(), "UTF-8"));
            return o.optBoolean("ok") ? o : null;
        } catch (Exception e) {
            return null;
        } finally {
            if (c != null) c.disconnect();
        }
    }

    static volatile String pendingTrace = "";

    private static String post(String h, String url, Map<String, String> headers) {
        HttpURLConnection c = null;
        try {
            JSONObject hs = new JSONObject();
            if (headers != null) {
                for (Map.Entry<String, String> e : headers.entrySet()) hs.put(e.getKey(), e.getValue());
            }
            JSONObject body = new JSONObject();
            body.put("url", url);
            body.put("headers", hs);
            body.put("trace", pendingTrace);
            body.put("media", CastProxy.mediaList());
            body.put("want_da", true);          // dansk tekstspor til TV'et (broen bestemmer, om den kan)
            lastSubUrl = "";
            boolean restart = pendingRestart;
            if (restart) {
                body.put("restart", true);
                body.put("start", pendingStart);
                body.put("subtrack", pendingSubtrack);
                body.put("subs", pendingSubs);
                pendingRestart = false;
            } else {
                String sub = CastRemote.subs();
                if (sub != null && sub.length() > 0) body.put("subs", sub);
            }
            byte[] b = body.toString().getBytes("UTF-8");
            c = (HttpURLConnection) new URL("http://" + h + "/api/prepare").openConnection();
            c.setConnectTimeout(1500);
            c.setReadTimeout(4200);
            c.setDoOutput(true);
            c.setRequestMethod("POST");
            c.setRequestProperty("Content-Type", "application/json");
            c.setFixedLengthStreamingMode(b.length);
            OutputStream os = c.getOutputStream();
            os.write(b);
            os.close();
            int code = c.getResponseCode();
            InputStream in = code < 400 ? c.getInputStream() : c.getErrorStream();
            ByteArrayOutputStream bo = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int r;
            while (in != null && (r = in.read(buf)) > 0) bo.write(buf, 0, r);
            JSONObject res = new JSONObject(new String(bo.toByteArray(), "UTF-8"));
            if (res.optBoolean("ok") && res.optString("play_url", "").length() > 0) {
                lastStatus = "sendt via X280 (" + h + ")";
                lastId = res.optString("id", "");
                lastSame = res.optBoolean("same", false);
                lastStart = res.optDouble("start", 0);
                lastDuration = res.optDouble("duration", 0);
                lastSub = res.optString("sub", "");
                lastSubUrl = res.optString("sub_url", "");
                org.json.JSONArray tr = res.optJSONArray("tracks");
                int n = tr == null ? 0 : tr.length();
                String[] names = new String[n];
                for (int i = 0; i < n; i++) {
                    JSONObject o = tr.optJSONObject(i);
                    String lang = o == null ? "" : o.optString("lang", "");
                    String nm = o == null ? "" : o.optString("name", "");
                    names[i] = (lang.length() > 0 ? lang : nm) + "|" + nm;
                }
                lastTracks = names;
                lastPlayUrl = res.getString("play_url");
                android.util.Log.i("MB", "bridge: sid=" + lastId + " start=" + lastStart
                        + " laengde=" + lastDuration + " undertekster='" + lastSub + "' spor=" + n);
                return lastPlayUrl;
            }
            lastStatus = "X280 afviste: " + res.optString("error");
            return null;
        } catch (Exception e) {
            lastStatus = "X280 kunne ikke naas (" + h + "): " + e;
            return null;
        } finally {
            if (c != null) c.disconnect();
        }
    }

    static boolean isBridgeUrl(String url) {
        String h = host;
        return h != null && url.startsWith("http://" + h + "/");
    }
}
