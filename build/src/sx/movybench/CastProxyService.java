package sx.movybench;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.PowerManager;

/**
 * Holder mellemmanden i live i baggrunden, mens telefonen sender til TV'et
 * (ogsaa med skaermen slukket). Stopper selv efter 3 timers stilhed.
 */
public class CastProxyService extends Service {

    private static final class Checker implements Runnable {
        private final CastProxyService svc;

        Checker(CastProxyService svc) {
            this.svc = svc;
        }

        @Override
        public void run() {
            if (!CastProxy.isRunning() || CastProxy.idleMillis() > IDLE_LIMIT_MS) {
                svc.stopSelf();
                return;
            }
            svc.handler.postDelayed(this, 60000L);
        }
    }


    private static final String CHANNEL = "castproxy";
    private static final int NOTIF_ID = 4717;
    private static final long IDLE_LIMIT_MS = 3L * 60L * 60L * 1000L;

    private PowerManager.WakeLock wake;
    private WifiManager.WifiLock wifi;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private Checker check;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && "sx.movybench.STOP_PROXY".equals(intent.getAction())) {
            stopSelf();
            return START_NOT_STICKY;
        }
        try {
            NotificationManager nm = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            if (Build.VERSION.SDK_INT >= 26 && nm != null) {
                NotificationChannel ch = new NotificationChannel(CHANNEL, "Cast-mellemmand",
                        NotificationManager.IMPORTANCE_LOW);
                nm.createNotificationChannel(ch);
            }
            Intent stop = new Intent(this, CastProxyService.class).setAction("sx.movybench.STOP_PROXY");
            int pf = PendingIntent.FLAG_UPDATE_CURRENT | (Build.VERSION.SDK_INT >= 23 ? PendingIntent.FLAG_IMMUTABLE : 0);
            PendingIntent stopPi = PendingIntent.getService(this, 1, stop, pf);
            Notification.Builder b = Build.VERSION.SDK_INT >= 26
                    ? new Notification.Builder(this, CHANNEL)
                    : new Notification.Builder(this);
            b.setContentTitle("MovieBench sender til TV")
                    .setContentText("Mellemmanden kører i baggrunden")
                    .setSmallIcon(android.R.drawable.ic_media_play)
                    .setOngoing(true)
                    .addAction(new Notification.Action.Builder(android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopPi).build());
            Notification n = b.build();
            if (Build.VERSION.SDK_INT >= 29) {
                startForeground(NOTIF_ID, n, 2 /* FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK */);
            } else {
                startForeground(NOTIF_ID, n);
            }
        } catch (Throwable t) {
            // uden notifikation kan tjenesten ikke blive i forgrunden
            stopSelf();
            return START_NOT_STICKY;
        }
        try {
            if (wake == null) {
                PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
                wake = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "moviebench:castproxy");
                wake.setReferenceCounted(false);
            }
            if (!wake.isHeld()) wake.acquire();
            if (wifi == null) {
                WifiManager wm = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
                int mode = Build.VERSION.SDK_INT >= 29 ? 4 /* FULL_LOW_LATENCY */ : WifiManager.WIFI_MODE_FULL_HIGH_PERF;
                wifi = wm.createWifiLock(mode, "moviebench:castproxy");
                wifi.setReferenceCounted(false);
            }
            if (!wifi.isHeld()) wifi.acquire();
        } catch (Throwable ignore) {
            // locks er en bonus
        }
        if (check == null) check = new Checker(this);
        handler.removeCallbacks(check);
        handler.postDelayed(check, 60000L);
        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {
        if (check != null) handler.removeCallbacks(check);
        try {
            if (wake != null && wake.isHeld()) wake.release();
            if (wifi != null && wifi.isHeld()) wifi.release();
        } catch (Throwable ignore) {
            // ingen
        }
        CastProxy.shutdown();
        super.onDestroy();
    }
}
