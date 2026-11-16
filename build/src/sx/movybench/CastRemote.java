package sx.movybench;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.webkit.ValueCallback;
import android.webkit.WebView;
import android.widget.Toast;

import com.google.android.gms.cast.framework.CastContext;
import com.google.android.gms.cast.framework.CastSession;
import com.google.android.gms.cast.framework.SessionManager;
import com.google.android.gms.cast.framework.media.RemoteMediaClient;

import org.json.JSONObject;

/**
 * Appens egen (skjulte, lydloese) afspiller er styringen af TV'et:
 * spoler man i den, spoler TV'et med; pause/play foelger med; undertekster sendes til TV'et.
 *
 * Findes videoen i en iframe eller et shadow DOM, faar vi tilstanden via Frames-motoren
 * (MB.tick), som er injiceret i alle rammer. Uden motoren bruges JS-walkeren her.
 */
public final class CastRemote {

    private static final Handler H = new Handler(Looper.getMainLooper());

    // JS: gaar ned i iframes (same-origin) og shadowRoots, max 6 niveauer og fael elementer.
    private static final String JS_WALK = "function mbDeep(r,out,d){try{"
            + "if(d>6||!r||!r.querySelectorAll)return;"
            + "var vs=r.querySelectorAll('video');for(var i=0;i<vs.length;i++)out.push(vs[i]);"
            + "var s=r.querySelectorAll('*');var cap=Math.min(s.length,1500);"
            + "for(var i=0;i<cap;i++){var sr=null;try{sr=s[i].shadowRoot;}catch(e){}"
            + "if(sr)mbDeep(sr,out,d+1);}"
            + "var fs=r.querySelectorAll('iframe');var fc=Math.min(fs.length,40);"
            + "for(var i=0;i<fc;i++){try{var dd=fs[i].contentDocument;"
            + "if(dd)mbDeep(dd,out,d+1);}catch(e){}}"
            + "}catch(e){}}";

    // JS: goer ALLE videoer lydloese og usynlige, og returnerer "tid_ms,pause,laengde_ms"
    private static final String JS_READ = "(function(){try{" + JS_WALK
            + "var out=[];mbDeep(document,out,0);if(!out.length)return '';"
            + "var best=null;"
            + "for(var i=0;i<out.length;i++){var v=out[i];"
            + "try{v.muted=true;v.volume=0;v.style.opacity='0';}catch(e){}"
            + "if(v.duration>0&&(!best||v.duration>best.duration))best=v;}"
            + "if(!best)best=out[0];"
            + "var d=best.duration;if(!(d>0))d=0;"
            + "return Math.round(best.currentTime*1000)+','+(best.paused?1:0)+','+Math.round(d*1000);"
            + "}catch(e){return '';}})()";
    private static final String JS_PAUSE = "(function(){try{" + JS_WALK
            + "var out=[];mbDeep(document,out,0);"
            + "for(var i=0;i<out.length;i++){try{out[i].pause();}catch(e){}}}catch(e){}})()";
    private static final String JS_PLAY = "(function(){try{" + JS_WALK
            + "var out=[];mbDeep(document,out,0);"
            + "for(var i=0;i<out.length;i++){var v=out[i];try{v.muted=true;v.volume=0;var p=v.play();"
            + "if(p&&p.catch)p.catch(function(){});}catch(e){}}}catch(e){}})()";
    private static final String JS_RESTORE = "(function(){try{" + JS_WALK
            + "var out=[];mbDeep(document,out,0);"
            + "for(var i=0;i<out.length;i++){var v=out[i];try{v.style.opacity='';v.muted=false;"
            + "v.volume=1;}catch(e){}}}catch(e){}})()";

    private static Activity act;
    private static volatile String subsText;
    private static volatile boolean active;
    private static boolean loading;
    private static double baseStart;
    private static double total;
    private static volatile double converted;
    private static String sid = "";
    private static String mode = "off";
    private static int idleTicks;
    private static int noVideoTicks;
    private static boolean warned;
    private static long gen;
    private static volatile long restoreUntil;

    // tilstand skubbet fra Frames-motoren (MB.tick) - gyldig i 2,6 sek
    private static volatile long pushT = -1;
    private static volatile boolean pushPaused;
    private static volatile long pushD;
    private static volatile long pushAt;

