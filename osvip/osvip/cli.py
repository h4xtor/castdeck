"""Command line entry point for osvip."""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time

import requests

from . import ads as ads_mod
from .api import (APIError, AuthError, Client, DEFAULT_BASE, QuotaExceeded,
                  RateLimited, USER_AGENT, decode_subtitle)
from .osdb import moviehash
from .pool import Pool


def load_config(path: str) -> dict:
    if not os.path.isfile(path):
        return {}
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def need_key(cfg: dict) -> str:
    key = (cfg.get("api_key") or "").strip()
    if not key or key == "CHANGE_ME":
        sys.exit("api_key missing - register a consumer key on opensubtitles.com "
                 "(profile -> API consumers) and set it in osvip.json")
    return key


def _client(cfg: dict, proxy: str | None = None) -> Client:
    return Client(need_key(cfg), cfg.get("user_agent", USER_AGENT),
                  cfg.get("base_url", DEFAULT_BASE),
                  proxy if proxy is not None else cfg.get("proxy"))


def _hash_arg(value: str) -> str:
    if re.fullmatch(r"[0-9a-fA-F]{16}", value):
        return value.lower()
    if not os.path.isfile(value):
        sys.exit(f"file not found: {value}")
    return moviehash(value)


def _search(client: Client, args) -> list[dict]:
    mh = _hash_arg(args.moviehash) if getattr(args, "moviehash", None) else None
    results: list[dict] = []
    page = 1
    while len(results) < args.limit and page <= 10:
        batch = client.search(
            moviehash=mh, query=getattr(args, "query", None),
            languages=args.lang, page=page, page_size=min(50, args.limit),
            season=getattr(args, "season", None),
            episode=getattr(args, "episode", None),
        )
        if not batch:
            break
        results.extend(batch)
        page += 1
    return results[: args.limit]


def _write_sub(out_dir: str, cand: dict, text: str, lang: str, file_id: int) -> str:
    name = cand.get("file_name") or cand.get("release") or f"sub_{file_id}"
    name = re.sub(r'[<>:"/\\|?*\x00-\x1f]', "_", name).strip(" .")
    if not name.lower().endswith((".srt", ".vtt", ".txt", ".sub", ".ass",
                                  ".ssa", ".dfxp", ".ttml")):
        name = f"{name}.{lang or 'und'}.srt"
    path = os.path.join(out_dir, name)
    if os.path.exists(path):
        stem, ext = os.path.splitext(path)
        path = f"{stem}_{file_id}{ext}"
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write(text)
    return path


def _finish(res, cand, text, out_dir, args, who: str) -> None:
    if not args.keep_ads:
        text, removed = ads_mod.strip_subtitle_ads(text)
        if removed:
            print(f"stripped {removed} ad cue(s)")
    path = _write_sub(out_dir, cand, text, args.lang, cand["file_id"])
    print(f"saved {path}   ({who})")


# ---------------------------------------------------------------- commands

def cmd_probe(args, cfg) -> None:
    key = (cfg.get("api_key") or "").strip() or "unset"
    client = Client(key, cfg.get("user_agent", USER_AGENT),
                    cfg.get("base_url", DEFAULT_BASE), cfg.get("proxy"))
    res = client.probe()
    ep = res.get("endpoint", {})
    if ep.get("status") == 200:
        print(f"endpoint : 200 ok | rate {ep.get('rate')}/s | vip={ep.get('vip')} "
              f"vip_user={ep.get('vip_user')} vip_consumer={ep.get('vip_consumer')}")
    else:
        print(f"endpoint : {ep.get('status')} {ep.get('error', '')}")
    se = res.get("search", {})
    st = se.get("status")
    if st == 200:
        print("api key  : valid")
    elif st == 403 and "cannot consume" in (se.get("message") or ""):
        print("api key  : INVALID - register a consumer key, set api_key in osvip.json")
    else:
        print(f"api key  : {st} {se.get('message', '')}")
    if args.anon_test:
        try:
            r = client.download(args.anon_test, token=None)
            print(f"anon dl  : OK remaining={r.remaining} link={r.link[:60]}...")
        except AuthError as e:
            print(f"anon dl  : disabled ({e.message[:90]}) - enable 'allow "
                  f"anonymous downloads' on the consumer")
        except (QuotaExceeded, APIError) as e:
            print(f"anon dl  : {e.message[:120]}")
    pool = Pool(cfg.get("accounts_file", "accounts.json"))
    if pool.accounts:
        print(pool.report())
        if args.login:
            ok, fail = pool.login_all(client)
            print(f"login    : ok={ok} fail={fail}")
            print(pool.report())
    else:
        print("accounts : none (run farm or pool add)")


