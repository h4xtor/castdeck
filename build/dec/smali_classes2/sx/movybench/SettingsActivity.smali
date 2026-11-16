.class public Lsx/movybench/SettingsActivity;
.super Landroidx/appcompat/app/AppCompatActivity;
.source "SettingsActivity.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lsx/movybench/SettingsActivity$Frag;
    }
.end annotation


# direct methods
.method public static synthetic $r8$lambda$LYDRSl0r7l98GSHO0orL3JW9luk(Lsx/movybench/SettingsActivity;Landroid/view/View;)V
    .locals 0

    invoke-direct {p0, p1}, Lsx/movybench/SettingsActivity;->lambda$onCreate$0(Landroid/view/View;)V

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 8
    invoke-direct {p0}, Landroidx/appcompat/app/AppCompatActivity;-><init>()V

    return-void
.end method

.method private synthetic lambda$onCreate$0(Landroid/view/View;)V
    .locals 0

    .line 15
    invoke-virtual {p0}, Lsx/movybench/SettingsActivity;->finish()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 12
    invoke-super {p0, p1}, Landroidx/appcompat/app/AppCompatActivity;->onCreate(Landroid/os/Bundle;)V

    .line 13
    sget v0, Lsx/movybench/R$layout;->activity_settings:I

    invoke-virtual {p0, v0}, Lsx/movybench/SettingsActivity;->setContentView(I)V

    .line 15
    sget v0, Lsx/movybench/R$id;->back:I

    invoke-virtual {p0, v0}, Lsx/movybench/SettingsActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    new-instance v1, Lsx/movybench/SettingsActivity$$ExternalSyntheticLambda0;

    invoke-direct {v1, p0}, Lsx/movybench/SettingsActivity$$ExternalSyntheticLambda0;-><init>(Lsx/movybench/SettingsActivity;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 16
    sget v0, Lsx/movybench/R$id;->back:I

    invoke-virtual {p0, v0}, Lsx/movybench/SettingsActivity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/View;->setFocusable(Z)V

    if-nez p1, :cond_0

    .line 19
    invoke-virtual {p0}, Lsx/movybench/SettingsActivity;->getSupportFragmentManager()Landroidx/fragment/app/FragmentManager;

    move-result-object p1

    invoke-virtual {p1}, Landroidx/fragment/app/FragmentManager;->beginTransaction()Landroidx/fragment/app/FragmentTransaction;

    move-result-object p1

    sget v0, Lsx/movybench/R$id;->container:I

    new-instance v1, Lsx/movybench/SettingsActivity$Frag;

    invoke-direct {v1}, Lsx/movybench/SettingsActivity$Frag;-><init>()V

    .line 20
    invoke-virtual {p1, v0, v1}, Landroidx/fragment/app/FragmentTransaction;->replace(ILandroidx/fragment/app/Fragment;)Landroidx/fragment/app/FragmentTransaction;

    move-result-object p1

    .line 21
    invoke-virtual {p1}, Landroidx/fragment/app/FragmentTransaction;->commit()I

    :cond_0
    return-void
.end method
