package sx.movybench;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.widget.Toast;

import com.google.android.gms.cast.MediaError;
import com.google.android.gms.cast.MediaInfo;
import com.google.android.gms.cast.MediaLoadRequestData;
import com.google.android.gms.cast.MediaMetadata;
import com.google.android.gms.cast.MediaStatus;
import com.google.android.gms.cast.MediaTrack;
import com.google.android.gms.cast.TextTrackStyle;
import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastSession;
import com.google.android.gms.cast.framework.media.RemoteMediaClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;

import java.util.ArrayList;
import java.util.List;

import sx.movybench.sub.Srt;

/**
 * Friends MovieBench: direct phone -> Chromecast casting with subtitles,
 * without MovieBridge.
 *
 * The phone's own proxy (CastProxy/ProxyCore) serves the video on the phone's
 * Wi-Fi address; SubServer serves the same subtitles the phone overlay shows as
 * a WebVTT side-loaded text track, which the Default Media Receiver renders on
 * the TV. Only active in the Friends package - the regular MovieBench keeps
 * the old code path (CastHelper.loadLegacy).
 *
 * No lambdas / anonymous classes on purpose (d8 + stub build, see BYG.md).
 */
public final class FriendsCast {

    static final String TAG = "FriendsCast";

    // Real Cast SDK 21.5 values (MediaTrack / TextTrackStyle / MediaStatus).
    // Kept as literals here: the previous stubs had wrong values (TYPE_TEXT=0),
    // which made the receiver ignore the subtitle track.
    static final int TRACK_TYPE_TEXT = 1;
    static final int TRACK_SUBTYPE_SUBTITLES = 1;
    static final int EDGE_TYPE_OUTLINE = 1;
    static final int WINDOW_TYPE_NONE = 0;
    static final int PLAYER_STATE_IDLE = 1;
    static final int IDLE_REASON_ERROR = 4;
    static final int MEDIA_TYPE_MOVIE = 1;
    static final int STREAM_TYPE_BUFFERED = 1;
    static final long TRACK_ID = 1L;

    private static final String KEY_TITLE = "com.google.android.gms.cast.metadata.TITLE";
    private static final String KEY_SUBTITLE = "com.google.android.gms.cast.metadata.SUBTITLE";

    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    /** How long a cast waits for the OpenSubtitles lookup before starting without subtitles. */
    static final long AUTO_WAIT_MS = 12000L;
    /** Debounce for subtitles chosen on the phone while already casting. */
    static final long PUSH_DELAY_MS = 900L;

    private static volatile String lastVtt;
    private static volatile String pendingVtt;
    private static volatile Context appCtx;
    private static volatile String autoText;
    private static volatile String autoKey = "";
    private static final Push PUSH = new Push();
    private static volatile String lastTitle = "Stream";
    private static volatile String lastSubtitle = "";
    private static RemoteMediaClient watched;
    private static Watch watcher;
    private static long lastReportAt;

    private FriendsCast() {
    }

    // ------------------------------------------------------------------ entry points

    /** Replaces CastHelper.load. Non-Friends builds go straight to the old code. */
    public static void load(Context ctx, String url, String title, String sub, CastHelper.Result cb) {
        if (ctx == null || !CastFlow.friends(ctx)) {
            CastHelper.loadLegacy(ctx, url, title, sub, cb);
            return;
        }
        long startMs = 0L;
        if (Bridge.pendingRestart) {
            startMs = Math.max(0L, Math.round(Bridge.pendingStart * 1000.0));
            Bridge.pendingRestart = false;
        }
        if (title != null && !title.isEmpty() && !"Stream".equals(title)) {
            lastTitle = title;
            lastSubtitle = sub == null ? "" : sub;
        }
        Context app = ctx.getApplicationContext();
        appCtx = app;
        Thread t = new Thread(new Prep(app, url, lastTitle, lastSubtitle, cb, startMs),
                "friends-cast-prep");
        t.setDaemon(true);
        t.start();
    }

    /**
     * Called from CastRemote.selectCaption (CC menu, timing adjust) while casting.
     * Returns true when the TV was updated, so the menu does not say
     * "saved for next cast".
     */
    public static boolean selectCaption(Activity a, String mode) {
        return apply(a, mode);
    }

