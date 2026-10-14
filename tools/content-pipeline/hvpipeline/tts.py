"""Kitap seslendirmesi: ElevenLabs zaman damgalı TTS (H-066).

Kurallar (CLAUDE.md, docs/KITAPLIK.md §5):
- Uç nokta `POST /v1/text-to-speech/{voice}/with-timestamps`; bölümlerdeki ayarlar
  (icerik/A1-001-a-strange-message/PROMPTS.md): model `eleven_v3`, stability 0.5, similarity 0.75,
  `language_code` en, `mp3_44100_128`. Hız seviyeye göre (book.BOOK_LEVELS[...]["speed"]).
- **Anahtar** yalnızca çalışma anında ortamdan okunur (`ELEVENLABS_API_KEY`); dosyaya ve loga yazılmaz.
- Varsayılan **kuru çalışma**: karakter sayısı ve tahmini kredi yazılır, API çağrılmaz. Gerçek çağrı
  yalnızca `execute=True` ile.
- **Aylık karakter tavanı** (`HIVELZON_TTS_MONTHLY_CHAR_CAP` ya da `--monthly-char-cap`). Tavan tanımlı
  değilse gerçek çağrı reddedilir ("tavan tanımlı değilse ücretli üretim kapalı").
- **İdempotent:** sesi ve hizalaması olan, hizalamadaki `textSha256` güncel metinle aynı bölüm atlanır.
  Uzun bölüm parçalara bölünür; her parçanın sonucu `audio/_parts/<sha>.{mp3,json}` önbelleğine yazılır,
  yarıda kalan iş yeniden çalışınca ödenmiş parçalar tekrar istenmez.
- Her gerçek çağrı `<kitap>/PROMPTS.md`'ye (tarih, bölüm, ses, model, hız, karakter, metin özeti) ve
  aylık kullanım defterine yazılır.
"""

from __future__ import annotations

import base64
import json
import os
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Callable
from urllib.parse import quote

from . import REPO_ROOT
from .align import Alignment, alignment_json, concat_alignments
from .book import AUDIO_DIR, PROMPTS_FILE, Book, Chapter, split_sentences, text_sha256

API_BASE = "https://api.elevenlabs.io"
ENV_KEY = "ELEVENLABS_API_KEY"
ENV_CAP = "HIVELZON_TTS_MONTHLY_CHAR_CAP"
ENV_LEDGER = "HIVELZON_TTS_LEDGER"
DEFAULT_LEDGER = REPO_ROOT / "kitaplar" / "_maliyet" / "elevenlabs-karakter.json"
OUTPUT_FORMAT = "mp3_44100_128"
LANGUAGE = "en"
STABILITY = 0.5
SIMILARITY = 0.75
PART_GAP = 0.40            # parçalar arası sessizlik (sn)
# İstek başına karakter sınırı. eleven_v3 için 3.000 varsayıldı (UNCONFIRMED: güncel sınır
# ElevenLabs belgesinden doğrulanmalı); diğer modellerde 5.000.
MAX_CHARS = {"eleven_v3": 3000}
DEFAULT_MAX_CHARS = 5000
# Karakter başına kredi (tahmin; güncel fiyat doğrulanmalı). Flash/Turbo yarım kredi.
CREDITS_PER_CHAR = {"eleven_v3": 1.0, "eleven_multilingual_v2": 1.0,
                    "eleven_flash_v2_5": 0.5, "eleven_turbo_v2_5": 0.5}
PROMPTS_HEADING = "## Seslendirme kayıtları (tts_book.py)"
PROMPTS_TABLE = ("| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |\n"
                 "|---|---|---|---|---|---|---|---|---|")


class TtsError(RuntimeError):
    pass


# --- plan ----------------------------------------------------------------------------------------

def split_parts(text: str, max_chars: int) -> list[str]:
    """Metni paragraf sınırlarında `max_chars`'ı aşmayan parçalara böler; tek paragraf sığmazsa
    cümle sınırında böler."""
    units: list[str] = []
    for par in text.split("\n\n"):
        if len(par) <= max_chars:
            units.append(par)
            continue
        cur = ""
        for s in split_sentences(par):
            if cur and len(cur) + 1 + len(s) > max_chars:
                units.append(cur)
                cur = s
            else:
                cur = f"{cur} {s}".strip()
        if cur:
            units.append(cur)
    parts: list[str] = []
    cur = ""
    for u in units:
        if len(u) > max_chars:
            raise TtsError(f"tek cümle {len(u)} karakter (sınır {max_chars}); metni böl")
        if cur and len(cur) + 2 + len(u) > max_chars:
            parts.append(cur)
            cur = u
        else:
            cur = f"{cur}\n\n{u}" if cur else u
    if cur:
        parts.append(cur)
    return parts


