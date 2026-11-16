.class Lsx/movybench/MainActivity$2;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/text/TextWatcher;


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


# direct methods
.method constructor <init>(Lsx/movybench/MainActivity;)V
    .locals 0

    .line 67
    iput-object p1, p0, Lsx/movybench/MainActivity$2;->this$0:Lsx/movybench/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .locals 1

    .line 70
    iget-object v0, p0, Lsx/movybench/MainActivity$2;->this$0:Lsx/movybench/MainActivity;

    invoke-static {v0}, Lsx/movybench/MainActivity;->-$$Nest$fgetadapter(Lsx/movybench/MainActivity;)Lsx/movybench/SiteAdapter;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Lsx/movybench/SiteAdapter;->filter(Ljava/lang/String;)V

    return-void
.end method

.method public beforeTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0

    return-void
.end method

.method public onTextChanged(Ljava/lang/CharSequence;III)V
    .locals 0

    return-void
.end method
