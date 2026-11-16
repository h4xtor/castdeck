.class public final Lsx/movybench/sub/Srt$Cue;
.super Ljava/lang/Object;
.source "Srt.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lsx/movybench/sub/Srt;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Cue"
.end annotation


# instance fields
.field public final end:J

.field public final start:J

.field public final text:Ljava/lang/String;


# direct methods
.method constructor <init>(JJLjava/lang/String;)V
    .locals 0

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-wide p1, p0, Lsx/movybench/sub/Srt$Cue;->start:J

    iput-wide p3, p0, Lsx/movybench/sub/Srt$Cue;->end:J

    iput-object p5, p0, Lsx/movybench/sub/Srt$Cue;->text:Ljava/lang/String;

    return-void
.end method
