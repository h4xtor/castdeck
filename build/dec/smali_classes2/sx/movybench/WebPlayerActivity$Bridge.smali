.class Lsx/movybench/WebPlayerActivity$Bridge;
.super Ljava/lang/Object;
.source "WebPlayerActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/WebPlayerActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "Bridge"
.end annotation


# instance fields
.field final synthetic this$0:Lsx/movybench/WebPlayerActivity;


# direct methods
.method public static synthetic $r8$lambda$h2QEYZiDvjkWwP5G55HsL0q8vyg(Lsx/movybench/WebPlayerActivity$Bridge;)V
    .locals 0

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity$Bridge;->lambda$nextMissing$1()V

    return-void
.end method

.method public static synthetic $r8$lambda$m8_6H3nMdLe-z7kOjjmseKmBS0o(Lsx/movybench/WebPlayerActivity$Bridge;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity$Bridge;->lambda$toast$0(Ljava/lang/String;)V

    return-void
.end method

.method private constructor <init>(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    .line 268
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity$Bridge;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/WebPlayerActivity-IA;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity$Bridge;-><init>(Lsx/movybench/WebPlayerActivity;)V

    return-void
.end method

.method private synthetic lambda$nextMissing$1()V
    .locals 1

    .line 274
    const-string v0, "Ingen next-knap fundet \u2014 brug menuen"

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity$Bridge;->toast(Ljava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$toast$0(Ljava/lang/String;)V
    .locals 2

    .line 271
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Bridge;->this$0:Lsx/movybench/WebPlayerActivity;

    const/4 v1, 0x0

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method


# virtual methods
.method public media(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 269
    iget-object p3, p0, Lsx/movybench/WebPlayerActivity$Bridge;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {p3, p1, p2}, Lsx/movybench/WebPlayerActivity;->-$$Nest$mpostMedia(Lsx/movybench/WebPlayerActivity;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public nextMissing()V
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 274
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Bridge;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetui(Lsx/movybench/WebPlayerActivity;)Landroid/os/Handler;

    move-result-object v0

    new-instance v1, Lsx/movybench/WebPlayerActivity$Bridge$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lsx/movybench/WebPlayerActivity$Bridge$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/WebPlayerActivity$Bridge;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public toast(Ljava/lang/String;)V
    .locals 2
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    .line 271
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity$Bridge;->this$0:Lsx/movybench/WebPlayerActivity;

    invoke-static {v0}, Lsx/movybench/WebPlayerActivity;->-$$Nest$fgetui(Lsx/movybench/WebPlayerActivity;)Landroid/os/Handler;

    move-result-object v0

    new-instance v1, Lsx/movybench/WebPlayerActivity$Bridge$$ExternalSyntheticLambda1;

    invoke-direct {v1, p0, p1}, Lsx/movybench/WebPlayerActivity$Bridge$$ExternalSyntheticLambda1;-><init>(Lsx/movybench/WebPlayerActivity$Bridge;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public tick(Ljava/lang/String;)Ljava/lang/String;
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    invoke-static {p1}, Lsx/movybench/CastRemote;->onTick(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
