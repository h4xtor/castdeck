.class public final Lsx/movybench/sub/SubProvider$Query;
.super Ljava/lang/Object;
.source "SubProvider.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/sub/SubProvider;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Query"
.end annotation


# instance fields
.field public episode:I

.field public imdb:Ljava/lang/String;

.field public lang:Ljava/lang/String;

.field public season:I

.field public title:Ljava/lang/String;

.field public year:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 9
    const-string v0, ""

    iput-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->title:Ljava/lang/String;

    .line 10
    iput-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->year:Ljava/lang/String;

    .line 11
    iput-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    .line 12
    const-string v0, "da"

    iput-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->lang:Ljava/lang/String;

    const/4 v0, 0x0

    .line 13
    iput v0, p0, Lsx/movybench/sub/SubProvider$Query;->season:I

    .line 14
    iput v0, p0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    return-void
.end method


# virtual methods
.method public imdbDigits()Ljava/lang/String;
    .locals 3

    .line 37
    iget-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->imdb:Ljava/lang/String;

    const-string v1, ""

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const-string v2, "[^0-9]"

    invoke-virtual {v0, v2, v1}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :goto_0
    return-object v1
.end method

.method public isEpisode()Z
    .locals 1

    .line 36
    iget v0, p0, Lsx/movybench/sub/SubProvider$Query;->season:I

    if-lez v0, :cond_0

    iget v0, p0, Lsx/movybench/sub/SubProvider$Query;->episode:I

    if-lez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public iso2()Ljava/lang/String;
    .locals 1

    .line 33
    iget-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->lang:Ljava/lang/String;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->lang:Ljava/lang/String;

    goto :goto_1

    :cond_1
    :goto_0
    const-string v0, "en"

    :goto_1
    return-object v0
.end method

.method public iso3()Ljava/lang/String;
    .locals 3

    .line 17
    iget-object v0, p0, Lsx/movybench/sub/SubProvider$Query;->lang:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v1

    const/4 v2, -0x1

    sparse-switch v1, :sswitch_data_0

    goto/16 :goto_0

    :sswitch_0
    const-string v1, "sv"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_0

    :cond_0
    const/16 v2, 0x8

    goto/16 :goto_0

    :sswitch_1
    const-string v1, "pl"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_1
    const/4 v2, 0x7

    goto :goto_0

    :sswitch_2
    const-string v1, "no"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_2

    goto :goto_0

    :cond_2
    const/4 v2, 0x6

    goto :goto_0

    :sswitch_3
    const-string v1, "nl"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_3

    goto :goto_0

    :cond_3
    const/4 v2, 0x5

    goto :goto_0

    :sswitch_4
    const-string v1, "fr"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    goto :goto_0

    :cond_4
    const/4 v2, 0x4

    goto :goto_0

    :sswitch_5
    const-string v1, "fi"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_5

    goto :goto_0

    :cond_5
    const/4 v2, 0x3

    goto :goto_0

    :sswitch_6
    const-string v1, "es"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_6

    goto :goto_0

    :cond_6
    const/4 v2, 0x2

    goto :goto_0

    :sswitch_7
    const-string v1, "de"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_7

    goto :goto_0

    :cond_7
    const/4 v2, 0x1

    goto :goto_0

    :sswitch_8
    const-string v1, "da"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_8

    goto :goto_0

    :cond_8
    const/4 v2, 0x0

    :goto_0
    packed-switch v2, :pswitch_data_0

    .line 28
    const-string v0, "eng"

    return-object v0

    .line 21
    :pswitch_0
    const-string v0, "swe"

    return-object v0

    .line 25
    :pswitch_1
    const-string v0, "pol"

    return-object v0

    .line 22
    :pswitch_2
    const-string v0, "nor"

    return-object v0

    .line 24
    :pswitch_3
    const-string v0, "dut"

    return-object v0

    .line 26
    :pswitch_4
    const-string v0, "fre"

    return-object v0

    .line 23
    :pswitch_5
    const-string v0, "fin"

    return-object v0

    .line 27
    :pswitch_6
    const-string v0, "spa"

    return-object v0

    .line 20
    :pswitch_7
    const-string v0, "ger"

    return-object v0

    .line 18
    :pswitch_8
    const-string v0, "dan"

    return-object v0

    nop

    :sswitch_data_0
    .sparse-switch
        0xc7d -> :sswitch_8
        0xc81 -> :sswitch_7
        0xcae -> :sswitch_6
        0xcc3 -> :sswitch_5
        0xccc -> :sswitch_4
        0xdbe -> :sswitch_3
        0xdc1 -> :sswitch_2
        0xdfc -> :sswitch_1
        0xe63 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_8
        :pswitch_7
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
