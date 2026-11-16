.class public final Lsx/movybench/sub/SubDl;
.super Ljava/lang/Object;
.source "SubDl.java"

# interfaces
.implements Lsx/movybench/sub/SubProvider;


# static fields
.field private static final BASE:Ljava/lang/String; = "https://api.subdl.com/api/v1/subtitles"

.field private static final CDN:Ljava/lang/String; = "https://dl.subdl.com"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public download(Lsx/movybench/sub/SubtitleResult;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 61
    iget-object p1, p1, Lsx/movybench/sub/SubtitleResult;->payload:Ljava/lang/String;

    const/4 p2, 0x0

    invoke-static {p1, p2}, Lsx/movybench/Http;->get(Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object p1

    invoke-static {p1}, Lsx/movybench/sub/Srt;->extract([B)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method public keyHint()Ljava/lang/String;
    .locals 1

    .line 18
    const-string v0, "subdl.com \u2192 API key"

    return-object v0
.end method

.method public name()Ljava/lang/String;
    .locals 1

    .line 17
    const-string v0, "SubDL"

    return-object v0
.end method

.method public requiresKey()Z
    .locals 1

    const/4 v0, 0x1

    return v0
.end method

.method public search(Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)Ljava/util/List;
    .locals 17
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

    move-object/from16 v0, p1

    .line 23
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-eqz p2, :cond_7

    .line 24
    invoke-virtual/range {p2 .. p2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    goto/16 :goto_5

    .line 26
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "https://api.subdl.com/api/v1/subtitles?api_key="

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 27
    invoke-virtual/range {p2 .. p2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "&languages="

    .line 28
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual/range {p1 .. p1}, Lsx/movybench/sub/SubProvider$Query;->iso2()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "&subs_per_page=30"

    .line 29
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 30
    iget-object v3, v0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    const-string v4, "UTF-8"

    if-nez v3, :cond_1

    const-string v3, "&imdb_id="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v5, v0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 31
    :cond_1
    const-string v3, "&film_name="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v5, v0, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    invoke-static {v5, v4}, Ljava/net/URLEncoder;->encode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 32
    :goto_0
    invoke-virtual/range {p1 .. p1}, Lsx/movybench/sub/SubProvider$Query;->isEpisode()Z

    move-result v3

    if-eqz v3, :cond_2

    .line 33
    const-string v3, "&type=tv&season_number="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v5, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "&episode_number="

    .line 34
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v5, v0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 36
    :cond_2
    const-string v3, "&type=movie"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 39
    :goto_1
    new-instance v3, Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v5, 0x0

    invoke-static {v2, v5}, Lsx/movybench/Http;->get(Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object v2

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 40
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 41
    const-string v3, "subtitles"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-nez v2, :cond_3

    return-object v1

    :cond_3
    const/4 v3, 0x0

    move v4, v3

    .line 44
    :goto_2
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-ge v4, v5, :cond_7

    const/16 v5, 0x3c

    if-ge v4, v5, :cond_7

    .line 45
    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    if-nez v5, :cond_4

    goto :goto_4

    .line 47
    :cond_4
    const-string v6, "url"

    const-string v7, ""

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 48
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_5

    goto :goto_4

    .line 49
    :cond_5
    new-instance v8, Lsx/movybench/sub/SubtitleResult;

    const-string v9, "language"

    .line 50
    invoke-virtual/range {p1 .. p1}, Lsx/movybench/sub/SubProvider$Query;->iso2()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v5, v9, v10}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    const-string v9, "name"

    .line 51
    invoke-virtual {v5, v9, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v9, "release_name"

    invoke-virtual {v5, v9, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    .line 52
    const-string v7, "http"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_6

    goto :goto_3

    :cond_6
    new-instance v7, Ljava/lang/StringBuilder;

    const-string v9, "https://dl.subdl.com"

    invoke-direct {v7, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    :goto_3
    move-object v13, v6

    iget v14, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    iget v15, v0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    const-string v6, "downloads"

    .line 54
    invoke-virtual {v5, v6, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v16

    const-string v10, "SubDL"

    move-object v9, v8

    invoke-direct/range {v9 .. v16}, Lsx/movybench/sub/SubtitleResult;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;III)V

    .line 49
    invoke-interface {v1, v8}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :goto_4
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    :cond_7
    :goto_5
    return-object v1
.end method
