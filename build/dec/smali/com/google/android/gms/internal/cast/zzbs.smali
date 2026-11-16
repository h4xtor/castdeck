.class public final Lcom/google/android/gms/internal/cast/zzbs;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"


# direct methods
.method public static zza(Lcom/google/android/gms/tasks/Task;Lcom/google/android/gms/internal/cast/zzbr;Lcom/google/android/gms/internal/cast/zzbr;)Lcom/google/android/gms/common/api/PendingResult;
    .locals 2

    .line 1
    new-instance v0, Lcom/google/android/gms/internal/cast/zzbq;

    invoke-direct {v0, p2}, Lcom/google/android/gms/internal/cast/zzbq;-><init>(Lcom/google/android/gms/internal/cast/zzbr;)V

    .line 2
    new-instance v1, Lcom/google/android/gms/internal/cast/zzbo;

    invoke-direct {v1, v0, p1}, Lcom/google/android/gms/internal/cast/zzbo;-><init>(Lcom/google/android/gms/internal/cast/zzbq;Lcom/google/android/gms/internal/cast/zzbr;)V

    invoke-virtual {p0, v1}, Lcom/google/android/gms/tasks/Task;->addOnSuccessListener(Lcom/google/android/gms/tasks/OnSuccessListener;)Lcom/google/android/gms/tasks/Task;

    move-result-object p0

    new-instance p1, Lcom/google/android/gms/internal/cast/zzbp;

    invoke-direct {p1, v0, p2}, Lcom/google/android/gms/internal/cast/zzbp;-><init>(Lcom/google/android/gms/internal/cast/zzbq;Lcom/google/android/gms/internal/cast/zzbr;)V

    .line 3
    invoke-virtual {p0, p1}, Lcom/google/android/gms/tasks/Task;->addOnFailureListener(Lcom/google/android/gms/tasks/OnFailureListener;)Lcom/google/android/gms/tasks/Task;

    return-object v0
.end method
