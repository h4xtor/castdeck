package sx.movybench;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Lille HTTP-mellemmand til Chromecast. Henter streamen som en rigtig browser
 * (med headers/cookies fra appens WebView) og serverer den videre som en ren
 * stream med CORS og Range-understoettelse. HLS-playlister omskrives, saa
 * ogsaa segmenter gaar gennem mellemmanden.
 *
 * Ren Java uden Android-afhaengigheder, saa den kan testes paa en PC.
 */
public final class ProxyCore {

    public interface HeaderSource {
        /** Headers (Referer, User-Agent, Cookie ...) der skal sendes opstroems. */
        Map<String, String> headersFor(String url, String rootUrl);
    }

    static final class Item {
        final String url;
        final String root;
        final String ext;

        Item(String url, String root, String ext) {
            this.url = url;
            this.root = root;
            this.ext = ext;
        }
    }

    private static final class LruMap extends LinkedHashMap<String, Item> {
        @Override
        protected boolean removeEldestEntry(Map.Entry<String, Item> eldest) {
            return size() > 20000;
        }
    }

    private static final class Names implements ThreadFactory {
        private final AtomicInteger n = new AtomicInteger();

        @Override
        public Thread newThread(Runnable r) {
            Thread t = new Thread(r, "castproxy-" + n.incrementAndGet());
            t.setDaemon(true);
            return t;
        }
    }

    private static final Pattern URI_ATTR = Pattern.compile("URI=\"([^\"]*)\"");
    private static final Charset UTF8 = Charset.forName("UTF-8");

    private final HeaderSource headerSource;
    private final Map<String, Item> tokens = Collections.synchronizedMap(new LruMap());
    private final LinkedList<String> logs = new LinkedList<String>();
    private final AtomicInteger active = new AtomicInteger();
    private final SimpleDateFormat clock = new SimpleDateFormat("HH:mm:ss", Locale.US);

    private ServerSocket server;
    private ExecutorService pool;
    private volatile boolean running;
    private volatile int port;
    public volatile long lastActivity = System.currentTimeMillis();

    public ProxyCore(HeaderSource headerSource) {
        this.headerSource = headerSource;
    }

    public int port() {
        return port;
    }

    public boolean isRunning() {
        return running;
    }

    public int activeConnections() {
        return active.get();
    }

    public synchronized void start() throws IOException {
        if (running) return;
        ServerSocket s = null;
        for (int p = 8099; p <= 8130 && s == null; p++) {
            try {
                ServerSocket t = new ServerSocket();
                t.setReuseAddress(true);
                t.bind(new InetSocketAddress(p), 64);
                s = t;
            } catch (IOException ignore) {
                // proev naeste port
            }
        }
        if (s == null) {
            s = new ServerSocket();
            s.setReuseAddress(true);
            s.bind(new InetSocketAddress(0), 64);
        }
        server = s;
        port = s.getLocalPort();
        pool = Executors.newCachedThreadPool(new Names());
        running = true;
        lastActivity = System.currentTimeMillis();
        final ServerSocket ss = s;
        Thread acceptor = new Thread(new Acceptor(this, ss), "castproxy-accept");
        acceptor.setDaemon(true);
        acceptor.start();
        log("mellemmand startet paa port " + port);
    }

    private static final class Acceptor implements Runnable {
        private final ProxyCore owner;
        private final ServerSocket ss;

        Acceptor(ProxyCore owner, ServerSocket ss) {
            this.owner = owner;
            this.ss = ss;
        }

        @Override
        public void run() {
            while (owner.running) {
                try {
                    Socket c = ss.accept();
                    owner.pool.execute(new Conn(owner, c));
                } catch (IOException e) {
                    if (owner.running) owner.log("accept-fejl: " + e);
                    break;
                } catch (RuntimeException e) {
                    break;
                }
            }
        }
    }

    private static final class Conn implements Runnable {
        private final ProxyCore owner;
        private final Socket c;

        Conn(ProxyCore owner, Socket c) {
            this.owner = owner;
            this.c = c;
        }

        @Override
        public void run() {
            owner.handle(c);
        }
    }

