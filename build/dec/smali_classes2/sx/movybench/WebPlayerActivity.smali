.class public Lsx/movybench/WebPlayerActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "WebPlayerActivity.java"

# interfaces
.implements Lcom/google/android/gms/cast/framework/SessionManagerListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/WebPlayerActivity$Bridge;,
        Lsx/movybench/WebPlayerActivity$Client;,
        Lsx/movybench/WebPlayerActivity$Chrome;,
        Lsx/movybench/WebPlayerActivity$MetaCb;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/appcompat/app/AppCompatActivity;",
        "Lcom/google/android/gms/cast/framework/SessionManagerListener<",
        "Lcom/google/android/gms/cast/framework/CastSession;",
        ">;"
    }
.end annotation


# static fields
.field private static final DESKTOP_UA:Ljava/lang/String; = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

.field public static final EXTRA_NAME:Ljava/lang/String; = "name"

.field public static final EXTRA_URL:Ljava/lang/String; = "url"


# instance fields
.field private ccBtn:Landroid/widget/TextView;

.field private chromeBar:Landroid/view/View;

.field private customView:Landroid/view/View;

.field private fsCallback:Landroid/webkit/WebChromeClient$CustomViewCallback;

.field private fsHost:Landroid/widget/FrameLayout;

.field private fsRoot:Landroid/widget/FrameLayout;

.field private lastMedia:Ljava/lang/String;

.field private lastMediaTitle:Ljava/lang/String;

.field private moreBtn:Landroid/widget/TextView;

.field private final overlay:Lsx/movybench/SubtitleOverlay;

.field private pendingCastSent:Z

.field private progress:Landroid/widget/ProgressBar;

.field private final pump:Ljava/lang/Runnable;

.field private siteName:Ljava/lang/String;

.field private streamPill:Landroid/widget/TextView;

.field private subFs:Landroid/widget/TextView;

.field private subInline:Landroid/widget/TextView;

.field private titleView:Landroid/widget/TextView;

.field private final ui:Landroid/os/Handler;

.field private web:Landroid/webkit/WebView;


