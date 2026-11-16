package com.google.android.gms.cast;
public class MediaLoadRequestData {
  public static class Builder {
    public Builder setMediaInfo(MediaInfo i) { return this; }
    public Builder setAutoplay(Boolean a) { return this; }
    public Builder setActiveTrackIds(long[] ids) { return this; }
    public MediaLoadRequestData build() { return new MediaLoadRequestData(); }
  }
}
