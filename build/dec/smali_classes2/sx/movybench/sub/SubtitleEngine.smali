.class public final Lsx/movybench/sub/SubtitleEngine;
.super Ljava/lang/Object;
.source "SubtitleEngine.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/sub/SubtitleEngine$Report;,
        Lsx/movybench/sub/SubtitleEngine$Callback;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static best(Ljava/util/List;)Lsx/movybench/sub/SubtitleResult;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/sub/SubtitleResult;",
            ">;)",
            "Lsx/movybench/sub/SubtitleResult;"
        }
    .end annotation

    .line 123
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    invoke-interface {p0, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lsx/movybench/sub/SubtitleResult;

    :goto_0
    return-object p0
.end method

.method private static longestWord(Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 114
    const-string v0, "\\s+"

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v0, p0

    const-string v1, ""

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_3

    aget-object v3, p0, v2

    .line 115
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v4

    const/4 v5, 0x3

    if-ge v4, v5, :cond_0

    goto :goto_1

    .line 116
    :cond_0
    const-string v4, "the"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_2

    const-string v4, "and"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_2

    const-string v4, "for"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_2

    const-string v4, "with"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    goto :goto_1

    .line 117
    :cond_1
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v4

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v5

    if-le v4, v5, :cond_2

    move-object v1, v3

    :cond_2
    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_3
    return-object v1
.end method

.method public static providers(Landroid/content/Context;)Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Lsx/movybench/sub/SubProvider;",
            ">;"
        }
    .end annotation

    .line 37
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 38
    invoke-static {p0}, Lsx/movybench/Prefs;->provOpenSubs(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 39
    new-instance v1, Lsx/movybench/sub/OpenSubsLegacy;

    invoke-direct {v1}, Lsx/movybench/sub/OpenSubsLegacy;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    invoke-static {p0}, Lsx/movybench/Prefs;->osKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    new-instance v1, Lsx/movybench/sub/OpenSubsRest;

    invoke-direct {v1}, Lsx/movybench/sub/OpenSubsRest;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 42
    :cond_0
    invoke-static {p0}, Lsx/movybench/Prefs;->provSubDl(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-static {p0}, Lsx/movybench/Prefs;->subdlKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    new-instance v1, Lsx/movybench/sub/SubDl;

    invoke-direct {v1}, Lsx/movybench/sub/SubDl;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "undertekst-kilder aktive: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "MB"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0
.end method

.method private static rank(Ljava/util/List;Lsx/movybench/sub/SubProvider$Query;)V
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/sub/SubtitleResult;",
            ">;",
            "Lsx/movybench/sub/SubProvider$Query;",
            ")V"
        }
    .end annotation

    .line 85
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_7

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lsx/movybench/sub/SubtitleResult;

    .line 87
    iget-object v2, v1, Lsx/movybench/sub/SubtitleResult;->language:Ljava/lang/String;

    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->iso2()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    iget-object v2, v1, Lsx/movybench/sub/SubtitleResult;->language:Ljava/lang/String;

    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->iso3()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_0

    goto :goto_1

    :cond_0
    const/4 v2, 0x0

    goto :goto_2

    :cond_1
    :goto_1
    const/16 v2, 0x78

    .line 88
    :goto_2
    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->isEpisode()Z

    move-result v3

    if-eqz v3, :cond_3

    .line 89
    iget v3, v1, Lsx/movybench/sub/SubtitleResult;->season:I

    iget v4, p1, Lsx/movybench/sub/SubProvider$Query;->season:I

    if-ne v3, v4, :cond_2

    iget v3, v1, Lsx/movybench/sub/SubtitleResult;->episode:I

    iget v4, p1, Lsx/movybench/sub/SubProvider$Query;->episode:I

    if-ne v3, v4, :cond_2

    add-int/lit8 v2, v2, 0x46

    goto :goto_3

    .line 90
    :cond_2
    iget v3, v1, Lsx/movybench/sub/SubtitleResult;->season:I

    if-nez v3, :cond_3

    add-int/lit8 v2, v2, 0xa

    .line 93
    :cond_3
    :goto_3
    iget-object v3, p1, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_4

    .line 94
    iget-object v3, p1, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    sget-object v4, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v3, v4}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v3

    const-string v4, "[^a-z0-9 ]"

    const-string v5, " "

    invoke-virtual {v3, v4, v5}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    .line 95
    iget-object v4, v1, Lsx/movybench/sub/SubtitleResult;->release:Ljava/lang/String;

    sget-object v5, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v4, v5}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v4

    .line 96
    invoke-static {v3}, Lsx/movybench/sub/SubtitleEngine;->longestWord(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 97
    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v5

    const/4 v6, 0x2

    if-le v5, v6, :cond_4

    invoke-virtual {v4, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_4

    add-int/lit8 v2, v2, 0x3c

    .line 99
    :cond_4
    iget-object v3, v1, Lsx/movybench/sub/SubtitleResult;->provider:Ljava/lang/String;

    const-string v4, "OpenSubtitles"

    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_5

    add-int/lit8 v2, v2, 0x19

    .line 100
    :cond_5
    iget-object v3, v1, Lsx/movybench/sub/SubtitleResult;->provider:Ljava/lang/String;

    const-string v4, "SubDL"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_6

    add-int/lit8 v2, v2, 0x12

    .line 101
    :cond_6
    iget v3, v1, Lsx/movybench/sub/SubtitleResult;->downloads:I

    div-int/lit16 v3, v3, 0x1f4

    const/16 v4, 0x28

    invoke-static {v4, v3}, Ljava/lang/Math;->min(II)I

    move-result v3

    add-int/2addr v2, v3

    .line 102
    iput v2, v1, Lsx/movybench/sub/SubtitleResult;->score:I

    goto/16 :goto_0

    .line 104
    :cond_7
    new-instance p1, Lsx/movybench/sub/SubtitleEngine$2;

    invoke-direct {p1}, Lsx/movybench/sub/SubtitleEngine$2;-><init>()V

    invoke-static {p0, p1}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    return-void
.end method

.method public static searchBlocking(Landroid/content/Context;Lsx/movybench/sub/SubProvider$Query;)Lsx/movybench/sub/SubtitleEngine$Report;
    .locals 9

    .line 47
    new-instance v0, Lsx/movybench/sub/SubtitleEngine$Report;

    invoke-direct {v0}, Lsx/movybench/sub/SubtitleEngine$Report;-><init>()V

    .line 48
    invoke-static {p0}, Lsx/movybench/Prefs;->osKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    .line 49
    invoke-static {p0}, Lsx/movybench/Prefs;->subdlKey(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x4

    .line 50
    invoke-static {v3}, Ljava/util/concurrent/Executors;->newFixedThreadPool(I)Ljava/util/concurrent/ExecutorService;

    move-result-object v3

    .line 51
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4}, Ljava/util/ArrayList;-><init>()V

    .line 52
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    .line 54
    invoke-static {p0}, Lsx/movybench/sub/SubtitleEngine;->providers(Landroid/content/Context;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_3

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lsx/movybench/sub/SubProvider;

    .line 55
    invoke-interface {v6}, Lsx/movybench/sub/SubProvider;->name()Ljava/lang/String;

    move-result-object v7

    const-string v8, "SubDL"

    invoke-virtual {v7, v8}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_0

    move-object v7, v2

    goto :goto_1

    :cond_0
    move-object v7, v1

    .line 56
    :goto_1
    invoke-interface {v6}, Lsx/movybench/sub/SubProvider;->requiresKey()Z

    move-result v8

    if-eqz v8, :cond_2

    if-eqz v7, :cond_1

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_2

    .line 57
    :cond_1
    iget-object v7, v0, Lsx/movybench/sub/SubtitleEngine$Report;->errors:Ljava/util/List;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-interface {v6}, Lsx/movybench/sub/SubProvider;->name()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v8, ": mangler API key (Settings)"

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v7, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 60
    :cond_2
    invoke-interface {v6}, Lsx/movybench/sub/SubProvider;->name()Ljava/lang/String;

    move-result-object v8

    invoke-interface {v5, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 61
    new-instance v8, Lsx/movybench/sub/SubtitleEngine$1;

    invoke-direct {v8, v6, p1, v7}, Lsx/movybench/sub/SubtitleEngine$1;-><init>(Lsx/movybench/sub/SubProvider;Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)V

    invoke-interface {v3, v8}, Ljava/util/concurrent/ExecutorService;->submit(Ljava/util/concurrent/Callable;)Ljava/util/concurrent/Future;

    move-result-object v6

    invoke-interface {v4, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_3
    const/4 p0, 0x0

    .line 68
    :goto_2
    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v1

    if-ge p0, v1, :cond_6

    .line 69
    invoke-interface {v5, p0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 71
    :try_start_0
    invoke-interface {v4, p0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/concurrent/Future;

    sget-object v6, Ljava/util/concurrent/TimeUnit;->SECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v7, 0x19

    invoke-interface {v2, v7, v8, v6}, Ljava/util/concurrent/Future;->get(JLjava/util/concurrent/TimeUnit;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/List;

    if-eqz v2, :cond_5

    .line 72
    iget-object v6, v0, Lsx/movybench/sub/SubtitleEngine$Report;->results:Ljava/util/List;

    invoke-interface {v6, v2}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_4

    :catch_0
    move-exception v2

    .line 74
    invoke-virtual {v2}, Ljava/lang/Exception;->getCause()Ljava/lang/Throwable;

    move-result-object v6

    if-nez v6, :cond_4

    goto :goto_3

    :cond_4
    invoke-virtual {v2}, Ljava/lang/Exception;->getCause()Ljava/lang/Throwable;

    move-result-object v2

    .line 75
    :goto_3
    iget-object v6, v0, Lsx/movybench/sub/SubtitleEngine$Report;->errors:Ljava/util/List;

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v7, ": "

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-static {v2}, Lsx/movybench/sub/SubtitleEngine;->shortMsg(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {v6, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_5
    :goto_4
    add-int/lit8 p0, p0, 0x1

    goto :goto_2

    .line 78
    :cond_6
    invoke-interface {v3}, Ljava/util/concurrent/ExecutorService;->shutdownNow()Ljava/util/List;

    .line 80
    iget-object p0, v0, Lsx/movybench/sub/SubtitleEngine$Report;->results:Ljava/util/List;

    invoke-static {p0, p1}, Lsx/movybench/sub/SubtitleEngine;->rank(Ljava/util/List;Lsx/movybench/sub/SubProvider$Query;)V

    return-object v0
.end method

.method private static shortMsg(Ljava/lang/Throwable;)Ljava/lang/String;
    .locals 2

    if-nez p0, :cond_0

    .line 127
    const-string p0, "ukendt fejl"

    return-object p0

    .line 128
    :cond_0
    invoke-virtual {p0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :cond_1

    .line 129
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    .line 130
    :cond_1
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result p0

    const/16 v1, 0x78

    if-le p0, v1, :cond_2

    const/4 p0, 0x0

    invoke-virtual {v0, p0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    :cond_2
    return-object v0
.end method
