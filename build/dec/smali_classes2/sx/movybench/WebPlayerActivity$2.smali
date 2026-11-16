.class Lsx/movybench/WebPlayerActivity$2;
.super Landroidx/activity/OnBackPressedCallback;
.source "WebPlayerActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lsx/movybench/WebPlayerActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lsx/movybench/WebPlayerActivity;


# direct methods
.method constructor <init>(Lsx/movybench/WebPlayerActivity;Z)V
    .locals 0

    .line 154
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity$2;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-direct {p0, p2}, Landroidx/activity/OnBackPressedCallback;-><init>(Z)V

    return-void
.end method


# virtual methods
.method public handleOnBackPressed()V
    .locals 1

    .line 156
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$2;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetcustomView(Lsx/movybench/WebPlayerActivity;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$2;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mhideFullscreen(Lsx/movybench/WebPlayerActivity;)V

    return-void

    .line 157
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$2;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetweb(Lsx/movybench/WebPlayerActivity;)Landroid/webkit/WebView;

    move-result-object v0

    invoke-virtual {v0}, Landroid/webkit/WebView;->canGoBack()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$2;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetweb(Lsx/movybench/WebPlayerActivity;)Landroid/webkit/WebView;

    move-result-object v0

    invoke-virtual {v0}, Landroid/webkit/WebView;->goBack()V

    return-void

    .line 158
    :cond_1
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$2;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-virtual {v0}, Lsx/movybench/WebPlayerActivity;->finish()V

    return-void
.end method
