package com.google.android.gms.cast.framework.media;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;
public class RemoteMediaClient {
  public PendingResult seek(long p) { return null; }
  public PendingResult pause() { return null; }
  public PendingResult play() { return null; }
  public PendingResult stop() { return null; }
  public PendingResult load(com.google.android.gms.cast.MediaLoadRequestData r) { return null; }
  public PendingResult setActiveMediaTracks(long[] ids) { return null; }
  public boolean hasMediaSession() { return false; }
  public long getApproximateStreamPosition() { return 0; }
  public long getStreamDuration() { return 0; }
  public com.google.android.gms.cast.MediaInfo getMediaInfo() { return null; }
  public int getPlayerState() { return 0; }
  public boolean isPlaying() { return false; }
}