def cmd_search(args, cfg) -> None:
    client = _client(cfg)
    results = _search(client, args)
    if args.json:
        print(json.dumps(results, indent=2))
        return
    if not results:
        sys.exit("no results")
    print(f"{'file_id':>9}  {'lang':<5} {'dl':>7} {'hash':<4} name")
    for r in results:
        print(f"{r['file_id']:>9}  {r['language']:<5} {r['downloads']:>7} "
              f"{'*' if r['moviehash_match'] else '':<4} "
              f"{(r['file_name'] or r['release'])[:70]}")


def cmd_get(args, cfg) -> None:
    client = _client(cfg)
    if args.file_id:
        cands = [{"file_id": args.file_id, "file_name": "",
                  "language": args.lang, "downloads": 0, "rating": 0,
                  "moviehash_match": False, "release": ""}]
    else:
        cands = _search(client, args)
        if not cands:
            sys.exit("no results")
        cands.sort(key=lambda c: (c["moviehash_match"], c["downloads"],
                                  c["rating"]), reverse=True)
        cands = cands[:3]

    out_dir = args.out or cfg.get("out_dir") or "subs"
    os.makedirs(out_dir, exist_ok=True)

    if args.anon:
        _get_anon(cfg, cands, out_dir, args)
        return

    pool = Pool(cfg.get("accounts_file", "accounts.json"))
    if not pool.accounts:
        sys.exit("pool empty - run: python -m osvip farm --count 10 "
                 "(or pool add USER PASS)")
    ok, fail = pool.login_all(client)
    if ok == 0:
        sys.exit(f"no account logged in ({fail} failed) - "
                 "python -m osvip pool report")

    last: Exception | None = None
    for cand in cands:
        attempts = 0
        max_attempts = len(pool.accounts) + 2
        while attempts < max_attempts:
            acct = pool.acquire()
            if acct is None:
                w = pool.wait_seconds()
                if w and w > 1:
                    sys.exit(f"all accounts spent - retry in {int(w)}s")
                sys.exit("no usable account - run: python -m osvip pool login")
            attempts += 1
            try:
                res = client.download(cand["file_id"], token=acct.token)
                pool.mark_download(acct, res)
                blob = Client.fetch_file(res.link)
                text = decode_subtitle(blob)
                left = (acct.allowed - acct.used) if acct.allowed else "?"
                _finish(res, cand, text, out_dir, args,
                        f"{acct.username}, remaining {left}")
                return
            except AuthError:
                if not pool.relogin(client, acct):
                    continue
            except QuotaExceeded as e:
                pool.mark_quota(acct, e.reset_utc)
            except RateLimited:
                time.sleep(2)
            except (APIError, OSError, requests.RequestException) as e:
                last = e
                break
    sys.exit(f"download failed: {last}")


def _get_anon(cfg: dict, cands: list[dict], out_dir: str, args) -> None:
    key = need_key(cfg)
    ua = cfg.get("user_agent", USER_AGENT)
    base = cfg.get("base_url", DEFAULT_BASE)
    proxies = cfg.get("proxies") or [None]
    last: Exception | None = None
    for cand in cands:
        for proxy in proxies:
            client = Client(key, ua, base, proxy)
            try:
                res = client.download(cand["file_id"], token=None)
                blob = Client.fetch_file(res.link)
                text = decode_subtitle(blob)
                _finish(res, cand, text, out_dir, args,
                        f"anonymous via {proxy or 'direct'}, "
                        f"remaining {res.remaining}")
                return
            except AuthError as e:
                sys.exit(f"anonymous downloads disabled ({e.message[:80]}) - "
                         "enable 'allow anonymous downloads' on the consumer, "
                         "or drop --anon")
            except QuotaExceeded as e:
                last = e
            except RateLimited:
                time.sleep(2)
            except (APIError, OSError, requests.RequestException) as e:
                last = e
                break
    sys.exit(f"download failed: {last}")


def cmd_pool(args, cfg) -> None:
    pool = Pool(cfg.get("accounts_file", "accounts.json"))
    if args.action in ("list", "report"):
        print(pool.report())
    elif args.action == "add":
        if len(args.creds) != 2:
            sys.exit("usage: pool add USERNAME PASSWORD")
        print("added" if pool.add(args.creds[0], args.creds[1]) else "already present")
    elif args.action == "remove":
        if len(args.creds) != 1:
            sys.exit("usage: pool remove USERNAME")
        print("removed" if pool.remove(args.creds[0]) else "not found")
    elif args.action == "login":
        client = _client(cfg)
        ok, fail = pool.login_all(client)
        print(f"logged in {ok}, failed {fail}")
        print(pool.report())


