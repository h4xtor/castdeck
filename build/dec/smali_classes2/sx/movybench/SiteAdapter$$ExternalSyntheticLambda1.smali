.class public final synthetic Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/view/View$OnLongClickListener;


# instance fields
.field public final synthetic f$0:Lsx/movybench/SiteAdapter;

.field public final synthetic f$1:Lsx/movybench/Site;


# direct methods
.method public synthetic constructor <init>(Lsx/movybench/SiteAdapter;Lsx/movybench/Site;)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;->f$0:Lsx/movybench/SiteAdapter;

    iput-object p2, p0, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;->f$1:Lsx/movybench/Site;

    return-void
.end method


# virtual methods
.method public final onLongClick(Landroid/view/View;)Z
    .locals 2

    .line 0
    iget-object v0, p0, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;->f$0:Lsx/movybench/SiteAdapter;

    iget-object v1, p0, Lsx/movybench/SiteAdapter$$ExternalSyntheticLambda1;->f$1:Lsx/movybench/Site;

    invoke-static {v0, v1, p1}, Lsx/movybench/SiteAdapter;->$r8$lambda$UF5GLYx7EHU6BIGec4CMStsBJm8(Lsx/movybench/SiteAdapter;Lsx/movybench/Site;Landroid/view/View;)Z

    move-result p1

    return p1
.end method
