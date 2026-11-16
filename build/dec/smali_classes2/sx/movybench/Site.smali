.class public final Lsx/movybench/Site;
.super Ljava/lang/Object;
.source "Site.java"


# instance fields
.field public final mirrors:[Ljava/lang/String;

.field public final name:Ljava/lang/String;

.field public final note:Ljava/lang/String;

.field public final url:Ljava/lang/String;


# direct methods
.method public varargs constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 12
    iput-object p1, p0, Lsx/movybench/Site;->name:Ljava/lang/String;

    .line 13
    iput-object p2, p0, Lsx/movybench/Site;->url:Ljava/lang/String;

    if-nez p3, :cond_0

    .line 14
    const-string p3, ""

    :cond_0
    iput-object p3, p0, Lsx/movybench/Site;->note:Ljava/lang/String;

    if-nez p4, :cond_1

    const/4 p1, 0x0

    .line 15
    new-array p4, p1, [Ljava/lang/String;

    :cond_1
    iput-object p4, p0, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public toString()Ljava/lang/String;
    .locals 1

    .line 18
    iget-object v0, p0, Lsx/movybench/Site;->name:Ljava/lang/String;

    return-object v0
.end method
