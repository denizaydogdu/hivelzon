"""Kitaplık kaynak biçimi (H-066): `kitaplar/<SEVİYE>-K<NN>-<kisa-baslik>/`.

Dosyalar (ayrıntı: docs/KITAPLIK.md §6):
- `book.json`        meta veri, bölümler → sayfalar (şema: schema/book.schema.json)
- `text.en.md`       sayfa sayfa İngilizce metin (işaretler aşağıda)
- `ceviri.tr.json`   bölümlerdeki biçimle aynı (translation.py): status, lines[en, tr, chunks, words]
- `glossary.md`      seviye üstü kelimeler tablosu: | Kelime | Türkçe | Örnek | Not |
- `rights-and-review.md`, `PROMPTS.md`
- `audio/<bölüm>.mp3` (git dışı) ve `audio/<bölüm>.align.json` (ElevenLabs hizalaması, depoda)
- `images/` (git dışı kaynak görseller)

`text.en.md` işaretleri (satır başında):
    # Kitap Başlığı                 isteğe bağlı; book.json `title` ile aynı olmalı
    > yorum                         sese ve denetime girmez
    ## [c1] Bölüm Başlığı           bölüm başı; başlık seslendirilir
    ### [p01]                       sayfa başı; altındaki satırlar o sayfanın metnidir
    (boş satır)                     paragraf sonu; paragraf içindeki satırlar boşlukla birleşir
Gövde düz metindir: Markdown biçimlendirmesi (*, _, `, [, ]) kullanılmaz.
"""

from __future__ import annotations

import hashlib
import json
import re
from dataclasses import dataclass, field
from pathlib import Path

BOOK_FILE = "book.json"
TEXT_FILE = "text.en.md"
GLOSSARY_FILE = "glossary.md"
RIGHTS_FILE = "rights-and-review.md"
PROMPTS_FILE = "PROMPTS.md"
AUDIO_DIR = "audio"
IMAGES_DIR = "images"

ID_RE = re.compile(r"^(A1|A2|B1|B2|C1|C2)-K\d{2}$")
DIR_RE = re.compile(r"^(A1|A2|B1|B2|C1|C2)-K\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*$")
CHAPTER_RE = re.compile(r"^##\s+\[(c\d{1,2})\]\s*(.+?)\s*$")
PAGE_RE = re.compile(r"^###\s+\[(p\d{2,3})\]\s*$")
TITLE_RE = re.compile(r"^#\s+(.+?)\s*$")
MARKUP_RE = re.compile(r"[*_`\[\]]")
HEADING_SEP = ".\n\n"

# Seviye tablosu (docs/KITAPLIK.md §4). `speed`: ElevenLabs voice_settings.speed başlangıç değeri
# (bölümlerde A1 için 0.9 ölçüldü: ~107 k/dk; kitapta 144–168). Gerçek hız book-lint'te hizalamadan
# ölçülür (`wpm`). `pacing`: `narration.pacing` yoksa dışa aktarmadaki anlatım temposu modu (pacing.py, H-069).
BOOK_LEVELS: dict[str, dict] = {
    "A1": {"words": 700, "pages": (10, 12), "chapters": (2, 3), "wpm": (100, 110), "speed": 0.90, "pacing": "auto"},
    "A2": {"words": 1500, "pages": (14, 16), "chapters": (3, 4), "wpm": (115, 125), "speed": 0.95, "pacing": "auto"},
    "B1": {"words": 3000, "pages": (18, 20), "chapters": (4, 5), "wpm": (130, 140), "speed": 1.00, "pacing": "auto"},
    "B2": {"words": 5000, "pages": (22, 24), "chapters": (5, 6), "wpm": (145, 155), "speed": 1.00, "pacing": "off"},
    "C1": {"words": 8000, "pages": (26, 28), "chapters": (6, 7), "wpm": (150, 170), "speed": 1.05, "pacing": "off"},
    "C2": {"words": 10000, "pages": (28, 30), "chapters": (7, 8), "wpm": (150, 180), "speed": 1.05, "pacing": "off"},
}
WORD_TOLERANCE = 0.20

# Kısaltmadan sonraki nokta cümle sonu sayılmaz.
ABBREVIATIONS = {"mr", "mrs", "ms", "dr", "st", "mt", "prof", "jr", "sr", "vs", "etc", "a.m", "p.m", "e.g", "i.e"}
_END_RE = re.compile(r"[.!?…]+[\"”’')\]]*(?=\s|$)")


