.class public final Lsx/movybench/Catalog;
.super Ljava/lang/Object;
.source "Catalog.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/Catalog$Row;
    }
.end annotation


# instance fields
.field private final rows:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lsx/movybench/Catalog$Row;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 19
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lsx/movybench/Catalog;->rows:Ljava/util/List;

    return-void
.end method

.method private add(Ljava/lang/String;)Lsx/movybench/Catalog;
    .locals 1

    .line 21
    iget-object v0, p0, Lsx/movybench/Catalog;->rows:Ljava/util/List;

    invoke-static {p1}, Lsx/movybench/Catalog$Row;->header(Ljava/lang/String;)Lsx/movybench/Catalog$Row;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object p0
.end method

.method private varargs add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;
    .locals 2

    .line 24
    iget-object v0, p0, Lsx/movybench/Catalog;->rows:Ljava/util/List;

    new-instance v1, Lsx/movybench/Site;

    invoke-direct {v1, p1, p2, p3, p4}, Lsx/movybench/Site;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)V

    invoke-static {v1}, Lsx/movybench/Catalog$Row;->site(Lsx/movybench/Site;)Lsx/movybench/Catalog$Row;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object p0
.end method

.method public static build()Lsx/movybench/Catalog;
    .locals 11

    .line 31
    new-instance v0, Lsx/movybench/Catalog;

    invoke-direct {v0}, Lsx/movybench/Catalog;-><init>()V

    .line 33
    const-string v1, "4K \u00b7 AUTO-NEXT \u00b7 DAILY DRIVERS"

    invoke-direct {v0, v1}, Lsx/movybench/Catalog;->add(Ljava/lang/String;)Lsx/movybench/Catalog;

    const/4 v1, 0x0

    .line 34
    new-array v2, v1, [Ljava/lang/String;

    const-string v3, "Movy"

    const-string v4, "https://www.movy.sx/"

    const-string v5, "4K \u00b7 auto-next \u00b7 watchlists"

    invoke-direct {v0, v3, v4, v5, v2}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 35
    const-string v2, "film \u00b7 serier \u00b7 anime \u00b7 auto-next"

    new-array v3, v1, [Ljava/lang/String;

    const-string v4, "Cinejoy"

    const-string v5, "https://cinejoy.pk/"

    invoke-direct {v0, v4, v5, v2, v3}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    const/4 v2, 0x1

    .line 36
    new-array v3, v2, [Ljava/lang/String;

    const-string v4, "https://bingebox.ac/"

    aput-object v4, v3, v1

    const-string v4, "PopcornMovies"

    const-string v5, "https://popcornmovies.st/"

    const-string v6, "4K \u00b7 auto-next"

    invoke-direct {v0, v4, v5, v6, v3}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    const/4 v3, 0x2

    .line 37
    new-array v4, v3, [Ljava/lang/String;

    const-string v5, "https://7movies.ws/"

    aput-object v5, v4, v1

    const-string v5, "https://7domains.fans/"

    aput-object v5, v4, v2

    const-string v5, "7Movies"

    const-string v7, "https://7movies.ac/"

    const-string v8, "4K \u00b7 anime \u00b7 auto-next"

    invoke-direct {v0, v5, v7, v8, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 39
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://fprime.at/"

    aput-object v5, v4, v1

    const-string v5, "Atlantic"

    const-string v7, "https://atlantic.bz/"

    invoke-direct {v0, v5, v7, v6, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 41
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://rayplayer.com/"

    aput-object v5, v4, v1

    const-string v5, "Rayplayer"

    const-string v7, "https://rayplayer.com/da"

    const-string v8, "dansk \u00b7 live tekster"

    invoke-direct {v0, v5, v7, v8, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    const/4 v4, 0x3

    .line 40
    new-array v5, v4, [Ljava/lang/String;

    const-string v7, "https://shuttletv.pk/"

    aput-object v7, v5, v1

    const-string v7, "https://shuttletv.me/"

    aput-object v7, v5, v2

    const-string v7, "https://shuttletv.cr/"

    aput-object v7, v5, v3

    const-string v7, "ShuttleTV"

    const-string v8, "https://shuttletv.su/"

    const-string v9, "ren aggregator \u00b7 eget player"

    invoke-direct {v0, v7, v8, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 42
    const-string v5, "https://flystream.net/"

    new-array v7, v1, [Ljava/lang/String;

    const-string v8, "FlyStream"

    invoke-direct {v0, v8, v5, v6, v7}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 43
    const-string v5, "https://vivarium.su/"

    new-array v7, v1, [Ljava/lang/String;

    const-string v8, "Vivarium"

    invoke-direct {v0, v8, v5, v6, v7}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 44
    new-array v5, v3, [Ljava/lang/String;

    const-string v7, "https://rivestream.ru/"

    aput-object v7, v5, v1

    const-string v7, "https://rivestream.win/"

    aput-object v7, v5, v2

    const-string v7, "Rive"

    const-string v8, "https://www.rivestream.app/"

    const-string v9, "4K \u00b7 anime \u00b7 status-side"

    invoke-direct {v0, v7, v8, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 46
    new-array v5, v3, [Ljava/lang/String;

    const-string v7, "https://corsflix.net/"

    aput-object v7, v5, v1

    const-string v7, "https://watch.corsflix.dpdns.org/"

    aput-object v7, v5, v2

    const-string v7, "CorsFlix"

    const-string v8, "https://watch.corsflix.net/"

    const-string v9, "samme skuff som Rive"

    invoke-direct {v0, v7, v8, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 48
    new-array v4, v4, [Ljava/lang/String;

    const-string v5, "https://flixer.su/"

    aput-object v5, v4, v1

    const-string v5, "https://flixer.cx/"

    aput-object v5, v4, v2

    const-string v5, "https://hexa.su/"

    aput-object v5, v4, v3

    const-string v5, "Flixer"

    const-string v7, "https://flixer.gd/"

    const-string v8, "auto-next"

    invoke-direct {v0, v5, v7, v8, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 50
    const-string v4, "https://cinelite.xyz/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v7, "CineLite"

    invoke-direct {v0, v7, v4, v6, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 52
    const-string v4, "FLERE I SAMME SKUFFE"

    invoke-direct {v0, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 53
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://flickystream.mov/"

    aput-object v5, v4, v1

    const-string v5, "MeowTV"

    const-string v7, "https://meowtv.ru/"

    const-string v9, "anime \u00b7 serier"

    invoke-direct {v0, v5, v7, v9, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 54
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://67movies.st/"

    aput-object v5, v4, v1

    const-string v5, "SweetFox"

    const-string v7, "https://sweetfox.app/"

    const-string v10, "aggregator"

    invoke-direct {v0, v5, v7, v10, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 55
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://www.cinezo.st/"

    aput-object v5, v4, v1

    const-string v5, "ArrowTV"

    const-string v7, "https://arrowtv.net/"

    invoke-direct {v0, v5, v7, v9, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 56
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://redflix.one/"

    aput-object v5, v4, v1

    const-string v5, "Ghostflix"

    const-string v7, "https://ghostflix.st/"

    const-string v9, "invite-baseret"

    invoke-direct {v0, v5, v7, v9, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 57
    new-array v4, v3, [Ljava/lang/String;

    const-string v5, "https://vuflix.co/"

    aput-object v5, v4, v1

    const-string v5, "https://toflix.co/"

    aput-object v5, v4, v2

    const-string v5, "Chillflix"

    const-string v7, "https://chillflix.lol/"

    const-string v9, "4K"

    invoke-direct {v0, v5, v7, v9, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 58
    const-string v4, "https://spacedom.live/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v7, "Spacedom"

    invoke-direct {v0, v7, v4, v10, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 59
    const-string v4, "https://dulo.mov/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v7, "dulo"

    invoke-direct {v0, v7, v4, v6, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 60
    const-string v4, "https://bingebang.st/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v7, "BingeBang"

    invoke-direct {v0, v7, v4, v6, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 61
    const-string v4, "https://koddo.to/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Koddo"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 62
    new-array v4, v1, [Ljava/lang/String;

    const-string v5, "Moonflix"

    const-string v6, "https://moonflix.website/"

    const-string v7, "film \u00b7 serier"

    invoke-direct {v0, v5, v6, v7, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 63
    const-string v4, "https://zenox.lol/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Zenox"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 64
    const-string v4, "https://nexa.mov/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Nexa"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 65
    const-string v4, "https://beta.way2movies.live/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Way2Movies"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 66
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://coreflix.tv/"

    aput-object v5, v4, v1

    const-string v5, "Reelix"

    const-string v6, "https://reelix.ac/"

    invoke-direct {v0, v5, v6, v8, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 67
    const-string v4, "https://cinemaos.live/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "CinemaOS"

    invoke-direct {v0, v6, v4, v7, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 68
    const-string v4, "4K \u00b7 guide: rentry.co/willow-guide"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Willow"

    const-string v10, "https://willowmovies.com/"

    invoke-direct {v0, v6, v10, v4, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 70
    const-string v4, "P-STREAM FORKS \u00b7 EGNE KILDER"

    invoke-direct {v0, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 71
    const-string v4, "https://cinecat.eu/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Cinecat"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 72
    new-array v4, v3, [Ljava/lang/String;

    const-string v5, "https://aether.cx/"

    aput-object v5, v4, v1

    const-string v5, "https://aether.ist/"

    aput-object v5, v4, v2

    const-string v5, "Aether"

    const-string v6, "https://aether.st/"

    invoke-direct {v0, v5, v6, v9, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 73
    const-string v4, "https://basementx.lol/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Basement"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 74
    new-array v4, v2, [Ljava/lang/String;

    const-string v5, "https://kdesa.app/"

    aput-object v5, v4, v1

    const-string v5, "kstream"

    const-string v6, "https://kdesa.stream/"

    const-string v10, "mirror: kdesa.app"

    invoke-direct {v0, v5, v6, v10, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 75
    const-string v4, "https://cinefork.net/"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "Cinefork"

    invoke-direct {v0, v6, v4, v9, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 76
    new-array v4, v3, [Ljava/lang/String;

    const-string v5, "https://pstream.site/"

    aput-object v5, v4, v1

    const-string v5, "https://streamwatch.pages.dev/"

    aput-object v5, v4, v2

    const-string v5, "StreamWatch"

    const-string v6, "https://streamwatch.online/"

    const-string v10, "P-Stream"

    invoke-direct {v0, v5, v6, v10, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 78
    const-string v4, "kopi\u00e9r source-lister herfra"

    new-array v5, v1, [Ljava/lang/String;

    const-string v6, "P-Stream kilder (GitHub)"

    const-string v10, "https://github.com/fmhy/edit/blob/main/docs/.vitepress/notes/movie-web-sources.md"

    invoke-direct {v0, v6, v10, v4, v5}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 81
    const-string v4, "DEDICATED SERVER \u00b7 STABILT PLAYER"

    invoke-direct {v0, v4}, Lsx/movybench/Catalog;->add(Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 82
    new-array v3, v3, [Ljava/lang/String;

    const-string v4, "https://nepu.app/"

    aput-object v4, v3, v1

    const-string v4, "https://nepu.is/"

    aput-object v4, v3, v2

    const-string v4, "NEPU"

    const-string v5, "https://nepu.io/"

    invoke-direct {v0, v4, v5, v9, v3}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 83
    new-array v2, v2, [Ljava/lang/String;

    const-string v3, "https://beta.cno.to/"

    aput-object v3, v2, v1

    const-string v3, "Cno"

    const-string v4, "https://cno.to/"

    const-string v5, "beta: beta.cno.to"

    invoke-direct {v0, v3, v4, v5, v2}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 84
    const-string v2, "dedicated player"

    new-array v3, v1, [Ljava/lang/String;

    const-string v4, "PressPlay"

    const-string v5, "https://pressplayx.to/"

    invoke-direct {v0, v4, v5, v2, v3}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 85
    const-string v2, "https://flixtrz.com/"

    new-array v3, v1, [Ljava/lang/String;

    const-string v4, "Flixtrz"

    invoke-direct {v0, v4, v2, v8, v3}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 86
    const-string v2, "https://cybermovies.ru/"

    new-array v3, v1, [Ljava/lang/String;

    const-string v4, "CyberMovies"

    invoke-direct {v0, v4, v2, v8, v3}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    .line 87
    const-string v2, "https://q62flix.ws/"

    new-array v1, v1, [Ljava/lang/String;

    const-string v3, "Q62"

    invoke-direct {v0, v3, v2, v7, v1}, Lsx/movybench/Catalog;->add(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)Lsx/movybench/Catalog;

    return-object v0
.end method


# virtual methods
.method public rows()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lsx/movybench/Catalog$Row;",
            ">;"
        }
    .end annotation

    .line 28
    iget-object v0, p0, Lsx/movybench/Catalog;->rows:Ljava/util/List;

    return-object v0
.end method
