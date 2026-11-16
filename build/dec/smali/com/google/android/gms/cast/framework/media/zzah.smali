.class final Lcom/google/android/gms/cast/framework/media/zzah;
.super Lcom/google/android/gms/cast/framework/media/zzbk;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"


# instance fields
.field final synthetic zza:Lcom/google/android/gms/cast/MediaQueueItem;

.field final synthetic zzb:I

.field final synthetic zzc:J

.field final synthetic zzd:Lorg/json/JSONObject;

.field final synthetic zze:Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;


# direct methods
.method constructor <init>(Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;Lcom/google/android/gms/cast/MediaQueueItem;IJLorg/json/JSONObject;)V
    .locals 0

    .line 1
    iput-object p1, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zze:Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;

    iput-object p2, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zza:Lcom/google/android/gms/cast/MediaQueueItem;

    iput p3, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zzb:I

    iput-wide p4, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zzc:J

    iput-object p6, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zzd:Lorg/json/JSONObject;

    const/4 p2, 0x0

    invoke-direct {p0, p1, p2}, Lcom/google/android/gms/cast/framework/media/zzbk;-><init>(Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;Z)V

    return-void
.end method


# virtual methods
.method protected final zza()V
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lcom/google/android/gms/cast/internal/zzao;
        }
    .end annotation

    .line 1
    iget-object v0, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zza:Lcom/google/android/gms/cast/MediaQueueItem;

    iget-object v1, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zze:Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;

    invoke-static {v1}, Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;->zze(Lcom/google/android/gms/cast/framework/media/RemoteMediaClient;)Lcom/google/android/gms/cast/internal/zzaq;

    move-result-object v2

    invoke-virtual {p0}, Lcom/google/android/gms/cast/framework/media/zzbk;->zzb()Lcom/google/android/gms/cast/internal/zzas;

    move-result-object v3

    const/4 v1, 0x1

    new-array v4, v1, [Lcom/google/android/gms/cast/MediaQueueItem;

    const/4 v1, 0x0

    aput-object v0, v4, v1

    iget-wide v8, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zzc:J

    iget-object v10, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zzd:Lorg/json/JSONObject;

    iget v5, p0, Lcom/google/android/gms/cast/framework/media/zzah;->zzb:I

    const/4 v6, 0x0

    const/4 v7, 0x0

    .line 2
    invoke-virtual/range {v2 .. v10}, Lcom/google/android/gms/cast/internal/zzaq;->zzw(Lcom/google/android/gms/cast/internal/zzas;[Lcom/google/android/gms/cast/MediaQueueItem;IIIJLorg/json/JSONObject;)J

    return-void
.end method
