.class public final synthetic Lcom/google/android/gms/cast/zzbi;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/common/api/internal/RemoteCall;


# static fields
.field public static final synthetic zza:Lcom/google/android/gms/cast/zzbi;


# direct methods
.method static synthetic constructor <clinit>()V
    .locals 1

    new-instance v0, Lcom/google/android/gms/cast/zzbi;

    invoke-direct {v0}, Lcom/google/android/gms/cast/zzbi;-><init>()V

    sput-object v0, Lcom/google/android/gms/cast/zzbi;->zza:Lcom/google/android/gms/cast/zzbi;

    return-void
.end method

.method private synthetic constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final accept(Ljava/lang/Object;Ljava/lang/Object;)V
    .locals 1

    check-cast p1, Lcom/google/android/gms/cast/internal/zzx;

    check-cast p2, Lcom/google/android/gms/tasks/TaskCompletionSource;

    sget v0, Lcom/google/android/gms/cast/zzbt;->zzf:I

    .line 1
    invoke-virtual {p1}, Lcom/google/android/gms/cast/internal/zzx;->getService()Landroid/os/IInterface;

    move-result-object p1

    check-cast p1, Lcom/google/android/gms/cast/internal/zzag;

    invoke-virtual {p1}, Lcom/google/android/gms/cast/internal/zzag;->zzl()V

    const/4 p1, 0x0

    .line 2
    invoke-virtual {p2, p1}, Lcom/google/android/gms/tasks/TaskCompletionSource;->setResult(Ljava/lang/Object;)V

    return-void
.end method