class BookError(ValueError):
    pass


def split_sentences(par: str) -> list[str]:
    """Paragrafı cümlelere böler. Kısaltma (Mr.) ve alıntıdan sonra küçük harfle devam eden
    cümle (\"Hello!\" says Lina.) bölünmez."""
    out: list[str] = []
    start = 0
    for m in _END_RE.finditer(par):
        token = par[start:m.start()].split()
        last = token[-1].lower().rstrip(".") if token else ""
        if m.group().startswith(".") and m.group().rstrip("\"”’')]") == "." and last in ABBREVIATIONS:
            continue
        rest = par[m.end():].lstrip()
        if rest and rest[0].islower():
            continue
        s = par[start:m.end()].strip()
        if s:
            out.append(s)
        start = m.end()
    tail = par[start:].strip()
    if tail:
        out.append(tail)
    return out


@dataclass
class Sentence:
    id: str
    text: str
    paragraph: int


@dataclass
class Page:
    id: str
    chapter: str
    number: int
    line: int
    paragraphs: list[str] = field(default_factory=list)
    sentences: list[Sentence] = field(default_factory=list)


@dataclass
class Chapter:
    id: str
    title: str
    line: int
    pages: list[Page] = field(default_factory=list)

    @property
    def heading(self) -> Sentence:
        return Sentence(f"{self.id}-h", self.title, 0)

    def spoken(self) -> list[Sentence]:
        """Seste sırayla okunan birimler: başlık + sayfaların cümleleri."""
        return [self.heading] + [s for p in self.pages for s in p.sentences]

    def tts_text(self) -> str:
        """ElevenLabs'e gönderilen metin. Başlıktan sonra nokta ve paragraf arası; paragraflar arasında
        boş satır. Hizalama bu metnin karakterlerini taşır (align.locate boşlukları yok sayar)."""
        head = self.title if self.title[-1:] in ".!?…" else self.title + "."
        body = "\n\n".join(par for p in self.pages for par in p.paragraphs)
        return head + "\n\n" + body if body else head


@dataclass
class BookText:
    title: str | None
    chapters: list[Chapter]
    errors: list[str]

    @property
    def pages(self) -> list[Page]:
        return [p for c in self.chapters for p in c.pages]

    def sentences(self) -> list[Sentence]:
        return [s for p in self.pages for s in p.sentences]

    def texts(self) -> list[str]:
        """Denetime giren İngilizce metin: bölüm başlıkları + bütün cümleler."""
        return [c.title for c in self.chapters] + [s.text for s in self.sentences()]


def parse_text(text: str) -> BookText:
    title = None
    chapters: list[Chapter] = []
    errors: list[str] = []
    page: Page | None = None
    buf: list[str] = []
    n = 0

    def flush_par() -> None:
        if page is not None and buf:
            page.paragraphs.append(re.sub(r"\s+", " ", " ".join(buf)).strip())
        buf.clear()

    for no, raw in enumerate(text.splitlines(), start=1):
        line = raw.strip()
        if line.startswith(">"):
            continue
        if line.startswith("### "):
            m = PAGE_RE.match(line)
            if not m:
                errors.append(f"satır {no}: sayfa işareti `### [p01]` biçiminde olmalı: {line!r}")
                continue
            flush_par()
            if not chapters:
                errors.append(f"satır {no}: sayfa {m.group(1)} bir bölümden (`## [c1] …`) önce geliyor")
                chapters.append(Chapter("c?", "?", no))
            n += 1
            page = Page(m.group(1), chapters[-1].id, n, no)
            chapters[-1].pages.append(page)
            continue
        if line.startswith("## "):
            m = CHAPTER_RE.match(line)
            if not m:
                errors.append(f"satır {no}: bölüm işareti `## [c1] Başlık` biçiminde olmalı: {line!r}")
                continue
            flush_par()
            page = None
            chapters.append(Chapter(m.group(1), m.group(2), no))
            continue
        if line.startswith("# "):
            if chapters or title is not None:
                errors.append(f"satır {no}: kitap başlığı (`# …`) yalnızca en başta bir kez olur")
            else:
                title = TITLE_RE.match(line).group(1)
            continue
        if not line:
            flush_par()
            continue
        if page is None:
            errors.append(f"satır {no}: metin bir sayfanın (`### [p01]`) dışında: {line[:50]!r}")
            continue
        if MARKUP_RE.search(line):
            errors.append(f"satır {no}: gövdede Markdown biçimlendirmesi (* _ ` [ ]) kullanılmaz: {line[:50]!r}")
        buf.append(line)
    flush_par()
    for c in chapters:
        for p in c.pages:
            k = 0
            for pi, par in enumerate(p.paragraphs, start=1):
                for s in split_sentences(par):
                    k += 1
                    p.sentences.append(Sentence(f"{p.id}-s{k:02d}", s, pi))
    return BookText(title, chapters, errors)


