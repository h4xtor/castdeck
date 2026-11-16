.class final Lcom/google/android/gms/cast/zzdn;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/cast/internal/zzas;


# instance fields
.field final synthetic zza:Lcom/google/android/gms/cast/zzdp;


# direct methods
.method constructor <init>(Lcom/google/android/gms/cast/zzdp;)V
    .locals 0

    iput-object p1, p0, Lcom/google/android/gms/cast/zzdn;->zza:Lcom/google/android/gms/cast/zzdp;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final zza(Ljava/lang/String;JILjava/lang/Object;JJ)V
    .locals 0

    .line 1
    :try_start_0
    iget-object p1, p0, Lcom/google/android/gms/cast/zzdn;->zza:Lcom/google/android/gms/cast/zzdp;

    new-instance p2, Lcom/google/android/gms/cast/zzdq;

    new-instance p3, Lcom/google/android/gms/common/api/Status;

    invoke-direct {p3, p4}, Lcom/google/android/gms/common/api/Status;-><init>(I)V
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p4, 0x1

    instance-of p6, p5, Lcom/google/android/gms/cast/internal/zzap;

    const/4 p7, 0x0

    if-eq p4, p6, :cond_0

    move-object p5, p7

    :cond_0
    if-eqz p5, :cond_1

    :try_start_1
    check-cast p5, Lcom/google/android/gms/cast/internal/zzap;

    iget-object p7, p5, Lcom/google/android/gms/cast/internal/zzap;->zza:Lorg/json/JSONObject;

    :cond_1
    invoke-direct {p2, p3, p7}, Lcom/google/android/gms/cast/zzdq;-><init>(Lcom/google/android/gms/common/api/Status;Lorg/json/JSONObject;)V

    invoke-virtual {p1, p2}, Lcom/google/android/gms/cast/zzdp;->setResult(Lcom/google/android/gms/common/api/Result;)V
    :try_end_1
    .catch Ljava/lang/IllegalStateException; {:try_start_1 .. :try_end_1} :catch_0

    return-void

    :catch_0
    move-exception p1

    const-string p2, "RemoteMediaPlayer"

    const-string p3, "Result already set when calling onRequestCompleted"

    .line 2
    invoke-static {p2, p3, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method public final zzb(Ljava/lang/String;JJJ)V
    .locals 0

    .line 1
    :try_start_0
    iget-object p1, p0, Lcom/google/android/gms/cast/zzdn;->zza:Lcom/google/android/gms/cast/zzdp;

    new-instance p2, Lcom/google/android/gms/common/api/Status;

    const/16 p3, 0x837

    invoke-direct {p2, p3}, Lcom/google/android/gms/common/api/Status;-><init>(I)V

    new-instance p3, Lcom/google/android/gms/cast/zzdo;

    invoke-direct {p3, p1, p2}, Lcom/google/android/gms/cast/zzdo;-><init>(Lcom/google/android/gms/cast/zzdp;Lcom/google/android/gms/common/api/Status;)V

    invoke-virtual {p1, p3}, Lcom/google/android/gms/cast/zzdp;->setResult(Lcom/google/android/gms/common/api/Result;)V
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    const-string p2, "RemoteMediaPlayer"

    const-string p3, "Result already set when calling onRequestReplaced"

    .line 2
    invoke-static {p2, p3, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method
