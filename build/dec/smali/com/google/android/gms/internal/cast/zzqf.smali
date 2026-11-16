.class public final Lcom/google/android/gms/internal/cast/zzqf;
.super Lcom/google/android/gms/internal/cast/zztp;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/internal/cast/zzuy;


# static fields
.field private static final zzb:Lcom/google/android/gms/internal/cast/zzqf;


# instance fields
.field private zzd:I

.field private zze:Lcom/google/android/gms/internal/cast/zzok;

.field private zzf:I

.field private zzg:I

.field private zzh:I

.field private zzi:I

.field private zzj:J

.field private zzk:Lcom/google/android/gms/internal/cast/zztx;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzqf;

    invoke-direct {v0}, Lcom/google/android/gms/internal/cast/zzqf;-><init>()V

    sput-object v0, Lcom/google/android/gms/internal/cast/zzqf;->zzb:Lcom/google/android/gms/internal/cast/zzqf;

    const-class v1, Lcom/google/android/gms/internal/cast/zzqf;

    .line 2
    invoke-static {v1, v0}, Lcom/google/android/gms/internal/cast/zztp;->zzH(Ljava/lang/Class;Lcom/google/android/gms/internal/cast/zztp;)V

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 1
    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zztp;-><init>()V

    .line 2
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzqf;->zzA()Lcom/google/android/gms/internal/cast/zztx;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/gms/internal/cast/zzqf;->zzk:Lcom/google/android/gms/internal/cast/zztx;

    return-void
.end method

.method static synthetic zza()Lcom/google/android/gms/internal/cast/zzqf;
    .locals 1

    sget-object v0, Lcom/google/android/gms/internal/cast/zzqf;->zzb:Lcom/google/android/gms/internal/cast/zzqf;

    return-object v0
.end method


# virtual methods
.method protected final zzb(ILjava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 14

    add-int/lit8 v0, p1, -0x1

    if-eqz v0, :cond_4

    const/4 v1, 0x2

    if-eq v0, v1, :cond_3

    const/4 v1, 0x3

    if-eq v0, v1, :cond_2

    const/4 v1, 0x4

    const/4 v2, 0x0

    if-eq v0, v1, :cond_1

    const/4 v1, 0x5

    if-eq v0, v1, :cond_0

    return-object v2

    .line 1
    :cond_0
    sget-object v0, Lcom/google/android/gms/internal/cast/zzqf;->zzb:Lcom/google/android/gms/internal/cast/zzqf;

    return-object v0

    :cond_1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzqe;

    .line 3
    invoke-direct {v0, v2}, Lcom/google/android/gms/internal/cast/zzqe;-><init>(Lcom/google/android/gms/internal/cast/zzms;)V

    return-object v0

    :cond_2
    new-instance v0, Lcom/google/android/gms/internal/cast/zzqf;

    .line 4
    invoke-direct {v0}, Lcom/google/android/gms/internal/cast/zzqf;-><init>()V

    return-object v0

    .line 2
    :cond_3
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzkp;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v4

    invoke-static {}, Lcom/google/android/gms/internal/cast/zzkm;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v6

    invoke-static {}, Lcom/google/android/gms/internal/cast/zzin;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v8

    invoke-static {}, Lcom/google/android/gms/internal/cast/zzhj;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v10

    const-string v12, "zzk"

    const-class v13, Lcom/google/android/gms/internal/cast/zzok;

    const-string v1, "zzd"

    const-string v2, "zze"

    const-string v3, "zzf"

    const-string v5, "zzg"

    const-string v7, "zzh"

    const-string v9, "zzi"

    const-string v11, "zzj"

    filled-new-array/range {v1 .. v13}, [Ljava/lang/Object;

    move-result-object v0

    sget-object v1, Lcom/google/android/gms/internal/cast/zzqf;->zzb:Lcom/google/android/gms/internal/cast/zzqf;

    const-string v2, "\u0001\u0007\u0000\u0001\u0001\u0007\u0007\u0000\u0001\u0000\u0001\u1009\u0000\u0002\u180c\u0001\u0003\u180c\u0002\u0004\u180c\u0003\u0005\u180c\u0004\u0006\u1002\u0005\u0007\u001b"

    invoke-static {v1, v2, v0}, Lcom/google/android/gms/internal/cast/zzqf;->zzE(Lcom/google/android/gms/internal/cast/zzux;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0

    :cond_4
    const/4 v0, 0x1

    .line 1
    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    return-object v0
.end method
