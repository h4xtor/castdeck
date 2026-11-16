.class public final Lsx/movybench/sub/Srt;
.super Ljava/lang/Object;
.source "Srt.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/sub/Srt$Cue;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static cues(Ljava/lang/String;)Ljava/util/List;
    .locals 17
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Lsx/movybench/sub/Srt$Cue;",
            ">;"
        }
    .end annotation

    move-object/from16 v0, p0

    .line 94
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    if-nez v0, :cond_0

    return-object v1

    .line 96
    :cond_0
    invoke-static {v0}, Lsx/movybench/sub/Srt;->normalise(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "\r\n"

    const-string v3, "\n"

    invoke-virtual {v0, v2, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v0

    const/16 v2, 0xd

    const/16 v4, 0xa

    invoke-virtual {v0, v2, v4}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v0

    .line 97
    const-string v2, "\n\\s*\n"

    invoke-virtual {v0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 98
    array-length v2, v0

    const/4 v5, 0x0

    move v6, v5

    :goto_0
    if-ge v6, v2, :cond_b

    aget-object v7, v0, v6

    .line 99
    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v7

    .line 100
    array-length v8, v7

    if-nez v8, :cond_1

    goto/16 :goto_4

    :cond_1
    move v8, v5

    :goto_1
    const/4 v9, 0x3

    .line 102
    array-length v10, v7

    invoke-static {v9, v10}, Ljava/lang/Math;->min(II)I

    move-result v9

    const-string v10, "-->"

    if-ge v8, v9, :cond_3

    .line 103
    aget-object v9, v7, v8

    invoke-virtual {v9, v10}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v9

    if-eqz v9, :cond_2

    goto :goto_2

    :cond_2
    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    :cond_3
    const/4 v8, -0x1

    :goto_2
    if-gez v8, :cond_4

    goto :goto_4

    .line 106
    :cond_4
    aget-object v9, v7, v8

    .line 107
    invoke-virtual {v9, v10}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v9

    .line 108
    array-length v10, v9

    const/4 v11, 0x2

    if-ge v10, v11, :cond_5

    goto :goto_4

    .line 109
    :cond_5
    aget-object v10, v9, v5

    invoke-static {v10}, Lsx/movybench/sub/Srt;->parseTime(Ljava/lang/String;)J

    move-result-wide v12

    const/4 v10, 0x1

    .line 110
    aget-object v9, v9, v10

    invoke-static {v9}, Lsx/movybench/sub/Srt;->parseTime(Ljava/lang/String;)J

    move-result-wide v14

    const-wide/16 v9, 0x0

    cmp-long v9, v12, v9

    if-ltz v9, :cond_a

    cmp-long v9, v14, v12

    if-gtz v9, :cond_6

    goto :goto_4

    .line 112
    :cond_6
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    :goto_3
    add-int/lit8 v8, v8, 0x1

    .line 113
    array-length v10, v7

    if-ge v8, v10, :cond_8

    .line 114
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->length()I

    move-result v10

    if-lez v10, :cond_7

    invoke-virtual {v9, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 115
    :cond_7
    aget-object v10, v7, v8

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_3

    .line 117
    :cond_8
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v7}, Lsx/movybench/sub/Srt;->stripTags(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v16

    .line 118
    invoke-virtual/range {v16 .. v16}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_9

    goto :goto_4

    .line 119
    :cond_9
    move-object/from16 v7, v16

    const-string v8, "osdb.link/vip"

    invoke-virtual {v7, v8}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v7

    if-eqz v7, :cond_c

    goto :goto_4

    :cond_c
    new-instance v7, Lsx/movybench/sub/Srt$Cue;

    move-object v11, v7

    invoke-direct/range {v11 .. v16}, Lsx/movybench/sub/Srt$Cue;-><init>(JJLjava/lang/String;)V

    invoke-interface {v1, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_a
    :goto_4
    add-int/lit8 v6, v6, 0x1

    goto/16 :goto_0

    :cond_b
    return-object v1
.end method

.method private static decode([B)Ljava/lang/String;
    .locals 7

    .line 69
    array-length v0, p0

    const/4 v1, 0x0

    const/4 v2, 0x2

    const/4 v3, 0x1

    const/16 v4, 0xff

    const/4 v5, 0x3

    if-le v0, v5, :cond_0

    aget-byte v0, p0, v1

    and-int/2addr v0, v4

    const/16 v6, 0xef

    if-ne v0, v6, :cond_0

    aget-byte v0, p0, v3

    and-int/2addr v0, v4

    const/16 v6, 0xbb

    if-ne v0, v6, :cond_0

    aget-byte v0, p0, v2

    and-int/2addr v0, v4

    const/16 v6, 0xbf

    if-ne v0, v6, :cond_0

    .line 70
    new-instance v0, Ljava/lang/String;

    array-length v1, p0

    sub-int/2addr v1, v5

    sget-object v2, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v5, v1, v2}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    return-object v0

    .line 72
    :cond_0
    array-length v0, p0

    const/16 v5, 0xfe

    if-le v0, v3, :cond_1

    aget-byte v0, p0, v1

    and-int/2addr v0, v4

    if-ne v0, v4, :cond_1

    aget-byte v0, p0, v3

    and-int/2addr v0, v4

    if-ne v0, v5, :cond_1

    .line 73
    new-instance v0, Ljava/lang/String;

    array-length v1, p0

    sub-int/2addr v1, v2

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_16LE:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v2, v1, v3}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    return-object v0

    .line 75
    :cond_1
    array-length v0, p0

    if-le v0, v3, :cond_2

    aget-byte v0, p0, v1

    and-int/2addr v0, v4

    if-ne v0, v5, :cond_2

    aget-byte v0, p0, v3

    and-int/2addr v0, v4

    if-ne v0, v4, :cond_2

    .line 76
    new-instance v0, Ljava/lang/String;

    array-length v1, p0

    sub-int/2addr v1, v2

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_16BE:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v2, v1, v3}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    return-object v0

    .line 78
    :cond_2
    new-instance v0, Ljava/lang/String;

    sget-object v3, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v3}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    move v3, v1

    .line 81
    :goto_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    if-ge v1, v4, :cond_4

    invoke-virtual {v0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v4

    const v5, 0xfffd

    if-ne v4, v5, :cond_3

    add-int/lit8 v3, v3, 0x1

    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 82
    :cond_4
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    div-int/lit16 v1, v1, 0x1f4

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    if-le v3, v1, :cond_5

    .line 84
    :try_start_0
    new-instance v1, Ljava/lang/String;

    const-string v2, "windows-1252"

    invoke-static {v2}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v2

    invoke-direct {v1, p0, v2}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v1

    :catch_0
    :cond_5
    return-object v0
.end method

.method public static extract([B)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    if-eqz p0, :cond_2

    .line 27
    array-length v0, p0

    if-eqz v0, :cond_2

    .line 29
    array-length v0, p0

    const/4 v1, 0x4

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-le v0, v1, :cond_0

    aget-byte v0, p0, v3

    const/16 v1, 0x50

    if-ne v0, v1, :cond_0

    aget-byte v0, p0, v2

    const/16 v1, 0x4b

    if-ne v0, v1, :cond_0

    .line 30
    invoke-static {p0}, Lsx/movybench/sub/Srt;->unzip([B)[B

    move-result-object p0

    goto :goto_0

    .line 31
    :cond_0
    array-length v0, p0

    const/4 v1, 0x2

    if-le v0, v1, :cond_1

    aget-byte v0, p0, v3

    and-int/lit16 v0, v0, 0xff

    const/16 v1, 0x1f

    if-ne v0, v1, :cond_1

    aget-byte v0, p0, v2

    and-int/lit16 v0, v0, 0xff

    const/16 v1, 0x8b

    if-ne v0, v1, :cond_1

    .line 32
    invoke-static {p0}, Lsx/movybench/sub/Srt;->ungzip([B)[B

    move-result-object p0

    .line 34
    :cond_1
    :goto_0
    invoke-static {p0}, Lsx/movybench/sub/Srt;->decode([B)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const-string v1, "<"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :ok_html

    new-instance v0, Ljava/lang/Exception;

    const-string v1, "OpenSubtitles svarede med en webside i stedet for undertekst-filen (typisk gr\u00e6nse eller adgangskrav)"

    invoke-direct {v0, v1}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw v0

    :ok_html
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x190

    if-gt v0, v1, :ok_vip

    const-string v1, "osdb.link/vip"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :ok_vip

    new-instance v0, Ljava/lang/Exception;

    const-string v1, "OpenSubtitles sendte kun en VIP-besked \u2014 pr\u00f8v et andet resultat p\u00e5 listen"

    invoke-direct {v0, v1}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw v0

    :ok_vip
    return-object p0

    .line 27
    :cond_2
    new-instance p0, Ljava/lang/Exception;

    const-string v0, "tom fil"

    invoke-direct {p0, v0}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static normalise(Ljava/lang/String;)Ljava/lang/String;
    .locals 9

    const-string v1, "\r"

    const-string v2, ""

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "Dialogue:"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :ret_in

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\n"

    invoke-virtual {p0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    const/4 v3, 0x0

    :loop_ass
    array-length v4, p0

    if-ge v3, v4, :end_ass

    aget-object v4, p0, v3

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :next_ass

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    const-string v5, ","

    const/16 v6, 0xa

    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v4

    array-length v5, v4

    const/16 v6, 0xa

    if-ge v5, v6, :next_ass

    const/4 v5, 0x1

    aget-object v5, v4, v5

    const/4 v6, 0x2

    aget-object v6, v4, v6

    const/16 v7, 0x9

    aget-object v7, v4, v7

    const-string v8, "\\{[^}]*\\}"

    const-string v4, ""

    invoke-virtual {v7, v8, v4}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "\\N"

    const-string v4, "\n"

    invoke-virtual {v7, v8, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v5, " --> "

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const/16 v5, 0xa

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const/16 v5, 0xa

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v1

    const/16 v5, 0xa

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v1

    :next_ass
    add-int/lit8 v3, v3, 0x1

    goto :loop_ass

    :end_ass
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    :ret_in
    return-object p0
.end method

.method private static fmt(J)Ljava/lang/String;
    .locals 8

    const-wide/32 v0, 0x36ee80

    .line 155
    div-long v2, p0, v0

    .line 156
    rem-long v0, p0, v0

    const-wide/32 v4, 0xea60

    div-long/2addr v0, v4

    .line 157
    rem-long v4, p0, v4

    const-wide/16 v6, 0x3e8

    div-long/2addr v4, v6

    .line 158
    rem-long/2addr p0, v6

    .line 159
    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-static {p0, p1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p0

    filled-new-array {v2, v0, v1, p0}, [Ljava/lang/Object;

    move-result-object p0

    const-string p1, "%02d:%02d:%02d.%03d"

    invoke-static {p1, p0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static parseTime(Ljava/lang/String;)J
    .locals 8

    .line 131
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0x2c

    const/16 v1, 0x2e

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    const-string v0, "\\s.*$"

    const-string v1, ""

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 132
    const-string v0, ":"

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    .line 135
    :try_start_0
    array-length v0, p0

    const/4 v1, 0x3

    const-wide/high16 v2, 0x404e000000000000L    # 60.0

    const/4 v4, 0x1

    const/4 v5, 0x2

    const/4 v6, 0x0

    if-ne v0, v1, :cond_0

    aget-object v0, p0, v6

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    int-to-double v0, v0

    const-wide v6, 0x40ac200000000000L    # 3600.0

    mul-double/2addr v0, v6

    aget-object v4, p0, v4

    invoke-static {v4}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v4

    int-to-double v6, v4

    mul-double/2addr v6, v2

    add-double/2addr v0, v6

    aget-object p0, p0, v5

    invoke-static {p0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v2

    goto :goto_0

    .line 136
    :cond_0
    array-length v0, p0

    if-ne v0, v5, :cond_1

    aget-object v0, p0, v6

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    int-to-double v0, v0

    mul-double/2addr v0, v2

    aget-object p0, p0, v4

    invoke-static {p0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v2

    :goto_0
    add-double/2addr v0, v2

    goto :goto_1

    .line 137
    :cond_1
    aget-object p0, p0, v6

    invoke-static {p0}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v0

    :goto_1
    const-wide v2, 0x408f400000000000L    # 1000.0

    mul-double/2addr v0, v2

    .line 138
    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-wide v0

    :catch_0
    const-wide/16 v0, -0x1

    return-wide v0
.end method

.method private static stripTags(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 125
    const-string v0, "<\\s*/?\\s*(i|b|u|font)[^>]*>"

    const-string v1, ""

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 126
    const-string v0, "\\{\\\\[^}]*}"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static toVtt(Ljava/util/List;)Ljava/lang/String;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/sub/Srt$Cue;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 146
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "WEBVTT\n\n"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 147
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lsx/movybench/sub/Srt$Cue;

    .line 148
    iget-wide v2, v1, Lsx/movybench/sub/Srt$Cue;->start:J

    invoke-static {v2, v3}, Lsx/movybench/sub/Srt;->fmt(J)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " --> "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-wide v3, v1, Lsx/movybench/sub/Srt$Cue;->end:J

    invoke-static {v3, v4}, Lsx/movybench/sub/Srt;->fmt(J)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const/16 v3, 0xa

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 149
    iget-object v1, v1, Lsx/movybench/sub/Srt$Cue;->text:Ljava/lang/String;

    const-string v2, "\n"

    invoke-virtual {v1, v2, v2}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 151
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static ungzip([B)[B
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 59
    new-instance v0, Ljava/util/zip/GZIPInputStream;

    new-instance v1, Ljava/io/ByteArrayInputStream;

    invoke-direct {v1, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    invoke-direct {v0, v1}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V

    .line 60
    new-instance p0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v1, 0x2000

    .line 61
    new-array v1, v1, [B

    .line 63
    :goto_0
    invoke-virtual {v0, v1}, Ljava/util/zip/GZIPInputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_0

    const/4 v3, 0x0

    invoke-virtual {p0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 64
    :cond_0
    invoke-virtual {v0}, Ljava/util/zip/GZIPInputStream;->close()V

    .line 65
    invoke-virtual {p0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method private static unzip([B)[B
    .locals 6
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 38
    new-instance v0, Ljava/util/zip/ZipInputStream;

    new-instance v1, Ljava/io/ByteArrayInputStream;

    invoke-direct {v1, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    invoke-direct {v0, v1}, Ljava/util/zip/ZipInputStream;-><init>(Ljava/io/InputStream;)V

    const/4 p0, 0x0

    .line 41
    :cond_0
    :goto_0
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->getNextEntry()Ljava/util/zip/ZipEntry;

    move-result-object v1

    if-eqz v1, :cond_7

    .line 42
    invoke-virtual {v1}, Ljava/util/zip/ZipEntry;->isDirectory()Z

    move-result v2

    if-eqz v2, :cond_1

    goto :goto_0

    .line 43
    :cond_1
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v3, 0x2000

    .line 44
    new-array v3, v3, [B

    .line 46
    :goto_1
    invoke-virtual {v0, v3}, Ljava/util/zip/ZipInputStream;->read([B)I

    move-result v4

    if-lez v4, :cond_2

    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_1

    .line 47
    :cond_2
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v2

    .line 48
    array-length v3, v2

    if-nez v3, :cond_3

    goto :goto_0

    .line 49
    :cond_3
    invoke-virtual {v1}, Ljava/util/zip/ZipEntry;->getName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v1

    .line 50
    const-string v3, ".srt"

    invoke-virtual {v1, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_6

    const-string v3, ".vtt"

    invoke-virtual {v1, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    goto :goto_2

    :cond_4
    if-eqz p0, :cond_5

    .line 51
    array-length v1, v2

    array-length v3, p0

    if-le v1, v3, :cond_0

    :cond_5
    move-object p0, v2

    goto :goto_0

    :cond_6
    :goto_2
    return-object v2

    .line 53
    :cond_7
    invoke-virtual {v0}, Ljava/util/zip/ZipInputStream;->close()V

    if-eqz p0, :cond_8

    return-object p0

    .line 54
    :cond_8
    new-instance p0, Ljava/lang/Exception;

    const-string v0, "zip uden indhold"

    invoke-direct {p0, v0}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw p0
.end method
