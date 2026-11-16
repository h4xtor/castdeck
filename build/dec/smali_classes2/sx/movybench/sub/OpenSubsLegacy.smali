.class public final Lsx/movybench/sub/OpenSubsLegacy;
.super Ljava/lang/Object;
.source "OpenSubsLegacy.java"

# interfaces
.implements Lsx/movybench/sub/SubProvider;


# static fields
.field private static final ENDPOINT:Ljava/lang/String; = "http://api.opensubtitles.org/xml-rpc"

.field private static final P_MEMBER:Ljava/util/regex/Pattern;

.field private static final P_TOKEN:Ljava/util/regex/Pattern;

.field private static final UA:Ljava/lang/String; = "MovieBench v1.0"


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 25
    const-string v0, "<name>token</name><value><string>([^<]+)</string>"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/sub/OpenSubsLegacy;->P_TOKEN:Ljava/util/regex/Pattern;

    .line 27
    const-string v0, "<member><name>([^<]+)</name><value><string>(.*?)</string></value></member>"

    const/16 v1, 0x20

    invoke-static {v0, v1}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;I)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/sub/OpenSubsLegacy;->P_MEMBER:Ljava/util/regex/Pattern;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static emit(Ljava/util/Map;Ljava/util/List;Lsx/movybench/sub/SubProvider$Query;)V
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/List<",
            "Lsx/movybench/sub/SubtitleResult;",
            ">;",
            "Lsx/movybench/sub/SubProvider$Query;",
            ")V"
        }
    .end annotation

    .line 90
    const-string v0, "SubDownloadLink"

    invoke-static {p0, v0}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 91
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v0, "ZipDownloadLink"

    invoke-static {p0, v0}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 92
    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v0, "downloadlink"

    invoke-static {p0, v0}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    move-object v5, v0

    .line 93
    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_2

    return-void

    .line 94
    :cond_2
    const-string v0, "SubLanguageID"

    invoke-static {p0, v0}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 95
    const-string v1, "MovieReleaseName"

    invoke-static {p0, v1}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 96
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_3

    const-string v1, "SubFileName"

    invoke-static {p0, v1}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 97
    :cond_3
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_4

    const-string v1, "MovieName"

    invoke-static {p0, v1}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :cond_4
    move-object v4, v1

    .line 98
    new-instance v9, Lsx/movybench/sub/SubtitleResult;

    .line 99
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_5

    invoke-virtual {p2}, Lsx/movybench/sub/SubProvider$Query;->iso3()Ljava/lang/String;

    move-result-object v0

    :cond_5
    move-object v3, v0

    iget v6, p2, Lsx/movybench/sub/SubProvider$Query;->season:I

    iget v7, p2, Lsx/movybench/sub/SubProvider$Query;->episode:I

    const-string p2, "SubDownloadsCnt"

    .line 100
    invoke-static {p0, p2}, Lsx/movybench/sub/OpenSubsLegacy;->get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lsx/movybench/sub/OpenSubsLegacy;->parseInt(Ljava/lang/String;)I

    move-result v8

    const-string v2, "OpenSubtitles"

    move-object v1, v9

    invoke-direct/range {v1 .. v8}, Lsx/movybench/sub/SubtitleResult;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;III)V

    .line 98
    invoke-interface {p1, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method private static esc(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 154
    const-string v0, "&"

    const-string v1, "&amp;"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "<"

    const-string v1, "&lt;"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, ">"

    const-string v1, "&gt;"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static get(Ljava/util/Map;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 104
    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    if-nez p0, :cond_0

    .line 105
    const-string p0, ""

    :cond_0
    return-object p0
.end method

.method private login()Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 122
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 123
    const-string v1, "User-Agent"

    const-string v2, "MovieBench v1.0"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 124
    const-string v1, "Content-Type"

    const-string v2, "text/xml"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 125
    new-instance v1, Ljava/lang/String;

    const-string v2, "http://api.opensubtitles.org/xml-rpc"

    const-string v3, "<?xml version=\"1.0\"?><methodCall><methodName>LogIn</methodName><params><param><value><string></string></value></param><param><value><string></string></value></param><param><value><string>en</string></value></param><param><value><string>MovieBench v1.0</string></value></param></params></methodCall>"

    invoke-static {v2, v3, v0}, Lsx/movybench/Http;->post(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object v0

    const-string v2, "UTF-8"

    invoke-direct {v1, v0, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 126
    sget-object v0, Lsx/movybench/sub/OpenSubsLegacy;->P_TOKEN:Ljava/util/regex/Pattern;

    invoke-virtual {v0, v1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v0

    .line 127
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->find()Z

    move-result v2

    if-eqz v2, :cond_0

    const/4 v1, 0x1

    .line 128
    invoke-virtual {v0, v1}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v0

    return-object v0

    .line 127
    :cond_0
    new-instance v0, Ljava/lang/Exception;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "OpenSubtitles login afvist: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v1}, Lsx/movybench/sub/OpenSubsLegacy;->statusOf(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private logout(Ljava/lang/String;)V
    .locals 3

    const-string v0, "<?xml version=\"1.0\"?><methodCall><methodName>LogOut</methodName><params><param><value><string>"

    .line 133
    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "</string></value></param></params></methodCall>"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 135
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 136
    const-string v1, "User-Agent"

    const-string v2, "MovieBench v1.0"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 137
    const-string v1, "Content-Type"

    const-string v2, "text/xml"

    invoke-interface {v0, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 138
    const-string v1, "http://api.opensubtitles.org/xml-rpc"

    invoke-static {v1, p1, v0}, Lsx/movybench/Http;->post(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;)[B
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    return-void
.end method

.method private static parseInt(Ljava/lang/String;)I
    .locals 0

    .line 150
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    const/4 p0, 0x0

    return p0
.end method

.method private static statusOf(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 144
    const-string v0, "<name>status</name><value><string>([^<]*)"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    if-nez p0, :cond_0

    .line 145
    const-string p0, ""

    :cond_0
    invoke-virtual {v0, p0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p0

    .line 146
    invoke-virtual {p0}, Ljava/util/regex/Matcher;->find()Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const-string p0, "intet svar"

    :goto_0
    return-object p0
.end method

.method private static unesc(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 158
    const-string v0, "&lt;"

    const-string v1, "<"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "&gt;"

    const-string v1, ">"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "&amp;"

    const-string v1, "&"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public download(Lsx/movybench/sub/SubtitleResult;Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 110
    new-instance p2, Ljava/util/HashMap;

    invoke-direct {p2}, Ljava/util/HashMap;-><init>()V

    .line 111
    const-string v0, "User-Agent"

    const-string v1, "MovieBench v1.0"

    invoke-interface {p2, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 112
    iget-object p1, p1, Lsx/movybench/sub/SubtitleResult;->payload:Ljava/lang/String;

    invoke-static {p1, p2}, Lsx/movybench/Http;->get(Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object p1

    invoke-static {p1}, Lsx/movybench/sub/Srt;->extract([B)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method public keyHint()Ljava/lang/String;
    .locals 1

    const/4 v0, 0x0

    return-object v0
.end method

.method public name()Ljava/lang/String;
    .locals 1

    .line 31
    const-string v0, "OpenSubtitles"

    return-object v0
.end method

.method public requiresKey()Z
    .locals 1

    const/4 v0, 0x0

    return v0
.end method

.method public search(Lsx/movybench/sub/SubProvider$Query;Ljava/lang/String;)Ljava/util/List;
    .locals 6
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

    .line 37
    new-instance p2, Ljava/util/ArrayList;

    invoke-direct {p2}, Ljava/util/ArrayList;-><init>()V

    .line 38
    invoke-direct {p0}, Lsx/movybench/sub/OpenSubsLegacy;->login()Ljava/lang/String;

    move-result-object v0

    .line 40
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "<member><name>sublanguageid</name><value><string>"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 42
    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->iso3()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "</string></value></member>"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 43
    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->imdbDigits()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 44
    const-string v2, "<member><name>imdbid</name><value><string>"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 45
    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->imdbDigits()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 46
    :cond_0
    iget-object v2, p1, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    .line 47
    const-string v2, "<member><name>query</name><value><string>"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v4, p1, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    .line 48
    invoke-static {v4}, Lsx/movybench/sub/OpenSubsLegacy;->esc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 50
    :cond_1
    :goto_0
    invoke-virtual {p1}, Lsx/movybench/sub/SubProvider$Query;->isEpisode()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 51
    const-string v2, "<member><name>season</name><value><string>"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v4, p1, Lsx/movybench/sub/SubProvider$Query;->season:I

    .line 52
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "</string></value></member><member><name>episode</name><value><string>"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 53
    iget v2, p1, Lsx/movybench/sub/SubProvider$Query;->episode:I

    .line 54
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 57
    :cond_2
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "<?xml version=\"1.0\"?><methodCall><methodName>SearchSubtitles</methodName><params><param><value><string>"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "</string></value></param><param><value><array><data><value><struct>"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "</struct></value></data></array></value></param></params></methodCall>"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 63
    new-instance v2, Ljava/util/HashMap;

    invoke-direct {v2}, Ljava/util/HashMap;-><init>()V

    .line 64
    const-string v3, "User-Agent"

    const-string v4, "MovieBench v1.0"

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 65
    const-string v3, "Content-Type"

    const-string v4, "text/xml"

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 66
    new-instance v3, Ljava/lang/String;

    const-string v4, "http://api.opensubtitles.org/xml-rpc"

    invoke-static {v4, v1, v2}, Lsx/movybench/Http;->post(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;)[B

    move-result-object v1

    const-string v2, "UTF-8"

    invoke-direct {v3, v1, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    .line 68
    const-string v1, "200 OK"

    invoke-virtual {v3, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_4

    const-string v1, "206 Partial Content"

    invoke-virtual {v3, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_3

    goto :goto_1

    .line 69
    :cond_3
    new-instance p1, Ljava/lang/Exception;

    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "OpenSubtitles afviste sogningen: "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v3}, Lsx/movybench/sub/OpenSubsLegacy;->statusOf(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p2}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw p1

    .line 72
    :cond_4
    :goto_1
    new-instance v1, Ljava/util/LinkedHashMap;

    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    .line 73
    sget-object v2, Lsx/movybench/sub/OpenSubsLegacy;->P_MEMBER:Ljava/util/regex/Pattern;

    invoke-virtual {v2, v3}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v2

    .line 74
    :goto_2
    invoke-virtual {v2}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    if-eqz v3, :cond_6

    const/4 v3, 0x1

    .line 75
    invoke-virtual {v2, v3}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x2

    .line 76
    invoke-virtual {v2, v4}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lsx/movybench/sub/OpenSubsLegacy;->unesc(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 77
    invoke-interface {v1, v3}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_5

    .line 78
    invoke-static {v1, p2, p1}, Lsx/movybench/sub/OpenSubsLegacy;->emit(Ljava/util/Map;Ljava/util/List;Lsx/movybench/sub/SubProvider$Query;)V

    .line 79
    invoke-interface {v1}, Ljava/util/Map;->clear()V

    .line 81
    :cond_5
    invoke-interface {v1, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_2

    .line 83
    :cond_6
    invoke-static {v1, p2, p1}, Lsx/movybench/sub/OpenSubsLegacy;->emit(Ljava/util/Map;Ljava/util/List;Lsx/movybench/sub/SubProvider$Query;)V

    .line 85
    invoke-direct {p0, v0}, Lsx/movybench/sub/OpenSubsLegacy;->logout(Ljava/lang/String;)V

    return-object p2
.end method