@dataclass
class ChapterJob:
    chapter: Chapter
    text: str
    sha: str
    parts: list[str]
    action: str              # "skip" | "generate"
    reason: str
    cached_parts: int = 0

    @property
    def chars(self) -> int:
        return len(self.text)


@dataclass
class Plan:
    book: Book
    voice_id: str | None
    model_id: str
    speed: float
    jobs: list[ChapterJob] = field(default_factory=list)

    @property
    def chars(self) -> int:
        """Üretilecek bölümlerin toplam karakteri (önbellekteki parçalar dahil)."""
        return sum(j.chars for j in self.jobs if j.action == "generate")

    def credits(self) -> float:
        """Tahmini kredi: yalnızca önbellekte olmayan, gerçekten istenecek parçalar."""
        return plan_billable(self) * CREDITS_PER_CHAR.get(self.model_id, 1.0)


def _parts_dir(book: Book) -> Path:
    return book.dir / AUDIO_DIR / "_parts"


def _part_key(text: str, voice: str | None, model: str, speed: float) -> str:
    return text_sha256(json.dumps([text, voice, model, speed, STABILITY, SIMILARITY, OUTPUT_FORMAT]))[:24]


def plan_book(book: Book, chapters: list[str] | None = None, force: bool = False) -> Plan:
    if book.text.errors:
        raise TtsError("text.en.md işaretleri hatalı: " + "; ".join(book.text.errors[:3]))
    n = book.narration()
    plan = Plan(book, n.get("voiceId"), n["modelId"], float(n["speed"]))
    max_chars = MAX_CHARS.get(plan.model_id, DEFAULT_MAX_CHARS)
    for c in book.text.chapters:
        if chapters and c.id not in chapters:
            continue
        text = c.tts_text()
        sha = text_sha256(text)
        parts = split_parts(text, max_chars)
        ap, mp = book.align_path(c.id), book.audio_path(c.id)
        action, reason = "generate", "ses yok"
        if ap.exists() and mp.exists():
            try:
                old = json.loads(ap.read_text(encoding="utf-8")).get("textSha256")
            except (OSError, ValueError):
                old = None
            if old == sha and not force:
                action, reason = "skip", "ses ve hizalama güncel (textSha256 aynı)"
            else:
                reason = "metin değişti" if old != sha else "--force"
        elif ap.exists():
            reason = "ses dosyası yok (hizalama var)"
        job = ChapterJob(c, text, sha, parts, action, reason)
        if action == "generate":
            cached = [p for p in parts if (_parts_dir(book) / f"{_part_key(p, plan.voice_id, plan.model_id, plan.speed)}.json").exists()]
            job.cached_parts = len(cached)
        plan.jobs.append(job)
    return plan


def plan_billable(plan: Plan) -> int:
    """Önbellekte olmayan parçaların toplam karakteri."""
    total = 0
    for j in plan.jobs:
        if j.action != "generate":
            continue
        for p in j.parts:
            if not (_parts_dir(plan.book) / f"{_part_key(p, plan.voice_id, plan.model_id, plan.speed)}.json").exists():
                total += len(p)
    return total


# --- tavan ve defter ------------------------------------------------------------------------------

def monthly_cap(cli_value: int | None = None) -> int | None:
    if cli_value is not None:
        return cli_value if cli_value > 0 else None
    raw = os.environ.get(ENV_CAP, "").strip()
    if not raw:
        return None
    try:
        v = int(raw.replace("_", "").replace(".", ""))
    except ValueError:
        raise TtsError(f"{ENV_CAP} tam sayı olmalı")
    return v if v > 0 else None


def ledger_path(cli_value: str | None = None) -> Path:
    return Path(cli_value or os.environ.get(ENV_LEDGER) or DEFAULT_LEDGER)


def month_key(now: datetime | None = None) -> str:
    return (now or datetime.now(timezone.utc)).strftime("%Y-%m")


