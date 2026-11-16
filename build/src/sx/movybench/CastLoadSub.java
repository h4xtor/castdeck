package sx.movybench;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.widget.Toast;

import com.google.android.gms.cast.MediaInfo;
import com.google.android.gms.cast.MediaLoadRequestData;
import com.google.android.gms.cast.MediaMetadata;
import com.google.android.gms.cast.MediaTrack;
import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastSession;
import com.google.android.gms.cast.framework.media.RemoteMediaClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.ResultCallback;

import java.util.ArrayList;
import java.util.List;

/**
 * CastHelper.load med dansk tekstspor: naar broen (X280) har et dansk VTT
 * (/s/<sid>/subs_da.vtt), vedhaeftes det som undertekstspor paa load-requesten
 * saa Chromecast tegner teksterne selv i stedet for indbraending.
 *
 * Roet: broens svar (med sub_url) kommer foerst naar CastProxy.wrap har koert
 * prepare - derfor goeres det her paa en baggrundstraad, og selve load sker
 * altid paa hovedtraaden bagefter. Uden dansk spor opfoerer den sig praecis
 * som CastHelper.load.
 */
public final class CastLoadSub {

    /** Maks ventetid paa at oversaettelsen er faerdig foer TV'et startes. */
    private static final long MAX_WAIT_MS = 60000;

    private CastLoadSub() {
    }

    /** Samme signatur som CastHelper.load - bruges af aktiviteter/fjernbetjening. */
    public static void load(Context c, String url, String title, String sub, CastHelper.Result done) {
        Thread t = new Thread(new WrapJob(c, url, title, sub, done), "mb-castsub");
        t.setDaemon(true);
        t.start();
    }

    // --------------------------------------------------- baggrund: broen foerst

    private static final class ToastJob implements Runnable {
        private final Context c;

        ToastJob(Context c) {
            this.c = c;
        }

        @Override
        public void run() {
            try {
                Toast.makeText(c, "Danske tekster klares til TV'et...", Toast.LENGTH_SHORT).show();
            } catch (Throwable ignore) {
                // ingen toast
            }
        }
    }

    private static final class WrapJob implements Runnable {
        private final Context c;
        private final String url;
        private final String title;
        private final String sub;
        private final CastHelper.Result done;

        WrapJob(Context c, String url, String title, String sub, CastHelper.Result done) {
            this.c = c;
            this.url = url;
            this.title = title;
            this.sub = sub;
            this.done = done;
        }

        @Override
        public void run() {
            String via;
            try {
                via = CastProxy.wrap(c, url);
            } catch (Throwable t) {
                Log.w("MB", "castsub: broen fejlede, gaar direkte: " + t);
                via = null;
            }
            if (via == null || via.length() == 0) via = url;
            boolean wantTrack = Bridge.isBridgeUrl(via)
                    && Bridge.lastSubUrl.length() > 0
                    && !"off".equals(CastRemote.modeStr());
            if (wantTrack) {
                waitForDa();
            }
            Handler h = new Handler(Looper.getMainLooper());
            h.post(new LoadJob(c, url, via, title, sub, done, wantTrack));
        }

        /** Venter (begraenset) paa at broen er faerdig med de danske tekster. */
        private void waitForDa() {
            final long end = SystemClock.elapsedRealtime() + MAX_WAIT_MS;
            Handler h = new Handler(Looper.getMainLooper());
            h.post(new ToastJob(c));
            boolean ready = false;
            while (SystemClock.elapsedRealtime() < end) {
                ready = daReady();
                if (ready) break;
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    break;
                }
            }
            if (ready) {
                Log.i("MB", "castsub: danske tekster klar");
            } else {
                Log.i("MB", "castsub: gaar videre uden ventetid paa oversaettelsen");
            }
        }

