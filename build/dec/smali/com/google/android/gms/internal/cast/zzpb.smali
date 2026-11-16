.class public final Lcom/google/android/gms/internal/cast/zzpb;
.super Lcom/google/android/gms/internal/cast/zztp;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/internal/cast/zzuy;


# static fields
.field private static final zzb:Lcom/google/android/gms/internal/cast/zzpb;


# instance fields
.field private zzd:I

.field private zze:Lcom/google/android/gms/internal/cast/zztx;

.field private zzf:Z

.field private zzg:Z

.field private zzh:J

.field private zzi:J

.field private zzj:J


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzpb;

    invoke-direct {v0}, Lcom/google/android/gms/internal/cast/zzpb;-><init>()V

    sput-object v0, Lcom/google/android/gms/internal/cast/zzpb;->zzb:Lcom/google/android/gms/internal/cast/zzpb;

    const-class v1, Lcom/google/android/gms/internal/cast/zzpb;

    .line 2
    invoke-static {v1, v0}, Lcom/google/android/gms/internal/cast/zztp;->zzH(Ljava/lang/Class;Lcom/google/android/gms/internal/cast/zztp;)V

    return-void
.end method

.method private constructor <init>()V
    .locals 1

    .line 1
    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zztp;-><init>()V

    .line 2
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzpb;->zzA()Lcom/google/android/gms/internal/cast/zztx;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/gms/internal/cast/zzpb;->zze:Lcom/google/android/gms/internal/cast/zztx;

    return-void
.end method

.method static synthetic zza()Lcom/google/android/gms/internal/cast/zzpb;
    .locals 1

    sget-object v0, Lcom/google/android/gms/internal/cast/zzpb;->zzb:Lcom/google/android/gms/internal/cast/zzpb;

    return-object v0
.end method


# virtual methods
.method protected final zzb(ILjava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 8

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
    sget-object p1, Lcom/google/android/gms/internal/cast/zzpb;->zzb:Lcom/google/android/gms/internal/cast/zzpb;

    return-object p1

    :cond_1
    new-instance p1, Lcom/google/android/gms/internal/cast/zzpa;

    .line 3
    invoke-direct {p1, p3}, Lcom/google/android/gms/internal/cast/zzpa;-><init>(Lcom/google/android/gms/internal/cast/zzms;)V

    return-object p1

    :cond_2
    new-instance p1, Lcom/google/android/gms/internal/cast/zzpb;

    .line 4
    invoke-direct {p1}, Lcom/google/android/gms/internal/cast/zzpb;-><init>()V

    return-object p1

    .line 2
    :cond_3
    const-class v2, Lcom/google/android/gms/internal/cast/zzot;

    const-string v6, "zzi"

    const-string v7, "zzj"

    const-string v0, "zzd"

    const-string v1, "zze"

    const-string v3, "zzf"

    const-string v4, "zzg"

    const-string v5, "zzh"

    filled-new-array/range {v0 .. v7}, [Ljava/lang/Object;

    move-result-object p1

    sget-object p2, Lcom/google/android/gms/internal/cast/zzpb;->zzb:Lcom/google/android/gms/internal/cast/zzpb;

    const-string p3, "\u0001\u0006\u0000\u0001\u0001\u0006\u0006\u0000\u0001\u0000\u0001\u001b\u0002\u1007\u0000\u0003\u1007\u0001\u0004\u1002\u0002\u0005\u1002\u0003\u0006\u1002\u0004"

    invoke-static {p2, p3, p1}, Lcom/google/android/gms/internal/cast/zzpb;->zzE(Lcom/google/android/gms/internal/cast/zzux;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    return-object p1

    :cond_4
    const/4 p1, 0x1

    .line 1
    invoke-static {p1}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object p1

    return-object p1
.end method
