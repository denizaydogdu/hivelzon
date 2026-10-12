"""ceviri.tr.json → altyazı ve kart metinlerine Türkçe anlam (H-046).

Kaynak dosya: icerik/<id>/ceviri.tr.json
    {"status": "DRAFT", "lines": [{"en", "speaker", "tr", "chunks": [{"en", "tr"}], "words": {anahtar: anlam},
                                   "source"}],
     "phrases": [{"en", "tr", "words": {anahtar: anlam}, "source", "note"}], "notes": [...]}

- `phrases` (H-052): altyazıda ya da kartta birebir geçmeyen hedef ifadelerin ve sözlük kelimelerinin
  anlamı (ör. B1 *Listen.* → "Dinle."). Altyazı eşlemesine girmez; yalnızca 🎯 paneli, defter kartı
  ve bölüm sözlüğü kullanır.

- Eşleme, İngilizce metnin birebir aynısıyla yapılır; yalnızca boşluklar normalleştirilir.
- Kelime anlamı (`gloss`), kelimenin anahtarıyla (küçük harf, baştaki/sondaki noktalama atılmış) bulunur.
- Kalıp ifadeler (`chunks`), cümledeki kelime aralığına (`startWord`..`endWord`, ikisi de dahil) çevrilir.
- `source` yalnızca bilgi içindir.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path

from .cefr import load_proper_nouns

TRANSLATION_FILE = "ceviri.tr.json"
_EDGE = re.compile(r"^[\W_]+|[\W_]+$", re.UNICODE)
_BLANK = re.compile(r"^\W*_{2,}\W*$")
_PREFIX = re.compile(r"^[^:]{1,20}:\s+(.+)$")
GAP = None  # kalıpta boşluk: "between … and …", "It's + gün"


def norm_text(s: str) -> str:
    return re.sub(r"\s+", " ", s or "").strip()


def word_key(w: str) -> str:
    """Kelime anahtarı: küçük harf; baştaki ve sondaki noktalama (… " ! ? . ,) atılır, içteki ' ve : kalır."""
    w = (w or "").replace("’", "'").replace("‘", "'")
    w = _EDGE.sub("", w)
    return w.lower()


def split_words(text: str) -> list[str]:
    """Kart metni için kelime listesi (zaman yok). Anahtarı boş olan parçalar (·, /, —) atlanır;
    görev boşluğu (___) kalır ama anlam istemez."""
    return [w for w in norm_text(text).split(" ") if word_key(w) or _BLANK.match(w)]


def chunk_pattern(en: str) -> list[str | None]:
    """Kalıbın kelime anahtarları; `…` ve `+ <yer tutucu>` boşluktur (GAP)."""
    out: list[str | None] = []
    toks = norm_text(en).split(" ")
    skip = False
    for t in toks:
        if skip:
            out.append(GAP)
            skip = False
            continue
        if t == "+":
            skip = True
            continue
        k = word_key(t)
        if k:
            out.append(k)
        if "…" in t or "..." in t:
            out.append(GAP)
    # ardışık boşlukları teke indir
    res: list[str | None] = []
    for x in out:
        if x is GAP and res and res[-1] is GAP:
            continue
        res.append(x)
    return res


@dataclass
class Miss:
    """Çeviriyle eşleşmeyen metin ya da anlamı olmayan kelime (lint için)."""
    where: str          # ör. "subs/s02.en.json#s02-01", "card c-msg"
    text: str
    kind: str           # "line" | "word" | "chunk"
    detail: str = ""
    required: bool = True   # altyazı ipucu: zorunlu; kart/görev metni: önerilen


@dataclass
class Translation:
    path: Path
    status: str
    lines: dict[str, dict]
    duplicates: list[str] = field(default_factory=list)
    phrases: list[dict] = field(default_factory=list)
    proper: frozenset = field(default_factory=load_proper_nouns)

    @classmethod
    def load(cls, ep_dir: Path) -> "Translation | None":
        p = Path(ep_dir) / TRANSLATION_FILE
        if not p.exists():
            return None
        d = json.loads(p.read_text(encoding="utf-8"))
        lines: dict[str, dict] = {}
        dups = []
        for ln in d.get("lines", []):
            k = norm_text(ln.get("en", ""))
            if not k:
                continue
            if k in lines and lines[k].get("tr") != ln.get("tr"):
                dups.append(k)
            lines.setdefault(k, ln)
        phrases = [ph for ph in d.get("phrases", []) if norm_text(ph.get("en", "")) and ph.get("tr")]
        return cls(p, d.get("status", "DRAFT"), lines, dups, phrases)

    def find(self, text: str) -> dict | None:
        return self.lines.get(norm_text(text))

    def needs_gloss(self, key: str) -> bool:
        return bool(key) and key not in self.proper

    # --- ortak çekirdek ---
    def _annotate(self, text: str, words: list[str], where: str, misses: list[Miss],
                  required: bool, allow_prefix: bool = False) -> tuple[str | None, list[str | None], list[dict]]:
        line = self.find(text)
        if line is None and allow_prefix:
            m = _PREFIX.match(norm_text(text))
            if m and self.find(m.group(1)) is not None:
                # "Bölüm 2: The New Neighbour" → İngilizce başlık kısmı
                line = self.find(m.group(1))
                words[:] = split_words(m.group(1))
        if line is None:
            misses.append(Miss(where, text, "line", "ceviri.tr.json'da bu metin yok", required))
            return None, [None] * len(words), []
        glossmap = {word_key(k): v for k, v in (line.get("words") or {}).items()}
        keys = [word_key(w) for w in words]
        glosses: list[str | None] = []
        for w, k in zip(words, keys):
            g = glossmap.get(k)
            if g is None and self.needs_gloss(k):
                misses.append(Miss(where, text, "word", w, required))
            glosses.append(g)
        chunks = []
        for ch in line.get("chunks") or []:
            span = _find_span(keys, chunk_pattern(ch.get("en", "")))
            if span is None:
                misses.append(Miss(where, text, "chunk", ch.get("en", ""), False))
                continue
            chunks.append({"en": ch["en"], "tr": ch["tr"], "startWord": span[0], "endWord": span[1]})
        return line.get("tr"), glosses, chunks

    # --- altyazı ipucu ---
    def annotate_cue(self, cue: dict, where: str, misses: list[Miss]) -> dict:
        words = [w["w"] for w in cue["words"]]
        tr, glosses, chunks = self._annotate(cue["text"], words, where, misses, True)
        cue["tr"] = tr
        for w, g in zip(cue["words"], glosses):
            w["gloss"] = g
        cue["chunks"] = chunks
        return cue

    # --- kart satırı, karar repliği, görev kökü (zamansız metin) ---
    def gloss_text(self, text: str, where: str, misses: list[Miss]) -> dict | None:
        """Bulunursa {"tr", "words": [{"w", "gloss"}], "chunks"}; bulunamazsa None."""
        words = split_words(text)
        tr, glosses, chunks = self._annotate(text, words, where, misses, False, allow_prefix=True)
        if tr is None:
            return None
        return {"tr": tr, "words": [{"w": w, "gloss": g} for w, g in zip(words, glosses)], "chunks": chunks}

    # --- hedef ifade (🎯 paneli, H-050) ---
    def gloss_phrase(self, phrase: str) -> dict | None:
        """Önce birebir satır, sonra herhangi bir satırdaki kalıp (`chunks[].en`), en son `phrases`
        (H-052). Bulunamazsa None; content-lint bunu hata sayar (`target-meaning`)."""
        g = self.gloss_text(phrase, "targetPhrase", [])
        if g is not None:
            return g
        key = _phrase_key(phrase)
        for line in self.lines.values():
            for ch in line.get("chunks") or []:
                if _phrase_key(ch.get("en", "")) == key:
                    glossmap = {word_key(k): v for k, v in (line.get("words") or {}).items()}
                    return {"tr": ch["tr"], "chunks": [],
                            "words": [{"w": w, "gloss": glossmap.get(word_key(w))} for w in split_words(phrase)]}
        ph = self._phrase(phrase)
        if ph is not None:
            glossmap = {word_key(k): v for k, v in (ph.get("words") or {}).items()}
            return {"tr": ph["tr"], "chunks": [],
                    "words": [{"w": w, "gloss": glossmap.get(word_key(w))} for w in split_words(phrase)]}
        return None

    def _phrase(self, text: str) -> dict | None:
        key = _phrase_key(text)
        return next((ph for ph in self.phrases if _phrase_key(ph["en"]) == key), None)

    # --- bölüm sözlüğü (H-052) ---
    def glossary_meaning(self, word: str) -> str | None:
        """Sözlük kelimesinin Türkçesi: `phrases` → satır kalıbı (`chunks[].en`, çok kelimeli girişler
        için) → herhangi bir satırın `words` anlamı (ilk geçtiği satır). Bulunamazsa None."""
        ph = self._phrase(word)
        if ph is not None:
            return ph["tr"]
        key = _phrase_key(word)
        multi = len(split_words(word)) > 1
        if multi:
            for line in self.lines.values():
                for ch in line.get("chunks") or []:
                    if _phrase_key(ch.get("en", "")) == key:
                        return ch["tr"]
            return None
        wk = word_key(word)
        for line in self.lines.values():
            for k, v in (line.get("words") or {}).items():
                if word_key(k) == wk and v:
                    return v
        return None


def _phrase_key(s: str) -> str:
    return norm_text(s).replace("...", "…").lower()


def _find_span(keys: list[str], pat: list[str | None]) -> tuple[int, int] | None:
    """Kalıbın ilk eşleşmesi (startWord, endWord). Boşluk 0+ kelime tutar; sondaki boşluk ise
    en az 1 kelime varsa cümle sonuna kadar uzanır (\"between … and …\")."""
    lits = [p for p in pat if p is not GAP]
    if not lits:
        return None

    def match(i: int, j: int) -> int | None:  # keys[i:], pat[j:] → son kelime indeksi + 1
        if j == len(pat):
            return i
        p = pat[j]
        if p is GAP:
            if j + 1 == len(pat):
                return len(keys) if len(keys) > i else i
            for k in range(i, len(keys)):
                r = match(k, j + 1)
                if r is not None:
                    return r
            return None
        if i < len(keys) and keys[i] == p:
            return match(i + 1, j + 1)
        return None

    first = 0 if pat[0] is not GAP else 1
    for i in range(len(keys)):
        if keys[i] != pat[first]:
            continue
        end = match(i, first)
        if end is not None and end > i:
            return i, end - 1
    return None
