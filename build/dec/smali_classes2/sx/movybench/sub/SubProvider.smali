.class public interface abstract Lsx/movybench/sub/SubProvider;
.super Ljava/lang/Object;
.source "SubProvider.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/sub/SubProvider$Query;
    }
.end annotation


# virtual methods
.method public abstract download(Lsx/movybench/sub/SubtitleResult;Ljava/lang/String;)Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation
.end method

.method public abstract keyHint()Ljava/lang/String;
.end method

.method public abstract name()Ljava/lang/String;
.end method

.method public abstract requiresKey()Z
.end method

.method public abstract search(Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lsx/movybench/sub/SubProvider$Query;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lsx/movybench/sub/SubtitleResult;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation
.end method
