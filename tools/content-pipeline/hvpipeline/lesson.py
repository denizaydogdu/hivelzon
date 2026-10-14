"""Dilbilgisi dersi kaynak biçimi (H-077; docs/DILBILGISI.md §4, §9): `dilbilgisi/<G-ID>/`.

Dosyalar:
- `lesson.json`          meta veri (şema: schema/lesson.schema.json): kimlik, seviye, Türkçe ad ve hedef,
                         önkoşullar, sürüm, durum (K-05), aiGenerated, öğretmen kontrolü, bağlar
- `lesson.md`            kartlar (aşağıdaki işaretler)
- `PROMPTS.md`, `rights-and-review.md`
- `audio/tr/<kart>-tr.{mp3,align.json}`   Türkçe anlatım (tts_tr: Alania + Duyu)
- `audio/en/<örnek>.{mp3,align.json}`     İngilizce örnek (ElevenLabs, Sarah)
- `audio/lesson-audio.json`               kart → ses parçası haritası (tts_lesson.py yazar)
Ses dosyaları (mp3) git dışındadır; hizalamalar ve harita depodadır (kitaplardaki gibi).

`lesson.md` işaretleri (satır başında):
    # G-A1-03-third-person-s        isteğe bağlı; lesson.json `id` ile aynı olmalı
    > yorum                         sese ve denetime girmez (<!-- --> da)
    ## <tür> [| Kart başlığı]       kart başı; tür: hook explain examples contrast practice seeInStory rule
    düz satır                       Türkçe anlatım (Hi, Alania). Boş satır paragraf sonu. Düz cümle:
                                    * _ ` [ ] yok; İngilizce kelime yazılmaz (ayrı İngilizce örneğe taşınır)
    + She [[goes]] to school. | O okula gider.     İngilizce örnek | Türkçesi; [[ ]] hedef yapı (Sarah okur)
    x She go to school. | -s eksik                 yanlış biçim (contrast); sesi yok, kapsamaya girmez
    ? choose | She ___ to school. | go | *goes      alıştırma: seç (doğru seçenek * ile)
    ? fill | He ___ football. (play) | plays        boşluk doldur (kabul edilen cevaplar)
    ? order | to / goes / She / school | She goes to school.    sıraya koy (parçalar / cevap)
    ? say | She goes to school. [| O okula gider.]  "Söyle" (H-055); örnek sesi Sarah okur
    ! Türkçe açıklama                               bir önceki alıştırmanın yanlış cevap açıklaması
    - episode A1-001 [s01] | Can you hear me?       "Hikâyede gör" bağı: bölüm altyazı satırı (düğüm isteğe bağlı)
    - book A1-K01 [p03] | Lina opens the door.      kitap cümlesi (sayfa isteğe bağlı); birebir cümle eşleşmesi
    @diagram timeline | past: I played | now: I play | future: I will play
    @diagram boxes | She :: özne | goes :: fiil + -es | to school
    @diagram suffix | go+es | play+s | watch+es
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path

from . import REPO_ROOT
from .book import MARKUP_RE, split_sentences, text_sha256

LESSON_FILE = "lesson.json"
CARDS_FILE = "lesson.md"
PROMPTS_FILE = "PROMPTS.md"
RIGHTS_FILE = "rights-and-review.md"
AUDIO_DIR = "audio"
TR_DIR = "tr"
EN_DIR = "en"
AUDIO_MANIFEST = "lesson-audio.json"
DEFAULT_ROOT = REPO_ROOT / "dilbilgisi"

ID_PATTERN = r"G-(A1|A2|B1|B2|C1|C2)-\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*"
ID_RE = re.compile(rf"^{ID_PATTERN}$")
CARD_TYPES = ("hook", "explain", "examples", "contrast", "practice", "seeInStory", "rule")
REQUIRED_CARDS = ("hook", "explain", "examples", "contrast", "practice", "rule")
REPEATABLE_CARDS = {"explain"}
PRACTICE_KINDS = ("choose", "fill", "order", "say")
DIAGRAM_KINDS = ("timeline", "boxes", "suffix")
TIMELINE_POINTS = ("past", "now", "future")
BLANK = "___"
REVIEW_REQUIRED = {"APPROVED", "SCHEDULED", "PUBLISHED"}

# İngilizce örnek sesi (DILBILGISI §2: kitaplardaki gibi Sarah). Hız seviyeye göre (book.BOOK_LEVELS).
EN_VOICE = "EXAVITQu4vr4xnSDxMaL"
EN_MODEL = "eleven_v3"

HEADING_RE = re.compile(r"^##\s+(\w+)\s*(?:\|\s*(.+?))?\s*$")
TITLE_RE = re.compile(r"^#\s+(.+?)\s*$")
TARGET_RE = re.compile(r"\[\[(.+?)\]\]")
LINK_RE = re.compile(r"^-\s+(episode|book)\s+(\S+)(?:\s+(\S+))?\s*\|\s*(.+?)\s*$")
DIAGRAM_RE = re.compile(r"^@diagram\s+(\S+)\s*(?:\|\s*(.*))?$")


class LessonError(ValueError):
    pass


@dataclass
class Example:
    id: str
    marked: str              # [[ ]] işaretli İngilizce
    tr: str
    line: int
    wrong: bool = False

    @property
    def en(self) -> str:
        return TARGET_RE.sub(r"\1", self.marked)

    @property
    def targets(self) -> list[dict]:
        """Hedef yapının düz metindeki karakter aralıkları."""
        out, shift = [], 0
        for m in TARGET_RE.finditer(self.marked):
            start = m.start() - shift
            out.append({"start": start, "end": start + len(m.group(1)), "text": m.group(1)})
            shift += 4
        return out


@dataclass
class PracticeItem:
    id: str
    kind: str
    line: int
    stem: str = ""
    options: list[str] = field(default_factory=list)
    correct: list[int] = field(default_factory=list)
    answers: list[str] = field(default_factory=list)
    tokens: list[str] = field(default_factory=list)
    tr: str = ""
    feedback: str = ""

    def solved(self) -> str | None:
        """Doğru cevabın yerleştiği İngilizce cümle (kapsama ve "Söyle" için)."""
        if self.kind == "choose" and self.correct:
            return self.stem.replace(BLANK, self.options[self.correct[0]], 1)
        if self.kind == "fill" and self.answers:
            return re.sub(r"\s*\([^)]*\)\s*$", "", self.stem).replace(BLANK, self.answers[0], 1)
        if self.kind == "order" and self.answers:
            return self.answers[0]
        if self.kind == "say":
            return self.stem
        return None


@dataclass
class Link:
    kind: str                # episode | book
    target: str              # A1-001 | A1-K01
    hint: str | None         # düğüm (s01) ya da sayfa (p03)
    text: str
    line: int


@dataclass
class Diagram:
    kind: str
    spec: dict
    line: int


@dataclass
class Card:
    id: str
    type: str
    line: int
    title: str | None = None
    paragraphs: list[str] = field(default_factory=list)
    examples: list[Example] = field(default_factory=list)
    practice: list[PracticeItem] = field(default_factory=list)
    links: list[Link] = field(default_factory=list)
    diagrams: list[Diagram] = field(default_factory=list)

    @property
    def narration(self) -> str:
        """Alania'ya giden metin: paragraflar boş satırla."""
        return "\n\n".join(self.paragraphs)

    @property
    def sentences(self) -> list[str]:
        return [s for p in self.paragraphs for s in split_sentences(p)]

    @property
    def right(self) -> list[Example]:
        return [e for e in self.examples if not e.wrong]

    @property
    def wrong(self) -> list[Example]:
        return [e for e in self.examples if e.wrong]

    @property
    def tr_segment_id(self) -> str:
        return f"{self.id}-tr"


