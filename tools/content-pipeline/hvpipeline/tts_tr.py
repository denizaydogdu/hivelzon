"""Türkçe anlatım: PatientDesk Alania TTS + Duyu kelime zamanları (H-075, docs/DILBILGISI.md §6).

Akış (parça başına):
1. Alania (`POST /v1/audio/speech`, `alania-v2`, `alania2-f1`) → 48 kHz PCM16 mono WAV.
2. Duyu (`POST /v1/audio/transcriptions`, `duyu-1`, `verbose_json`, kelime zaman damgası) → kelime zamanları.
3. Duyu kelimeleri **özgün metne** eşlenir (normalleştirilmiş kelime dizisi üzerinde bulanık hizalama:
   noktalama, büyük/küçük harf ve Duyu'nun yanlış duyduğu kelimeler tolere edilir). Eşleşme zayıfsa
   uyarı verilir ve hizalama dosyasına `quality.ok = false` yazılır; sessizce yanlış zaman üretilmez.
4. Kelime zamanları karakterlere dağıtılır ve ElevenLabs `alignment` biçiminde yazılır
   (`characters / character_start_times_seconds / character_end_times_seconds`); `align.py` değişmeden okur.
5. Ses -16 LUFS'a getirilir (media.gain_to_target + media.gain_filter) ve kitaplardaki gibi
   mp3 44,1 kHz 128 kb/sn olarak yazılır. Zamanlar değişmez (kırpma yok).

Kurallar (CLAUDE.md):
- Varsayılan **kuru çalışma**: karakter ve tahmini TL yazılır, üretim çağrısı yapılmaz; gerçek çağrı `execute=True`.
  Ücret satırı için yalnız okuma yapan `GET /v1/usage` çağrılır (`billing_status`, H-108; 2 sn bağlantı / 5 sn okuma);
  `HIVELZON_TR_TTS_OFFLINE=1` ya da araçlarda `--offline` bunu da atlar ve "ücretli varsayıldı" yazar.
- **Aylık karakter tavanı** (`HIVELZON_TR_TTS_MONTHLY_CHAR_CAP` ya da `--monthly-char-cap`) tanımlı değilse
  gerçek çağrı reddedilir. Defter: `kitaplar/_maliyet/patientdesk-karakter.json` (değiştirilebilir).
- **İdempotent:** anahtar = metin + model + ses + üslup + söyleniş sha256'sı. Ödenmiş ham WAV ve Duyu
  sonucu `_raw/` önbelleğinde tutulur; güncel çıktı varsa hiçbir çağrı yapılmaz.
- 429'da `Retry-After` kadar beklenir (sınırlı deneme).
- **Anahtar** (`PD_API_KEY`) yalnız ortamdan ya da `~/.config/hivelzon/patientdesk.env`'den okunur (gerçek
  çağrıda ve kuru çalışmadaki ücret durumu okumasında); ekrana, loga ve dosyaya yazılmaz. `/v1/usage`
  yanıtındaki `user_id` de saklanmaz ve yazılmaz.
- Her gerçek çağrı verilen `PROMPTS.md` tablosuna yazılır (tarih, parça, model, ses, sürüm, karakter,
  ses süresi, istek kimliği, metin sha256).
"""

from __future__ import annotations

import io
import json
import math
import os
import re
import threading
import time
import unicodedata
import uuid
import wave
from array import array
from dataclasses import dataclass, field
from datetime import datetime, timezone
from difflib import SequenceMatcher
from pathlib import Path
from typing import Callable, Protocol

from . import REPO_ROOT
from .align import Alignment, alignment_json
from .book import text_sha256
from .ledgerlock import atomic_bytes, ledger_lock

API_BASE = "https://voice.patientdesk.ai"
ENV_KEY = "PD_API_KEY"
ENV_URL = "PD_API_URL"
KEY_FILE = Path.home() / ".config" / "hivelzon" / "patientdesk.env"
ENV_CAP = "HIVELZON_TR_TTS_MONTHLY_CHAR_CAP"
ENV_LEDGER = "HIVELZON_TR_TTS_LEDGER"
ENV_OFFLINE = "HIVELZON_TR_TTS_OFFLINE"   # 1: ücret durumu okunmaz (testler, CI, ağsız çalışma)
USAGE_PATH = "/v1/usage"
USAGE_CONNECT_TIMEOUT = 2.0
USAGE_READ_TIMEOUT = 5.0
USAGE_TOTAL_TIMEOUT = 8.0   # DNS ve yanıt gövdesi dahil üst sınır (H-112)
USAGE_MAX_BYTES = 65536
DEFAULT_LEDGER = REPO_ROOT / "kitaplar" / "_maliyet" / "patientdesk-karakter.json"
TTS_MODEL = "alania-v2"
VOICE = "alania2-f1"
STT_MODEL = "duyu-1"
LANGUAGE = "tr"
MAX_CHARS = 5000
MAX_INSTRUCTIONS = 200
TL_PER_1000_CHARS = 0.75        # Alania tarifesi; ücretsiz dönem bitti (14.11.2026), güncel durum: billing_status()
TL_PER_AUDIO_HOUR = 6.0         # Duyu dosya
EST_CHARS_PER_SEC = 14.0        # kuru çalışmada Duyu süresi tahmini (Türkçe anlatım)
MAX_RETRIES = 5
MAX_RETRY_WAIT = 60.0
RAW_DIR = "_raw"
# Hizalama kalitesi eşikleri
FUZZY_OK = 0.6                  # bulanık eşleşme benzerlik alt sınırı
MIN_QUALITY = 0.85              # iyi eşleşen kelime oranı
MAX_BAD_RUN = 2                 # art arda zayıf/eksik kelime sınırı (bu ve üstü uyarı)
DURATION_TOLERANCE = 0.5        # Duyu kelime sonu ses süresini en çok bu kadar aşabilir (sn; H-114)
GAP_SECONDS = 3.0               # Duyu kelimeleri arasında bu kadar boşluk: Duyu bir parçayı atlamış olabilir (H-105)
PROMPTS_HEADING = "## Türkçe seslendirme kayıtları (tts_tr.py)"
PROMPTS_TABLE = ("| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |\n"
                 "|---|---|---|---|---|---|---|---|---|")
_ID_RE = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_.-]*$")


class TrTtsError(RuntimeError):
    pass


class RateLimited(Exception):
    """HTTP 429. `retry_after` sn sonra yeniden denenir."""

    def __init__(self, retry_after: float):
        super().__init__(f"429 Retry-After {retry_after}")
        self.retry_after = retry_after


class Client(Protocol):
    def speech(self, payload: dict) -> tuple[bytes, dict]: ...

    def transcribe(self, wav: bytes, filename: str) -> tuple[dict, dict]: ...


# --- girdi ---------------------------------------------------------------------------------------

@dataclass
class Segment:
    id: str
    text: str
    instructions: str | None = None
    pronunciations: list[dict] | None = None


_PRON_SHAPE = '[{"term": metin, "say_as": metin}, …]'


def pron_problem(prons) -> str | None:
    """Söyleniş sözlüğü biçim hatası (yoksa None). Kural şemalardakiyle aynı (book/lesson/talk-task):
    liste; her öğe yalnız `term` ve `say_as` anahtarlı sözlük, ikisi de boş olmayan metin (H-118)."""
    if prons is None:
        return None
    if not isinstance(prons, list):
        return f"liste olmalı ({type(prons).__name__} verildi)"
    for k, q in enumerate(prons, 1):
        if not isinstance(q, dict):
            return f"{k}. öğe sözlük değil ({q!r})"
        extra = sorted(set(q) - {"term", "say_as"})
        if extra:
            return f"{k}. öğede bilinmeyen anahtar: {', '.join(map(str, extra))}"
        for f in ("term", "say_as"):
            if not isinstance(q.get(f), str) or not q[f]:
                return f"{k}. öğede `{f}` boş olmayan metin olmalı ({q.get(f)!r})"
    return None


