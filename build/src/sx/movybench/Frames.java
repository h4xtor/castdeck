package sx.movybench;

import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import java.util.zip.GZIPInputStream;
import java.util.zip.InflaterInputStream;

/**
 * HTML-fanger: injicerer cast-motoren i ALLE HTML-sider, ogsaa cross-origin iframes
 * (WebView's evaluateJavascript naar kun hovedraemmen).
 *
 * Motoren finder <video> i iframes og shadow DOM, hjaelder og skjuler dem,
 * og melder tilstand hvert 0,5 sek via MB.tick -> CastRemote.onTick (kommando tilbage).
 * Kun selve video-elementet skjules - aldrig sidens kontrolbjaelke.
 */
public final class Frames {

    private static final long MAX_HTML = 8L * 1024 * 1024;

    private Frames() {
    }

    private static final String ENGINE =
            "(function(){"
            + "if(window.__mbEng)return;window.__mbEng=1;"
            + "function mbAll(r,out,d){try{"
            + "if(d>6||!r||!r.querySelectorAll)return;"
            + "var vs=r.querySelectorAll('video');for(var i=0;i<vs.length;i++)out.push(vs[i]);"
            + "var s=r.querySelectorAll('*');var cap=Math.min(s.length,800);"
            + "for(var i=0;i<cap;i++){var sr=null;try{sr=s[i].shadowRoot;}catch(e){}"
            + "if(sr)mbAll(sr,out,d+1);}"
            + "var fs=r.querySelectorAll('iframe');var fc=Math.min(fs.length,40);"
            + "for(var i=0;i<fc;i++){try{var dd=fs[i].contentDocument;"
            + "if(dd)mbAll(dd,out,d+1);}catch(e){}}"
            + "}catch(e){}}"
            + "function mbPick(){var out=[];mbAll(document,out,0);var best=null;"
            + "for(var i=0;i<out.length;i++){var v=out[i];"
            + "if(v.duration>0&&(!best||v.duration>best.duration))best=v;}"
            + "if(!best&&out.length)best=out[0];return best;}"
            + "function hush(v){try{v.muted=true;v.volume=0;v.style.opacity='0';}catch(e){}}"
            + "function show(v){try{v.style.opacity='';v.muted=false;v.volume=1;}catch(e){}}"
            + "setInterval(function(){try{"
            + "var v=mbPick();if(!v)return;"
            + "var cmd='';var st='{}';"
            + "try{st=JSON.stringify({t:Math.round(v.currentTime*1000),"
            + "p:v.paused?1:0,d:Math.round((v.duration||0)*1000)});}catch(e){}"
            + "try{cmd=window.MB?MB.tick(st):'';}catch(e){cmd='';}"
            + "if(cmd==='h'){hush(v);}"
            + "else if(cmd==='hp'){hush(v);try{v.pause();}catch(e){}}"
            + "else if(cmd==='h+'){hush(v);var p=v.play();if(p&&p.catch)p.catch(function(){});}"
            + "else if(cmd==='r'){show(v);}"
            + "}catch(e){}},500);"
            + "})();";

    public static WebResourceResponse intercept(WebResourceRequest req) {
        try {
            if (req == null || req.getUrl() == null) return null;
            String u = req.getUrl().toString();
            if (!isHtmlCandidate(u)) return null;
            HttpURLConnection c = (HttpURLConnection) new URL(u).openConnection();
            c.setConnectTimeout(8000);
            c.setReadTimeout(12000);
            c.setInstanceFollowRedirects(true);
            Map<String, String> hs = req.getRequestHeaders();
            if (hs != null) {
                for (Map.Entry<String, String> e : hs.entrySet()) {
                    if (e.getKey() != null && e.getValue() != null
                            && !"accept-encoding".equalsIgnoreCase(e.getKey())) {
                        c.setRequestProperty(e.getKey(), e.getValue());
                    }
                }
            }
            c.setRequestProperty("Accept-Encoding", "identity");
            int code = c.getResponseCode();
            if (code < 200 || code >= 300) return null;
            String ct = c.getContentType();
            if (ct == null || !ct.toLowerCase().contains("text/html")) return null;
            InputStream in = c.getInputStream();
            String enc = c.getContentEncoding();
            if ("gzip".equalsIgnoreCase(enc)) in = new GZIPInputStream(in);
            else if ("deflate".equalsIgnoreCase(enc)) in = new InflaterInputStream(in);
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            byte[] buf = new byte[8192];
            long tot = 0;
            int n;
            while ((n = in.read(buf)) != -1) {
                tot += n;
                if (tot > MAX_HTML) {
                    try { in.close(); } catch (Throwable ignore) { }
                    return null;
                }
                bos.write(buf, 0, n);
            }
            try { in.close(); } catch (Throwable ignore) { }
            String cs = "utf-8";
            if (ct != null) {
                int i = ct.toLowerCase().indexOf("charset=");
                if (i >= 0) {
                    cs = ct.substring(i + 8).trim();
                    int j = cs.indexOf(';');
                    if (j >= 0) cs = cs.substring(0, j).trim();
                    if (cs.length() == 0) cs = "utf-8";
                }
            }
            String html = new String(bos.toByteArray(), cs);
            String tag = "<script>" + ENGINE + "</script>";
            int p = html.toLowerCase().lastIndexOf("</body>");
            String out = p >= 0 ? html.substring(0, p) + tag + html.substring(p) : html + tag;
            return new WebResourceResponse("text/html", cs,
                    new ByteArrayInputStream(out.getBytes(cs)));
        } catch (Throwable t) {
            return null;
        }
    }

    private static boolean isHtmlCandidate(String u) {
        if (u == null || u.length() == 0) return false;
        String low = u.toLowerCase();
        if (!low.startsWith("http://") && !low.startsWith("https://")) return false;
        if (low.contains(":8097/") || low.contains(":8098/")) return false;   // vores bridge
        String path = low;
        int q = path.indexOf('?');
        if (q >= 0) path = path.substring(0, q);
        if (path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".json")
                || path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".jpeg")
                || path.endsWith(".gif") || path.endsWith(".webp") || path.endsWith(".svg")
                || path.endsWith(".ico") || path.endsWith(".m3u8") || path.endsWith(".ts")
                || path.endsWith(".m4s") || path.endsWith(".mp4") || path.endsWith(".webm")
                || path.endsWith(".vtt") || path.endsWith(".srt") || path.endsWith(".woff")
                || path.endsWith(".woff2") || path.endsWith(".ttf")) {
            return false;
        }
        return true;
    }
}
