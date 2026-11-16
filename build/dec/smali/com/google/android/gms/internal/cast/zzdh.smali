.class final Lcom/google/android/gms/internal/cast/zzdh;
.super Lcom/google/android/gms/internal/cast/zzdl;
.source "com.google.android.gms:play-services-cast@@21.4.0"


# direct methods
.method constructor <init>(Lcom/google/android/gms/internal/cast/zzdn;Lcom/google/android/gms/common/api/GoogleApiClient;)V
    .locals 0

    .line 1
    invoke-direct {p0, p1, p2}, Lcom/google/android/gms/internal/cast/zzdl;-><init>(Lcom/google/android/gms/internal/cast/zzdn;Lcom/google/android/gms/common/api/GoogleApiClient;)V

    return-void
.end method


# virtual methods
.method public final bridge synthetic doExecute(Lcom/google/android/gms/common/api/Api$AnyClient;)V
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 1
    check-cast p1, Lcom/google/android/gms/internal/cast/zzdq;

    invoke-virtual {p0, p1}, Lcom/google/android/gms/internal/cast/zzdl;->zza(Lcom/google/android/gms/internal/cast/zzdq;)V

    return-void
.end method

.method public final zza(Lcom/google/android/gms/internal/cast/zzdq;)V
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzdk;

    invoke-direct {v0, p0}, Lcom/google/android/gms/internal/cast/zzdk;-><init>(Lcom/google/android/gms/internal/cast/zzdl;)V

    invoke-virtual {p1, v0}, Lcom/google/android/gms/internal/cast/zzdq;->zzs(Lcom/google/android/gms/internal/cast/zzds;)V

    return-void
.end method