def check_pronunciations(prons, where: str, exc: type[Exception] | None = None) -> list[dict]:
    """Söyleniş sözlüğünü denetler (ücretli çağrıdan önce; H-118). None → []. Bozuksa `exc` (varsayılan
    TrTtsError) açık Türkçe iletiyle; geçerliyse öğelerin kopyası döner."""
    problem = pron_problem(prons)
    if problem:
        raise (exc or TrTtsError)(f"{where}: pronunciations {_PRON_SHAPE} biçiminde olmalı: {problem}")
    return [dict(q) for q in prons or []]


def check_segments(segs: list[Segment], allow_empty: bool = False) -> list[Segment]:
    """Parça denetimi (kimlik, metin, instructions, pronunciations, uzunluk). `tts_tr.py` girdisi ve
    kitap/ders/bölüm araçlarının kurduğu parçalar aynı denetimden geçer (H-118)."""
    if not segs and allow_empty:
        return segs
    return _check_segments(segs)


def _check_segments(segs: list[Segment]) -> list[Segment]:
    seen: set[str] = set()
    for s in segs:
        if not _ID_RE.match(s.id):
            raise TrTtsError(f"geçersiz parça kimliği: {s.id!r} (harf, rakam, _ . -)")
        if s.id in seen:
            raise TrTtsError(f"parça kimliği tekrar ediyor: {s.id}")
        seen.add(s.id)
        if not s.text.strip():
            raise TrTtsError(f"{s.id}: metin boş")
        if s.instructions is not None and not isinstance(s.instructions, str):
            raise TrTtsError(f"{s.id}: instructions metin olmalı ({type(s.instructions).__name__} verildi)")
        check_pronunciations(s.pronunciations, s.id)
        if spoken_text(s.text).lstrip().startswith(("(", "[")):
            raise TrTtsError(f"{s.id}: metin parantezle başlıyor ve açılamadı (kapanmayan/iç içe); Alania baştaki "
                             f"parantezi yönerge sayar, metni düzelt: {s.text!r}")
        if not norm(spoken_text(s.text)):
            raise TrTtsError(f"{s.id}: okunacak metin yok (Alania'ya giden: {spoken_text(s.text)!r})")
        if len(s.text) > MAX_CHARS:
            raise TrTtsError(f"{s.id}: {len(s.text)} karakter (istek sınırı {MAX_CHARS}); parçayı böl")
        if s.instructions and len(s.instructions) > MAX_INSTRUCTIONS:
            raise TrTtsError(f"{s.id}: instructions {len(s.instructions)} karakter (sınır {MAX_INSTRUCTIONS})")
    if not segs:
        raise TrTtsError("parça yok")
    return segs


def load_segments(path: Path) -> list[Segment]:
    """JSON (`[{"id","text",...}]` ya da `{"instructions"?, "segments": [...]}`) veya Markdown
    (`## <kimlik>` başlığı + altındaki metin; `<!-- -->` yorumları atlanır)."""
    raw = Path(path).read_text(encoding="utf-8")
    if Path(path).suffix.lower() == ".json":
        doc = json.loads(raw)
        default_ins = None
        if isinstance(doc, dict):
            default_ins = doc.get("instructions")
            doc = doc.get("segments", [])
        if not isinstance(doc, list) or not all(isinstance(d, dict) and isinstance(d.get("id"), (str, int))
                                               and not isinstance(d.get("id"), bool)
                                               and isinstance(d.get("text"), str) for d in doc):
            raise TrTtsError(f"{path}: parça listesi [{{\"id\", \"text\", …}}, …] biçiminde olmalı")
        segs = [Segment(str(d["id"]), str(d["text"]).strip(), d.get("instructions", default_ins),
                        d.get("pronunciations")) for d in doc]
        return _check_segments(segs)
    raw = re.sub(r"<!--.*?-->", "", raw, flags=re.S)
    segs: list[Segment] = []
    cur_id: str | None = None
    buf: list[str] = []

    def flush():
        if cur_id is not None:
            paras = [" ".join(p.split()) for p in "\n".join(buf).split("\n\n")]
            segs.append(Segment(cur_id, "\n\n".join(p for p in paras if p)))
    for line in raw.splitlines():
        m = re.match(r"^##\s+(\S+)\s*$", line)
        if m:
            flush()
            cur_id, buf = m.group(1), []
        elif cur_id is not None:
            buf.append(line)
    flush()
    return _check_segments(segs)


# --- normalleştirme ve hizalama ------------------------------------------------------------------

_WORD_RE = re.compile(r"[^\W_]+(?:['’][^\W_]+)*", re.UNICODE)
_FOLD = str.maketrans({"ı": "i", "ş": "s", "ğ": "g", "ç": "c", "ö": "o", "ü": "u", "â": "a", "î": "i", "û": "u"})


def tr_lower(s: str) -> str:
    return s.replace("I", "ı").replace("İ", "i").lower()


_ONES = ["", "bir", "iki", "üç", "dört", "beş", "altı", "yedi", "sekiz", "dokuz"]
_TENS = ["", "on", "yirmi", "otuz", "kırk", "elli", "altmış", "yetmiş", "seksen", "doksan"]


def number_tr(n: int) -> str:
    """Sayıyı Türkçe yazıya çevirir (0–999 999; boşluksuz, karşılaştırma için). H-083: Duyu "yedi"yi
    "7" diye yazabilir; metindeki "3'te" de "üçte" diye duyulur."""
    if n == 0:
        return "sıfır"
    if n >= 1_000_000:
        return str(n)
    out = ""
    th, n = divmod(n, 1000)
    if th:
        out += ("" if th == 1 else number_tr(th)) + "bin"
    h, n = divmod(n, 100)
    if h:
        out += ("" if h == 1 else _ONES[h]) + "yüz"
    t, o = divmod(n, 10)
    return out + _TENS[t] + _ONES[o]


def norm(w: str) -> str:
    """Karşılaştırma biçimi: Türkçe küçük harf, noktalama ve kesme işareti yok; rakamlar yazıyla."""
    w = unicodedata.normalize("NFC", tr_lower(w))
    w = "".join(c for c in w if c.isalnum())
    return re.sub(r"\d+", lambda m: number_tr(int(m.group(0))), w) if any(c.isdigit() for c in w) else w


def fold(w: str) -> str:
    """Bulanık karşılaştırma: Türkçe harfler ASCII'ye katlanır (ı/i, ş/s …)."""
    return norm(w).translate(_FOLD)


def sim(a: str, b: str) -> float:
    if a == b:
        return 1.0
    fa, fb = fold(a), fold(b)
    if not fa or not fb:
        return 0.0
    if fa == fb:
        return 0.95
    return SequenceMatcher(None, fa, fb).ratio()


@dataclass
class Token:
    text: str
    start: int      # karakter indeksi (dahil)
    end: int        # karakter indeksi (hariç)


def tokenize(text: str) -> list[Token]:
    return [Token(m.group(0), m.start(), m.end()) for m in _WORD_RE.finditer(text)]


@dataclass
class WordTime:
    token: Token
    start: float
    end: float
    status: str             # exact | fuzzy | weak | missing
    heard: str | None = None
    score: float = 0.0


_GAP = -0.45
_PAIR_BIAS = -0.30


# Geri izleme adım kodları (`_dp_align`): 0 = yok; 1 = 1:1, 2 = 2:1, 3 = 1:2, 4 = özgün atla, 5 = Duyu atla.
_STEPS = ((0, 0), (1, 1), (2, 1), (1, 2), (1, 0), (0, 1))


