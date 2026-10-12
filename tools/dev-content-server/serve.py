#!/usr/bin/env python3
"""hiVelzon yerel içerik sunucusu (H-031, yalnızca geliştirme).

Her bölüm paketini (`icerik/<id>/_build/package/`) şu adreste sunar:

    http://127.0.0.1:8787/packages/index.json          -> paket listesi
    http://127.0.0.1:8787/packages/<contentId>/<yol>   -> scenes.json, segments/*.mp4 ...
    http://127.0.0.1:8787/packages/_season/S1/<yol>    -> sezon paketi: season.json, jenerik-*.mp4 (H-050)

- Yalnızca 127.0.0.1'e bağlanır (dışarıya açık değildir).
- HTTP Range isteklerini destekler (AVPlayer mp4 için bayt aralığı ister).
- Yalnızca standart kütüphane kullanılır; ücretli ya da dış servis çağrısı yoktur.

Kullanım:
    python3 tools/dev-content-server/serve.py [--port 8787] [--root icerik] [--quiet]

Bu sunucu ileride VideoHostingPort / CDN (K-13) adaptörünün yerini tutar.
"""

from __future__ import annotations

import argparse
import json
import mimetypes
import os
import re
import sys
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import unquote, urlsplit

REPO_ROOT = Path(__file__).resolve().parents[2]
CHUNK = 256 * 1024
CONTENT_TYPES = {
    ".mp4": "video/mp4",
    ".m4a": "audio/mp4",
    ".json": "application/json; charset=utf-8",
    ".jpg": "image/jpeg",
    ".jpeg": "image/jpeg",
    ".png": "image/png",
}
RANGE_RE = re.compile(r"^bytes=(\d*)-(\d*)$")
SEASON_PREFIX = "_season"
SEASON_DIR = Path("_evren") / "_build" / "season"   # export_package.py üretir
SEASON_RE = re.compile(r"^S\d+$")


def discover_seasons(root: Path) -> list[dict]:
    """Sezon paketleri: `_evren/_build/season/S<n>/season.json`."""
    out = []
    for sj in sorted((root / SEASON_DIR).glob("S*/season.json")):
        try:
            d = json.loads(sj.read_text(encoding="utf-8"))
            out.append({"season": d["season"], "title": d.get("title"), "path": f"{SEASON_PREFIX}/{sj.parent.name}"})
        except (OSError, ValueError, KeyError) as exc:
            print(f"uyarı: {sj} okunamadı: {exc}", file=sys.stderr)
    return out


def discover_packages(root: Path) -> dict[str, dict]:
    """contentId -> {dir, title, ...}. scenes.json'ı olan her `_build/package`."""
    packages: dict[str, dict] = {}
    for scenes in sorted(root.glob("*/_build/package/scenes.json")):
        try:
            data = json.loads(scenes.read_text(encoding="utf-8"))
            ep = data["episode"]
        except (OSError, ValueError, KeyError) as exc:
            print(f"uyarı: {scenes} okunamadı: {exc}", file=sys.stderr)
            continue
        packages[ep["id"]] = {
            "dir": scenes.parent,
            "id": ep["id"],
            "title": ep.get("title", ep["id"]),
            "level": ep.get("level"),
            "season": ep.get("season"),
            "number": ep.get("number"),
            "contentVersion": ep.get("contentVersion"),
            "estimatedMinutes": ep.get("estimatedMinutes"),
        }
    return packages