@dataclass
class EnSegment:
    id: str
    text: str
    card: str
    role: str                # example | say


@dataclass
class LessonText:
    title: str | None
    cards: list[Card]
    errors: list[str]


def parse_diagram(kind: str, raw: str) -> tuple[dict | None, str | None]:
    items = [x.strip() for x in (raw or "").split("|") if x.strip()]
    if kind not in DIAGRAM_KINDS:
        return None, f"bilinmeyen şema türü {kind!r} ({', '.join(DIAGRAM_KINDS)})"
    if kind == "timeline":
        points = []
        for it in items:
            at, sep, text = it.partition(":")
            at = at.strip()
            if not sep or at not in TIMELINE_POINTS or not text.strip():
                return None, f"timeline öğesi `past|now|future: metin` olmalı: {it!r}"
            points.append({"at": at, "text": text.strip()})
        if not points:
            return None, "timeline en az bir nokta ister"
        return {"kind": kind, "points": points}, None
    if kind == "boxes":
        boxes = []
        for it in items:
            text, _, cap = it.partition("::")
            box = {"text": text.strip()}
            if cap.strip():
                box["caption"] = cap.strip()
            boxes.append(box)
        if len(boxes) < 2:
            return None, "boxes en az iki kutu ister"
        return {"kind": kind, "boxes": boxes, "arrows": True}, None
    words = []
    for it in items:
        m = re.fullmatch(r"([A-Za-z'’]+)\+([A-Za-z'’]+)", it)
        if not m:
            return None, f"suffix öğesi `kök+ek` olmalı (ör. go+es): {it!r}"
        words.append({"base": m.group(1), "suffix": m.group(2), "word": m.group(1) + m.group(2)})
    if not words:
        return None, "suffix en az bir kelime ister"
    return {"kind": kind, "words": words}, None


