"""Dilbilgisi dersi paketi (H-077): `dilbilgisi/<G-ID>/_build/package/`.

    lesson.json    meta veri (+ `durations`, `estimatedMinutes`, `cardCount`, `teacherReviewed`); şema lesson.schema.json
    cards.json     kartlar: Türkçe anlatım cümleleri + kelime zamanları, örnekler (ses, hedef aralıkları, kelime
                   zamanları), yanlış biçimler, şemalar, alıştırma, "Hikâyede gör" derin bağları; şema cards.schema.json
    audio/<parça>.m4a   AAC, -16 LUFS (her parça ayrı ölçülür; parçalar ayrı çalınır)
    manifest.json  dosya listesi, boyut, sha256, ses düzeyi, metin sha256, eksik medya

Yalnızca yerel ffmpeg kullanılır (bookexport.LocalMedia); ücretli servis çağrısı yoktur. Eksik ses (git dışı)
paketi durdurmaz: `manifest.missing` listesine yazılır (`--require-media` ile hata). Hizalama metinle
uyuşmazsa (metin TTS'ten sonra değişmiş) paket üretilmez.
"""

from __future__ import annotations

import json
import shutil
from dataclasses import dataclass, field
from pathlib import Path

from .align import Alignment, AlignmentMismatch, sentence_timings
from .bookexport import LocalMedia
from .build import TOOL_ID, file_digest
from .graph import schema_errors
from .lesson import Lesson, LessonError, text_sha256
from .storylinks import StoryIndex

PACKAGE_SCHEMA_VERSION = 1
AUDIO_EXT = ".m4a"
PRACTICE_SECONDS = 10.0          # tahmini süre: alıştırma başına
MIN_MEASURABLE_LUFS = -70.0


@dataclass
class LessonExport:
    lesson_id: str
    package: Path
    lesson: dict
    cards: dict
    manifest: dict
    missing: list[dict] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)


def _timings(align: Path, texts: list[str], sid: str, expect_sha: str) -> list[dict]:
    doc = json.loads(align.read_text(encoding="utf-8"))
    if doc.get("textSha256") and doc["textSha256"] != expect_sha:
        raise LessonError(f"{sid}: hizalama başka bir metinden (textSha256 farklı); tts_lesson.py ile yeniden üret")
    try:
        return sentence_timings(Alignment.load(align), texts)
    except AlignmentMismatch as e:
        raise LessonError(f"{sid}: {e} (tts_lesson.py ile yeniden üret)") from e


