.class public Lsx/movybench/SettingsActivity$Frag;
.super Landroidx/preference/PreferenceFragmentCompat;
.source "SettingsActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/SettingsActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "Frag"
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 25
    invoke-direct {p0}, Landroidx/preference/PreferenceFragmentCompat;-><init>()V

    return-void
.end method


# virtual methods
.method public onCreatePreferences(Landroid/os/Bundle;Ljava/lang/String;)V
    .locals 0

    .line 28
    sget p1, Lsx/movybench/R$xml;->prefs:I

    invoke-virtual {p0, p1, p2}, Lsx/movybench/SettingsActivity$Frag;->setPreferencesFromResource(ILjava/lang/String;)V

    return-void
.end method