    // afspillerens tilstand sidste gang vi kiggede
    private static long lastT = -1;
    private static long lastWall;
    private static boolean lastPaused;
    private static boolean phonePausedByUs;
    private static double pendingTarget = -1;
    private static long pendingAt;
    private static double phoneSec = 0;

    private CastRemote() {
    }

    // ------------------------------------------------------------ udefra

    /** Appens egen undertekst-tekst (SRT) - sendes med til X280, saa den braendes ind i billedet. */
    static String subs() {
        return subsText;
    }

    /** Nuvaerende undertekst-tilstand ("app" | "t:<spor>" | "off"). */
    static String modeStr() {
        return mode;
    }

    /** Kaldes naar appen indlaeser eller fjerner undertekster. Maa aldrig kaste fejl. */
    public static void onSubs(String text) {
        try {
            subsText = (text == null || text.trim().length() == 0) ? null : text;
            Log.i("MB", "onSubs: " + (subsText == null ? "fjernet" : subsText.length() + " tegn"));
            if (!active || subsText == null) return;
            mode = "app";
            H.removeCallbacks(RESTART);
            H.postDelayed(RESTART, 1200);
        } catch (Throwable ignore) {
            // undertekster maa aldrig vaelte appen
        }
    }

    /**
     * Frames-motoren i (hver) raemme meldinger tilstand hvert 0,5 sek og faar en kommando:
     * "" (ingenting) / "h" (lydloes+skjul) / "hp" (skjul+pause) / "h+" (skjul+spil) / "r" (gendan).
     */
    public static String onTick(String raw) {
        try {
            if (raw != null && raw.length() > 0 && raw.length() < 4096) {
                JSONObject o = new JSONObject(raw);
                long t = o.optLong("t", -1);
                if (t >= 0) {
                    pushT = t;
                    pushPaused = o.optInt("p", 0) == 1;
                    pushD = o.optLong("d", 0);
                    pushAt = SystemClock.elapsedRealtime();
                }
            }
        } catch (Throwable ignore) {
            // maa aldrig kaste i JS-vaevet
        }
        if (!active) return "r";
        if (SystemClock.elapsedRealtime() < restoreUntil) return "r";
        if (loading) return "hp";
        return "h";
    }

    /** Er TV'et allerede i gang med netop dette link? */
    static boolean tvHasMedia(Context ctx, String playUrl) {
        try {
            RemoteMediaClient c = client(ctx != null ? ctx : CastProxy.appContext());
            if (c == null || c.getMediaInfo() == null) return false;
            if (!playUrl.equals(c.getMediaInfo().getContentId())) return false;
            return c.getPlayerState() != 1;
        } catch (Throwable t) {
            return false;
        }
    }

    /** Kaldes naar TV'et har taget imod en film. */
    public static void onCast(Activity a) {
        try {
            act = a;
            sid = Bridge.lastId;
            baseStart = Bridge.lastStart;
            total = Bridge.lastDuration;
            converted = 0;
            String sub = Bridge.lastSub;
            if (sub.startsWith("fra appen")) mode = "app";
            else if (sub.startsWith("spor ")) mode = "t:" + sub.substring(5);
            else mode = "off";
            loading = false;
            idleTicks = 0;
            noVideoTicks = 0;
            lastT = -1;
            pendingTarget = -1;
            phonePausedByUs = false;
            pushT = -1;
            pushAt = 0;
            restoreUntil = 0;
            Log.i("MB", "onCast: sid=" + sid + " start=" + baseStart + " laengde=" + total + " undertekster=" + mode);
            if (!active) {
                active = true;
                gen++;
                H.postDelayed(new Tick(gen), 700);
                Thread t = new Thread(new Poll(gen), "castremote-poll");
                t.setDaemon(true);
                t.start();
                warned = false;
                Toast.makeText(a, "Spiller på TV – brug afspilleren i appen til at spole", Toast.LENGTH_LONG).show();
            }
        } catch (Throwable ignore) {
            // fjernbetjeningen maa aldrig vaelte appen
        }
    }

    // ----------------------------------------------------------- hjaelp

    private static RemoteMediaClient client(Context c) {
        try {
            if (c == null) return null;
            CastContext cc = CastContext.getSharedInstance(c);
            SessionManager sm = cc.getSessionManager();
            CastSession s = sm.getCurrentCastSession();
            if (s == null || !s.isConnected()) return null;
            return s.getRemoteMediaClient();
        } catch (Throwable t) {
            return null;
        }
    }

