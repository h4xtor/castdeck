.class final Lcom/google/android/gms/internal/cast/zzdg;
.super Lcom/google/android/gms/internal/cast/zzdl;
.source "com.google.android.gms:play-services-cast@@21.4.0"


# instance fields
.field final synthetic zza:Ljava/lang/String;

.field final synthetic zzb:Lcom/google/android/gms/internal/cast/zzdn;


# direct methods
.method constructor <init>(Lcom/google/android/gms/internal/cast/zzdn;Lcom/google/android/gms/common/api/GoogleApiClient;Ljava/lang/String;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzdg;->zzb:Lcom/google/android/gms/internal/cast/zzdn;

    iput-object p3, p0, Lcom/google/android/gms/internal/cast/zzdg;->zza:Ljava/lang/String;

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
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/os/RemoteException;
        }
    .end annotation

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzdj;

    invoke-direct {v0, p0, p1}, Lcom/google/android/gms/internal/cast/zzdj;-><init>(Lcom/google/android/gms/internal/cast/zzdl;Lcom/google/android/gms/internal/cast/zzdq;)V

    iget-object v1, p0, Lcom/google/android/gms/internal/cast/zzdg;->zzb:Lcom/google/android/gms/internal/cast/zzdn;

    invoke-static {v1}, Lcom/google/android/gms/internal/cast/zzdn;->zzc(Lcom/google/android/gms/internal/cast/zzdn;)Lcom/google/android/gms/internal/cast/zzdv;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/gms/internal/cast/zzdg;->zza:Ljava/lang/String;

    invoke-virtual {p1, v0, v1, v2}, Lcom/google/android/gms/internal/cast/zzdq;->zzr(Lcom/google/android/gms/internal/cast/zzds;Lcom/google/android/gms/internal/cast/zzdv;Ljava/lang/String;)V

    return-void
.end method
