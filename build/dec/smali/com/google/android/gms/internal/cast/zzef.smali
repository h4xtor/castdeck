.class final Lcom/google/android/gms/internal/cast/zzef;
.super Lcom/google/android/gms/internal/cast/zzek;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"


# instance fields
.field final synthetic zza:Lcom/google/android/gms/internal/cast/zzeg;


# direct methods
.method constructor <init>(Lcom/google/android/gms/internal/cast/zzeg;)V
    .locals 0

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzef;->zza:Lcom/google/android/gms/internal/cast/zzeg;

    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zzek;-><init>()V

    return-void
.end method


# virtual methods
.method public final zza(J)V
    .locals 0

    .line 1
    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzef;->zza:Lcom/google/android/gms/internal/cast/zzeg;

    invoke-static {p1}, Lcom/google/android/gms/internal/cast/zzeg;->zzb(Lcom/google/android/gms/internal/cast/zzeg;)I

    move-result p2

    add-int/lit8 p2, p2, 0x1

    invoke-static {p1, p2}, Lcom/google/android/gms/internal/cast/zzeg;->zzc(Lcom/google/android/gms/internal/cast/zzeg;I)V

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzef;->zza:Lcom/google/android/gms/internal/cast/zzeg;

    iget-object p2, p1, Lcom/google/android/gms/internal/cast/zzeg;->zza:Landroid/animation/Animator;

    .line 2
    invoke-virtual {p1, p2}, Lcom/google/android/gms/internal/cast/zzee;->zza(Landroid/animation/Animator;)Z

    move-result p1

    if-nez p1, :cond_0

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzef;->zza:Lcom/google/android/gms/internal/cast/zzeg;

    iget-object p1, p1, Lcom/google/android/gms/internal/cast/zzeg;->zza:Landroid/animation/Animator;

    invoke-virtual {p1}, Landroid/animation/Animator;->isStarted()Z

    move-result p1

    if-nez p1, :cond_0

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzef;->zza:Lcom/google/android/gms/internal/cast/zzeg;

    invoke-static {p1}, Lcom/google/android/gms/internal/cast/zzeg;->zze(Lcom/google/android/gms/internal/cast/zzeg;)Z

    move-result p2

    if-nez p2, :cond_0

    iget-object p1, p1, Lcom/google/android/gms/internal/cast/zzeg;->zza:Landroid/animation/Animator;

    .line 3
    invoke-virtual {p1}, Landroid/animation/Animator;->start()V

    :cond_0
    return-void
.end method
