.class Lsx/movybench/sub/SubtitleEngine$2;
.super Ljava/lang/Object;
.source "SubtitleEngine.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lsx/movybench/sub/SubtitleEngine;->rank(Ljava/util/List;Lsx/movybench/sub/SubProvider$Query;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Lsx/movybench/sub/SubtitleResult;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 104
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    .line 104
    check-cast p1, Lsx/movybench/sub/SubtitleResult;

    check-cast p2, Lsx/movybench/sub/SubtitleResult;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/sub/SubtitleEngine$2;->compare(Lsx/movybench/sub/SubtitleResult;Lsx/movybench/sub/SubtitleResult;)I

    move-result p1

    return p1
.end method

.method public compare(Lsx/movybench/sub/SubtitleResult;Lsx/movybench/sub/SubtitleResult;)I
    .locals 0

    .line 106
    iget p2, p2, Lsx/movybench/sub/SubtitleResult;->score:I

    iget p1, p1, Lsx/movybench/sub/SubtitleResult;->score:I

    invoke-static {p2, p1}, Ljava/lang/Integer;->compare(II)I

    move-result p1

    return p1
.end method
