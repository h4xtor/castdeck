.class public abstract Lcom/google/android/gms/internal/cast/zzek;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"


# instance fields
.field private zza:Ljava/lang/Runnable;

.field private zzb:Landroid/view/Choreographer$FrameCallback;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public abstract zza(J)V
.end method

.method final zzb()Landroid/view/Choreographer$FrameCallback;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzek;->zzb:Landroid/view/Choreographer$FrameCallback;

    if-nez v0, :cond_0

    new-instance v0, Lcom/google/android/gms/internal/cast/zzei;

    invoke-direct {v0, p0}, Lcom/google/android/gms/internal/cast/zzei;-><init>(Lcom/google/android/gms/internal/cast/zzek;)V

    iput-object v0, p0, Lcom/google/android/gms/internal/cast/zzek;->zzb:Landroid/view/Choreographer$FrameCallback;

    :cond_0
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzek;->zzb:Landroid/view/Choreographer$FrameCallback;

    return-object v0
.end method

.method final zzc()Ljava/lang/Runnable;
    .locals 1

    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzek;->zza:Ljava/lang/Runnable;

    if-nez v0, :cond_0

    new-instance v0, Lcom/google/android/gms/internal/cast/zzej;

    invoke-direct {v0, p0}, Lcom/google/android/gms/internal/cast/zzej;-><init>(Lcom/google/android/gms/internal/cast/zzek;)V

    iput-object v0, p0, Lcom/google/android/gms/internal/cast/zzek;->zza:Ljava/lang/Runnable;

    :cond_0
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzek;->zza:Ljava/lang/Runnable;

    return-object v0
.end method
