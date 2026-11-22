"""Writes the compile-only stubs used by friends/build.sh.

The stubs only let javac compile the new Friends classes. They are never
dexed: on the phone the real Google Cast SDK and app classes are used.
Every signature here was checked against the smali of MovieBench_Friends 1.12.
Constants are deliberately NOT stubbed (javac would inline wrong values).
"""
import os
import sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), "..", "stubs")

STUBS = {
    "com/google/android/gms/cast/MediaInfo.java": """
package com.google.android.gms.cast;
public class MediaInfo {
  public java.util.List getMediaTracks() { return null; }
  public static class Builder {
    public Builder(String u) { }
    public Builder setStreamType(int t) { return this; }
    public Builder setContentType(String c) { return this; }
    public Builder setMetadata(MediaMetadata m) { return this; }
    public Builder setMediaTracks(java.util.List t) { return this; }
    public Builder setTextTrackStyle(TextTrackStyle s) { return this; }
    public MediaInfo build() { return null; }
  }
}
""",
    "com/google/android/gms/cast/MediaLoadRequestData.java": """
package com.google.android.gms.cast;
public class MediaLoadRequestData {
  public static class Builder {
    public Builder() { }
    public Builder setMediaInfo(MediaInfo i) { return this; }
    public Builder setAutoplay(Boolean a) { return this; }
    public Builder setActiveTrackIds(long[] ids) { return this; }
    public Builder setCurrentTime(long ms) { return this; }
    public MediaLoadRequestData build() { return null; }
  }
}
""",
    "com/google/android/gms/cast/MediaMetadata.java": """
package com.google.android.gms.cast;
public class MediaMetadata {
  public MediaMetadata(int type) { }
  public void putString(String key, String value) { }
}
""",
    "com/google/android/gms/cast/MediaTrack.java": """
package com.google.android.gms.cast;
public class MediaTrack {
  public static class Builder {
    public Builder(long id, int type) { }
    public Builder setName(String n) { return this; }
    public Builder setLanguage(String l) { return this; }
    public Builder setSubtype(int s) { return this; }
    public Builder setContentId(String c) { return this; }
    public Builder setContentType(String c) { return this; }
    public MediaTrack build() { return null; }
  }
}
""",
    "com/google/android/gms/cast/TextTrackStyle.java": """
package com.google.android.gms.cast;
public class TextTrackStyle {
  public TextTrackStyle() { }
  public void setFontScale(float f) { }
  public void setForegroundColor(int c) { }
  public void setBackgroundColor(int c) { }
  public void setEdgeType(int t) { }
  public void setEdgeColor(int c) { }
  public void setWindowType(int t) { }
}
""",
    "com/google/android/gms/cast/MediaStatus.java": """
package com.google.android.gms.cast;
public class MediaStatus {
  public int getPlayerState() { return 0; }
  public int getIdleReason() { return 0; }
}
""",
    "com/google/android/gms/cast/MediaError.java": """
package com.google.android.gms.cast;
public class MediaError {
  public Integer getDetailedErrorCode() { return null; }
  public String getReason() { return null; }
}
""",
    "com/google/android/gms/cast/framework/CastContext.java": """
package com.google.android.gms.cast.framework;
public class CastContext {
  public static CastContext getSharedInstance(android.content.Context c) { return null; }
  public SessionManager getSessionManager() { return null; }
}
""",
    "com/google/android/gms/cast/framework/SessionManager.java": """
package com.google.android.gms.cast.framework;
public class SessionManager { public CastSession getCurrentCastSession() { return null; } }
""",
    "com/google/android/gms/cast/framework/CastSession.java": """
package com.google.android.gms.cast.framework;
public class CastSession {
  public boolean isConnected() { return false; }
  public com.google.android.gms.cast.framework.media.RemoteMediaClient getRemoteMediaClient() { return null; }
}
""",
    "com/google/android/gms/cast/framework/media/RemoteMediaClient.java": """
package com.google.android.gms.cast.framework.media;
import com.google.android.gms.common.api.PendingResult;
public class RemoteMediaClient {
  public interface MediaChannelResult extends com.google.android.gms.common.api.Result { }
  public abstract static class Callback {
    public Callback() { }
    public void onStatusUpdated() { }
    public void onMediaError(com.google.android.gms.cast.MediaError e) { }
  }
  public PendingResult load(com.google.android.gms.cast.MediaLoadRequestData r) { return null; }
  public PendingResult setActiveMediaTracks(long[] ids) { return null; }
  public boolean hasMediaSession() { return false; }
  public long getApproximateStreamPosition() { return 0; }
  public com.google.android.gms.cast.MediaInfo getMediaInfo() { return null; }
  public com.google.android.gms.cast.MediaStatus getMediaStatus() { return null; }
  public void registerCallback(Callback c) { }
  public void unregisterCallback(Callback c) { }
}
""",
    "com/google/android/gms/common/api/PendingResult.java": """
package com.google.android.gms.common.api;
public abstract class PendingResult<R extends Result> {
  public abstract void setResultCallback(ResultCallback<? super R> r);
}
""",
    "com/google/android/gms/common/api/Result.java": """
package com.google.android.gms.common.api;
public interface Result { Status getStatus(); }
""",
    "com/google/android/gms/common/api/ResultCallback.java": """
package com.google.android.gms.common.api;
public interface ResultCallback<R extends Result> { void onResult(R r); }
""",
    "com/google/android/gms/common/api/Status.java": """
package com.google.android.gms.common.api;
public final class Status implements Result {
  public Status getStatus() { return this; }
  public boolean isSuccess() { return false; }
  public int getStatusCode() { return 0; }
  public String getStatusMessage() { return null; }
}
""",
    "sx/movybench/CastHelper.java": """
package sx.movybench;
public final class CastHelper {
  public interface Result { void onResult(boolean ok, String msg); }
  static String contentType(String u) { return null; }
  public static void loadLegacy(android.content.Context c, String u, String t, String s, Result r) { }
}
""",
    "sx/movybench/CastFlow.java": """
package sx.movybench;
public class CastFlow { static boolean friends(android.content.Context c) { return false; } }
""",
    "sx/movybench/CastProxy.java": """
package sx.movybench;
public final class CastProxy {
  public static synchronized String wrap(android.content.Context c, String u) { return null; }
  static String localIp() { return null; }
  static String lastSource() { return null; }
}
""",
    "sx/movybench/CastRemote.java": """
package sx.movybench;
public final class CastRemote { static String subs() { return null; } }
""",
    "sx/movybench/CcMenu.java": """
package sx.movybench;
public final class CcMenu { static String mode() { return null; } static double offsetSeconds() { return 0; } }
""",
    "sx/movybench/Bridge.java": """
package sx.movybench;
public final class Bridge { public static volatile boolean pendingRestart; public static volatile double pendingStart; }
""",
    "sx/movybench/sub/Srt.java": """
package sx.movybench.sub;
public final class Srt {
  public static java.util.List cues(String s) { return null; }
  public static final class Cue {
    public final long start; public final long end; public final String text;
    Cue() { start = 0; end = 0; text = null; }
  }
}
""",
}

for rel, body in STUBS.items():
    path = os.path.join(ROOT, rel)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(body.lstrip())
print("stubs: %d files -> %s" % (len(STUBS), os.path.abspath(ROOT)))
