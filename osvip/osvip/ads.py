"""Website ad-block list (uBlock Origin) + subtitle ad-line stripper."""
from __future__ import annotations

import re

UBLOCK_LIST = """! Title: OpenSubtitles - popunders, banners, offer interstitials
! Updated: 2026-11-16
! uBlock Origin -> Settings -> Filter lists -> Import -> paste this file
! Direct downloads without any of this: python -m osvip get --query "..."

! --- popunders/popups on subtitle properties ---
*$popup,domain=opensubtitles.com|opensubtitles.org|opensubtitles.net|opensubtitles.com.br

! --- third-party ad networks ---
||adsterra.com^
||propellerads.com^
||propellerclick.com^
||onclkds.com^
||popads.net^
||popunder.net^
||popmyads.com^
||exoclick.com^
||exosrv.com^
||juicyads.com^
||trafficjunky.com^
||hilltopads.net^
||revenuehits.com^
||adskeeper.com^
||mgid.com^
||taboola.com^
||outbrain.com^
||yllix.com^
||adf.ly^
||sh.st^
||ouo.io^
||linkvertise.com^
||flashclicks.com^
||adsupply.com^
||zeropark.com^
||adnium.com^
||onclickads.net^
||doubleclick.net^
||googlesyndication.com^
||amazon-adsystem.com^
||criteo.com^
||rubiconproject.com^
||openx.net^
||casalemedia.com^
||pubmatic.com^
||adform.net^
||smartadserver.com^

! --- on-page ad slots ---
opensubtitles.com|opensubtitles.org|opensubtitles.net##.ad
opensubtitles.com|opensubtitles.org|opensubtitles.net##.ads
opensubtitles.com|opensubtitles.org|opensubtitles.net##.banner
opensubtitles.com|opensubtitles.org|opensubtitles.net##.sponsor
opensubtitles.com|opensubtitles.org|opensubtitles.net##[class*="advert"]
opensubtitles.com|opensubtitles.org|opensubtitles.net##[id*="advert"]
opensubtitles.com|opensubtitles.org|opensubtitles.net##[id^="ad-"]
opensubtitles.com|opensubtitles.org|opensubtitles.net##[class^="ad-"]
opensubtitles.com|opensubtitles.org|opensubtitles.net##[data-ad]
opensubtitles.com|opensubtitles.org|opensubtitles.net##iframe[src*="doubleclick"]
opensubtitles.com|opensubtitles.org|opensubtitles.net##iframe[src*="adsterra"]
opensubtitles.com|opensubtitles.org|opensubtitles.net##iframe[src*="propellerads"]
"""

_AD_RE = re.compile(
    r"(?i)(osdb\.link|become\b[^.]{0,40}\bvip\b|support us|www\.opensubtitles"
    r"|opensubtitles\.(org|com|net)|downloaded from|please (visit|support|disable)"
    r"|advertis|sponsor)"
)
_URL_ONLY = re.compile(r"^\s*https?://\S+\s*$")


def _is_ad(text: str) -> bool:
    t = text.strip()
    if not t or len(t) > 160:
        return False
    if _URL_ONLY.match(t):
        return bool(re.search(r"opensubtitles|osdb", t, re.I))
    return bool(_AD_RE.search(t))


def strip_subtitle_ads(text: str) -> tuple[str, int]:
    """Drop ad cues from an SRT, renumber the rest. Returns (clean_text, removed)."""
    blocks = re.split(r"\n\s*\n", text.replace("\r\n", "\n").strip())
    kept: list[str] = []
    removed = 0
    for block in blocks:
        lines = block.split("\n")
        if len(lines) >= 2 and "-->" in lines[1]:
            cue_text = "\n".join(lines[2:])
            if _is_ad(cue_text):
                removed += 1
                continue
            kept.append(block)
        else:
            kept.append(block)
    out = []
    counter = 0
    for block in kept:
        lines = block.split("\n")
        if len(lines) >= 2 and "-->" in lines[1]:
            counter += 1
            lines[0] = str(counter)
            out.append("\n".join(lines))
        else:
            out.append(block)
    return "\n\n".join(out) + "\n", removed
