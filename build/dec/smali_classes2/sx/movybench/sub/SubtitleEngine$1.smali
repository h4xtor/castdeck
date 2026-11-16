.class Lsx/movybench/sub/SubtitleEngine$1;
.super Ljava/lang/Object;
.source "SubtitleEngine.java"

# interfaces
.implements Ljava/util/concurrent/Callable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lsx/movybench/sub/SubtitleEngine;->searchBlocking(Landroid/content/Context;Lsx/movybench/sub/SubProvider$Query;)Lsx/movybench/sub/SubtitleEngine$Report;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/concurrent/Callable<",
        "Ljava/util/List<",
        "Lsx/movybench/sub/SubtitleResult;",
        ">;>;"
    }
.end annotation


# instance fields
.field final synthetic val$key:Ljava/lang/String;

.field final synthetic val$p:Lsx/movybench/sub/SubProvider;

.field final synthetic val$q:Lsx/movybench/sub/SubProvider$Query;


# direct methods
.method constructor <init>(Lsx/movybench/sub/SubProvider;Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 61
    iput-object p1, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$p:Lsx/movybench/sub/SubProvider;

    iput-object p2, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$q:Lsx/movybench/sub/SubProvider$Query;

    iput-object p3, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public bridge synthetic call()Ljava/lang/Object;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 61
    invoke-virtual {p0}, Lsx/movybench/sub/SubtitleEngine$1;->call()Ljava/util/List;

    move-result-object v0

    return-object v0
.end method

.method public call()Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
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

    .line 63
    iget-object v0, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$p:Lsx/movybench/sub/SubProvider;

    iget-object v1, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$q:Lsx/movybench/sub/SubProvider$Query;

    iget-object v2, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$key:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Lsx/movybench/sub/SubProvider;->search(Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_r

    const-wide/16 v0, 0x190

    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V

    iget-object v0, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$p:Lsx/movybench/sub/SubProvider;

    iget-object v1, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$q:Lsx/movybench/sub/SubProvider$Query;

    iget-object v2, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$key:Ljava/lang/String;

    invoke-interface {v0, v1, v2}, Lsx/movybench/sub/SubProvider;->search(Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)Ljava/util/List;

    move-result-object v3

    :cond_r
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "sog '"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lsx/movybench/sub/SubtitleEngine$1;->val$p:Lsx/movybench/sub/SubProvider;

    invoke-interface {v2}, Lsx/movybench/sub/SubProvider;->name()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "': "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " resultater"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "MB"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object v3
.end method
