"""ElevenLabs karakter hizalamasından altyazı ipuçları (cue) ve kelime zamanları.

Kaynak: geçici kurgu.py v3 `chunks()` ve bolum_yardimci.py `grup()`.
Kurallar (D-001): cümle parçası düzeyinde zamanlama; 2 kelimeden kısa parça sonrakiyle birleşir;
ipucu söylenen sözün sonundan 0,15 sn sonra (ya da sonraki ipucu başlayınca) kalkar;
çekimin ilk ipucu, ölçülen ses başlangıcından önce başlamaz (enerji eşiği ile öne kayma telafisi).
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path

CUE_TAIL = 0.15
MIN_WORDS = 2


@dataclass
class Alignment:
    chars: list[str]
    starts: list[float]
    ends: list[float]

    @classmethod
    def load(cls, path: Path) -> "Alignment":
        a = json.loads(Path(path).read_text(encoding="utf-8"))["alignment"]
        return cls(list(a["characters"]), list(a["character_start_times_seconds"]),
                   list(a["character_end_times_seconds"]))

    @property
    def text(self) -> str:
        return "".join(self.chars)

    @property
    def end(self) -> float:
        return self.ends[-1] if self.ends else 0.0

    def scaled(self, atempo: float) -> "Alignment":
        f = 1.0 / (atempo or 1.0)
        return Alignment(self.chars[:], [s * f for s in self.starts], [e * f for e in self.ends])

    def shifted(self, dt: float) -> "Alignment":
        return Alignment(self.chars[:], [s + dt for s in self.starts], [e + dt for e in self.ends])


@dataclass
class Part:
    """Çekim sesindeki tek bir replik: konuşmacı + çekim sesi zaman çizelgesine kaydırılmış hizalama."""
    speaker: str
    align: Alignment


@dataclass
class Cue:
    text: str
    start: float
    end: float
    speaker: str
    words: list[dict] = field(default_factory=list)

    def shifted(self, dt: float) -> "Cue":
        return Cue(self.text, self.start + dt, self.end + dt, self.speaker,
                   [{"w": w["w"], "start": w["start"] + dt, "end": w["end"] + dt} for w in self.words])


def _sentence_chunks(chars: list[str]) -> list[list[int]]:
    parts: list[list[int]] = []
    cur: list[int] = []
    for i, c in enumerate(chars):
        cur.append(i)
        if c in ".?!" and (i + 1 == len(chars) or chars[i + 1] == " "):
            parts.append(cur)
            cur = []
    if cur:
        parts.append(cur)
    merged: list[list[int]] = []
    buf: list[int] = []
    for p in parts:
        buf += p
        txt = "".join(chars[k] for k in buf).strip()
        if len(txt.split()) >= MIN_WORDS:
            merged.append(buf)
            buf = []
    if buf:
        if merged:
            merged[-1] += buf
        else:
            merged.append(buf)
    return [m for m in merged if "".join(chars[k] for k in m).strip()]


def _words(al: Alignment, idx: list[int]) -> list[dict]:
    out: list[dict] = []
    cur: list[int] = []
    for k in idx + [None]:
        if k is None or al.chars[k].isspace():
            if cur:
                out.append({"w": "".join(al.chars[j] for j in cur),
                            "start": al.starts[cur[0]], "end": al.ends[cur[-1]]})
                cur = []
        else:
            cur.append(k)
    return out


def part_cues(part: Part) -> list[Cue]:
    al = part.align
    out = []
    for m in _sentence_chunks(al.chars):
        idx = [k for k in m if al.chars[k].strip()]
        if not idx:
            continue
        words = _words(al, m)
        out.append(Cue("".join(al.chars[k] for k in m).strip(), al.starts[idx[0]], al.ends[idx[-1]],
                       part.speaker, words))
    return out


def shot_cues(parts: list[Part], lead: float = 0.0) -> list[Cue]:
    """Bir çekimin bütün ipuçları (çekim sesi zaman çizelgesinde, aoff eklenmeden).

    lead: çekim sesinde ölçülen ilk enerji başlangıcı (sn); ilk ipucu bundan önce başlamaz.
    """
    cues: list[Cue] = []
    for p in parts:
        cues += part_cues(p)
    cues.sort(key=lambda c: c.start)
    if cues and lead > cues[0].start:
        c = cues[0]
        c.start = lead
        if c.words:
            c.words[0]["start"] = max(c.words[0]["start"], min(lead, c.words[0]["end"]))
    for k, c in enumerate(cues):
        end = c.end + CUE_TAIL
        if k + 1 < len(cues):
            end = min(end, cues[k + 1].start)
        c.end = max(end, c.start + 0.05)
    return cues


def merge_parts(items: list[tuple[str, Alignment, float]], gap: float) -> list[Part]:
    """Ardışık replikleri tek ses dosyasına birleştirirken hizalamaları kaydırır.

    items: (konuşmacı, hizalama, o öğenin ses süresi). Her öğeden sonra `gap` sn sessizlik eklenir
    (bolum_yardimci.grup ile aynı: apad=pad_dur=gap + concat).
    """
    out: list[Part] = []
    t0 = 0.0
    for speaker, al, dur in items:
        out.append(Part(speaker, al.shifted(t0)))
        t0 += dur + gap
    return out


def round_cue(c: Cue, nd: int = 3) -> dict:
    return {
        "start": round(c.start, nd), "end": round(c.end, nd), "speaker": c.speaker, "text": c.text,
        "words": [{"w": w["w"], "start": round(w["start"], nd), "end": round(w["end"], nd)} for w in c.words],
    }


# --- Kitaplık (H-066): cümle düzeyinde zamanlama ------------------------------------------------
# Bölüm altyazısı cümle *parçası* düzeyindedir (kısa parça birleşir). Kitapta okunan cümle vurgulanır:
# her cümle kendi aralığını alır. Ses metni (TTS girdisi) ile cümle listesi aynı sırada eşlenir;
# boşluklar ve tırnak biçimleri (’ ‘ “ ”) karşılaştırmaya girmez.

_QUOTES = str.maketrans({"’": "'", "‘": "'", "“": '"', "”": '"', "—": "-", "–": "-"})


class AlignmentMismatch(ValueError):
    """Hizalama metni kaynak metinle uyuşmuyor (metin TTS'ten sonra değişmiş)."""


def _fold(c: str) -> str:
    return c.translate(_QUOTES)


def locate(al: Alignment, texts: list[str]) -> list[list[int]]:
    """Her metnin hizalamadaki karakter indeksleri (boşluksuz karakterler sırayla eşlenir).

    Metinler hizalamada verilen sırayla geçmelidir; aralarında yalnızca boşluk ya da noktalama
    olabilir. Uyuşmazlıkta AlignmentMismatch.
    """
    pos = [i for i, c in enumerate(al.chars) if c.strip()]
    k = 0
    out: list[list[int]] = []
    for t in texts:
        want = [_fold(c) for c in t if c.strip()]
        if not want:
            out.append([])
            continue
        # Cümleler arasındaki fazladan noktalamayı (ör. başlıktan sonra eklenen ".") atla.
        while k < len(pos) and _fold(al.chars[pos[k]]) != want[0] and not al.chars[pos[k]].isalnum():
            k += 1
        got = [_fold(al.chars[pos[j]]) for j in range(k, min(k + len(want), len(pos)))]
        if got != want:
            near = "".join(al.chars[pos[j]] for j in range(k, min(k + 40, len(pos))))
            raise AlignmentMismatch(f"hizalama metinle uyuşmuyor: beklenen \"{t[:60]}\", seste \"{near}\"")
        first, last = pos[k], pos[k + len(want) - 1]
        out.append(list(range(first, last + 1)))
        k += len(want)
    return out


def span_words(al: Alignment, idx: list[int]) -> list[dict]:
    """Karakter aralığındaki kelimeler ve zamanları ({"w", "start", "end"}); boşlukla ayrılır."""
    return _words(al, idx)


def sentence_timings(al: Alignment, texts: list[str], nd: int = 3) -> list[dict]:
    """Cümle başına {"start", "end", "words": [{"w", "start", "end"}]} (sn, sesin başına göre)."""
    out = []
    for idx in locate(al, texts):
        if not idx:
            out.append({"start": None, "end": None, "words": []})
            continue
        words = span_words(al, idx)
        nz = [i for i in idx if al.chars[i].strip()]
        out.append({"start": round(al.starts[nz[0]], nd), "end": round(al.ends[nz[-1]], nd),
                    "words": [{"w": w["w"], "start": round(w["start"], nd), "end": round(w["end"], nd)}
                              for w in words]})
    return out


def concat_alignments(parts: list[tuple[Alignment, float]], gap: float, sep: str = " ") -> Alignment:
    """Parça parça üretilmiş sesin hizalamalarını tek dosyaya göre birleştirir.

    parts: (hizalama, o parçanın ses süresi). Her parçadan sonra `gap` sn sessizlik vardır
    (media.concat_audio ile aynı). Parçalar arasına zamanı sessizliğe düşen tek bir `sep` karakteri girer.
    """
    chars: list[str] = []
    starts: list[float] = []
    ends: list[float] = []
    t0 = 0.0
    for n, (al, dur) in enumerate(parts):
        if n:
            chars.append(sep)
            starts.append(t0 - gap)
            ends.append(t0)
        sh = al.shifted(t0)
        chars += sh.chars
        starts += sh.starts
        ends += sh.ends
        t0 += dur + gap
    return Alignment(chars, starts, ends)


def alignment_json(al: Alignment) -> dict:
    """ElevenLabs `alignment` biçimi (Alignment.load ile geri okunur)."""
    return {"characters": al.chars, "character_start_times_seconds": [round(s, 4) for s in al.starts],
            "character_end_times_seconds": [round(e, 4) for e in al.ends]}