def _dp_align(orig: list[str], heard: list[str]) -> list[tuple[list[int], list[int], float]]:
    """Dizi hizalama (Needleman–Wunsch türevi). Adımlar: 1:1, 2:1, 1:2, özgün atla, Duyu atla.
    Dönüş: (özgün indeksleri, Duyu indeksleri, benzerlik) grupları, sırayla.

    H-118: sonuç önceki sürümle birebir aynıdır (adım sırası, `>` eşitlik kuralı ve kayan nokta işlemleri
    korunur); yalnız maliyet düştü:
    - `fold()` her kelime ve komşu çift için bir kez hesaplanır (önceden hücre başına 6 kez);
    - `SequenceMatcher` oranı aynı (fa, fb) çifti için bir kez hesaplanır (1:1 için yoğun `array` tablosu);
    - 2:1 ve 1:2 adımları benzerlik `FUZZY_OK` altındaysa zaten seçilemez (kazanç -inf); bu durum önce
      `real_quick_ratio()`/`quick_ratio()` üst sınırıyla elenir (`ratio() ≤ quick_ratio() ≤ real_quick_ratio()`);
    - geri izleme satır başına `bytearray` adım kodu + `array('d')` benzerlik; `best` yalnız canlı 3 satır."""
    n, m = len(orig), len(heard)
    NEG = float("-inf")
    fo = [fold(w) for w in orig]
    fh = [fold(w) for w in heard]
    o2 = [orig[i] + orig[i + 1] for i in range(n - 1)]
    h2 = [heard[j] + heard[j + 1] for j in range(m - 1)]
    fo2 = [fold(w) for w in o2]
    fh2 = [fold(w) for w in h2]
    ratios: dict[tuple[str, str], float] = {}   # 2:1 / 1:2 çiftleri (azdır: çoğu uzunluk sınırında elenir)
    # 1:1 oranları: benzersiz katlanmış kelime kimlikleri üzerinden yoğun tablo (-1 = henüz hesaplanmadı).
    uo: dict[str, int] = {}
    uh: dict[str, int] = {}
    io = [uo.setdefault(w, len(uo)) for w in fo]
    ih = [uh.setdefault(w, len(uh)) for w in fh]
    nuh = len(uh)
    table = array("d", [-1.0]) * (len(uo) * nuh)

    def sim_1(i: int, j: int) -> float:                     # = sim(orig[i], heard[j])
        if orig[i] == heard[j]:
            return 1.0
        fa, fb = fo[i], fh[j]
        if not fa or not fb:
            return 0.0
        if fa == fb:
            return 0.95
        k = io[i] * nuh + ih[j]
        r = table[k]
        if r < 0.0:
            r = table[k] = SequenceMatcher(None, fa, fb).ratio()
        return r

    def sim_gate(a: str, b: str, fa: str, fb: str) -> float | None:   # sim(a, b) ≥ FUZZY_OK ise değeri, yoksa None
        if a == b:
            return 1.0
        if not fa or not fb:
            return None
        if fa == fb:
            return 0.95 if 0.95 >= FUZZY_OK else None
        r = ratios.get((fa, fb))
        if r is None:
            la, lb = len(fa), len(fb)
            if 2.0 * min(la, lb) / (la + lb) < FUZZY_OK:        # real_quick_ratio (ratio için üst sınır)
                return None
            sm = SequenceMatcher(None, fa, fb)
            if sm.quick_ratio() < FUZZY_OK:
                return None
            r = ratios[(fa, fb)] = sm.ratio()
        return r if r >= FUZZY_OK else None

    best: dict[int, list[float]] = {0: [NEG] * (m + 1)}
    best[0][0] = 0.0
    codes = [bytearray(m + 1) for _ in range(n + 1)]
    sims = [array("d", [0.0]) * (m + 1) for _ in range(n + 1)]

    def row(k: int) -> list[float]:
        r = best.get(k)
        if r is None:
            r = best[k] = [NEG] * (m + 1)
        return r

    for i in range(n + 1):
        b0 = row(i)
        b1 = row(i + 1) if i < n else None
        b2 = row(i + 2) if i + 1 < n else None
        c0, s0 = codes[i], sims[i]
        if b1 is not None:
            c1, s1 = codes[i + 1], sims[i + 1]
        if b2 is not None:
            c2, s2 = codes[i + 2], sims[i + 2]
        a, fa = (orig[i], fo[i]) if i < n else ("", "")
        if i + 1 < n:
            a2, fa2 = o2[i], fo2[i]
        for j in range(m + 1):
            cur = b0[j]
            if cur == NEG:
                continue
            # Adım sırası önceki sürümle aynı: 1:1, 2:1, 1:2, özgün atla, Duyu atla (eşitlikte ilk gelen kalır).
            if i < n and j < m:
                s = sim_1(i, j)
                v = cur + (s + _PAIR_BIAS)
                if v > b1[j + 1]:
                    b1[j + 1] = v
                    c1[j + 1] = 1
                    s1[j + 1] = s
            if i + 1 < n and j < m:
                s = sim_gate(a2, heard[j], fa2, fh[j])
                if s is not None:
                    v = cur + (s + 2 * _PAIR_BIAS - 0.05)   # önceki ifadeyle aynı sıra (kayan nokta)
                    if v > b2[j + 1]:
                        b2[j + 1] = v
                        c2[j + 1] = 2
                        s2[j + 1] = s
            if i < n and j + 1 < m:
                s = sim_gate(a, h2[j], fa, fh2[j])
                if s is not None:
                    v = cur + (s + 2 * _PAIR_BIAS - 0.05)   # önceki ifadeyle aynı sıra (kayan nokta)
                    if v > b1[j + 2]:
                        b1[j + 2] = v
                        c1[j + 2] = 3
                        s1[j + 2] = s
            if i < n:
                v = cur + _GAP
                if v > b1[j]:
                    b1[j] = v
                    c1[j] = 4
                    s1[j] = 0.0
            if j < m:
                v = cur + _GAP
                if v > b0[j + 1]:
                    b0[j + 1] = v
                    c0[j + 1] = 5
                    s0[j + 1] = 0.0
        del best[i]
    out = []
    i, j = n, m
    while (i, j) != (0, 0):
        di, dj = _STEPS[codes[i][j]]
        pi, pj = i - di, j - dj
        out.append((list(range(pi, i)), list(range(pj, j)), sims[i][j]))
        i, j = pi, pj
    out.reverse()
    return out


@dataclass
class Quality:
    words: int
    exact: int
    fuzzy: int
    weak: int
    missing: int
    extra_heard: int
    worst_run: int
    score: float
    ok: bool
    warnings: list[str] = field(default_factory=list)

    def as_json(self) -> dict:
        return {"words": self.words, "exact": self.exact, "fuzzy": self.fuzzy, "weak": self.weak,
                "missing": self.missing, "extraHeard": self.extra_heard, "worstRun": self.worst_run,
                "score": round(self.score, 3), "ok": self.ok, "warnings": self.warnings}


def _time_ok(w: dict, duration: float | None = None) -> bool:
    """Duyu kelime zamanı kullanılabilir mi: sonlu sayılar, 0 ≤ start ≤ end ve (süre biliniyorsa)
    end ≤ süre + DURATION_TOLERANCE (H-114). Geçersiz kelime duyulmamış sayılır."""
    try:
        st, en = w.get("start"), w.get("end")
        if isinstance(st, bool) or isinstance(en, bool) or not isinstance(st, (int, float)) \
                or not isinstance(en, (int, float)):
            return False
        st, en = float(st), float(en)
    except (AttributeError, TypeError, ValueError, OverflowError):
        return False
    if not (math.isfinite(st) and math.isfinite(en)) or st < 0 or en < st:
        return False
    return duration is None or en <= duration + DURATION_TOLERANCE


def _word_ok(w, duration: float | None = None) -> bool:
    """Duyu kelime girdisi kullanılabilir mi: sözlük, `word` metin ve zamanı geçerli (`_time_ok`; H-114)."""
    return isinstance(w, dict) and isinstance(w.get("word"), str) and _time_ok(w, duration)


