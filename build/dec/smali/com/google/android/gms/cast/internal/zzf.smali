.class public final synthetic Lcom/google/android/gms/cast/internal/zzf;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/common/api/internal/RemoteCall;


# instance fields
.field public final synthetic zza:Lcom/google/android/gms/cast/internal/zzn;

.field public final synthetic zzb:[Ljava/lang/String;

.field public final synthetic zzc:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/google/android/gms/cast/internal/zzn;[Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/gms/cast/internal/zzf;->zza:Lcom/google/android/gms/cast/internal/zzn;

    iput-object p2, p0, Lcom/google/android/gms/cast/internal/zzf;->zzb:[Ljava/lang/String;

    iput-object p3, p0, Lcom/google/android/gms/cast/internal/zzf;->zzc:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;Ljava/lang/Object;)V
    .locals 3

    check-cast p1, Lcom/google/android/gms/cast/internal/zzo;

    check-cast p2, Lcom/google/android/gms/tasks/TaskCompletionSource;

    .line 1
    new-instance v0, Lcom/google/android/gms/cast/internal/zzj;

    iget-object v1, p0, Lcom/google/android/gms/cast/internal/zzf;->zza:Lcom/google/android/gms/cast/internal/zzn;

    invoke-direct {v0, v1, p2}, Lcom/google/android/gms/cast/internal/zzj;-><init>(Lcom/google/android/gms/cast/internal/zzn;Lcom/google/android/gms/tasks/TaskCompletionSource;)V

    .line 2
    invoke-virtual {p1}, Lcom/google/android/gms/cast/internal/zzo;->getService()Landroid/os/IInterface;

    move-result-object p1

    check-cast p1, Lcom/google/android/gms/cast/internal/zzaj;

    iget-object p2, p0, Lcom/google/android/gms/cast/internal/zzf;->zzb:[Ljava/lang/String;

    iget-object v1, p0, Lcom/google/android/gms/cast/internal/zzf;->zzc:Ljava/lang/String;

    const/4 v2, 0x0

    .line 3
    invoke-virtual {p1, v0, p2, v1, v2}, Lcom/google/android/gms/cast/internal/zzaj;->zze(Lcom/google/android/gms/common/api/internal/IStatusCallback;[Ljava/lang/String;Ljava/lang/String;Ljava/util/List;)V

    return-void
.end method
