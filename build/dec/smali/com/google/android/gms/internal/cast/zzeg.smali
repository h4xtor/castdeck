.class public final Lcom/google/android/gms/internal/cast/zzeg;
.super Lcom/google/android/gms/internal/cast/zzee;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"


# instance fields
.field protected final zza:Landroid/animation/Animator;

.field private final zzb:I

.field private zzc:I

.field private final zzd:Lcom/google/android/gms/internal/cast/zzek;


# direct methods
.method private constructor <init>(Landroid/animation/Animator;ILjava/lang/Runnable;)V
    .locals 0

    .line 1
    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zzee;-><init>()V

    new-instance p2, Lcom/google/android/gms/internal/cast/zzef;

    invoke-direct {p2, p0}, Lcom/google/android/gms/internal/cast/zzef;-><init>(Lcom/google/android/gms/internal/cast/zzeg;)V

    iput-object p2, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzd:Lcom/google/android/gms/internal/cast/zzek;

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzeg;->zza:Landroid/animation/Animator;

    const/4 p1, -0x1

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzb:I

    return-void
.end method

.method static bridge synthetic zzb(Lcom/google/android/gms/internal/cast/zzeg;)I
    .locals 0

    iget p0, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzc:I

    return p0
.end method

.method static bridge synthetic zzc(Lcom/google/android/gms/internal/cast/zzeg;I)V
    .locals 0

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzc:I

    return-void
.end method

.method public static zzd(Landroid/animation/Animator;ILjava/lang/Runnable;)V
    .locals 1

    .line 1
    new-instance p1, Lcom/google/android/gms/internal/cast/zzeg;

    const/4 p2, -0x1

    const/4 v0, 0x0

    invoke-direct {p1, p0, p2, v0}, Lcom/google/android/gms/internal/cast/zzeg;-><init>(Landroid/animation/Animator;ILjava/lang/Runnable;)V

    invoke-virtual {p0, p1}, Landroid/animation/Animator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    return-void
.end method

.method static bridge synthetic zze(Lcom/google/android/gms/internal/cast/zzeg;)Z
    .locals 2

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzb:I

    const/4 v1, -0x1

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    iget p0, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzc:I

    if-ltz p0, :cond_1

    const/4 p0, 0x1

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x0

    return p0
.end method


# virtual methods
.method public final onAnimationEnd(Landroid/animation/Animator;)V
    .locals 1

    .line 1
    invoke-virtual {p0, p1}, Lcom/google/android/gms/internal/cast/zzee;->zza(Landroid/animation/Animator;)Z

    move-result p1

    if-nez p1, :cond_0

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzeg;->zzd:Lcom/google/android/gms/internal/cast/zzek;

    .line 2
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzen;->zzb()Lcom/google/android/gms/internal/cast/zzen;

    move-result-object v0

    .line 3
    invoke-virtual {v0, p1}, Lcom/google/android/gms/internal/cast/zzen;->zza(Lcom/google/android/gms/internal/cast/zzek;)V

    :cond_0
    return-void
.end method
