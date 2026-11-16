"""OpenSubtitles.com REST API client (api/v1)."""
from __future__ import annotations

import gzip
import io
import time
import zipfile
from dataclasses import dataclass

import requests

DEFAULT_BASE = "https://api.opensubtitles.com/api/v1"
USER_AGENT = "OSFreeTool v1.0.0"


class APIError(Exception):
    def __init__(self, status: int, message: str, reset_utc: str | None = None):
        super().__init__(f"HTTP {status}: {message}")
        self.status = status
        self.message = message
        self.reset_utc = reset_utc


class AuthError(APIError):
    """401/403 - credentials or Api-Key rejected."""


class QuotaExceeded(APIError):
    """406 - daily download allowance spent."""


class RateLimited(APIError):
    """429 - requests-per-second ceiling."""


@dataclass
class DownloadResult:
    link: str
    remaining: int | None = None
    requests: int | None = None
    reset_utc: str | None = None


def _body_json(r: requests.Response) -> dict:
    try:
        data = r.json()
        return data if isinstance(data, dict) else {}
    except ValueError:
        return {}


def _message(r: requests.Response) -> str:
    data = _body_json(r)
    return str(data.get("message") or data.get("error") or r.text[:200] or r.reason)


def _retry_after(r: requests.Response) -> float:
    raw = r.headers.get("RateLimit-Reset") or r.headers.get("Retry-After") or "1"
    try:
        return max(1.0, float(raw))
    except ValueError:
        return 1.0


def _raise_http(r: requests.Response) -> None:
    data = _body_json(r)
    msg = str(data.get("message") or data.get("error") or r.text[:200] or r.reason)
    reset = data.get("reset_time_utc")
    if r.status_code in (401, 403) or "cannot consume" in msg:
        raise AuthError(r.status_code, msg, reset)
    if r.status_code == 406 or ("allowed" in msg and "subtitle" in msg):
        raise QuotaExceeded(r.status_code, msg, reset)
    if r.status_code == 429:
        raise RateLimited(429, msg, reset)
    raise APIError(r.status_code, msg, reset)


