"""CEFR-J kapsama ve cümle uzunluğu denetimi (kaynak: geçici cefr_check.py v2).

Seviyeler A1–C2 (C2: Kitaplık, H-066). CEFR-J listesi A1–B2'yi kapsar. C1 ve C2 için CEFR-J'ye
Octanove C1/C2 eklenir; bu liste CC BY-SA 4.0'dır ve **ayrı veri seti** olarak ayrı dosyada durur
(`data/lexicon_ccbysa/`, `docs/LISANS-RAPORU.md` §2.3). Dosya yoksa C1/C2 kapsaması denetlenmez.
"""

from __future__ import annotations

import csv
import re
from dataclasses import dataclass, field
from functools import lru_cache
from pathlib import Path

from . import DATA_DIR

LEVELS = ["A1", "A2", "B1", "B2", "C1", "C2"]
CEFRJ_LEVELS = ["A1", "A2", "B1", "B2"]          # CEFR-J v1.6'nın kapsadığı seviyeler
WORDLIST = DATA_DIR / "cefrj-wordlist-v1.6.csv"
# Octanove C1/C2 (CC BY-SA 4.0): ayrı veri seti, ayrı dosya. Depoda yoksa C1/C2 kapsaması denetlenmez.
CCBYSA_DIR = DATA_DIR / "lexicon_ccbysa"
OCTANOVE = CCBYSA_DIR / "octanove-vocabulary-profile-c1c2-1.0.csv"
NO_LIST_MSG = "liste yok; kapsama denetlenmedi"
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
    # Düzensiz geçmiş zaman (A2 past simple; H-069 kitapları). Başsözcük listede yoksa yine liste dışı sayılır.
    "began": "begin", "begun": "begin", "broke": "break", "broken": "break", "brought": "bring",
    "built": "build", "caught": "catch", "chose": "choose", "cost": "cost", "cut": "cut",
    "drew": "draw", "drove": "drive", "fell": "fall", "felt": "feel", "flew": "fly", "forgot": "forget",
    "froze": "freeze", "grew": "grow", "held": "hold", "hid": "hide", "hit": "hit", "hung": "hang",
    "kept": "keep", "lay": "lie", "led": "lead", "left": "leave", "lent": "lend", "let": "let",
    "lost": "lose", "meant": "mean", "met": "meet", "paid": "pay", "put": "put", "rang": "ring",
    "rode": "ride", "sang": "sing", "sent": "send", "shook": "shake", "shot": "shoot",
    "shut": "shut", "slept": "sleep", "sold": "sell", "spent": "spend", "spoke": "speak",
    "stood": "stand", "stole": "steal", "swam": "swim", "taught": "teach", "threw": "throw",
    "understood": "understand", "woke": "wake", "wore": "wear", "won": "win",
    "better": "good", "best": "good", "worse": "bad", "worst": "bad",
    # Düzensiz üçüncü hâl (V3; B1–B2 dilbilgisi dersleri, H-081: edilgen, perfect, koşul, wish).
    # Başsözcük listede yoksa yine liste dışı sayılır.
    "born": "bear", "beaten": "beat", "bitten": "bite", "chosen": "choose", "done": "do",
    "driven": "drive", "drunk": "drink", "eaten": "eat", "fallen": "fall", "flown": "fly",
    "forgotten": "forget", "frozen": "freeze", "given": "give", "gone": "go", "grown": "grow",
    "hidden": "hide", "known": "know", "ridden": "ride", "risen": "rise", "seen": "see",
    "shaken": "shake", "shown": "show", "spoken": "speak", "stolen": "steal", "sung": "sing",
    "swum": "swim", "taken": "take", "thrown": "throw", "woken": "wake", "worn": "wear",
    "written": "write",
    # -ie fiilleri: lie → lying
    "lying": "lie", "dying": "die", "tying": "tie",
}

# "'s" yalnızca bu sözcüklerde "is"; diğerlerinde iyelik ekidir ve atılır.
S_IS = {"it", "what", "that", "he", "she", "there", "where", "who", "here", "how"}
NT_BASE = {"can": "can", "won": "will", "don": "do", "doesn": "does", "didn": "did",
           "isn": "is", "aren": "are", "wasn": "was", "weren": "were", "couldn": "could",
           "shouldn": "should", "wouldn": "would", "haven": "have", "hasn": "has", "hadn": "had", "mustn": "must"}
