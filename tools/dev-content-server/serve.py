#!/usr/bin/env python3
"""hiVelzon yerel içerik sunucusu (H-031, yalnızca geliştirme).

Her bölüm paketini (`icerik/<id>/_build/package/`) şu adreste sunar:

    http://127.0.0.1:8787/packages/index.json          -> paket listesi
    http://127.0.0.1:8787/packages/<contentId>/<yol>   -> scenes.json, segments/*.mp4 ...
    http://127.0.0.1:8787/packages/_season/S1/<yol>    -> sezon paketi: season.json, jenerik-*.mp4 (H-050)

Kitaplık paketleri (`kitaplar/<id>/_build/package/`, H-066):

    http://127.0.0.1:8787/books/index.json             -> kitap listesi
    http://127.0.0.1:8787/books/<kitapId>/<yol>        -> book.json, pages.json, audio/*.m4a, images/*.webp
    http://127.0.0.1:8787/packages/_books/<kitapId>/<yol> -> aynısı; backend kataloğunun paket yeri (H-070)

Dilbilgisi dersleri (`dilbilgisi/<G-ID>/_build/package/`, H-077):

    http://127.0.0.1:8787/grammar/index.json           -> ders listesi
    http://127.0.0.1:8787/grammar/<G-ID>/<yol>         -> lesson.json, cards.json, audio/*.m4a

Bağımsız konu reelleri (`reeller/<id>/_build/package/`, H-094):

    http://127.0.0.1:8787/reels/index.json             -> reel listesi
    http://127.0.0.1:8787/reels/<id>/<yol>             -> reel.json, <id>.mp4, stills/*.webp, audio/*.m4a

Bölüm ve kitap listelerinde `grammarTopics` (varsa) yer alır: "Bu bölümdeki dilbilgisi".

- Yalnızca 127.0.0.1'e bağlanır (dışarıya açık değildir).
- HTTP Range isteklerini destekler (AVPlayer mp4 için bayt aralığı ister).
- Yalnızca standart kütüphane kullanılır; ücretli ya da dış servis çağrısı yoktur.

Kullanım:
    python3 tools/dev-content-server/serve.py [--port 8787] [--root icerik] [--books-root kitaplar]
        [--grammar-root dilbilgisi] [--reels-root reeller] [--quiet]

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
    ".webp": "image/webp",
}
RANGE_RE = re.compile(r"^bytes=(\d*)-(\d*)$")
SEASON_PREFIX = "_season"
BOOKS_PREFIX = "_books"
REELS_PREFIX = "_reels"
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
        if ep.get("grammarTopics"):
            packages[ep["id"]]["grammarTopics"] = ep["grammarTopics"]
    return packages


def discover_books(root: Path) -> dict[str, dict]:
    """kitapId -> {dir, title, level, ...}. book.json'u olan her `<kitap>/_build/package` (H-066).
    `_` ile başlayan klasörler (ör. `_maliyet`) atlanır."""
    books: dict[str, dict] = {}
    if not root.is_dir():
        return books
    for bj in sorted(root.glob("*/_build/package/book.json")):
        if bj.parents[2].name.startswith("_"):
            continue
        try:
            d = json.loads(bj.read_text(encoding="utf-8"))
            books[d["id"]] = {
                "dir": bj.parent,
                "id": d["id"],
                "title": d.get("title", d["id"]),
                "titleTr": d.get("titleTr"),
                "level": d.get("level"),
                "genre": d.get("genre"),
                "contentVersion": d.get("contentVersion"),
                "status": d.get("status"),
                "cover": d.get("cover"),
                "estimatedMinutes": d.get("estimatedMinutes"),
                "pageCount": d.get("pageCount"),
                "chapters": len(d.get("chapters", [])),
                # Ses bölüm bölüm hazırlanabilir: "Bana bir kitap oku" ilk
                # bölümünün sesi olan kitabı önce seçer.
                "firstChapterAudio": bool((d.get("chapters") or [{}])[0].get("audio")),
            }
            if d.get("grammarTopics"):
                books[d["id"]]["grammarTopics"] = d["grammarTopics"]
        except (OSError, ValueError, KeyError) as exc:
            print(f"uyarı: {bj} okunamadı: {exc}", file=sys.stderr)
    return books


def discover_grammar(root: Path) -> dict[str, dict]:
    """G-ID -> {dir, titleTr, level, ...}. lesson.json'u olan her `<ders>/_build/package` (H-077)."""
    lessons: dict[str, dict] = {}
    if not root.is_dir():
        return lessons
    for lj in sorted(root.glob("*/_build/package/lesson.json")):
        if lj.parents[2].name.startswith("_"):
            continue
        try:
            d = json.loads(lj.read_text(encoding="utf-8"))
            lessons[d["id"]] = {
                "dir": lj.parent,
                "id": d["id"],
                "level": d.get("level"),
                "titleTr": d.get("titleTr"),
                "titleEn": d.get("titleEn"),
                "goalTr": d.get("goalTr"),
                "prerequisites": d.get("prerequisites", []),
                "contentVersion": d.get("contentVersion"),
                "status": d.get("status"),
                "linksTo": d.get("linksTo"),
                "cardCount": d.get("cardCount"),
                "estimatedMinutes": d.get("estimatedMinutes"),
            }
        except (OSError, ValueError, KeyError) as exc:
            print(f"uyarı: {lj} okunamadı: {exc}", file=sys.stderr)
    return lessons