    /**
     * Called (via smali hook) whenever the phone gets new subtitle text - e.g. after
     * the user searched and downloaded one while a cast is running. Pushes it to the
     * TV after a short debounce; a no-op when nothing is being cast.
     */
    public static void onSubs(String text) {
        try {
            Context c = appCtx;
            if (text == null || c == null || !CastFlow.friends(c)) {
                return;
            }
            MAIN.removeCallbacks(PUSH);
            MAIN.postDelayed(PUSH, PUSH_DELAY_MS);
        } catch (Throwable ignored) {
            // never let a subtitle hook break the phone overlay
        }
    }

    static boolean apply(Context a, String mode) {
        try {
            if (a == null || !CastFlow.friends(a)) {
                return false;
            }
            RemoteMediaClient rmc = client(a);
            if (rmc == null || !rmc.hasMediaSession()) {
                return false;
            }
            if ("off".equals(mode)) {
                rmc.setActiveMediaTracks(new long[0]);
                toast(a, "Undertekster slået fra på TV");
                return true;
            }
            String vtt = currentVtt();
            if (vtt == null) {
                toast(a, "Ingen undertekst valgt endnu — vælg eller søg i CC");
                return true;
            }
            if (vtt.equals(lastVtt) && hasTrack(rmc)) {
                rmc.setActiveMediaTracks(new long[] {TRACK_ID});
                toast(a, "Undertekster vises på TV");
                return true;
            }
            if (vtt.equals(pendingVtt)) {
                return true; // this exact text is already on its way to the TV
            }
            String source = CastProxy.lastSource();
            if (source == null || source.isEmpty()) {
                return false;
            }
            Bridge.pendingRestart = true;
            Bridge.pendingStart = rmc.getApproximateStreamPosition() / 1000.0;
            toast(a, "Opdaterer undertekster på TV…");
            load(a, source, lastTitle, lastSubtitle, new Quiet(a.getApplicationContext()));
            return true;
        } catch (Throwable t) {
            Log.w(TAG, "selectCaption failed: " + t.getClass().getSimpleName());
            return false;
        }
    }

    /** Applies the CC-menu timing offset to the phone overlay clock (ms). */
    public static long subTime(long t) {
        if (t < 0) {
            return t;
        }
        long r = t - Math.round(CcMenu.offsetSeconds() * 1000.0);
        return r < 0 ? 0 : r;
    }

    // ------------------------------------------------------------------ helpers

    /** Current subtitles exactly as the phone shows them, as WebVTT (or null). */
    static String currentVtt() {
        String mode = CcMenu.mode();
        if ("off".equals(mode)) {
            return null;
        }
        String text = CastRemote.subs();
        if (text == null || text.trim().isEmpty()) {
            // Nothing chosen on the phone: use what the cast-time lookup found,
            // but only for the film/episode it was fetched for.
            text = AutoSubPolicy.key(lastTitle, lastSubtitle).equals(autoKey) ? autoText : null;
        }
        if (text == null || text.trim().isEmpty()) {
            return null;
        }
        List cues;
        try {
            cues = Srt.cues(text);
        } catch (Throwable t) {
            // A bad subtitle must never crash the cast: fall back to no track.
            Log.w(TAG, "subtitle parse failed: " + t.getClass().getSimpleName());
            return null;
        }
        if (cues == null || cues.isEmpty()) {
            return null;
        }
        int n = cues.size();
        long[] s = new long[n];
        long[] e = new long[n];
        String[] x = new String[n];
        for (int i = 0; i < n; i++) {
            Srt.Cue c = (Srt.Cue) cues.get(i);
            s[i] = c.start;
            e[i] = c.end;
            x[i] = c.text;
        }
        long offset = Math.round(CcMenu.offsetSeconds() * 1000.0);
        return VttBuilder.build(s, e, x, offset);
    }

    static String trackLanguage(String mode) {
        if ("en-us".equals(mode) || "translate-da".equals(mode)) {
            return "en";
        }
        return "da";
    }

    static String trackName(String mode) {
        if ("en-us".equals(mode)) {
            return "English";
        }
        if ("translate-da".equals(mode)) {
            return "Undertekster";
        }
        return "Dansk";
    }

    static boolean isLoopback(String url) {
        if (url == null) {
            return true;
        }
        String u = url.toLowerCase();
        return u.startsWith("http://127.") || u.startsWith("http://localhost")
                || u.startsWith("http://[::1]") || u.startsWith("http://0.0.0.0");
    }

    static String hostOf(String url) {
        if (url == null) {
            return "?";
        }
        int s = url.indexOf("://");
        int from = s < 0 ? 0 : s + 3;
        int end = url.indexOf('/', from);
        return end < 0 ? url.substring(from) : url.substring(from, end);
    }

