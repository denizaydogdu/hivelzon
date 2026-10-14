"""Ortak cümle bölücü ve harf/özel ad yardımcıları (kitap, ders ve kapsama denetimi; H-073).

Cümleler `. ! ? …` (ve ardından gelen kapanış tırnağı/parantez) + boşluk ile biter. Bölünmeyen durumlar:
- Kısaltmalar: *Mr. Mrs. Ms. Dr. St. Prof. a.m. p.m. e.g. i.e. etc.* (`ABBREVIATIONS`).
- Sayı kısaltmaları yalnız ardından rakam gelirse: *No. 3*, *p. 12* (`NUMBER_ABBREVIATIONS`).
  ("I said no. Then…" bölünür.)
- Baş harfler: tek büyük harf + nokta + büyük harfle başlayan sözcük, ve şu üçünden biri:
  sonraki sözcük bilinen bir özel ad (`names`: kitabın `properNouns`'u + `data/proper_nouns.txt`;
  *A. Serra*), önceki sözcük bir unvan (*Ms A. Serra*, *Professor K. Lind*) ya da başka bir baş harf
  (*J. R. Hale*). "This is E. Meet me…" (imza) böylece yine iki cümledir.
- Ondalık sayı (*3.5*) ve sözcük içi nokta (*e.g.*) zaten boşluksuz olduğu için bölünmez.
- Alıntıdan sonra küçük harfle devam eden konuşma eki (`"Stop!" says Lina.`) aynı cümledir.

Harfler Unicode'dur: aksanlı Latin ve Türkçe harfler (*Lucía, Tomás, Zoë, Şebnem, Çağrı, Ömer*) sözcük
içinde kalır; özel ad anahtarları bu yüzden bölünmez.
"""

from __future__ import annotations

import re

LETTER = r"[^\W\d_]"
# Özel ad parçaları ve sözcükler: Unicode harfler, içte kesme işareti (O'Neill, Lina's).
NAME_WORD_RE = re.compile(rf"{LETTER}+(?:['’]{LETTER}+)*")

ABBREVIATIONS = {"mr", "mrs", "ms", "dr", "st", "mt", "prof", "jr", "sr", "vs", "etc", "a.m", "p.m", "e.g", "i.e"}
NUMBER_ABBREVIATIONS = {"no", "nos", "p", "pp", "vol", "ch", "fig"}
# Baş harften önce gelebilen unvanlar (İngiliz yazımında noktasız: Ms A. Serra).
TITLES = {"mr", "mrs", "ms", "miss", "dr", "prof", "professor", "doctor", "sir", "dame", "lady", "lord",
          "captain", "inspector", "sergeant", "judge", "aunt", "uncle"}
_END_RE = re.compile(r"[.!?…]+[\"”’')\]]*(?=\s|$)")
_OPENERS = "\"“‘'([«"
_INITIAL_NEXT_RE = re.compile(rf"(?:[^\W\d_a-z])\.\s")   # sonraki sözcük de baş harf: J. R. Hale


def _is_initial(tok: str) -> bool:
    return len(tok) == 1 and tok.isalpha() and tok.isupper()


def no_break(before: str, mark: str, rest: str, names=frozenset()) -> bool:
    """Bu noktadan sonra cümle bitmiyor mu? (kısaltma, sayı kısaltması, baş harf)"""
    if mark.rstrip("\"”’')]") != ".":
        return False
    toks = before.split()
    tok = toks[-1].lstrip(_OPENERS) if toks else ""
    low = tok.lower().rstrip(".")
    if low in ABBREVIATIONS:
        return True
    if low in NUMBER_ABBREVIATIONS and rest[:1].isdigit():
        return True
    if _is_initial(tok) and rest[:1].isupper():
        nxt = NAME_WORD_RE.match(rest)
        prev = toks[-2].lstrip(_OPENERS).rstrip(".") if len(toks) > 1 else ""
        chain = _INITIAL_NEXT_RE.match(rest) is not None or _is_initial(prev)
        if (nxt and nxt.group().lower() in names) or prev.lower() in TITLES or chain:
            return True   # baş harf: A. Serra, Ms A. Serra, J. R. Hale
    return False


def split_sentences(par: str, names=frozenset()) -> list[str]:
    """Paragrafı cümlelere böler (kurallar modül belgesinde). `names`: küçük harfli özel ad anahtarları
    (baş harf kuralı için; `name_keys`)."""
    out: list[str] = []
    start = 0
    for m in _END_RE.finditer(par):
        rest = par[m.end():].lstrip()
        if no_break(par[start:m.start()], m.group(), rest, names):
            continue
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


def name_keys(names) -> set[str]:
    """Özel ad listesinden küçük harfli anahtarlar (kapsama ve kelime anlamı muafiyeti).
    "İlse" hem `i̇lse` (str.lower) hem `ilse` (kapsama, İ→I) olarak eklenir."""
    out: set[str] = set()
    for p in names or []:
        for w in NAME_WORD_RE.findall(str(p).replace("’", "'")):
            out.add(w.lower())
            out.add(w.replace("İ", "I").lower())
    return out