REEL_CATEGORY_TR = {"CIN": "Sinema", "SPO": "Spor", "BOK": "Kitap"}


def discover_reels(root: Path) -> dict[str, dict]:
    """reelId -> {dir, titleTr, level, ...}. `reel.json` kaynak klasörde ya da
    `<reel>/_build/package` altında (H-094); `_build/package` varsa o tercih edilir.
    `_` ile başlayan klasörler atlanır."""
    reels: dict[str, dict] = {}
    if not root.is_dir():
        return reels
    for d in sorted(p for p in root.iterdir() if p.is_dir() and not p.name.startswith("_")):
        rj = next(
            (c for c in (d / "_build" / "package" / "reel.json", d / "reel.json") if c.is_file()),
            None,
        )
        if rj is None:
            continue
        try:
            doc = json.loads(rj.read_text(encoding="utf-8"))
            category = doc.get("category")
            reels[doc["id"]] = {
                "dir": rj.parent,
                "id": doc["id"],
                "category": category,
                "categoryTr": doc.get("categoryTr") or REEL_CATEGORY_TR.get(category),
                "level": doc.get("level"),
                "titleTr": doc.get("titleTr", doc["id"]),
                "duration": doc.get("duration"),
                "sourceType": doc.get("sourceType", "standalone"),
                "family": doc.get("family"),
                "poster": doc.get("poster"),
                "contentVersion": doc.get("contentVersion"),
                "status": doc.get("status"),
            }
        except (OSError, ValueError, KeyError) as exc:
            print(f"uyarı: {rj} okunamadı: {exc}", file=sys.stderr)
    return reels


