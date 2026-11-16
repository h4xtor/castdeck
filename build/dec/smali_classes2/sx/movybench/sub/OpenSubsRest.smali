.class public final Lsx/movybench/sub/OpenSubsRest;
.super Ljava/lang/Object;
.source "OpenSubsRest.java"

# interfaces
.implements Lsx/movybench/sub/SubProvider;


# static fields
.field private static final BASE:Ljava/lang/String; = "https://api.opensubtitles.com/api/v1"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static headers(Ljava/lang/String;)Ljava/util/Map;
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 79
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 80
    const-string v1, "Api-Key"

    invoke-interface {v0, v1, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 81
    const-string p0, "User-Agent"

    const-string v1, "MovieBench v1.0"

    invoke-interface {v0, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 82
    const-string p0, "Accept"

    const-string v1, "application/json"

    invoke-interface {v0, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-object v0
.end method


# virtual methods
.method public download(Lsx/movybench/sub/SubtitleResult;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 67
    invoke-static {p2}, Lsx/movybench/sub/OpenSubsRest;->headers(Ljava/lang/String;)Ljava/util/Map;

    move-result-object v0

    .line 68
    const-string v1, "Content-Type"

    const-string v2, "application/json"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 69
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "{\"file_id\":"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, p1, Lsx/movybench/sub/SubtitleResult;->payload:Ljava/lang/String;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "}"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 70
    new-instance v1, Ljava/lang/String;

    const-string v2, "https://api.opensubtitles.com/api/v1/download"

    invoke-static {v2, p1, v0}, Lsx/movybench/Http;->post(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object p1

    const-string v0, "UTF-8"

    invoke-direct {v1, p1, v0}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 71
    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 72
    const-string v0, "link"

    const-string v1, ""

    invoke-virtual {p1, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 73
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    .line 74
    invoke-static {p2}, Lsx/movybench/sub/OpenSubsRest;->headers(Ljava/lang/String;)Ljava/util/Map;

    move-result-object p2

    invoke-static {p1, p2}, Lsx/movybench/Http;->get(Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object p1

    .line 75
    invoke-static {p1}, Lsx/movybench/sub/Srt;->extract([B)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 73
    :cond_0
    new-instance p1, Ljava/lang/Exception;

    const-string p2, "OpenSubtitles gav intet link"

    invoke-direct {p1, p2}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public keyHint()Ljava/lang/String;
    .locals 1

    .line 19
    const-string v0, "opensubtitles.com \u2192 API key"

    return-object v0
.end method

.method public name()Ljava/lang/String;
    .locals 1

    .line 18
    const-string v0, "OpenSubtitles (API)"

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

    .line 24
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-eqz p2, :cond_b

    .line 25
    invoke-virtual/range {p2 .. p2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    goto/16 :goto_4

    .line 27
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "https://api.opensubtitles.com/api/v1/subtitles?languages="

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual/range {p1 .. p1}, Lsx/movybench/sub/SubProvider$Query;->iso2()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 28
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

    .line 29
    :cond_1
    const-string v3, "&query="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v5, v0, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    invoke-static {v5, v4}, Ljava/net/URLEncoder;->encode(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 30
    :goto_0
    invoke-virtual/range {p1 .. p1}, Lsx/movybench/sub/SubProvider$Query;->isEpisode()Z

    move-result v3

    if-eqz v3, :cond_2

    .line 31
    const-string v3, "&type=episode&season_number="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v5, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "&episode_number="

    .line 32
    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v5, v0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 34
    :cond_2
    const-string v3, "&type=movie"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 36
    :goto_1
    iget-object v3, v0, Lsx/movybench/sub/SubProvider$Query;->year:Ljava/lang/String;

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_3

    const-string v3, "&year="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v5, v0, Lsx/movybench/sub/SubProvider$Query;->year:Ljava/lang/String;

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 38
    :cond_3
    new-instance v3, Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static/range {p2 .. p2}, Lsx/movybench/sub/OpenSubsRest;->headers(Ljava/lang/String;)Ljava/util/Map;

    move-result-object v5

    invoke-static {v2, v5}, Lsx/movybench/Http;->get(Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object v2

    invoke-direct {v3, v2, v4}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 39
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 40
    const-string v3, "data"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    if-nez v2, :cond_4

    return-object v1

    :cond_4
    const/4 v3, 0x0

    move v4, v3

    .line 43
    :goto_2
    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-ge v4, v5, :cond_b

    const/16 v5, 0x3c

    if-ge v4, v5, :cond_b

    .line 44
    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v5

    if-nez v5, :cond_5

    goto :goto_3

    .line 46
    :cond_5
    const-string v6, "attributes"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    if-nez v5, :cond_6

    goto :goto_3

    .line 48
    :cond_6
    const-string v6, "files"

    invoke-virtual {v5, v6}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v6

    if-eqz v6, :cond_a

    .line 49
    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I

    move-result v7

    if-nez v7, :cond_7

    goto :goto_3

    .line 50
    :cond_7
    invoke-virtual {v6, v3}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v6

    if-nez v6, :cond_8

    goto :goto_3

    .line 52
    :cond_8
    const-string v7, "file_id"

    const-string v8, ""

    invoke-virtual {v6, v7, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v13

    .line 53
    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_9

    goto :goto_3

    .line 54
    :cond_9
    new-instance v6, Lsx/movybench/sub/SubtitleResult;

    const-string v7, "language"

    .line 55
    invoke-virtual/range {p1 .. p1}, Lsx/movybench/sub/SubProvider$Query;->iso2()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v5, v7, v9}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    const-string v7, "feature_details"

    .line 56
    invoke-virtual {v5, v7, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "release"

    invoke-virtual {v5, v8, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    const-string v7, "season_number"

    iget v8, v0, Lsx/movybench/sub/SubProvider$Query;->season:I

    .line 58
    invoke-virtual {v5, v7, v8}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v14

    const-string v7, "episode_number"

    iget v8, v0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    .line 59
    invoke-virtual {v5, v7, v8}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v15

    const-string v7, "download_count"

    .line 60
    invoke-virtual {v5, v7, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v16

    const-string v10, "OpenSubtitles API"

    move-object v9, v6

    invoke-direct/range {v9 .. v16}, Lsx/movybench/sub/SubtitleResult;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;III)V

    .line 54
    invoke-interface {v1, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_a
    :goto_3
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    :cond_b
    :goto_4
    return-object v1
.end method
