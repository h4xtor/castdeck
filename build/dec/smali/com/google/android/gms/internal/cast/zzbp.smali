.class public final synthetic Lcom/google/android/gms/internal/cast/zzbp;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/tasks/OnFailureListener;


# instance fields
.field public final synthetic zza:Lcom/google/android/gms/internal/cast/zzbq;

.field public final synthetic zzb:Lcom/google/android/gms/internal/cast/zzbr;


# direct methods
.method public synthetic constructor <init>(Lcom/google/android/gms/internal/cast/zzbq;Lcom/google/android/gms/internal/cast/zzbr;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzbp;->zza:Lcom/google/android/gms/internal/cast/zzbq;

    iput-object p2, p0, Lcom/google/android/gms/internal/cast/zzbp;->zzb:Lcom/google/android/gms/internal/cast/zzbr;

    return-void
.end method


# virtual methods
.method public final onFailure(Ljava/lang/Exception;)V
    .locals 3

    .line 1
    new-instance v0, Lcom/google/android/gms/common/api/Status;

    const/16 v1, 0x8

    const-string v2, "unknown error"

    invoke-direct {v0, v1, v2}, Lcom/google/android/gms/common/api/Status;-><init>(ILjava/lang/String;)V

    .line 2
    instance-of v1, p1, Lcom/google/android/gms/common/api/ApiException;

    if-eqz v1, :cond_0

    .line 3
    check-cast p1, Lcom/google/android/gms/common/api/ApiException;

    new-instance v0, Lcom/google/android/gms/common/api/Status;

    .line 4
    invoke-virtual {p1}, Lcom/google/android/gms/common/api/ApiException;->getStatusCode()I

    move-result v1

    invoke-virtual {p1}, Lcom/google/android/gms/common/api/ApiException;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, v1, p1}, Lcom/google/android/gms/common/api/Status;-><init>(ILjava/lang/String;)V

    :cond_0
    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzbp;->zza:Lcom/google/android/gms/internal/cast/zzbq;

    .line 5
    sget v1, Lcom/google/android/gms/cast/framework/CastSession;->zza:I

    .line 6
    invoke-virtual {p1, v0}, Lcom/google/android/gms/internal/cast/zzbq;->setResult(Lcom/google/android/gms/common/api/Result;)V

    return-void
.end method