def ledger_used(path: Path, month: str) -> int:
    if not path.exists():
        return 0
    d = json.loads(path.read_text(encoding="utf-8"))
    return int(d.get(month, {}).get("characters", 0))


def ledger_add(path: Path, month: str, chars: int) -> None:
    d = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}
    m = d.setdefault(month, {"characters": 0, "calls": 0})
    m["characters"] += chars
    m["calls"] += 1
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    os.replace(tmp, path)


def append_prompts(book: Book, row: dict) -> None:
    p = book.dir / PROMPTS_FILE
    text = p.read_text(encoding="utf-8") if p.exists() else f"# {book.id} PROMPTS\n"
    if PROMPTS_HEADING not in text:
        text = text.rstrip("\n") + f"\n\n{PROMPTS_HEADING}\n\n{PROMPTS_TABLE}\n"
    line = (f"| {row['date']} | {row['chapter']} | {row['part']} | {row['voice']} | {row['model']} | {row['speed']} | "
            f"{row['chars']} | {row['sha'][:16]} | {row['file']} |\n")
    text = text if text.endswith("\n") else text + "\n"
    tmp = p.with_suffix(".md.tmp")
    tmp.write_text(text + line, encoding="utf-8")
    os.replace(tmp, p)


# --- API -----------------------------------------------------------------------------------------

def http_client(timeout: float = 180.0) -> Callable[[str, dict], dict]:
    """Gerçek ElevenLabs istemcisi. Anahtar burada, çağrı anında ortamdan okunur; döndürülen işlev
    anahtarı yalnızca istek başlığına koyar."""
    import urllib.error
    import urllib.request

    if not os.environ.get(ENV_KEY):
        raise TtsError(f"{ENV_KEY} ortam değişkeni tanımlı değil (anahtar repo dışında tutulur)")

    def call(voice_id: str, payload: dict) -> dict:
        url = f"{API_BASE}/v1/text-to-speech/{quote(voice_id, safe='')}/with-timestamps?output_format={OUTPUT_FORMAT}"
        req = urllib.request.Request(url, data=json.dumps(payload).encode("utf-8"), method="POST",
                                     headers={"xi-api-key": os.environ[ENV_KEY],
                                              "Content-Type": "application/json", "Accept": "application/json"})
        try:
            with urllib.request.urlopen(req, timeout=timeout) as r:
                return json.loads(r.read())
        except urllib.error.HTTPError as e:
            body = e.read().decode("utf-8", errors="replace")[:300]
            raise TtsError(f"ElevenLabs HTTP {e.code}: {body}") from None
    return call


def payload(text: str, model_id: str, speed: float) -> dict:
    return {"text": text, "model_id": model_id, "language_code": LANGUAGE,
            "voice_settings": {"stability": STABILITY, "similarity_boost": SIMILARITY, "speed": speed}}


# --- yürütme -------------------------------------------------------------------------------------

@dataclass
class RunResult:
    generated: list[str] = field(default_factory=list)
    skipped: list[str] = field(default_factory=list)
    calls: int = 0
    chars: int = 0
    stopped: str | None = None


def _atomic_bytes(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + ".tmp")
    tmp.write_bytes(data)
    os.replace(tmp, path)


def _atomic_json(path: Path, doc: dict) -> None:
    _atomic_bytes(path, (json.dumps(doc, ensure_ascii=False) + "\n").encode("utf-8"))


