"""Bağımsız konu reelleri (H-094; `docs/REEL-PAKETI.md`).

Kaynak biçimi kitap ve dilbilgisi dersleriyle aynı yaklaşımdadır: her reel
`<reel>/reel.json` dosyasıdır ve `/reels/<id>/…` altında sunulur. Reel, bir
bölüme bağlı olmayan, tek öğrenme hedefi taşıyan dikey kısa videodur
(`sourceType = standalone`); mevcut hikâye klipleri (`episode_clip`) ayrı
kalır.

`parse_reel` katı okuma yapar (eksik/bozuk alan → `ReelError`);
`lint_reel` hata ve uyarıları toplar. Ücretli çağrı yoktur.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from .cefr import LEVELS
from .graph import Issue

REEL_FILE = "reel.json"
SCHEMA_VERSION = 1

# Kimlik: <SEVİYE>-R-<KAT>-<NN> (ör. A1-R-CIN-01). Seviye ve kategori kimlikten
# okunur; paket klasör adı kimlikle aynı olmalıdır.
ID_RE = re.compile(r"^(A1|A2|B1|B2|C1|C2)-R-(CIN|SPO|BOK)-\d{2}$")

CATEGORIES = {"CIN": "Sinema", "SPO": "Spor", "BOK": "Kitap"}
STATUSES = ("DRAFT", "APPROVED", "PUBLISHED", "WITHDRAWN")
SOURCE_TYPES = ("standalone", "episode_clip")
TARGET_KINDS = ("phrase", "word")
RELATED_KINDS = ("episode", "book", "grammar")


class ReelError(ValueError):
    """`reel.json` okunamadı ya da zorunlu alan eksik/bozuk."""


@dataclass(frozen=True)
class Reel:
    """Doğrulanmış reel (`reel.json`)."""

    id: str
    level: str
    category: str
    title_tr: str
    duration: float
    content_version: int
    source_type: str
    status: str
    target_en: str
    target_tr: str
    target_cue: str | None
    cue_ids: tuple[str, ...]
    video: str
    poster: str | None
    image: str | None
    audio: str | None
    has_practice: bool

    @property
    def category_tr(self) -> str:
        return CATEGORIES.get(self.category, self.category)


def _require_str(doc: dict, key: str) -> str:
    v = doc.get(key)
    if not isinstance(v, str) or not v.strip():
        raise ReelError(f"`{key}` zorunlu (boş olamaz)")
    return v


def _require_num(doc: dict, key: str) -> float:
    v = doc.get(key)
    if not isinstance(v, (int, float)) or isinstance(v, bool):
        raise ReelError(f"`{key}` sayı olmalı")
    return float(v)


def _opt_str(doc: dict, key: str) -> str | None:
    v = doc.get(key)
    return v if isinstance(v, str) and v.strip() else None


def _cue_list(doc: dict) -> list[dict]:
    cues = doc.get("cues")
    if not isinstance(cues, list) or not cues:
        raise ReelError("`cues` boş olamaz")
    out: list[dict] = []
    for c in cues:
        if not isinstance(c, dict):
            raise ReelError("`cues` öğeleri nesne olmalı")
        out.append(c)
    return out


def parse_reel(doc: dict) -> Reel:
    """`reel.json` sözlüğünü katı biçimde [Reel]'a çevirir.

    Zorunlu alanlar eksikse [ReelError] yükseltir; denetim listesi değildir
    ([lint_reel] hata/uyarı toplar).
    """
    if not isinstance(doc, dict):
        raise ReelError("reel.json bir nesne olmalı")
    if doc.get("schemaVersion") != SCHEMA_VERSION:
        raise ReelError(f"schemaVersion {SCHEMA_VERSION} bekleniyordu")

    reel_id = _require_str(doc, "id")
    level = _require_str(doc, "level")
    category = _require_str(doc, "category")
    title_tr = _require_str(doc, "titleTr")
    duration = _require_num(doc, "duration")
    video = _require_str(doc, "video")

    target = doc.get("target")
    if not isinstance(target, dict):
        raise ReelError("`target` nesne olmalı")
    target_en = _require_str(target, "en")
    target_tr = _require_str(target, "tr")

    cues = _cue_list(doc)
    cue_ids = tuple(c["id"] for c in cues if isinstance(c.get("id"), str))

    version = doc.get("contentVersion")
    if not isinstance(version, int) or isinstance(version, bool) or version < 1:
        raise ReelError("`contentVersion` 1'den büyük tam sayı olmalı")

    return Reel(
        id=reel_id,
        level=level,
        category=category,
        title_tr=title_tr,
        duration=duration,
        content_version=version,
        source_type=doc.get("sourceType", "standalone"),
        status=doc.get("status", "DRAFT"),
        target_en=target_en,
        target_tr=target_tr,
        target_cue=_opt_str(target, "cue"),
        cue_ids=cue_ids,
        video=video,
        poster=_opt_str(doc, "poster"),
        image=_opt_str(doc, "image"),
        audio=_opt_str(doc, "audio"),
        has_practice=isinstance(doc.get("practice"), dict),
    )


def reel_file(path: Path) -> Path:
    """`reel.json` yolunu bulur: `_build/package/` varsa o, yoksa kaynak klasör."""
    if path.is_file():
        return path
    built = path / "_build" / "package" / REEL_FILE
    if built.is_file():
        return built
    return path / REEL_FILE


def reel_folder(path: Path) -> str:
    """Reel kimliğini taşıyan klasör adı (`_build/package` düzeninde üst klasör)."""
    p = path if path.is_dir() else path.parent
    if p.name == "package" and p.parent.name == "_build":
        return p.parent.parent.name
    return p.name


def load_reel(path: Path) -> Reel:
    """`reel.json` dosyasını okur ([path] klasör, `_build/package` ya da dosya olabilir)."""
    file = reel_file(path)
    try:
        doc = json.loads(file.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ReelError(f"{file} okunamadı: {exc}") from exc
    except ValueError as exc:
        raise ReelError(f"{file} bozuk JSON: {exc}") from exc
    return parse_reel(doc)


@dataclass
class ReelReport:
    """Bir reel paketinin denetim sonucu."""

    path: Path
    reel: Reel | None = None
    issues: list[Issue] = field(default_factory=list)

    @property
    def errors(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "error"]

    @property
    def warnings(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "warning"]

    @property
    def ok(self) -> bool:
        return not self.errors


def _err(code: str, message: str) -> Issue:
    return Issue("error", code, message)


def _warn(code: str, message: str) -> Issue:
    return Issue("warning", code, message)


def _check_practice(doc: dict, issues: list[Issue]) -> None:
    practice = doc.get("practice")
    if practice is None:
        return
    if not isinstance(practice, dict):
        issues.append(_err("reel.practice", "practice nesne olmalı"))
        return
    if not isinstance(practice.get("promptTr"), str) or not practice["promptTr"].strip():
        issues.append(_err("reel.practice.prompt", "sorunun Türkçesi boş olamaz"))
    options = practice.get("options")
    if not isinstance(options, list) or len(options) < 2:
        issues.append(_err("reel.practice.options", "en az iki seçenek gerekir"))
        return
    correct = [o for o in options if isinstance(o, dict) and o.get("correct") is True]
    if len(correct) != 1:
        issues.append(
            _err(
                "reel.practice.correct",
                f"tam olarak bir doğru seçenek olmalı (bulunan: {len(correct)})",
            )
        )
    for o in options:
        if not isinstance(o, dict) or not isinstance(o.get("text"), str) or not o["text"].strip():
            issues.append(_err("reel.practice.option", "seçenek metni boş olamaz"))


def _check_related(doc: dict, issues: list[Issue]) -> None:
    related = doc.get("related")
    if related is None:
        return
    if not isinstance(related, list):
        issues.append(_err("reel.related", "related liste olmalı"))
        return
    for r in related:
        if not isinstance(r, dict) or r.get("kind") not in RELATED_KINDS:
            issues.append(
                _err("reel.related.kind", f"kind {RELATED_KINDS} içinde olmalı")
            )
            continue
        if not isinstance(r.get("id"), str) or not r["id"].strip():
            issues.append(_err("reel.related.id", "bağ kimliği boş olamaz"))


def _check_cues(doc: dict, issues: list[Issue]) -> None:
    cues = doc.get("cues")
    if not isinstance(cues, list) or not cues:
        issues.append(_err("reel.cues", "en az bir altyazı satırı gerekir"))
        return
    seen: set[str] = set()
    for c in cues:
        if not isinstance(c, dict):
            issues.append(_err("reel.cue", "satır nesne olmalı"))
            continue
        cid = c.get("id")
        if not isinstance(cid, str) or not cid.strip():
            issues.append(_err("reel.cue.id", "satır kimliği boş olamaz"))
            continue
        if cid in seen:
            issues.append(_err("reel.cue.duplicate", f"satır kimliği yineleniyor: {cid}"))
        seen.add(cid)
        if not isinstance(c.get("text"), str) or not c["text"].strip():
            issues.append(_err("reel.cue.text", f"{cid}: İngilizce metin boş olamaz"))
        start, end = c.get("start"), c.get("end")
        if not isinstance(start, (int, float)) or not isinstance(end, (int, float)):
            issues.append(_err("reel.cue.time", f"{cid}: başlangıç/bitiş sayı olmalı"))
        elif end <= start:
            issues.append(_err("reel.cue.time", f"{cid}: bitiş başlangıçtan sonra olmalı"))


def _check_media(root: Path, reel: Reel, issues: list[Issue]) -> None:
    """Medya dosyaları henüz üretilmemiş olabilir; eksikse **uyarı** (H-094 P0)."""
    for label, rel in (
        ("video", reel.video),
        ("poster", reel.poster),
        ("görsel", reel.image),
        ("ses", reel.audio),
    ):
        if rel and not (root / rel).exists():
            issues.append(_warn("reel.media", f"{label} dosyası yok: {rel}"))


def _check_audio_fit(root: Path, issues: list[Issue]) -> None:
    """Ses satırı kare süresine sığmıyorsa kurguda **kesilir** → hata (H-094 §8).

    Yalnız üretim tarafında anlamlıdır: `shots.json` ve `_raw/tts/timing.json`
    varsa denetlenir; ses henüz üretilmemişse (cue zamanlamada yoksa) atlanır.
    """
    shots_file = root / "shots.json"
    timing_file = root / "_raw" / "tts" / "timing.json"
    if not shots_file.is_file() or not timing_file.is_file():
        return
    try:
        shots = json.loads(shots_file.read_text(encoding="utf-8"))
        timing = json.loads(timing_file.read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        issues.append(_err("reel.audio.fit", f"zamanlama okunamadı: {exc}"))
        return
    if not isinstance(timing, dict):
        return
    from .media import AOFF as default_aoff

    for seg in shots.get("timeline") or []:
        cue = (seg or {}).get("audio")
        if not cue or cue not in timing:
            continue
        free = float(seg.get("len", 0)) - float(seg.get("aoff", default_aoff))
        length = float(timing[cue])
        if length > free + 1e-6:
            issues.append(
                _err(
                    "reel.audio.fit",
                    f"{seg.get('shot')}: {cue} {length:.2f} sn, kare {free:.2f} sn → ses kesilir",
                )
            )


def _check_cue_windows(root: Path, doc: dict, issues: list[Issue], built: bool) -> None:
    """Alt yazı (cue) zamanı kurgudaki çekimle aynı yerde mi? (H-094 §8)

    Çekim süresi değişince elle yazılan cue zamanları kayar; alt yazı sesten ayrı
    düşer. Kaynak `reel.json` elle yazılır → **uyarı** (pakette `build_reel.py`
    yeniden hizalar). Kurulmuş pakette ise hiza zorunlu → **hata**.
    """
    shots_file = root / "shots.json"
    if not shots_file.is_file():
        return
    try:
        shots = json.loads(shots_file.read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        issues.append(_err("reel.cue.window", f"shots.json okunamadı: {exc}"))
        return
    from .media import AOFF as default_aoff
    from .media import XFADE

    timeline = shots.get("timeline") or []
    starts: list[float] = []
    acc = 0.0
    for i, seg in enumerate(timeline):
        if i:
            acc -= XFADE
        starts.append(acc)
        acc += float(seg.get("len", 0))
    by_cue = {seg.get("audio"): i for i, seg in enumerate(timeline) if seg.get("audio")}
    for cue in doc.get("cues", []) or []:
        i = by_cue.get(cue.get("id"))
        if i is None:
            continue
        shot = timeline[i]["shot"]
        expected = starts[i] + float(timeline[i].get("aoff", default_aoff))
        start = float(cue.get("start", -1))
        end = float(cue.get("end", 0))
        add = _err if built else _warn
        if abs(start - expected) > 0.1:
            issues.append(
                add(
                    "reel.cue.window",
                    f"{cue.get('id')}: alt yazı {start:.2f} sn'de, ses {expected:.2f} sn'de başlıyor ({shot})",
                )
            )
        elif end > starts[i] + float(timeline[i].get("len", 0)) + 0.05:
            issues.append(
                add(
                    "reel.cue.window",
                    f"{cue.get('id')}: alt yazı {shot} çekiminin sonunu aşıyor ({end:.2f} sn)",
                )
            )


def lint_reel(root: Path) -> ReelReport:
    """`reel.json` paketini denetler (kimlik, kategori, hedef, soru, medya)."""
    file = reel_file(root)
    report = ReelReport(path=file.parent)
    try:
        doc = json.loads(file.read_text(encoding="utf-8"))
    except OSError as exc:
        report.issues.append(_err("reel.file", f"{file} okunamadı: {exc}"))
        return report
    except ValueError as exc:
        report.issues.append(_err("reel.file", f"{file} bozuk JSON: {exc}"))
        return report

    if not isinstance(doc, dict) or doc.get("schemaVersion") != SCHEMA_VERSION:
        report.issues.append(
            _err("reel.schemaVersion", f"schemaVersion {SCHEMA_VERSION} bekleniyordu")
        )
        return report

    try:
        reel = parse_reel(doc)
    except ReelError as exc:
        report.issues.append(_err("reel.required", str(exc)))
        return report
    report.reel = reel

    folder = reel_folder(root)
    if not ID_RE.match(reel.id):
        report.issues.append(
            _err("reel.id", f"kimlik kalıbı <SEVİYE>-R-<KAT>-<NN> olmalı: {reel.id}")
        )
    else:
        level, category = ID_RE.match(reel.id).groups()  # type: ignore[union-attr]
        if level != reel.level:
            report.issues.append(
                _err("reel.id.level", f"kimlik seviyesi ({level}) ile level ({reel.level}) uyuşmuyor")
            )
        if category != reel.category:
            report.issues.append(
                _err(
                    "reel.id.category",
                    f"kimlik kategorisi ({category}) ile category ({reel.category}) uyuşmuyor",
                )
            )
    if folder != reel.id:
        report.issues.append(
            _err("reel.folder", f"klasör adı ({folder}) kimlikle aynı olmalı: {reel.id}")
        )

    if reel.level not in LEVELS:
        report.issues.append(_err("reel.level", f"bilinmeyen seviye: {reel.level}"))
    if reel.category not in CATEGORIES:
        report.issues.append(_err("reel.category", f"bilinmeyen kategori: {reel.category}"))
    if reel.source_type not in SOURCE_TYPES:
        report.issues.append(_err("reel.sourceType", f"bilinmeyen tür: {reel.source_type}"))
    elif reel.source_type != "standalone":
        report.issues.append(
            _err(
                "reel.sourceType",
                "`/reels/` paketi bağımsız olmalı (standalone); hikâye klibi clips.json'dadır",
            )
        )
    if reel.status not in STATUSES:
        report.issues.append(_err("reel.status", f"bilinmeyen durum: {reel.status}"))
    if reel.duration <= 0:
        report.issues.append(_err("reel.duration", "süre sıfırdan büyük olmalı"))

    kind = (doc.get("target") or {}).get("kind")
    if kind not in TARGET_KINDS:
        report.issues.append(
            _err("reel.target.kind", f"kind {TARGET_KINDS} içinde olmalı: {kind}")
        )
    if reel.target_cue and reel.target_cue not in reel.cue_ids:
        report.issues.append(
            _err("reel.target.cue", f"hedef satırı altyazıda yok: {reel.target_cue}")
        )

    _check_cues(doc, report.issues)
    _check_practice(doc, report.issues)
    _check_related(doc, report.issues)
    _check_media(report.path, reel, report.issues)
    source = (
        report.path.parent.parent
        if report.path.name == "package" and report.path.parent.name == "_build"
        else report.path
    )
    _check_audio_fit(source, report.issues)
    _check_cue_windows(source, doc, report.issues, built=report.path != source)
    return report


def discover_reels(root: Path) -> list[Path]:
    """Reel paketleri: `<reel>/reel.json` (ya da hazırsa `<reel>/_build/package/reel.json`).

    Kitap ve dilbilgisi dersleriyle aynı yaklaşım: kaynak klasör depoda, paket
    çıktısı `_build/`; `_` ile başlayan klasörler atlanır.
    """
    if not root.is_dir():
        return []
    return [
        f
        for d in sorted(p for p in root.iterdir() if p.is_dir() and not p.name.startswith("_"))
        for f in [reel_file(d)]
        if f.is_file()
    ]


def write_reports(reports: list[ReelReport]) -> list[Path]:
    """Reel başına lint özeti: `<reel>/_build/lint.json` (H-094 P4).

    Backend içe aktarması hata/uyarı sayısını buradan alır; rapor `reel.json`'dan
    (üretim paketindeyse paket dosyasından) eskiyse yok sayılır. Atomik yazılır:
    önce `.json.tmp`, sonra yerine taşınır.
    """
    import os
    from datetime import datetime, timezone

    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    written: list[Path] = []
    for r in reports:
        root = r.path
        if root.name == "package" and root.parent.name == "_build":
            root = root.parent.parent
        doc = {
            "tool": "reel-lint",
            "schemaVersion": 1,
            "contentId": r.reel.id if r.reel else root.name,
            "level": r.reel.level if r.reel else None,
            "generatedAt": now,
            "errors": [str(i) for i in r.errors],
            "warnings": [str(i) for i in r.warnings],
        }
        out = root / "_build" / "lint.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        tmp = out.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        os.replace(tmp, out)
        written.append(out)
    return written


def as_dict(report: ReelReport) -> dict[str, Any]:
    """`--json` çıktısı: makine okunur özet."""
    return {
        "path": str(report.path),
        "id": report.reel.id if report.reel else None,
        "errors": len(report.errors),
        "warnings": len(report.warnings),
        "issues": [
            {"level": i.level, "code": i.code, "message": i.message} for i in report.issues
        ],
    }
