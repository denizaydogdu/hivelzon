"""CEFR-J kapsama ve cümle uzunluğu denetimi (kaynak: geçici cefr_check.py v2)."""

from __future__ import annotations

import csv
import re
from dataclasses import dataclass, field
from functools import lru_cache
from pathlib import Path

from . import DATA_DIR

LEVELS = ["A1", "A2", "B1", "B2"]
WORDLIST = DATA_DIR / "cefrj-wordlist-v1.6.csv"
PROPER_NOUNS = DATA_DIR / "proper_nouns.txt"

# Ünlemler özel ad gibi sayılmaz (kapsama paydasına girmez). Belgelendi: docs/BOLUM-PAKETI.md.
INTERJECTIONS = {"oh", "ah", "ha", "hmm", "wow", "uh", "um", "shh"}

IRREGULAR = {
    "is": "be", "am": "be", "are": "be", "was": "be", "were": "be", "been": "be",
    "has": "have", "had": "have", "does": "do", "did": "do", "goes": "go", "went": "go",
    "says": "say", "said": "say", "men": "man", "women": "woman", "children": "child",
    "people": "person", "an": "a", "made": "make", "came": "come", "saw": "see",
    "took": "take", "got": "get", "knew": "know", "found": "find",
    "heard": "hear", "told": "tell", "thought": "think", "gave": "give", "sat": "sit",
    "ran": "run", "wrote": "write", "ate": "eat", "drank": "drink", "bought": "buy",
}

# "'s" yalnızca bu sözcüklerde "is"; diğerlerinde iyelik ekidir ve atılır.
S_IS = {"it", "what", "that", "he", "she", "there", "where", "who", "here", "how"}
NT_BASE = {"can": "can", "won": "will", "don": "do", "doesn": "does", "didn": "did",
           "isn": "is", "aren": "are", "wasn": "was", "weren": "were", "couldn": "could",
           "shouldn": "should", "wouldn": "would", "haven": "have", "hasn": "has", "mustn": "must"}
OTHER_CONTR = {"m": "am", "re": "are", "ll": "will", "ve": "have", "d": "would"}

SUFFIXES = (("ies", "y"), ("es", ""), ("s", ""), ("ied", "y"), ("ed", ""), ("ed", "e"),
            ("ing", ""), ("ing", "e"), ("d", ""))


@dataclass
class Wordlist:
    allowed: set[str]
    levels: dict[str, str]
    level: str


@lru_cache(maxsize=8)
def load_wordlist(level: str = "A1", path: str | None = None) -> Wordlist:
    p = Path(path) if path else WORDLIST
    rows = [ln for ln in p.read_text(encoding="utf-8").splitlines() if not ln.startswith("#")]
    allowed: set[str] = set()
    lv: dict[str, str] = {}
    max_i = LEVELS.index(level) if level in LEVELS else len(LEVELS) - 1
    for r in csv.DictReader(rows):
        for h in r["headword"].split("/"):
            h = h.strip().lower()
            if not h:
                continue
            cur = lv.get(h)
            if cur is None or LEVELS.index(r["CEFR"]) < LEVELS.index(cur):
                lv[h] = r["CEFR"]
            if LEVELS.index(r["CEFR"]) <= max_i:
                allowed.add(h)
    allowed.update({"oclock", "not"})
    return Wordlist(allowed, lv, level)


@lru_cache(maxsize=1)
def load_proper_nouns() -> frozenset[str]:
    words = set()
    for ln in PROPER_NOUNS.read_text(encoding="utf-8").splitlines():
        ln = ln.strip().lower()
        if ln and not ln.startswith("#"):
            words.add(ln)
    return frozenset(words)


def normalize(text: str) -> str:
    t = re.sub(r"\[[^\]]*\]", " ", text)
    t = re.sub(r"\([^)]*\)", " ", t)
    return t.replace("’", "'").replace("‘", "'")


