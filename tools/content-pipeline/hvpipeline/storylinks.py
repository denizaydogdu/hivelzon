"""Dilbilgisi dersindeki "Hikâyede gör" bağlarının çözülmesi (H-077).

Bağ, bölüm altyazı satırına ya da kitap cümlesine **birebir cümle eşleşmesiyle** bağlanır
(boşluk ve tırnak biçimi farkı yok sayılır; büyük/küçük harf ve noktalama sayılır).

- **Bölüm** (`icerik/<id>/`, kimlik content.json `contentId`): önce paket altyazıları
  (`_build/package/scenes.json` + `subs/*.json`), yoksa kurgu.json'dan kuru derleme (build_dry; hizalamalar
  depoda), o da yoksa story.en.md satırı (yalnızca satır numarası; derin bağ düğümsüz kalır).
  Altyazı ipucu birden çok cümle taşıyabilir ("Yes. I'm your new neighbour."): cümlelerden biri eşleşirse yeter.
- **Kitap** (`kitaplar/<id>-…/`): kaynak metin (text.en.md); cümle kimlikleri paketteki pages.json ile aynıdır.
  Paket varsa cümlenin zamanları pages.json'dan eklenir.

Sonuç derin bağ hedefidir: bölüm kimliği + düğüm + altyazı satırı ya da kitap kimliği + sayfa + cümle.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path

from . import REPO_ROOT
from .book import Book, BookError, split_sentences

ICERIK_ROOT = REPO_ROOT / "icerik"
BOOKS_ROOT = REPO_ROOT / "kitaplar"
_Q = str.maketrans({"’": "'", "‘": "'", "“": '"', "”": '"', "—": "-", "–": "-", "…": "..."})


def norm_sentence(s: str) -> str:
    return re.sub(r"\s+", " ", s.translate(_Q)).strip()


@dataclass
class Resolution:
    target: dict | None
    error: str | None = None
    warnings: list[str] = field(default_factory=list)


class StoryIndex:
    def __init__(self, icerik_root: Path | None = None, books_root: Path | None = None):
        self.icerik_root = Path(icerik_root) if icerik_root else ICERIK_ROOT
        self.books_root = Path(books_root) if books_root else BOOKS_ROOT
        self._episodes: dict[str, Path] | None = None
        self._books: dict[str, Path] | None = None
        self._cues: dict[str, tuple[list[dict], str | None]] = {}
        self._sents: dict[str, tuple[list[dict], str | None]] = {}

    # --- kataloglar ---
    def episodes(self) -> dict[str, Path]:
        if self._episodes is None:
            self._episodes = {}
            if self.icerik_root.is_dir():
                for cp in sorted(self.icerik_root.glob("*/content.json")):
                    if cp.parent.name.startswith("_"):
                        continue
                    try:
                        cid = json.loads(cp.read_text(encoding="utf-8")).get("contentId")
                    except (OSError, ValueError):
                        continue
                    if cid:
                        self._episodes.setdefault(cid, cp.parent)
        return self._episodes

    def books(self) -> dict[str, Path]:
        if self._books is None:
            self._books = {}
            if self.books_root.is_dir():
                for bp in sorted(self.books_root.glob("*/book.json")):
                    if bp.parent.name.startswith("_"):
                        continue
                    try:
                        bid = json.loads(bp.read_text(encoding="utf-8")).get("id")
                    except (OSError, ValueError):
                        continue
                    if bid:
                        self._books.setdefault(bid, bp.parent)
        return self._books

    # --- bölüm altyazıları ---
    def episode_cues(self, ep_id: str) -> tuple[list[dict], str | None]:
        """[{node, cueId, text, start, end, source}] ve (varsa) neden bulunamadığı."""
        if ep_id in self._cues:
            return self._cues[ep_id]
        d = self.episodes().get(ep_id)
        if d is None:
            res: tuple[list[dict], str | None] = ([], f"bölüm bulunamadı: {ep_id} ({self.icerik_root})")
        else:
            res = self._load_cues(d)
        self._cues[ep_id] = res
        return res

    def _load_cues(self, d: Path) -> tuple[list[dict], str | None]:
        pkg = d / "_build" / "package"
        out: list[dict] = []
        if (pkg / "scenes.json").exists():
            try:
                doc = json.loads((pkg / "scenes.json").read_text(encoding="utf-8"))
                for n in doc.get("nodes", []):
                    rel = n.get("subtitles")
                    if rel and (pkg / rel).exists():
                        sub = json.loads((pkg / rel).read_text(encoding="utf-8"))
                        out += [{"node": n["id"], "cueId": c.get("id"), "text": c["text"], "start": c.get("start"),
                                 "end": c.get("end"), "source": "package"} for c in sub.get("cues", [])]
                return out, None
            except (OSError, ValueError, KeyError) as e:
                return [], f"paket altyazıları okunamadı: {e}"
        if (d / "kurgu.json").exists():
            from .build import BuildError, build_dry
            try:
                _, b = build_dry(d)
            except (BuildError, FileNotFoundError, KeyError, ValueError) as e:
                return [], f"kurgu kuru derlenemedi: {e}"
            for sub in b.subs.values():
                out += [{"node": sub["segment"], "cueId": c["id"], "text": c["text"], "start": c["start"],
                         "end": c["end"], "source": "kurgu"} for c in sub["cues"]]
            return out, None
        if (d / "story.en.md").exists():
            from .story import read_story
            out = [{"node": None, "cueId": None, "storyLine": ln.line_no, "text": ln.text, "start": None,
                    "end": None, "source": "story"} for ln in read_story(d / "story.en.md")]
            return out, None
        return [], "bölümde altyazı, kurgu.json ya da story.en.md yok"

    # --- kitap cümleleri ---
    def book_sentences(self, book_id: str) -> tuple[list[dict], str | None]:
        if book_id in self._sents:
            return self._sents[book_id]
        d = self.books().get(book_id)
        if d is None:
            res: tuple[list[dict], str | None] = ([], f"kitap bulunamadı: {book_id} ({self.books_root})")
        else:
            try:
                book = Book.load(d)
            except BookError as e:
                res = ([], str(e))
            else:
                times = {}
                pj = d / "_build" / "package" / "pages.json"
                if pj.exists():
                    try:
                        for p in json.loads(pj.read_text(encoding="utf-8")).get("pages", []):
                            for s in p.get("sentences", []):
                                times[s["id"]] = (s.get("start"), s.get("end"))
                    except (OSError, ValueError, KeyError):
                        times = {}
                out = []
                for c in book.text.chapters:
                    for p in c.pages:
                        for s in p.sentences:
                            st, en = times.get(s.id, (None, None))
                            out.append({"chapter": c.id, "page": p.id, "sentenceId": s.id, "text": s.text,
                                        "start": st, "end": en})
                res = (out, None)
        self._sents[book_id] = res
        return res

    # --- çözüm ---
    def resolve(self, kind: str, target: str, text: str, hint: str | None = None) -> Resolution:
        want = norm_sentence(text)
        if kind == "episode":
            cues, err = self.episode_cues(target)
            if err:
                return Resolution(None, err)
            pool = [c for c in cues if hint is None or c.get("node") == hint]
            hits = [c for c in pool if norm_sentence(c["text"]) == want
                    or want in (norm_sentence(s) for s in split_sentences(c["text"]))]
            if not hits:
                where = f" (düğüm {hint})" if hint else ""
                return Resolution(None, f"bölüm {target}{where} altyazısında birebir cümle yok: \"{text}\"")
            h = hits[0]
            t = {"kind": "episode", "episodeId": target, "node": h.get("node"), "cueId": h.get("cueId"),
                 "text": text, "cueText": h["text"], "start": h.get("start"), "end": h.get("end")}
            res = Resolution(t)
            if h["source"] == "story":
                t["storyLine"] = h.get("storyLine")
                res.warnings.append(f"bölüm {target}: altyazı yok (kurgu/paket yok); bağ yalnız story.en.md "
                                    f"satırına çözüldü (satır {h.get('storyLine')}), düğüm yok")
            if len(hits) > 1:
                res.warnings.append(f"bölüm {target}: cümle {len(hits)} yerde geçiyor; ilki kullanıldı "
                                    f"({h.get('node')}/{h.get('cueId')}); düğüm vererek seç")
            return res
        if kind == "book":
            sents, err = self.book_sentences(target)
            if err:
                return Resolution(None, err)
            pool = [s for s in sents if hint is None or s["page"] == hint]
            hits = [s for s in pool if norm_sentence(s["text"]) == want]
            if not hits:
                where = f" (sayfa {hint})" if hint else ""
                return Resolution(None, f"kitap {target}{where} metninde birebir cümle yok: \"{text}\"")
            h = hits[0]
            t = {"kind": "book", "bookId": target, "chapter": h["chapter"], "page": h["page"],
                 "sentenceId": h["sentenceId"], "text": h["text"], "start": h["start"], "end": h["end"]}
            res = Resolution(t)
            if len(hits) > 1:
                res.warnings.append(f"kitap {target}: cümle {len(hits)} yerde geçiyor; ilki kullanıldı "
                                    f"({h['page']}/{h['sentenceId']}); sayfa vererek seç")
            return res
        return Resolution(None, f"bilinmeyen bağ türü: {kind}")
