.class final Lcom/google/android/gms/internal/cast/zzdf;
.super Lcom/google/android/gms/internal/cast/zzdu;
.source "com.google.android.gms:play-services-cast@@21.4.0"


# instance fields
.field final synthetic zza:Lcom/google/android/gms/internal/cast/zzdn;


# direct methods
.method constructor <init>(Lcom/google/android/gms/internal/cast/zzdn;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzdf;->zza:Lcom/google/android/gms/internal/cast/zzdn;

    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zzdu;-><init>()V

    return-void
.end method


# virtual methods
.method public final zzb(I)V
    .locals 2

    .line 1
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzdn;->zzb()Lcom/google/android/gms/cast/internal/Logger;

    move-result-object p1

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/Object;

    const-string v1, "onRemoteDisplayEnded"

    invoke-virtual {p1, v1, v0}, Lcom/google/android/gms/cast/internal/Logger;->d(Ljava/lang/String;[Ljava/lang/Object;)V

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzdf;->zza:Lcom/google/android/gms/internal/cast/zzdn;

    .line 2
    invoke-static {p1}, Lcom/google/android/gms/internal/cast/zzdn;->zzf(Lcom/google/android/gms/internal/cast/zzdn;)V

    return-void
.end method
