.class public final Lsx/movybench/SiteAdapter;
.super Landroidx/recyclerview/widget/RecyclerView$Adapter;
.source "SiteAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/SiteAdapter$Listener;,
        Lsx/movybench/SiteAdapter$HeaderVH;,
        Lsx/movybench/SiteAdapter$SiteVH;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/recyclerview/widget/RecyclerView$Adapter<",
        "Landroidx/recyclerview/widget/RecyclerView$ViewHolder;",
        ">;"
    }
.end annotation


# static fields
.field private static final TINTS:[I

.field private static final T_HEADER:I = 0x0

.field private static final T_SITE:I = 0x1


# instance fields
.field private final all:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lsx/movybench/Catalog$Row;",
            ">;"
        }
    .end annotation
.end field

.field private final listener:Lsx/movybench/SiteAdapter$Listener;

.field private final shown:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lsx/movybench/Catalog$Row;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$UF5GLYx7EHU6BIGec4CMStsBJm8(Lsx/movybench/SiteAdapter;Lsx/movybench/Site;Landroid/view/View;)Z
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/SiteAdapter;->lambda$onBindViewHolder$1(Lsx/movybench/Site;Landroid/view/View;)Z

    move-result p0

    return p0
.end method

.method public static synthetic $r8$lambda$xjBeGBcpRrc1SzSyO2_oY7Nxz0A(Lsx/movybench/SiteAdapter;Lsx/movybench/Site;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lsx/movybench/SiteAdapter;->lambda$onBindViewHolder$0(Lsx/movybench/Site;Landroid/view/View;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x6

    .line 27
    new-array v0, v0, [I

    fill-array-data v0, :array_0

    sput-object v0, Lsx/movybench/SiteAdapter;->TINTS:[I

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

.method public constructor <init>(Ljava/util/List;Lsx/movybench/SiteAdapter$Listener;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/Catalog$Row;",
            ">;",
            "Lsx/movybench/SiteAdapter$Listener;",
            ")V"
        }
    .end annotation

    .line 35
    invoke-direct {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;-><init>()V

    .line 31
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lsx/movybench/SiteAdapter;->all:Ljava/util/List;

    .line 32
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    .line 36
    invoke-interface {v0, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 37
    invoke-interface {v1, p1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 38
    iput-object p2, p0, Lsx/movybench/SiteAdapter;->listener:Lsx/movybench/SiteAdapter$Listener;

    return-void
.end method

.method private static initial(Ljava/lang/String;)Ljava/lang/String;
    .locals 3

    const/4 v0, 0x0

    .line 101
    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v0, v1, :cond_1

    .line 102
    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    .line 103
    invoke-static {v1}, Ljava/lang/Character;->isLetterOrDigit(C)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-static {v1}, Ljava/lang/Character;->toUpperCase(C)C

    move-result p0

    invoke-static {p0}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 105
    :cond_1
    const-string p0, "\u2022"

    return-object p0
.end method

.method private synthetic lambda$onBindViewHolder$0(Lsx/movybench/Site;Landroid/view/View;)V
    .locals 0

    .line 96
    iget-object p2, p0, Lsx/movybench/SiteAdapter;->listener:Lsx/movybench/SiteAdapter$Listener;

    invoke-interface {p2, p1}, Lsx/movybench/SiteAdapter$Listener;->onSite(Lsx/movybench/Site;)V

    return-void
.end method

.method private synthetic lambda$onBindViewHolder$1(Lsx/movybench/Site;Landroid/view/View;)Z
    .locals 0

    .line 97
    iget-object p2, p0, Lsx/movybench/SiteAdapter;->listener:Lsx/movybench/SiteAdapter$Listener;

    invoke-interface {p2, p1}, Lsx/movybench/SiteAdapter$Listener;->onSiteLong(Lsx/movybench/Site;)V

    const/4 p1, 0x1

    return p1
.end method

.method public static typeAt(Ljava/util/List;I)I
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lsx/movybench/Catalog$Row;",
            ">;I)I"
        }
    .end annotation

    .line 60
    invoke-interface {p0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lsx/movybench/Catalog$Row;

    invoke-virtual {p0}, Lsx/movybench/Catalog$Row;->isHeader()Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0
.end method


# virtual methods
.method public filter(Ljava/lang/String;)V
    .locals 4

    .line 42
    iget-object v0, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    if-nez p1, :cond_0

    .line 43
    const-string p1, ""

    goto :goto_0

    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    sget-object v0, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {p1, v0}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object p1

    .line 44
    :goto_0
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 45
    iget-object p1, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    iget-object v0, p0, Lsx/movybench/SiteAdapter;->all:Ljava/util/List;

    invoke-interface {p1, v0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    goto :goto_2

    .line 47
    :cond_1
    iget-object v0, p0, Lsx/movybench/SiteAdapter;->all:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_2
    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_5

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lsx/movybench/Catalog$Row;

    .line 48
    invoke-virtual {v1}, Lsx/movybench/Catalog$Row;->isHeader()Z

    move-result v2

    if-eqz v2, :cond_3

    goto :goto_1

    .line 49
    :cond_3
    iget-object v2, v1, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    iget-object v2, v2, Lsx/movybench/Site;->name:Ljava/lang/String;

    sget-object v3, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    invoke-virtual {v2, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_4

    iget-object v2, v1, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    iget-object v2, v2, Lsx/movybench/Site;->note:Ljava/lang/String;

    sget-object v3, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 50
    invoke-virtual {v2, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_4

    iget-object v2, v1, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    iget-object v2, v2, Lsx/movybench/Site;->url:Ljava/lang/String;

    sget-object v3, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 51
    invoke-virtual {v2, v3}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2, p1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 52
    :cond_4
    iget-object v2, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 56
    :cond_5
    :goto_2
    invoke-virtual {p0}, Lsx/movybench/SiteAdapter;->notifyDataSetChanged()V

    return-void
.end method

.method public getItemCount()I
    .locals 1

    .line 108
    iget-object v0, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    return v0
.end method

.method public getItemViewType(I)I
    .locals 1

    .line 64
    iget-object v0, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lsx/movybench/Catalog$Row;

    invoke-virtual {p1}, Lsx/movybench/Catalog$Row;->isHeader()Z

    move-result p1

    xor-int/lit8 p1, p1, 0x1

    return p1
.end method

.method public onBindViewHolder(Landroidx/recyclerview/widget/RecyclerView$ViewHolder;I)V
    .locals 3

    .line 77
    iget-object v0, p0, Lsx/movybench/SiteAdapter;->shown:Ljava/util/List;

    invoke-interface {v0, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lsx/movybench/Catalog$Row;

    .line 78
    instance-of v0, p1, Lsx/movybench/SiteAdapter$HeaderVH;

    if-eqz v0, :cond_0

    .line 79
    check-cast p1, Lsx/movybench/SiteAdapter$HeaderVH;

    iget-object p1, p1, Lsx/movybench/SiteAdapter$HeaderVH;->label:Landroid/widget/TextView;

    iget-object p2, p2, Lsx/movybench/Catalog$Row;->header:Ljava/lang/String;

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    .line 82
    :cond_0
    check-cast p1, Lsx/movybench/SiteAdapter$SiteVH;

    .line 83
    iget-object p2, p2, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    .line 84
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->name:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 85
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->note:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->note:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 86
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->count:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    array-length v1, v1

    if-nez v1, :cond_1

    const-string v1, ""

    goto :goto_0

    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p2, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    array-length v2, v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " spejl"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 87
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->monogram:Landroid/widget/TextView;

    iget-object v1, p2, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-static {v1}, Lsx/movybench/SiteAdapter;->initial(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 89
    sget-object v0, Lsx/movybench/SiteAdapter;->TINTS:[I

    iget-object v1, p2, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->hashCode()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Math;->abs(I)I

    move-result v1

    array-length v2, v0

    rem-int/2addr v1, v2

    aget v0, v0, v1

    .line 90
    iget-object v1, p1, Lsx/movybench/SiteAdapter$SiteVH;->monogram:Landroid/widget/TextView;

    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 91
    iget-object v1, p1, Lsx/movybench/SiteAdapter$SiteVH;->monogram:Landroid/widget/TextView;

    const/16 v2, 0x2c

    .line 92
    invoke-static {v0, v2}, Landroidx/core/graphics/ColorUtils;->setAlphaComponent(II)I

    move-result v0

    invoke-static {v0}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v0

    .line 91
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 94
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->itemView:Landroid/view/View;

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/View;->setClickable(Z)V

    .line 95
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->itemView:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setFocusable(Z)V

    .line 96
    iget-object v0, p1, Lsx/movybench/SiteAdapter$SiteVH;->itemView:Landroid/view/View;

    new-instance v1, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0, p2}, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/SiteAdapter;Lsx/movybench/Site;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 97
    iget-object p1, p1, Lsx/movybench/SiteAdapter$SiteVH;->itemView:Landroid/view/View;

    new-instance v0, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p2}, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;-><init>(Lsx/movybench/SiteAdapter;Lsx/movybench/Site;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    return-void
.end method

.method public onCreateViewHolder(Landroid/view/ViewGroup;I)Landroidx/recyclerview/widget/RecyclerView$ViewHolder;
    .locals 3

    .line 69
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v0

    const/4 v1, 0x0

    if-nez p2, :cond_0

    .line 71
    new-instance p2, Lsx/movybench/SiteAdapter$HeaderVH;

    sget v2, Lsx/movybench/R$layout;->item_header:I

    invoke-virtual {v0, v2, p1, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    invoke-direct {p2, p1}, Lsx/movybench/SiteAdapter$HeaderVH;-><init>(Landroid/view/View;)V

    return-object p2

    .line 73
    :cond_0
    new-instance p2, Lsx/movybench/SiteAdapter$SiteVH;

    sget v2, Lsx/movybench/R$layout;->item_site:I

    invoke-virtual {v0, v2, p1, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    invoke-direct {p2, p1}, Lsx/movybench/SiteAdapter$SiteVH;-><init>(Landroid/view/View;)V

    return-object p2
.end method
