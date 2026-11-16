package com.google.android.gms.cast;
public class MediaTrack {
  public static final int TYPE_TEXT = 0;
  public static final int TYPE_AUDIO = 1;
  public static final int TYPE_VIDEO = 2;
  public static final int SUBTITLE_TYPE_SUBTITLES = 3;
  public long getId() { return 0L; }
  public int getType() { return 0; }
  public String getContentId() { return null; }
  public static class Builder {
    public Builder(long id, int type) { }
    public Builder setName(String n) { return this; }
    public Builder setLanguage(String l) { return this; }
    public Builder setSubtype(int s) { return this; }
    public Builder setContentId(String c) { return this; }
    public MediaTrack build() { return new MediaTrack(); }
  }
}