def tokens(text: str) -> list[str]:
    """Küçük harfli sözcükler; kısaltmalar açılır, yarım sözcükler (Fri…) atılır."""
    t = normalize(text)
    t = re.sub(r"\b\w+…|…\w+\b", " ", t)
    low = t.replace("İ", "I").lower()
    out: list[str] = []
    for w in re.findall(r"[a-zçğıöşüéè]+(?:-[a-zçğıöşüéè]+)*(?:'[a-z]+)?", low):
        if w == "o'clock":
            out.append("oclock")
            continue
        if "'" not in w:
            out.append(w)
            continue
        base, suf = w.split("'", 1)
        if suf == "t" and base.endswith("n"):
            stem = base[:-1]
            if base in NT_BASE:
                out += [NT_BASE[base], "not"]
            elif stem in NT_BASE.values():
                out += [stem, "not"]
            else:
                out += [base, "not"]
        elif suf == "s":
            out += [base, "is"] if base in S_IS else [base]
            if base == "let":
                out[-1:] = ["let", "us"]
        elif suf in OTHER_CONTR:
            out += [base, OTHER_CONTR[suf]]
        else:
            out.append(base)
    return [w for w in out if w]


def lemma(w: str, allowed: set[str], extra: set[str] = frozenset()) -> str:
    if w in IRREGULAR:
        return IRREGULAR[w]
    pool = allowed | extra
    if w in pool:
        return w
    for suf, rep in SUFFIXES:
        if w.endswith(suf) and len(w) > len(suf) + 1:
            b = w[: -len(suf)] + rep
            if b in pool:
                return b
            if suf in ("ing", "ed") and len(b) > 2 and b[-1] == b[-2] and b[:-1] in pool:
                return b[:-1]
    return w


def sentences(text: str) -> list[list[str]]:
    t = normalize(text)
    out = []
    for sent in re.split(r"[.!?…]+", t):
        words = re.findall(r"[A-Za-zÇĞİÖŞÜçğıöşüé']+", sent)
        if words:
            out.append(words)
    return out


@dataclass
class Coverage:
    level: str
    tokens: int = 0
    in_list: int = 0
    glossed: int = 0
    off_list: dict[str, list] = field(default_factory=dict)  # lemma -> [level|YOK|gloss, count]
    long_sentences: list[str] = field(default_factory=list)
    max_sentence_words: int = 0

    @property
    def pct(self) -> float:
        return 100.0 * self.in_list / self.tokens if self.tokens else 100.0

    @property
    def pct_with_gloss(self) -> float:
        return 100.0 * (self.in_list + self.glossed) / self.tokens if self.tokens else 100.0

    def unglossed(self) -> dict[str, list]:
        return {k: v for k, v in self.off_list.items() if v[0] != "gloss"}


def coverage(texts: list[str], level: str = "A1", gloss: list[str] = (), proper: set[str] = frozenset(),
             max_words: int = 8) -> Coverage:
    wl = load_wordlist(level)
    pn = set(load_proper_nouns()) | {p.lower() for p in proper}
    gl = set()
    for g in gloss:
        g = g.lower().strip()
        gl.add(g)
        gl.update(g.split())  # "next to" → next, to
    cov = Coverage(level)
    for text in texts:
        for s in sentences(text):
            n = len(s)
            cov.max_sentence_words = max(cov.max_sentence_words, n)
            if n > max_words:
                cov.long_sentences.append(" ".join(s))
        toks = []
        for w in tokens(text):
            # Tireli sözcük listede yoksa parçalarına ayrılır (T-shirt listede var; "well-known" yoksa iki sözcük).
            toks += w.split("-") if "-" in w and w not in wl.allowed and w not in wl.levels else [w]
        for w in toks:
            if w in pn or w in INTERJECTIONS:
                continue
            cov.tokens += 1
            lem = lemma(w, wl.allowed, gl)
            if lem in wl.allowed:
                cov.in_list += 1
            elif w in gl or lem in gl:
                cov.glossed += 1
                cov.off_list.setdefault(lem, ["gloss", 0])[1] += 1
            else:
                cov.off_list.setdefault(lem, [wl.levels.get(lem, "YOK"), 0])[1] += 1
    return cov
