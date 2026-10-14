"""Kitap anlatım temposu (H-069): ücretli yeniden üretim olmadan seviye hızına inmek.

ElevenLabs `speed` A1 için yeterince düşmüyor (0.9'da ölçülen 144–168 k/dk; hedef 100–110). Dışa
aktarmada bölüm sesi cümle sınırlarından kesilir, cümleler arasına sessizlik eklenir ve gerekirse perde
korunarak yavaşlatılır (ffmpeg `atempo`, en az 0.85). Ayar: `book.json → narration.pacing`
(docs/KITAPLIK.md §6.5):

    {"mode": "auto" | "manual" | "off", "sentencePauseSec": 0.9, "tempo": 0.95}

- `off`     ses olduğu gibi.
- `manual`  `sentencePauseSec` (varsayılan 0.6) ve `tempo` (varsayılan 1.0) olduğu gibi uygulanır.
- `auto`    bölüm başına, seviye aralığının ORTASINA (A1: 105 k/dk) inecek değerler hesaplanır: önce
            duraklama (en çok 1,2 sn), yetmezse tempo (en az 0,85). Elle verilen değerler yok sayılır.
  Alan yoksa seviye varsayılanı: A1–B1 `auto`, B2+ `off` (book.BOOK_LEVELS[...]["pacing"]).

`sentencePauseSec`, iki cümle arasındaki **toplam** sessizliğin alt sınırıdır: kayıttaki doğal boşluk
(tempo sonrası) zaten uzunsa ekleme yapılmaz, kısaysa aradaki fark kadar sessizlik eklenir. Paragraf
sınırında ×1,25, sayfa sınırında ve bölüm başlığından sonra ×1,5.

Kesim noktası bir cümlenin son karakterinin bitişi ile sonrakinin ilk karakterinin başlangıcı arasındadır
(kelime içinden kesilmez); ses zarfı verilirse bu aralıktaki en sessiz 10 ms pencere seçilir. Hizalama
boşluğu gerçekte sessiz değilse (ElevenLabs hizalaması ~0,1 sn kayabiliyor) arama ±0,25 sn genişler
(`choose_cut`). Eklenen sessizliğin iki yanına kısa (≤ 8 ms) yumuşak geçiş konur. Zaman eşlemesi örnek
düzeyinde kesindir: her parça tempo sonrası tam `round(N / tempo)` örneğe doldurulur/kırpılır, ardından
tam sessizlik eklenir. Yeni zaman = t / tempo + (önceki eklenen sessizlikler); her cümlenin zamanı kendi
parçasına sıkıştırılır, vurgu hiçbir zaman eklenen duraklamaya düşmez. Hesap deterministiktir.
"""

from __future__ import annotations

import bisect
import math
from dataclasses import dataclass, field

from .book import BOOK_LEVELS

MODES = ("auto", "manual", "off")
SR = 44100
MANUAL_PAUSE = 0.6          # manual modda sentencePauseSec verilmezse
AUTO_MAX_PAUSE = 1.2        # auto: cümleler arası en uzun duraklama (sn)
MIN_TEMPO = 0.85            # atempo alt sınırı (daha yavaşı doğal duyulmuyor)
MAX_TEMPO = 1.25
FACTORS = {"sentence": 1.0, "paragraph": 1.25, "page": 1.5}
FADE_MAX = 0.008            # eklenen sessizliğin iki yanındaki yumuşak geçiş (sn, üst sınır)
WIN = 0.01                  # media.envelope penceresi (10 ms)
QUIET = 0.01                # kesim penceresi "sessiz": zarf ≤ en büyük değerin %1'i (-40 dB)
SLACK = 0.25                # hizalama boşluğu sessiz değilse aramanın iki yana genişlemesi (sn)


class PacingError(ValueError):
    pass