def _parse_practice(card: Card, raw: str, no: int, errors: list[str]) -> None:
    fields = [f.strip() for f in raw[1:].split("|")]
    kind = fields[0]
    rest = fields[1:]
    item = PracticeItem(f"{card.id}-q{len(card.practice) + 1}", kind, no)
    if kind not in PRACTICE_KINDS:
        errors.append(f"satır {no}: bilinmeyen alıştırma türü {kind!r} ({', '.join(PRACTICE_KINDS)})")
        return
    if not rest or not rest[0]:
        errors.append(f"satır {no}: alıştırmanın metni yok")
        return
    item.stem = rest[0]
    if kind == "choose":
        for k, o in enumerate(rest[1:]):
            if o.startswith("*"):
                item.correct.append(k)
                o = o[1:].strip()
            item.options.append(o)
    elif kind == "fill":
        item.answers = [a for a in rest[1:] if a]
    elif kind == "order":
        item.tokens = [t.strip() for t in rest[0].split("/") if t.strip()]
        item.stem = ""
        item.answers = [a for a in rest[1:] if a]
    elif kind == "say":
        item.tr = rest[1] if len(rest) > 1 else ""
    card.practice.append(item)


def parse_lesson_md(text: str) -> LessonText:
    title = None
    cards: list[Card] = []
    errors: list[str] = []
    buf: list[str] = []
    text = re.sub(r"<!--.*?-->", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)

    def flush() -> None:
        if cards and buf:
            cards[-1].paragraphs.append(re.sub(r"\s+", " ", " ".join(buf)).strip())
        buf.clear()

    for no, raw in enumerate(text.splitlines(), start=1):
        line = raw.strip()
        if line.startswith(">"):
            continue
        if line.startswith("## "):
            flush()
            m = HEADING_RE.match(line)
            if not m or m.group(1) not in CARD_TYPES:
                errors.append(f"satır {no}: kart başlığı `## <tür>` olmalı ({', '.join(CARD_TYPES)}): {line!r}")
                cards.append(Card(f"c{len(cards) + 1:02d}", "?", no))
                continue
            cards.append(Card(f"c{len(cards) + 1:02d}", m.group(1), no, m.group(2)))
            continue
        if line.startswith("# "):
            if cards or title is not None:
                errors.append(f"satır {no}: ders başlığı (`# …`) yalnızca en başta bir kez olur")
            else:
                title = TITLE_RE.match(line).group(1)
            continue
        if not line:
            flush()
            continue
        if not cards:
            errors.append(f"satır {no}: metin bir kartın (`## <tür>`) dışında: {line[:50]!r}")
            continue
        card = cards[-1]
        if line[0] in "+x" and len(line) > 1 and line[1] == " ":
            flush()
            en, _, tr = line[2:].partition("|")
            wrong = line[0] == "x"
            ex_id = f"{card.id}-{'x' if wrong else 'ex'}{sum(1 for e in card.examples if e.wrong == wrong) + 1}"
            card.examples.append(Example(ex_id, en.strip(), tr.strip(), no, wrong))
            continue
        if line.startswith("?"):
            flush()
            _parse_practice(card, line, no, errors)
            continue
        if line.startswith("!"):
            flush()
            if not card.practice:
                errors.append(f"satır {no}: `!` açıklaması bir alıştırmadan sonra gelir")
            else:
                fb = card.practice[-1].feedback
                card.practice[-1].feedback = f"{fb} {line[1:].strip()}".strip()
            continue
        if line.startswith("- "):
            flush()
            m = LINK_RE.match(line)
            if not m:
                errors.append(f"satır {no}: bağ `- episode A1-001 [s01] | cümle` ya da `- book A1-K01 [p03] | cümle` "
                              f"biçiminde olmalı: {line[:60]!r}")
            else:
                card.links.append(Link(m.group(1), m.group(2), m.group(3), m.group(4), no))
            continue
        if line.startswith("@"):
            flush()
            m = DIAGRAM_RE.match(line)
            if not m:
                errors.append(f"satır {no}: şema `@diagram <tür> | öğe | öğe` biçiminde olmalı")
                continue
            spec, err = parse_diagram(m.group(1), m.group(2) or "")
            if err:
                errors.append(f"satır {no}: {err}")
            else:
                card.diagrams.append(Diagram(m.group(1), spec, no))
            continue
        if MARKUP_RE.search(line):
            errors.append(f"satır {no}: Türkçe anlatım düz metindir (* _ ` [ ] yok): {line[:50]!r}")
        buf.append(line)
    flush()
    return LessonText(title, cards, errors)


