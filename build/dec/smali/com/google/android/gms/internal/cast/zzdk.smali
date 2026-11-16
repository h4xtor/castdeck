.class public final Lcom/google/android/gms/internal/cast/zzdk;
.super Lcom/google/android/gms/internal/cast/zzdi;
.source "com.google.android.gms:play-services-cast@@21.4.0"


# instance fields
.field final synthetic zza:Lcom/google/android/gms/internal/cast/zzdl;


# direct methods
.method protected constructor <init>(Lcom/google/android/gms/internal/cast/zzdl;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzdk;->zza:Lcom/google/android/gms/internal/cast/zzdl;

    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zzdi;-><init>()V

    return-void
.end method


# virtual methods
.method public final zzd(I)V
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 1
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzdn;->zzb()Lcom/google/android/gms/cast/internal/Logger;

    move-result-object v0

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    filled-new-array {p1}, [Ljava/lang/Object;

    move-result-object p1

    const-string v1, "onError: %d"

    invoke-virtual {v0, v1, p1}, Lcom/google/android/gms/cast/internal/Logger;->d(Ljava/lang/String;[Ljava/lang/Object;)V

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzdk;->zza:Lcom/google/android/gms/internal/cast/zzdl;

    iget-object p1, p1, Lcom/google/android/gms/internal/cast/zzdl;->zzc:Lcom/google/android/gms/internal/cast/zzdn;

    .line 2
    invoke-static {p1}, Lcom/google/android/gms/internal/cast/zzdn;->zzf(Lcom/google/android/gms/internal/cast/zzdn;)V

    .line 3
    new-instance p1, Lcom/google/android/gms/internal/cast/zzdm;

    sget-object v0, Lcom/google/android/gms/common/api/Status;->RESULT_INTERNAL_ERROR:Lcom/google/android/gms/common/api/Status;

    invoke-direct {p1, v0}, Lcom/google/android/gms/internal/cast/zzdm;-><init>(Lcom/google/android/gms/common/api/Status;)V

    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzdk;->zza:Lcom/google/android/gms/internal/cast/zzdl;

    invoke-virtual {v0, p1}, Lcom/google/android/gms/internal/cast/zzdl;->setResult(Lcom/google/android/gms/common/api/Result;)V

    return-void
.end method

.method public final zzf()V
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 1
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzdn;->zzb()Lcom/google/android/gms/cast/internal/Logger;

    move-result-object v0

    const/4 v1, 0x0

    new-array v1, v1, [Ljava/lang/Object;

    const-string v2, "onDisconnected"

    invoke-virtual {v0, v2, v1}, Lcom/google/android/gms/cast/internal/Logger;->d(Ljava/lang/String;[Ljava/lang/Object;)V

    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzdk;->zza:Lcom/google/android/gms/internal/cast/zzdl;

    iget-object v0, v0, Lcom/google/android/gms/internal/cast/zzdl;->zzc:Lcom/google/android/gms/internal/cast/zzdn;

    .line 2
    invoke-static {v0}, Lcom/google/android/gms/internal/cast/zzdn;->zzf(Lcom/google/android/gms/internal/cast/zzdn;)V

    .line 3
    new-instance v0, Lcom/google/android/gms/internal/cast/zzdm;

    sget-object v1, Lcom/google/android/gms/common/api/Status;->RESULT_SUCCESS:Lcom/google/android/gms/common/api/Status;

    invoke-direct {v0, v1}, Lcom/google/android/gms/internal/cast/zzdm;-><init>(Lcom/google/android/gms/common/api/Status;)V

    iget-object v1, p0, Lcom/google/android/gms/internal/cast/zzdk;->zza:Lcom/google/android/gms/internal/cast/zzdl;

    invoke-virtual {v1, v0}, Lcom/google/android/gms/internal/cast/zzdl;->setResult(Lcom/google/android/gms/common/api/Result;)V

    return-void
.end method
