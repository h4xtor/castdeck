"""Free-account pool: N accounts -> VIP-sized daily throughput."""
from __future__ import annotations

import json
import os
import time
from dataclasses import asdict, dataclass
from datetime import datetime, timezone

from .api import APIError, AuthError, Client

TOKEN_TTL = 24 * 3600  # /login tokens last 24h (OpenSubtitles forum, 2026-10)
TOKEN_SLACK = 300


@dataclass
class Account:
    username: str
    password: str
    token: str = ""
    token_exp: float = 0.0
    allowed: int = 0
    used: int = 0
    reset_utc: str = ""
    exhausted_until: float = 0.0
    last_error: str = ""


def _parse_reset(reset_utc: str) -> float:
    if not reset_utc:
        return 0.0
    try:
        return datetime.fromisoformat(reset_utc.replace("Z", "+00:00")).timestamp()
    except ValueError:
        return 0.0


def load_accounts(path: str) -> list[Account]:
    if not os.path.isfile(path):
        return []
    with open(path, encoding="utf-8") as f:
        raw = json.load(f)
    fields = Account.__dataclass_fields__
    return [Account(**{k: v for k, v in item.items() if k in fields}) for item in raw]


def save_accounts(path: str, accounts: list[Account]) -> None:
    with open(path, "w", encoding="utf-8") as f:
        json.dump([asdict(a) for a in accounts], f, indent=2)


class Pool:
    def __init__(self, path: str):
        self.path = path
        self.accounts = load_accounts(path)
        self._cursor = 0

    def save(self) -> None:
        save_accounts(self.path, self.accounts)

    def add(self, username: str, password: str) -> bool:
        if any(a.username == username for a in self.accounts):
            return False
        self.accounts.append(Account(username=username, password=password))
        self.save()
        return True

    def remove(self, username: str) -> bool:
        before = len(self.accounts)
        self.accounts = [a for a in self.accounts if a.username != username]
        if len(self.accounts) == before:
            return False
        self.save()
        return True

    def _fresh_token(self, a: Account) -> bool:
        return bool(a.token) and time.time() < a.token_exp - TOKEN_SLACK

    def login(self, client: Client, a: Account) -> bool:
        try:
            info = client.login(a.username, a.password)
        except (AuthError, APIError) as e:
            a.last_error = f"login {e.status}: {e.message[:80]}"
            self.save()
            return False
        a.token = info["token"]
        a.token_exp = time.time() + TOKEN_TTL
        if info.get("allowed"):
            a.allowed = info["allowed"]
        a.last_error = ""
        self.save()
        return True

    def login_all(self, client: Client) -> tuple[int, int]:
        ok = fail = 0
        for a in self.accounts:
            if self._fresh_token(a) and not a.last_error:
                ok += 1
                continue
            if self.login(client, a):
                ok += 1
            else:
                fail += 1
        return ok, fail

    def acquire(self) -> Account | None:
        n = len(self.accounts)
        if n == 0:
            return None
        now = time.time()
        for _ in range(n):
            a = self.accounts[self._cursor % n]
            self._cursor += 1
            if a.last_error or not self._fresh_token(a):
                continue
            if a.allowed and a.used >= a.allowed:
                continue
            if a.exhausted_until and now < a.exhausted_until:
                continue
            return a
        return None

    def mark_download(self, a: Account, result) -> None:
        if result.reset_utc:
            a.reset_utc = result.reset_utc
        if result.remaining is not None and a.allowed:
            a.used = max(0, a.allowed - result.remaining)
        else:
            a.used += 1
        self.save()

    def mark_quota(self, a: Account, reset_utc: str | None) -> None:
        if reset_utc:
            a.reset_utc = reset_utc
            a.exhausted_until = _parse_reset(reset_utc) + 5
        else:
            a.exhausted_until = time.time() + 3600
        if a.allowed:
            a.used = a.allowed
        self.save()

    def relogin(self, client: Client, a: Account) -> bool:
        return self.login(client, a)

    def wait_seconds(self) -> float | None:
        now = time.time()
        waits = [a.exhausted_until - now for a in self.accounts if a.exhausted_until > now]
        return max(0.0, min(waits)) if waits else None

    def report(self) -> str:
        now = time.time()
        ready = stale = blocked = errored = 0
        rows = []
        for a in self.accounts:
            if a.last_error:
                state = "ERROR " + a.last_error[:44]
                errored += 1
            elif not self._fresh_token(a):
                state = "stale token - run pool login"
                stale += 1
            elif a.exhausted_until > now:
                stamp = datetime.fromtimestamp(a.exhausted_until,
                                               timezone.utc).strftime("%H:%M:%SZ")
                state = f"quota until {stamp}"
                blocked += 1
            elif a.allowed and a.used >= a.allowed:
                state = "spent, awaiting reset"
                blocked += 1
            else:
                state = "ready"
                ready += 1
            left = max(0, a.allowed - a.used) if a.allowed else "?"
            rows.append((a.username, a.allowed or "?", a.used, left, state))
        head = (f"accounts {len(self.accounts)} | ready {ready} | blocked {blocked}"
                f" | stale {stale} | error {errored}")
        if not rows:
            return head + "\npool empty - run: python -m osvip farm --count 10"
        body = "\n".join(f"{u:<26} {al:>5} {us:>5} {le:>5}  {st}"
                         for u, al, us, le, st in rows)
        return head + "\n" + body
