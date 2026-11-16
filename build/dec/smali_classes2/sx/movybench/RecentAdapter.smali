.class public final Lsx/movybench/RecentAdapter;
.super Landroidx/recyclerview/widget/RecyclerView$Adapter;
.source "RecentAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/RecentAdapter$VH;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/recyclerview/widget/RecyclerView$Adapter<",
        "Lsx/movybench/RecentAdapter$VH;",
        ">;"
    }
.end annotation


# static fields
.field private static final TINTS:[I


# instance fields
.field private final items:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lsx/movybench/Site;",
            ">;"
        }
    .end annotation
.end field

.field private final listener:Lsx/movybench/SiteAdapter$Listener;


# direct methods
.method public static synthetic $r8$lambda$tsCR3yiQwA3n5QP3W87d8PkZpIE(Lsx/movybench/RecentAdapter;Lsx/movybench/Site;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/RecentAdapter;->lambda$onBindViewHolder$0(Lsx/movybench/Site;Landroid/view/View;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x6

    .line 18
    new-array v0, v0, [I

    fill-array-data v0, :array_0

    sput-object v0, Lsx/movybench/RecentAdapter;->TINTS:[I

    return-void

    nop

    :array_0
    .array-data 4
        -0xc298
        -0x4fe0
        -0xca2f46
        -0x937301
        -0x388201
        -0xb52180
    .end array-data
.end method

.method public constructor <init>(Lsx/movybench/SiteAdapter$Listener;)V
    .locals 1

    .line 25
    invoke-direct {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;-><init>()V

    .line 22
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lsx/movybench/RecentAdapter;->items:Ljava/util/List;

    .line 26
    iput-object p1, p0, Lsx/movybench/RecentAdapter;->listener:Lsx/movybench/SiteAdapter$Listener;

    return-void
.end method

.method private synthetic lambda$onBindViewHolder$0(Lsx/movybench/Site;Landroid/view/View;)V
    .locals 0

    .line 50
    iget-object p2, p0, Lsx/movybench/RecentAdapter;->listener:Lsx/movybench/SiteAdapter$Listener;

    invoke-interface {p2, p1}, Lsx/movybench/SiteAdapter$Listener;->onSite(Lsx/movybench/Site;)V

    return-void
.end method


# virtual methods
.method public getItemCount()I
    .locals 1

    .line 53
    iget-object v0, p0, Lsx/movybench/RecentAdapter;->items:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    return v0
.end method

.method public bridge synthetic onBindViewHolder(Landroidx/recyclerview/widget/RecyclerView$ViewHolder;I)V
    .locals 0

    .line 16
    check-cast p1, Lsx/movybench/RecentAdapter$VH;

    invoke-virtual {p0, p1, p2}, Lsx/movybench/RecentAdapter;->onBindViewHolder(Lsx/movybench/RecentAdapter$VH;I)V

    return-void
.end method

.method public onBindViewHolder(Lsx/movybench/RecentAdapter$VH;I)V
    .locals 4

    .line 42
    iget-object v0, p0, Lsx/movybench/RecentAdapter;->items:Ljava/util/List;

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lsx/movybench/Site;

    .line 43
    iget-object v0, p1, Lsx/movybench/RecentAdapter$VH;->name:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 44
    iget-object v0, p1, Lsx/movybench/RecentAdapter$VH;->note:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->note:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 45
    iget-object v0, p1, Lsx/movybench/RecentAdapter$VH;->mono:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->name:Ljava/lang/String;

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 46
    sget-object v0, Lsx/movybench/RecentAdapter;->TINTS:[I

    iget-object v1, p2, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->hashCode()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Math;->abs(I)I

    move-result v1

    array-length v2, v0

    rem-int/2addr v1, v2

    aget v0, v0, v1

    .line 47
    iget-object v1, p1, Lsx/movybench/RecentAdapter$VH;->mono:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 48
    iget-object v1, p1, Lsx/movybench/RecentAdapter$VH;->mono:Landroid/widget/TextView;

    const/16 v2, 0x2c

    invoke-static {v0, v2}, Landroidx/core/graphics/ColorUtils;->setAlphaComponent(II)I

    move-result v0

    invoke-static {v0}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 49
    iget-object v0, p1, Lsx/movybench/RecentAdapter$VH;->itemView:Landroid/view/View;

    invoke-virtual {v0, v3}, Landroid/view/View;->setFocusable(Z)V

    .line 50
    iget-object p1, p1, Lsx/movybench/RecentAdapter$VH;->itemView:Landroid/view/View;

    new-instance v0, Lsx/movybench/RecentAdapter$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0, p2}, Lsx/movybench/RecentAdapter$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/RecentAdapter;Lsx/movybench/Site;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-void
.end method

.method public bridge synthetic onCreateViewHolder(Landroid/view/ViewGroup;I)Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
    .locals 0

    .line 16
    invoke-virtual {p0, p1, p2}, Lsx/movybench/RecentAdapter;->onCreateViewHolder(Landroid/view/ViewGroup;I)Lsx/movybench/RecentAdapter$VH;

    move-result-object p1

    return-object p1
.end method

.method public onCreateViewHolder(Landroid/view/ViewGroup;I)Lsx/movybench/RecentAdapter$VH;
    .locals 3

    .line 37
    new-instance p2, Lsx/movybench/RecentAdapter$VH;

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    sget v1, Lsx/movybench/R$layout;->item_recent:I

    const/4 v2, 0x0

    .line 38
    invoke-virtual {v0, v1, p1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    invoke-direct {p2, p1}, Lsx/movybench/RecentAdapter$VH;-><init>(Landroid/view/View;)V

    return-object p2
.end method

.method public setData(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/Site;",
            ">;)V"
        }
    .end annotation

    .line 30
    iget-object v0, p0, Lsx/movybench/RecentAdapter;->items:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 31
    iget-object v0, p0, Lsx/movybench/RecentAdapter;->items:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 32
    invoke-virtual {p0}, Lsx/movybench/RecentAdapter;->notifyDataSetChanged()V

    return-void
.end method
