.class public final Lsx/movybench/Catalog$Row;
.super Ljava/lang/Object;
.source "Catalog.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/Catalog;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Row"
.end annotation


# instance fields
.field public final header:Ljava/lang/String;

.field public final site:Lsx/movybench/Site;


# direct methods
.method private constructor <init>(Ljava/lang/String;Lsx/movybench/Site;)V
    .locals 0

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lsx/movybench/Catalog$Row;->header:Ljava/lang/String;

    iput-object p2, p0, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    return-void
.end method

.method static header(Ljava/lang/String;)Lsx/movybench/Catalog$Row;
    .locals 2

    .line 14
    new-instance v0, Lsx/movybench/Catalog$Row;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1}, Lsx/movybench/Catalog$Row;-><init>(Ljava/lang/String;Lsx/movybench/Site;)V

    return-object v0
.end method

.method static site(Lsx/movybench/Site;)Lsx/movybench/Catalog$Row;
    .locals 2

    .line 15
    new-instance v0, Lsx/movybench/Catalog$Row;

    const/4 v1, 0x0

    invoke-direct {v0, v1, p0}, Lsx/movybench/Catalog$Row;-><init>(Ljava/lang/String;Lsx/movybench/Site;)V

    return-object v0
.end method


# virtual methods
.method public isHeader()Z
    .locals 1

    .line 16
    iget-object v0, p0, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method