    private static WebView web() {
        try {
            java.lang.reflect.Field f = act.getClass().getDeclaredField("web");
            f.setAccessible(true);
            return (WebView) f.get(act);
        } catch (Throwable t) {
            return null;
        }
    }

    private static void js(String code, ValueCallback cb) {
        try {
            WebView w = web();
            if (w != null) w.evaluateJavascript(code, cb);
        } catch (Throwable ignore) {
            // ok
        }
    }

    private static double position() {
        RemoteMediaClient c = client(act);
        if (c == null) return baseStart;
        return baseStart + c.getApproximateStreamPosition() / 1000.0;
    }

    private static double length(RemoteMediaClient c) {
        if (total > 60) return total;
        double d = 0;
        try {
            d = c.getStreamDuration() / 1000.0;
        } catch (Throwable ignore) {
            d = 0;
        }
        return baseStart + Math.max(d, converted);
    }

    static void hide(boolean restore) {
        active = false;
        gen++;
        H.removeCallbacks(RESTART);
        if (restore) {
            restoreUntil = SystemClock.elapsedRealtime() + 1200;
            js(JS_RESTORE, null);
        }
    }

    // ------------------------------------------------------- handlinger

    static void seekTo(double target) {
        try {
            RemoteMediaClient c = client(act);
            if (c == null) return;
            double len = length(c);
            if (len > 0) target = Math.min(target, Math.max(0, len - 5));
            target = Math.max(0, target);
            double rel = target - baseStart;
            if (rel >= 0 && rel <= converted - 8) {
                c.seek((long) (rel * 1000));
            } else {
                restart(target);
            }
        } catch (Throwable ignore) {
            // ok
        }
    }

    private static final Runnable RESTART = new RestartJob();

    private static final class RestartJob implements Runnable {
        @Override
        public void run() {
            restart(phoneSec > 0 ? phoneSec : position());
        }
    }

    /** Beder X280 om at starte forfra et andet sted (eller med andre undertekster) og sender til TV. */
    static void restart(double target) {
        try {
            if (act == null || loading) return;
            loading = true;
            Log.i("MB", "genstarter TV ved " + target + " sek (undertekster=" + mode + ")");
            // telefonens afspiller staar stille mens TV'et henter, saa de ikke driver fra hinanden
            if (!lastPaused) {
                phonePausedByUs = true;
                js(JS_PAUSE, null);
            }
            Bridge.pendingRestart = true;
            Bridge.pendingStart = target;
            if (mode.equals("off")) {
                Bridge.pendingSubtrack = "off";
                Bridge.pendingSubs = "";
            } else if (mode.equals("app")) {
                Bridge.pendingSubtrack = "";
                Bridge.pendingSubs = subsText == null ? "" : subsText;
            } else {
                Bridge.pendingSubtrack = mode.substring(2);
                Bridge.pendingSubs = "";
            }
            String src = CastProxy.lastSource();
            if (src == null || src.length() == 0) {
                loading = false;
                finishLoad(false);
                return;
            }
            CastLoadSub.load(act, src, "Stream", "", new LoadDone());
        } catch (Throwable t) {
            loading = false;
            finishLoad(false);
        }
    }

    private static void finishLoad(boolean ok) {
        lastT = -1;               // naeste maaling starter forfra
        if (phonePausedByUs) {
            phonePausedByUs = false;
            js(JS_PLAY, null);
        }
    }

    private static final class LoadDone implements CastHelper.Result {
        @Override
        public void onResult(boolean ok, String msg) {
            loading = false;
            Log.i("MB", "genstart klaar: ok=" + ok + (ok ? "" : " (" + msg + ")"));
            if (ok) {
                sid = Bridge.lastId;
                baseStart = Bridge.lastStart;
                if (Bridge.lastDuration > 60) total = Bridge.lastDuration;
                converted = 0;
            } else {
                try {
                    if (act != null) Toast.makeText(act, "Kunne ikke spole: " + msg, Toast.LENGTH_LONG).show();
                } catch (Throwable ignore) {
                    // ok
                }
            }
            finishLoad(ok);
        }
    }

    // ---------------------------------------------------------- maaling