def settings(meta: dict, level: str) -> dict:
    """book.json → etkin ayar {"mode", "sentencePauseSec", "tempo"} (auto'da sayılar None)."""
    raw = dict(((meta.get("narration") or {}).get("pacing")) or {})
    mode = raw.get("mode") or BOOK_LEVELS.get(level, {}).get("pacing", "off")
    if mode not in MODES:
        raise PacingError(f"narration.pacing.mode bilinmiyor: {mode!r} ({', '.join(MODES)})")
    if mode == "manual":
        pause = float(raw.get("sentencePauseSec", MANUAL_PAUSE))
        tempo = float(raw.get("tempo", 1.0))
        if not MIN_TEMPO <= tempo <= MAX_TEMPO:
            raise PacingError(f"narration.pacing.tempo {tempo} aralık dışında ({MIN_TEMPO}–{MAX_TEMPO})")
        if pause < 0:
            raise PacingError("narration.pacing.sentencePauseSec negatif olamaz")
        return {"mode": mode, "sentencePauseSec": pause, "tempo": tempo}
    return {"mode": mode, "sentencePauseSec": None, "tempo": None}


def target_wpm(level: str) -> float | None:
    lv = BOOK_LEVELS.get(level)
    return (lv["wpm"][0] + lv["wpm"][1]) / 2.0 if lv else None


# --- ölçüm --------------------------------------------------------------------------------------

def spoken(timings: list[dict]) -> list[dict]:
    return [t for t in timings if t.get("start") is not None]


def wpm(timings: list[dict]) -> float | None:
    """Anlatım hızı: kelime sayısı / (ilk cümle başı → son cümle sonu). book-lint ile aynı tanım."""
    sp = spoken(timings)
    if not sp:
        return None
    dur = sp[-1]["end"] - sp[0]["start"]
    n = sum(len(t["words"]) for t in sp)
    return 60.0 * n / dur if dur > 0 else None


@dataclass
class Boundary:
    kind: str           # sentence | paragraph | page
    prev_end: float     # önceki cümlenin son karakterinin bitişi (sn, kaynak sesi)
    next_start: float   # sonraki cümlenin ilk karakterinin başlangıcı
    prev_start: float = 0.0
    next_end: float = 0.0

    @property
    def gap(self) -> float:
        return max(0.0, self.next_start - self.prev_end)


def boundaries(timings: list[dict], units: list[tuple[str, int]]) -> list[Boundary]:
    """Ardışık seslendirilen cümleler arasındaki sınırlar. `units`: timings ile aynı sırada (sayfa, paragraf);
    bölüm başlığı için ("", 0) → başlıktan sonraki sınır sayfa sınırı sayılır."""
    if len(units) != len(timings):
        raise PacingError("units ve timings uzunlukları farklı")
    pairs = [(t, u) for t, u in zip(timings, units) if t.get("start") is not None]
    out = []
    for (a, ua), (b, ub) in zip(pairs, pairs[1:]):
        kind = "page" if ua[0] != ub[0] else ("paragraph" if ua[1] != ub[1] else "sentence")
        if b["start"] < a["end"]:
            raise PacingError(f"cümleler üst üste biniyor: {a['end']} > {b['start']}")
        out.append(Boundary(kind, a["end"], b["start"], a["start"], b["end"]))
    return out


def inserted(b: Boundary, pause: float, tempo: float) -> float:
    """Sınıra eklenecek sessizlik (sn): toplam boşluk en az FACTORS[kind] × pause olsun."""
    return max(0.0, FACTORS[b.kind] * pause - b.gap / tempo)


def paced_span(span: float, bounds: list[Boundary], pause: float, tempo: float) -> float:
    return span / tempo + sum(inserted(b, pause, tempo) for b in bounds)


