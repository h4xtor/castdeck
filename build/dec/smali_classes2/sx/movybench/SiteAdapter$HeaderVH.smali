.class final Lsx/movybench/SiteAdapter$HeaderVH;
.super Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
.source "SiteAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/SiteAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "HeaderVH"
.end annotation


# instance fields
.field final label:Landroid/widget/TextView;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 1

    .line 113
    invoke-direct {p0, p1}, Landroidx/recyclerview/widget/RecyclerView$ViewHolder;-><init>(Landroid/view/View;)V

    .line 114
    sget v0, Lsx/movybench/R$id;->headerLabel:I

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lsx/movybench/SiteAdapter$HeaderVH;->label:Landroid/widget/TextView;

    return-void
.end method
