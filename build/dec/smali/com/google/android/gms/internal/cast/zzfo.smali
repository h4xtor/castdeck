.class final Lcom/google/android/gms/internal/cast/zzfo;
.super Lcom/google/android/gms/internal/cast/zzfg;
.source "com.google.android.gms:play-services-cast@@21.4.0"


# instance fields
.field private final zza:Lcom/google/android/gms/internal/cast/zzfq;


# direct methods
.method constructor <init>(Lcom/google/android/gms/internal/cast/zzfq;I)V
    .locals 1

    .line 1
    invoke-virtual {p1}, Lcom/google/android/gms/internal/cast/zzfq;->size()I

    move-result v0

    invoke-direct {p0, v0, p2}, Lcom/google/android/gms/internal/cast/zzfg;-><init>(II)V

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzfo;->zza:Lcom/google/android/gms/internal/cast/zzfq;

    return-void
.end method


# virtual methods
.method protected final zza(I)Ljava/lang/Object;
    .locals 1

    .line 1
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzfo;->zza:Lcom/google/android/gms/internal/cast/zzfq;

    invoke-virtual {v0, p1}, Lcom/google/android/gms/internal/cast/zzfq;->get(I)Ljava/lang/Object;

    move-result-object p1

    return-object p1
.end method
