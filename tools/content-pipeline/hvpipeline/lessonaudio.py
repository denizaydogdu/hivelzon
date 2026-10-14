"""Dilbilgisi dersi ses planı (H-077; docs/DILBILGISI.md §6, §9.3).

- **Türkçe anlatım** (kart başına bir parça, `<kart>-tr`): tts_tr (Alania + Duyu) → `audio/tr/`.
  Tavan `HIVELZON_TR_TTS_MONTHLY_CHAR_CAP`, defter `kitaplar/_maliyet/patientdesk-karakter.json`.
- **İngilizce örnekler** (her `+` örnek ve her "Söyle" alıştırması ayrı parça): ElevenLabs zaman damgalı TTS
  (tts.py ile aynı uç nokta ve ayarlar; ses Sarah) → `audio/en/`. Tavan `HIVELZON_TTS_MONTHLY_CHAR_CAP`,
  defter `kitaplar/_maliyet/elevenlabs-karakter.json` (kitaplarla ortak aylık defter).
- `audio/lesson-audio.json`: kart → parçalar (dosya yolları, metin sha256, süre, Duyu kalitesi).

Kurallar (CLAUDE.md): varsayılan kuru çalışma; gerçek çağrı yalnız `execute_*` ile ve tavan tanımlıysa;
her parçadan önce tavan denetlenir; ödenmiş ham çıktı `_raw/` önbelleğinde tutulur, güncel çıktı varsa çağrı
yapılmaz (anahtar: metin + ses + model + ayar sha256'sı); her gerçek çağrı dersin PROMPTS.md'sine yazılır;
anahtarlar yalnız ortamdan, yalnız gerçek çağrıda okunur.
"""

from __future__ import annotations

import base64
import json
import os
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Callable

from . import tts, tts_tr
from .align import Alignment
from .lesson import AUDIO_DIR, AUDIO_MANIFEST, PROMPTS_FILE, EN_DIR, TR_DIR, EnSegment, Lesson, text_sha256

EN_PROMPTS_HEADING = "## İngilizce örnek seslendirme kayıtları (tts_lesson.py)"
EN_PROMPTS_TABLE = ("| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |\n"
                    "|---|---|---|---|---|---|---|---|")
RAW_DIR = "_raw"


# --- İngilizce plan ------------------------------------------------------------------------------

@dataclass
class EnJob:
    seg: EnSegment
    key: str
    action: str          # skip | tts | build
    reason: str

    @property
    def chars(self) -> int:
        return len(self.seg.text)


@dataclass
class EnPlan:
    out_dir: Path
    voice: str
    model: str
    speed: float
    jobs: list[EnJob] = field(default_factory=list)

    def raw_mp3(self, j: EnJob) -> Path:
        return self.out_dir / RAW_DIR / f"{j.key}.mp3"

    def raw_json(self, j: EnJob) -> Path:
        return self.out_dir / RAW_DIR / f"{j.key}.json"

    def audio(self, j: EnJob) -> Path:
        return self.out_dir / f"{j.seg.id}.mp3"

    def align(self, j: EnJob) -> Path:
        return self.out_dir / f"{j.seg.id}.align.json"

    @property
    def billable_chars(self) -> int:
        return sum(j.chars for j in self.jobs if j.action == "tts")

    def credits(self) -> float:
        return self.billable_chars * tts.CREDITS_PER_CHAR.get(self.model, 1.0)


def en_key(text: str, voice: str, model: str, speed: float) -> str:
    return text_sha256(json.dumps([text, voice, model, speed, tts.STABILITY, tts.SIMILARITY, tts.OUTPUT_FORMAT]))[:24]


def plan_en(segs: list[EnSegment], out_dir: Path, voice: str, model: str, speed: float, force: bool = False) -> EnPlan:
    plan = EnPlan(Path(out_dir), voice, model, float(speed))
    paid: set[str] = set()       # bu planda üretilecek anahtarlar: aynı metin bir kez ücretlenir
    for s in segs:
        j = EnJob(s, en_key(s.text, voice, model, plan.speed), "tts", "ses yok")
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
        if j.action != "skip" and plan.raw_mp3(j).exists() and plan.raw_json(j).exists():
            j.action, j.reason = "build", "ödenmiş ses önbellekte"
        elif j.action == "tts" and j.key in paid:
            j.action, j.reason = "build", "aynı metin bu planda daha önce üretiliyor (tek ücret)"
        if j.action == "tts":
            paid.add(j.key)
        plan.jobs.append(j)
    return plan


