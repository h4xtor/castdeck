.class public final Lsx/movybench/Inject;
.super Ljava/lang/Object;
.source "Inject.java"


# static fields
.field public static final AUTONEXT:Ljava/lang/String; = "(function(){\n  if (window.__mbNext) return; window.__mbNext = 1;\n  document.addEventListener(\'ended\', function(e){\n    var t = e.target;\n    if (!t || t.tagName !== \'VIDEO\') return;\n    var nodes = document.querySelectorAll(\'a,button\');\n    for (var i = 0; i < nodes.length; i++) {\n      var n = nodes[i];\n      var s = ((n.innerText || \'\') + \' \' + (n.getAttribute(\'title\') || \'\') + \' \'\n              + (n.getAttribute(\'aria-label\') || \'\') + \' \' + (n.className || \'\')).toLowerCase();\n      if (/\\bnext episode\\b|\\bnext\\b|n\u00e6ste afsnit|n\u00e6ste|naeste/.test(s)) {\n        n.click();\n        try { MB.toast(\'Auto-next: n\u00e6ste afsnit\'); } catch(x){}\n        return;\n      }\n    }\n    try { MB.nextMissing(); } catch(x){}\n  }, true);\n})();\n"

.field public static final SNIFF:Ljava/lang/String; = "(function(){\n  window.__mbTitle = function(){\n    var og = document.querySelector(\'meta[property=\"og:title\"]\');\n    var h1 = document.querySelector(\'h1\');\n    return [\n      document.title || \'\',\n      location.href || \'\',\n      og ? (og.getAttribute(\'content\') || \'\') : \'\',\n      h1 ? (h1.innerText || \'\') : \'\'\n    ];\n  };\n  if (window.__mbHook) return; window.__mbHook = 1;\n  function send(u){\n    try {\n      if (!u || typeof u !== \'string\') return;\n      if (/^(blob:|data:|about:)/.test(u)) return;\n      MB.media(u, document.title || \'\', location.href || \'\');\n    } catch(e){}\n  }\n  try {\n    var d = Object.getOwnPropertyDescriptor(HTMLMediaElement.prototype, \'src\');\n    if (d && d.set) {\n      Object.defineProperty(HTMLMediaElement.prototype, \'src\', {\n        configurable: true, get: d.get,\n        set: function(v){ send(v); return d.set.call(this, v); }\n      });\n    }\n  } catch(e){}\n  try {\n    var p = HTMLMediaElement.prototype.play;\n    HTMLMediaElement.prototype.play = function(){\n      send(this.currentSrc || this.src || \'\');\n      return p.apply(this, arguments);\n    };\n  } catch(e){}\n  document.addEventListener(\'play\', function(e){\n    var t = e.target;\n    if (t && t.tagName === \'VIDEO\') send(t.currentSrc || t.src || \'\');\n  }, true);\n  try {\n    if (window.fetch) {\n      var f = window.fetch;\n      window.fetch = function(a,b){\n        try { send(typeof a === \'string\' ? a : (a && a.url) || \'\'); } catch(e){}\n        return f.apply(this, arguments);\n      };\n    }\n  } catch(e){}\n  try {\n    var xo = XMLHttpRequest.prototype.open;\n    XMLHttpRequest.prototype.open = function(m,u){\n      try { send(u); } catch(e){}\n      return xo.apply(this, arguments);\n    };\n  } catch(e){}\n})();\n"

.field public static final TIME:Ljava/lang/String; = "(function(){var v=document.querySelector(\'video\');return v?Math.round(v.currentTime*1000):-1})()"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
