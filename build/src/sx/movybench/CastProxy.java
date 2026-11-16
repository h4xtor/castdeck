package sx.movybench;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.webkit.CookieManager;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.URL;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Limen mellem MovieBench og mellemmanden (ProxyCore).
 * - note(): kaldes for hver WebView-forespoergsel og husker de rigtige headers.
 * - wrap(): kaldes lige foer cast og laver streamlinket om til et lokalt link.
 */
public final class CastProxy {

    private static ProxyCore core;
    private static Context appCtx;
    private static volatile String lastPage;
    private static final Map<String, Map<String, String>> seen = Collections.synchronizedMap(
            new LinkedHashMap<String, Map<String, String>>() {
                @Override
                protected boolean removeEldestEntry(Map.Entry<String, Map<String, String>> e) {
                    return size() > 300;
                }
            });

    private static final java.util.ArrayList<String> trace = new java.util.ArrayList<String>();

    private CastProxy() {
    }

    private static boolean staticAsset(String u) {
        String l = u.toLowerCase(Locale.US);
        int q = l.indexOf('?');
        if (q > 0) l = l.substring(0, q);
        return l.endsWith(".css") || l.endsWith(".js") || l.endsWith(".png") || l.endsWith(".jpg")
                || l.endsWith(".jpeg") || l.endsWith(".gif") || l.endsWith(".svg") || l.endsWith(".webp")
                || l.endsWith(".woff") || l.endsWith(".woff2") || l.endsWith(".ttf") || l.endsWith(".ico");
    }

    private static void addTrace(WebResourceRequest r, String url) {
        if (staticAsset(url)) return;
        Map<String, String> h = r.getRequestHeaders();
        String range = null;
        if (h != null) {
            for (Map.Entry<String, String> e : h.entrySet()) {
                if (e.getKey().equalsIgnoreCase("range")) range = e.getValue();
            }
        }
        String line = r.getMethod() + " " + (url.length() > 170 ? url.substring(0, 170) + "..." : url)
                + (range != null ? "  [Range: " + range + "]" : "");
        synchronized (trace) {
            trace.add(line);
            while (trace.size() > 60) trace.remove(0);
        }
    }

    private static volatile String lastSource = "";

    static String lastSource() {
        return lastSource;
    }

    /** De vigtigste links WebView har set (hovedlister foerst), saa X280 kan finde den rigtige film. */
    static org.json.JSONArray mediaList() {
        org.json.JSONArray out = new org.json.JSONArray();
        try {
            java.util.ArrayList<String> keys;
            synchronized (seen) {
                keys = new java.util.ArrayList<String>(seen.keySet());
            }
            java.util.ArrayList<String> pick = new java.util.ArrayList<String>();
            int other = 0;
            for (int i = keys.size() - 1; i >= 0 && pick.size() < 24; i--) {
                String k = keys.get(i);
                String l = k.toLowerCase(Locale.US);
                boolean list = l.contains(".m3u8") || l.contains("/manifest") || l.contains("init")
                        || l.contains(".mp4") || l.contains(".mkv") || l.contains(".webm");
                if (list) {
                    pick.add(k);
                } else if (other < 3) {
                    pick.add(k);
                    other++;
                }
            }
            for (int i = pick.size() - 1; i >= 0; i--) out.put(pick.get(i));
        } catch (Throwable ignore) {
            // tom liste er ok
        }
        return out;
    }

    static String traceDump() {
        StringBuilder sb = new StringBuilder();
        synchronized (trace) {
            for (String s : trace) sb.append(s).append('\n');
        }
        return sb.toString();
    }

    // ------------------------------------------------------------ WebView hook

    public static void note(WebResourceRequest r) {
        try {
            String url = r.getUrl().toString();
            if (r.isForMainFrame()) lastPage = url;
            addTrace(r, url);
            Bridge.discoverAsync();
            if (looksMedia(url)) {
                Map<String, String> h = r.getRequestHeaders();
                seen.put(url, h == null ? new HashMap<String, String>() : new HashMap<String, String>(h));
            }
        } catch (Throwable ignore) {
            // maa aldrig vaelte WebView
        }
    }

    private static boolean looksMedia(String url) {
        String u = url.toLowerCase(Locale.US);
        return u.contains(".m3u8") || u.contains(".mp4") || u.contains(".mkv") || u.contains(".webm")
                || u.contains("format=m3u8") || u.contains("/manifest") || u.contains(".ts")
                || u.contains(".m4s");
    }

    // ---------------------------------------------------------------- headers