    /**
     * Bruger foerst tilstanden skubbet fra Frames-motoren (hvis den er ny, under 2,6 sek),
     * ellers svaret fra JS-walkeren i hovedraemmen.
     */
    private static final class Sample implements ValueCallback {
        private final long g;

        Sample(long g) {
            this.g = g;
        }

        @Override
        public void onReceiveValue(Object o0) {
            try {
                if (g != gen || !active) return;
                long now = SystemClock.elapsedRealtime();
                String raw = o0 == null ? null : o0.toString();
                String s = raw == null ? "" : raw.replace("\"", "").trim();

                long t = -1;
                boolean paused = false;
                boolean present = false;
                if (pushAt > 0 && now - pushAt < 2600 && pushT >= 0) {
                    // motoren i raemmerne har nyere tal end hovedraemmens walker
                    t = pushT;
                    paused = pushPaused;
                    present = true;
                    noVideoTicks = 0;
                }
                if (!present) {
                    if (s.length() == 0 || s.equals("null")) {
                        if (++noVideoTicks == 12 && !warned) {
                            warned = true;
                            Toast.makeText(act, "Kunne ikke finde afspilleren på siden – spoling fra telefonen er ikke mulig her",
                                    Toast.LENGTH_LONG).show();
                        }
                        return;
                    }
                    noVideoTicks = 0;
                    String[] p = s.split(",");
                    if (p.length < 2) return;
                    t = Long.parseLong(p[0]);
                    paused = p[1].equals("1");
                }
                phoneSec = t / 1000.0;
                if (loading) {
                    lastT = -1;
                    return;
                }
                if (lastT < 0) {
                    // foerste maaling: start TV'et der hvor telefonen er
                    lastT = t;
                    lastWall = now;
                    lastPaused = paused;
                    if (Math.abs(phoneSec - position()) > 20) {
                        seekTo(phoneSec);
                    }
                    RemoteMediaClient c0 = client(act);
                    if (c0 != null && paused != !c0.isPlaying()) {
                        if (paused) c0.pause();
                        else c0.play();
                    }
                    return;
                }
                long expected = lastT + (lastPaused ? 0 : (now - lastWall));
                if (Math.abs(t - expected) > 3000) {
                    pendingTarget = t / 1000.0;      // brugeren har spolet i appens afspiller
                    pendingAt = now + 700;
                }
                if (paused != lastPaused) {
                    RemoteMediaClient c = client(act);
                    if (c != null) {
                        if (paused) c.pause();
                        else c.play();
                    }
                }
                lastT = t;
                lastWall = now;
                lastPaused = paused;
                if (pendingTarget >= 0 && now >= pendingAt) {
                    double tg = pendingTarget;
                    pendingTarget = -1;
                    seekTo(tg);
                }
            } catch (Throwable ignore) {
                // ok
            }
        }
    }

    private static final class Tick implements Runnable {
        private final long g;

        Tick(long g) {
            this.g = g;
        }

        @Override
        public void run() {
            if (g != gen || !active) return;
            try {
                if (act == null) {
                    hide(false);
                    return;
                }
                RemoteMediaClient c = client(act);
                if (act.isFinishing() || act.isDestroyed()) {
                    // forlader man afspilleren, stopper TV'et ogsaa
                    if (c != null) c.stop();
                    hide(false);
                    return;
                }
                if (c == null || !c.hasMediaSession()) {
                    if (++idleTicks > 24 && !loading) {
                        hide(true);       // TV'et er sluttet / forbindelsen er vaek -> appen faar lyd og billede igen
                        return;
                    }
                } else {
                    idleTicks = 0;
                }
                js(JS_READ, new Sample(g));
            } catch (Throwable ignore) {
                // ok
            }
            H.postDelayed(this, 500);
        }
    }

    private static final class Poll implements Runnable {
        private final long g;

        Poll(long g) {
            this.g = g;
        }

        @Override
        public void run() {
            while (active && g == gen) {
                try {
                    JSONObject o = Bridge.progress(sid);
                    if (o != null) {
                        converted = o.optDouble("seconds", 0);
                        double d = o.optDouble("duration", 0);
                        if (d > 60) total = d;
                    }
                    Thread.sleep(2500);
                } catch (InterruptedException e) {
                    return;
                } catch (Throwable ignore) {
                    // proev igen
                }
            }
        }
    }
}