@dataclass
class Lesson:
    dir: Path
    meta: dict
    text: LessonText

    @classmethod
    def load(cls, lesson_dir: Path) -> "Lesson":
        d = Path(lesson_dir)
        lp = d / LESSON_FILE
        if not lp.exists():
            raise LessonError(f"{LESSON_FILE} yok: {d}")
        try:
            meta = json.loads(lp.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            raise LessonError(f"{LESSON_FILE} geçersiz JSON: {e}") from e
        cp = d / CARDS_FILE
        text = parse_lesson_md(cp.read_text(encoding="utf-8")) if cp.exists() else LessonText(None, [], [f"{CARDS_FILE} yok"])
        return cls(d, meta, text)

    @property
    def id(self) -> str:
        return self.meta.get("id", "?")

    @property
    def level(self) -> str:
        return self.meta.get("level", "?")

    @property
    def cards(self) -> list[Card]:
        return self.text.cards

    @property
    def pronunciations(self) -> list[dict]:
        return list(self.meta.get("pronunciations") or [])

    def tr_voice(self) -> dict:
        n = dict((self.meta.get("narration") or {}).get("tr") or {})
        from . import tts_tr
        n.setdefault("voice", tts_tr.VOICE)
        n.setdefault("model", tts_tr.TTS_MODEL)
        return n

    def en_voice(self) -> dict:
        from .book import BOOK_LEVELS
        n = dict((self.meta.get("narration") or {}).get("en") or {})
        n.setdefault("voiceId", EN_VOICE)
        n.setdefault("modelId", EN_MODEL)
        n.setdefault("speed", BOOK_LEVELS.get(self.level, {}).get("speed", 1.0))
        return n

    # --- ses parçaları ---
    def tr_segments(self):
        """Türkçe anlatım parçaları (kart başına bir parça): tts_tr.Segment listesi."""
        from .tts_tr import Segment
        ins = self.tr_voice().get("instructions")
        out = []
        for c in self.cards:
            if not c.paragraphs:
                continue
            low = c.narration.lower()
            pr = [p for p in self.pronunciations if str(p.get("term", "")).lower() in low] or None
            out.append(Segment(c.tr_segment_id, c.narration, ins, pr))
        return out

    def en_segments(self) -> list[EnSegment]:
        """İngilizce parçalar: her doğru örnek (+) ve her "Söyle" alıştırması."""
        out = []
        for c in self.cards:
            for e in c.right:
                out.append(EnSegment(e.id, e.en, c.id, "example"))
            for p in c.practice:
                if p.kind == "say" and p.stem:
                    out.append(EnSegment(p.id, p.stem, c.id, "say"))
        return out

    def tr_dir(self) -> Path:
        return self.dir / AUDIO_DIR / TR_DIR

    def en_dir(self) -> Path:
        return self.dir / AUDIO_DIR / EN_DIR

    def tr_paths(self, seg_id: str) -> tuple[Path, Path]:
        return self.tr_dir() / f"{seg_id}.mp3", self.tr_dir() / f"{seg_id}.align.json"

    def en_paths(self, seg_id: str) -> tuple[Path, Path]:
        return self.en_dir() / f"{seg_id}.mp3", self.en_dir() / f"{seg_id}.align.json"

    def english_texts(self) -> list[str]:
        """Kapsama denetimine giren İngilizce metin: doğru örnekler ve alıştırmaların çözülmüş hâli."""
        out = [e.en for c in self.cards for e in c.right]
        out += [s for c in self.cards for p in c.practice if (s := p.solved())]
        return out


# --- Türkçe anlatımdaki İngilizce kelimeler ------------------------------------------------------
# Alania İngilizce kelimeleri Türkçe okur (DILBILGISI §6.1 duman testi): Türkçe parçada İngilizce
# kelime olmamalı; ayrı İngilizce örnek parçasına taşınır ya da söyleniş sözlüğüne yazılır.

TR_LETTERS = set("çğıöşüÇĞİÖŞÜâîû")
# CEFR-J listesinde de bulunan yaygın Türkçe kelimeler (yanlış alarm olmasın).
TR_COMMON = {
    "her", "say", "son", "can", "top", "set", "test", "plan", "program", "problem", "film", "net", "far", "bar",
    "park", "bank", "tip", "model", "form", "fit", "star", "stop", "metro", "pilot", "robot", "radar", "kilo",
    "ton", "bin", "dam", "hat", "had", "has", "git", "gel", "port", "post", "tank", "fan", "pas", "mat", "kit",
    "bit", "sen", "ben", "dil", "yer", "art", "hem", "pin", "pan", "tek", "kim", "ama", "ile", "bas", "ten", "tam",
    "kas", "per", "sor", "dem", "kaz", "bale", "dans", "fan", "gaz", "lira", "makine", "menü", "mini", "nokta",
    "oda", "orta", "sade", "sakin", "sinema", "taksi", "tenis", "video", "yoga", "kart", "kare", "dur", "sus",
    "bal", "kek", "lamba", "masa", "para", "radyo", "sabah", "saat", "sana", "sen", "ses", "site", "spor",
}
# Kısa İngilizce işlev kelimeleri (3 harften kısa olanlar listeyle denetlenmez; Türkçeyle çakışanlar yok:
# "on", "an", "in", "de", "da", "ne" dışarıda).
EN_SHORT = {"he", "it", "is", "am", "do", "to", "of", "my", "me", "we", "us", "go", "no", "so", "up", "by", "be"}
_TR_WORD_RE = re.compile(r"(?<![\w-])-[A-Za-z]{1,3}\b|[^\W\d_]+(?:['’][^\W\d_]+)*", re.UNICODE)


def tr_words(sentence: str) -> list[str]:
    return [w for w in _TR_WORD_RE.findall(sentence) if not w.startswith("-")]


def english_in_turkish(text: str, pronunciations: list[dict] | None = None) -> list[str]:
    """Türkçe anlatımda İngilizce görünen kelimeler ve `-s` gibi ek gösterimleri (sıralı, tekrarsız)."""
    from .cefr import IRREGULAR, lemma, load_wordlist
    wl = load_wordlist("B2")
    vocab = set(wl.levels)
    said = {str(p.get("term", "")).lower() for p in (pronunciations or [])}
    out: list[str] = []
    for tok in _TR_WORD_RE.findall(text):
        low = tok.lower()
        if low in said or tok in out:
            continue
        if tok.startswith("-"):
            out.append(tok)
            continue
        base = re.split(r"['’]", low)[0]
        if any(c in TR_LETTERS for c in base) or base in TR_COMMON or base in said:
            continue
        if base in EN_SHORT or re.search(r"[qwx]", base) or (len(base) >= 3 and (base in vocab or base in IRREGULAR
                                                            or lemma(base, vocab) in vocab)):
            out.append(tok)
    return out


# --- ders klasörleri -----------------------------------------------------------------------------

def known_lessons(root: Path | None = None) -> set[str]:
    r = Path(root) if root else DEFAULT_ROOT
    if not r.is_dir():
        return set()
    return {p.parent.name for p in r.glob(f"*/{LESSON_FILE}") if not p.parent.name.startswith("_")}


def check_grammar_topics(topics, root: Path | None = None) -> list[tuple[str, str]]:
    """Bölüm ve kitaptaki `grammarTopics` (isteğe bağlı): (düzey, ileti) listesi.

    Biçim hatalıysa hata. Ders klasöründe ders varsa bilinmeyen kimlik hatadır; henüz hiç ders yoksa
    uyarı (bağ denetlenemedi)."""
    if topics is None:
        return []
    if not isinstance(topics, list) or not all(isinstance(t, str) for t in topics):
        return [("error", "`grammarTopics` kimlik listesi olmalı")]
    out = []
    bad = [t for t in topics if not ID_RE.match(t)]
    for t in bad:
        out.append(("error", f"`grammarTopics` kimliği `G-<SEVİYE>-<2 hane>-<kisa-ad>` olmalı: {t!r}"))
    seen = set()
    for t in topics:
        if t in seen:
            out.append(("warning", f"`grammarTopics` iki kez: {t}"))
        seen.add(t)
    known = known_lessons(root)
    good = [t for t in dict.fromkeys(topics) if t not in bad]
    if not known:
        if good:
            out.append(("warning", f"dilbilgisi dersi yok ({Path(root) if root else DEFAULT_ROOT}); "
                                   f"`grammarTopics` bağı denetlenmedi: {', '.join(good)}"))
        return out
    for t in good:
        if t not in known:
            out.append(("error", f"`grammarTopics` dersi bulunamadı: {t}"))
    return out


__all__ = ["Lesson", "LessonError", "Card", "Example", "PracticeItem", "Link", "Diagram", "EnSegment",
           "parse_lesson_md", "parse_diagram", "english_in_turkish", "known_lessons", "check_grammar_topics",
           "text_sha256"]