def map_words(text: str, duyu_words: list[dict], duration: float | None = None) -> tuple[list[WordTime], Quality]:
    """Duyu kelimelerini özgün metnin kelimelerine eşler. Eksik kelimelere komşu zamanlar arasında
    karakter uzunluğuna göre zaman verilir ve kalite düşürülür. Zamanı geçersiz Duyu kelimeleri
    (`_time_ok`) atlanır: karşılık gelen özgün kelime "missing" olur ve uyarı yazılır (H-114)."""
    toks = tokenize(text)
    # Bozuk girdi (sözlük değil, `word` metin değil, zaman geçersiz) duyulmamış sayılır ve uyarı verilir;
    # yalnız noktalamadan oluşan geçerli kelime eskisi gibi sessizce atlanır.
    bad_time = [w for w in duyu_words if not _word_ok(w, duration)]
    heard_raw = [w for w in duyu_words if _word_ok(w, duration) and norm(w["word"])]
    heard = [norm(str(w["word"])) for w in heard_raw]
    groups = _dp_align([norm(t.text) for t in toks], heard)
    times: list[WordTime | None] = [None] * len(toks)
    extra = 0
    for oi, hj, s in groups:
        if not oi:
            extra += len(hj)
            continue
        if not hj:
            continue
        st, en = float(heard_raw[hj[0]]["start"]), float(heard_raw[hj[-1]]["end"])
        heard_txt = " ".join(str(heard_raw[k]["word"]) for k in hj)
        status = "exact" if s >= 0.999 else "fuzzy" if s >= FUZZY_OK else "weak"
        if len(oi) == 1:
            times[oi[0]] = WordTime(toks[oi[0]], st, en, status, heard_txt, s)
        else:   # iki özgün kelime tek Duyu kelimesine: süre karakter uzunluğuna göre bölünür
            total = sum(len(toks[k].text) for k in oi)
            t = st
            for k in oi:
                d = (en - st) * len(toks[k].text) / total
                times[k] = WordTime(toks[k], t, t + d, status, heard_txt, s)
                t += d
    # eksikler: komşu zamanlar arasında dağıt
    k = 0
    while k < len(toks):
        if times[k] is not None:
            k += 1
            continue
        r = k
        while r < len(toks) and times[r] is None:
            r += 1
        lo = times[k - 1].end if k > 0 else 0.0
        hi = times[r].start if r < len(toks) else (duration if duration is not None else lo)
        if r == len(toks) and k > 0 and duration is None:
            hi = lo
        hi = max(hi, lo)
        total = sum(len(toks[q].text) for q in range(k, r))
        t = lo
        for q in range(k, r):
            d = (hi - lo) * len(toks[q].text) / total
            times[q] = WordTime(toks[q], t, t + d, "missing", None, 0.0)
            t += d
        k = r
    words: list[WordTime] = [w for w in times if w is not None]
    # monotonluk (Duyu zamanları çakışırsa)
    for a, b in zip(words, words[1:]):
        if b.start < a.end:
            b.start = a.end
        if b.end < b.start:
            b.end = b.start
    counts = {s: sum(1 for w in words if w.status == s) for s in ("exact", "fuzzy", "weak", "missing")}
    run = worst = 0
    for w in words:
        run = run + 1 if w.status in ("weak", "missing") else 0
        worst = max(worst, run)
    n = len(words) or 1
    score = (counts["exact"] + counts["fuzzy"]) / n
    warnings = []
    if bad_time:
        warnings.append(f"Duyu'nun {len(bad_time)} kelimesi geçersiz (zaman ya da biçim), atlandı: "
                        + ", ".join(str(w.get("word") if isinstance(w, dict) else w) for w in bad_time[:8]))
    if score < MIN_QUALITY:
        warnings.append(f"iyi eşleşen kelime oranı düşük: %{score * 100:.0f} (alt sınır %{MIN_QUALITY * 100:.0f})")
    if worst >= MAX_BAD_RUN:
        warnings.append(f"art arda {worst} kelime zayıf ya da eksik eşleşti")
    if extra > max(2, 0.2 * len(toks)):
        warnings.append(f"Duyu metinde olmayan {extra} kelime duydu")
    bad = [f"{w.token.text}→{w.heard or '∅'}" for w in words if w.status in ("weak", "missing")]
    if bad and warnings:
        warnings.append("zayıf/eksik: " + ", ".join(bad[:8]))
    q = Quality(len(words), counts["exact"], counts["fuzzy"], counts["weak"], counts["missing"], extra, worst,
                score, not warnings, warnings)
    return words, q


def char_alignment(text: str, words: list[WordTime]) -> Alignment:
    """Kelime zamanlarını karakterlere dağıtır. Kelime harfleri kelimenin aralığını eşit paylaşır.
    Kelimeler arasındaki boşluklar aradaki sessizliği paylaşır; boşluktan önceki noktalama önceki
    kelimenin sonunda, boşluktan sonraki noktalama sonraki kelimenin başında (sıfır süre) durur."""
    nchar = len(text)
    starts = [0.0] * nchar
    ends = [0.0] * nchar
    for w in words:
        L = w.token.end - w.token.start
        d = (w.end - w.start) / L if L else 0.0
        for k in range(L):
            starts[w.token.start + k] = w.start + k * d
            ends[w.token.start + k] = w.start + (k + 1) * d
    bounds = [(0, words[0].token.start if words else nchar, None, words[0].start if words else 0.0)]
    for a, b in zip(words, words[1:]):
        bounds.append((a.token.end, b.token.start, a.end, b.start))
    if words:
        last = words[-1]
        bounds.append((last.token.end, nchar, last.end, None))
    for lo, hi, t_prev, t_next in bounds:
        if lo >= hi:
            continue
        idx = list(range(lo, hi))
        ws = [k for k in idx if text[k].isspace()]
        g0 = t_prev if t_prev is not None else t_next
        g1 = t_next if t_next is not None else t_prev
        if g0 is None:
            g0 = g1 = 0.0
        g1 = max(g1, g0)
        if ws:
            for k in idx:
                if k < ws[0]:
                    starts[k] = ends[k] = g0
                elif k > ws[-1]:
                    starts[k] = ends[k] = g1
            span = ws[-1] - ws[0] + 1
            d = (g1 - g0) / span
            for n_, k in enumerate(range(ws[0], ws[-1] + 1)):
                starts[k], ends[k] = g0 + n_ * d, g0 + (n_ + 1) * d
        else:
            d = (g1 - g0) / len(idx)
            for n_, k in enumerate(idx):
                starts[k], ends[k] = g0 + n_ * d, g0 + (n_ + 1) * d
    return Alignment(list(text), starts, ends)


# --- tavan, defter, kayıt ------------------------------------------------------------------------

def monthly_cap(cli_value: int | None = None) -> int | None:
    if cli_value is not None:
        return cli_value if cli_value > 0 else None
    raw = os.environ.get(ENV_CAP, "").strip()
    if not raw:
        return None
    try:
        v = int(raw.replace("_", "").replace(".", ""))
    except ValueError:
        raise TrTtsError(f"{ENV_CAP} tam sayı olmalı")
    return v if v > 0 else None


def ledger_path(cli_value: str | None = None) -> Path:
    return Path(cli_value or os.environ.get(ENV_LEDGER) or DEFAULT_LEDGER)


def month_key(now: datetime | None = None) -> str:
    return (now or datetime.now(timezone.utc)).strftime("%Y-%m")


def ledger_used(path: Path, month: str) -> int:
    if not path.exists():
        return 0
    return int(json.loads(path.read_text(encoding="utf-8")).get(month, {}).get("characters", 0))


