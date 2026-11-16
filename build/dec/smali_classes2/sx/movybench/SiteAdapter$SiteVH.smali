.class final Lsx/movybench/SiteAdapter$SiteVH;
.super Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
.source "SiteAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/SiteAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "SiteVH"
.end annotation


# instance fields
.field final count:Landroid/widget/TextView;

.field final monogram:Landroid/widget/TextView;

.field final name:Landroid/widget/TextView;

.field final note:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 1

    .line 121
    invoke-direct {p0, p1}, Landroidx/recyclerview/widget/RecyclerView$ViewHolder;-><init>(Landroid/view/View;)V

    .line 122
    sget v0, Lsx/movybench/R$id;->siteName:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/SiteAdapter$SiteVH;->name:Landroid/widget/TextView;

    .line 123
    sget v0, Lsx/movybench/R$id;->siteNote:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/SiteAdapter$SiteVH;->note:Landroid/widget/TextView;

    .line 124
    sget v0, Lsx/movybench/R$id;->mirrorCount:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/SiteAdapter$SiteVH;->count:Landroid/widget/TextView;

    .line 125
    sget v0, Lsx/movybench/R$id;->monogram:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lsx/movybench/SiteAdapter$SiteVH;->monogram:Landroid/widget/TextView;

    return-void
.end method
