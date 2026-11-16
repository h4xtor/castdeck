.class final Lsx/movybench/RecentAdapter$VH;
.super Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
.source "RecentAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/RecentAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "VH"
.end annotation


# instance fields
.field final mono:Landroid/widget/TextView;

.field final name:Landroid/widget/TextView;

.field final note:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 1

    .line 58
    invoke-direct {p0, p1}, Landroidx/recyclerview/widget/RecyclerView$ViewHolder;-><init>(Landroid/view/View;)V

    .line 59
    sget v0, Lsx/movybench/R$id;->monogram:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/RecentAdapter$VH;->mono:Landroid/widget/TextView;

    .line 60
    sget v0, Lsx/movybench/R$id;->siteName:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lsx/movybench/RecentAdapter$VH;->name:Landroid/widget/TextView;

    .line 61
    sget v0, Lsx/movybench/R$id;->siteNote:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lsx/movybench/RecentAdapter$VH;->note:Landroid/widget/TextView;

    return-void
.end method
