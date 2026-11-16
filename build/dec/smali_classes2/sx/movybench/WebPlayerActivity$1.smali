.class Lsx/movybench/WebPlayerActivity$1;
.super Ljava/lang/Object;
.source "WebPlayerActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/WebPlayerActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lsx/movybench/WebPlayerActivity;


# direct methods
.method public static synthetic $r8$lambda$zoLTmc-UkLeYv6mvS8EUCbQFQnY(Lsx/movybench/WebPlayerActivity$1;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity$1;->lambda$run$0(Ljava/lang/String;)V

    return-void
.end method

.method constructor <init>(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    .line 77
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity$1;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private synthetic lambda$run$0(Ljava/lang/String;)V
    .locals 2

    if-eqz p1, :cond_1

    .line 81
    const-string v0, "null"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 83
    :cond_0
    :try_start_0
    const-string v0, "\""

    const-string v1, ""

    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v0

    .line 84
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$1;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetoverlay(Lsx/movybench/WebPlayerActivity;)Lsx/movybench/SubtitleOverlay;

    move-result-object p1

    double-to-long v0, v0

    invoke-virtual {p1, v0, v1}, Lsx/movybench/SubtitleOverlay;->render(J)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 79
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$1;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetoverlay(Lsx/movybench/WebPlayerActivity;)Lsx/movybench/SubtitleOverlay;

    move-result-object v0

    invoke-virtual {v0}, Lsx/movybench/SubtitleOverlay;->active()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 80
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$1;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetweb(Lsx/movybench/WebPlayerActivity;)Landroid/webkit/WebView;

    move-result-object v0

    new-instance v1, Lsx/movybench/WebPlayerActivity$1$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lsx/movybench/WebPlayerActivity$1$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/WebPlayerActivity$1;)V

    const-string v2, "(function(){var v=document.querySelector(\'video\');return v?Math.round(v.currentTime*1000):-1})()"

    invoke-virtual {v0, v2, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 88
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$1;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetui(Lsx/movybench/WebPlayerActivity;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0xfa

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