# direct methods
.method public static synthetic $r8$lambda$01sbgmg8vyepN7IugRO9hmbSg7I(Lsx/movybench/WebPlayerActivity;ZLjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$flushPendingCast$7(ZLjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$0OLT_09CRvgvJY1spXuZ8AkMW3g(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->lambda$onCreate$5(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$51ILZuPcGk5-9e2x0RG5k6gCJFs(Lsx/movybench/WebPlayerActivity;Z[Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$startSubtitleSearch$11(Z[Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$ANPE6uznooU2oUW0F49oaSC4Gxo(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->flushPendingCast()V

    return-void
.end method

.method public static synthetic $r8$lambda$B8fxkEHXOAdhYPH5rUaroTqXmdM(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)Z
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->lambda$onCreate$1(Landroid/view/View;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$CpnAH4D-NdlS4Ss3KT4VOCblFqM(Lsx/movybench/WebPlayerActivity;ZLjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$onMedia$9(ZLjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$GkdqDvzM7NcR105oSUUPd667ReM(Lsx/movybench/WebPlayerActivity;Ljava/util/List;Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lsx/movybench/WebPlayerActivity;->lambda$listDialog$17(Ljava/util/List;Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$Koo1gwHAzCw_7zYmUR1Ji1HtG8I(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->lambda$onCreate$0(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$LMr1odnThu1cKUiYMigx1m0Q628(Lsx/movybench/WebPlayerActivity;Landroidx/appcompat/app/AlertDialog;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/sub/SubtitleResult;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lsx/movybench/WebPlayerActivity;->lambda$download$21(Landroidx/appcompat/app/AlertDialog;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/sub/SubtitleResult;)V

    return-void
.end method

.method public static synthetic $r8$lambda$PMkqhBpw0ei6B4oBOzXWUQNRYII(Lsx/movybench/WebPlayerActivity;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$emptyDialog$19(Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$S6iuLfZ8CRGxAGakYAKHbPSODx8(Lsx/movybench/WebPlayerActivity;ZLjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$manualCast$24(ZLjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$TIWrz6sURP5jTtbhs3_pS6tg0P4(Lsx/movybench/WebPlayerActivity;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$openMenu$23(Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$TksqUjJ4Gb_LCRG7Q3ty4xi8H54(Lsx/movybench/WebPlayerActivity;Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lsx/movybench/WebPlayerActivity;->lambda$emptyDialog$20(Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$Tm_GSTx_iEO_jEdDlbM1hIJKkOk(Lsx/movybench/WebPlayerActivity;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$postMedia$8(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$U_Fc5GPhGAMOmYv6hubgIDrvNbg(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->lambda$onCreate$3(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$Vbo_RoX34nLQjyJYK_TCalT0uFM(Lsx/movybench/WebPlayerActivity;Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lsx/movybench/WebPlayerActivity;->lambda$listDialog$18(Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$Yo17ANVen3qauNewA2RKk8EEds0(Lsx/movybench/WebPlayerActivity;ZLjava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$castNow$6(ZLjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$_ibX7Uu3udCXAIDk_bP3WjzrlDA(Lsx/movybench/WebPlayerActivity;Landroid/view/View;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lsx/movybench/WebPlayerActivity;->lambda$manualSearch$13(Landroid/view/View;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V

    return-void
.end method

.method public static synthetic $r8$lambda$goSshaBnvGgEctw47mga8fJFGBQ(Lsx/movybench/WebPlayerActivity;Lsx/movybench/TitleParser;ZLandroidx/appcompat/app/AlertDialog;Z)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lsx/movybench/WebPlayerActivity;->lambda$launchSearch$16(Lsx/movybench/TitleParser;ZLandroidx/appcompat/app/AlertDialog;Z)V

    return-void
.end method

.method public static synthetic $r8$lambda$mfFMZ4oUeaqpyEd-bSUQSA6cJMI(Lsx/movybench/WebPlayerActivity;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct/range {p0 .. p5}, Lsx/movybench/WebPlayerActivity;->lambda$manualSearch$12(Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$oOQfW1LFRjIJRho2_wv0ElDAXRg(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->lambda$onCreate$2(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$pFYTY0fyLbAFULzWDJugOyNyqV8(Lsx/movybench/WebPlayerActivity;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lsx/movybench/WebPlayerActivity;->lambda$manualCast$25(Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$t5E_n6ufj0ZS-MMe-REOAJp-pd4(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->lambda$onCreate$4(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$tZxXM5aIyGN-1UqTN3vrBLfGc7g(Lsx/movybench/WebPlayerActivity;Landroidx/appcompat/app/AlertDialog;Ljava/util/List;Lsx/movybench/TitleParser;Ljava/util/List;ZZLjava/lang/String;)V
    .locals 0

    invoke-direct/range {p0 .. p7}, Lsx/movybench/WebPlayerActivity;->lambda$launchSearch$15(Landroidx/appcompat/app/AlertDialog;Ljava/util/List;Lsx/movybench/TitleParser;Ljava/util/List;ZZLjava/lang/String;)V

    return-void
.end method

.method public static synthetic $r8$lambda$zH94JbL8a7m5ACTHmPFccO53GW8(Lsx/movybench/WebPlayerActivity;Lsx/movybench/sub/SubtitleResult;Landroidx/appcompat/app/AlertDialog;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->lambda$download$22(Lsx/movybench/sub/SubtitleResult;Landroidx/appcompat/app/AlertDialog;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetchromeBar(Lsx/movybench/WebPlayerActivity;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->chromeBar:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetcustomView(Lsx/movybench/WebPlayerActivity;)Landroid/view/View;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->customView:Landroid/view/View;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetfsHost(Lsx/movybench/WebPlayerActivity;)Landroid/widget/FrameLayout;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->fsHost:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetfsRoot(Lsx/movybench/WebPlayerActivity;)Landroid/widget/FrameLayout;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->fsRoot:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetoverlay(Lsx/movybench/WebPlayerActivity;)Lsx/movybench/SubtitleOverlay;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetprogress(Lsx/movybench/WebPlayerActivity;)Landroid/widget/ProgressBar;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->progress:Landroid/widget/ProgressBar;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetui(Lsx/movybench/WebPlayerActivity;)Landroid/os/Handler;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetweb(Lsx/movybench/WebPlayerActivity;)Landroid/webkit/WebView;
    .locals 0

    iget-object p0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputcustomView(Lsx/movybench/WebPlayerActivity;Landroid/view/View;)V
    .locals 0

    iput-object p1, p0, Lsx/movybench/WebPlayerActivity;->customView:Landroid/view/View;

    return-void
.end method

.method static bridge synthetic -$$Nest$fputfsCallback(Lsx/movybench/WebPlayerActivity;Landroid/webkit/WebChromeClient$CustomViewCallback;)V
    .locals 0

    iput-object p1, p0, Lsx/movybench/WebPlayerActivity;->fsCallback:Landroid/webkit/WebChromeClient$CustomViewCallback;

    return-void
.end method

.method static bridge synthetic -$$Nest$mhideBars(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->hideBars()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mhideFullscreen(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->hideFullscreen()V

    return-void
.end method

.method static bridge synthetic -$$Nest$mpostMedia(Lsx/movybench/WebPlayerActivity;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->postMedia(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mstartPump(Lsx/movybench/WebPlayerActivity;)V
    .locals 0

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->startPump()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smisAd(Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0}, Lsx/movybench/WebPlayerActivity;->isAd(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method static bridge synthetic -$$Nest$smlooksLikeMedia(Ljava/lang/String;)Z
    .locals 0

    invoke-static {p0}, Lsx/movybench/WebPlayerActivity;->looksLikeMedia(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public constructor <init>()V
    .locals 2

    .line 51
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 69
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    .line 70
    new-instance v0, Lsx/movybench/SubtitleOverlay;

    invoke-direct {v0}, Lsx/movybench/SubtitleOverlay;-><init>()V

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    .line 72
    const-string v0, ""

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    .line 73
    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMediaTitle:Ljava/lang/String;

    .line 74
    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    .line 77
    new-instance v0, Lsx/movybench/WebPlayerActivity$1;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$1;-><init>(Lsx/movybench/WebPlayerActivity;)V

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->pump:Ljava/lang/Runnable;

    return-void
.end method

.method private castNow()V
    .locals 4

    .line 166
    invoke-static {p0}, Lsx/movybench/CastHelper;->isConnected(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 167
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 168
    const-string v0, "Ingen stream fundet endnu \u2014 start afspilningen"

    invoke-direct {p0, v0}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void

    .line 171
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->streamTitle()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->metaLabel()Ljava/lang/String;

    move-result-object v2

    new-instance v3, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda10;

    invoke-direct {v3, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda10;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-static {p0, v0, v1, v2, v3}, Lsx/movybench/CastLoadSub;->load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V

    goto :goto_0

    :cond_1
    const/4 v0, 0x0

    .line 173
    iput-boolean v0, p0, Lsx/movybench/WebPlayerActivity;->pendingCastSent:Z

    .line 174
    invoke-static {p0}, Lsx/movybench/CastHelper;->openPicker(Landroid/app/Activity;)V

    :goto_0
    return-void
.end method

.method private copy(Ljava/lang/String;)V
    .locals 2

    .line 647
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p1, "Ingen stream fundet"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void

    .line 648
    :cond_0
    const-string v0, "clipboard"

    .line 649
    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    if-eqz v0, :cond_1

    .line 650
    const-string v1, "stream"

    invoke-static {v1, p1}, Landroid/content/ClipData;->newPlainText(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Landroid/content/ClipData;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/content/ClipboardManager;->setPrimaryClip(Landroid/content/ClipData;)V

    .line 651
    :cond_1
    const-string p1, "URL kopieret"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void
.end method

.method private static dismiss(Landroidx/appcompat/app/AlertDialog;)V
    .locals 1

    if-eqz p0, :cond_0

    .line 665
    :try_start_0
    invoke-virtual {p0}, Landroidx/appcompat/app/AlertDialog;->isShowing()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0}, Landroidx/appcompat/app/AlertDialog;->dismiss()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_0
    return-void
.end method

.method private download(Lsx/movybench/sub/SubtitleResult;Lsx/movybench/TitleParser;)V
    .locals 2

    .line 538
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "Henter undertekst\n"

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Lsx/movybench/sub/SubtitleResult;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p2}, Lsx/movybench/WebPlayerActivity;->progressDialog(Ljava/lang/String;)Landroidx/appcompat/app/AlertDialog;

    move-result-object p2

    .line 539
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda8;

    invoke-direct {v1, p0, p1, p2}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda8;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/sub/SubtitleResult;Landroidx/appcompat/app/AlertDialog;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 564
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private emptyDialog(Lsx/movybench/TitleParser;Ljava/util/List;Z)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lsx/movybench/TitleParser;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;Z)V"
        }
    .end annotation

    .line 518
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    .line 519
    invoke-virtual {p1}, Lsx/movybench/TitleParser;->label()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 520
    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 521
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "Ingen hits. Titlen blev l\u00e6st som: \""

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p1, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, "\""

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    .line 522
    :cond_0
    const-string v0, "\n"

    invoke-static {v0, p2}, Landroid/text/TextUtils;->join(Ljava/lang/CharSequence;Ljava/lang/Iterable;)Ljava/lang/String;

    move-result-object p2

    .line 520
    :goto_0
    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 523
    new-instance p2, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {p2, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    const-string v0, "Ingen undertekster"

    .line 524
    invoke-virtual {p2, v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p2

    .line 525
    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-virtual {p2, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setMessage(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p2

    new-instance p3, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda6;

    invoke-direct {p3, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda6;-><init>(Lsx/movybench/WebPlayerActivity;)V

    .line 526
    const-string v0, "S\u00f8g manuelt"

    invoke-virtual {p2, v0, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p2

    new-instance p3, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda7;

    invoke-direct {p3, p0, p1}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda7;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/TitleParser;)V

    .line 527
    const-string p1, "\u00c5bn sub-side"

    invoke-virtual {p2, p1, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    sget p2, Lsx/movybench/R$string;->close:I

    const/4 p3, 0x0

    .line 533
    invoke-virtual {p1, p2, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    .line 534
    invoke-virtual {p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    return-void
.end method

.method private flushPendingCast()V
    .locals 4

    .line 194
    iget-boolean v0, p0, Lsx/movybench/WebPlayerActivity;->pendingCastSent:Z

    if-nez v0, :cond_1

    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x1

    .line 195
    iput-boolean v0, p0, Lsx/movybench/WebPlayerActivity;->pendingCastSent:Z

    .line 196
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->streamTitle()Ljava/lang/String;

    move-result-object v1

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->metaLabel()Ljava/lang/String;

    move-result-object v2

    new-instance v3, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda22;

    invoke-direct {v3, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda22;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-static {p0, v0, v1, v2, v3}, Lsx/movybench/CastLoadSub;->load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V

    :cond_1
    :goto_0
    return-void
.end method

.method private grabMeta(Lsx/movybench/WebPlayerActivity$MetaCb;)V
    .locals 2

    .line 360
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    new-instance v1, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda18;

    invoke-direct {v1, p1}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda18;-><init>(Lsx/movybench/WebPlayerActivity$MetaCb;)V

    const-string p1, "(function(){try{return window.__mbTitle?window.__mbTitle():[document.title||\'\',location.href||\'\',(document.querySelector(\'meta[property=\"og:title\"]\')||{}).content||\'\',(document.querySelector(\'h1\')||{}).innerText||\'\'];}catch(e){return null}})()"

    invoke-virtual {v0, p1, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    return-void
.end method

.method private hideBars()V
    .locals 2

    .line 348
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    const/16 v1, 0x1106

    invoke-virtual {v0, v1}, Landroid/view/View;->setSystemUiVisibility(I)V

    return-void
.end method

.method private hideFullscreen()V
    .locals 3

    .line 337
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->customView:Landroid/view/View;

    if-nez v0, :cond_0

    return-void

    .line 338
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->fsHost:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->removeAllViews()V

    const/4 v0, 0x0

    .line 339
    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->customView:Landroid/view/View;

    .line 340
    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->fsRoot:Landroid/widget/FrameLayout;

    const/16 v2, 0x8

    invoke-virtual {v1, v2}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 341
    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->chromeBar:Landroid/view/View;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 342
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getWindow()Landroid/view/Window;

    move-result-object v1

    const/16 v2, 0x80

    invoke-virtual {v1, v2}, Landroid/view/Window;->clearFlags(I)V

    .line 343
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->showBars()V

    .line 344
    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->fsCallback:Landroid/webkit/WebChromeClient$CustomViewCallback;

    if-eqz v1, :cond_1

    invoke-interface {v1}, Landroid/webkit/WebChromeClient$CustomViewCallback;->onCustomViewHidden()V

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->fsCallback:Landroid/webkit/WebChromeClient$CustomViewCallback;

    :cond_1
    return-void
.end method

.method private static isAd(Ljava/lang/String;)Z
    .locals 6

    .line 254
    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0x21

    .line 255
    new-array v1, v0, [Ljava/lang/String;

    const-string v2, "doubleclick.net"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "googlesyndication.com"

    const/4 v4, 0x1

    aput-object v2, v1, v4

    const/4 v2, 0x2

    const-string v5, "googleadservices.com"

    aput-object v5, v1, v2

    const/4 v2, 0x3

    const-string v5, "adservice.google"

    aput-object v5, v1, v2

    const/4 v2, 0x4

    const-string v5, "adsystem.com"

    aput-object v5, v1, v2

    const/4 v2, 0x5

    const-string v5, "amazon-adsystem"

    aput-object v5, v1, v2

    const/4 v2, 0x6

    const-string v5, "popads.net"

    aput-object v5, v1, v2

    const/4 v2, 0x7

    const-string v5, "popcash.net"

    aput-object v5, v1, v2

    const/16 v2, 0x8

    const-string v5, "propellerads.com"

    aput-object v5, v1, v2

    const/16 v2, 0x9

    const-string v5, "exoclick.com"

    aput-object v5, v1, v2

    const/16 v2, 0xa

    const-string v5, "exosrv.com"

    aput-object v5, v1, v2

    const/16 v2, 0xb

    const-string v5, "juicyads.com"

    aput-object v5, v1, v2

    const/16 v2, 0xc

    const-string v5, "trafficjunky.net"

    aput-object v5, v1, v2

    const/16 v2, 0xd

    const-string v5, "trafficfactory"

    aput-object v5, v1, v2

    const/16 v2, 0xe

    const-string v5, "hilltopads.net"

    aput-object v5, v1, v2

    const/16 v2, 0xf

    const-string v5, "adsterra.com"

    aput-object v5, v1, v2

    const/16 v2, 0x10

    const-string v5, "onclckds.com"

    aput-object v5, v1, v2

    const/16 v2, 0x11

    const-string v5, "clickadu.com"

    aput-object v5, v1, v2

    const/16 v2, 0x12

    const-string v5, "mgid.com"

    aput-object v5, v1, v2

    const/16 v2, 0x13

    const-string v5, "revcontent.com"

    aput-object v5, v1, v2

    const/16 v2, 0x14

    const-string v5, "zergnet.com"

    aput-object v5, v1, v2

    const/16 v2, 0x15

    const-string v5, "adnxs.com"

    aput-object v5, v1, v2

    const/16 v2, 0x16

    const-string v5, "openx.net"

    aput-object v5, v1, v2

    const/16 v2, 0x17

    const-string v5, "pubmatic.com"

    aput-object v5, v1, v2

    const/16 v2, 0x18

    const-string v5, "criteo.com"

    aput-object v5, v1, v2

    const/16 v2, 0x19

    const-string v5, "taboola.com"

    aput-object v5, v1, v2

    const/16 v2, 0x1a

    const-string v5, "outbrain.com"

    aput-object v5, v1, v2

    const/16 v2, 0x1b

    const-string v5, "adcash.com"

    aput-object v5, v1, v2

    const/16 v2, 0x1c

    const-string v5, "tsyndicate.com"

    aput-object v5, v1, v2

    const/16 v2, 0x1d

    const-string v5, "pemsrv.com"

    aput-object v5, v1, v2

    const/16 v2, 0x1e

    const-string v5, "dtscout.com"

    aput-object v5, v1, v2

    const/16 v2, 0x1f

    const-string v5, "realsrv.com"

    aput-object v5, v1, v2

    const/16 v2, 0x20

    const-string v5, "juicyads"

    aput-object v5, v1, v2

    move v2, v3

    :goto_0
    if-ge v2, v0, :cond_1

    .line 264
    aget-object v5, v1, v2

    invoke-virtual {p0, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_0

    return v4

    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 265
    :cond_1
    const-string v0, "/ads/"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, "/adserver/"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_2

    const-string v0, "/popunder"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_3

    :cond_2
    move v3, v4

    :cond_3
    return v3
.end method

.method private static isHomepage(Ljava/lang/String;)Z
    .locals 3

    const/4 v0, 0x1

    if-nez p0, :cond_0

    return v0

    :cond_0
    const/4 v1, 0x0

    .line 438
    :try_start_0
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0

    invoke-virtual {p0}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_2

    .line 439
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_2

    const-string v2, "/"

    invoke-virtual {p0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz p0, :cond_1

    goto :goto_0

    :cond_1
    move v0, v1

    :cond_2
    :goto_0
    return v0

    :catch_0
    return v1
.end method

.method private synthetic lambda$castNow$6(ZLjava/lang/String;)V
    .locals 0

    .line 171
    invoke-direct {p0, p2}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    if-eqz p1, :mb_no

    invoke-static {p0}, Lsx/movybench/CastRemote;->onCast(Landroid/app/Activity;)V

    :mb_no
    return-void
.end method

.method private synthetic lambda$download$21(Landroidx/appcompat/app/AlertDialog;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/sub/SubtitleResult;)V
    .locals 0

    .line 556
    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->dismiss(Landroidx/appcompat/app/AlertDialog;)V

    if-nez p2, :cond_0

    .line 557
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "Download fejlede: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void

    .line 558
    :cond_0
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    invoke-virtual {p1, p2}, Lsx/movybench/SubtitleOverlay;->set(Ljava/lang/String;)V

    .line 559
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    invoke-virtual {p1}, Lsx/movybench/SubtitleOverlay;->count()I

    move-result p1

    if-nez p1, :cond_1

    const-string p1, "Filen indeholdt ingen cues"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void

    .line 560
    :cond_1
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->startPump()V

    .line 561
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object p2, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    invoke-virtual {p2}, Lsx/movybench/SubtitleOverlay;->count()I

    move-result p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " cues \u00b7 "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-direct {p0, p4}, Lsx/movybench/WebPlayerActivity;->screenLang(Lsx/movybench/sub/SubtitleResult;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    .line 562
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->subInline:Landroid/widget/TextView;

    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setVisibility(I)V

    return-void
.end method

.method private synthetic lambda$download$22(Lsx/movybench/sub/SubtitleResult;Landroidx/appcompat/app/AlertDialog;)V
    .locals 8

    const/4 v0, 0x0

    .line 544
    :try_start_0
    invoke-static {p0}, Lsx/movybench/sub/SubtitleEngine;->providers(Landroid/content/Context;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lsx/movybench/sub/SubProvider;

    .line 545
    invoke-interface {v2}, Lsx/movybench/sub/SubProvider;->name()Ljava/lang/String;

    move-result-object v3

    iget-object v4, p1, Lsx/movybench/sub/SubtitleResult;->provider:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_0

    goto :goto_0

    :cond_1
    move-object v2, v0

    :goto_0
    if-eqz v2, :cond_3

    .line 548
    invoke-interface {v2}, Lsx/movybench/sub/SubProvider;->name()Ljava/lang/String;

    move-result-object v1

    const-string v3, "SubDL"

    invoke-virtual {v1, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-static {p0}, Lsx/movybench/Prefs;->subdlKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    goto :goto_1

    :cond_2
    invoke-static {p0}, Lsx/movybench/Prefs;->osKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    .line 549
    :goto_1
    invoke-interface {v2, p1, v1}, Lsx/movybench/sub/SubProvider;->download(Lsx/movybench/sub/SubtitleResult;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    move-object v6, v0

    move-object v5, v1

    goto :goto_3

    .line 547
    :cond_3
    new-instance v1, Ljava/lang/Exception;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "provider v\u00e6k: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, p1, Lsx/movybench/sub/SubtitleResult;->provider:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw v1
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v1

    .line 551
    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v2

    if-nez v2, :cond_4

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v1

    goto :goto_2

    :cond_4
    invoke-virtual {v1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v1

    :goto_2
    move-object v5, v0

    move-object v6, v1

    .line 555
    :goto_3
    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda0;

    move-object v2, v0

    move-object v3, p0

    move-object v4, p2

    move-object v7, p1

    invoke-direct/range {v2 .. v7}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/WebPlayerActivity;Landroidx/appcompat/app/AlertDialog;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/sub/SubtitleResult;)V

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$emptyDialog$19(Landroid/content/DialogInterface;I)V
    .locals 0

    const/4 p1, 0x1

    .line 526
    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->manualSearch(Z)V

    return-void
.end method

.method private synthetic lambda$emptyDialog$20(Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V
    .locals 1

    .line 528
    iget-object p1, p1, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    invoke-static {p1}, Landroid/net/Uri;->encode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 529
    new-instance p2, Landroid/content/Intent;

    new-instance p3, Ljava/lang/StringBuilder;

    const-string v0, "https://www.opensubtitles.org/da/search2/sublanguageid-"

    invoke-direct {p3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 531
    invoke-static {p0}, Lsx/movybench/Prefs;->lang(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    const-string v0, "/moviename-"

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 530
    invoke-static {p1}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    const-string p3, "android.intent.action.VIEW"

    invoke-direct {p2, p3, p1}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 529
    invoke-virtual {p0, p2}, Lsx/movybench/WebPlayerActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method private synthetic lambda$flushPendingCast$7(ZLjava/lang/String;)V
    .locals 0

    .line 196
    invoke-direct {p0, p2}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    if-eqz p1, :mb_no

    invoke-static {p0}, Lsx/movybench/CastRemote;->onCast(Landroid/app/Activity;)V

    :mb_no
    return-void
.end method

.method static synthetic lambda$grabMeta$10(Lsx/movybench/WebPlayerActivity$MetaCb;Ljava/lang/String;)V
    .locals 5

    .line 366
    const-string v0, ""

    const/4 v1, 0x0

    if-eqz p1, :cond_1

    const-string v2, "null"

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    goto :goto_1

    .line 368
    :cond_0
    :try_start_0
    new-instance v2, Lorg/json/JSONArray;

    invoke-direct {v2, p1}, Lorg/json/JSONArray;-><init>(Ljava/lang/String;)V

    const/4 p1, 0x4

    .line 369
    new-array p1, p1, [Ljava/lang/String;

    const/4 v3, 0x0

    .line 370
    invoke-virtual {v2, v3, v0}, Lorg/json/JSONArray;->optString(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v4

    aput-object v4, p1, v3

    const/4 v3, 0x1

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONArray;->optString(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v4

    aput-object v4, p1, v3

    const/4 v3, 0x2

    .line 371
    invoke-virtual {v2, v3, v0}, Lorg/json/JSONArray;->optString(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v4

    aput-object v4, p1, v3

    const/4 v3, 0x3

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONArray;->optString(ILjava/lang/String;)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p1, v3

    .line 369
    invoke-interface {p0, p1}, Lsx/movybench/WebPlayerActivity$MetaCb;->on([Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 373
    :catch_0
    invoke-interface {p0, v1}, Lsx/movybench/WebPlayerActivity$MetaCb;->on([Ljava/lang/String;)V

    :goto_0
    return-void

    .line 366
    :cond_1
    :goto_1
    invoke-interface {p0, v1}, Lsx/movybench/WebPlayerActivity$MetaCb;->on([Ljava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$launchSearch$15(Landroidx/appcompat/app/AlertDialog;Ljava/util/List;Lsx/movybench/TitleParser;Ljava/util/List;ZZLjava/lang/String;)V
    .locals 0

    .line 494
    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->dismiss(Landroidx/appcompat/app/AlertDialog;)V

    .line 495
    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 496
    invoke-direct {p0, p3, p4, p5}, Lsx/movybench/WebPlayerActivity;->emptyDialog(Lsx/movybench/TitleParser;Ljava/util/List;Z)V

    goto :goto_0

    :cond_0
    if-eqz p6, :cond_1

    const/4 p1, 0x0

    .line 498
    invoke-interface {p2, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lsx/movybench/sub/SubtitleResult;

    invoke-direct {p0, p1, p3}, Lsx/movybench/WebPlayerActivity;->download(Lsx/movybench/sub/SubtitleResult;Lsx/movybench/TitleParser;)V

    goto :goto_0

    .line 500
    :cond_1
    invoke-direct {p0, p2, p3, p7}, Lsx/movybench/WebPlayerActivity;->listDialog(Ljava/util/List;Lsx/movybench/TitleParser;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private synthetic lambda$launchSearch$16(Lsx/movybench/TitleParser;ZLandroidx/appcompat/app/AlertDialog;Z)V
    .locals 10

    .line 469
    iget-object v0, p1, Lsx/movybench/TitleParser;->imdb:Ljava/lang/String;

    if-eqz p2, :cond_0

    .line 470
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v0, p1, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    iget-object v1, p1, Lsx/movybench/TitleParser;->year:Ljava/lang/String;

    invoke-static {v0, v1}, Lsx/movybench/sub/ImdbResolver;->resolve(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_0
    move-object v9, v0

    .line 471
    new-instance v0, Lsx/movybench/sub/SubProvider$Query;

    invoke-direct {v0}, Lsx/movybench/sub/SubProvider$Query;-><init>()V

    .line 472
    iget-object v1, p1, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    iput-object v1, v0, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    .line 473
    iget-object v1, p1, Lsx/movybench/TitleParser;->year:Ljava/lang/String;

    iput-object v1, v0, Lsx/movybench/sub/SubProvider$Query;->year:Ljava/lang/String;

    .line 474
    iput-object v9, v0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    .line 475
    invoke-static {p0}, Lsx/movybench/Prefs;->lang(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lsx/movybench/sub/SubProvider$Query;->lang:Ljava/lang/String;

    .line 476
    iget v1, p1, Lsx/movybench/TitleParser;->season:I

    iput v1, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    .line 477
    iget v1, p1, Lsx/movybench/TitleParser;->episode:I

    iput v1, v0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    .line 478
    invoke-static {p0, v0}, Lsx/movybench/sub/SubtitleEngine;->searchBlocking(Landroid/content/Context;Lsx/movybench/sub/SubProvider$Query;)Lsx/movybench/sub/SubtitleEngine$Report;

    move-result-object v1

    .line 480
    iget-object v2, v1, Lsx/movybench/sub/SubtitleEngine$Report;->results:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    iget-object v2, v0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    iget-object v2, v0, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    .line 481
    const-string v1, ""

    iput-object v1, v0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    .line 482
    invoke-static {p0, v0}, Lsx/movybench/sub/SubtitleEngine;->searchBlocking(Landroid/content/Context;Lsx/movybench/sub/SubProvider$Query;)Lsx/movybench/sub/SubtitleEngine$Report;

    move-result-object v1

    .line 485
    :cond_1
    iget-object v2, v1, Lsx/movybench/sub/SubtitleEngine$Report;->results:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_2

    iget v2, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    if-lez v2, :cond_2

    const/4 v1, 0x0

    .line 486
    iput v1, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    .line 487
    iput v1, v0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    .line 488
    invoke-static {p0, v0}, Lsx/movybench/sub/SubtitleEngine;->searchBlocking(Landroid/content/Context;Lsx/movybench/sub/SubProvider$Query;)Lsx/movybench/sub/SubtitleEngine$Report;

    move-result-object v1

    .line 490
    :cond_2
    new-instance v4, Ljava/util/ArrayList;

    iget-object v0, v1, Lsx/movybench/sub/SubtitleEngine$Report;->results:Ljava/util/List;

    invoke-direct {v4, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 491
    new-instance v6, Ljava/util/ArrayList;

    iget-object v0, v1, Lsx/movybench/sub/SubtitleEngine$Report;->errors:Ljava/util/List;

    invoke-direct {v6, v0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 493
    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda24;

    move-object v1, v0

    move-object v2, p0

    move-object v3, p3

    move-object v5, p1

    move v7, p2

    move v8, p4

    invoke-direct/range {v1 .. v9}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda24;-><init>(Lsx/movybench/WebPlayerActivity;Landroidx/appcompat/app/AlertDialog;Ljava/util/List;Lsx/movybench/TitleParser;Ljava/util/List;ZZLjava/lang/String;)V

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method private synthetic lambda$listDialog$17(Ljava/util/List;Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 510
    invoke-interface {p1, p4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lsx/movybench/sub/SubtitleResult;

    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->download(Lsx/movybench/sub/SubtitleResult;Lsx/movybench/TitleParser;)V

    return-void
.end method

.method private synthetic lambda$listDialog$18(Lsx/movybench/TitleParser;Landroid/content/DialogInterface;I)V
    .locals 0

    const/4 p2, 0x0

    .line 511
    invoke-direct {p0, p1, p2, p2}, Lsx/movybench/WebPlayerActivity;->launchSearch(Lsx/movybench/TitleParser;ZZ)V

    return-void
.end method

.method private synthetic lambda$manualCast$24(ZLjava/lang/String;)V
    .locals 0

    .line 640
    invoke-direct {p0, p2}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    if-eqz p1, :mb_no

    invoke-static {p0}, Lsx/movybench/CastRemote;->onCast(Landroid/app/Activity;)V

    :mb_no
    return-void
.end method

.method private synthetic lambda$manualCast$25(Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 635
    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 636
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p3

    if-eqz p3, :cond_0

    return-void

    .line 637
    :cond_0
    invoke-static {p0}, Lsx/movybench/CastHelper;->isConnected(Landroid/content/Context;)Z

    move-result p3

    if-nez p3, :cond_1

    invoke-static {p0}, Lsx/movybench/CastHelper;->openPicker(Landroid/app/Activity;)V

    const/4 p3, 0x0

    iput-boolean p3, p0, Lsx/movybench/WebPlayerActivity;->pendingCastSent:Z

    .line 638
    :cond_1
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    .line 639
    invoke-virtual {p2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lsx/movybench/WebPlayerActivity;->lastMediaTitle:Ljava/lang/String;

    .line 640
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->streamTitle()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->metaLabel()Ljava/lang/String;

    move-result-object p3

    new-instance p4, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda20;

    invoke-direct {p4, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda20;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-static {p0, p1, p2, p3, p4}, Lsx/movybench/CastLoadSub;->load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V

    return-void
.end method

.method private synthetic lambda$manualSearch$12(Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 409
    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 410
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p4

    if-eqz p4, :cond_0

    const-string p1, "Skriv en titel"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void

    .line 411
    :cond_0
    const-string p4, ""

    invoke-static {p1, p4, p4, p4}, Lsx/movybench/TitleParser;->parse(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lsx/movybench/TitleParser;

    move-result-object p5

    .line 412
    invoke-virtual {p2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->num(Ljava/lang/String;)I

    move-result p2

    .line 413
    invoke-virtual {p3}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {p3}, Lsx/movybench/WebPlayerActivity;->num(Ljava/lang/String;)I

    move-result p3

    if-lez p2, :cond_1

    .line 414
    iput p2, p5, Lsx/movybench/TitleParser;->season:I

    :cond_1
    if-lez p3, :cond_2

    .line 415
    iput p3, p5, Lsx/movybench/TitleParser;->episode:I

    .line 416
    :cond_2
    const-string p2, "(?i)[.\\s_-]*s\\d{1,2}[\\s._-]*e\\d{1,3}\\b"

    invoke-virtual {p1, p2, p4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p5, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    const/4 p1, 0x0

    const/4 p2, 0x1

    .line 417
    invoke-direct {p0, p5, p1, p2}, Lsx/movybench/WebPlayerActivity;->launchSearch(Lsx/movybench/TitleParser;ZZ)V

    return-void
.end method

.method private synthetic lambda$manualSearch$13(Landroid/view/View;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V
    .locals 3

    .line 405
    new-instance v0, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v0, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "S\u00f8g "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 406
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->langName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " undertekster"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 407
    invoke-virtual {v0, p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setView(Landroid/view/View;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda9;

    invoke-direct {v0, p0, p2, p3, p4}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda9;-><init>(Lsx/movybench/WebPlayerActivity;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V

    .line 408
    const-string p2, "S\u00f8g"

    invoke-virtual {p1, p2, v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    sget p2, Lsx/movybench/R$string;->cancel:I

    const/4 p3, 0x0

    .line 419
    invoke-virtual {p1, p2, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    .line 420
    invoke-virtual {p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    return-void
.end method

.method static synthetic lambda$manualSearch$14(Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Ljava/lang/Runnable;[Ljava/lang/String;)V
    .locals 4

    if-eqz p4, :cond_2

    const/4 v0, 0x1

    .line 424
    aget-object v1, p4, v0

    invoke-static {v1}, Lsx/movybench/WebPlayerActivity;->isHomepage(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    const/4 v1, 0x0

    .line 425
    aget-object v1, p4, v1

    aget-object v0, p4, v0

    const/4 v2, 0x2

    aget-object v2, p4, v2

    const/4 v3, 0x3

    aget-object p4, p4, v3

    invoke-static {v1, v0, v2, p4}, Lsx/movybench/TitleParser;->parse(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lsx/movybench/TitleParser;

    move-result-object p4

    .line 426
    invoke-virtual {p4}, Lsx/movybench/TitleParser;->sane()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p4, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    invoke-virtual {p0, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 427
    :cond_0
    iget p0, p4, Lsx/movybench/TitleParser;->season:I

    if-lez p0, :cond_1

    iget p0, p4, Lsx/movybench/TitleParser;->season:I

    invoke-static {p0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 428
    :cond_1
    iget p0, p4, Lsx/movybench/TitleParser;->episode:I

    if-lez p0, :cond_2

    iget p0, p4, Lsx/movybench/TitleParser;->episode:I

    invoke-static {p0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 430
    :cond_2
    invoke-interface {p3}, Ljava/lang/Runnable;->run()V

    return-void
.end method

.method private synthetic lambda$onCreate$0(Landroid/view/View;)V
    .locals 0

    const/4 p1, 0x0

    .line 146
    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->startSubtitleSearch(Z)V

    return-void
.end method

.method private synthetic lambda$onCreate$1(Landroid/view/View;)Z
    .locals 0

    const/4 p1, 0x1

    .line 147
    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->startSubtitleSearch(Z)V

    return p1
.end method

.method private synthetic lambda$onCreate$2(Landroid/view/View;)V
    .locals 0

    .line 148
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->openMenu()V

    return-void
.end method

.method private synthetic lambda$onCreate$3(Landroid/view/View;)V
    .locals 0

    .line 149
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->castNow()V

    return-void
.end method

.method private synthetic lambda$onCreate$4(Landroid/view/View;)V
    .locals 0

    .line 151
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    invoke-virtual {p1}, Lsx/movybench/SubtitleOverlay;->clear()V

    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {p1}, Landroid/webkit/WebView;->reload()V

    return-void
.end method

.method private synthetic lambda$onCreate$5(Landroid/view/View;)V
    .locals 0

    .line 152
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->castNow()V

    return-void
.end method

.method private synthetic lambda$onMedia$9(ZLjava/lang/String;)V
    .locals 0

    .line 234
    invoke-direct {p0, p2}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    if-eqz p1, :mb_no

    invoke-static {p0}, Lsx/movybench/CastRemote;->onCast(Landroid/app/Activity;)V

    :mb_no
    return-void
.end method

.method private synthetic lambda$openMenu$23(Landroid/content/DialogInterface;I)V
    .locals 1

    packed-switch p2, :pswitch_data_0

    goto :goto_0

    :pswitch_0
    const/4 p1, 0x1

    .line 608
    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->manualSearch(Z)V

    goto :goto_0

    .line 607
    :pswitch_1
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    invoke-virtual {p1}, Lsx/movybench/SubtitleOverlay;->clear()V

    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {p1}, Landroid/webkit/WebView;->reload()V

    goto :goto_0

    .line 606
    :pswitch_2
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    invoke-virtual {p1}, Lsx/movybench/SubtitleOverlay;->clear()V

    const-string p1, "Undertekster ryddet"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    goto :goto_0

    .line 605
    :pswitch_3
    new-instance p1, Landroid/content/Intent;

    iget-object p2, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {p2}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    const-string v0, "android.intent.action.VIEW"

    invoke-direct {p1, v0, p2}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    invoke-virtual {p0, p1}, Lsx/movybench/WebPlayerActivity;->startActivity(Landroid/content/Intent;)V

    goto :goto_0

    .line 604
    :pswitch_4
    const-string p1, "desktop_ua"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toggle(Ljava/lang/String;)V

    goto :goto_0

    .line 603
    :pswitch_5
    const-string p1, "auto_next"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toggle(Ljava/lang/String;)V

    goto :goto_0

    :pswitch_6
    const/4 p1, 0x0

    .line 602
    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->startSubtitleSearch(Z)V

    goto :goto_0

    .line 601
    :pswitch_7
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->copy(Ljava/lang/String;)V

    goto :goto_0

    .line 600
    :pswitch_8
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->manualCast()V

    goto :goto_0

    .line 599
    :pswitch_9
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->castNow()V

    :goto_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_9
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private synthetic lambda$postMedia$8(Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 222
    invoke-direct {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onMedia(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private synthetic lambda$startSubtitleSearch$11(Z[Ljava/lang/String;)V
    .locals 5

    if-nez p2, :cond_0

    .line 382
    const-string p1, "Kunne ikke l\u00e6se siden"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    return-void

    :cond_0
    const/4 v0, 0x0

    .line 383
    aget-object v0, p2, v0

    const/4 v1, 0x1

    aget-object v2, p2, v1

    const/4 v3, 0x2

    aget-object v3, p2, v3

    const/4 v4, 0x3

    aget-object v4, p2, v4

    invoke-static {v0, v2, v3, v4}, Lsx/movybench/TitleParser;->parse(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lsx/movybench/TitleParser;

    move-result-object v0

    .line 384
    iget-object v2, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    invoke-static {v2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_1

    iget-object v2, v0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    sget-object v3, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v2, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    sget-object v4, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 385
    invoke-virtual {v3, v4}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 386
    iget-object v2, v0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    iget-object v3, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    const-string v3, "^[\\s\\-\u2013\u2014:|&]+"

    const-string v4, ""

    .line 387
    invoke-virtual {v2, v3, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    .line 389
    :cond_1
    invoke-virtual {v0}, Lsx/movybench/TitleParser;->sane()Z

    move-result v2

    if-eqz v2, :cond_3

    aget-object p2, p2, v1

    invoke-static {p2}, Lsx/movybench/WebPlayerActivity;->isHomepage(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_2

    goto :goto_0

    .line 394
    :cond_2
    invoke-direct {p0, v0, p1, v1}, Lsx/movybench/WebPlayerActivity;->launchSearch(Lsx/movybench/TitleParser;ZZ)V

    return-void

    .line 390
    :cond_3
    :goto_0
    const-string p1, "Kunne ikke l\u00e6se titlen \u2014 skriv den selv"

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    .line 391
    invoke-direct {p0, v1}, Lsx/movybench/WebPlayerActivity;->manualSearch(Z)V

    return-void
.end method

.method private langName()Ljava/lang/String;
    .locals 3

    .line 450
    invoke-static {p0}, Lsx/movybench/Prefs;->lang(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v1

    const/4 v2, -0x1

    sparse-switch v1, :sswitch_data_0

    goto/16 :goto_0

    :sswitch_0
    const-string v1, "sv"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_0

    :cond_0
    const/16 v2, 0x8

    goto/16 :goto_0

    :sswitch_1
    const-string v1, "pl"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v2, 0x7

    goto :goto_0

    :sswitch_2
    const-string v1, "no"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    goto :goto_0

    :cond_2
    const/4 v2, 0x6

    goto :goto_0

    :sswitch_3
    const-string v1, "nl"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_3

    goto :goto_0

    :cond_3
    const/4 v2, 0x5

    goto :goto_0

    :sswitch_4
    const-string v1, "fr"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    goto :goto_0

    :cond_4
    const/4 v2, 0x4

    goto :goto_0

    :sswitch_5
    const-string v1, "fi"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_5

    goto :goto_0

    :cond_5
    const/4 v2, 0x3

    goto :goto_0

    :sswitch_6
    const-string v1, "es"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_6

    goto :goto_0

    :cond_6
    const/4 v2, 0x2

    goto :goto_0

    :sswitch_7
    const-string v1, "en"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_7

    goto :goto_0

    :cond_7
    const/4 v2, 0x1

    goto :goto_0

    :sswitch_8
    const-string v1, "de"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_8

    goto :goto_0

    :cond_8
    const/4 v2, 0x0

    :goto_0
    packed-switch v2, :pswitch_data_0

    .line 461
    const-string v0, "danske"

    return-object v0

    .line 454
    :pswitch_0
    const-string v0, "svenske"

    return-object v0

    .line 458
    :pswitch_1
    const-string v0, "polske"

    return-object v0

    .line 455
    :pswitch_2
    const-string v0, "norske"

    return-object v0

    .line 457
    :pswitch_3
    const-string v0, "hollandske"

    return-object v0

    .line 459
    :pswitch_4
    const-string v0, "franske"

    return-object v0

    .line 456
    :pswitch_5
    const-string v0, "finske"

    return-object v0

    .line 460
    :pswitch_6
    const-string v0, "spanske"

    return-object v0

    .line 452
    :pswitch_7
    const-string v0, "engelske"

    return-object v0

    .line 453
    :pswitch_8
    const-string v0, "tyske"

    return-object v0

    nop

    :sswitch_data_0
    .sparse-switch
        0xc81 -> :sswitch_8
        0xca9 -> :sswitch_7
        0xcae -> :sswitch_6
        0xcc3 -> :sswitch_5
        0xccc -> :sswitch_4
        0xdbe -> :sswitch_3
        0xdc1 -> :sswitch_2
        0xdfc -> :sswitch_1
        0xe63 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private launchSearch(Lsx/movybench/TitleParser;ZZ)V
    .locals 8

    .line 466
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "S\u00f8ger "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->langName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " undertekster\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 467
    invoke-virtual {p1}, Lsx/movybench/TitleParser;->label()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 466
    invoke-direct {p0, v0}, Lsx/movybench/WebPlayerActivity;->progressDialog(Ljava/lang/String;)Landroidx/appcompat/app/AlertDialog;

    move-result-object v5

    .line 468
    new-instance v0, Ljava/lang/Thread;

    new-instance v7, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda16;

    move-object v1, v7

    move-object v2, p0

    move-object v3, p1

    move v4, p3

    move v6, p2

    invoke-direct/range {v1 .. v6}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda16;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/TitleParser;ZLandroidx/appcompat/app/AlertDialog;Z)V

    invoke-direct {v0, v7}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 503
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private listDialog(Ljava/util/List;Lsx/movybench/TitleParser;Ljava/lang/String;)V
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/sub/SubtitleResult;",
            ">;",
            "Lsx/movybench/TitleParser;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 507
    new-instance p3, Lsx/movybench/sub/SubtitleAdapter;

    invoke-direct {p3, p1}, Lsx/movybench/sub/SubtitleAdapter;-><init>(Ljava/util/List;)V

    .line 508
    new-instance v0, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v0, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 509
    invoke-virtual {p2}, Lsx/movybench/TitleParser;->label()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "  \u00b7  "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " hit"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v1, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda14;

    invoke-direct {v1, p0, p1, p2}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda14;-><init>(Lsx/movybench/WebPlayerActivity;Ljava/util/List;Lsx/movybench/TitleParser;)V

    .line 510
    invoke-virtual {v0, p3, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setAdapter(Landroid/widget/ListAdapter;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    new-instance p3, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda15;

    invoke-direct {p3, p0, p2}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda15;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/TitleParser;)V

    .line 511
    const-string p2, "Bredere s\u00f8gning"

    invoke-virtual {p1, p2, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    sget p2, Lsx/movybench/R$string;->cancel:I

    const/4 p3, 0x0

    .line 512
    invoke-virtual {p1, p2, p3}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    .line 513
    invoke-virtual {p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    return-void
.end method

.method private static looksLikeMedia(Ljava/lang/String;)Z
    .locals 2

    const/4 v0, 0x0

    if-nez p0, :cond_0

    return v0

    .line 247
    :cond_0
    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p0

    .line 248
    const-string v1, "blob:"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "data:"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_3

    const-string v1, "about:"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_0

    .line 249
    :cond_1
    const-string v1, ".m3u8"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, ".mp4"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, ".mkv"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, ".webm"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "format=m3u8"

    .line 250
    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_2

    const-string v1, "/manifest"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_3

    :cond_2
    const/4 v0, 0x1

    :cond_3
    :goto_0
    return v0
.end method

.method private manualCast()V
    .locals 6

    .line 626
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getLayoutInflater()Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lsx/movybench/R$layout;->dialog_manual_cast:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 627
    sget v1, Lsx/movybench/R$id;->urlIn:I

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 628
    sget v3, Lsx/movybench/R$id;->nameIn:I

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/widget/EditText;

    .line 629
    iget-object v4, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-static {v4}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_0

    iget-object v4, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-virtual {v1, v4}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 630
    :cond_0
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->streamTitle()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 631
    new-instance v4, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v4, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    const-string v5, "Cast manuel URL"

    .line 632
    invoke-virtual {v4, v5}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v4

    .line 633
    invoke-virtual {v4, v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setView(Landroid/view/View;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    new-instance v4, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda17;

    invoke-direct {v4, p0, v1, v3}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda17;-><init>(Lsx/movybench/WebPlayerActivity;Landroid/widget/EditText;Landroid/widget/EditText;)V

    .line 634
    const-string v1, "Cast"

    invoke-virtual {v0, v1, v4}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    sget v1, Lsx/movybench/R$string;->cancel:I

    .line 642
    invoke-virtual {v0, v1, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 643
    invoke-virtual {v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    return-void
.end method

.method private manualSearch(Z)V
    .locals 10

    .line 399
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getLayoutInflater()Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lsx/movybench/R$layout;->dialog_sub_search:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v5

    .line 400
    sget v0, Lsx/movybench/R$id;->tIn:I

    invoke-virtual {v5, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/EditText;

    const/4 v1, 0x1

    .line 401
    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setSelectAllOnFocus(Z)V

    .line 402
    sget v1, Lsx/movybench/R$id;->sIn:I

    invoke-virtual {v5, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/EditText;

    .line 403
    sget v2, Lsx/movybench/R$id;->eIn:I

    invoke-virtual {v5, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/widget/EditText;

    .line 405
    new-instance v9, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda12;

    move-object v3, v9

    move-object v4, p0

    move-object v6, v0

    move-object v7, v1

    move-object v8, v2

    invoke-direct/range {v3 .. v8}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda12;-><init>(Lsx/movybench/WebPlayerActivity;Landroid/view/View;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;)V

    if-nez p1, :cond_0

    .line 422
    invoke-interface {v9}, Ljava/lang/Runnable;->run()V

    return-void

    .line 423
    :cond_0
    new-instance p1, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda13;

    invoke-direct {p1, v0, v1, v2, v9}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda13;-><init>(Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/EditText;Ljava/lang/Runnable;)V

    invoke-direct {p0, p1}, Lsx/movybench/WebPlayerActivity;->grabMeta(Lsx/movybench/WebPlayerActivity$MetaCb;)V

    return-void
.end method

.method private metaLabel()Ljava/lang/String;
    .locals 1

    .line 577
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    if-nez v0, :cond_0

    const-string v0, ""

    :cond_0
    return-object v0
.end method

.method private static num(Ljava/lang/String;)I
    .locals 0

    .line 446
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    const/4 p0, 0x0

    return p0
.end method

.method private onMedia(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 226
    invoke-static {p1}, Lsx/movybench/WebPlayerActivity;->looksLikeMedia(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 227
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    return-void

    .line 228
    :cond_1
    iput-object p1, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    if-nez p2, :cond_2

    .line 229
    const-string p2, ""

    :cond_2
    iput-object p2, p0, Lsx/movybench/WebPlayerActivity;->lastMediaTitle:Ljava/lang/String;

    .line 230
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity;->streamPill:Landroid/widget/TextView;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u25cf  "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->shortStream()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u2014 send til TV"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 231
    iget-object p2, p0, Lsx/movybench/WebPlayerActivity;->streamPill:Landroid/widget/TextView;

    const/4 v0, 0x0

    invoke-virtual {p2, v0}, Landroid/widget/TextView;->setVisibility(I)V

    .line 232
    invoke-static {p0}, Lsx/movybench/Prefs;->autoCast(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_3

    invoke-static {p0}, Lsx/movybench/CastHelper;->isConnected(Landroid/content/Context;)Z

    move-result p2

    if-eqz p2, :cond_3

    const/4 p2, 0x1

    .line 233
    iput-boolean p2, p0, Lsx/movybench/WebPlayerActivity;->pendingCastSent:Z

    .line 234
    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->streamTitle()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->metaLabel()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda21;

    invoke-direct {v1, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda21;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-static {p0, p1, p2, v0, v1}, Lsx/movybench/CastLoadSub;->load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V

    :cond_3
    return-void
.end method

.method public static open(Landroid/app/Activity;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 93
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lsx/movybench/WebPlayerActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 94
    const-string v1, "url"

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 95
    const-string p1, "name"

    invoke-virtual {v0, p1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 96
    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method private openMenu()V
    .locals 5

    const/16 v0, 0xa

    .line 583
    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "Cast stream til TV"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "Cast manuel URL\u2026"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "Kopi\u00e9r stream-URL"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "Undertekster (s\u00f8g)"

    aput-object v2, v0, v1

    .line 588
    invoke-static {p0}, Lsx/movybench/Prefs;->autoNext(Landroid/content/Context;)Z

    move-result v1

    const-string v2, "TIL"

    const-string v3, "FRA"

    if-eqz v1, :cond_0

    move-object v1, v2

    goto :goto_0

    :cond_0
    move-object v1, v3

    :goto_0
    const-string v4, "Auto-next: "

    invoke-virtual {v4, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v4, 0x4

    aput-object v1, v0, v4

    .line 589
    invoke-static {p0}, Lsx/movybench/Prefs;->desktopUa(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_1

    :cond_1
    move-object v2, v3

    :goto_1
    const-string v1, "Desktop-UA: "

    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x5

    aput-object v1, v0, v2

    const/4 v1, 0x6

    const-string v2, "\u00c5bn i ekstern browser"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "Ryd undertekster"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "Genindl\u00e6s"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "S\u00f8g undertekster manuelt"

    aput-object v2, v0, v1

    .line 595
    new-instance v1, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v1, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    .line 596
    iget-object v2, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    if-nez v2, :cond_2

    const-string v2, "Menu"

    :cond_2
    invoke-virtual {v1, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    new-instance v2, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda19;

    invoke-direct {v2, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda19;-><init>(Lsx/movybench/WebPlayerActivity;)V

    .line 597
    invoke-virtual {v1, v0, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    sget v1, Lsx/movybench/R$string;->close:I

    const/4 v2, 0x0

    .line 611
    invoke-virtual {v0, v1, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v0

    .line 612
    invoke-virtual {v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    return-void
.end method

.method private postMedia(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    if-nez p1, :cond_0

    return-void

    .line 222
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    new-instance v1, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda23;

    invoke-direct {v1, p0, p1, p2}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda23;-><init>(Lsx/movybench/WebPlayerActivity;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private progressDialog(Ljava/lang/String;)Landroidx/appcompat/app/AlertDialog;
    .locals 3

    .line 657
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getLayoutInflater()Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lsx/movybench/R$layout;->dialog_progress:I

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    .line 658
    sget v1, Lsx/movybench/R$id;->msg:I

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    check-cast v1, Landroid/widget/TextView;

    invoke-virtual {v1, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 659
    new-instance p1, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {p1, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    invoke-virtual {p1, v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setView(Landroid/view/View;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setCancelable(Z)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    invoke-virtual {p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->create()Landroidx/appcompat/app/AlertDialog;

    move-result-object p1

    .line 660
    invoke-virtual {p1}, Landroidx/appcompat/app/AlertDialog;->show()V

    return-object p1
.end method

.method private screenLang(Lsx/movybench/sub/SubtitleResult;)Ljava/lang/String;
    .locals 1

    .line 568
    iget-object v0, p1, Lsx/movybench/sub/SubtitleResult;->language:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-direct {p0}, Lsx/movybench/WebPlayerActivity;->langName()Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    :cond_0
    iget-object p1, p1, Lsx/movybench/sub/SubtitleResult;->language:Ljava/lang/String;

    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p1, v0}, Ljava/lang/String;->toUpperCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p1

    :goto_0
    return-object p1
.end method

.method private shortStream()Ljava/lang/String;
    .locals 2

    .line 239
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMedia:Ljava/lang/String;

    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v0

    .line 240
    const-string v1, "m3u8"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v0, "HLS-stream fundet"

    return-object v0

    .line 241
    :cond_0
    const-string v1, ".mp4"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "MP4-stream fundet"

    return-object v0

    .line 242
    :cond_1
    const-string v0, "Stream fundet"

    return-object v0
.end method

.method private showBars()V
    .locals 2

    .line 354
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setSystemUiVisibility(I)V

    return-void
.end method

.method private startPump()V
    .locals 2

    .line 572
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->pump:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 573
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->pump:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private startSubtitleSearch(Z)V
    .locals 1

    .line 381
    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda25;

    invoke-direct {v0, p0, p1}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda25;-><init>(Lsx/movybench/WebPlayerActivity;Z)V

    invoke-direct {p0, v0}, Lsx/movybench/WebPlayerActivity;->grabMeta(Lsx/movybench/WebPlayerActivity$MetaCb;)V

    return-void
.end method

.method private streamTitle()Ljava/lang/String;
    .locals 1

    .line 179
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMediaTitle:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->lastMediaTitle:Ljava/lang/String;

    return-object v0

    .line 180
    :cond_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "MovieBench"

    goto :goto_0

    :cond_1
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    :goto_0
    return-object v0
.end method

.method private toast(Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    .line 669
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private toggle(Ljava/lang/String;)V
    .locals 5

    .line 616
    invoke-static {p0}, Lsx/movybench/Prefs;->autoNext(Landroid/content/Context;)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    .line 617
    const-string v1, "auto_next"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const-string v3, "desktop_ua"

    if-eqz v2, :cond_0

    invoke-static {p0}, Lsx/movybench/Prefs;->autoNext(Landroid/content/Context;)Z

    move-result v0

    :goto_0
    xor-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 618
    :cond_0
    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-static {p0}, Lsx/movybench/Prefs;->desktopUa(Landroid/content/Context;)Z

    move-result v0

    goto :goto_0

    .line 619
    :cond_1
    :goto_1
    invoke-static {p0, p1, v0}, Lsx/movybench/Prefs;->setBool(Landroid/content/Context;Ljava/lang/String;Z)V

    .line 620
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, " = "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    .line 621
    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    const-string v2, "Genstart siden for at skifte UA"

    invoke-direct {p0, v2}, Lsx/movybench/WebPlayerActivity;->toast(Ljava/lang/String;)V

    .line 622
    :cond_2
    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    if-eqz v0, :cond_3

    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    const-string v0, "(function(){\n  if (window.__mbNext) return; window.__mbNext = 1;\n  document.addEventListener(\'ended\', function(e){\n    var t = e.target;\n    if (!t || t.tagName !== \'VIDEO\') return;\n    var nodes = document.querySelectorAll(\'a,button\');\n    for (var i = 0; i < nodes.length; i++) {\n      var n = nodes[i];\n      var s = ((n.innerText || \'\') + \' \' + (n.getAttribute(\'title\') || \'\') + \' \'\n              + (n.getAttribute(\'aria-label\') || \'\') + \' \' + (n.className || \'\')).toLowerCase();\n      if (/\\bnext episode\\b|\\bnext\\b|n\u00e6ste afsnit|n\u00e6ste|naeste/.test(s)) {\n        n.click();\n        try { MB.toast(\'Auto-next: n\u00e6ste afsnit\'); } catch(x){}\n        return;\n      }\n    }\n    try { MB.nextMissing(); } catch(x){}\n  }, true);\n})();\n"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    :cond_3
    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 5

    .line 102
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 103
    sget p1, Lsx/movybench/R$layout;->activity_web:I

    invoke-virtual {p0, p1}, Lsx/movybench/WebPlayerActivity;->setContentView(I)V

    .line 105
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    const-string v0, "url"

    invoke-virtual {p1, v0}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 106
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v1, "name"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    if-nez p1, :cond_0

    .line 107
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->finish()V

    return-void

    .line 109
    :cond_0
    sget v0, Lsx/movybench/R$id;->web:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/webkit/WebView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    .line 110
    sget v0, Lsx/movybench/R$id;->title:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->titleView:Landroid/widget/TextView;

    .line 111
    sget v0, Lsx/movybench/R$id;->subOverlay:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->subInline:Landroid/widget/TextView;

    .line 112
    sget v0, Lsx/movybench/R$id;->subOverlayFs:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->subFs:Landroid/widget/TextView;

    .line 113
    sget v0, Lsx/movybench/R$id;->cc:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->ccBtn:Landroid/widget/TextView;

    .line 114
    sget v0, Lsx/movybench/R$id;->more:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->moreBtn:Landroid/widget/TextView;

    .line 115
    sget v0, Lsx/movybench/R$id;->streamPill:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->streamPill:Landroid/widget/TextView;

    .line 116
    sget v0, Lsx/movybench/R$id;->progress:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/ProgressBar;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->progress:Landroid/widget/ProgressBar;

    .line 117
    sget v0, Lsx/movybench/R$id;->chrome:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->chromeBar:Landroid/view/View;

    .line 118
    sget v0, Lsx/movybench/R$id;->fs:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->fsRoot:Landroid/widget/FrameLayout;

    .line 119
    sget v0, Lsx/movybench/R$id;->fsHost:I

    invoke-virtual {p0, v0}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout;

    iput-object v0, p0, Lsx/movybench/WebPlayerActivity;->fsHost:Landroid/widget/FrameLayout;

    .line 121
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->overlay:Lsx/movybench/SubtitleOverlay;

    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->subInline:Landroid/widget/TextView;

    iget-object v2, p0, Lsx/movybench/WebPlayerActivity;->subFs:Landroid/widget/TextView;

    invoke-virtual {v0, v1, v2}, Lsx/movybench/SubtitleOverlay;->bind(Landroid/widget/TextView;Landroid/widget/TextView;)V

    .line 122
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->titleView:Landroid/widget/TextView;

    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    invoke-static {v1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    move-object v1, p1

    goto :goto_0

    :cond_1
    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 123
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->siteName:Ljava/lang/String;

    invoke-static {p0, v0}, Lsx/movybench/Prefs;->pushRecent(Landroid/content/Context;Ljava/lang/String;)V

    .line 125
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v0

    const/4 v1, 0x1

    .line 126
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 127
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    .line 128
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setDatabaseEnabled(Z)V

    .line 129
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setLoadWithOverviewMode(Z)V

    .line 130
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setUseWideViewPort(Z)V

    const/4 v2, 0x0

    .line 131
    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V

    .line 132
    invoke-virtual {v0, v1}, Landroid/webkit/WebSettings;->setJavaScriptCanOpenWindowsAutomatically(Z)V

    .line 133
    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setSupportMultipleWindows(Z)V

    .line 134
    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setMixedContentMode(I)V

    const/4 v2, -0x1

    .line 135
    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setCacheMode(I)V

    .line 136
    invoke-static {p0}, Lsx/movybench/Prefs;->desktopUa(Landroid/content/Context;)Z

    move-result v2

    if-eqz v2, :cond_2

    const-string v2, "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"

    invoke-virtual {v0, v2}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    .line 138
    :cond_2
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/webkit/CookieManager;->setAcceptCookie(Z)V

    .line 139
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v0

    iget-object v2, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {v0, v2, v1}, Landroid/webkit/CookieManager;->setAcceptThirdPartyCookies(Landroid/webkit/WebView;Z)V

    .line 140
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    const/high16 v2, -0x1000000

    invoke-virtual {v0, v2}, Landroid/webkit/WebView;->setBackgroundColor(I)V

    .line 141
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    new-instance v2, Lsx/movybench/WebPlayerActivity$Bridge;

    const/4 v3, 0x0

    invoke-direct {v2, p0, v3}, Lsx/movybench/WebPlayerActivity$Bridge;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/WebPlayerActivity-IA;)V

    const-string v4, "MB"

    invoke-virtual {v0, v2, v4}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    .line 142
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    new-instance v2, Lsx/movybench/WebPlayerActivity$Client;

    invoke-direct {v2, p0, v3}, Lsx/movybench/WebPlayerActivity$Client;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/WebPlayerActivity-IA;)V

    invoke-virtual {v0, v2}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 143
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    new-instance v2, Lsx/movybench/WebPlayerActivity$Chrome;

    invoke-direct {v2, p0, v3}, Lsx/movybench/WebPlayerActivity$Chrome;-><init>(Lsx/movybench/WebPlayerActivity;Lsx/movybench/WebPlayerActivity-IA;)V

    invoke-virtual {v0, v2}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V

    .line 144
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {v0, p1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    .line 146
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->ccBtn:Landroid/widget/TextView;

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda26;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda26;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 147
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->ccBtn:Landroid/widget/TextView;

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda1;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    .line 148
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->moreBtn:Landroid/widget/TextView;

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda2;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 149
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->streamPill:Landroid/widget/TextView;

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda3;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 150
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->streamPill:Landroid/widget/TextView;

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setFocusable(Z)V

    .line 151
    sget p1, Lsx/movybench/R$id;->reload:I

    invoke-virtual {p0, p1}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda4;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 152
    sget p1, Lsx/movybench/R$id;->castBtn:I

    invoke-virtual {p0, p1}, Lsx/movybench/WebPlayerActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    new-instance v0, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda5;

    invoke-direct {v0, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda5;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 154
    invoke-virtual {p0}, Lsx/movybench/WebPlayerActivity;->getOnBackPressedDispatcher()Landroidx/activity/OnBackPressedDispatcher;

    move-result-object p1

    new-instance v0, Lsx/movybench/WebPlayerActivity$2;

    invoke-direct {v0, p0, v1}, Lsx/movybench/WebPlayerActivity$2;-><init>(Lsx/movybench/WebPlayerActivity;Z)V

    invoke-virtual {p1, p0, v0}, Landroidx/activity/OnBackPressedDispatcher;->addCallback(Landroidx/lifecycle/LifecycleOwner;Landroidx/activity/OnBackPressedCallback;)V

    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 673
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->pump:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 674
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    if-eqz v0, :cond_0

    .line 675
    invoke-virtual {v0}, Landroid/webkit/WebView;->stopLoading()V

    .line 676
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->web:Landroid/webkit/WebView;

    invoke-virtual {v0}, Landroid/webkit/WebView;->destroy()V

    .line 678
    :cond_0
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onDestroy()V

    return-void
.end method

.method public onSessionEnded(Lcom/google/android/gms/cast/framework/CastSession;I)V
    .locals 0

    const/4 p1, 0x0

    .line 188
    iput-boolean p1, p0, Lsx/movybench/WebPlayerActivity;->pendingCastSent:Z

    return-void
.end method

.method public bridge synthetic onSessionEnded(Lcom/google/android/gms/cast/framework/Session;I)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionEnded(Lcom/google/android/gms/cast/framework/CastSession;I)V

    return-void
.end method

.method public onSessionEnding(Lcom/google/android/gms/cast/framework/CastSession;)V
    .locals 0

    return-void
.end method

.method public bridge synthetic onSessionEnding(Lcom/google/android/gms/cast/framework/Session;)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1}, Lsx/movybench/WebPlayerActivity;->onSessionEnding(Lcom/google/android/gms/cast/framework/CastSession;)V

    return-void
.end method

.method public onSessionResumeFailed(Lcom/google/android/gms/cast/framework/CastSession;I)V
    .locals 0

    return-void
.end method

.method public bridge synthetic onSessionResumeFailed(Lcom/google/android/gms/cast/framework/Session;I)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionResumeFailed(Lcom/google/android/gms/cast/framework/CastSession;I)V

    return-void
.end method

.method public onSessionResumed(Lcom/google/android/gms/cast/framework/CastSession;Z)V
    .locals 0

    .line 184
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    new-instance p2, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda11;

    invoke-direct {p2, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda11;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, p2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public bridge synthetic onSessionResumed(Lcom/google/android/gms/cast/framework/Session;Z)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionResumed(Lcom/google/android/gms/cast/framework/CastSession;Z)V

    return-void
.end method

.method public onSessionResuming(Lcom/google/android/gms/cast/framework/CastSession;Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method public bridge synthetic onSessionResuming(Lcom/google/android/gms/cast/framework/Session;Ljava/lang/String;)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionResuming(Lcom/google/android/gms/cast/framework/CastSession;Ljava/lang/String;)V

    return-void
.end method

.method public onSessionStartFailed(Lcom/google/android/gms/cast/framework/CastSession;I)V
    .locals 0

    return-void
.end method

.method public bridge synthetic onSessionStartFailed(Lcom/google/android/gms/cast/framework/Session;I)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionStartFailed(Lcom/google/android/gms/cast/framework/CastSession;I)V

    return-void
.end method

.method public onSessionStarted(Lcom/google/android/gms/cast/framework/CastSession;Ljava/lang/String;)V
    .locals 0

    .line 183
    iget-object p1, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    new-instance p2, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda11;

    invoke-direct {p2, p0}, Lsx/movybench/WebPlayerActivity$$ExternalSyntheticLambda11;-><init>(Lsx/movybench/WebPlayerActivity;)V

    invoke-virtual {p1, p2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public bridge synthetic onSessionStarted(Lcom/google/android/gms/cast/framework/Session;Ljava/lang/String;)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionStarted(Lcom/google/android/gms/cast/framework/CastSession;Ljava/lang/String;)V

    return-void
.end method

.method public onSessionStarting(Lcom/google/android/gms/cast/framework/CastSession;)V
    .locals 0

    return-void
.end method

.method public bridge synthetic onSessionStarting(Lcom/google/android/gms/cast/framework/Session;)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1}, Lsx/movybench/WebPlayerActivity;->onSessionStarting(Lcom/google/android/gms/cast/framework/CastSession;)V

    return-void
.end method

.method public onSessionSuspended(Lcom/google/android/gms/cast/framework/CastSession;I)V
    .locals 0

    return-void
.end method

.method public bridge synthetic onSessionSuspended(Lcom/google/android/gms/cast/framework/Session;I)V
    .locals 0

    .line 51
    check-cast p1, Lcom/google/android/gms/cast/framework/CastSession;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/WebPlayerActivity;->onSessionSuspended(Lcom/google/android/gms/cast/framework/CastSession;I)V

    return-void
.end method

.method protected onStart()V
    .locals 2

    .line 200
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStart()V

    .line 202
    :try_start_0
    invoke-static {p0}, Lcom/google/android/gms/cast/framework/CastContext;->getSharedInstance(Landroid/content/Context;)Lcom/google/android/gms/cast/framework/CastContext;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/android/gms/cast/framework/CastContext;->getSessionManager()Lcom/google/android/gms/cast/framework/SessionManager;

    move-result-object v0

    const-class v1, Lcom/google/android/gms/cast/framework/CastSession;

    .line 203
    invoke-virtual {v0, p0, v1}, Lcom/google/android/gms/cast/framework/SessionManager;->addSessionManagerListener(Lcom/google/android/gms/cast/framework/SessionManagerListener;Ljava/lang/Class;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    return-void
.end method

.method protected onStop()V
    .locals 2

    .line 210
    :try_start_0
    invoke-static {p0}, Lcom/google/android/gms/cast/framework/CastContext;->getSharedInstance(Landroid/content/Context;)Lcom/google/android/gms/cast/framework/CastContext;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/android/gms/cast/framework/CastContext;->getSessionManager()Lcom/google/android/gms/cast/framework/SessionManager;

    move-result-object v0

    const-class v1, Lcom/google/android/gms/cast/framework/CastSession;

    .line 211
    invoke-virtual {v0, p0, v1}, Lcom/google/android/gms/cast/framework/SessionManager;->removeSessionManagerListener(Lcom/google/android/gms/cast/framework/SessionManagerListener;Ljava/lang/Class;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 214
    :catchall_0
    iget-object v0, p0, Lsx/movybench/WebPlayerActivity;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lsx/movybench/WebPlayerActivity;->pump:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 215
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onStop()V

    return-void
.end method
