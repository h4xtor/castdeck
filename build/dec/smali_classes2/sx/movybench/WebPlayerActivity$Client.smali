.class Lsx/movybench/WebPlayerActivity$Client;
.super Landroid/webkit/WebViewClient;
.source "WebPlayerActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/WebPlayerActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Client"
.end annotation


# instance fields
.field final synthetic this$0:Lsx/movybench/WebPlayerActivity;


# direct methods
.method private constructor <init>(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    .line 278
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/WebPlayerActivity-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity$Client;-><init>(Lsx/movybench/WebPlayerActivity;)V

    return-void
.end method

.method static synthetic lambda$onPageFinished$0(Landroid/webkit/WebView;)V
    .locals 2

    .line 310
    const-string v0, "(function(){\n  window.__mbTitle = function(){\n    var og = document.querySelector(\'meta[property=\"og:title\"]\');\n    var h1 = document.querySelector(\'h1\');\n    return [\n      document.title || \'\',\n      location.href || \'\',\n      og ? (og.getAttribute(\'content\') || \'\') : \'\',\n      h1 ? (h1.innerText || \'\') : \'\'\n    ];\n  };\n  if (window.__mbHook) return; window.__mbHook = 1;\n  function send(u){\n    try {\n      if (!u || typeof u !== \'string\') return;\n      if (/^(blob:|data:|about:)/.test(u)) return;\n      MB.media(u, document.title || \'\', location.href || \'\');\n    } catch(e){}\n  }\n  try {\n    var d = Object.getOwnPropertyDescriptor(HTMLMediaElement.prototype, \'src\');\n    if (d && d.set) {\n      Object.defineProperty(HTMLMediaElement.prototype, \'src\', {\n        configurable: true, get: d.get,\n        set: function(v){ send(v); return d.set.call(this, v); }\n      });\n    }\n  } catch(e){}\n  try {\n    var p = HTMLMediaElement.prototype.play;\n    HTMLMediaElement.prototype.play = function(){\n      send(this.currentSrc || this.src || \'\');\n      return p.apply(this, arguments);\n    };\n  } catch(e){}\n  document.addEventListener(\'play\', function(e){\n    var t = e.target;\n    if (t && t.tagName === \'VIDEO\') send(t.currentSrc || t.src || \'\');\n  }, true);\n  try {\n    if (window.fetch) {\n      var f = window.fetch;\n      window.fetch = function(a,b){\n        try { send(typeof a === \'string\' ? a : (a && a.url) || \'\'); } catch(e){}\n        return f.apply(this, arguments);\n      };\n    }\n  } catch(e){}\n  try {\n    var xo = XMLHttpRequest.prototype.open;\n    XMLHttpRequest.prototype.open = function(m,u){\n      try { send(u); } catch(e){}\n      return xo.apply(this, arguments);\n    };\n  } catch(e){}\n})();\n"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method

.method static synthetic lambda$onPageFinished$1(Landroid/webkit/WebView;)V
    .locals 2

    .line 311
    const-string v0, "(function(){\n  window.__mbTitle = function(){\n    var og = document.querySelector(\'meta[property=\"og:title\"]\');\n    var h1 = document.querySelector(\'h1\');\n    return [\n      document.title || \'\',\n      location.href || \'\',\n      og ? (og.getAttribute(\'content\') || \'\') : \'\',\n      h1 ? (h1.innerText || \'\') : \'\'\n    ];\n  };\n  if (window.__mbHook) return; window.__mbHook = 1;\n  function send(u){\n    try {\n      if (!u || typeof u !== \'string\') return;\n      if (/^(blob:|data:|about:)/.test(u)) return;\n      MB.media(u, document.title || \'\', location.href || \'\');\n    } catch(e){}\n  }\n  try {\n    var d = Object.getOwnPropertyDescriptor(HTMLMediaElement.prototype, \'src\');\n    if (d && d.set) {\n      Object.defineProperty(HTMLMediaElement.prototype, \'src\', {\n        configurable: true, get: d.get,\n        set: function(v){ send(v); return d.set.call(this, v); }\n      });\n    }\n  } catch(e){}\n  try {\n    var p = HTMLMediaElement.prototype.play;\n    HTMLMediaElement.prototype.play = function(){\n      send(this.currentSrc || this.src || \'\');\n      return p.apply(this, arguments);\n    };\n  } catch(e){}\n  document.addEventListener(\'play\', function(e){\n    var t = e.target;\n    if (t && t.tagName === \'VIDEO\') send(t.currentSrc || t.src || \'\');\n  }, true);\n  try {\n    if (window.fetch) {\n      var f = window.fetch;\n      window.fetch = function(a,b){\n        try { send(typeof a === \'string\' ? a : (a && a.url) || \'\'); } catch(e){}\n        return f.apply(this, arguments);\n      };\n    }\n  } catch(e){}\n  try {\n    var xo = XMLHttpRequest.prototype.open;\n    XMLHttpRequest.prototype.open = function(m,u){\n      try { send(u); } catch(e){}\n      return xo.apply(this, arguments);\n    };\n  } catch(e){}\n})();\n"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method


# virtual methods
.method public onLoadResource(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 1

    .line 298
    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$smlooksLikeMedia(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    const-string v0, ""

    invoke-static {p1, p2, v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mpostMedia(Lsx/movybench/WebPlayerActivity;Ljava/lang/String;Ljava/lang/String;)V

    :cond_0
    return-void
.end method

.method public onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 3

    .line 306
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetprogress(Lsx/movybench/WebPlayerActivity;)Landroid/widget/ProgressBar;

    move-result-object p2

    const/16 v0, 0x8

    invoke-virtual {p2, v0}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 307
    const-string p2, "(function(){\n  window.__mbTitle = function(){\n    var og = document.querySelector(\'meta[property=\"og:title\"]\');\n    var h1 = document.querySelector(\'h1\');\n    return [\n      document.title || \'\',\n      location.href || \'\',\n      og ? (og.getAttribute(\'content\') || \'\') : \'\',\n      h1 ? (h1.innerText || \'\') : \'\'\n    ];\n  };\n  if (window.__mbHook) return; window.__mbHook = 1;\n  function send(u){\n    try {\n      if (!u || typeof u !== \'string\') return;\n      if (/^(blob:|data:|about:)/.test(u)) return;\n      MB.media(u, document.title || \'\', location.href || \'\');\n    } catch(e){}\n  }\n  try {\n    var d = Object.getOwnPropertyDescriptor(HTMLMediaElement.prototype, \'src\');\n    if (d && d.set) {\n      Object.defineProperty(HTMLMediaElement.prototype, \'src\', {\n        configurable: true, get: d.get,\n        set: function(v){ send(v); return d.set.call(this, v); }\n      });\n    }\n  } catch(e){}\n  try {\n    var p = HTMLMediaElement.prototype.play;\n    HTMLMediaElement.prototype.play = function(){\n      send(this.currentSrc || this.src || \'\');\n      return p.apply(this, arguments);\n    };\n  } catch(e){}\n  document.addEventListener(\'play\', function(e){\n    var t = e.target;\n    if (t && t.tagName === \'VIDEO\') send(t.currentSrc || t.src || \'\');\n  }, true);\n  try {\n    if (window.fetch) {\n      var f = window.fetch;\n      window.fetch = function(a,b){\n        try { send(typeof a === \'string\' ? a : (a && a.url) || \'\'); } catch(e){}\n        return f.apply(this, arguments);\n      };\n    }\n  } catch(e){}\n  try {\n    var xo = XMLHttpRequest.prototype.open;\n    XMLHttpRequest.prototype.open = function(m,u){\n      try { send(u); } catch(e){}\n      return xo.apply(this, arguments);\n    };\n  } catch(e){}\n})();\n"

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 308
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/Prefs;->autoNext(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_0

    const-string p2, "(function(){\n  if (window.__mbNext) return; window.__mbNext = 1;\n  document.addEventListener(\'ended\', function(e){\n    var t = e.target;\n    if (!t || t.tagName !== \'VIDEO\') return;\n    var nodes = document.querySelectorAll(\'a,button\');\n    for (var i = 0; i < nodes.length; i++) {\n      var n = nodes[i];\n      var s = ((n.innerText || \'\') + \' \' + (n.getAttribute(\'title\') || \'\') + \' \'\n              + (n.getAttribute(\'aria-label\') || \'\') + \' \' + (n.className || \'\')).toLowerCase();\n      if (/\\bnext episode\\b|\\bnext\\b|n\u00e6ste afsnit|n\u00e6ste|naeste/.test(s)) {\n        n.click();\n        try { MB.toast(\'Auto-next: n\u00e6ste afsnit\'); } catch(x){}\n        return;\n      }\n    }\n    try { MB.nextMissing(); } catch(x){}\n  }, true);\n})();\n"

    invoke-virtual {p1, p2, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 309
    :cond_0
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetoverlay(Lsx/movybench/WebPlayerActivity;)Lsx/movybench/SubtitleOverlay;

    move-result-object p2

    invoke-virtual {p2}, Lsx/movybench/SubtitleOverlay;->active()Z

    move-result p2

    if-eqz p2, :cond_1

    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mstartPump(Lsx/movybench/WebPlayerActivity;)V

    .line 310
    :cond_1
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetui(Lsx/movybench/WebPlayerActivity;)Landroid/os/Handler;

    move-result-object p2

    new-instance v0, Lsx/movybench/WebPlayerActivity$Client$$ExternalSyntheticLambda0;

    invoke-direct {v0, p1}, Lsx/movybench/WebPlayerActivity$Client$$ExternalSyntheticLambda0;-><init>(Landroid/webkit/WebView;)V

    const-wide/16 v1, 0x5dc

    invoke-virtual {p2, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 311
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetui(Lsx/movybench/WebPlayerActivity;)Landroid/os/Handler;

    move-result-object p2

    new-instance v0, Lsx/movybench/WebPlayerActivity$Client$$ExternalSyntheticLambda1;

    invoke-direct {v0, p1}, Lsx/movybench/WebPlayerActivity$Client$$ExternalSyntheticLambda1;-><init>(Landroid/webkit/WebView;)V

    const-wide/16 v1, 0xfa0

    invoke-virtual {p2, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method public onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .locals 0

    .line 302
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetprogress(Lsx/movybench/WebPlayerActivity;)Landroid/widget/ProgressBar;

    move-result-object p1

    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Landroid/widget/ProgressBar;->setVisibility(I)V

    return-void
.end method

.method public shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .locals 2

    invoke-static {p2}, Lsx/movybench/CastProxy;->note(Landroid/webkit/WebResourceRequest;)V

    invoke-static {p2}, Lsx/movybench/Frames;->intercept(Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;

    move-result-object v0

    if-eqz v0, :cond_frame

    return-object v0

    :cond_frame
    .line 289
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p1

    .line 290
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/Prefs;->blockAds(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_0

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$smisAd(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_0

    .line 291
    new-instance p1, Landroid/webkit/WebResourceResponse;

    new-instance p2, Ljava/io/ByteArrayInputStream;

    const/4 v0, 0x0

    new-array v0, v0, [B

    invoke-direct {p2, v0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    const-string v0, "text/plain"

    const-string v1, "utf-8"

    invoke-direct {p1, v0, v1, p2}, Landroid/webkit/WebResourceResponse;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/io/InputStream;)V

    return-object p1

    .line 293
    :cond_0
    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$smlooksLikeMedia(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_1

    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    const-string v0, ""

    invoke-static {p2, p1, v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mpostMedia(Lsx/movybench/WebPlayerActivity;Ljava/lang/String;Ljava/lang/String;)V

    :cond_1
    const/4 p1, 0x0

    return-object p1
.end method

.method public shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 1

    .line 280
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p1

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p1

    .line 281
    const-string p2, "intent:"

    invoke-virtual {p1, p2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    const/4 v0, 0x0

    if-nez p2, :cond_1

    const-string p2, "market:"

    invoke-virtual {p1, p2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_1

    const-string p2, "tg:"

    invoke-virtual {p1, p2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_0

    goto :goto_0

    :cond_0
    return v0

    .line 282
    :cond_1
    :goto_0
    :try_start_0
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Client;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1, v0}, Landroid/content/Intent;->parseUri(Ljava/lang/String;I)Landroid/content/Intent;

    move-result-object p1

    invoke-virtual {p2, p1}, Lsx/movybench/WebPlayerActivity;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 p1, 0x1

    return p1
.end method
