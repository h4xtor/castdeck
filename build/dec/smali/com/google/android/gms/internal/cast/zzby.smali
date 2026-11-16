.class final Lcom/google/android/gms/internal/cast/zzby;
.super Ljava/lang/Object;
.source "com.google.android.gms:play-services-cast-framework@@21.4.0"

# interfaces
.implements Lcom/google/android/gms/cast/framework/media/internal/zza;


# instance fields
.field final synthetic zza:Lcom/google/android/gms/internal/cast/zzca;


# direct methods
.method constructor <init>(Lcom/google/android/gms/internal/cast/zzca;)V
    .locals 0

    iput-object p1, p0, Lcom/google/android/gms/internal/cast/zzby;->zza:Lcom/google/android/gms/internal/cast/zzca;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final zza(Landroid/graphics/Bitmap;)V
    .locals 2

    if-eqz p1, :cond_1

    .line 1
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzby;->zza:Lcom/google/android/gms/internal/cast/zzca;

    invoke-static {v0}, Lcom/google/android/gms/internal/cast/zzca;->zza(Lcom/google/android/gms/internal/cast/zzca;)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_0

    invoke-static {v0}, Lcom/google/android/gms/internal/cast/zzca;->zza(Lcom/google/android/gms/internal/cast/zzca;)Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x4

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_0
    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzby;->zza:Lcom/google/android/gms/internal/cast/zzca;

    invoke-static {v0}, Lcom/google/android/gms/internal/cast/zzca;->zzb(Lcom/google/android/gms/internal/cast/zzca;)Landroid/widget/ImageView;

    move-result-object v0

    const/4 v1, 0x0

    .line 2
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setVisibility(I)V

    iget-object v0, p0, Lcom/google/android/gms/internal/cast/zzby;->zza:Lcom/google/android/gms/internal/cast/zzca;

    invoke-static {v0}, Lcom/google/android/gms/internal/cast/zzca;->zzb(Lcom/google/android/gms/internal/cast/zzca;)Landroid/widget/ImageView;

    move-result-object v0

    .line 3
    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    iget-object p1, p0, Lcom/google/android/gms/internal/cast/zzby;->zza:Lcom/google/android/gms/internal/cast/zzca;

    invoke-static {p1}, Lcom/google/android/gms/internal/cast/zzca;->zzc(Lcom/google/android/gms/internal/cast/zzca;)Lcom/google/android/gms/internal/cast/zzbz;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-static {p1}, Lcom/google/android/gms/internal/cast/zzca;->zzc(Lcom/google/android/gms/internal/cast/zzca;)Lcom/google/android/gms/internal/cast/zzbz;

    move-result-object p1

    .line 4
    invoke-virtual {p1}, Lcom/google/android/gms/internal/cast/zzbz;->zza()V

    :cond_1
    return-void
.end method
