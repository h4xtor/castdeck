package sx.movybench;

import java.util.Locale;

/**
 * Pure decisions for the cast-time OpenSubtitles lookup (no Android, unit tested).
 */
final class AutoSubPolicy {

    private AutoSubPolicy() {
    }

    /** Language the OpenSubtitles search should ask for, given the CC-menu mode. */
    static String searchLang(String mode, String prefLang) {
        if ("en-us".equals(mode) || "translate-da".equals(mode)) {
            return "en";
        }
        if (prefLang == null || prefLang.trim().isEmpty()) {
            return "da";
        }
        return prefLang.trim().toLowerCase(Locale.ROOT);
    }

    /** Titles that carry no information about what is playing. */
    static boolean titleUsable(String title) {
        if (title == null) {
            return false;
        }
        String t = title.trim();
        return !t.isEmpty() && !"Stream".equals(t) && !"MovieBench".equals(t);
    }

    /** Identity of "this film/episode" so a fetched subtitle is never reused for another. */
    static String key(String title, String sub) {
        return (title == null ? "" : title.trim()) + "|" + (sub == null ? "" : sub.trim());
    }
}