@dataclass
class LessonAudioPlan:
    lesson: Lesson
    tr: tts_tr.Plan
    en: EnPlan


def plan_lesson(lesson: Lesson, langs: tuple[str, ...] = ("tr", "en"), cards: list[str] | None = None,
                force: bool = False) -> LessonAudioPlan:
    if lesson.text.errors:
        raise tts.TtsError("lesson.md işaretleri hatalı: " + "; ".join(lesson.text.errors[:3]))
    keep = (lambda cid: cid in cards) if cards else (lambda cid: True)
    trv, env = lesson.tr_voice(), lesson.en_voice()
    tr_segs = [s for s in lesson.tr_segments() if keep(s.id[:-3])] if "tr" in langs else []
    en_segs = [s for s in lesson.en_segments() if keep(s.card)] if "en" in langs else []
    tr_plan = tts_tr.plan_segments(tr_segs, lesson.dir / AUDIO_DIR / TR_DIR, trv["voice"], trv["model"], force)
    en_plan = plan_en(en_segs, lesson.dir / AUDIO_DIR / EN_DIR, env["voiceId"], env["modelId"], env["speed"], force)
    return LessonAudioPlan(lesson, tr_plan, en_plan)


def describe(p: LessonAudioPlan) -> list[str]:
    out = [f"{p.lesson.id}: Türkçe anlatım (Alania {p.tr.model}, {p.tr.voice}; Duyu {tts_tr.STT_MODEL})"]
    out += ["  " + ln for ln in tts_tr.describe(p.tr)[1:]] or ["  (parça yok)"]
    label = {"skip": "ATLA", "tts": "ÜRET (ElevenLabs)", "build": "YEREL (ücret yok)"}
    out.append(f"{p.lesson.id}: İngilizce örnekler (ElevenLabs {p.en.model}, ses {p.en.voice}, hız {p.en.speed})")
    for j in p.en.jobs:
        out.append(f"    {j.seg.id}: {j.chars} karakter, {label[j.action]} — {j.reason}: {j.seg.text!r}")
    if not p.en.jobs:
        out.append("    (parça yok)")
    return out


# --- İngilizce yürütme ---------------------------------------------------------------------------

@dataclass
class EnResult:
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


def append_en_prompts(path: Path, row: dict) -> None:
    text = path.read_text(encoding="utf-8") if path.exists() else "# PROMPTS\n"
    if EN_PROMPTS_HEADING not in text:
        text = text.rstrip("\n") + f"\n\n{EN_PROMPTS_HEADING}\n\n{EN_PROMPTS_TABLE}\n"
    text = text if text.endswith("\n") else text + "\n"
    line = (f"| {row['date']} | {row['segment']} | {row['voice']} | {row['model']} | {row['speed']} | {row['chars']} | "
            f"{row['sha'][:16]} | {row['file']} |\n")
    _atomic_bytes(path, (text + line).encode("utf-8"))