def auto_params(timings: list[dict], bounds: list[Boundary], target: float,
                max_pause: float = AUTO_MAX_PAUSE, min_tempo: float = MIN_TEMPO) -> tuple[float, float]:
    """Hedef hıza (k/dk) inmek için (duraklama, tempo). Önce duraklama [0, max_pause], sonra tempo
    [min_tempo, 1]. Hızlandırma yapılmaz: kayıt zaten yavaşsa (0, 1). Sonuç 0,01'e yuvarlanır."""
    sp = spoken(timings)
    if not sp or target <= 0:
        return 0.0, 1.0
    span = sp[-1]["end"] - sp[0]["start"]
    n = sum(len(t["words"]) for t in sp)
    want = 60.0 * n / target
    if span <= 0 or paced_span(span, bounds, 0.0, 1.0) >= want:
        return 0.0, 1.0
    if paced_span(span, bounds, max_pause, 1.0) >= want:
        lo, hi = 0.0, max_pause            # paced_span duraklamayla artar
        for _ in range(60):
            mid = (lo + hi) / 2
            lo, hi = (mid, hi) if paced_span(span, bounds, mid, 1.0) < want else (lo, mid)
        return round(hi, 2), 1.0
    if paced_span(span, bounds, max_pause, min_tempo) <= want:
        return max_pause, min_tempo
    lo, hi = min_tempo, 1.0                 # paced_span tempo büyüdükçe azalır
    for _ in range(60):
        mid = (lo + hi) / 2
        lo, hi = (mid, hi) if paced_span(span, bounds, max_pause, mid) >= want else (lo, mid)
    return max_pause, max(min_tempo, round(lo, 2))


# --- plan ---------------------------------------------------------------------------------------

@dataclass
class ChapterPacing:
    mode: str
    pause: float
    tempo: float
    total: int                                        # kaynak örnek sayısı
    cuts: list[int] = field(default_factory=list)     # kesim noktaları (örnek), artan
    pauses: list[int] = field(default_factory=list)   # her kesimde eklenen sessizlik (örnek)
    fades: list[int] = field(default_factory=list)    # her kesimin iki yanındaki geçiş (örnek)
    kinds: list[str] = field(default_factory=list)
    sr: int = SR

    @property
    def active(self) -> bool:
        return self.tempo != 1.0 or any(self.pauses)

    def segments(self) -> list[dict]:
        """Kaynak parçaları: {start, end (None = sona kadar), out (tempo sonrası örnek), pad, fadeIn, fadeOut}."""
        edges = [0] + self.cuts + [self.total]
        out = []
        for j in range(len(edges) - 1):
            a, b = edges[j], edges[j + 1]
            last = j == len(edges) - 2
            out.append({"start": a, "end": None if last else b, "out": self.out_len(b - a),
                        "pad": 0 if last else self.pauses[j],
                        "fadeIn": self.fades[j - 1] if j and self.pauses[j - 1] else 0,
                        "fadeOut": self.fades[j] if not last and self.pauses[j] else 0})
        return out

    def out_len(self, n: int) -> int:
        return n if self.tempo == 1.0 else int(round(n / self.tempo))

    def out_starts(self) -> list[int]:
        acc, out = 0, []
        for s in self.segments():
            out.append(acc)
            acc += s["out"] + s["pad"]
        return out

    @property
    def out_total(self) -> int:
        return sum(s["out"] + s["pad"] for s in self.segments())

    def map(self, t: float, seg: int | None = None) -> float:
        """Kaynak zamanı (sn) → işlenmiş ses zamanı (sn). `seg` verilirse zaman o parçanın içine sıkıştırılır
        (k. seslendirilen cümle k. parçadadır; hizalama kesimden birkaç ms taşsa da vurgu duraklamaya düşmez)."""
        segs, starts = self.segments(), self.out_starts()
        s = t * self.sr
        j = bisect.bisect_right(self.cuts, s) if seg is None else seg
        rel = min(max(0.0, (s - segs[j]["start"]) / self.tempo), float(segs[j]["out"]))
        return (starts[j] + rel) / self.sr

    def describe(self) -> dict:
        return {"mode": self.mode, "sentencePauseSec": self.pause, "tempo": self.tempo,
                "insertedSec": round(sum(self.pauses) / self.sr, 3)}


def _quietest(env: list[float], lo: float, hi: float, mid: float) -> int | None:
    i0 = math.ceil(lo / WIN - 1e-9)
    i1 = math.floor(hi / WIN + 1e-9) - 1
    cands = range(max(0, i0), min(len(env) - 1, i1) + 1)
    if not cands:
        return None
    return min(cands, key=lambda i: (round(env[i], 6), abs((i + 0.5) * WIN - mid), i))