def cmd_ads(args, cfg) -> None:
    if args.out:
        with open(args.out, "w", encoding="utf-8") as f:
            f.write(ads_mod.UBLOCK_LIST)
        print(f"wrote {args.out}")
    else:
        print(ads_mod.UBLOCK_LIST)


def cmd_clean(args, cfg) -> None:
    with open(args.file, encoding="utf-8", errors="replace") as f:
        text = f.read()
    cleaned, removed = ads_mod.strip_subtitle_ads(text)
    if args.out:
        with open(args.out, "w", encoding="utf-8", newline="") as f:
            f.write(cleaned)
        print(f"wrote {args.out} ({removed} ad cue(s) removed)")
    elif args.in_place:
        with open(args.file, "w", encoding="utf-8", newline="") as f:
            f.write(cleaned)
        print(f"cleaned {args.file} ({removed} ad cue(s) removed)")
    else:
        sys.stdout.write(cleaned)


def cmd_farm(args, cfg) -> None:
    from .farm import run_farm
    made = run_farm(count=args.count, cfg=cfg, headed=not args.headless,
                    captcha_key=args.captcha or cfg.get("captcha_key"),
                    manual=args.manual, delay=args.delay,
                    signup_url=cfg.get("signup_url"))
    print(f"created {made} account(s) -> {cfg.get('accounts_file', 'accounts.json')}")
    print("next: python -m osvip pool login")


# ---------------------------------------------------------------- parser

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(prog="osvip",
                                description="OpenSubtitles VIP-equivalent toolkit")
    sub = p.add_subparsers(dest="cmd", required=True)

    def add(name, fn, help_text):
        sp = sub.add_parser(name, help=help_text)
        sp.add_argument("--config", default="osvip.json")
        sp.set_defaults(fn=fn)
        return sp

    pr = add("probe", cmd_probe, "live check of API, key and pool")
    pr.add_argument("--anon-test", type=int, metavar="FILE_ID")
    pr.add_argument("--login", action="store_true",
                    help="also login pool accounts")

    ps = add("search", cmd_search, "search subtitles")
    g = ps.add_mutually_exclusive_group(required=True)
    g.add_argument("--moviehash", metavar="FILE",
                   help="file to hash, or a literal 16-hex hash")
    g.add_argument("--query", help="title / release query")
    ps.add_argument("--lang", default="en")
    ps.add_argument("--limit", type=int, default=20)
    ps.add_argument("--season", type=int)
    ps.add_argument("--episode", type=int)
    ps.add_argument("--json", action="store_true")

    pg = add("get", cmd_get, "download a subtitle direct, no installer, no offers")
    g2 = pg.add_mutually_exclusive_group(required=True)
    g2.add_argument("--moviehash", metavar="FILE")
    g2.add_argument("--query", help="title / release query")
    g2.add_argument("--file-id", type=int, metavar="ID")
    pg.add_argument("--lang", default="en")
    pg.add_argument("--out", default=None, help="output directory")
    pg.add_argument("--keep-ads", action="store_true")
    pg.add_argument("--anon", action="store_true",
                    help="no login - 5/day per IP (rotates config proxies)")

    pp = add("pool", cmd_pool, "account pool management")
    pp.add_argument("action", choices=["list", "report", "add", "remove", "login"])
    pp.add_argument("creds", nargs="*", metavar="CRED")

    pa = add("ads", cmd_ads, "print uBlock Origin filter list")
    pa.add_argument("--out", default=None)

    pc = add("clean", cmd_clean, "strip ad cues from an SRT")
    pc.add_argument("file")
    pc.add_argument("--out", default=None)
    pc.add_argument("--in-place", action="store_true")

    pf = add("farm", cmd_farm, "create free accounts via temp-mail + browser")
    pf.add_argument("--count", type=int, default=5)
    pf.add_argument("--headless", action="store_true")
    pf.add_argument("--manual", action="store_true",
                    help="pause for you at the captcha")
    pf.add_argument("--2captcha", dest="captcha", default=None,
                    metavar="KEY", help="2captcha API key")
    pf.add_argument("--delay", type=float, default=5)

    return p


def main(argv: list[str] | None = None) -> None:
    args = build_parser().parse_args(argv)
    cfg = load_config(args.config)
    try:
        args.fn(args, cfg)
    except APIError as e:
        sys.exit(f"api error: {e}")
    except RuntimeError as e:
        sys.exit(str(e))
    except KeyboardInterrupt:
        sys.exit("interrupted")


if __name__ == "__main__":
    main()
