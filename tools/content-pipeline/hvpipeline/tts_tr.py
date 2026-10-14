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
- Varsayılan **kuru çalışma**: karakter ve tahmini TL yazılır, API çağrılmaz; gerçek çağrı `execute=True`.
- **Aylık karakter tavanı** (`HIVELZON_TR_TTS_MONTHLY_CHAR_CAP` ya da `--monthly-char-cap`) tanımlı değilse
  gerçek çağrı reddedilir. Defter: `kitaplar/_maliyet/patientdesk-karakter.json` (değiştirilebilir).
- **İdempotent:** anahtar = metin + model + ses + üslup + söyleniş sha256'sı. Ödenmiş ham WAV ve Duyu
  sonucu `_raw/` önbelleğinde tutulur; güncel çıktı varsa hiçbir çağrı yapılmaz.
- 429'da `Retry-After` kadar beklenir (sınırlı deneme).
- **Anahtar** (`PD_API_KEY`) yalnız ortamdan ya da `~/.config/hivelzon/patientdesk.env`'den, yalnız gerçek
  çağrıda okunur; ekrana, loga ve dosyaya yazılmaz.
- Her gerçek çağrı verilen `PROMPTS.md` tablosuna yazılır (tarih, parça, model, ses, sürüm, karakter,
  ses süresi, istek kimliği, metin sha256).