@dataclass
class GlossEntry:
    en: str
    tr: str
    example: str = ""
    note: str = ""
    line: int = 0


def parse_glossary(text: str) -> tuple[list[GlossEntry], list[str]]:
    """`glossary.md` tablosu. Başlık satırında `Kelime` (ya da `Word`/`EN`) ve `Türkçe` (ya da `TR`)
    sütunları; isteğe bağlı `Örnek` ve `Not`. Tablo dışındaki satırlar serbest metindir."""
    entries: list[GlossEntry] = []
    errors: list[str] = []
    cols: dict[str, int] | None = None
    for no, raw in enumerate(text.splitlines(), start=1):
        line = raw.strip()
        if not line.startswith("|"):
            cols = None   # tablo bitti; sonraki tablo kendi başlığıyla başlar
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if all(re.fullmatch(r":?-{2,}:?", c) for c in cells if c):
            continue
        low = [c.lower() for c in cells]
        if cols is None:
            def find(*names: str) -> int | None:
                return next((i for i, c in enumerate(low) if c in names), None)
            en, tr = find("kelime", "word", "en", "ifade"), find("türkçe", "turkce", "tr", "anlam")
            if en is None or tr is None:
                errors.append(f"satır {no}: sözlük tablosunun başlığında `Kelime` ve `Türkçe` sütunları olmalı")
                cols = {}
            else:
                cols = {"en": en, "tr": tr, "example": find("örnek", "ornek", "example"), "note": find("not", "note")}
            continue
        if not cols:
            continue

        def cell(key: str) -> str:
            i = cols.get(key)
            return cells[i] if i is not None and i < len(cells) else ""
        if cell("en"):
            entries.append(GlossEntry(cell("en"), cell("tr"), cell("example"), cell("note"), no))
    return entries, errors


def text_sha256(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


@dataclass
class Book:
    dir: Path
    meta: dict
    text: BookText
    glossary: list[GlossEntry]
    glossary_errors: list[str]

    @classmethod
    def load(cls, book_dir: Path) -> "Book":
        d = Path(book_dir)
        bp = d / BOOK_FILE
        if not bp.exists():
            raise BookError(f"{BOOK_FILE} yok: {d}")
        try:
            meta = json.loads(bp.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            raise BookError(f"{BOOK_FILE} geçersiz JSON: {e}") from e
        tp = d / TEXT_FILE
        text = parse_text(tp.read_text(encoding="utf-8")) if tp.exists() else BookText(None, [], [f"{TEXT_FILE} yok"])
        gp = d / GLOSSARY_FILE
        gl, ge = parse_glossary(gp.read_text(encoding="utf-8")) if gp.exists() else ([], [])
        return cls(d, meta, text, gl, ge)

    @property
    def id(self) -> str:
        return self.meta.get("id", "?")

    @property
    def level(self) -> str:
        return self.meta.get("level", "?")

    @property
    def proper_nouns(self) -> set[str]:
        out = set()
        for p in self.meta.get("properNouns", []) or []:
            out.update(w.lower() for w in re.findall(r"[A-Za-zÇĞİÖŞÜçğıöşüé']+", p))
        return out

    def chapter_meta(self) -> list[dict]:
        return list(self.meta.get("chapters", []) or [])

    def page_meta(self) -> dict[str, dict]:
        return {p["id"]: p for c in self.chapter_meta() for p in c.get("pages", []) if isinstance(p, dict) and "id" in p}

    def align_path(self, chapter_id: str) -> Path:
        return self.dir / AUDIO_DIR / f"{chapter_id}.align.json"

    def audio_path(self, chapter_id: str) -> Path:
        return self.dir / AUDIO_DIR / f"{chapter_id}.mp3"

    def image_path(self, name: str) -> Path:
        return self.dir / IMAGES_DIR / name

    def narration(self) -> dict:
        n = dict(self.meta.get("narration") or {})
        n.setdefault("modelId", "eleven_v3")
        n.setdefault("speed", BOOK_LEVELS.get(self.level, {}).get("speed", 1.0))
        return n