class Client:
    def __init__(self, api_key: str, user_agent: str = USER_AGENT,
                 base: str = DEFAULT_BASE, proxy: str | None = None, timeout: int = 30):
        self.base = base.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update({
            "Api-Key": api_key,
            "User-Agent": user_agent,
            "Accept": "application/json",
        })
        if proxy:
            self.session.proxies.update({"http": proxy, "https": proxy})
        self._last_call = 0.0

    def _throttle(self, min_interval: float) -> None:
        wait = self._last_call + min_interval - time.monotonic()
        if wait > 0:
            time.sleep(wait)
        self._last_call = time.monotonic()

    def _request(self, method: str, path: str, *, params=None, body=None,
                 token: str | None = None, retries: int = 3,
                 min_interval: float = 0.21):
        url = path if path.startswith("http") else f"{self.base}/{path.lstrip('/')}"
        headers = {"Authorization": f"Bearer {token}"} if token else {}
        last: APIError | None = None
        for attempt in range(retries):
            self._throttle(min_interval)
            try:
                r = self.session.request(method, url, params=params, json=body,
                                         headers=headers, timeout=self.timeout,
                                         allow_redirects=(method == "GET"))
            except requests.RequestException as e:
                last = APIError(0, str(e))
                time.sleep(1 + attempt)
                continue
            if r.status_code == 429:
                last = RateLimited(429, _message(r))
                time.sleep(_retry_after(r))
                continue
            if r.status_code >= 500:
                last = APIError(r.status_code, _message(r))
                time.sleep(1 + attempt)
                continue
            if r.status_code >= 400:
                _raise_http(r)
            if r.status_code in (301, 302, 307, 308):
                raise APIError(r.status_code, f"redirect not followed: {r.headers.get('Location')}")
            if not r.content:
                return {}
            try:
                return r.json()
            except ValueError:
                return {"raw": r.text[:500]}
        raise last if last else APIError(0, "request failed")

    def login(self, username: str, password: str) -> dict:
        data = self._request("POST", "/login",
                             body={"username": username, "password": password},
                             min_interval=1.0)
        token = data.get("token") or ""
        if not token:
            raise AuthError(401, str(data.get("message") or "no token in login response"))
        user = data.get("user") or {}
        allowed = user.get("allowed_downloads")
        if allowed is None:
            allowed = data.get("allowed_downloads")
        return {
            "token": token,
            "allowed": int(allowed) if allowed is not None else 0,
            "vip": bool(user.get("vip") or data.get("vip")),
        }

    def infos_user(self, token: str) -> dict:
        data = self._request("GET", "/infos/user", token=token)
        return data.get("data") or data

    def search(self, *, moviehash: str | None = None, query: str | None = None,
               languages: str = "en", page: int = 1, page_size: int = 50,
               season: int | None = None, episode: int | None = None,
               order_by: str = "download_count",
               order_direction: str = "desc") -> list[dict]:
        params = {
            "languages": languages,
            "page": page,
            "page_size": max(1, min(int(page_size), 50)),
            "order_by": order_by,
            "order_direction": order_direction,
        }
        if moviehash:
            params["moviehash"] = moviehash
        if query:
            params["query"] = query
        if season is not None:
            params["season_number"] = season
        if episode is not None:
            params["episode_number"] = episode
        data = self._request("GET", "/subtitles", params=params)
        out: list[dict] = []
        for item in data.get("data") or []:
            attrs = item.get("attributes") or {}
            for f in attrs.get("files") or []:
                fid = f.get("file_id")
                if not fid:
                    continue
                out.append({
                    "file_id": fid,
                    "file_name": f.get("file_name") or "",
                    "language": attrs.get("language") or "",
                    "downloads": attrs.get("download_count") or 0,
                    "rating": attrs.get("ratings") or 0,
                    "moviehash_match": bool(attrs.get("moviehash_match")
                                            or f.get("moviehash_match")),
                    "release": attrs.get("release") or "",
                })
        return out

    def download(self, file_id: int, token: str | None = None) -> DownloadResult:
        data = self._request("POST", "/download", body={"file_id": int(file_id)}, token=token)
        link = data.get("link")
        if not link:
            msg = str(data.get("message") or data)
            if "allowed" in msg:
                raise QuotaExceeded(406, msg, data.get("reset_time_utc"))
            raise APIError(0, f"no link in response: {msg[:200]}")
        return DownloadResult(
            link=link,
            remaining=data.get("remaining"),
            requests=data.get("requests"),
            reset_utc=data.get("reset_time_utc"),
        )

    @staticmethod
    def fetch_file(link: str, timeout: int = 60) -> bytes:
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
                          "(KHTML, like Gecko) Chrome/126.0 Safari/537.36"
        }
        last_err: Exception | None = None
        for _ in range(3):
            try:
                r = requests.get(link, headers=headers, timeout=timeout)
                if r.status_code >= 400:
                    raise APIError(r.status_code, r.text[:120])
                return r.content
            except (requests.RequestException, APIError) as e:
                last_err = e
                time.sleep(1)
        if isinstance(last_err, APIError):
            raise last_err
        raise APIError(0, str(last_err))

    def probe(self) -> dict:
        out: dict = {}
        try:
            r = self.session.get(f"{self.base}/infos/formats", timeout=self.timeout)
            out["endpoint"] = {
                "status": r.status_code,
                "rate": r.headers.get("X-RateLimit-Limit-Second")
                or r.headers.get("RateLimit-Limit") or "?",
                "vip": r.headers.get("x-vip"),
                "vip_user": r.headers.get("x-vip-user"),
                "vip_consumer": r.headers.get("x-vip-consumer"),
            }
        except requests.RequestException as e:
            out["endpoint"] = {"status": 0, "error": str(e)}
        try:
            r = self.session.get(f"{self.base}/subtitles",
                                 params={"query": "test", "page_size": 1},
                                 timeout=self.timeout)
            out["search"] = {"status": r.status_code,
                             "message": _body_json(r).get("message", "ok")}
        except requests.RequestException as e:
            out["search"] = {"status": 0, "error": str(e)}
        return out


def decode_subtitle(blob: bytes) -> str:
    try:
        if blob[:2] == b"\x1f\x8b":
            blob = gzip.decompress(blob)
        elif blob[:2] == b"PK\x03\x04":
            with zipfile.ZipFile(io.BytesIO(blob)) as zf:
                names = [n for n in zf.namelist()
                         if n.lower().endswith((".srt", ".vtt", ".txt", ".sub",
                                                ".ass", ".ssa", ".dfxp", ".ttml"))]
                if not names:
                    raise APIError(0, f"archive holds no subtitle: {zf.namelist()[:5]}")
                blob = zf.read(names[0])
    except (OSError, zipfile.BadZipFile) as e:
        raise APIError(0, f"corrupt payload: {e}") from e
    for enc in ("utf-8-sig", "utf-8", "cp1252"):
        try:
            return blob.decode(enc)
        except UnicodeDecodeError:
            continue
    return blob.decode("latin-1")