def export_lesson(lesson_dir: Path, media=None, icerik_root: Path | None = None, books_root: Path | None = None,
                  clean: bool = True) -> LessonExport:
    lesson = Lesson.load(lesson_dir)
    if lesson.text.errors:
        raise LessonError("lesson.md işaretleri hatalı: " + "; ".join(lesson.text.errors[:3]))
    media = media or LocalMedia()
    pkg = lesson.dir / "_build" / "package"
    if clean and pkg.exists():
        shutil.rmtree(pkg)
    pkg.mkdir(parents=True, exist_ok=True)
    missing: list[dict] = []
    errors: list[str] = []
    loud: dict[str, dict] = {}
    index = StoryIndex(icerik_root, books_root)

    def audio(sid: str, mp3: Path, aj: Path, texts: list[str], text: str) -> tuple[list[dict] | None, str | None, float | None]:
        """(zamanlar, paket ses yolu, süre). Hizalama yoksa zamansız; ses yoksa sessiz."""
        if not aj.exists():
            missing.append({"kind": "alignment", "segment": sid, "path": str(aj.relative_to(lesson.dir))})
            return None, None, None
        t = _timings(aj, texts, sid, text_sha256(text))
        if not mp3.exists():
            missing.append({"kind": "audio", "segment": sid, "path": str(mp3.relative_to(lesson.dir))})
            return t, None, None
        before = media.loudness([mp3])
        i = before.get("I")
        gain = media.target_lufs - i if isinstance(i, (int, float)) and i > MIN_MEASURABLE_LUFS else 0.0
        rel = f"audio/{sid}{AUDIO_EXT}"
        media.audio(mp3, gain, pkg / rel)
        dur = round(media.duration(pkg / rel), 3)
        loud[sid] = {"before": i, "gainDb": round(gain, 2)}
        last = max((x["end"] for x in t if x["end"] is not None), default=0.0)
        if last > dur + 0.05:
            errors.append(f"{sid}: zamanlar ses süresini aşıyor ({last} > {dur} sn)")
        return t, rel, dur

    def words(t: dict | None, text: str) -> list[dict]:
        if t and t["words"]:
            return [dict(w) for w in t["words"]]
        return [{"w": w, "start": None, "end": None} for w in text.split()]

    cards_out = []
    narr_total = ex_total = 0.0
    narr_any = ex_any = False
    per_card: dict[str, float] = {}
    for c in lesson.cards:
        card: dict = {"id": c.id, "type": c.type}
        if c.title:
            card["title"] = c.title
        card["narration"] = None
        if c.paragraphs:
            sents = c.sentences
            mp3, aj = lesson.tr_paths(c.tr_segment_id)
            t, rel, dur = audio(c.tr_segment_id, mp3, aj, sents, c.narration)
            card["narration"] = {"lang": "tr", "text": c.narration, "audio": rel, "duration": dur,
                                 "sentences": [{"text": s, "start": t[k]["start"] if t else None,
                                                "end": t[k]["end"] if t else None, "words": words(t[k] if t else None, s)}
                                               for k, s in enumerate(sents)]}
            if dur:
                narr_total += dur
                narr_any = True
                per_card[c.id] = per_card.get(c.id, 0.0) + dur
        examples = []
        for e in c.right:
            mp3, aj = lesson.en_paths(e.id)
            t, rel, dur = audio(e.id, mp3, aj, [e.en], e.en)
            t0 = t[0] if t else None
            examples.append({"id": e.id, "en": e.en, "tr": e.tr, "targets": e.targets, "audio": rel, "duration": dur,
                             "start": t0["start"] if t0 else None, "end": t0["end"] if t0 else None,
                             "words": words(t0, e.en)})
            if dur:
                ex_total += dur
                ex_any = True
                per_card[c.id] = per_card.get(c.id, 0.0) + dur
        card["examples"] = examples
        card["wrong"] = [{"id": e.id, "en": e.en, **({"tr": e.tr} if e.tr else {})} for e in c.wrong]
        card["diagrams"] = [d.spec for d in c.diagrams]
        practice = []
        for p in c.practice:
            item: dict = {"id": p.id, "kind": p.kind}
            if p.kind == "choose":
                item["stem"] = p.stem
                item["options"] = [{"text": o, "correct": k in p.correct} for k, o in enumerate(p.options)]
            elif p.kind == "fill":
                item["stem"] = p.stem
                item["answers"] = p.answers
            elif p.kind == "order":
                item["tokens"] = p.tokens
                item["answer"] = p.answers[0] if p.answers else ""
            elif p.kind == "say":
                item["text"] = p.stem
                if p.tr:
                    item["tr"] = p.tr
                mp3, aj = lesson.en_paths(p.id)
                t, rel, dur = audio(p.id, mp3, aj, [p.stem], p.stem)
                item["audio"], item["duration"] = rel, dur
                item["words"] = words(t[0] if t else None, p.stem)
                if dur:
                    ex_total += dur
                    ex_any = True
                    per_card[c.id] = per_card.get(c.id, 0.0) + dur
            if p.feedback:
                item["feedbackTr"] = p.feedback
            practice.append(item)
        card["practice"] = practice
        links = []
        for ln in c.links:
            r = index.resolve(ln.kind, ln.target, ln.text, ln.hint)
            if r.error:
                errors.append(f"{c.id}: {r.error}")
                continue
            links.append(r.target)
        card["links"] = links
        cards_out.append(card)

    cards_doc = {"schemaVersion": PACKAGE_SCHEMA_VERSION, "lessonId": lesson.id,
                 "contentVersion": lesson.meta.get("contentVersion", 1), "level": lesson.level, "cards": cards_out}

    m = lesson.meta
    keep = ("schemaVersion", "id", "level", "titleTr", "titleEn", "goalTr", "prerequisites", "contentVersion",
            "status", "aiGenerated", "linksTo")
    lesson_doc = {k: m[k] for k in keep if k in m}
    tr = m.get("teacherReview")
    lesson_doc["teacherReview"] = {"by": tr["by"], "at": tr["at"]} if isinstance(tr, dict) and tr.get("by") else None
    total = (narr_total + ex_total) if (narr_any or ex_any) else None
    n_practice = sum(len(c.practice) for c in lesson.cards)
    lesson_doc.update({
        "cardCount": len(lesson.cards),
        "teacherReviewed": lesson_doc["teacherReview"] is not None,
        "durations": {"narration": round(narr_total, 3) if narr_any else None,
                      "examples": round(ex_total, 3) if ex_any else None,
                      "total": round(total, 3) if total is not None else None,
                      "cards": {k: round(v, 3) for k, v in per_card.items()}},
        "estimatedMinutes": round((total + PRACTICE_SECONDS * n_practice) / 60.0, 1) if total is not None else None,
    })

    for name, doc, schema in (("lesson.json", lesson_doc, "lesson.schema.json"), ("cards.json", cards_doc, "cards.schema.json")):
        errors += [f"{name}: {e}" for e in schema_errors(doc, schema)]
        (pkg / name).write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")

    files = sorted(p for p in pkg.rglob("*") if p.is_file() and p.name != "manifest.json")
    seg_text = {s.id: s.text for s in lesson.tr_segments()} | {s.id: s.text for s in lesson.en_segments()}
    manifest = {
        "schemaVersion": 1,
        "contentId": lesson.id,
        "contentType": "GRAMMAR_LESSON",
        "contentVersion": m.get("contentVersion", 1),
        "tool": TOOL_ID,
        "textSha256": {k: text_sha256(v) for k, v in seg_text.items()},
        "loudness": {"targetLUFS": media.target_lufs, "segments": loud} if loud else None,
        "missing": missing,
        "files": [{"path": str(p.relative_to(pkg)), "bytes": p.stat().st_size, "sha256": file_digest(p)}
                  for p in files],
    }
    manifest["totalBytes"] = sum(f["bytes"] for f in manifest["files"])
    (pkg / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return LessonExport(lesson.id, pkg, lesson_doc, cards_doc, manifest, missing, errors)