    static RemoteMediaClient client(Context c) {
        try {
            CastSession s = CastContext.getSharedInstance(c).getSessionManager().getCurrentCastSession();
            if (s == null || !s.isConnected()) {
                return null;
            }
            return s.getRemoteMediaClient();
        } catch (Throwable t) {
            return null;
        }
    }

    static boolean hasTrack(RemoteMediaClient rmc) {
        try {
            MediaInfo mi = rmc.getMediaInfo();
            List tracks = mi == null ? null : mi.getMediaTracks();
            return tracks != null && !tracks.isEmpty();
        } catch (Throwable t) {
            return false;
        }
    }

    static void toast(Context c, String msg) {
        try {
            Toast.makeText(c.getApplicationContext(), msg, Toast.LENGTH_SHORT).show();
        } catch (Throwable ignored) {
            // no UI available
        }
    }

    static void post(Runnable r) {
        MAIN.post(r);
    }

    static synchronized void watch(Context app, RemoteMediaClient rmc) {
        if (rmc == watched) {
            return;
        }
        try {
            if (watched != null && watcher != null) {
                watched.unregisterCallback(watcher);
            }
        } catch (Throwable ignored) {
            // old session already gone
        }
        watcher = new Watch(app, rmc);
        rmc.registerCallback(watcher);
        watched = rmc;
    }

    static void report(Context app, String msg) {
        long now = SystemClock.elapsedRealtime();
        if (now - lastReportAt < 8000L) {
            return;
        }
        lastReportAt = now;
        Log.w(TAG, msg);
        try {
            Toast.makeText(app, msg, Toast.LENGTH_LONG).show();
        } catch (Throwable ignored) {
            // no UI
        }
    }

    static TextTrackStyle style() {
        TextTrackStyle st = new TextTrackStyle();
        st.setFontScale(1.0f);
        st.setForegroundColor(Color.argb(255, 255, 255, 255));
        st.setBackgroundColor(Color.argb(140, 0, 0, 0));
        st.setEdgeType(EDGE_TYPE_OUTLINE);
        st.setEdgeColor(Color.argb(255, 0, 0, 0));
        st.setWindowType(WINDOW_TYPE_NONE);
        return st;
    }

