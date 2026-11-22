package sx.movybench;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Plain-JDK tests for the Android-independent Friends classes.
 * Run: see friends/test.sh. Exit code != 0 on any failure.
 */
public final class FriendsTests {

    private static int passed;
    private static final List<String> FAILED = new ArrayList<>();

    public static void main(String[] args) throws Exception {
        stampFormat();
        buildBasic();
        buildOffsetLaterAndEarlier();
        buildDropsAndClamps();
        buildEscapes();
        buildEmptyIsNull();
        longFilmNoDrift();
        serverServesVttWithCors();
        serverPreflightAnd404();
        serverVersioning();
        serverHead();
        serverConcurrent();

        System.out.println("passed: " + passed + ", failed: " + FAILED.size());
        for (String f : FAILED) {
            System.out.println("  FAIL " + f);
        }
        if (!FAILED.isEmpty()) {
            System.exit(1);
        }
    }

    // ---------------------------------------------------------------- VttBuilder

    static void stampFormat() {
        eq("stamp 0", "00:00:00.000", VttBuilder.stamp(0));
        eq("stamp 1h2m3s4ms", "01:02:03.004", VttBuilder.stamp(3723004L));
        eq("stamp negative clamps", "00:00:00.000", VttBuilder.stamp(-50));
        eq("stamp >10h", "12:00:00.000", VttBuilder.stamp(12L * 3600000L));
    }

    static void buildBasic() {
        String v = VttBuilder.build(new long[] {1000, 5000}, new long[] {2500, 7000},
                new String[] {"Hej", "To\nlinjer"}, 0);
        eq("header", true, v.startsWith("WEBVTT\n\n"));
        eq("cue 1", true, v.contains("00:00:01.000 --> 00:00:02.500\nHej\n\n"));
        eq("cue 2 multi-line", true, v.contains("00:00:05.000 --> 00:00:07.000\nTo\nlinjer\n\n"));
    }

    static void buildOffsetLaterAndEarlier() {
        String later = VttBuilder.build(new long[] {10000}, new long[] {12000}, new String[] {"x"}, 500);
        eq("offset +0.5s", true, later.contains("00:00:10.500 --> 00:00:12.500"));
        String earlier = VttBuilder.build(new long[] {10000}, new long[] {12000}, new String[] {"x"}, -2000);
        eq("offset -2s", true, earlier.contains("00:00:08.000 --> 00:00:10.000"));
    }

    static void buildDropsAndClamps() {
        String v = VttBuilder.build(new long[] {0, 1000, 3000}, new long[] {500, 4000, 3000},
                new String[] {"gone", "clamped", "zero-length"}, -1500);
        eq("cue ending before 0 dropped", false, v.contains("gone"));
        eq("start clamped to 0", true, v.contains("00:00:00.000 --> 00:00:02.500\nclamped"));
        eq("zero-length cue gets 1s", true, v.contains("00:00:01.500 --> 00:00:02.500\nzero-length"));
    }

    static void buildEscapes() {
        String v = VttBuilder.build(new long[] {0}, new long[] {1000},
                new String[] {"Tom & Jerry <3 --> slut\r\n\n  "}, 0);
        eq("ampersand escaped", true, v.contains("Tom &amp; Jerry"));
        eq("lt escaped", true, v.contains("&lt;3"));
        eq("no arrow inside text", 1, count(v, "-->"));
        eq("blank lines removed", false, v.contains("slut\n\n\n"));
    }

    static void buildEmptyIsNull() {
        eq("null input", null, VttBuilder.build(null, null, null, 0));
        eq("only blank text", null, VttBuilder.build(new long[] {0}, new long[] {1}, new String[] {"  "}, 0));
    }

    /** 2h film, one cue per 3 s: last cue keeps exact source timing (no drift). */
    static void longFilmNoDrift() {
        int n = 2400;
        long[] s = new long[n];
        long[] e = new long[n];
        String[] t = new String[n];
        for (int i = 0; i < n; i++) {
            s[i] = i * 3000L + 137;
            e[i] = s[i] + 2000;
            t[i] = "Linje " + i;
        }
        String v = VttBuilder.build(s, e, t, 0);
        eq("cue count", n, count(v, "-->"));
        // last cue starts at 7197.137 s = 01:59:57.137
        eq("last cue exact", true, v.contains("01:59:57.137 --> 01:59:59.137\nLinje 2399"));
    }

