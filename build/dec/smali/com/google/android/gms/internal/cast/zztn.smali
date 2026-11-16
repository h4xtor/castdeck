.class public abstract Lcom/google/android/gms/internal/cast/zztn;
.super Lcom/google/android/gms/internal/cast/zztp;
.source "com.google.android.gms:play-services-cast@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/internal/cast/zzuy;


# instance fields
.field protected final zzb:Lcom/google/android/gms/internal/cast/zztj;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 1
    invoke-direct {p0}, Lcom/google/android/gms/internal/cast/zztp;-><init>()V

    .line 2
    invoke-static {}, Lcom/google/android/gms/internal/cast/zztj;->zza()Lcom/google/android/gms/internal/cast/zztj;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/gms/internal/cast/zztn;->zzb:Lcom/google/android/gms/internal/cast/zztj;

    return-void
.end method
