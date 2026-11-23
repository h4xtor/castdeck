package sx.movybench;

/**
 * Builds a WebVTT document from parsed subtitle cues.
 *
 * Pure Java (no Android types) so it can be unit tested on a plain JDK.
 * The same cue list that drives the phone overlay is fed in here, so the
 * TV and the phone show identical text with identical timing.
 */
public final class VttBuilder {

    private VttBuilder() {
    }

    /**
     * @param starts   cue start times in ms (source timeline)
     * @param ends     cue end times in ms (source timeline)
     * @param texts    cue texts (may contain newlines)
     * @param offsetMs user timing adjustment; positive = subtitles later
     * @return WebVTT text, or null when there are no usable cues
     */
    public static String build(long[] starts, long[] ends, String[] texts, long offsetMs) {
        if (starts == null || ends == null || texts == null) {
            return null;
        }
        int n = Math.min(starts.length, Math.min(ends.length, texts.length));
        StringBuilder sb = new StringBuilder(n * 64 + 16);
        sb.append("WEBVTT\n\n");
        int written = 0;
        for (int i = 0; i < n; i++) {
            String text = clean(texts[i]);
            if (text.isEmpty()) {
                continue;
            }
            long s = starts[i] + offsetMs;
            long e = ends[i] + offsetMs;
            if (e <= 0) {
                continue;
            }
            if (s < 0) {
                s = 0;
            }
            if (e <= s) {
                e = s + 1000;
            }
            sb.append(stamp(s)).append(" --> ").append(stamp(e)).append('\n');
            sb.append(text).append("\n\n");
            written++;
        }
        return written == 0 ? null : sb.toString();
    }

    /** hh:mm:ss.mmm as required by WebVTT. */
    public static String stamp(long ms) {
        if (ms < 0) {
            ms = 0;
        }
        long h = ms / 3600000L;
        long m = (ms / 60000L) % 60L;
        long s = (ms / 1000L) % 60L;
        long f = ms % 1000L;
        return pad(h, 2) + ":" + pad(m, 2) + ":" + pad(s, 2) + "." + pad(f, 3);
    }

    /** Escapes VTT-significant characters and drops blank lines inside a cue. */
    static String clean(String raw) {
        if (raw == null) {
            return "";
        }
        String t = raw.replace("\r", "");
        t = t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        // "-->" must never appear inside cue text
        t = t.replace("--&gt;", "→");
        StringBuilder out = new StringBuilder(t.length());
        String[] lines = t.split("\n");
        for (String line : lines) {
            String l = line.trim();
            if (l.isEmpty()) {
                continue;
            }
            if (out.length() > 0) {
                out.append('\n');
            }
            out.append(l);
        }
        return out.toString();
    }

    private static String pad(long v, int width) {
        String s = Long.toString(v);
        StringBuilder sb = new StringBuilder(width);
        for (int i = s.length(); i < width; i++) {
            sb.append('0');
        }
        return sb.append(s).toString();
    }
}
