.class Lsx/movybench/MainActivity$1;
.super Landroidx/recyclerview/widget/GridLayoutManager$SpanSizeLookup;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lsx/movybench/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lsx/movybench/MainActivity;

.field final synthetic val$columns:I


# direct methods
.method constructor <init>(Lsx/movybench/MainActivity;I)V
    .locals 0

    .line 56
    iput-object p1, p0, Lsx/movybench/MainActivity$1;->this$0:Lsx/movybench/MainActivity;

    iput p2, p0, Lsx/movybench/MainActivity$1;->val$columns:I

    invoke-direct {p0}, Landroidx/recyclerview/widget/GridLayoutManager$SpanSizeLookup;-><init>()V

    return-void
.end method


# virtual methods
.method public getSpanSize(I)I
    .locals 1

    .line 58
    iget-object v0, p0, Lsx/movybench/MainActivity$1;->this$0:Lsx/movybench/MainActivity;

    invoke-static {v0}, Lsx/movybench/MainActivity;->-$$Nest$fgetadapter(Lsx/movybench/MainActivity;)Lsx/movybench/SiteAdapter;

    move-result-object v0

    invoke-virtual {v0, p1}, Lsx/movybench/SiteAdapter;->getItemViewType(I)I

    move-result p1

    if-nez p1, :cond_0

    iget p1, p0, Lsx/movybench/MainActivity$1;->val$columns:I

    goto :goto_0

    :cond_0
    const/4 p1, 0x1

    :goto_0
    return p1
.end method