    // ---------------------------------------------------------------- SubServer

    static void serverServesVttWithCors() throws Exception {
        SubServer srv = SubServer.get();
        String path = srv.publish("WEBVTT\n\n00:00:01.000 --> 00:00:02.000\nDansk æøå\n\n");
        HttpURLConnection c = open(srv, path, "GET");
        eq("GET status", 200, c.getResponseCode());
        eq("content type", "text/vtt; charset=utf-8", c.getHeaderField("Content-Type"));
        eq("CORS origin", "*", c.getHeaderField("Access-Control-Allow-Origin"));
        eq("body utf-8", true, read(c).contains("Dansk æøå"));
    }

    static void serverPreflightAnd404() throws Exception {
        SubServer srv = SubServer.get();
        HttpURLConnection o = open(srv, "/subs/1.vtt", "OPTIONS");
        eq("OPTIONS 204", 204, o.getResponseCode());
        eq("OPTIONS CORS", "*", o.getHeaderField("Access-Control-Allow-Origin"));
        eq("unknown path 404", 404, open(srv, "/etc/passwd", "GET").getResponseCode());
        eq("query string ignored", 200, open(srv, srv.publish(srv.currentText()) + "?x=1", "GET").getResponseCode());
    }

    static void serverVersioning() {
        SubServer srv = SubServer.get();
        String a = srv.publish("WEBVTT\n\nA");
        String a2 = srv.publish("WEBVTT\n\nA");
        String b = srv.publish("WEBVTT\n\nB");
        eq("same text keeps url", a, a2);
        eq("new text new url", false, a.equals(b));
    }

    static void serverHead() throws Exception {
        SubServer srv = SubServer.get();
        String p = srv.publish("WEBVTT\n\nHEAD-test");
        HttpURLConnection c = open(srv, p, "HEAD");
        eq("HEAD 200", 200, c.getResponseCode());
        eq("HEAD length header", String.valueOf("WEBVTT\n\nHEAD-test".length()), c.getHeaderField("Content-Length"));
    }

    static void serverConcurrent() throws Exception {
        final SubServer srv = SubServer.get();
        final String p = srv.publish("WEBVTT\n\nconcurrent");
        final int[] ok = new int[1];
        Thread[] ts = new Thread[20];
        for (int i = 0; i < ts.length; i++) {
            ts[i] = new Thread(new Fetch(srv, p, ok));
            ts[i].start();
        }
        for (Thread t : ts) {
            t.join(10000);
        }
        eq("20 parallel GETs", 20, ok[0]);
    }

    static final class Fetch implements Runnable {
        final SubServer srv;
        final String path;
        final int[] ok;

        Fetch(SubServer srv, String path, int[] ok) {
            this.srv = srv;
            this.path = path;
            this.ok = ok;
        }

        @Override
        public void run() {
            try {
                HttpURLConnection c = open(srv, path, "GET");
                if (c.getResponseCode() == 200 && read(c).contains("concurrent")) {
                    synchronized (ok) {
                        ok[0]++;
                    }
                }
            } catch (Exception ignored) {
                // counted as failure
            }
        }
    }

    // ---------------------------------------------------------------- helpers

    static HttpURLConnection open(SubServer srv, String path, String method) throws Exception {
        HttpURLConnection c = (HttpURLConnection) new URL("http://127.0.0.1:" + srv.port() + path).openConnection();
        c.setRequestMethod(method);
        c.setConnectTimeout(3000);
        c.setReadTimeout(3000);
        return c;
    }

    static String read(HttpURLConnection c) throws Exception {
        try (InputStream in = c.getInputStream()) {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int r;
            while ((r = in.read(buf)) > 0) {
                out.write(buf, 0, r);
            }
            return new String(out.toByteArray(), StandardCharsets.UTF_8);
        }
    }

    static int count(String s, String needle) {
        int n = 0;
        int i = 0;
        while ((i = s.indexOf(needle, i)) >= 0) {
            n++;
            i += needle.length();
        }
        return n;
    }

    static void eq(String name, Object want, Object got) {
        boolean same = want == null ? got == null : want.equals(got);
        if (same) {
            passed++;
        } else {
            FAILED.add(name + ": want <" + want + "> got <" + got + ">");
        }
    }
}