def execute_en(plan: EnPlan, client: Callable[[str, dict], dict] | None, cap: int | None, ledger: Path,
               prompts: Path, now: Callable[[], datetime] | None = None,
               log: Callable[[str], None] = print) -> EnResult:
    if cap is None and any(j.action == "tts" for j in plan.jobs):
        raise tts.TtsError(f"aylık karakter tavanı tanımlı değil ({tts.ENV_CAP} ya da --en-cap); "
                           "tavan yoksa ücretli üretim kapalıdır (CLAUDE.md)")
    now = now or (lambda: datetime.now(timezone.utc))
    res = EnResult()
    for j in plan.jobs:
        sid = j.seg.id
        if j.action == "skip":
            res.skipped.append(sid)
            continue
        raw_mp3, raw_json = plan.raw_mp3(j), plan.raw_json(j)
        sha = text_sha256(j.seg.text)
        if not (raw_mp3.exists() and raw_json.exists()):
            month = tts.month_key(now())
            used = tts.ledger_used(ledger, month)
            if used + j.chars > cap:
                res.stopped = f"aylık tavan aşılır: bu ay {used} + {j.chars} > {cap} karakter; {sid} üretilmedi"
                log(res.stopped)
                return res
            resp = client(plan.voice, tts.payload(j.seg.text, plan.model, plan.speed))
            if "audio_base64" not in resp or "alignment" not in resp:
                raise tts.TtsError(f"{sid}: ElevenLabs yanıtında audio_base64/alignment yok")
            # Ödeme yapıldı: önce defter ve kayıt, sonra önbellek (çift ücret olmasın).
            tts.ledger_add(ledger, month, j.chars)
            append_en_prompts(prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "segment": sid,
                                        "voice": plan.voice, "model": plan.model, "speed": plan.speed,
                                        "chars": j.chars, "sha": sha, "file": f"audio/en/{sid}.mp3"})
            _atomic_bytes(raw_mp3, base64.b64decode(resp["audio_base64"]))
            _atomic_bytes(raw_json, (json.dumps({"text": j.seg.text, "alignment": resp["alignment"]},
                                                ensure_ascii=False) + "\n").encode("utf-8"))
            res.calls += 1
            res.chars += j.chars
            log(f"  {sid}: ElevenLabs {j.chars} karakter")
        else:
            log(f"  {sid}: önbellekten (ücret yok)")
        al = json.loads(raw_json.read_text(encoding="utf-8"))["alignment"]
        _atomic_bytes(plan.audio(j), raw_mp3.read_bytes())
        # Hizalama en son yazılır: idempotentlik denetimi ses + hizalama ikilisine bakar.
        doc = {"text": j.seg.text, "textSha256": sha, "key": j.key, "lang": "en", "voice_id": plan.voice,
               "model_id": plan.model, "speed": plan.speed, "alignment": al}
        _atomic_bytes(plan.align(j), (json.dumps(doc, ensure_ascii=False) + "\n").encode("utf-8"))
        res.generated.append(sid)
    return res


# --- ses haritası --------------------------------------------------------------------------------

def audio_manifest(lesson: Lesson) -> dict:
    """Kart → ses parçaları. Var olan dosyalara bakar; ağ çağrısı yapmaz."""
    trv, env = lesson.tr_voice(), lesson.en_voice()
    tr_by_card = {s.id[:-3]: s for s in lesson.tr_segments()}
    en_by_card: dict[str, list[EnSegment]] = {}
    for s in lesson.en_segments():
        en_by_card.setdefault(s.card, []).append(s)
    cards = []
    for c in lesson.cards:
        segs = []
        items = []
        if c.id in tr_by_card:
            s = tr_by_card[c.id]
            items.append(("tr", "narration", s.id, s.text, *lesson.tr_paths(s.id)))
        for s in en_by_card.get(c.id, []):
            items.append(("en", s.role, s.id, s.text, *lesson.en_paths(s.id)))
        for lang, role, sid, text, mp3, aj in items:
            sha = text_sha256(text)
            entry = {"id": sid, "lang": lang, "role": role, "text": text, "textSha256": sha, "chars": len(text),
                     "audio": f"{lang}/{mp3.name}", "align": f"{lang}/{aj.name}", "present": False,
                     "duration": None, "quality": None}
            if aj.exists():
                try:
                    doc = json.loads(aj.read_text(encoding="utf-8"))
                    entry["present"] = mp3.exists() and doc.get("textSha256") == sha
                    entry["duration"] = doc.get("duration") or round(Alignment.load(aj).end, 3)
                    entry["quality"] = doc.get("quality")
                except (OSError, ValueError, KeyError):
                    pass
            segs.append(entry)
        cards.append({"card": c.id, "type": c.type, "segments": segs})
    return {"schemaVersion": 1, "lessonId": lesson.id,
            "voices": {"tr": {"model": trv["model"], "voice": trv["voice"], "timing": tts_tr.STT_MODEL,
                              "instructions": trv.get("instructions")},
                       "en": {"model": env["modelId"], "voice": env["voiceId"], "speed": env["speed"]}},
            "cards": cards}


def write_manifest(lesson: Lesson) -> Path:
    p = lesson.dir / AUDIO_DIR / AUDIO_MANIFEST
    doc = audio_manifest(lesson)
    data = (json.dumps(doc, ensure_ascii=False, indent=1) + "\n").encode("utf-8")
    if not (p.exists() and p.read_bytes() == data):
        _atomic_bytes(p, data)
    return p


def prompts_path(lesson: Lesson) -> Path:
    return lesson.dir / PROMPTS_FILE
