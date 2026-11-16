.class Lsx/movybench/WebPlayerActivity$Chrome;
.super Landroid/webkit/WebChromeClient;
.source "WebPlayerActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/WebPlayerActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Chrome"
.end annotation


# instance fields
.field final synthetic this$0:Lsx/movybench/WebPlayerActivity;


# direct methods
.method private constructor <init>(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    .line 315
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-direct {p0}, Landroid/webkit/WebChromeClient;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/WebPlayerActivity-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity$Chrome;-><init>(Lsx/movybench/WebPlayerActivity;)V

    return-void
.end method


# virtual methods
.method public onHideCustomView()V
    .locals 1

    .line 333
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mhideFullscreen(Lsx/movybench/WebPlayerActivity;)V

    return-void
.end method

.method public onProgressChanged(Landroid/webkit/WebView;I)V
    .locals 1

    .line 317
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetprogress(Lsx/movybench/WebPlayerActivity;)Landroid/widget/ProgressBar;

    move-result-object p1

    const/16 v0, 0x64

    if-lt p2, v0, :cond_0

    const/16 v0, 0x8

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p1, v0}, Landroid/widget/ProgressBar;->setVisibility(I)V

    .line 318
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetprogress(Lsx/movybench/WebPlayerActivity;)Landroid/widget/ProgressBar;

    move-result-object p1

    invoke-virtual {p1, p2}, Landroid/widget/ProgressBar;->setProgress(I)V

    return-void
.end method

.method public onShowCustomView(Landroid/view/View;Landroid/webkit/WebChromeClient$CustomViewCallback;)V
    .locals 2

    .line 322
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetcustomView(Lsx/movybench/WebPlayerActivity;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-interface {p2}, Landroid/webkit/WebChromeClient$CustomViewCallback;->onCustomViewHidden()V

    return-void

    .line 323
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0, p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fputcustomView(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V

    .line 324
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0, p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fputfsCallback(Lsx/movybench/WebPlayerActivity;Landroid/webkit/WebChromeClient$CustomViewCallback;)V

    .line 325
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetfsHost(Lsx/movybench/WebPlayerActivity;)Landroid/widget/FrameLayout;

    move-result-object p2

    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, -0x1

    invoke-direct {v0, v1, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p2, p1, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 327
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetfsRoot(Lsx/movybench/WebPlayerActivity;)Landroid/widget/FrameLayout;

    move-result-object p1

    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 328
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetchromeBar(Lsx/movybench/WebPlayerActivity;)Landroid/view/View;

    move-result-object p1

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/view/View;->setVisibility(I)V

    .line 329
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-virtual {p1}, Lsx/movybench/WebPlayerActivity;->getWindow()Landroid/view/Window;

    move-result-object p1

    const/16 p2, 0x80

    invoke-virtual {p1, p2}, Landroid/view/Window;->addFlags(I)V

    .line 330
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity$Chrome;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mhideBars(Lsx/movybench/WebPlayerActivity;)V

    return-void
.end method
