.class public final Lsx/movybench/CastHelper;
.super Ljava/lang/Object;
.source "CastHelper.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/CastHelper$Result;
    }
.end annotation


# static fields
.field private static final KEY_SUBTITLE:Ljava/lang/String; = "com.google.android.gms.cast.metadata.SUBTITLE"

.field private static final KEY_TITLE:Ljava/lang/String; = "com.google.android.gms.cast.metadata.TITLE"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static contentType(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 95
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    .line 96
    const-string v0, ".m3u8"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_3

    const-string v0, "playlist"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    .line 97
    :cond_0
    const-string v0, ".webm"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "video/webm"

    return-object p0

    .line 98
    :cond_1
    const-string v0, ".mkv"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_2

    const-string p0, "video/x-matroska"

    return-object p0

    .line 99
    :cond_2
    const-string p0, "video/mp4"

    return-object p0

    .line 96
    :cond_3
    :goto_0
    const-string p0, "application/x-mpegURL"

    return-object p0
.end method

.method public static isConnected(Landroid/content/Context;)Z
    .locals 0

    .line 42
    invoke-static {p0}, Lsx/movybench/CastHelper;->session(Landroid/content/Context;)Lcom/google/android/gms/cast/framework/CastSession;

    move-result-object p0

    if-eqz p0, :cond_0

    .line 43
    invoke-virtual {p0}, Lcom/google/android/gms/cast/framework/CastSession;->isConnected()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method static synthetic lambda$load$0(Lsx/movybench/CastHelper$Result;Lcom/google/android/gms/cast/framework/media/RemoteMediaClient$MediaChannelResult;)V
    .locals 2

    .line 86
    invoke-interface {p1}, Lcom/google/android/gms/cast/framework/media/RemoteMediaClient$MediaChannelResult;->getStatus()Lcom/google/android/gms/common/api/Status;

    move-result-object v0

    invoke-virtual {v0}, Lcom/google/android/gms/common/api/Status;->isSuccess()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p1, 0x1

    const-string v0, "Sender til TV"

    invoke-interface {p0, p1, v0}, Lsx/movybench/CastHelper$Result;->onResult(ZLjava/lang/String;)V

    goto :goto_0

    .line 87
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Cast afvist: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-interface {p1}, Lcom/google/android/gms/cast/framework/media/RemoteMediaClient$MediaChannelResult;->getStatus()Lcom/google/android/gms/common/api/Status;

    move-result-object p1

    invoke-virtual {p1}, Lcom/google/android/gms/common/api/Status;->getStatusMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const/4 v0, 0x0

    invoke-interface {p0, v0, p1}, Lsx/movybench/CastHelper$Result;->onResult(ZLjava/lang/String;)V

    :goto_0
    return-void
.end method

.method public static load(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lsx/movybench/CastHelper$Result;)V
    .locals 5

    invoke-static {p0, p1}, Lsx/movybench/CastProxy;->wrap(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const-string v1, "mb:skip"

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :mb_go

    return-void

    :mb_go
    const/4 v0, 0x0

    .line 62
    :try_start_0
    invoke-static {p0}, Lsx/movybench/CastHelper;->session(Landroid/content/Context;)Lcom/google/android/gms/cast/framework/CastSession;

    move-result-object p0

    if-eqz p0, :cond_4

    .line 63
    invoke-virtual {p0}, Lcom/google/android/gms/cast/framework/CastSession;->isConnected()Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_0

    .line 67
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/gms/cast/framework/CastSession;->getRemoteMediaClient()Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;

    move-result-object p0

    if-nez p0, :cond_1

    .line 69
    const-string p0, "Cast-sessionen er ikke klar"

    invoke-interface {p4, v0, p0}, Lsx/movybench/CastHelper$Result;->onResult(ZLjava/lang/String;)V

    return-void

    .line 72
    :cond_1
    new-instance v1, Lcom/google/android/gms/cast/MediaMetadata;

    const/4 v2, 0x1

    invoke-direct {v1, v2}, Lcom/google/android/gms/cast/MediaMetadata;-><init>(I)V

    .line 73
    const-string v3, "com.google.android.gms.cast.metadata.TITLE"

    invoke-static {p2}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_2

    const-string p2, "Stream"

    :cond_2
    invoke-virtual {v1, v3, p2}, Lcom/google/android/gms/cast/MediaMetadata;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 74
    invoke-static {p3}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p2

    if-nez p2, :cond_3

    const-string p2, "com.google.android.gms.cast.metadata.SUBTITLE"

    invoke-virtual {v1, p2, p3}, Lcom/google/android/gms/cast/MediaMetadata;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 76
    :cond_3
    new-instance p2, Lcom/google/android/gms/cast/MediaInfo$Builder;

    invoke-direct {p2, p1}, Lcom/google/android/gms/cast/MediaInfo$Builder;-><init>(Ljava/lang/String;)V

    .line 77
    invoke-virtual {p2, v2}, Lcom/google/android/gms/cast/MediaInfo$Builder;->setStreamType(I)Lcom/google/android/gms/cast/MediaInfo$Builder;

    move-result-object p2

    .line 78
    invoke-static {p1}, Lsx/movybench/CastHelper;->contentType(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Lcom/google/android/gms/cast/MediaInfo$Builder;->setContentType(Ljava/lang/String;)Lcom/google/android/gms/cast/MediaInfo$Builder;

    move-result-object p1

    .line 79
    invoke-virtual {p1, v1}, Lcom/google/android/gms/cast/MediaInfo$Builder;->setMetadata(Lcom/google/android/gms/cast/MediaMetadata;)Lcom/google/android/gms/cast/MediaInfo$Builder;

    move-result-object p1

    .line 80
    invoke-virtual {p1}, Lcom/google/android/gms/cast/MediaInfo$Builder;->build()Lcom/google/android/gms/cast/MediaInfo;

    move-result-object p1

    .line 81
    new-instance p2, Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;

    invoke-direct {p2}, Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;-><init>()V

    .line 82
    invoke-virtual {p2, p1}, Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;->setMediaInfo(Lcom/google/android/gms/cast/MediaInfo;)Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;

    move-result-object p1

    .line 83
    invoke-static {v2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p2

    invoke-virtual {p1, p2}, Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;->setAutoplay(Ljava/lang/Boolean;)Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;

    move-result-object p1

    .line 84
    invoke-virtual {p1}, Lcom/google/android/gms/cast/MediaLoadRequestData$Builder;->build()Lcom/google/android/gms/cast/MediaLoadRequestData;

    move-result-object p1

    .line 85
    invoke-virtual {p0, p1}, Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;->load(Lcom/google/android/gms/cast/MediaLoadRequestData;)Lcom/google/android/gms/common/api/PendingResult;

    move-result-object p0

    new-instance p1, Lsx/movybench/CastHelper$$ExternalSyntheticLambda0;

    invoke-direct {p1, p4}, Lsx/movybench/CastHelper$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/CastHelper$Result;)V

    invoke-virtual {p0, p1}, Lcom/google/android/gms/common/api/PendingResult;->setResultCallback(Lcom/google/android/gms/common/api/ResultCallback;)V

    goto :goto_1

    .line 64
    :cond_4
    :goto_0
    const-string p0, "Ingen cast-session \u2014 tryk p\u00e5 cast-knappen f\u00f8rst"

    invoke-interface {p4, v0, p0}, Lsx/movybench/CastHelper$Result;->onResult(ZLjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception p0

    .line 90
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "Cast fejl: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {p4, v0, p0}, Lsx/movybench/CastHelper$Result;->onResult(ZLjava/lang/String;)V

    :goto_1
    return-void
.end method

.method public static openPicker(Landroid/app/Activity;)V
    .locals 3

    .line 49
    :try_start_0
    new-instance v0, Landroidx/mediarouter/media/MediaRouteSelector$Builder;

    invoke-direct {v0}, Landroidx/mediarouter/media/MediaRouteSelector$Builder;-><init>()V

    .line 50
    invoke-static {p0}, Lsx/movybench/Prefs;->receiverId(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/gms/cast/CastMediaControlIntent;->categoryForCast(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroidx/mediarouter/media/MediaRouteSelector$Builder;->addControlCategory(Ljava/lang/String;)Landroidx/mediarouter/media/MediaRouteSelector$Builder;

    move-result-object v0

    .line 51
    invoke-virtual {v0}, Landroidx/mediarouter/media/MediaRouteSelector$Builder;->build()Landroidx/mediarouter/media/MediaRouteSelector;

    move-result-object v0

    .line 52
    new-instance v1, Landroidx/mediarouter/app/MediaRouteChooserDialog;

    const/4 v2, 0x0

    invoke-direct {v1, p0, v2}, Landroidx/mediarouter/app/MediaRouteChooserDialog;-><init>(Landroid/content/Context;I)V

    .line 53
    invoke-virtual {v1, v0}, Landroidx/mediarouter/app/MediaRouteChooserDialog;->setRouteSelector(Landroidx/mediarouter/media/MediaRouteSelector;)V

    .line 54
    invoke-virtual {v1}, Landroidx/mediarouter/app/MediaRouteChooserDialog;->show()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    return-void
.end method

.method private static session(Landroid/content/Context;)Lcom/google/android/gms/cast/framework/CastSession;
    .locals 0

    .line 34
    :try_start_0
    invoke-static {p0}, Lcom/google/android/gms/cast/framework/CastContext;->getSharedInstance(Landroid/content/Context;)Lcom/google/android/gms/cast/framework/CastContext;

    move-result-object p0

    invoke-virtual {p0}, Lcom/google/android/gms/cast/framework/CastContext;->getSessionManager()Lcom/google/android/gms/cast/framework/SessionManager;

    move-result-object p0

    .line 35
    invoke-virtual {p0}, Lcom/google/android/gms/cast/framework/SessionManager;->getCurrentCastSession()Lcom/google/android/gms/cast/framework/CastSession;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object p0

    :catchall_0
    const/4 p0, 0x0

    return-object p0
.end method
