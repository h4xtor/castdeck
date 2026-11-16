"""Account factory: temp-mail inbox + real-browser signup -> accounts.json."""
from __future__ import annotations

import re
import time
import uuid

import requests

from .pool import load_accounts, save_accounts

MAIL_BASE = "https://api.mail.tm"
SIGNUP_URL = "https://www.opensubtitles.com/en/users/sign_up"
BROWSER_UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
              "(KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36")


class TempMail:
    def __init__(self) -> None:
        self.s = requests.Session()

    def create(self, tries: int = 3) -> tuple[str, str, str]:
        for _ in range(tries):
            domains = self.s.get(f"{MAIL_BASE}/domains", timeout=30).json()
            members = domains.get("hydra:member") or domains.get("member") or []
            if not members:
                raise RuntimeError("mail.tm: no domains available")
            domain = members[0]["domain"]
            address = f"{uuid.uuid4().hex[:12]}@{domain}"
            password = uuid.uuid4().hex + "aA1!"
            r = self.s.post(f"{MAIL_BASE}/accounts",
                            json={"address": address, "password": password}, timeout=30)
            if r.status_code in (200, 201):
                t = self.s.post(f"{MAIL_BASE}/token",
                                json={"address": address, "password": password},
                                timeout=30)
                if t.status_code == 200:
                    return address, password, t.json()["token"]
        raise RuntimeError("mail.tm: could not create mailbox")

    def wait_confirm(self, token: str, timeout: int = 240, interval: int = 5) -> str:
        hdr = {"Authorization": f"Bearer {token}"}
        deadline = time.time() + timeout
        while time.time() < deadline:
            msgs = self.s.get(f"{MAIL_BASE}/messages", headers=hdr, timeout=30).json()
            for m in (msgs.get("hydra:member") or []):
                sender = ((m.get("from") or {}).get("address") or "").lower()
                if "opensubtitle" not in sender:
                    continue
                detail = self.s.get(f"{MAIL_BASE}/messages/{m['id']}",
                                    headers=hdr, timeout=30).json()
                blob = detail.get("html") or detail.get("text") or ""
                if isinstance(blob, list):
                    blob = "\n".join(blob)
                links = [u.rstrip(".,)") for u in
                         re.findall(r'https?://[^\s"\'<>]+', str(blob))]
                for link in links:
                    if re.search(r"confirm|verif|activat|validat|sign_?up", link, re.I):
                        return link
                if links:
                    return links[0]
            time.sleep(interval)
        raise RuntimeError(f"mail.tm: no confirmation mail within {timeout}s")


def solve_captcha(kind: str, sitekey: str, pageurl: str, key: str,
                  timeout: int = 180) -> str:
    method = "hcaptcha" if kind == "hcaptcha" else "turnstile"
    r = requests.post("https://2captcha.com/in.php", timeout=30, data={
        "key": key, "method": method, "googlekey": sitekey,
        "pageurl": pageurl, "json": 1,
    }).json()
    if r.get("status") != 1:
        raise RuntimeError(f"2captcha: {r.get('request')}")
    req_id = r["request"]
    deadline = time.time() + timeout
    while time.time() < deadline:
        time.sleep(5)
        g = requests.get("https://2captcha.com/res.php", timeout=30, params={
            "key": key, "action": "get", "id": req_id, "json": 1,
        }).json()
        if g.get("status") == 1:
            return str(g["request"])
        if g.get("request") != "CAPCHA_NOT_READY":
            raise RuntimeError(f"2captcha: {g.get('request')}")
    raise RuntimeError("2captcha: timeout")


def _username() -> str:
    return "osvip" + uuid.uuid4().hex[:9]


def _accept_cookies(page) -> None:
    for text in ("accept", "allow all", "agree", "godkend"):
        btn = page.locator(f'button:visible:text-is("{text}")').first
        try:
            if btn.count():
                btn.click(timeout=3000)
                return
        except Exception:
            continue


def _fill_first(page, selectors: list[str], value: str) -> bool:
    for sel in selectors:
        try:
            loc = page.locator(sel).first
            if loc.count() and loc.is_visible():
                loc.fill(value, timeout=5000)
                return True
        except Exception:
            continue
    return False


def _fill_username(page, username: str) -> bool:
    if _fill_first(page, [
        'input[autocomplete="username"]',
        'input[name*="username" i]',
        'input[id*="username" i]',
        'input[name*="user[name]" i]',
    ], username):
        return True
    cands = page.locator('input[type="text"]:visible, input:not([type]):visible')
    for i in range(min(cands.count(), 6)):
        el = cands.nth(i)
        try:
            hint = ((el.get_attribute("name") or "")
                    + (el.get_attribute("id") or "")
                    + (el.get_attribute("placeholder") or ""))
            if re.search(r"mail|pass|search|captcha|query", hint, re.I):
                continue
            el.fill(username, timeout=5000)
            return True
        except Exception:
            continue
    return False


