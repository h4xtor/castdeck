package sx.movybench;

import android.content.Context;
import android.util.Log;

import java.util.Iterator;
import java.util.List;

import sx.movybench.sub.ImdbResolver;
import sx.movybench.sub.SubProvider;
import sx.movybench.sub.SubtitleEngine;
import sx.movybench.sub.SubtitleResult;

/**
 * Looks up subtitles on OpenSubtitles (and SubDL, when the user enabled it) for
 * the film/episode that is about to be cast - the same engine, providers and
 * ranking the CC menu's "Soeg undertekst" uses, just without any dialog.
 *
 * Blocking network code: call from a background thread only.
 * No lambdas / anonymous classes on purpose (d8 + stub build, see BYG.md).
 */
final class FriendsAutoSub {

    private static final String TAG = "FriendsAutoSub";

    private FriendsAutoSub() {
    }

    /** True when a cast without chosen subtitles should go looking for some. */
    static boolean wanted(Context app, String title) {
        return !"off".equals(CcMenu.mode())
                && AutoSubPolicy.titleUsable(title)
                && Prefs.autoSub(app);
    }

    /** Returns the downloaded subtitle text (SRT/VTT), or null when nothing usable was found. */
    @SuppressWarnings({"rawtypes"})
    static String fetch(Context app, String title, String mode) {
        try {
            TitleParser tp = TitleParser.parse(title, "", "", "");
            if (tp == null || !tp.sane()) {
                Log.i(TAG, "title not usable for search");
                return null;
            }
            SubProvider.Query q = new SubProvider.Query();
            q.title = tp.title;
            q.year = tp.year;
            q.season = tp.season;
            q.episode = tp.episode;
            q.lang = CcMenu.preferredSearch(AutoSubPolicy.searchLang(mode, Prefs.lang(app)));
            q.imdb = tp.imdb;
            if (q.imdb == null || q.imdb.isEmpty()) {
                q.imdb = resolveImdb(tp);
            }
            SubtitleEngine.Report report = SubtitleEngine.searchBlocking(app, q);
            boolean empty = report.results == null || report.results.isEmpty();
            if (empty && q.imdb != null && !q.imdb.isEmpty()) {
                // A wrong/missing IMDb match must not hide a plain title hit.
                q.imdb = "";
                report = SubtitleEngine.searchBlocking(app, q);
            }
            SubtitleResult best = SubtitleEngine.best(report.results);
            if (best == null) {
                Log.i(TAG, "no subtitles found, errors=" + report.errors);
                return null;
            }
            String text = download(app, best);
            Log.i(TAG, "picked " + best + " chars=" + (text == null ? -1 : text.length()));
            return text == null || text.trim().isEmpty() ? null : text;
        } catch (Throwable t) {
            Log.w(TAG, "auto search failed: " + t.getClass().getSimpleName());
            return null;
        }
    }

    private static String resolveImdb(TitleParser tp) {
        try {
            String id = ImdbResolver.resolve(tp.title, tp.year);
            return id == null ? "" : id;
        } catch (Throwable t) {
            return "";
        }
    }

    @SuppressWarnings({"rawtypes"})
    private static String download(Context app, SubtitleResult r) throws Exception {
        List providers = SubtitleEngine.providers(app);
        for (Iterator it = providers.iterator(); it.hasNext(); ) {
            SubProvider p = (SubProvider) it.next();
            if (p.name().equals(r.provider)) {
                String key = p.name().startsWith("SubDL") ? Prefs.subdlKey(app) : Prefs.osKey(app);
                return p.download(r, key);
            }
        }
        return null;
    }
}
