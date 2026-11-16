.class public final synthetic Lsx/movybench/CastHelper$$ExternalSyntheticLambda0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Lcom/google/android/gms/common/api/ResultCallback;


# instance fields
.field public final synthetic f$0:Lsx/movybench/CastHelper$Result;


# direct methods
.method public synthetic constructor <init>(Lsx/movybench/CastHelper$Result;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lsx/movybench/CastHelper$$ExternalSyntheticLambda0;->f$0:Lsx/movybench/CastHelper$Result;

    return-void
.end method


# virtual methods
.method public final onResult(Lcom/google/android/gms/common/api/Result;)V
    .locals 1

    .line 0
    iget-object v0, p0, Lsx/movybench/CastHelper$$ExternalSyntheticLambda0;->f$0:Lsx/movybench/CastHelper$Result;

    check-cast p1, Lcom/google/android/gms/cast/framework/media/RemoteMediaClient$MediaChannelResult;

    invoke-static {v0, p1}, Lsx/movybench/CastHelper;->lambda$load$0(Lsx/movybench/CastHelper$Result;Lcom/google/android/gms/cast/framework/media/RemoteMediaClient$MediaChannelResult;)V

    return-void
.end method
