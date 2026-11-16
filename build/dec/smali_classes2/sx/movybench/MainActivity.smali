.class public Lsx/movybench/MainActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "MainActivity.java"

# interfaces
.implements Lsx/movybench/SiteAdapter$Listener;


# instance fields
.field private adapter:Lsx/movybench/SiteAdapter;

.field private final byName:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lsx/movybench/Site;",
            ">;"
        }
    .end annotation
.end field

.field private filter:Landroid/widget/EditText;

.field private list:Landroidx/recyclerview/widget/RecyclerView;

.field private recentAdapter:Lsx/movybench/RecentAdapter;

.field private recentView:Landroidx/recyclerview/widget/RecyclerView;

.field private recentsLabel:Landroid/widget/TextView;


# direct methods
.method public static synthetic $r8$lambda$HtdX9eWLRFoZOBuLjwQ4I0VnhQ0(Lsx/movybench/MainActivity;Lsx/movybench/Site;[Ljava/lang/String;Landroid/content/DialogInterface;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3, p4}, Lsx/movybench/MainActivity;->lambda$showMirrors$4(Lsx/movybench/Site;[Ljava/lang/String;Landroid/content/DialogInterface;I)V

    return-void
.end method

.method public static synthetic $r8$lambda$XtB1VCtqVN3Za4KuflYu_6LPS1Q(Lsx/movybench/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/MainActivity;->lambda$onCreate$0(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$euyvjIW0_vj5SGI4TaXhkWBH-SI(Lsx/movybench/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/MainActivity;->lambda$onCreate$2(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$fgMa8bO-Wl6hNWmLtX-sOb8IPV8(Lsx/movybench/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/MainActivity;->lambda$onCreate$3(Landroid/view/View;)V

    return-void
.end method

.method public static synthetic $r8$lambda$pmMqyCKNwf661Nxq_PBr5uK8Tng(Lsx/movybench/MainActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/MainActivity;->lambda$onCreate$1(Landroid/view/View;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$fgetadapter(Lsx/movybench/MainActivity;)Lsx/movybench/SiteAdapter;
    .locals 0

    iget-object p0, p0, Lsx/movybench/MainActivity;->adapter:Lsx/movybench/SiteAdapter;

    return-object p0
.end method

.method public constructor <init>()V
    .locals 1

    .line 25
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    .line 34
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lsx/movybench/MainActivity;->byName:Ljava/util/Map;

    return-void
.end method

.method private columns()I
    .locals 2

    .line 130
    invoke-virtual {p0}, Lsx/movybench/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    iget v0, v0, Landroid/content/res/Configuration;->screenWidthDp:I

    const/16 v1, 0x4b0

    if-lt v0, v1, :cond_0

    const/4 v0, 0x5

    return v0

    :cond_0
    const/16 v1, 0x384

    if-lt v0, v1, :cond_1

    const/4 v0, 0x4

    return v0

    :cond_1
    const/16 v1, 0x258

    if-lt v0, v1, :cond_2

    const/4 v0, 0x3

    return v0

    :cond_2
    const/4 v0, 0x2

    return v0
.end method

.method private focusSearch()V
    .locals 3

    .line 113
    iget-object v0, p0, Lsx/movybench/MainActivity;->filter:Landroid/widget/EditText;

    if-nez v0, :cond_0

    return-void

    .line 114
    :cond_0
    invoke-virtual {v0}, Landroid/widget/EditText;->requestFocus()Z

    .line 115
    const-string v0, "input_method"

    .line 116
    invoke-virtual {p0, v0}, Lsx/movybench/MainActivity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/inputmethod/InputMethodManager;

    if-eqz v0, :cond_1

    .line 117
    iget-object v1, p0, Lsx/movybench/MainActivity;->filter:Landroid/widget/EditText;

    const/4 v2, 0x1

    invoke-virtual {v0, v1, v2}, Landroid/view/inputmethod/InputMethodManager;->showSoftInput(Landroid/view/View;I)Z

    :cond_1
    return-void
.end method

.method private jumpToRecents()V
    .locals 2

    .line 121
    iget-object v0, p0, Lsx/movybench/MainActivity;->list:Landroidx/recyclerview/widget/RecyclerView;

    if-eqz v0, :cond_0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroidx/recyclerview/widget/RecyclerView;->scrollToPosition(I)V

    .line 122
    :cond_0
    iget-object v0, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroidx/recyclerview/widget/RecyclerView;->getVisibility()I

    move-result v0

    if-nez v0, :cond_1

    .line 123
    iget-object v0, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    invoke-virtual {v0}, Landroidx/recyclerview/widget/RecyclerView;->requestFocus()Z

    goto :goto_0

    .line 125
    :cond_1
    invoke-direct {p0}, Lsx/movybench/MainActivity;->focusSearch()V

    :goto_0
    return-void
.end method

.method private synthetic lambda$onCreate$0(Landroid/view/View;)V
    .locals 1

    .line 74
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lsx/movybench/SettingsActivity;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method private synthetic lambda$onCreate$1(Landroid/view/View;)V
    .locals 0

    .line 86
    invoke-direct {p0}, Lsx/movybench/MainActivity;->focusSearch()V

    return-void
.end method

.method private synthetic lambda$onCreate$2(Landroid/view/View;)V
    .locals 0

    .line 88
    invoke-direct {p0}, Lsx/movybench/MainActivity;->jumpToRecents()V

    return-void
.end method

.method private synthetic lambda$onCreate$3(Landroid/view/View;)V
    .locals 0

    .line 90
    invoke-static {p0}, Lsx/movybench/CastHelper;->openPicker(Landroid/app/Activity;)V

    return-void
.end method

.method private synthetic lambda$showMirrors$4(Lsx/movybench/Site;[Ljava/lang/String;Landroid/content/DialogInterface;I)V
    .locals 0

    .line 155
    aget-object p2, p2, p4

    invoke-direct {p0, p1, p2}, Lsx/movybench/MainActivity;->open(Lsx/movybench/Site;Ljava/lang/String;)V

    return-void
.end method

.method private open(Lsx/movybench/Site;Ljava/lang/String;)V
    .locals 2

    .line 161
    iget-object v0, p1, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-static {p0, v0}, Lsx/movybench/Prefs;->pushRecent(Landroid/content/Context;Ljava/lang/String;)V

    .line 162
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lsx/movybench/WebPlayerActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 163
    const-string v1, "url"

    invoke-virtual {v0, v1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 164
    const-string p2, "name"

    iget-object p1, p1, Lsx/movybench/Site;->name:Ljava/lang/String;

    invoke-virtual {v0, p2, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 165
    invoke-virtual {p0, v0}, Lsx/movybench/MainActivity;->startActivity(Landroid/content/Intent;)V

    return-void
.end method

.method private refreshRecents()V
    .locals 6

    .line 100
    iget-object v0, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lsx/movybench/MainActivity;->recentsLabel:Landroid/widget/TextView;

    if-nez v0, :cond_0

    goto :goto_3

    .line 101
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 102
    invoke-static {p0}, Lsx/movybench/Prefs;->recentList(Landroid/content/Context;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_1
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    .line 103
    iget-object v3, p0, Lsx/movybench/MainActivity;->byName:Ljava/util/Map;

    invoke-interface {v3, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lsx/movybench/Site;

    if-eqz v2, :cond_1

    .line 104
    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 106
    :cond_2
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    .line 107
    iget-object v2, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    const/4 v3, 0x0

    const/16 v4, 0x8

    if-nez v1, :cond_3

    move v5, v3

    goto :goto_1

    :cond_3
    move v5, v4

    :goto_1
    invoke-virtual {v2, v5}, Landroidx/recyclerview/widget/RecyclerView;->setVisibility(I)V

    .line 108
    iget-object v2, p0, Lsx/movybench/MainActivity;->recentsLabel:Landroid/widget/TextView;

    if-nez v1, :cond_4

    goto :goto_2

    :cond_4
    move v3, v4

    :goto_2
    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 109
    iget-object v1, p0, Lsx/movybench/MainActivity;->recentAdapter:Lsx/movybench/RecentAdapter;

    invoke-virtual {v1, v0}, Lsx/movybench/RecentAdapter;->setData(Ljava/util/List;)V

    :cond_5
    :goto_3
    return-void
.end method

.method private showMirrors(Lsx/movybench/Site;)V
    .locals 5

    .line 149
    iget-object v0, p1, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    array-length v0, v0

    const/4 v1, 0x1

    add-int/2addr v0, v1

    new-array v0, v0, [Ljava/lang/String;

    .line 150
    iget-object v2, p1, Lsx/movybench/Site;->url:Ljava/lang/String;

    const/4 v3, 0x0

    aput-object v2, v0, v3

    .line 151
    iget-object v2, p1, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    iget-object v4, p1, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    array-length v4, v4

    invoke-static {v2, v3, v0, v1, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 153
    new-instance v1, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    invoke-direct {v1, p0}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;-><init>(Landroid/content/Context;)V

    iget-object v2, p1, Lsx/movybench/Site;->name:Ljava/lang/String;

    .line 154
    invoke-virtual {v1, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setTitle(Ljava/lang/CharSequence;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object v1

    new-instance v2, Lsx/movybench/MainActivity$$ExternalSyntheticLambda0;

    invoke-direct {v2, p0, p1, v0}, Lsx/movybench/MainActivity$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/MainActivity;Lsx/movybench/Site;[Ljava/lang/String;)V

    .line 155
    invoke-virtual {v1, v0, v2}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    sget v0, Lsx/movybench/R$string;->cancel:I

    const/4 v1, 0x0

    .line 156
    invoke-virtual {p1, v0, v1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;

    move-result-object p1

    .line 157
    invoke-virtual {p1}, Lcom/google/android/material/dialog/MaterialAlertDialogBuilder;->show()Landroidx/appcompat/app/AlertDialog;

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 6

    .line 38
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 39
    sget p1, Lsx/movybench/R$layout;->activity_main:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->setContentView(I)V

    .line 41
    invoke-static {}, Lsx/movybench/Catalog;->build()Lsx/movybench/Catalog;

    move-result-object p1

    invoke-virtual {p1}, Lsx/movybench/Catalog;->rows()Ljava/util/List;

    move-result-object p1

    .line 43
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lsx/movybench/Catalog$Row;

    .line 44
    invoke-virtual {v3}, Lsx/movybench/Catalog$Row;->isHeader()Z

    move-result v4

    if-eqz v4, :cond_0

    goto :goto_0

    :cond_0
    add-int/lit8 v2, v2, 0x1

    .line 46
    iget-object v4, p0, Lsx/movybench/MainActivity;->byName:Ljava/util/Map;

    iget-object v5, v3, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    iget-object v5, v5, Lsx/movybench/Site;->name:Ljava/lang/String;

    iget-object v3, v3, Lsx/movybench/Catalog$Row;->site:Lsx/movybench/Site;

    invoke-interface {v4, v5, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    .line 49
    :cond_1
    sget v0, Lsx/movybench/R$id;->stats:I

    invoke-virtual {p0, v0}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " sider \u00b7 cast \u00b7 danske undertekster"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 52
    invoke-direct {p0}, Lsx/movybench/MainActivity;->columns()I

    move-result v0

    .line 54
    sget v2, Lsx/movybench/R$id;->list:I

    invoke-virtual {p0, v2}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroidx/recyclerview/widget/RecyclerView;

    iput-object v2, p0, Lsx/movybench/MainActivity;->list:Landroidx/recyclerview/widget/RecyclerView;

    .line 55
    new-instance v2, Landroidx/recyclerview/widget/GridLayoutManager;

    invoke-direct {v2, p0, v0}, Landroidx/recyclerview/widget/GridLayoutManager;-><init>(Landroid/content/Context;I)V

    .line 56
    new-instance v3, Lsx/movybench/MainActivity$1;

    invoke-direct {v3, p0, v0}, Lsx/movybench/MainActivity$1;-><init>(Lsx/movybench/MainActivity;I)V

    invoke-virtual {v2, v3}, Landroidx/recyclerview/widget/GridLayoutManager;->setSpanSizeLookup(Landroidx/recyclerview/widget/GridLayoutManager$SpanSizeLookup;)V

    .line 61
    iget-object v0, p0, Lsx/movybench/MainActivity;->list:Landroidx/recyclerview/widget/RecyclerView;

    invoke-virtual {v0, v2}, Landroidx/recyclerview/widget/RecyclerView;->setLayoutManager(Landroidx/recyclerview/widget/RecyclerView$LayoutManager;)V

    .line 63
    new-instance v0, Lsx/movybench/SiteAdapter;

    invoke-direct {v0, p1, p0}, Lsx/movybench/SiteAdapter;-><init>(Ljava/util/List;Lsx/movybench/SiteAdapter$Listener;)V

    iput-object v0, p0, Lsx/movybench/MainActivity;->adapter:Lsx/movybench/SiteAdapter;

    .line 64
    iget-object p1, p0, Lsx/movybench/MainActivity;->list:Landroidx/recyclerview/widget/RecyclerView;

    invoke-virtual {p1, v0}, Landroidx/recyclerview/widget/RecyclerView;->setAdapter(Landroidx/recyclerview/widget/RecyclerView$Adapter;)V

    .line 66
    sget p1, Lsx/movybench/R$id;->filter:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lsx/movybench/MainActivity;->filter:Landroid/widget/EditText;

    .line 67
    new-instance v0, Lsx/movybench/MainActivity$2;

    invoke-direct {v0, p0}, Lsx/movybench/MainActivity$2;-><init>(Lsx/movybench/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->addTextChangedListener(Landroid/text/TextWatcher;)V

    .line 73
    sget p1, Lsx/movybench/R$id;->gear:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 74
    new-instance v0, Lsx/movybench/MainActivity$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0}, Lsx/movybench/MainActivity$$ExternalSyntheticLambda1;-><init>(Lsx/movybench/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const/4 v0, 0x1

    .line 75
    invoke-virtual {p1, v0}, Landroid/view/View;->setFocusable(Z)V

    .line 77
    sget p1, Lsx/movybench/R$id;->recents:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroidx/recyclerview/widget/RecyclerView;

    iput-object p1, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    .line 78
    sget p1, Lsx/movybench/R$id;->recentsLabel:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lsx/movybench/MainActivity;->recentsLabel:Landroid/widget/TextView;

    .line 79
    iget-object p1, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    if-eqz p1, :cond_2

    .line 80
    new-instance v0, Landroidx/recyclerview/widget/LinearLayoutManager;

    invoke-direct {v0, p0, v1, v1}, Landroidx/recyclerview/widget/LinearLayoutManager;-><init>(Landroid/content/Context;IZ)V

    invoke-virtual {p1, v0}, Landroidx/recyclerview/widget/RecyclerView;->setLayoutManager(Landroidx/recyclerview/widget/RecyclerView$LayoutManager;)V

    .line 81
    new-instance p1, Lsx/movybench/RecentAdapter;

    invoke-direct {p1, p0}, Lsx/movybench/RecentAdapter;-><init>(Lsx/movybench/SiteAdapter$Listener;)V

    iput-object p1, p0, Lsx/movybench/MainActivity;->recentAdapter:Lsx/movybench/RecentAdapter;

    .line 82
    iget-object v0, p0, Lsx/movybench/MainActivity;->recentView:Landroidx/recyclerview/widget/RecyclerView;

    invoke-virtual {v0, p1}, Landroidx/recyclerview/widget/RecyclerView;->setAdapter(Landroidx/recyclerview/widget/RecyclerView$Adapter;)V

    .line 85
    :cond_2
    sget p1, Lsx/movybench/R$id;->tabSearch:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    if-eqz p1, :cond_3

    .line 86
    new-instance v0, Lsx/movybench/MainActivity$$ExternalSyntheticLambda2;

    invoke-direct {v0, p0}, Lsx/movybench/MainActivity$$ExternalSyntheticLambda2;-><init>(Lsx/movybench/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 87
    :cond_3
    sget p1, Lsx/movybench/R$id;->tabRecents:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    if-eqz p1, :cond_4

    .line 88
    new-instance v0, Lsx/movybench/MainActivity$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0}, Lsx/movybench/MainActivity$$ExternalSyntheticLambda3;-><init>(Lsx/movybench/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 89
    :cond_4
    sget p1, Lsx/movybench/R$id;->tabCast:I

    invoke-virtual {p0, p1}, Lsx/movybench/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    if-eqz p1, :cond_5

    .line 90
    new-instance v0, Lsx/movybench/MainActivity$$ExternalSyntheticLambda4;

    invoke-direct {v0, p0}, Lsx/movybench/MainActivity$$ExternalSyntheticLambda4;-><init>(Lsx/movybench/MainActivity;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :cond_5
    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 95
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onResume()V

    .line 96
    invoke-direct {p0}, Lsx/movybench/MainActivity;->refreshRecents()V

    return-void
.end method

.method public onSite(Lsx/movybench/Site;)V
    .locals 1

    .line 139
    iget-object v0, p1, Lsx/movybench/Site;->mirrors:[Ljava/lang/String;

    array-length v0, v0

    if-lez v0, :cond_0

    invoke-direct {p0, p1}, Lsx/movybench/MainActivity;->showMirrors(Lsx/movybench/Site;)V

    goto :goto_0

    .line 140
    :cond_0
    iget-object v0, p1, Lsx/movybench/Site;->url:Ljava/lang/String;

    invoke-direct {p0, p1, v0}, Lsx/movybench/MainActivity;->open(Lsx/movybench/Site;Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public onSiteLong(Lsx/movybench/Site;)V
    .locals 0

    .line 145
    invoke-direct {p0, p1}, Lsx/movybench/MainActivity;->showMirrors(Lsx/movybench/Site;)V

    return-void
.end method
