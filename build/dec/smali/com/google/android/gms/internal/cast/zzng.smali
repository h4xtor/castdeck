.class public final Lcom/google/android/gms/internal/cast/zzng;
.super Lcom/google/android/gms/internal/cast/zztp;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/internal/cast/zzuy;


# static fields
.field private static final zzb:Lcom/google/android/gms/internal/cast/zzng;


# instance fields
.field private zzd:I

.field private zze:Lcom/google/android/gms/internal/cast/zzok;

.field private zzf:Z

.field private zzg:J

.field private zzh:I

.field private zzi:I

.field private zzj:I

.field private zzk:I

.field private zzl:I

.field private zzm:Lcom/google/android/gms/internal/cast/zzqd;

.field private zzn:I

.field private zzo:I

.field private zzp:Z

.field private zzq:I

.field private zzr:I

.field private zzs:Z


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzng;

    invoke-direct {v0}, Lcom/google/android/gms/internal/cast/zzng;-><init>()V

    sput-object v0, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    const-class v1, Lcom/google/android/gms/internal/cast/zzng;

    invoke-static {v1, v0}, Lcom/google/android/gms/internal/cast/zztp;->zzH(Ljava/lang/Class;Lcom/google/android/gms/internal/cast/zztp;)V

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 1
    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zztp;-><init>()V

    return-void
.end method

.method public static zza()Lcom/google/android/gms/internal/cast/zznf;
    .locals 1

    .line 1
    sget-object v0, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    invoke-virtual {v0}, Lcom/google/android/gms/internal/cast/zztp;->zzv()Lcom/google/android/gms/internal/cast/zztm;

    move-result-object v0

    check-cast v0, Lcom/google/android/gms/internal/cast/zznf;

    return-object v0
.end method

.method public static zzc(Lcom/google/android/gms/internal/cast/zzng;)Lcom/google/android/gms/internal/cast/zznf;
    .locals 1

    .line 1
    sget-object v0, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    invoke-virtual {v0}, Lcom/google/android/gms/internal/cast/zztp;->zzv()Lcom/google/android/gms/internal/cast/zztm;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/google/android/gms/internal/cast/zztm;->zzp(Lcom/google/android/gms/internal/cast/zztp;)Lcom/google/android/gms/internal/cast/zztm;

    .line 2
    check-cast v0, Lcom/google/android/gms/internal/cast/zznf;

    return-object v0
.end method

.method static synthetic zzd()Lcom/google/android/gms/internal/cast/zzng;
    .locals 1

    sget-object v0, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    return-object v0
.end method

.method public static zze()Lcom/google/android/gms/internal/cast/zzng;
    .locals 1

    sget-object v0, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    return-object v0
.end method

.method static synthetic zzf(Lcom/google/android/gms/internal/cast/zzng;Lcom/google/android/gms/internal/cast/zzok;)V
    .locals 0

    .line 1
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zze:Lcom/google/android/gms/internal/cast/zzok;

    iget p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit8 p1, p1, 0x1

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    return-void
.end method

.method static synthetic zzg(Lcom/google/android/gms/internal/cast/zzng;Z)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit8 v0, v0, 0x2

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput-boolean p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzf:Z

    return-void
.end method

.method static synthetic zzh(Lcom/google/android/gms/internal/cast/zzng;J)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit8 v0, v0, 0x4

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput-wide p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzg:J

    return-void
.end method

.method static synthetic zzi(Lcom/google/android/gms/internal/cast/zzng;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit8 v0, v0, 0x40

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzk:I

    return-void
.end method

.method static synthetic zzj(Lcom/google/android/gms/internal/cast/zzng;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit16 v0, v0, 0x80

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzl:I

    return-void
.end method

.method static synthetic zzk(Lcom/google/android/gms/internal/cast/zzng;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit16 v0, v0, 0x400

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzo:I

    return-void
.end method

.method static synthetic zzl(Lcom/google/android/gms/internal/cast/zzng;Z)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit16 v0, v0, 0x800

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput-boolean p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzp:Z

    return-void
.end method

.method static synthetic zzm(Lcom/google/android/gms/internal/cast/zzng;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit16 v0, v0, 0x1000

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzq:I

    return-void
.end method

.method static synthetic zzn(Lcom/google/android/gms/internal/cast/zzng;I)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit16 v0, v0, 0x2000

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzr:I

    return-void
.end method

.method static synthetic zzo(Lcom/google/android/gms/internal/cast/zzng;Z)V
    .locals 1

    iget v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    or-int/lit16 v0, v0, 0x4000

    iput v0, p0, Lcom/google/android/gms/internal/cast/zzng;->zzd:I

    iput-boolean p1, p0, Lcom/google/android/gms/internal/cast/zzng;->zzs:Z

    return-void
.end method


# virtual methods
.method protected final zzb(ILjava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .locals 20

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
    sget-object v0, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    return-object v0

    :cond_1
    new-instance v0, Lcom/google/android/gms/internal/cast/zznf;

    .line 3
    invoke-direct {v0, v2}, Lcom/google/android/gms/internal/cast/zznf;-><init>(Lcom/google/android/gms/internal/cast/zzms;)V

    return-object v0

    :cond_2
    new-instance v0, Lcom/google/android/gms/internal/cast/zzng;

    invoke-direct {v0}, Lcom/google/android/gms/internal/cast/zzng;-><init>()V

    return-object v0

    .line 2
    :cond_3
    invoke-static {}, Lcom/google/android/gms/internal/cast/zzhd;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v7

    invoke-static {}, Lcom/google/android/gms/internal/cast/zzha;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v9

    invoke-static {}, Lcom/google/android/gms/internal/cast/zziq;->zza()Lcom/google/android/gms/internal/cast/zztt;

    move-result-object v14

    const-string v18, "zzr"

    const-string v19, "zzs"

    const-string v1, "zzd"

    const-string v2, "zze"

    const-string v3, "zzf"

    const-string v4, "zzg"

    const-string v5, "zzh"

    const-string v6, "zzi"

    const-string v8, "zzj"

    const-string v10, "zzk"

    const-string v11, "zzl"

    const-string v12, "zzm"

    const-string v13, "zzn"

    const-string v15, "zzo"

    const-string v16, "zzp"

    const-string v17, "zzq"

    filled-new-array/range {v1 .. v19}, [Ljava/lang/Object;

    move-result-object v0

    sget-object v1, Lcom/google/android/gms/internal/cast/zzng;->zzb:Lcom/google/android/gms/internal/cast/zzng;

    const-string v2, "\u0001\u000f\u0000\u0001\u0001\u000f\u000f\u0000\u0000\u0000\u0001\u1009\u0000\u0002\u1007\u0001\u0003\u1005\u0002\u0004\u1006\u0003\u0005\u180c\u0004\u0006\u180c\u0005\u0007\u1004\u0006\u0008\u1004\u0007\t\u1009\u0008\n\u180c\t\u000b\u1004\n\u000c\u1007\u000b\r\u1004\u000c\u000e\u1004\r\u000f\u1007\u000e"

    invoke-static {v1, v2, v0}, Lcom/google/android/gms/internal/cast/zzng;->zzE(Lcom/google/android/gms/internal/cast/zzux;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    return-object v0

    :cond_4
    const/4 v0, 0x1

    .line 1
    invoke-static {v0}, Ljava/lang/Byte;->valueOf(B)Ljava/lang/Byte;

    move-result-object v0

    return-object v0
.end method
