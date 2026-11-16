.class public final synthetic Lcom/google/android/gms/internal/cast/zzdb;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic zza:Lcom/google/android/gms/internal/cast/zzdd;

.field public final synthetic zzb:Lcom/google/android/gms/internal/cast/zzcz;


# direct methods
.method public synthetic constructor <init>(Lcom/google/android/gms/internal/cast/zzdd;Lcom/google/android/gms/internal/cast/zzcz;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzdb;->zza:Lcom/google/android/gms/internal/cast/zzdd;

    iput-object p2, p0, Lcom/google/android/gms/internal/cast/zzdb;->zzb:Lcom/google/android/gms/internal/cast/zzcz;

    return-void
.end method


# virtual methods
.method public final run()V
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzdb;->zza:Lcom/google/android/gms/internal/cast/zzdd;

    invoke-virtual {v0}, Lcom/google/android/gms/internal/cast/zzdd;->zze()Z

    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzdb;->zzb:Lcom/google/android/gms/internal/cast/zzcz;

    invoke-interface {v0}, Lcom/google/android/gms/internal/cast/zzcz;->zza()V

    return-void
.end method
