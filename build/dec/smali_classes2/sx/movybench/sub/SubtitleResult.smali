.class public final Lsx/movybench/sub/SubtitleResult;
.super Ljava/lang/Object;
.source "SubtitleResult.java"


# instance fields
.field public final downloads:I

.field public final episode:I

.field public final language:Ljava/lang/String;

.field public final payload:Ljava/lang/String;

.field public final provider:Ljava/lang/String;

.field public final release:Ljava/lang/String;

.field public score:I

.field public final season:I


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;III)V
    .locals 0

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 18
    iput-object p1, p0, Lsx/movybench/sub/SubtitleResult;->provider:Ljava/lang/String;

    .line 19
    const-string p1, ""

    if-nez p2, :cond_0

    move-object p2, p1

    :cond_0
    iput-object p2, p0, Lsx/movybench/sub/SubtitleResult;->language:Ljava/lang/String;

    if-nez p3, :cond_1

    move-object p3, p1

    .line 20
    :cond_1
    iput-object p3, p0, Lsx/movybench/sub/SubtitleResult;->release:Ljava/lang/String;

    if-nez p4, :cond_2

    move-object p4, p1

    .line 21
    :cond_2
    iput-object p4, p0, Lsx/movybench/sub/SubtitleResult;->payload:Ljava/lang/String;

    .line 22
    iput p5, p0, Lsx/movybench/sub/SubtitleResult;->season:I

    .line 23
    iput p6, p0, Lsx/movybench/sub/SubtitleResult;->episode:I

    .line 24
    iput p7, p0, Lsx/movybench/sub/SubtitleResult;->downloads:I

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 5

    .line 29
    iget-object v0, p0, Lsx/movybench/sub/SubtitleResult;->language:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v0

    .line 30
    iget-object v1, p0, Lsx/movybench/sub/SubtitleResult;->release:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x2e

    if-le v1, v2, :cond_0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lsx/movybench/sub/SubtitleResult;->release:Ljava/lang/String;

    const/4 v4, 0x0

    invoke-virtual {v3, v4, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\u2026"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0

    :cond_0
    iget-object v1, p0, Lsx/movybench/sub/SubtitleResult;->release:Ljava/lang/String;

    .line 31
    :goto_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "  \u00b7  "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v3, p0, Lsx/movybench/sub/SubtitleResult;->provider:Ljava/lang/String;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v1, "release ukendt"

    :cond_1
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