    /**
     * Cast-time OpenSubtitles lookup. Waits up to AUTO_WAIT_MS so the video starts with
     * subtitles when the search is quick; if it is slow the cast starts without and the
     * job pushes the subtitles to the TV as soon as it finishes.
     */
    static String lookupBlocking(Context app, String title, String sub, String mode) {
        post(new Say(app, "Søger undertekster på OpenSubtitles…"));
        AutoJob job = new AutoJob(app, title, sub, mode);
        Thread t = new Thread(job, "friends-autosub");
        t.setDaemon(true);
        t.start();
        try {
            t.join(AUTO_WAIT_MS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        if (job.abandonIfRunning()) {
            post(new Say(app, "Undertekst-søgningen tager tid — sender videoen nu, tekst følger"));
            return null;
        }
        return currentVtt();
    }

    // ------------------------------------------------------------------ jobs

    /** Background: search + download; stores the result for currentVtt(). */
    static final class AutoJob implements Runnable {
        private final Context app;
        private final String title;
        private final String sub;
        private final String mode;
        private boolean finished;
        private boolean abandoned;

        AutoJob(Context app, String title, String sub, String mode) {
            this.app = app;
            this.title = title;
            this.sub = sub;
            this.mode = mode;
        }

        @Override
        public void run() {
            String text = FriendsAutoSub.fetch(app, title, mode);
            if (text != null) {
                autoText = text;
                autoKey = AutoSubPolicy.key(title, sub);
            } else {
                post(new Say(app, "Ingen undertekster fundet — brug CC → Søg undertekst"));
            }
            if (finish() && text != null) {
                // The cast already started without subtitles: add them now.
                post(PUSH);
            }
        }

        private synchronized boolean finish() {
            finished = true;
            return abandoned;
        }

        /** True when the job is still running (and from now on pushes its own result). */
        synchronized boolean abandonIfRunning() {
            if (finished) {
                return false;
            }
            abandoned = true;
            return true;
        }
    }

    /** Debounced "subtitles changed on the phone while casting" -> update the TV. */
    static final class Push implements Runnable {
        @Override
        public void run() {
            Context c = appCtx;
            if (c != null) {
                apply(c, CcMenu.mode());
            }
        }
    }

    /** Main-thread toast. */
    static final class Say implements Runnable {
        private final Context app;
        private final String msg;

        Say(Context app, String msg) {
            this.app = app;
            this.msg = msg;
        }

        @Override
        public void run() {
            toast(app, msg);
        }
    }

    /** Background: proxy the stream and prepare the subtitle file (no network on main). */
    static final class Prep implements Runnable {
        private final Context app;
        private final String url;
        private final String title;
        private final String sub;
        private final CastHelper.Result cb;
        private final long startMs;

        Prep(Context app, String url, String title, String sub, CastHelper.Result cb, long startMs) {
            this.app = app;
            this.url = url;
            this.title = title;
            this.sub = sub;
            this.cb = cb;
            this.startMs = startMs;
        }

        @Override
        public void run() {
            if (url == null || url.isEmpty()) {
                post(new Done(cb, false, "Ingen stream fundet endnu — start afspilningen"));
                return;
            }
            String wrapped;
            try {
                wrapped = CastProxy.wrap(app, url);
            } catch (Throwable t) {
                Log.w(TAG, "wrap failed: " + t.getClass().getSimpleName());
                wrapped = url;
            }
            if (wrapped == null || wrapped.startsWith("mb:")) {
                post(new Done(cb, false, "Videoen kunne ikke forberedes til TV'et"));
                return;
            }
            if (isLoopback(wrapped)) {
                post(new Done(cb, false,
                        "Telefonen har ingen Wi-Fi-adresse, som TV'et kan nå. "
                                + "Forbind telefon og Chromecast til samme Wi-Fi."));
                return;
            }
            String subUrl = null;
            String mode = CcMenu.mode();
            String vtt = currentVtt();
            if (vtt == null && FriendsAutoSub.wanted(app, title)) {
                vtt = lookupBlocking(app, title, sub, mode);
            }
            if (vtt != null) {
                pendingVtt = vtt;
                String ip = CastProxy.localIp();
                SubServer server = SubServer.get();
                if (ip != null && server != null) {
                    String path = server.publish(vtt);
                    subUrl = "http://" + ip + ":" + server.port() + path;
                } else {
                    Log.w(TAG, "subtitle server unavailable (ip=" + (ip != null) + ")");
                }
            }
            Log.i(TAG, "cast prepare: host=" + hostOf(wrapped) + " subs=" + (subUrl != null)
                    + " start=" + startMs);
            post(new Send(app, wrapped, url, title, sub, cb, startMs, subUrl, vtt, mode, true));
        }
    }

    /** Main thread: build the Cast load request (with the text track) and send it. */
    static final class Send implements Runnable {
        final Context app;
        final String media;
        final String original;
        final String title;
        final String sub;
        final CastHelper.Result cb;
        final long startMs;
        final String subUrl;
        final String vtt;
        final String mode;
        final boolean retryWithoutSubs;

        Send(Context app, String media, String original, String title, String sub,
             CastHelper.Result cb, long startMs, String subUrl, String vtt, String mode,
             boolean retryWithoutSubs) {
            this.app = app;
            this.media = media;
            this.original = original;
            this.title = title;
            this.sub = sub;
            this.cb = cb;
            this.startMs = startMs;
            this.subUrl = subUrl;
            this.vtt = vtt;
            this.mode = mode;
            this.retryWithoutSubs = retryWithoutSubs;
        }

        @Override
        public void run() {
            try {
                RemoteMediaClient rmc = client(app);
                if (rmc == null) {
                    done(false, "Ingen cast-session — tryk på cast-knappen først");
                    return;
                }
                MediaMetadata md = new MediaMetadata(MEDIA_TYPE_MOVIE);
                md.putString(KEY_TITLE, title == null || title.isEmpty() ? "Stream" : title);
                if (sub != null && !sub.isEmpty()) {
                    md.putString(KEY_SUBTITLE, sub);
                }
                String type = CastHelper.contentType(media);
                if ("video/mp4".equals(type)) {
                    type = CastHelper.contentType(original);
                }
                MediaInfo.Builder b = new MediaInfo.Builder(media)
                        .setStreamType(STREAM_TYPE_BUFFERED)
                        .setContentType(type)
                        .setMetadata(md);
                boolean withSubs = subUrl != null;
                if (withSubs) {
                    MediaTrack track = new MediaTrack.Builder(TRACK_ID, TRACK_TYPE_TEXT)
                            .setName(trackName(mode))
                            .setSubtype(TRACK_SUBTYPE_SUBTITLES)
                            .setContentId(subUrl)
                            .setContentType("text/vtt")
                            .setLanguage(trackLanguage(mode))
                            .build();
                    List tracks = new ArrayList();
                    tracks.add(track);
                    b.setMediaTracks(tracks);
                    b.setTextTrackStyle(style());
                }
                MediaLoadRequestData.Builder req = new MediaLoadRequestData.Builder()
                        .setMediaInfo(b.build())
                        .setAutoplay(Boolean.TRUE);
                if (startMs > 0) {
                    req.setCurrentTime(startMs);
                }
                if (withSubs) {
                    req.setActiveTrackIds(new long[] {TRACK_ID});
                }
                watch(app, rmc);
                PendingResult pr = rmc.load(req.build());
                pr.setResultCallback(new LoadResult(this));
            } catch (Throwable t) {
                Log.w(TAG, "load failed: " + t.getClass().getSimpleName());
                done(false, "Cast fejl: " + t.getClass().getSimpleName());
            }
        }

        void done(boolean ok, String msg) {
            pendingVtt = null;
            if (cb != null) {
                cb.onResult(ok, msg);
            }
        }
    }

    // Raw type on purpose: a generic ResultCallback makes javac emit a bridge
    // method + Signature attribute that crashes this d8 build (NPE).
    @SuppressWarnings({"rawtypes"})
    static final class LoadResult implements ResultCallback {
        private final Send send;

        LoadResult(Send send) {
            this.send = send;
        }

        @Override
        public void onResult(Result r) {
            pendingVtt = null;
            Status st = r == null ? null : r.getStatus();
            if (st != null && st.isSuccess()) {
                if (send.subUrl != null) {
                    lastVtt = send.vtt;
                    send.done(true, "Sender til TV · " + trackName(send.mode) + " undertekster på TV");
                } else {
                    lastVtt = null;
                    send.done(true, "Sender til TV");
                }
                return;
            }
            int code = st == null ? -1 : st.getStatusCode();
            String why = st == null ? null : st.getStatusMessage();
            Log.w(TAG, "load rejected code=" + code + " subs=" + (send.subUrl != null));
            if (send.subUrl != null && send.retryWithoutSubs) {
                // The receiver refused the request with the text track: keep the
                // video on the TV and say plainly that subtitles are missing.
                toast(send.app, "TV'et afviste underteksterne — sender video uden");
                post(new Send(send.app, send.media, send.original, send.title, send.sub, send.cb,
                        send.startMs, null, null, send.mode, false));
                return;
            }
            send.done(false, "Cast afvist af TV'et (kode " + code + ")"
                    + (why == null || why.isEmpty() ? "" : ": " + why));
        }
    }

    static final class Done implements Runnable {
        private final CastHelper.Result cb;
        private final boolean ok;
        private final String msg;

        Done(CastHelper.Result cb, boolean ok, String msg) {
            this.cb = cb;
            this.ok = ok;
            this.msg = msg;
        }

        @Override
        public void run() {
            if (cb != null) {
                cb.onResult(ok, msg);
            }
        }
    }

    /** Result sink for subtitle-only reloads: just tell the user. */
    static final class Quiet implements CastHelper.Result {
        private final Context app;

        Quiet(Context app) {
            this.app = app;
        }

        @Override
        public void onResult(boolean ok, String msg) {
            toast(app, ok ? "Undertekster opdateret på TV" : msg);
        }
    }

    /** Surfaces receiver-side failures instead of silently falling back to the phone. */
    static final class Watch extends RemoteMediaClient.Callback {
        private final Context app;
        private final RemoteMediaClient rmc;

        Watch(Context app, RemoteMediaClient rmc) {
            this.app = app;
            this.rmc = rmc;
        }

        @Override
        public void onStatusUpdated() {
            try {
                MediaStatus st = rmc.getMediaStatus();
                if (st != null && st.getPlayerState() == PLAYER_STATE_IDLE
                        && st.getIdleReason() == IDLE_REASON_ERROR) {
                    report(app, "Chromecast kunne ikke afspille videoen (format eller forbindelse). "
                            + "Afspilningen fortsætter på telefonen.");
                }
            } catch (Throwable ignored) {
                // status not available
            }
        }

        @Override
        public void onMediaError(MediaError e) {
            try {
                Integer code = e == null ? null : e.getDetailedErrorCode();
                String reason = e == null ? null : e.getReason();
                report(app, "Chromecast-fejl" + (code == null ? "" : " " + code)
                        + (reason == null ? "" : ": " + reason));
            } catch (Throwable ignored) {
                // ignore
            }
        }
    }
}