def ledger_add(path: Path, month: str, chars: int = 0, stt_seconds: float = 0.0) -> None:
    """Okuma-değiştirme-yazma defter kilidi altında (H-114): eşzamanlı çalıştırma güncelleme kaybettirmez."""
    with ledger_lock(path):
        d = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}
        m = d.setdefault(month, {})
        for k in ("characters", "calls", "duyuSeconds", "duyuCalls"):
            m.setdefault(k, 0)
        if chars:
            m["characters"] += chars
            m["calls"] += 1
        if stt_seconds:
            m["duyuSeconds"] = round(m["duyuSeconds"] + stt_seconds, 3)
            m["duyuCalls"] += 1
        _atomic_bytes(path, (json.dumps(d, ensure_ascii=False, indent=2) + "\n").encode("utf-8"))


def append_prompts(path: Path, row: dict) -> None:
    with ledger_lock(path):     # H-114: eşzamanlı çalıştırmalar satır kaybettirmez
        text = path.read_text(encoding="utf-8") if path.exists() else "# PROMPTS\n"
        if PROMPTS_HEADING not in text:
            text = text.rstrip("\n") + f"\n\n{PROMPTS_HEADING}\n\n{PROMPTS_TABLE}\n"
        text = text if text.endswith("\n") else text + "\n"
        line = (f"| {row['date']} | {row['segment']} | {row['model']} | {row['voice']} | {row['release']} | "
                f"{row['chars']} | {row['seconds']} | {row['request_id']} | {row['sha'][:16]} |\n")
        _atomic_bytes(path, (text + line).encode("utf-8"))


def _atomic_bytes(path: Path, data: bytes) -> None:
    atomic_bytes(path, data)     # benzersiz geçici dosya (H-114)


def estimate_tl(chars: int, stt_seconds: float) -> float:
    return chars / 1000 * TL_PER_1000_CHARS + stt_seconds / 3600 * TL_PER_AUDIO_HOUR


# --- API -----------------------------------------------------------------------------------------

def _read_env_file(path: Path) -> dict:
    out = {}
    if not path.exists():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        k = k.strip().removeprefix("export ").strip()
        out[k] = v.strip().strip("'\"")
    return out


def load_credentials(key_file: Path | None = None) -> tuple[str, str]:
    """(anahtar, taban URL). Önce ortam, sonra repo dışındaki dosya. Anahtar hiçbir yere yazılmaz."""
    f = _read_env_file(key_file or KEY_FILE)
    key = os.environ.get(ENV_KEY) or f.get(ENV_KEY)
    if not key:
        raise TrTtsError(f"{ENV_KEY} tanımlı değil (ortam ya da {key_file or KEY_FILE}; anahtar repo dışında tutulur)")
    base = (os.environ.get(ENV_URL) or f.get(ENV_URL) or API_BASE).rstrip("/")
    if not base.startswith("https://"):
        raise TrTtsError(f"{ENV_URL} https olmalı")
    return key, base


def _headers_dict(h) -> dict:
    return {k.lower(): v for k, v in h.items()}


class HttpClient:
    """Gerçek PatientDesk istemcisi (urllib). 429 → RateLimited; diğer hatalar → TrTtsError (gövde
    kısaltılır, anahtar içermez)."""

    def __init__(self, key_file: Path | None = None, timeout: float = 180.0):
        self._key, self.base = load_credentials(key_file)
        self.timeout = timeout

    def _do(self, req):
        import urllib.error
        import urllib.request
        try:
            with urllib.request.urlopen(req, timeout=self.timeout) as r:
                return r.read(), _headers_dict(r.headers)
        except urllib.error.HTTPError as e:
            if e.code == 429:
                ra = e.headers.get("Retry-After", "1")
                try:
                    wait = float(ra)
                except ValueError:
                    wait = 5.0
                raise RateLimited(wait) from None
            body = e.read().decode("utf-8", errors="replace")[:300].replace(self._key, "***")
            raise TrTtsError(f"PatientDesk HTTP {e.code}: {body}") from None

    def speech(self, payload: dict) -> tuple[bytes, dict]:
        import urllib.request
        req = urllib.request.Request(f"{self.base}/v1/audio/speech", data=json.dumps(payload).encode("utf-8"),
                                     method="POST", headers={"Authorization": f"Bearer {self._key}",
                                                             "Content-Type": "application/json"})
        return self._do(req)

    def transcribe(self, wav: bytes, filename: str) -> tuple[dict, dict]:
        import urllib.request
        boundary = "hv" + uuid.uuid4().hex
        buf = io.BytesIO()
        for k, v in [("model", STT_MODEL), ("response_format", "verbose_json"),
                     ("timestamp_granularities[]", "word")]:
            buf.write(f"--{boundary}\r\nContent-Disposition: form-data; name=\"{k}\"\r\n\r\n{v}\r\n".encode())
        buf.write(f"--{boundary}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"{filename}\"\r\n"
                  f"Content-Type: audio/wav\r\n\r\n".encode())
        buf.write(wav)
        buf.write(f"\r\n--{boundary}--\r\n".encode())
        req = urllib.request.Request(f"{self.base}/v1/audio/transcriptions", data=buf.getvalue(), method="POST",
                                     headers={"Authorization": f"Bearer {self._key}",
                                              "Content-Type": f"multipart/form-data; boundary={boundary}"})
        body, h = self._do(req)
        return json.loads(body), h


# --- ücret durumu (H-108) ------------------------------------------------------------------------
# PatientDesk `GET /v1/usage` (Bearer anahtar) → {"user_id", "used_seconds", "quota_seconds",
# "remaining_seconds", "free", "free_until"}. `used/remaining_seconds` Duyu saniyeleridir; Alania karakter
# ücreti burada görünmez. Ücretsiz kampanya 14.11.2026'da bitti; yanıt bunu `free: false` ile söyler.

@dataclass(frozen=True)
class BillingStatus:
    """Okunan ücret durumu. `known=False` ise `reason` nedenini söyler ve ücretli varsayılır.
    `fetched`: ağ isteği denendi mi. `user_id` ve anahtar bilerek tutulmaz."""
    known: bool
    fetched: bool = False
    free: bool | None = None
    free_until: datetime | None = None
    remaining_seconds: float | None = None
    quota_seconds: float | None = None
    reason: str | None = None

    def is_free(self, now: datetime | None = None) -> bool:
        if not self.known or self.free is not True:
            return False
        return self.free_until is None or (now or datetime.now(timezone.utc)) < self.free_until


def _unknown(reason: str, fetched: bool) -> BillingStatus:
    return BillingStatus(known=False, fetched=fetched, reason=reason)


NO_TR_WORK = "Türkçe iş yok"


def work_needed(chars: int, stt_seconds: float) -> bool:
    """Ücretli Türkçe iş var mı: Alania karakteri ya da Duyu hizalaması (ses saatiyle ücretli)."""
    return chars > 0 or stt_seconds > 0


def _with_deadline(fn: Callable, args: tuple, seconds: float):
    """`fn(*args)` en çok `seconds` bekler. Soket süreleri DNS çözümlemesini ve gövdenin tamamını
    kapsamadığı için genel sınır ayrı bir iş parçacığıyla konur; süre aşılırsa iş parçacığı arka planda
    (daemon) biter, sonucu kullanılmaz."""
    box: dict = {}

    def run():
        try:
            box["v"] = fn(*args)
        except BaseException as e:  # noqa: BLE001 — çağırana aynen iletilir
            box["e"] = e

    t = threading.Thread(target=run, name="pd-usage", daemon=True)
    t.start()
    t.join(seconds)
    if t.is_alive():
        raise TimeoutError("toplam süre aşıldı")
    if "e" in box:
        raise box["e"]
    return box["v"]


