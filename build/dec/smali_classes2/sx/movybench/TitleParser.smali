.class public final Lsx/movybench/TitleParser;
.super Ljava/lang/Object;
.source "TitleParser.java"


# static fields
.field private static final NOISE:[Ljava/lang/String;

.field private static final P_EP_ONLY:Ljava/util/regex/Pattern;

.field private static final P_IMDB:Ljava/util/regex/Pattern;

.field private static final P_NXNN:Ljava/util/regex/Pattern;

.field private static final P_S_E:Ljava/util/regex/Pattern;

.field private static final P_WORD:Ljava/util/regex/Pattern;

.field private static final P_YEAR:Ljava/util/regex/Pattern;


# instance fields
.field public episode:I

.field public imdb:Ljava/lang/String;

.field public raw:Ljava/lang/String;

.field public season:I

.field public title:Ljava/lang/String;

.field public year:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 22
    const-string v0, "(?i)\\bs(\\d{1,2})[\\s._-]*e(\\d{1,3})\\b"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/TitleParser;->P_S_E:Ljava/util/regex/Pattern;

    .line 23
    const-string v0, "(?i)\\b(\\d{1,2})x(\\d{2,3})\\b"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/TitleParser;->P_NXNN:Ljava/util/regex/Pattern;

    .line 24
    const-string v0, "(?i)season\\s*(\\d{1,2})\\s*(?:episode|ep\\.?)\\s*(\\d{1,3})"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/TitleParser;->P_WORD:Ljava/util/regex/Pattern;

    .line 26
    const-string v0, "(?i)\\b(?:episode|ep\\.?)\\s*(\\d{1,3})\\b"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/TitleParser;->P_EP_ONLY:Ljava/util/regex/Pattern;

    .line 27
    const-string v0, "\\b(19[5-9]\\d|20[0-4]\\d)\\b"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/TitleParser;->P_YEAR:Ljava/util/regex/Pattern;

    .line 28
    const-string v0, "\\b(tt\\d{7,9})\\b"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lsx/movybench/TitleParser;->P_IMDB:Ljava/util/regex/Pattern;

    const/16 v0, 0x18

    .line 30
    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "watch online free"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "watch online"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "free online"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "full movie"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "full episodes"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "streaming"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "hd"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "4k"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "1080p"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "720p"

    aput-object v2, v0, v1

    const/16 v1, 0xa

    const-string v2, "subbed"

    aput-object v2, v0, v1

    const/16 v1, 0xb

    const-string v2, "dubbed"

    aput-object v2, v0, v1

    const/16 v1, 0xc

    const-string v2, "english sub"

    aput-object v2, v0, v1

    const/16 v1, 0xd

    const-string v2, "english subs"

    aput-object v2, v0, v1

    const/16 v1, 0xe

    const-string v2, "online free"

    aput-object v2, v0, v1

    const/16 v1, 0xf

    const-string v2, "putlocker"

    aput-object v2, v0, v1

    const/16 v1, 0x10

    const-string v2, "download"

    aput-object v2, v0, v1

    const/16 v1, 0x11

    const-string v2, "movies"

    aput-object v2, v0, v1

    const/16 v1, 0x12

    const-string v2, "tv series"

    aput-object v2, v0, v1

    const/16 v1, 0x13

    const-string v2, "series online"

    aput-object v2, v0, v1

    const/16 v1, 0x14

    const-string v2, "free movies"

    aput-object v2, v0, v1

    const/16 v1, 0x15

    const-string v2, "movie"

    aput-object v2, v0, v1

    const/16 v1, 0x16

    const-string v2, "tv show"

    aput-object v2, v0, v1

    const/16 v1, 0x17

    const-string v2, "tv"

    aput-object v2, v0, v1

    sput-object v0, Lsx/movybench/TitleParser;->NOISE:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 15
    const-string v0, ""

    iput-object v0, p0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    .line 16
    iput-object v0, p0, Lsx/movybench/TitleParser;->year:Ljava/lang/String;

    const/4 v1, 0x0

    .line 17
    iput v1, p0, Lsx/movybench/TitleParser;->season:I

    .line 18
    iput v1, p0, Lsx/movybench/TitleParser;->episode:I

    .line 19
    iput-object v0, p0, Lsx/movybench/TitleParser;->imdb:Ljava/lang/String;

    .line 20
    iput-object v0, p0, Lsx/movybench/TitleParser;->raw:Ljava/lang/String;

    return-void
.end method

.method private static clampInt(Ljava/lang/String;II)I
    .locals 0

    .line 119
    :try_start_0
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0

    .line 120
    invoke-static {p2, p0}, Ljava/lang/Math;->min(II)I

    move-result p0

    invoke-static {p1, p0}, Ljava/lang/Math;->max(II)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return p0

    :catch_0
    const/4 p0, 0x0

    return p0
.end method

.method private static cleanTitle(Ljava/lang/String;)Ljava/lang/String;
    .locals 8

    .line 82
    const-string v0, ""

    if-nez p0, :cond_0

    return-object v0

    .line 84
    :cond_0
    const-string v1, "\\(\\s*(19|20)\\d{2}\\s*\\)"

    const-string v2, " "

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 85
    const-string v1, "(?i)\\bs\\d{1,2}[\\s._-]*e\\d{1,3}\\b"

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 86
    const-string v1, "(?i)\\b\\d{1,2}x\\d{2,3}\\b"

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 87
    const-string v1, "(?i)season\\s*\\d+.*$"

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 88
    const-string v1, "(?i)\\bepisode\\s*\\d+\\b"

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 90
    const-string v1, "[|\u2022\u00b7]"

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    const/4 v1, 0x0

    aget-object p0, p0, v1

    .line 91
    const-string v3, "\\s+[-\u2013\u2014]\\s+[^-\u2013\u2014]{2,28}$"

    invoke-virtual {p0, v3, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 92
    const-string v3, "[\\._]+"

    invoke-virtual {p0, v3, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 93
    const-string v3, "(?i)\\b(watch|stream|online|free|full|hd|4k|1080p|720p)\\b"

    invoke-virtual {p0, v3, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 94
    sget-object v3, Lsx/movybench/TitleParser;->NOISE:[Ljava/lang/String;

    array-length v4, v3

    :goto_0
    if-ge v1, v4, :cond_1

    aget-object v5, v3, v1

    .line 95
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "(?i)\\b"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v5}, Ljava/util/regex/Pattern;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "\\b"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {p0, v5, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 97
    :cond_1
    const-string v1, "\\s{2,}"

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 98
    const-string v1, "^[\\s&\\-\u2013\u2014:.,/]+"

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const-string v1, "[\\s&\\-\u2013\u2014:.,/]+$"

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 99
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static varargs firstNonEmpty([Ljava/lang/String;)Ljava/lang/String;
    .locals 4

    .line 103
    array-length v0, p0

    const/4 v1, 0x0

    :goto_0
    if-ge v1, v0, :cond_1

    aget-object v2, p0, v1

    if-eqz v2, :cond_0

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_0

    return-object v2

    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 104
    :cond_1
    const-string p0, ""

    return-object p0
.end method

.method private static lastPathSegment(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    .line 108
    const-string v0, ""

    if-nez p0, :cond_0

    return-object v0

    .line 109
    :cond_0
    const-string v1, "[?#].*$"

    invoke-virtual {p0, v1, v0}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 110
    const-string v1, "/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 111
    array-length v1, p0

    add-int/lit8 v1, v1, -0x1

    :goto_0
    if-ltz v1, :cond_2

    .line 112
    aget-object v2, p0, v1

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    aget-object p0, p0, v1

    const/16 v0, 0x2d

    const/16 v1, 0x20

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_1
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    :cond_2
    return-object v0
.end method

.method public static parse(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lsx/movybench/TitleParser;
    .locals 8

    .line 38
    new-instance v0, Lsx/movybench/TitleParser;

    invoke-direct {v0}, Lsx/movybench/TitleParser;-><init>()V

    .line 39
    const-string v1, ""

    if-nez p0, :cond_0

    move-object v2, v1

    goto :goto_0

    :cond_0
    move-object v2, p0

    :goto_0
    iput-object v2, v0, Lsx/movybench/TitleParser;->raw:Ljava/lang/String;

    const/4 v2, 0x4

    .line 41
    new-array v2, v2, [Ljava/lang/String;

    const/4 v3, 0x0

    aput-object p2, v2, v3

    const/4 p2, 0x1

    aput-object p3, v2, p2

    const/4 p3, 0x2

    aput-object p0, v2, p3

    const/4 v4, 0x3

    invoke-static {p1}, Lsx/movybench/TitleParser;->lastPathSegment(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v2, v4

    invoke-static {v2}, Lsx/movybench/TitleParser;->firstNonEmpty([Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 42
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " | "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    .line 44
    sget-object v4, Lsx/movybench/TitleParser;->P_S_E:Ljava/util/regex/Pattern;

    invoke-virtual {v4, v2}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v5

    .line 45
    invoke-virtual {v5}, Ljava/util/regex/Matcher;->find()Z

    move-result v6

    if-nez v6, :cond_1

    invoke-virtual {v4, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v5

    .line 46
    :cond_1
    invoke-virtual {v5, v3}, Ljava/util/regex/Matcher;->find(I)Z

    .line 47
    invoke-virtual {v4, v2}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v3

    .line 48
    invoke-virtual {v3}, Ljava/util/regex/Matcher;->find()Z

    move-result v5

    if-nez v5, :cond_2

    invoke-virtual {v4, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v3

    .line 49
    :cond_2
    invoke-virtual {v3}, Ljava/util/regex/Matcher;->find()Z

    move-result v4

    const/16 v5, 0x63

    const/16 v6, 0x3e7

    if-eqz v4, :cond_3

    .line 50
    invoke-virtual {v3, p2}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, p2, v5}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result v4

    iput v4, v0, Lsx/movybench/TitleParser;->season:I

    .line 51
    invoke-virtual {v3, p3}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p3

    invoke-static {p3, p2, v6}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result p3

    iput p3, v0, Lsx/movybench/TitleParser;->episode:I

    goto :goto_1

    .line 53
    :cond_3
    sget-object v3, Lsx/movybench/TitleParser;->P_NXNN:Ljava/util/regex/Pattern;

    invoke-virtual {v3, v2}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v4

    .line 54
    invoke-virtual {v4}, Ljava/util/regex/Matcher;->find()Z

    move-result v7

    if-nez v7, :cond_4

    invoke-virtual {v3, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v4

    .line 55
    :cond_4
    invoke-virtual {v4}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    if-eqz v3, :cond_5

    .line 56
    invoke-virtual {v4, p2}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3, p2, v5}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result v3

    iput v3, v0, Lsx/movybench/TitleParser;->season:I

    .line 57
    invoke-virtual {v4, p3}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p3

    invoke-static {p3, p2, v6}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result p3

    iput p3, v0, Lsx/movybench/TitleParser;->episode:I

    goto :goto_1

    .line 59
    :cond_5
    sget-object v3, Lsx/movybench/TitleParser;->P_WORD:Ljava/util/regex/Pattern;

    invoke-virtual {v3, v2}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v3

    .line 60
    invoke-virtual {v3}, Ljava/util/regex/Matcher;->find()Z

    move-result v4

    if-eqz v4, :cond_6

    .line 61
    invoke-virtual {v3, p2}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4, p2, v5}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result v4

    iput v4, v0, Lsx/movybench/TitleParser;->season:I

    .line 62
    invoke-virtual {v3, p3}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p3

    invoke-static {p3, p2, v6}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result p3

    iput p3, v0, Lsx/movybench/TitleParser;->episode:I

    goto :goto_1

    .line 64
    :cond_6
    sget-object p3, Lsx/movybench/TitleParser;->P_EP_ONLY:Ljava/util/regex/Pattern;

    invoke-virtual {p3, v2}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p3

    .line 65
    invoke-virtual {p3}, Ljava/util/regex/Matcher;->find()Z

    move-result v3

    if-eqz v3, :cond_7

    invoke-virtual {p3, p2}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p3

    invoke-static {p3, p2, v6}, Lsx/movybench/TitleParser;->clampInt(Ljava/lang/String;II)I

    move-result p3

    iput p3, v0, Lsx/movybench/TitleParser;->episode:I

    .line 70
    :cond_7
    :goto_1
    sget-object p3, Lsx/movybench/TitleParser;->P_IMDB:Ljava/util/regex/Pattern;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    if-nez p1, :cond_8

    move-object p1, v1

    :cond_8
    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v3, " "

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    if-nez p0, :cond_9

    goto :goto_2

    :cond_9
    move-object v1, p0

    :goto_2
    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p3, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p1

    .line 71
    invoke-virtual {p1}, Ljava/util/regex/Matcher;->find()Z

    move-result p3

    if-eqz p3, :cond_a

    invoke-virtual {p1, p2}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p1

    iput-object p1, v0, Lsx/movybench/TitleParser;->imdb:Ljava/lang/String;

    .line 73
    :cond_a
    sget-object p1, Lsx/movybench/TitleParser;->P_YEAR:Ljava/util/regex/Pattern;

    invoke-virtual {p1, v2}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object p1

    .line 74
    invoke-virtual {p1}, Ljava/util/regex/Matcher;->find()Z

    move-result p3

    if-eqz p3, :cond_b

    invoke-virtual {p1, p2}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object p1

    iput-object p1, v0, Lsx/movybench/TitleParser;->year:Ljava/lang/String;

    .line 76
    :cond_b
    invoke-static {v2}, Lsx/movybench/TitleParser;->cleanTitle(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    iput-object p1, v0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    .line 77
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_c

    invoke-static {p0}, Lsx/movybench/TitleParser;->cleanTitle(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    :cond_c
    return-object v0
.end method


# virtual methods
.method public candidates()Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 152
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 153
    iget-object v1, p0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    iget-object v1, p0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 154
    :cond_0
    iget-object v1, p0, Lsx/movybench/TitleParser;->raw:Ljava/lang/String;

    invoke-static {v1}, Lsx/movybench/TitleParser;->cleanTitle(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 155
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    invoke-interface {v0, v1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_1

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_1
    return-object v0
.end method

.method public isSeries()Z
    .locals 1

    .line 138
    iget v0, p0, Lsx/movybench/TitleParser;->season:I

    if-gtz v0, :cond_1

    iget v0, p0, Lsx/movybench/TitleParser;->episode:I

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method public label()Ljava/lang/String;
    .locals 4

    .line 128
    new-instance v0, Ljava/lang/StringBuilder;

    iget-object v1, p0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "Ukendt titel"

    goto :goto_0

    :cond_0
    iget-object v1, p0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    :goto_0
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 129
    iget v1, p0, Lsx/movybench/TitleParser;->season:I

    if-lez v1, :cond_1

    iget v1, p0, Lsx/movybench/TitleParser;->episode:I

    if-lez v1, :cond_1

    .line 130
    const-string v1, " S"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lsx/movybench/TitleParser;->season:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    const-string v3, "%02d"

    invoke-static {v3, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "E"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lsx/movybench/TitleParser;->episode:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v3, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 131
    :cond_1
    iget-object v1, p0, Lsx/movybench/TitleParser;->year:Ljava/lang/String;

    if-eqz v1, :cond_2

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_2

    .line 132
    const-string v1, " ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lsx/movybench/TitleParser;->year:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ")"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 134
    :cond_2
    :goto_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public sane()Z
    .locals 6

    .line 142
    iget-object v0, p0, Lsx/movybench/TitleParser;->title:Ljava/lang/String;

    if-nez v0, :cond_0

    const-string v0, ""

    goto :goto_0

    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 143
    :goto_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    const/4 v2, 0x2

    const/4 v3, 0x0

    if-lt v1, v2, :cond_4

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    const/16 v2, 0x5a

    if-le v1, v2, :cond_1

    goto :goto_1

    .line 144
    :cond_1
    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v1

    .line 145
    const-string v2, "shows"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_4

    const-string v4, "movies"

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_4

    const-string v5, "home"

    invoke-virtual {v1, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_4

    const-string v5, "tv"

    invoke-virtual {v1, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_2

    goto :goto_1

    .line 146
    :cond_2
    invoke-virtual {v1, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_3

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_3

    return v3

    .line 147
    :cond_3
    const-string v1, ".*[a-zA-Z].*"

    invoke-virtual {v0, v1}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v0

    return v0

    :cond_4
    :goto_1
    return v3
.end method