"""

from __future__ import annotations

import io
import json
import os
import re
import time
import unicodedata
import uuid
import wave
from dataclasses import dataclass, field
from datetime import datetime, timezone
from difflib import SequenceMatcher
from pathlib import Path
from typing import Callable, Protocol

from . import REPO_ROOT
from .align import Alignment, alignment_json
from .book import text_sha256

API_BASE = "https://voice.patientdesk.ai"
ENV_KEY = "PD_API_KEY"
ENV_URL = "PD_API_URL"
KEY_FILE = Path.home() / ".config" / "hivelzon" / "patientdesk.env"
ENV_CAP = "HIVELZON_TR_TTS_MONTHLY_CHAR_CAP"
ENV_LEDGER = "HIVELZON_TR_TTS_LEDGER"
DEFAULT_LEDGER = REPO_ROOT / "kitaplar" / "_maliyet" / "patientdesk-karakter.json"
TTS_MODEL = "alania-v2"
VOICE = "alania2-f1"
STT_MODEL = "duyu-1"
LANGUAGE = "tr"
MAX_CHARS = 5000
MAX_INSTRUCTIONS = 200
TL_PER_1000_CHARS = 0.75        # Alania (ilk ay ücretsiz; 2026-10-14)
TL_PER_AUDIO_HOUR = 6.0         # Duyu dosya
EST_CHARS_PER_SEC = 14.0        # kuru çalışmada Duyu süresi tahmini (Türkçe anlatım)
MAX_RETRIES = 5
MAX_RETRY_WAIT = 60.0
RAW_DIR = "_raw"
# Hizalama kalitesi eşikleri
FUZZY_OK = 0.6                  # bulanık eşleşme benzerlik alt sınırı
MIN_QUALITY = 0.85              # iyi eşleşen kelime oranı
MAX_BAD_RUN = 2                 # art arda zayıf/eksik kelime sınırı (bu ve üstü uyarı)
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


def norm(w: str) -> str:
    """Karşılaştırma biçimi: Türkçe küçük harf, noktalama ve kesme işareti yok."""
    w = unicodedata.normalize("NFC", tr_lower(w))
    return "".join(c for c in w if c.isalnum())


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


def _dp_align(orig: list[str], heard: list[str]) -> list[tuple[list[int], list[int], float]]:
    """Dizi hizalama (Needleman–Wunsch türevi). Adımlar: 1:1, 2:1, 1:2, özgün atla, Duyu atla.
    Dönüş: (özgün indeksleri, Duyu indeksleri, benzerlik) grupları, sırayla."""
    n, m = len(orig), len(heard)
    NEG = float("-inf")
    best = [[NEG] * (m + 1) for _ in range(n + 1)]
    back: list[list[tuple | None]] = [[None] * (m + 1) for _ in range(n + 1)]
    best[0][0] = 0.0
    for i in range(n + 1):
        for j in range(m + 1):
            cur = best[i][j]
            if cur == NEG:
                continue
            steps = []
            if i < n and j < m:
                s = sim(orig[i], heard[j])
                steps.append((1, 1, s + _PAIR_BIAS, s))
            if i + 1 < n and j < m:
                s = sim(orig[i] + orig[i + 1], heard[j])
                steps.append((2, 1, s + 2 * _PAIR_BIAS - 0.05 if s >= FUZZY_OK else NEG, s))
            if i < n and j + 1 < m:
                s = sim(orig[i], heard[j] + heard[j + 1])
                steps.append((1, 2, s + 2 * _PAIR_BIAS - 0.05 if s >= FUZZY_OK else NEG, s))
            if i < n:
                steps.append((1, 0, _GAP, 0.0))
            if j < m:
                steps.append((0, 1, _GAP, 0.0))
            for di, dj, gain, s in steps:
                v = cur + gain
                if v > best[i + di][j + dj]:
                    best[i + di][j + dj] = v
                    back[i + di][j + dj] = (i, j, s)
    out = []
    i, j = n, m
    while (i, j) != (0, 0):
        pi, pj, s = back[i][j]
        out.append((list(range(pi, i)), list(range(pj, j)), s))
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


def map_words(text: str, duyu_words: list[dict], duration: float | None = None) -> tuple[list[WordTime], Quality]:
    """Duyu kelimelerini özgün metnin kelimelerine eşler. Eksik kelimelere komşu zamanlar arasında
    karakter uzunluğuna göre zaman verilir ve kalite düşürülür."""
    toks = tokenize(text)
    heard_raw = [w for w in duyu_words if norm(str(w.get("word", "")))]
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
    text = path.read_text(encoding="utf-8") if path.exists() else "# PROMPTS\n"
    if PROMPTS_HEADING not in text:
        text = text.rstrip("\n") + f"\n\n{PROMPTS_HEADING}\n\n{PROMPTS_TABLE}\n"
    text = text if text.endswith("\n") else text + "\n"
    line = (f"| {row['date']} | {row['segment']} | {row['model']} | {row['voice']} | {row['release']} | "
            f"{row['chars']} | {row['seconds']} | {row['request_id']} | {row['sha'][:16]} |\n")
    _atomic_bytes(path, (text + line).encode("utf-8"))


def _atomic_bytes(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_bytes(data)
    os.replace(tmp, path)


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


def wav_duration(data: bytes) -> float:
    with wave.open(io.BytesIO(data)) as w:
        return w.getnframes() / float(w.getframerate())


# --- plan ve yürütme -----------------------------------------------------------------------------

def tts_payload(seg: Segment, voice: str = VOICE, model: str = TTS_MODEL) -> dict:
    p = {"model": model, "voice": voice, "input": seg.text}
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
        if not wav_p.exists():
            month = month_key(now())
            used = ledger_used(ledger, month)
            if used + j.chars > cap:
                res.stopped = f"aylık tavan aşılır: bu ay {used} + {j.chars} > {cap} karakter; {sid} üretilmedi"
                log(res.stopped)
                return res
            audio, h = with_retry(client.speech, tts_payload(j.seg, plan.voice, plan.model), sleep=sleep, log=log)
            if not audio[:4] == b"RIFF":
                raise TrTtsError(f"{sid}: Alania yanıtı WAV değil")
            # Ödeme yapıldı: önce defter ve kayıt, sonra önbellek (çift ücret olmasın).
            ledger_add(ledger, month, chars=j.chars)
            secs = float(h.get("x-audio-seconds") or wav_duration(audio))
            append_prompts(prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "segment": sid,
                                     "model": plan.model, "voice": plan.voice,
                                     "release": h.get("x-model-release", "-"),
                                     "chars": h.get("x-characters", j.chars), "seconds": round(secs, 2),
                                     "request_id": h.get("x-request-id", "-"), "sha": sha})
            _atomic_bytes(wav_p, audio)
            res.tts_calls += 1
            res.chars += j.chars
            log(f"  {sid}: Alania {j.chars} karakter → {secs:.2f} sn")
        audio = wav_p.read_bytes()
        duration = wav_duration(audio)
        if not stt_p.exists():
            doc, h = with_retry(client.transcribe, audio, f"{j.key}.wav", sleep=sleep, log=log)
            if "words" not in doc:
                raise TrTtsError(f"{sid}: Duyu yanıtında kelime zamanları yok (verbose_json + word)")
            secs = float(doc.get("duration") or duration)
            ledger_add(ledger, month_key(now()), stt_seconds=secs)
            append_prompts(prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "segment": sid,
                                     "model": STT_MODEL, "voice": "-", "release": h.get("x-model-release", "-"),
                                     "chars": "-", "seconds": round(secs, 2),
                                     "request_id": h.get("x-request-id", "-"), "sha": sha})
            _atomic_bytes(stt_p, (json.dumps({"text": doc.get("text"), "language": doc.get("language"),
                                              "duration": doc.get("duration"), "words": doc["words"]},
                                             ensure_ascii=False) + "\n").encode("utf-8"))
            res.stt_calls += 1
            res.stt_seconds += secs
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