def _http_get(url: str, headers: dict, connect_timeout: float, read_timeout: float) -> tuple[int, bytes]:
    """Yalnız https, yönlendirme izlenmez (anahtar başka adrese gitmez). Bağlantı ve okuma süreleri ayrı."""
    import http.client
    from urllib.parse import urlsplit
    u = urlsplit(url)
    if u.scheme != "https" or not u.hostname:
        raise ValueError("https olmayan adres")
    conn = http.client.HTTPSConnection(u.hostname, u.port or 443, timeout=connect_timeout)
    try:
        conn.connect()
        conn.sock.settimeout(read_timeout)
        conn.request("GET", u.path + (f"?{u.query}" if u.query else ""), headers=headers)
        r = conn.getresponse()
        return r.status, r.read(USAGE_MAX_BYTES)
    finally:
        conn.close()


def _num(v) -> float | None:
    if v is None:
        return None
    if isinstance(v, bool) or not isinstance(v, (int, float)):
        raise ValueError("sayı değil")
    f = float(v)
    if not math.isfinite(f) or f < 0:
        raise ValueError("geçersiz sayı")
    return f


def _parse_usage(raw: bytes) -> BillingStatus:
    try:
        d = json.loads(raw)
        if not isinstance(d, dict) or not isinstance(d.get("free"), bool):
            raise ValueError("free alanı yok")
        until = d.get("free_until")
        if until is not None:
            if not isinstance(until, str):
                raise ValueError("free_until metin değil")
            until = datetime.fromisoformat(until.replace("Z", "+00:00"))
            if until.tzinfo is None:
                until = until.replace(tzinfo=timezone.utc)
        return BillingStatus(known=True, fetched=True, free=d["free"], free_until=until,
                             remaining_seconds=_num(d.get("remaining_seconds")),
                             quota_seconds=_num(d.get("quota_seconds")))
    except Exception:  # noqa: BLE001 — bozuk/aşırı iç içe JSON vb.; "hiç fırlatmaz" sözleşmesi
        return _unknown("geçersiz yanıt", True)


def offline_requested(flag: bool | None = None) -> bool:
    if flag:
        return True
    return os.environ.get(ENV_OFFLINE, "").strip().lower() in ("1", "true", "yes", "evet")


def billing_status(fetch: Callable[[str, dict, float, float], tuple[int, bytes]] | None = None,
                   key_file: Path | None = None, offline: bool | None = None, needed: bool = True,
                   total_timeout: float = USAGE_TOTAL_TIMEOUT) -> BillingStatus:
    """PatientDesk ücret durumunu okur (yalnız okuma; üretim çağrısı değil). Hiçbir zaman istisna fırlatmaz;
    sorun olursa nedeniyle `known=False` döner. Anahtar ve `user_id` hiçbir çıktıya girmez.
    `needed=False` (ücretli Türkçe iş yok, bkz. `work_needed`) ise ağa çıkılmaz."""
    if not needed:
        return _unknown(NO_TR_WORK, False)
    if offline_requested(offline):
        return _unknown("çevrimdışı", False)
    try:
        key, base = load_credentials(key_file)
    except TrTtsError as e:
        return _unknown("PD_API_URL https değil" if "https" in str(e) else "anahtar tanımlı değil", False)
    except Exception as e:  # noqa: BLE001 — anahtar dosyası okunamadı vb.; çağırana istisna gitmez
        return _unknown(f"anahtar okunamadı ({type(e).__name__})", False)
    try:
        status, raw = _with_deadline(fetch or _http_get,
                                     (base + USAGE_PATH, {"Authorization": f"Bearer {key}",
                                                          "Accept": "application/json"},
                                      USAGE_CONNECT_TIMEOUT, USAGE_READ_TIMEOUT),
                                     total_timeout)
    except TimeoutError:                      # socket.timeout da TimeoutError'dır (3.10+)
        return _unknown("zaman aşımı", True)
    except OSError as e:                      # bağlantı, DNS, TLS
        return _unknown(f"ağ hatası ({type(e).__name__})", True)
    except Exception as e:  # noqa: BLE001
        return _unknown(f"beklenmeyen hata ({type(e).__name__})", True)
    if status != 200:
        return _unknown(f"HTTP {status}" + (" (anahtar geçersiz ya da engelli)" if status in (401, 403) else ""), True)
    return _parse_usage(raw)


def _local_date(d: datetime) -> str:
    return d.astimezone().strftime("%d.%m.%Y")


def cost_text(chars: int, stt_seconds: float, status: BillingStatus, now: datetime | None = None) -> str:
    """Bütün Türkçe ses araçlarının kuru çalışma ücret satırı (tarife TL_PER_1000_CHARS + TL_PER_AUDIO_HOUR)."""
    now = now or datetime.now(timezone.utc)
    if not status.fetched and not work_needed(chars, stt_seconds):
        return "0 TL (Türkçe üretim yok; ücret durumu okunmadı)"
    tl = estimate_tl(chars, stt_seconds)
    if not status.known:
        return f"≈ {tl:.2f} TL (ücret durumu doğrulanamadı: {status.reason}; ücretli varsayıldı)"
    if status.is_free(now):
        until = f": {_local_date(status.free_until)} tarihine kadar" if status.free_until else ""
        line = f"ücretsiz (PatientDesk{until}; tarife ≈ {tl:.2f} TL)"
    elif status.free_until is not None and status.free_until <= now:
        line = f"≈ {tl:.2f} TL ödenecek (ücretsiz dönem {_local_date(status.free_until)} bitti)"
    else:
        line = f"≈ {tl:.2f} TL ödenecek (ücretli dönem)"
    if status.remaining_seconds is not None:
        line += f"; kalan Duyu kotası ≈ {status.remaining_seconds / 3600:.0f} saat"
    return line


def dry_run_note(status: BillingStatus) -> str:
    if not status.fetched:
        return "hiçbir API çağrısı yapılmadı"
    if status.known:
        return f"üretim çağrısı yapılmadı; yalnız ücret durumu okundu (GET {USAGE_PATH})"
    return f"üretim çağrısı yapılmadı; ücret durumu okunamadı (GET {USAGE_PATH})"


def with_retry(fn: Callable, *args, sleep: Callable[[float], None] = time.sleep,
               log: Callable[[str], None] = print):
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            return fn(*args)
        except RateLimited as e:
            if attempt == MAX_RETRIES:
                raise TrTtsError(f"429: {MAX_RETRIES} denemede geçmedi") from None
            wait = min(max(e.retry_after, 0.0), MAX_RETRY_WAIT)
            log(f"  429: {wait:g} sn bekleniyor (deneme {attempt}/{MAX_RETRIES})")
            sleep(wait)


def wav_slice(data: bytes, start: float, end: float) -> bytes:
    with wave.open(io.BytesIO(data)) as src:
        rate = src.getframerate()
        src.setpos(max(0, int(start * rate)))
        frames = src.readframes(max(0, int((end - start) * rate)))
        params = src.getparams()
    buf = io.BytesIO()
    with wave.open(buf, "wb") as o:
        o.setparams(params)
        o.writeframes(frames)
    return buf.getvalue()


def duyu_gaps(words: list[dict], duration: float | None = None,
              min_gap: float = GAP_SECONDS) -> list[tuple[float, float]]:
    """Duyu'nun konuşmayı atladığı aralık adayları (Alania anlatımında 3 sn'lik sessizlik olmaz): kelimeler
    arası, baştaki ve (`duration` verilirse) sondaki uzun boşluk (Duyu bazen sesin son 20 sn'sini yazmaz).
    Zamanı geçersiz kelimeler (`_time_ok`) hesaba katılmaz (H-114)."""
    words = [w for w in words if _word_ok(w, duration)]
    if not words:
        return []
    gaps = [(float(a["end"]), float(b["start"])) for a, b in zip(words, words[1:])
            if float(b["start"]) - float(a["end"]) > min_gap]
    if float(words[0]["start"]) > min_gap:
        gaps.insert(0, (0.0, float(words[0]["start"])))
    if duration is not None and duration - float(words[-1]["end"]) > min_gap:
        gaps.append((float(words[-1]["end"]), duration))
    return gaps