def choose_cut(b: Boundary, env: list[float] | None) -> float:
    """Sınırdaki kesim anı (sn).

    1. Hizalama boşluğu [prev_end, next_start] içinde en sessiz 10 ms pencerenin ortası (eşitlikte ortaya
       en yakını). Zarf yoksa ya da aralık bir pencereden darsa orta nokta.
    2. O pencere sessiz değilse (zarf > en büyüğün %1'i): ElevenLabs hizalaması gerçek sessizlikten
       ~0,1 sn önce/sonra olabiliyor (A1-K01'de ölçüldü: "dear." sönümü hizalama boşluğuna taşıyor). Arama
       iki yana SLACK kadar, ama iki cümlenin ortalarını geçmeden genişletilir; en sessiz pencere seçilir.
    """
    mid = (b.prev_end + b.next_start) / 2
    if not env:
        return mid
    best = _quietest(env, b.prev_end, b.next_start, mid)
    peak = max(env) or 1.0
    if best is None or env[best] > QUIET * peak:
        lo = max(b.prev_end - SLACK, (b.prev_start + b.prev_end) / 2)
        hi = min(b.next_start + SLACK, (b.next_start + b.next_end) / 2)
        wide = _quietest(env, lo, hi, mid)
        if wide is not None and (best is None or env[wide] < env[best]):
            best = wide
    return mid if best is None else (best + 0.5) * WIN


def plan_chapter(timings: list[dict], units: list[tuple[str, int]], cfg: dict, level: str,
                 source_end: float, env: list[float] | None = None, sr: int = SR) -> ChapterPacing | None:
    """Bölüm planı. Mod `off` ise ya da yapılacak iş yoksa None."""
    if cfg["mode"] == "off" or not spoken(timings):
        return None
    bounds = boundaries(timings, units)
    if cfg["mode"] == "auto":
        pause, tempo = auto_params(timings, bounds, target_wpm(level) or 0.0)
    else:
        pause, tempo = cfg["sentencePauseSec"], cfg["tempo"]
    total = int(round(max(source_end, spoken(timings)[-1]["end"]) * sr))
    plan = ChapterPacing(cfg["mode"], pause, tempo, total, sr=sr)
    prev = 0
    for b in bounds:
        c = int(round(choose_cut(b, env) * sr))
        c = min(max(c, prev + 1, int(math.ceil((b.prev_start + b.prev_end) / 2 * sr))),
                int((b.next_start + b.next_end) / 2 * sr))
        plan.cuts.append(c)
        plan.pauses.append(int(round(inserted(b, pause, tempo) * sr)))
        plan.kinds.append(b.kind)
        prev = c
    edges = [0] + plan.cuts + [total]
    plan.fades = [max(0, min(int(FADE_MAX * sr), (edges[k + 1] - edges[k]) // 2, (edges[k + 2] - edges[k + 1]) // 2))
                  for k in range(len(plan.cuts))]
    return plan if plan.active else None



def apply(timings: list[dict], plan: ChapterPacing | None, nd: int = 3) -> list[dict]:
    """Cümle ve kelime zamanlarını işlenmiş sese taşır (plan None ise kopya)."""
    out = []
    k = 0                       # k. seslendirilen cümle → k. parça
    for t in timings:
        if plan is None or t.get("start") is None:
            out.append({**t, "words": [dict(w) for w in t.get("words", [])]})
            continue

        def m(x: float, j: int = k) -> float:
            return round(plan.map(x, j), nd)
        out.append({**t, "start": m(t["start"]), "end": m(t["end"]),
                    "words": [{**w, "start": m(w["start"]), "end": m(w["end"])} for w in t["words"]]})
        k += 1
    return out


def chapter_units(chapter) -> list[tuple[str, int]]:
    """book.Chapter → spoken() sırasıyla (sayfa, paragraf); başlık ("", 0)."""
    out = [("", 0)]
    for p in chapter.pages:
        out += [(p.id, s.paragraph) for s in p.sentences]
    return out
