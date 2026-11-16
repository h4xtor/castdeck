package com.google.android.gms.cast;
public class MediaInfo {
  public String getContentId() { return null; }
  public static class Builder {
    public Builder(String u) { }
    public Builder setStreamType(int t) { return this; }
    public Builder setContentType(String c) { return this; }
    public Builder setMetadata(MediaMetadata m) { return this; }
    public Builder setMediaTracks(java.util.List t) { return this; }
    public MediaInfo build() { return new MediaInfo(); }
  }
}