def fill_gaps(client: "Client", wav: bytes, words: list[dict], key: str, sleep=time.sleep, log=print,
              duration: float | None = None,
              on_paid: Callable[[float, float, dict], None] | None = None) -> tuple[list[dict], float]:
    """Uzun Duyu boşluklarını ayrıca yazıya döker ve kelimeleri zamanı kaydırarak araya ekler (H-105:
    Duyu uzun sayfalarda ortadaki 20 sn'yi atlayabiliyor; ses tamam). Dönüş: (kelimeler, ek Duyu saniyesi).
    `on_paid(a, b, başlıklar)` her başarılı (ücretli) boşluk çağrısından hemen sonra, yanıt işlenmeden çağrılır
    (H-114: harcama defterde kaybolmaz)."""
    out = list(words)
    spent = 0.0
    for a, b in duyu_gaps(words, duration):
        doc, h = with_retry(client.transcribe, wav_slice(wav, a, b), f"{key}-{a:.1f}.wav", sleep=sleep, log=log)
        if on_paid is not None:
            on_paid(a, b, h if isinstance(h, dict) else {})
        spent += b - a
        got = doc.get("words") if isinstance(doc, dict) else None
        add = [{**w, "start": round(float(w["start"]) + a, 3), "end": round(float(w["end"]) + a, 3)}
               for w in (got if isinstance(got, list) else []) if _word_ok(w, b - a)]
        k = next((i for i, w in enumerate(out) if _word_ok(w) and float(w["start"]) >= b), len(out))
        out = out[:k] + add + out[k:]
        log(f"  Duyu boşluğu {a:.1f}–{b:.1f} sn yeniden yazıya döküldü: {len(add)} kelime")
    return out, spent


def _header_seconds(raw, audio: bytes) -> float:
    """`x-audio-seconds` başlığı geçerli sonlu sayıysa o, değilse WAV süresi (H-114: bozuk başlık hata değil)."""
    try:
        v = float(raw)
        if math.isfinite(v) and v >= 0:
            return v
    except (TypeError, ValueError):
        pass
    return wav_duration(audio)


def _duyu_seconds(doc, audio_seconds: float) -> float:
    """Deftere yazılacak Duyu saniyesi: yanıttaki geçerli `duration`, yoksa gönderilen sesin süresi."""
    try:
        v = float(doc.get("duration")) if isinstance(doc, dict) and doc.get("duration") is not None else None
    except (TypeError, ValueError):
        v = None
    return v if v is not None and math.isfinite(v) and v > 0 else audio_seconds


def wav_duration(data: bytes) -> float:
    with wave.open(io.BytesIO(data)) as w:
        return w.getnframes() / float(w.getframerate())


# --- plan ve yürütme -----------------------------------------------------------------------------

def spoken_text(text: str) -> str:
    """Alania'ya giden metin. Alania metnin başındaki parantezli bölümü (ve köşeli parantezi) okunacak metin
    değil yönerge sayar: "(Hatalı) Geç kaldım" → "Hatalı" okunmaz; tamamı parantezli "(Hatalı sıra: Yedi cuma.)"
    → HTTP 400 "nothing to speak after its instruction" (2026-11-28, H-109). Baştaki grup açılır:
    tamamını sarıyorsa parantezler kalkar, değilse "X: geri kalan" olur. Ekranda görünen metin değişmez;
    Duyu eşlemesi noktalamayı saymadığı için hizalama aynı metne göre yapılır."""
    t = text.replace("[", "(").replace("]", ")")
    lead = len(t) - len(t.lstrip())
    if not t[lead:].startswith("("):
        return t
    depth = 0
    for k in range(lead, len(t)):
        depth += {"(": 1, ")": -1}.get(t[k], 0)
        if depth == 0:
            inner, rest = t[lead + 1:k].strip(), t[k + 1:].strip()
            if not rest:
                return inner
            sep = "" if inner[-1:] in ":.!?;," else ":"
            return f"{inner}{sep} {rest}"
    return t   # kapanmayan parantez: olduğu gibi


def tts_payload(seg: Segment, voice: str = VOICE, model: str = TTS_MODEL) -> dict:
    p = {"model": model, "voice": voice, "input": spoken_text(seg.text)}
    if seg.instructions:
        p["instructions"] = seg.instructions
    if seg.pronunciations:
        p["pronunciations"] = seg.pronunciations
    return p


def seg_key(seg: Segment, voice: str = VOICE, model: str = TTS_MODEL) -> str:
    return text_sha256(json.dumps(tts_payload(seg, voice, model), ensure_ascii=False, sort_keys=True))[:24]


@dataclass
class Job:
    seg: Segment
    key: str
    action: str          # skip | tts | stt | build
    reason: str

    @property
    def chars(self) -> int:
        return len(self.seg.text)


@dataclass
class Plan:
    out_dir: Path
    voice: str
    model: str
    jobs: list[Job] = field(default_factory=list)

    def raw_wav(self, j: Job) -> Path:
        return self.out_dir / RAW_DIR / f"{j.key}.wav"

    def raw_stt(self, j: Job) -> Path:
        return self.out_dir / RAW_DIR / f"{j.key}.duyu.json"

    def raw_stt_main(self, j: Job) -> Path:
        """Ödenmiş ana Duyu yanıtı (boşluk doldurmadan önce; H-114): boşluk çağrısı düşerse yeniden ödenmez."""
        return self.out_dir / RAW_DIR / f"{j.key}.duyu.main.json"

    def audio(self, j: Job) -> Path:
        return self.out_dir / f"{j.seg.id}.mp3"

    def align(self, j: Job) -> Path:
        return self.out_dir / f"{j.seg.id}.align.json"

    @property
    def billable_chars(self) -> int:
        return sum(j.chars for j in self.jobs if j.action == "tts")

    @property
    def est_stt_seconds(self) -> float:
        return sum(j.chars / EST_CHARS_PER_SEC for j in self.jobs if j.action in ("tts", "stt"))


def plan_segments(segs: list[Segment], out_dir: Path, voice: str = VOICE, model: str = TTS_MODEL,
                  force: bool = False) -> Plan:
    plan = Plan(Path(out_dir), voice, model)
    for s in segs:
        j = Job(s, seg_key(s, voice, model), "tts", "ses yok")
        ap, mp = plan.align(j), plan.audio(j)
        if ap.exists() and mp.exists() and not force:
            try:
                old = json.loads(ap.read_text(encoding="utf-8")).get("key")
            except (OSError, ValueError):
                old = None
            if old == j.key:
                j.action, j.reason = "skip", "ses ve hizalama güncel (anahtar aynı)"
            else:
                j.reason = "metin ya da ayar değişti"
        if j.action != "skip":
            if plan.raw_wav(j).exists():
                j.action, j.reason = ("build", "ham ses ve Duyu önbellekte") if plan.raw_stt(j).exists() \
                    else ("stt", "ham ses önbellekte; yalnız Duyu")
        plan.jobs.append(j)
    return plan


def describe(plan: Plan) -> list[str]:
    label = {"skip": "ATLA", "tts": "ÜRET (Alania + Duyu)", "stt": "YALNIZ DUYU", "build": "YEREL (ücret yok)"}
    lines = [f"Çıktı: {plan.out_dir} · model {plan.model}, ses {plan.voice}, Duyu {STT_MODEL}"]
    for j in plan.jobs:
        lines.append(f"  {j.seg.id}: {j.chars} karakter, {label[j.action]} — {j.reason}")
    return lines


@dataclass
class SegResult:
    id: str
    chars: int
    duration: float
    quality: dict
    lufs: float | None


@dataclass
class RunResult:
    done: list[SegResult] = field(default_factory=list)
    skipped: list[str] = field(default_factory=list)
    tts_calls: int = 0
    stt_calls: int = 0
    chars: int = 0
    stt_seconds: float = 0.0
    warnings: list[str] = field(default_factory=list)
    stopped: str | None = None