    public synchronized void stop() {
        running = false;
        try {
            if (server != null) server.close();
        } catch (IOException ignore) {
            // ingen handling
        }
        if (pool != null) pool.shutdownNow();
        log("mellemmand stoppet");
    }

    // ---------------------------------------------------------------- tokens

    private static String sha1(String s) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] d = md.digest(s.getBytes(UTF8));
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 8; i++) sb.append(String.format(Locale.US, "%02x", d[i]));
            return sb.toString();
        } catch (Exception e) {
            return Integer.toHexString(s.hashCode());
        }
    }

    private String register(String url, String root, String ext) {
        String token = sha1(url);
        tokens.put(token, new Item(url, root == null ? url : root, ext));
        return token;
    }

    /** Registrerer en stream og giver den lokale URL som Chromecasten skal bruge. */
    public String publicUrl(String url, String ip, boolean hls) {
        String ext = hls ? "m3u8" : topExt(url);
        String token = register(url, url, ext);
        return "http://" + ip + ":" + port + "/p/" + token + "." + ext;
    }

    public static boolean looksHls(String url) {
        String u = url.toLowerCase(Locale.US);
        return u.contains(".m3u8") || u.contains("format=m3u8") || u.contains("playlist");
    }

    /** true hvis URL'en har en tydelig filendelse (saa vi ikke skal sniffe). */
    public static boolean hasClearExt(String url) {
        String e = pathExt(url);
        return e.equals("mp4") || e.equals("m4v") || e.equals("mov") || e.equals("webm")
                || e.equals("mkv") || e.equals("m3u8");
    }

    private static String pathExt(String url) {
        String p = url;
        int q = p.indexOf('?');
        if (q >= 0) p = p.substring(0, q);
        int h = p.indexOf('#');
        if (h >= 0) p = p.substring(0, h);
        int slash = p.lastIndexOf('/');
        int dot = p.lastIndexOf('.');
        if (dot < 0 || dot < slash) return "";
        return p.substring(dot + 1).toLowerCase(Locale.US);
    }

    private static String topExt(String url) {
        String e = pathExt(url);
        if (e.equals("webm")) return "webm";
        if (e.equals("mkv")) return "mkv";
        return "mp4";
    }

    private static String segExt(String url) {
        String e = pathExt(url);
        if (e.equals("m3u8") || e.equals("ts") || e.equals("m4s") || e.equals("mp4")
                || e.equals("m4v") || e.equals("aac") || e.equals("mp3") || e.equals("vtt")
                || e.equals("webvtt") || e.equals("key") || e.equals("cmfv") || e.equals("cmfa")
                || e.equals("m4a") || e.equals("srt")) {
            return e;
        }
        return "ts";
    }

    private static String mimeFor(String ext) {
        if (ext.equals("m3u8")) return "application/vnd.apple.mpegurl";
        if (ext.equals("mp4") || ext.equals("m4v") || ext.equals("m4s") || ext.equals("cmfv")) return "video/mp4";
        if (ext.equals("webm")) return "video/webm";
        if (ext.equals("mkv")) return "video/x-matroska";
        if (ext.equals("aac")) return "audio/aac";
        if (ext.equals("mp3")) return "audio/mpeg";
        if (ext.equals("m4a") || ext.equals("cmfa")) return "audio/mp4";
        if (ext.equals("vtt") || ext.equals("webvtt")) return "text/vtt";
        if (ext.equals("key")) return "application/octet-stream";
        return "video/mp2t";
    }

    // ----------------------------------------------------------------- log

    public void log(String s) {
        String line;
        synchronized (clock) {
            line = clock.format(new Date()) + " " + s;
        }
        synchronized (logs) {
            logs.add(line);
            while (logs.size() > 400) logs.removeFirst();
        }
    }

    public String logText() {
        StringBuilder sb = new StringBuilder();
        synchronized (logs) {
            for (String l : logs) sb.append(l).append('\n');
        }
        return sb.toString();
    }

    private static String shortUrl(String u) {
        try {
            URL x = new URL(u);
            String s = x.getHost() + x.getPath();
            return s.length() > 90 ? s.substring(0, 90) + "..." : s;
        } catch (Exception e) {
            return "?";
        }
    }

    // ------------------------------------------------------------ http server

    private static String readLine(InputStream in) throws IOException {
        StringBuilder sb = new StringBuilder();
        int c;
        while ((c = in.read()) != -1) {
            if (c == '\n') break;
            if (c != '\r') sb.append((char) c);
            if (sb.length() > 16384) throw new IOException("linje for lang");
        }
        if (c == -1 && sb.length() == 0) return null;
        return sb.toString();
    }

    private void handle(Socket s) {
        active.incrementAndGet();
        try {
            s.setSoTimeout(45000);
            s.setTcpNoDelay(true);
            InputStream in = new BufferedInputStream(s.getInputStream());
            OutputStream out = new BufferedOutputStream(s.getOutputStream(), 65536);
            String reqLine = readLine(in);
            if (reqLine == null) return;
            Map<String, String> h = new HashMap<String, String>();
            String line;
            int n = 0;
            while ((line = readLine(in)) != null && line.length() > 0 && n++ < 100) {
                int i = line.indexOf(':');
                if (i > 0) h.put(line.substring(0, i).trim().toLowerCase(Locale.US), line.substring(i + 1).trim());
            }
            String[] p = reqLine.split(" ");
            if (p.length < 2) return;
            String method = p[0].toUpperCase(Locale.US);
            String path = p[1];
            lastActivity = System.currentTimeMillis();
            String client = s.getInetAddress() == null ? "?" : s.getInetAddress().getHostAddress();

            if (method.equals("OPTIONS")) {
                writeHead(out, 204, "No Content", null, -1, null, null, null);
                out.flush();
                return;
            }
            if (path.startsWith("/log") || path.startsWith("/status")) {
                byte[] b = ("MovieBench cast-mellemmand, port " + port + "\n\n" + logText()).getBytes(UTF8);
                writeHead(out, 200, "OK", "text/plain; charset=utf-8", b.length, null, null, null);
                out.write(b);
                out.flush();
                return;
            }
            if (!path.startsWith("/p/")) {
                writeHead(out, 404, "Not Found", "text/plain", 0, null, null, null);
                out.flush();
                return;
            }
            String t = path.substring(3);
            int cut = t.length();
            int dot = t.indexOf('.');
            int q = t.indexOf('?');
            if (dot >= 0) cut = Math.min(cut, dot);
            if (q >= 0) cut = Math.min(cut, q);
            Item e = tokens.get(t.substring(0, cut));
            if (e == null) {
                log(client + " " + method + " ukendt token " + t);
                writeHead(out, 404, "Not Found", "text/plain", 0, null, null, null);
                out.flush();
                return;
            }
            serve(e, method, h, out, client);
        } catch (IOException ex) {
            // klienten lukkede (spoling/pause) - helt normalt
        } catch (RuntimeException ex) {
            log("fejl: " + ex);
        } finally {
            active.decrementAndGet();
            try {
                s.close();
            } catch (IOException ignore) {
                // ingen handling
            }
        }
    }

    private void serve(Item e, String method, Map<String, String> h, OutputStream out, String client)
            throws IOException {
        String url = e.url;
        HttpURLConnection c = null;
        int code = 0;
        String range = h.get("range");
        try {
            for (int redirects = 0; ; redirects++) {
                c = (HttpURLConnection) new URL(url).openConnection();
                c.setInstanceFollowRedirects(false);
                c.setConnectTimeout(15000);
                c.setReadTimeout(30000);
                Map<String, String> up = headerSource.headersFor(url, e.root);
                if (up != null) {
                    for (Map.Entry<String, String> me : up.entrySet()) {
                        if (me.getValue() != null && me.getValue().length() > 0) {
                            c.setRequestProperty(me.getKey(), me.getValue());
                        }
                    }
                }
                c.setRequestProperty("Accept-Encoding", "identity");
                if (range != null) c.setRequestProperty("Range", range);
                code = c.getResponseCode();
                String loc = c.getHeaderField("Location");
                if (code >= 300 && code < 400 && loc != null && redirects < 6) {
                    url = new URL(new URL(url), loc).toString();
                    c.disconnect();
                    continue;
                }
                break;
            }
        } catch (IOException ex) {
            log(client + " " + method + " " + shortUrl(url) + " -> opstroemsfejl: " + ex);
            byte[] b = ("opstroemsfejl: " + ex).getBytes(UTF8);
            writeHead(out, 502, "Bad Gateway", "text/plain", b.length, null, null, null);
            out.write(b);
            out.flush();
            return;
        }

        String ct = c.getContentType();
        String lenHdr = c.getHeaderField("Content-Length");
        log(client + " " + method + (range != null ? " [" + range + "]" : "") + " " + shortUrl(url)
                + " -> " + code + (ct != null ? " " + ct : ""));

        InputStream body = null;
        try {
            body = code >= 400 ? c.getErrorStream() : c.getInputStream();
        } catch (IOException ex) {
            body = c.getErrorStream();
        }

        boolean playlist = code < 400 && (e.ext.equals("m3u8")
                || (ct != null && ct.toLowerCase(Locale.US).contains("mpegurl")));

        if (playlist && body != null) {
            ByteArrayOutputStream bo = new ByteArrayOutputStream();
            byte[] buf = new byte[16384];
            int r;
            while ((r = body.read(buf)) > 0) {
                bo.write(buf, 0, r);
                if (bo.size() > 8 * 1024 * 1024) break;
            }
            body.close();
            String text = new String(bo.toByteArray(), UTF8);
            String host = h.get("host");
            if (host == null) host = "127.0.0.1:" + port;
            byte[] outB = text.trim().startsWith("#EXTM3U")
                    ? rewrite(text, url, e, host).getBytes(UTF8)
                    : bo.toByteArray();
            writeHead(out, 200, "OK", "application/vnd.apple.mpegurl", outB.length, null, null, null);
            if (!method.equals("HEAD")) out.write(outB);
            out.flush();
            return;
        }

        String outCt = fixCt(ct, e.ext);
        String reason = code == 206 ? "Partial Content" : (code == 200 ? "OK" : (c.getResponseMessage() == null ? "" : c.getResponseMessage()));
        String acceptRanges = c.getHeaderField("Accept-Ranges");
        if (acceptRanges == null && code == 206) acceptRanges = "bytes";
        long len = -1;
        if (lenHdr != null) {
            try {
                len = Long.parseLong(lenHdr.trim());
            } catch (NumberFormatException ignore) {
                len = -1;
            }
        }
        writeHead(out, code, reason, outCt, len, c.getHeaderField("Content-Range"), acceptRanges, null);
        if (!method.equals("HEAD") && body != null) {
            byte[] buf = new byte[65536];
            int r;
            try {
                while ((r = body.read(buf)) > 0) {
                    out.write(buf, 0, r);
                    lastActivity = System.currentTimeMillis();
                }
            } finally {
                try {
                    body.close();
                } catch (IOException ignore) {
                    // ingen handling
                }
            }
        }
        out.flush();
        c.disconnect();
    }

    private static String fixCt(String up, String ext) {
        if (up == null) return mimeFor(ext);
        String u = up.toLowerCase(Locale.US);
        boolean bad = u.contains("octet-stream") || u.contains("binary") || u.contains("html")
                || u.startsWith("image/") || (u.startsWith("text/") && !ext.equals("vtt"));
        return bad ? mimeFor(ext) : up;
    }

    private static void writeHead(OutputStream out, int code, String reason, String ct, long len,
                                  String contentRange, String acceptRanges, String extra)
            throws IOException {
        StringBuilder sb = new StringBuilder();
        sb.append("HTTP/1.1 ").append(code).append(' ').append(reason == null ? "" : reason).append("\r\n");
        if (ct != null) sb.append("Content-Type: ").append(ct).append("\r\n");
        if (len >= 0) sb.append("Content-Length: ").append(len).append("\r\n");
        if (contentRange != null) sb.append("Content-Range: ").append(contentRange).append("\r\n");
        if (acceptRanges != null) sb.append("Accept-Ranges: ").append(acceptRanges).append("\r\n");
        sb.append("Access-Control-Allow-Origin: *\r\n");
        sb.append("Access-Control-Allow-Methods: GET, HEAD, OPTIONS\r\n");
        sb.append("Access-Control-Allow-Headers: *\r\n");
        sb.append("Access-Control-Expose-Headers: Content-Length, Content-Range, Content-Type, Accept-Ranges\r\n");
        sb.append("Cache-Control: no-cache\r\n");
        sb.append("Connection: close\r\n");
        if (extra != null) sb.append(extra);
        sb.append("\r\n");
        out.write(sb.toString().getBytes(UTF8));
    }

    // -------------------------------------------------------------- HLS

    private static String abs(String base, String ref) {
        try {
            return new URL(new URL(base), ref).toString();
        } catch (Exception e) {
            return ref;
        }
    }

    private String local(String absUrl, String root, String ext, String host) {
        String token = register(absUrl, root, ext);
        return "http://" + host + "/p/" + token + "." + ext;
    }

    String rewrite(String text, String baseUrl, Item e, String host) {
        StringBuilder sb = new StringBuilder();
        String[] lines = text.split("\r?\n", -1);
        boolean nextIsVariant = false;
        for (int i = 0; i < lines.length; i++) {
            String line = lines[i];
            String t = line.trim();
            boolean last = i == lines.length - 1;
            if (t.length() == 0) {
                if (!last) sb.append('\n');
                continue;
            }
            if (t.startsWith("#")) {
                if (t.startsWith("#EXT-X-STREAM-INF")) nextIsVariant = true;
                Matcher m = URI_ATTR.matcher(line);
                StringBuffer o = new StringBuffer();
                while (m.find()) {
                    String u = m.group(1);
                    String ext;
                    if (t.startsWith("#EXT-X-KEY") || t.startsWith("#EXT-X-SESSION-KEY")) ext = "key";
                    else if (t.startsWith("#EXT-X-MAP")) ext = "mp4";
                    else if (t.startsWith("#EXT-X-MEDIA") || t.startsWith("#EXT-X-I-FRAME-STREAM-INF")) {
                        String se = segExt(u);
                        ext = se.equals("vtt") || se.equals("webvtt") || se.equals("aac") ? se : "m3u8";
                    } else ext = segExt(u);
                    String ref = local(abs(baseUrl, u), e.root, ext, host);
                    m.appendReplacement(o, Matcher.quoteReplacement("URI=\"" + ref + "\""));
                }
                m.appendTail(o);
                sb.append(o);
                if (!last) sb.append('\n');
            } else {
                String ext = nextIsVariant ? "m3u8" : segExt(t);
                nextIsVariant = false;
                sb.append(local(abs(baseUrl, t), e.root, ext, host));
                if (!last) sb.append('\n');
            }
        }
        return sb.toString();
    }

    // ------------------------------------------------------- sniff (HLS?)

    /** Kigger de foerste bytes: er det en HLS-playliste? Blokerer kort. */
    public boolean sniffHls(String url) {
        try {
            HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
            c.setInstanceFollowRedirects(true);
            c.setConnectTimeout(5000);
            c.setReadTimeout(5000);
            Map<String, String> up = headerSource.headersFor(url, url);
            if (up != null) {
                for (Map.Entry<String, String> me : up.entrySet()) {
                    if (me.getValue() != null && me.getValue().length() > 0) {
                        c.setRequestProperty(me.getKey(), me.getValue());
                    }
                }
            }
            c.setRequestProperty("Range", "bytes=0-1023");
            c.setRequestProperty("Accept-Encoding", "identity");
            int code = c.getResponseCode();
            String ct = c.getContentType();
            boolean hls = ct != null && ct.toLowerCase(Locale.US).contains("mpegurl");
            if (!hls && code < 400) {
                InputStream in = c.getInputStream();
                byte[] b = new byte[16];
                int r = in.read(b);
                in.close();
                if (r > 0) hls = new String(b, 0, r, UTF8).trim().startsWith("#EXTM3U");
            }
            c.disconnect();
            return hls;
        } catch (Exception ex) {
            return false;
        }
    }
}