class Handler(BaseHTTPRequestHandler):
    server_version = "hiVelzonDevContent/0.1"
    root: Path = REPO_ROOT / "icerik"
    books_root: Path = REPO_ROOT / "kitaplar"
    grammar_root: Path = REPO_ROOT / "dilbilgisi"
    reels_root: Path = REPO_ROOT / "reeller"
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
        if len(parts) >= 4 and parts[0] == "packages" and parts[1] == BOOKS_PREFIX:
            parts = ["books", *parts[2:]]  # backend VideoHostingPort yolu: _books/<kitapId> (H-070)
        if len(parts) >= 4 and parts[0] == "packages" and parts[1] == REELS_PREFIX:
            parts = ["reels", *parts[2:]]  # backend VideoHostingPort yolu: _reels/<reelId> (H-094)
        if len(parts) >= 4 and parts[0] == "packages" and parts[1] == SEASON_PREFIX:
            return self._send_season_file(parts[2], parts[3:], send_body)
        if len(parts) >= 3 and parts[0] == "packages":
            return self._send_package_file(parts[1], parts[2:], send_body)
        if parts == ["books", "index.json"]:
            return self._send_books_index(send_body)
        if len(parts) >= 3 and parts[0] == "books":
            book = discover_books(self.books_root).get(parts[1])
            if book is None:
                return self.send_error(HTTPStatus.NOT_FOUND, "Unknown book")
            return self._send_file(book["dir"].resolve(), parts[2:], send_body)
        if parts == ["grammar", "index.json"]:
            return self._send_grammar_index(send_body)
        if len(parts) >= 3 and parts[0] == "grammar":
            lesson = discover_grammar(self.grammar_root).get(parts[1])
            if lesson is None:
                return self.send_error(HTTPStatus.NOT_FOUND, "Unknown lesson")
            return self._send_file(lesson["dir"].resolve(), parts[2:], send_body)
        if parts == ["reels", "index.json"]:
            return self._send_reels_index(send_body)
        if len(parts) >= 3 and parts[0] == "reels":
            reel = discover_reels(self.reels_root).get(parts[1])
            if reel is None:
                return self.send_error(HTTPStatus.NOT_FOUND, "Unknown reel")
            return self._send_file(reel["dir"].resolve(), parts[2:], send_body)
        # http.server durum satırını latin-1 yazar: iletiler ASCII olmalı.
        self.send_error(HTTPStatus.NOT_FOUND, "Not found")

    def _send_grammar_index(self, send_body: bool) -> None:
        # Her istekte yeniden taranır (bölüm ve kitap paketleri gibi).
        lessons = discover_grammar(self.grammar_root)
        body = json.dumps(
            {"schemaVersion": 1,
             "lessons": [{k: v for k, v in g.items() if k != "dir"} for g in sorted(lessons.values(), key=lambda g: g["id"])]},
            ensure_ascii=False,
        ).encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if send_body:
            self.wfile.write(body)

    def _send_books_index(self, send_body: bool) -> None:
        # Her istekte yeniden taranır (bölüm paketleri gibi).
        books = discover_books(self.books_root)
        body = json.dumps(
            {"schemaVersion": 1,
             "books": [{k: v for k, v in b.items() if k != "dir"} for b in sorted(books.values(), key=lambda b: b["id"])]},
            ensure_ascii=False,
        ).encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if send_body:
            self.wfile.write(body)

    def _send_reels_index(self, send_body: bool) -> None:
        # Her istekte yeniden taranır (bölüm, kitap ve ders paketleri gibi).
        reels = discover_reels(self.reels_root)
        body = json.dumps(
            {"schemaVersion": 1,
             "reels": [{k: v for k, v in r.items() if k != "dir"} for r in sorted(reels.values(), key=lambda r: r["id"])]},
            ensure_ascii=False,
        ).encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if send_body:
            self.wfile.write(body)

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
    parser.add_argument("--books-root", type=Path, default=REPO_ROOT / "kitaplar", help="kitaplar klasörü (H-066)")
    parser.add_argument("--grammar-root", type=Path, default=REPO_ROOT / "dilbilgisi", help="dilbilgisi klasörü (H-077)")
    parser.add_argument("--reels-root", type=Path, default=REPO_ROOT / "reeller", help="reeller klasörü (H-094)")
    parser.add_argument("--quiet", action="store_true", help="istek günlüğünü kapat")
    args = parser.parse_args(argv)

    Handler.root = args.root.resolve()
    Handler.books_root = args.books_root.resolve()
    Handler.grammar_root = args.grammar_root.resolve()
    Handler.reels_root = args.reels_root.resolve()
    Handler.quiet = args.quiet
    packages = discover_packages(Handler.root)
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    server.daemon_threads = True
    print(f"hiVelzon içerik sunucusu: http://127.0.0.1:{args.port}/packages/index.json")
    for p in sorted(packages):
        print(f"  {p}  {packages[p]['title']}  ({packages[p]['dir']})")
    for s in discover_seasons(Handler.root):
        print(f"  {s['path']}  Sezon {s['season']}: {s['title']}")
    books = discover_books(Handler.books_root)
    if books:
        print(f"Kitaplık: http://127.0.0.1:{args.port}/books/index.json")
    for b in sorted(books):
        print(f"  {b}  {books[b]['title']}  ({books[b]['dir']})")
    lessons = discover_grammar(Handler.grammar_root)
    if lessons:
        print(f"Dilbilgisi: http://127.0.0.1:{args.port}/grammar/index.json")
    for g in sorted(lessons):
        print(f"  {g}  {lessons[g]['titleTr']}  ({lessons[g]['dir']})")
    reels = discover_reels(Handler.reels_root)
    if reels:
        print(f"Reeller: http://127.0.0.1:{args.port}/reels/index.json")
    for r in sorted(reels):
        print(f"  {r}  {reels[r]['titleTr']}  ({reels[r]['dir']})")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