OTHER_CONTR = {"m": "am", "re": "are", "ll": "will", "ve": "have", "d": "would"}

SUFFIXES = (("ies", "y"), ("es", ""), ("s", ""), ("ied", "y"), ("ed", ""), ("ed", "e"),
            ("ing", ""), ("ing", "e"), ("d", ""),
            # karşılaştırma ve üstünlük (A2: louder, happier, redder); en son denenir
            ("ier", "y"), ("iest", "y"), ("er", ""), ("er", "e"), ("est", ""), ("est", "e"))
DOUBLED_SUFFIXES = ("ing", "ed", "er", "est")   # çift ünsüz: running → run, redder → red, biggest → big


@dataclass
class Wordlist:
    allowed: set[str]
    levels: dict[str, str]
    level: str
    sources: dict[str, str] = field(default_factory=dict)   # başsözcük -> "cefrj" | "octanove" | ...


def _csv_rows(p: Path) -> list[dict]:
    rows = [ln for ln in p.read_text(encoding="utf-8").splitlines() if ln.strip() and not ln.startswith("#")]
    out = []
    for r in csv.DictReader(rows):
        out.append({(k or "").strip(): (v or "").strip() for k, v in r.items()})
    return out


def has_extra_list(level: str, path: str | None = None) -> bool:
    """C1/C2 için ek liste (Octanove) bu ortamda var mı? A1–B2 için her zaman True."""
    if level in CEFRJ_LEVELS:
        return True
    return Path(path).exists() if path else OCTANOVE.exists()


@lru_cache(maxsize=16)
def load_wordlist(level: str = "A1", path: str | None = None, extra: str | None = None) -> Wordlist:
    """Kümülatif liste: `level` ve altındaki başsözcükler.

    A1–B2: yalnızca CEFR-J. C1/C2: CEFR-J'nin tamamı + ek listenin (`extra`, varsayılan Octanove)
    `level`'e kadarki satırları. Ek dosyada `source` sütunu varsa kaynak oradan, yoksa "octanove".
    Ek dosya yoksa yalnızca CEFR-J kullanılır (çağıran `has_extra_list` ile uyarı verir).
    """
    p = Path(path) if path else WORDLIST
    allowed: set[str] = set()
    lv: dict[str, str] = {}
    src: dict[str, str] = {}
    max_i = LEVELS.index(level) if level in LEVELS else len(CEFRJ_LEVELS) - 1

    def add(rows: list[dict], default_source: str) -> None:
        for r in rows:
            cefr = r.get("CEFR", "").upper()
            if cefr not in LEVELS:
                continue
            for h in r.get("headword", "").split("/"):
                h = h.strip().lower()
                if not h:
                    continue
                cur = lv.get(h)
                if cur is None or LEVELS.index(cefr) < LEVELS.index(cur):
                    lv[h] = cefr
                    src[h] = r.get("source") or default_source
                if LEVELS.index(cefr) <= max_i:
                    allowed.add(h)

    add(_csv_rows(p), "cefrj")
    if level not in CEFRJ_LEVELS:
        ep = Path(extra) if extra else OCTANOVE
        if ep.exists():
            add(_csv_rows(ep), "octanove")
    allowed.update({"oclock", "not"})
    return Wordlist(allowed, lv, level, src)


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
            if suf in DOUBLED_SUFFIXES and len(b) > 2 and b[-1] == b[-2] and b[:-1] in pool:
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
             max_words: int = 8, extra: str | None = None) -> Coverage:
    wl = load_wordlist(level, None, extra)
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
            # Önce yalnız listeye göre: sözlükteki bir öğrenci notu (ör. "going to", "sang") listedeki
            # bir sözcüğü liste dışına itmesin.
            base = lemma(w, wl.allowed)
            lem = base if base in wl.allowed else lemma(w, wl.allowed, gl)
            if lem in wl.allowed:
                cov.in_list += 1
            elif w in gl or lem in gl:
                cov.glossed += 1
                cov.off_list.setdefault(lem, ["gloss", 0])[1] += 1
            else:
                cov.off_list.setdefault(lem, [wl.levels.get(lem, "YOK"), 0])[1] += 1
    return cov