def finalize_audio(wav: Path, out: Path) -> float | None:
    """-16 LUFS'a kazanç + sınırlayıcı; mp3 44,1 kHz 128 kb/sn. Dönüş: ölçülen çıkış LUFS."""
    from . import media
    gain = media.gain_to_target(wav)
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = out.with_name(out.stem + ".part.mp3")
    media.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(wav), "-af", media.gain_filter(gain),
               "-c:a", "libmp3lame", "-b:a", "128k", str(tmp)])
    os.replace(tmp, out)
    return round(media.loudness([out])["I"], 2)


def execute(plan: Plan, client: Client, cap: int | None, ledger: Path, prompts: Path,
            finalize: Callable[[Path, Path], float | None] = finalize_audio,
            sleep: Callable[[float], None] = time.sleep, now: Callable[[], datetime] | None = None,
            log: Callable[[str], None] = print) -> RunResult:
    if cap is None:
        raise TrTtsError(f"aylık karakter tavanı tanımlı değil ({ENV_CAP} ya da --monthly-char-cap); "
                         "tavan yoksa ücretli üretim kapalıdır (CLAUDE.md)")
    now = now or (lambda: datetime.now(timezone.utc))
    res = RunResult()
    for j in plan.jobs:
        sid = j.seg.id
        if j.action == "skip":
            res.skipped.append(sid)
            continue
        wav_p, stt_p = plan.raw_wav(j), plan.raw_stt(j)
        sha = text_sha256(j.seg.text)
        # H-114: tavan, defter kilidi altında ve ücretli çağrıdan hemen önce okunan defterle denetlenir; kilit
        # çağrı, defter yazısı ve önbellek yazısı bitene kadar tutulur. Kilit alınınca önbellek yeniden
        # denetlenir: aynı parçayı bekleyen eşzamanlı çalıştırma ilkinin ödediği sesi kullanır, yeniden ödemez.
        if not wav_p.exists():
            with ledger_lock(ledger, log=log):
                if not wav_p.exists():
                    month = month_key(now())
                    used = ledger_used(ledger, month)
                    if used + j.chars > cap:
                        res.stopped = f"aylık tavan aşılır: bu ay {used} + {j.chars} > {cap} karakter; {sid} üretilmedi"
                        log(res.stopped)
                        return res
                    audio, h = with_retry(client.speech, tts_payload(j.seg, plan.voice, plan.model),
                                          sleep=sleep, log=log)
                    # H-114: çağrı başarıyla döndü = ödendi. Yanıt denetlenmeden önce deftere (bozuk gövdede de
                    # gönderilen karakter ücretlenir), sonra önbellek, en son PROMPTS satırı.
                    ledger_add(ledger, month, chars=j.chars)
                    res.tts_calls += 1
                    res.chars += j.chars
                    if not isinstance(audio, (bytes, bytearray)) or audio[:4] != b"RIFF":
                        raise TrTtsError(f"{sid}: Alania yanıtı WAV değil (ücret deftere yazıldı)")
                    _atomic_bytes(wav_p, bytes(audio))
                    h = h if isinstance(h, dict) else {}
                    secs = _header_seconds(h.get("x-audio-seconds"), audio)
                    append_prompts(prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "segment": sid,
                                             "model": plan.model, "voice": plan.voice,
                                             "release": h.get("x-model-release", "-"),
                                             "chars": h.get("x-characters", j.chars), "seconds": round(secs, 2),
                                             "request_id": h.get("x-request-id", "-"), "sha": sha})
                    log(f"  {sid}: Alania {j.chars} karakter → {secs:.2f} sn")
        audio = wav_p.read_bytes()
        duration = wav_duration(audio)
        if not stt_p.exists():
            with ledger_lock(ledger, log=log):
                if not stt_p.exists():
                    main_p = plan.raw_stt_main(j)
                    if main_p.exists():
                        doc = json.loads(main_p.read_text(encoding="utf-8"))
                        log(f"  {sid}: Duyu ana yanıtı önbellekten (ücret yok); yalnız boşluklar")
                    else:
                        doc, h = with_retry(client.transcribe, audio, f"{j.key}.wav", sleep=sleep, log=log)
                        # H-114: ödendi → önce defter (Duyu ücreti gönderilen sesin süresine göre), sonra denetim.
                        secs = _duyu_seconds(doc, duration)
                        ledger_add(ledger, month_key(now()), stt_seconds=secs)
                        res.stt_calls += 1
                        res.stt_seconds += secs
                        if not isinstance(doc, dict) or not isinstance(doc.get("words"), list):
                            raise TrTtsError(f"{sid}: Duyu yanıtında kelime zamanları yok (verbose_json + word; "
                                             "ücret deftere yazıldı)")
                        doc = {"text": doc.get("text"), "language": doc.get("language"),
                               "duration": doc.get("duration"), "words": doc["words"]}
                        _atomic_bytes(main_p, (json.dumps(doc, ensure_ascii=False) + "\n").encode("utf-8"))
                        h = h if isinstance(h, dict) else {}
                        append_prompts(prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "segment": sid,
                                                 "model": STT_MODEL, "voice": "-",
                                                 "release": h.get("x-model-release", "-"),
                                                 "chars": "-", "seconds": round(secs, 2),
                                                 "request_id": h.get("x-request-id", "-"), "sha": sha})

                    def gap_paid(a: float, b: float, gh: dict, sid=sid) -> None:
                        ledger_add(ledger, month_key(now()), stt_seconds=b - a)
                        res.stt_calls += 1
                        res.stt_seconds += b - a
                        append_prompts(prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"),
                                                 "segment": f"{sid} boşluk {a:.1f}–{b:.1f}",
                                                 "model": STT_MODEL, "voice": "-",
                                                 "release": gh.get("x-model-release", "-"), "chars": "-",
                                                 "seconds": round(b - a, 2),
                                                 "request_id": gh.get("x-request-id", "-"), "sha": sha})
                    words_, _extra = fill_gaps(client, audio, doc["words"], j.key, sleep=sleep, log=log,
                                               duration=duration, on_paid=gap_paid)
                    doc = {**doc, "words": words_}
                    _atomic_bytes(stt_p, (json.dumps({"text": doc.get("text"), "language": doc.get("language"),
                                                      "duration": doc.get("duration"), "words": doc["words"]},
                                                     ensure_ascii=False) + "\n").encode("utf-8"))
                    log(f"  {sid}: Duyu {len(doc['words'])} kelime")
        stt = json.loads(stt_p.read_text(encoding="utf-8"))
        words, q = map_words(j.seg.text, stt["words"], duration)
        al = char_alignment(j.seg.text, words)
        for w in q.warnings:
            msg = f"UYARI {sid}: {w}"
            res.warnings.append(msg)
            log(msg)
        lufs = finalize(wav_p, plan.audio(j))
        # Hizalama en son yazılır: idempotentlik denetimi ses + hizalama ikilisine bakar.
        doc = {"text": j.seg.text, "textSha256": sha, "key": j.key, "lang": LANGUAGE, "model_id": plan.model,
               "voice_id": plan.voice, "timing": STT_MODEL, "duration": round(duration, 3),
               "loudnessLufs": lufs, "quality": q.as_json(),
               "words": [{"w": w.token.text, "start": round(w.start, 3), "end": round(w.end, 3),
                          "status": w.status, **({"heard": w.heard} if w.heard and w.status != "exact" else {})}
                         for w in words],
               "alignment": alignment_json(al)}
        _atomic_bytes(plan.align(j), (json.dumps(doc, ensure_ascii=False) + "\n").encode("utf-8"))
        res.done.append(SegResult(sid, j.chars, duration, q.as_json(), lufs))
    return res
