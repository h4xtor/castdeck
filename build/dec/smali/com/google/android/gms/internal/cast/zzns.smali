.class public final Lcom/google/android/gms/internal/cast/zzns;
.super Lcom/google/android/gms/internal/cast/zztp;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/internal/cast/zzuy;


# static fields
.field private static final zzb:Lcom/google/android/gms/internal/cast/zzns;


# instance fields
.field private zzd:I

.field private zze:I

.field private zzf:I

.field private zzg:I

.field private zzh:Z


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzns;

    invoke-direct {v0}, Lcom/google/android/gms/internal/cast/zzns;-><init>()V

    sput-object v0, Lcom/google/android/gms/internal/cast/zzns;->zzb:Lcom/google/android/gms/internal/cast/zzns;

    const-class v1, Lcom/google/android/gms/internal/cast/zzns;

    invoke-static {v1, v0}, Lcom/google/android/gms/internal/cast/zztp;->zzH(Ljava/lang/Class;Lcom/google/android/gms/internal/cast/zztp;)V

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 1
    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zztp;-><init>()V

    return-void
.end method

.method public static zza()Lcom/google/android/gms/internal/cast/zznr;
    .locals 1

    .line 1
    sget-object v0, Lcom/google/android/gms/internal/cast/zzns;->zzb:Lcom/google/android/gms/internal/cast/zzns;

    invoke-virtual {v0}, Lcom/google/android/gms/internal/cast/zztp;->zzv()Lcom/google/android/gms/internal/cast/zztm;

    move-result-object v0

    check-cast v0, Lcom/google/android/gms/internal/cast/zznr;

    return-object v0
.end method

.method static synthetic zzc()Lcom/google/android/gms/internal/cast/zzns;
    .locals 1

    sget-object v0, Lcom/google/android/gms/internal/cast/zzns;->zzb:Lcom/google/android/gms/internal/cast/zzns;

    return-object v0
.end method

.method static synthetic zzd(Lcom/google/android/gms/internal/cast/zzns;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    or-int/lit8 v0, v0, 0x2

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzns;->zzf:I

    return-void
.end method

.method static synthetic zze(Lcom/google/android/gms/internal/cast/zzns;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    or-int/lit8 v0, v0, 0x4

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzns;->zzg:I

    return-void
.end method

.method static synthetic zzf(Lcom/google/android/gms/internal/cast/zzns;Z)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    or-int/lit8 v0, v0, 0x8

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    iput-boolean p1, p0, Lcom/google/android/gms/internal/cast/zzns;->zzh:Z

    return-void
.end method

.method static synthetic zzg(Lcom/google/android/gms/internal/cast/zzns;I)V
    .locals 0

    add-int/lit8 p1, p1, -0x1

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzns;->zze:I

    iget p1, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    or-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzns;->zzd:I

    return-void
.end method


# virtual methods
.method protected final zzb(ILjava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 6

    add-int/lit8 p1, p1, -0x1

    if-eqz p1, :cond_4

    const/4 p2, 0x2

    if-eq p1, p2, :cond_3

    const/4 p2, 0x3

    if-eq p1, p2, :cond_2

    const/4 p2, 0x4

    const/4 p3, 0x0

    if-eq p1, p2, :cond_1

    const/4 p2, 0x5

    if-eq p1, p2, :cond_0

    return-object p3

    .line 1
    :cond_0
    sget-object p1, Lcom/google/android/gms/internal/cast/zzns;->zzb:Lcom/google/android/gms/internal/cast/zzns;

    return-object p1

    :cond_1
    new-instance p1, Lcom/google/android/gms/internal/cast/zznr;

    .line 3
    invoke-direct {p1, p3}, Lcom/google/android/gms/internal/cast/zznr;-><init>(Lcom/google/android/gms/internal/cast/zzms;)V

    return-object p1

    :cond_2
    new-instance p1, Lcom/google/android/gms/internal/cast/zzns;

    invoke-direct {p1}, Lcom/google/android/gms/internal/cast/zzns;-><init>()V

    return-object p1

    .line 2
    :cond_3
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzlh;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v2

    const-string v4, "zzg"

    const-string v5, "zzh"

    const-string v0, "zzd"

    const-string v1, "zze"

    const-string v3, "zzf"

    filled-new-array/range {v0 .. v5}, [Ljava/lang/Object;

    move-result-object p1

    sget-object p2, Lcom/google/android/gms/internal/cast/zzns;->zzb:Lcom/google/android/gms/internal/cast/zzns;

    const-string p3, "\u0001\u0004\u0000\u0001\u0001\u0004\u0004\u0000\u0000\u0000\u0001\u180c\u0000\u0002\u1004\u0001\u0003\u1004\u0002\u0004\u1007\u0003"

    invoke-static {p2, p3, p1}, Lcom/google/android/gms/internal/cast/zzns;->zzE(Lcom/google/android/gms/internal/cast/zzux;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    return-object p1

    :cond_4
    const/4 p1, 0x1

    .line 1
    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object p1

    return-object p1
.end method
