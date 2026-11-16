.class public final Lsx/movybench/SubtitleOverlay;
.super Ljava/lang/Object;
.source "SubtitleOverlay.java"


# instance fields
.field private cues:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lsx/movybench/sub/Srt$Cue;",
            ">;"
        }
    .end annotation
.end field

.field private fullscreen:Landroid/widget/TextView;

.field private inline:Landroid/widget/TextView;

.field private lastIndex:I


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 17
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    const/4 v0, -0x1

    .line 18
    iput v0, p0, Lsx/movybench/SubtitleOverlay;->lastIndex:I

    return-void
.end method

.method private static show(Landroid/widget/TextView;Ljava/lang/String;)V
    .locals 1

    if-nez p0, :cond_0

    return-void

    :cond_0
    if-eqz p1, :cond_3

    .line 61
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    .line 64
    :cond_1
    invoke-virtual {p0}, Landroid/widget/TextView;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_2

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setVisibility(I)V

    .line 65
    :cond_2
    invoke-virtual {p0}, Landroid/widget/TextView;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->contentEquals(Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_4

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 62
    :cond_3
    :goto_0
    invoke-virtual {p0}, Landroid/widget/TextView;->getVisibility()I

    move-result p1

    const/16 v0, 0x8

    if-eq p1, v0, :cond_4

    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_4
    :goto_1
    return-void
.end method


# virtual methods
.method public active()Z
    .locals 1

    .line 39
    iget-object v0, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    return v0
.end method

.method public bind(Landroid/widget/TextView;Landroid/widget/TextView;)V
    .locals 0

    .line 23
    iput-object p1, p0, Lsx/movybench/SubtitleOverlay;->inline:Landroid/widget/TextView;

    .line 24
    iput-object p2, p0, Lsx/movybench/SubtitleOverlay;->fullscreen:Landroid/widget/TextView;

    return-void
.end method

.method public clear()V
    .locals 2

    .line 34
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    const/4 v0, -0x1

    .line 35
    iput v0, p0, Lsx/movybench/SubtitleOverlay;->lastIndex:I

    const-wide/16 v0, -0x1

    .line 36
    invoke-virtual {p0, v0, v1}, Lsx/movybench/SubtitleOverlay;->render(J)V

    return-void
.end method

.method public count()I
    .locals 1

    .line 41
    iget-object v0, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    return v0
.end method

.method public render(J)V
    .locals 5

    :try_s2

    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    .line 45
    const-string v1, ""

    if-ltz v0, :cond_4

    iget-object v0, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_4

    const/4 v0, 0x0

    .line 47
    :goto_0
    iget-object v2, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    if-ge v0, v2, :cond_2

    .line 48
    iget-object v2, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lsx/movybench/sub/Srt$Cue;

    .line 49
    iget-wide v3, v2, Lsx/movybench/sub/Srt$Cue;->start:J

    cmp-long v3, p1, v3

    if-ltz v3, :cond_0

    iget-wide v3, v2, Lsx/movybench/sub/Srt$Cue;->end:J

    cmp-long v3, p1, v3

    if-gez v3, :cond_0

    goto :goto_2

    .line 50
    :cond_0
    iget-wide v2, v2, Lsx/movybench/sub/Srt$Cue;->start:J

    cmp-long v2, v2, p1

    if-lez v2, :cond_1

    goto :goto_1

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_2
    :goto_1
    const/4 v0, -0x1

    :goto_2
    if-ltz v0, :cond_3

    .line 52
    iget-object p1, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lsx/movybench/sub/Srt$Cue;

    iget-object p1, p1, Lsx/movybench/sub/Srt$Cue;->text:Ljava/lang/String;

    move-object v1, p1

    .line 53
    :cond_3
    iput v0, p0, Lsx/movybench/SubtitleOverlay;->lastIndex:I

    .line 55
    :cond_4
    iget-object p1, p0, Lsx/movybench/SubtitleOverlay;->inline:Landroid/widget/TextView;

    invoke-static {p1, v1}, Lsx/movybench/SubtitleOverlay;->show(Landroid/widget/TextView;Ljava/lang/String;)V

    .line 56
    iget-object p1, p0, Lsx/movybench/SubtitleOverlay;->fullscreen:Landroid/widget/TextView;

    invoke-static {p1, v1}, Lsx/movybench/SubtitleOverlay;->show(Landroid/widget/TextView;Ljava/lang/String;)V

    :try_e2

    return-void

    .catch Ljava/lang/Throwable; {:try_s2 .. :try_e2} :catch_2

    :catch_2
    move-exception p1

    invoke-static {p1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object p1

    const-string v1, "SubtitleOverlay.render fejlede: "

    invoke-virtual {v1, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v0, "MB"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public set(Ljava/lang/String;)V
    .locals 2

    :try_s1
    invoke-static {p1}, Lsx/movybench/CastRemote;->onSubs(Ljava/lang/String;)V

    .line 28
    invoke-static {p1}, Lsx/movybench/sub/Srt;->cues(Ljava/lang/String;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lsx/movybench/SubtitleOverlay;->cues:Ljava/util/List;

    const/4 p1, -0x1

    .line 29
    iput p1, p0, Lsx/movybench/SubtitleOverlay;->lastIndex:I

    const-wide/16 v0, -0x1

    .line 30
    invoke-virtual {p0, v0, v1}, Lsx/movybench/SubtitleOverlay;->render(J)V
    :try_e1

    return-void

    .catch Ljava/lang/Throwable; {:try_s1 .. :try_e1} :catch_1

    :catch_1
    move-exception p1

    invoke-static {p1}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object p1

    const-string v1, "SubtitleOverlay.set fejlede: "

    invoke-virtual {v1, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v0, "MB"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

.end method
