package sx.movybench;
public final class CastHelper {
  public interface Result { void onResult(boolean ok, String msg); }
  public static void load(android.content.Context c, String u, String t, String s, Result r) {}
}