    private static final ProxyCore.HeaderSource HEADERS = new ProxyCore.HeaderSource() {
        @Override
        public Map<String, String> headersFor(String url, String rootUrl) {
            Map<String, String> out = new HashMap<String, String>();
            try {
                Map<String, String> s = seen.get(url);
                if (s == null) s = seen.get(rootUrl);
                if (s != null) {
                    for (Map.Entry<String, String> e : s.entrySet()) {
                        String k = e.getKey();
                        String lk = k.toLowerCase(Locale.US);
                        if (lk.equals("range") || lk.equals("host") || lk.equals("accept-encoding")
                                || lk.equals("connection") || lk.equals("content-length")
                                || lk.equals("x-requested-with")) {
                            continue;
                        }
                        out.put(k, e.getValue());
                    }
                }
                if (!containsKey(out, "User-Agent")) {
                    String ua = null;
                    try {
                        if (appCtx != null) ua = WebSettings.getDefaultUserAgent(appCtx);
                    } catch (Throwable ignore) {
                        // brug standard
                    }
                    if (ua == null) ua = System.getProperty("http.agent");
                    if (ua != null) out.put("User-Agent", ua);
                }
                if (!containsKey(out, "Referer")) {
                    String ref = lastPage;
                    if (ref == null) {
                        try {
                            URL u = new URL(url);
                            ref = u.getProtocol() + "://" + u.getHost() + "/";
                        } catch (Exception ignore) {
                            ref = null;
                        }
                    }
                    if (ref != null) out.put("Referer", ref);
                }
                try {
                    String cookie = CookieManager.getInstance().getCookie(url);
                    if (cookie != null && cookie.length() > 0) out.put("Cookie", cookie);
                } catch (Throwable ignore) {
                    // ingen cookies
                }
                if (!containsKey(out, "Accept")) out.put("Accept", "*/*");
            } catch (Throwable ignore) {
                // returner det vi har
            }
            return out;
        }
    };

    private static boolean containsKey(Map<String, String> m, String key) {
        for (String k : m.keySet()) if (k.equalsIgnoreCase(key)) return true;
        return false;
    }

    // ------------------------------------------------------------- cast hook

    public static synchronized String wrap(Context ctx, String url) {
        try {
            if (url == null || !(url.startsWith("http://") || url.startsWith("https://"))) return url;
            if (ctx != null) appCtx = ctx.getApplicationContext();
            if (Bridge.isBridgeUrl(url)) return url;
            // 1) X280 (MovieBridge): henter + omdanner til H.264/AAC
            Bridge.pendingTrace = traceDump();
            String viaX280 = Bridge.prepare(url, HEADERS.headersFor(url, url), 4800);
            if (viaX280 != null) {
                lastSource = url;
                if (core != null) core.log("cast via X280: " + viaX280);
                // samme film sendes igen (fx fra et andet link paa siden) -> lad TV'et vaere i fred
                if (Bridge.lastSame && CastRemote.tvHasMedia(ctx, viaX280)) return "mb:skip";
                return viaX280;
            }
            // 2) Ellers: mellemmanden paa telefonen
            String ip = localIp();
            if (ip == null) return url;
            if (core == null || !core.isRunning()) {
                core = new ProxyCore(HEADERS);
                core.start();
            }
            if (url.startsWith("http://" + ip + ":" + core.port() + "/")) return url;
            startService();
            boolean hls = ProxyCore.looksHls(url);
            if (!hls && !ProxyCore.hasClearExt(url)) {
                hls = sniff(url);
            }
            core.log("X280: " + Bridge.lastStatus);
            String local = core.publicUrl(url, ip, hls);
            core.log("cast: " + (hls ? "HLS" : "fil") + " -> " + local);
            return local;
        } catch (Throwable t) {
            return url;
        }
    }

    private static boolean sniff(final String url) {
        final AtomicReference<Boolean> res = new AtomicReference<Boolean>(Boolean.FALSE);
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                res.set(Boolean.valueOf(core.sniffHls(url)));
            }
        }, "castproxy-sniff");
        t.setDaemon(true);
        t.start();
        try {
            t.join(3000);
        } catch (InterruptedException ignore) {
            Thread.currentThread().interrupt();
        }
        return res.get().booleanValue();
    }

    private static void startService() {
        try {
            if (appCtx == null) return;
            Intent i = new Intent(appCtx, CastProxyService.class);
            if (Build.VERSION.SDK_INT >= 26) appCtx.startForegroundService(i);
            else appCtx.startService(i);
        } catch (Throwable ignore) {
            // proxyen virker stadig mens appen er i forgrunden
        }
    }

    static synchronized void shutdown() {
        if (core != null) core.stop();
        core = null;
    }

    static long idleMillis() {
        ProxyCore c = core;
        if (c == null) return Long.MAX_VALUE;
        if (c.activeConnections() > 0) return 0;
        return System.currentTimeMillis() - c.lastActivity;
    }

    static Context appContext() {
        return appCtx;
    }

    static boolean isRunning() {
        ProxyCore c = core;
        return c != null && c.isRunning();
    }

    // ------------------------------------------------------------------ net

    static String localIp() {
        String fallback = null;
        try {
            Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
            while (en != null && en.hasMoreElements()) {
                NetworkInterface ni = en.nextElement();
                if (!ni.isUp() || ni.isLoopback()) continue;
                String name = ni.getName() == null ? "" : ni.getName().toLowerCase(Locale.US);
                Enumeration<InetAddress> ad = ni.getInetAddresses();
                while (ad.hasMoreElements()) {
                    InetAddress a = ad.nextElement();
                    if (!(a instanceof Inet4Address) || a.isLoopbackAddress()) continue;
                    if (!a.isSiteLocalAddress()) continue;
                    if (name.startsWith("wlan")) return a.getHostAddress();
                    if (fallback == null && !name.startsWith("rmnet") && !name.startsWith("tun")
                            && !name.startsWith("tailscale")) {
                        fallback = a.getHostAddress();
                    }
                }
            }
        } catch (Throwable ignore) {
            // ingen
        }
        return fallback;
    }
}