def execute(plan: Plan, client: Callable[[str, dict], dict], cap: int | None, ledger: Path,
            concat: Callable[[list[Path], float, Path], Path] | None = None,
            duration: Callable[[Path], float] | None = None, now: Callable[[], datetime] | None = None,
            log: Callable[[str], None] = print) -> RunResult:
    """Planı gerçekten çalıştırır. Tavan yoksa reddeder. Her parça öncesinde tavan denetlenir."""
    if cap is None:
        raise TtsError(f"aylık karakter tavanı tanımlı değil ({ENV_CAP} ya da --monthly-char-cap); "
                       "tavan yoksa ücretli üretim kapalıdır (CLAUDE.md)")
    if not plan.voice_id:
        raise TtsError("book.json → narration.voiceId yok")
    now = now or (lambda: datetime.now(timezone.utc))
    res = RunResult()
    book = plan.book
    for job in plan.jobs:
        cid = job.chapter.id
        if job.action == "skip":
            res.skipped.append(cid)
            continue
        part_files: list[tuple[Path, Path]] = []
        for k, text in enumerate(job.parts, start=1):
            key = _part_key(text, plan.voice_id, plan.model_id, plan.speed)
            mp3, aj = _parts_dir(book) / f"{key}.mp3", _parts_dir(book) / f"{key}.json"
            if not (mp3.exists() and aj.exists()):
                month = month_key(now())
                used = ledger_used(ledger, month)
                if used + len(text) > cap:
                    res.stopped = (f"aylık tavan aşılır: bu ay {used} + {len(text)} > {cap} karakter; "
                                   f"{cid} parça {k} üretilmedi")
                    log(res.stopped)
                    return res
                resp = client(plan.voice_id, payload(text, plan.model_id, plan.speed))
                if "audio_base64" not in resp or "alignment" not in resp:
                    raise TtsError("ElevenLabs yanıtında audio_base64/alignment yok")
                # Ödeme yapıldı: önce defter ve kayıt, sonra dosyalar (çift ücret olmasın diye önbelleğe).
                ledger_add(ledger, month, len(text))
                res.calls += 1
                res.chars += len(text)
                _atomic_bytes(mp3, base64.b64decode(resp["audio_base64"]))
                _atomic_json(aj, {"text": text, "textSha256": text_sha256(text), "voice_id": plan.voice_id,
                                  "model_id": plan.model_id, "speed": plan.speed, "lang": LANGUAGE,
                                  "alignment": resp["alignment"]})
                append_prompts(book, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "chapter": cid,
                                      "part": f"{k}/{len(job.parts)}", "voice": plan.voice_id,
                                      "model": plan.model_id, "speed": plan.speed, "chars": len(text),
                                      "sha": text_sha256(text), "file": f"audio/{cid}.mp3"})
                log(f"  {cid} parça {k}/{len(job.parts)}: {len(text)} karakter üretildi")
            else:
                log(f"  {cid} parça {k}/{len(job.parts)}: önbellekten (ücret yok)")
            part_files.append((mp3, aj))
        _assemble(book, job, plan, part_files, concat, duration)
        res.generated.append(cid)
    return res


def _assemble(book: Book, job: ChapterJob, plan: Plan, part_files: list[tuple[Path, Path]],
              concat, duration) -> None:
    out_mp3, out_align = book.audio_path(job.chapter.id), book.align_path(job.chapter.id)
    if len(part_files) == 1:
        mp3, aj = part_files[0]
        al = Alignment.load(aj)
        _atomic_bytes(out_mp3, mp3.read_bytes())
    else:
        if concat is None or duration is None:
            from . import media
            concat = concat or _concat_mp3
            duration = duration or media.probe_duration
        al = concat_alignments([(Alignment.load(aj), duration(mp3)) for mp3, aj in part_files], PART_GAP)
        concat([mp3 for mp3, _ in part_files], PART_GAP, out_mp3)
    # Hizalama en son yazılır: idempotentlik denetimi ses + hizalama ikilisine bakar.
    _atomic_json(out_align, {"text": job.text, "textSha256": job.sha, "voice_id": plan.voice_id,
                             "model_id": plan.model_id, "speed": plan.speed, "lang": LANGUAGE,
                             "parts": len(part_files), "alignment": alignment_json(al)})


def _concat_mp3(paths: list[Path], gap: float, out: Path) -> Path:
    from . import media
    wav = out.with_name(out.stem + ".concat.wav")
    wav.unlink(missing_ok=True)
    media.concat_audio(paths, gap, wav)
    tmp = out.with_name(out.stem + ".part.mp3")
    media.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(wav), "-c:a", "libmp3lame", "-b:a", "128k", str(tmp)])
    os.replace(tmp, out)
    wav.unlink(missing_ok=True)
    return out


def describe(plan: Plan) -> list[str]:
    lines = [f"{plan.book.id}: ses {plan.voice_id or '(narration.voiceId yok)'}, model {plan.model_id}, hız {plan.speed}"]
    for j in plan.jobs:
        extra = f", {len(j.parts)} parça" + (f" ({j.cached_parts} önbellekte)" if j.cached_parts else "")
        lines.append(f"  {j.chapter.id}: {j.chars} karakter, {'ATLA' if j.action == 'skip' else 'ÜRET'} — {j.reason}"
                     + (extra if j.action == "generate" else ""))
    return lines