def _captcha_present(page):
    checks = [
        ('.h-captcha[data-sitekey]', "hcaptcha"),
        ('iframe[src*="hcaptcha"]', "hcaptcha"),
        ('.cf-turnstile[data-sitekey]', "turnstile"),
        ('iframe[src*="challenges.cloudflare.com"]', "turnstile"),
    ]
    for sel, kind in checks:
        try:
            if page.locator(sel).first.count():
                el = page.locator('[data-sitekey]').first
                sitekey = el.get_attribute("data-sitekey") if el.count() else ""
                return kind, sitekey or ""
        except Exception:
            continue
    return None, ""


def _inject_captcha(page, token: str) -> None:
    page.evaluate("""(tok) => {
      for (const sel of ['textarea[name="h-captcha-response"]',
                         'textarea[name="g-recaptcha-response"]',
                         'textarea[name="cf-turnstile-response"]',
                         'input[name="g-recaptcha-response"]']) {
        document.querySelectorAll(sel).forEach(el => {
          el.value = tok;
          el.dispatchEvent(new Event('input', {bubbles: true}));
          el.dispatchEvent(new Event('change', {bubbles: true}));
        });
      }
      try { if (window.hcaptcha && window.hcaptcha.setResponse)
              window.hcaptcha.setResponse({response: tok, widgetId: 0}); } catch (e) {}
    }""", token)


def _signup_once(page, url: str, email: str, password: str, username: str,
                 captcha_key: str | None, manual: bool) -> None:
    page.goto(url, wait_until="domcontentloaded", timeout=45000)
    page.wait_for_timeout(1500)
    _accept_cookies(page)
    if not _fill_first(page, ['input[type="email"]',
                              'input[name*="email" i]',
                              'input[autocomplete="email"]'], email):
        raise RuntimeError("email field not found")
    if not _fill_username(page, username):
        raise RuntimeError("username field not found")
    pwds = page.locator('input[type="password"]')
    if pwds.count() == 0:
        raise RuntimeError("password field not found")
    for i in range(pwds.count()):
        try:
            pwds.nth(i).fill(password, timeout=5000)
        except Exception:
            pass
    kind, sitekey = _captcha_present(page)
    if kind:
        if manual:
            input("captcha is open in the browser - solve it, then press Enter: ")
        elif captcha_key:
            _inject_captcha(page, solve_captcha(kind, sitekey, page.url, captcha_key))
        else:
            raise RuntimeError("captcha present - set captcha_key or run --manual")
    page.locator('button[type="submit"]:visible, input[type="submit"]:visible') \
        .first.click(timeout=10000)
    page.wait_for_timeout(3500)
    err = page.locator('[class*="error" i]:visible, .alert:visible, '
                       '.invalid-feedback:visible').first
    try:
        if err.count():
            txt = err.inner_text().strip()[:120]
            if txt:
                raise RuntimeError(f"form error: {txt}")
    except RuntimeError:
        raise
    except Exception:
        pass
    if "sign_up" in page.url:
        body = ""
        try:
            body = page.inner_text("body")[:4000]
        except Exception:
            pass
        if not re.search(r"check your email|confirmation|verify your|activat",
                         body, re.I):
            raise RuntimeError("signup did not progress (stayed on sign-up page)")


def run_farm(count: int, cfg: dict, headed: bool = True,
             captcha_key: str | None = None, manual: bool = False,
             delay: float = 5, signup_url: str | None = None) -> int:
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        raise SystemExit("playwright missing: pip install playwright && "
                         "playwright install chromium")
    signup_url = signup_url or cfg.get("signup_url") or SIGNUP_URL
    accounts_path = cfg.get("accounts_file", "accounts.json")
    accounts = load_accounts(accounts_path)
    made = 0
    errors = 0
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=not headed)
        ctx = browser.new_context(user_agent=cfg.get("browser_ua", BROWSER_UA),
                                  locale="en-US")
        page = ctx.new_page()
        while made < count and errors < 3:
            mail = TempMail()
            address, pw, mtok = mail.create()
            username = _username()
            print(f"[{made + 1}/{count}] signup {address} -> {username}", flush=True)
            try:
                _signup_once(page, signup_url, address, pw, username,
                             captcha_key, manual)
                link = mail.wait_confirm(mtok)
                page.goto(link, wait_until="domcontentloaded", timeout=45000)
                page.wait_for_timeout(3000)
                accounts = load_accounts(accounts_path)
                accounts.append({
                    "username": username,
                    "email": address,
                    "password": pw,
                    "created": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
                })
                save_accounts(accounts_path, accounts)
                made += 1
                errors = 0
                print(f"  ok -> {username}", flush=True)
            except Exception as e:
                errors += 1
                print(f"  fail: {e}", flush=True)
            if made < count:
                time.sleep(delay)
        browser.close()
    return made