        private boolean daReady() {
            try {
                org.json.JSONObject p = Bridge.progress(Bridge.lastId);
                if (p == null) return false;
                if (p.optInt("da_total", 0) == 0) return true;   // intet at oversaette
                return p.optBoolean("da_ready", false);
            } catch (Throwable t) {
                return false;
            }
        }
    }

    // ------------------------------------------------------- hovedtraad: load

    private static final class LoadJob implements Runnable {
        private final Context c;
        private final String origUrl;
        private final String via;
        private final String title;
        private final String sub;
        private final CastHelper.Result done;
        private final boolean wantTrack;

        LoadJob(Context c, String origUrl, String via, String title, String sub,
                CastHelper.Result done, boolean wantTrack) {
            this.c = c;
            this.origUrl = origUrl;
            this.via = via;
            this.title = title;
            this.sub = sub;
            this.done = done;
            this.wantTrack = wantTrack;
        }

        @Override
        public void run() {
            if (!wantTrack) {
                // ingen dansk spor: opfoer dig som CastHelper.load (den laver sit eget wrap)
                CastHelper.load(c, origUrl, title, sub, done);
                return;
            }
            try {
                CastContext cc = CastContext.getSharedInstance(c);
                CastSession sess = cc.getSessionManager().getCurrentCastSession();
                RemoteMediaClient client = sess == null || !sess.isConnected() ? null : sess.getRemoteMediaClient();
                if (client == null) {
                    done.onResult(false, "Cast-sessionen er ikke klar");
                    return;
                }
                MediaMetadata md = new MediaMetadata(1);
                md.putString("com.google.android.gms.cast.metadata.TITLE",
                        title == null || title.length() == 0 ? "Stream" : title);
                if (sub != null && sub.length() > 0) {
                    md.putString("com.google.android.gms.cast.metadata.SUBTITLE", sub);
                }
                List<MediaTrack> tracks = new ArrayList<MediaTrack>();
                MediaTrack da = new MediaTrack.Builder(1L, MediaTrack.TYPE_TEXT)
                        .setSubtype(MediaTrack.SUBTITLE_TYPE_SUBTITLES)
                        .setContentId(Bridge.lastSubUrl)
                        .setName("Dansk")
                        .setLanguage("da")
                        .build();
                tracks.add(da);
                MediaInfo info = new MediaInfo.Builder(via)
                        .setStreamType(1)
                        .setContentType("application/x-mpegURL")
                        .setMetadata(md)
                        .setMediaTracks(tracks)
                        .build();
                MediaLoadRequestData req = new MediaLoadRequestData.Builder()
                        .setMediaInfo(info)
                        .setAutoplay(Boolean.TRUE)
                        .build();
                PendingResult r = client.load(req);
                r.setResultCallback(new LoadDone(done, client));
            } catch (Throwable e) {
                Log.w("MB", "castsub load fejlede: " + e);
                done.onResult(false, "Cast fejl: " + e.getClass().getSimpleName());
            }
        }
    }

    private static final class LoadDone implements ResultCallback {
        private final CastHelper.Result done;
        private final RemoteMediaClient client;

        LoadDone(CastHelper.Result done, RemoteMediaClient client) {
            this.done = done;
            this.client = client;
        }

        @Override
        public void onResult(Result r) {
            boolean ok = false;
            String msg = "Cast afvist";
            try {
                if (r != null && r.getStatus() != null) {
                    ok = r.getStatus().isSuccess();
                    String m = r.getStatus().getStatusMessage();
                    if (!ok && m != null) msg = "Cast afvist: " + m;
                }
            } catch (Throwable ignore) {
                // ok = false
            }
            if (ok) {
                done.onResult(true, "Sender til TV");
                try {
                    // saet det danske spor aktivt med det samme
                    client.setActiveMediaTracks(new long[]{1L});
                } catch (Throwable ignore) {
                    // brugeren kan vaelge det i TV'ets menu
                }
            } else {
                done.onResult(false, msg);
            }
        }
    }
}