class Handler(BaseHTTPRequestHandler):
    server_version = "hiVelzonDevContent/0.1"
    root: Path = REPO_ROOT / "icerik"
    quiet = False

    def log_message(self, fmt: str, *args) -> None:  # noqa: D401
        if not self.quiet:
            super().log_message(fmt, *args)

    # GET ve HEAD aynı yolu izler.
    def do_HEAD(self) -> None:  # noqa: N802
        self._handle(send_body=False)

    def do_GET(self) -> None:  # noqa: N802
        self._handle(send_body=True)

    def _handle(self, send_body: bool) -> None:
        path = unquote(urlsplit(self.path).path)
        parts = [p for p in path.split("/") if p]
        if parts == ["packages", "index.json"]:
            return self._send_index(send_body)
        if len(parts) >= 4 and parts[0] == "packages" and parts[1] == SEASON_PREFIX:
            return self._send_season_file(parts[2], parts[3:], send_body)
        if len(parts) >= 3 and parts[0] == "packages":
            return self._send_package_file(parts[1], parts[2:], send_body)
        # http.server durum satırını latin-1 yazar: iletiler ASCII olmalı.
        self.send_error(HTTPStatus.NOT_FOUND, "Not found")

    def _send_index(self, send_body: bool) -> None:
        # Her istekte yeniden taranır: paket yeniden üretilince sunucu yeniden başlatılmaz.
        packages = discover_packages(self.root)
        body = json.dumps(
            {
                "schemaVersion": 1,
                "packages": [
                    {k: v for k, v in p.items() if k != "dir"}
                    for p in sorted(packages.values(), key=lambda p: p["id"])
                ],
                "seasons": discover_seasons(self.root),
            },
            ensure_ascii=False,
        ).encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if send_body:
            self.wfile.write(body)

    def _send_season_file(self, season: str, rel: list[str], send_body: bool) -> None:
        base = (self.root / SEASON_DIR / season).resolve()
        if not SEASON_RE.match(season) or not base.is_dir():
            return self.send_error(HTTPStatus.NOT_FOUND, "Unknown season")
        return self._send_file(base, rel, send_body)

    def _send_package_file(self, content_id: str, rel: list[str], send_body: bool) -> None:
        package = discover_packages(self.root).get(content_id)
        if package is None:
            return self.send_error(HTTPStatus.NOT_FOUND, "Unknown package")
        return self._send_file(package["dir"].resolve(), rel, send_body)

    def _send_file(self, base: Path, rel: list[str], send_body: bool) -> None:
        if any(p in ("..", ".") or p.startswith(".") for p in rel):
            return self.send_error(HTTPStatus.BAD_REQUEST, "Invalid path")
        target = (base / Path(*rel)).resolve()
        if base not in target.parents or not target.is_file():
            return self.send_error(HTTPStatus.NOT_FOUND, "File not found")

        size = target.stat().st_size
        ctype = CONTENT_TYPES.get(target.suffix.lower()) or (
            mimetypes.guess_type(target.name)[0] or "application/octet-stream"
        )
        start, end = 0, size - 1
        status = HTTPStatus.OK
        range_header = self.headers.get("Range")
        if range_header:
            m = RANGE_RE.match(range_header.strip())
            if not m or (m.group(1) == "" and m.group(2) == ""):
                return self._range_not_satisfiable(size)
            if m.group(1) == "":  # son N bayt
                length = int(m.group(2))
                start = max(0, size - length)
            else:
                start = int(m.group(1))
                if m.group(2) != "":
                    end = min(int(m.group(2)), size - 1)
            if start >= size or start > end:
                return self._range_not_satisfiable(size)
            status = HTTPStatus.PARTIAL_CONTENT

        length = end - start + 1
        self.send_response(status)
        self.send_header("Content-Type", ctype)
        self.send_header("Accept-Ranges", "bytes")
        self.send_header("Content-Length", str(length))
        if status == HTTPStatus.PARTIAL_CONTENT:
            self.send_header("Content-Range", f"bytes {start}-{end}/{size}")
        # JSON değişebilir; medya için kısa önbellek yeterli.
        self.send_header(
            "Cache-Control", "no-store" if target.suffix == ".json" else "max-age=60"
        )
        self.end_headers()
        if not send_body:
            return
        try:
            with target.open("rb") as fh:
                fh.seek(start)
                remaining = length
                while remaining > 0:
                    chunk = fh.read(min(CHUNK, remaining))
                    if not chunk:
                        break
                    self.wfile.write(chunk)
                    remaining -= len(chunk)
        except (BrokenPipeError, ConnectionResetError):
            # Oynatıcı aralığı iptal edebilir (AVPlayer sık yapar); hata değildir.
            pass

    def _range_not_satisfiable(self, size: int) -> None:
        self.send_response(HTTPStatus.REQUESTED_RANGE_NOT_SATISFIABLE)
        self.send_header("Content-Range", f"bytes */{size}")
        self.send_header("Content-Length", "0")
        self.end_headers()


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--port", type=int, default=int(os.environ.get("PORT", 8787)))
    parser.add_argument("--root", type=Path, default=REPO_ROOT / "icerik", help="icerik klasörü")
    parser.add_argument("--quiet", action="store_true", help="istek günlüğünü kapat")
    args = parser.parse_args(argv)

    Handler.root = args.root.resolve()
    Handler.quiet = args.quiet
    packages = discover_packages(Handler.root)
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    server.daemon_threads = True
    print(f"hiVelzon içerik sunucusu: http://127.0.0.1:{args.port}/packages/index.json")
    for p in sorted(packages):
        print(f"  {p}  {packages[p]['title']}  ({packages[p]['dir']})")
    for s in discover_seasons(Handler.root):
        print(f"  {s['path']}  Sezon {s['season']}: {s['title']}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
