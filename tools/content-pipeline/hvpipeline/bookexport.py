"""Kitap paketi dışa aktarma (H-066): `kitaplar/<id>/_build/package/`.

    book.json      meta veri; bölümlere `audio`, `duration`; sayfalara paket görsel yolu
    pages.json     sayfa → cümle → kelime; `start`/`end` sn (bölüm sesi içinde), `tr`, `gloss`
    audio/<bölüm>.m4a   AAC 96k, -16 LUFS (kitabın bütün bölümleri birlikte ölçülür, tek kazanç)
    images/<sayfa>.webp ve images/cover.webp   genişlik 1080, WebP q80
    manifest.json  dosya listesi, boyut, sha256, ses düzeyi, anlatım temposu, eksik medya

Anlatım temposu (H-069, pacing.py): `narration.pacing` (yoksa seviye varsayılanı) etkinse bölüm sesi
cümle sınırlarından kesilir, sessizlik eklenir, gerekirse `atempo` ile yavaşlatılır; pages.json zamanları
işlenmiş sese göre yeniden hesaplanır. Ses düzeyi (-16 LUFS) her zaman son adımdır.

Yalnızca yerel ffmpeg/ImageMagick kullanılır (media.py); ücretli servis çağrısı yoktur.
Eksik medya (git dışı ses ve görseller) paketi durdurmaz: `manifest.missing` listesine yazılır ve
CLI'de uyarı olarak gösterilir (`--require-media` ile hata).
"""

from __future__ import annotations

import json
import shutil
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

from . import pacing
from .align import Alignment, AlignmentMismatch, sentence_timings
from .book import Book, BookError, text_sha256
from .booklint import annotate, load_translation, word_count
from .build import TOOL_ID, file_digest
from .graph import schema_errors
from .translation import Miss, norm_text

PACKAGE_SCHEMA_VERSION = 1
AUDIO_EXT = ".m4a"
IMAGE_WIDTH = 1080


class LocalMedia:
    """media.py arka ucu (ffmpeg + ImageMagick). Testlerde sahte bir nesneyle değiştirilir."""

    def __init__(self):
        from . import media
        self.m = media

    def loudness(self, paths: list[Path]) -> dict:
        return self.m.loudness(paths)

    def audio(self, src: Path, gain_db: float, out: Path) -> Path:
        return self.m.audio_clip(src, gain_db, out)

    def duration(self, path: Path) -> float:
        return self.m.probe_duration(path)

    def image(self, src: Path, out: Path) -> Path:
        return self.m.scene_webp(src, out, width=IMAGE_WIDTH)

    def samples(self, path: Path) -> int:
        return self.m.probe_samples(path)

    def envelope(self, path: Path) -> list[float]:
        return self.m.envelope(path)

    def pace(self, src: Path, plan: "pacing.ChapterPacing", out: Path) -> Path:
        return self.m.pace_audio(src, plan.segments(), plan.tempo, out)

    @property
    def target_lufs(self) -> float:
        return self.m.TARGET_LUFS


@dataclass
class BookExport:
    book_id: str
    package: Path
    book: dict
    pages: dict
    manifest: dict
    missing: list[dict] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)
    translation_misses: list[Miss] = field(default_factory=list)
    pacing: dict = field(default_factory=dict)


def _sentence(tr, s, timing: dict | None, misses: list[Miss]) -> dict:
    if timing and timing["words"]:
        words = [dict(w) for w in timing["words"]]
    else:
        words = [{"w": w, "start": None, "end": None} for w in norm_text(s.text).split(" ")]
    if tr is not None:
        tr_text, glosses, chunks = annotate(tr, s.text, [w["w"] for w in words], s.id, misses)
    else:
        tr_text, glosses, chunks = None, [None] * len(words), []
    for w, g in zip(words, glosses):
        w["gloss"] = g
    return {"id": s.id, "paragraph": s.paragraph, "text": s.text,
            "start": timing["start"] if timing else None, "end": timing["end"] if timing else None,
            "tr": tr_text, "words": words, "chunks": chunks}


def export_book(book_dir: Path, media=None, clean: bool = True) -> BookExport:
    book = Book.load(book_dir)
    if book.text.errors:
        raise BookError("text.en.md işaretleri hatalı: " + "; ".join(book.text.errors[:3]))
    media = media or LocalMedia()
    pkg = book.dir / "_build" / "package"
    if clean and pkg.exists():
        shutil.rmtree(pkg)
    pkg.mkdir(parents=True, exist_ok=True)
    tr = load_translation(book)
    misses: list[Miss] = []
    missing: list[dict] = []
    errors: list[str] = []

    # 1) Zamanlama: bölüm başına hizalama → cümle ve kelime zamanları
    timings: dict[str, list[dict] | None] = {}
    for c in book.text.chapters:
        ap = book.align_path(c.id)
        if not ap.exists():
            timings[c.id] = None
            missing.append({"kind": "alignment", "chapter": c.id, "path": str(ap.relative_to(book.dir))})
            continue
        try:
            timings[c.id] = sentence_timings(Alignment.load(ap), [s.text for s in c.spoken()])
        except AlignmentMismatch as e:
            raise BookError(f"{c.id}: {e} (metin TTS'ten sonra değişti; tts_book.py ile sesi yeniden üret)") from e

    # 2) Ses: var olan bölüm seslerinin birleşik ölçümünden tek kazanç (kitap içi tutarlılık)
    sources = {c.id: book.audio_path(c.id) for c in book.text.chapters}
    present = {cid: p for cid, p in sources.items() if p.exists()}
    for cid, p in sources.items():
        if cid not in present:
            missing.append({"kind": "audio", "chapter": cid, "path": str(p.relative_to(book.dir))})
    try:
        cfg = pacing.settings(book.meta, book.level)
    except pacing.PacingError as e:
        raise BookError(str(e)) from e
    units = {c.id: pacing.chapter_units(c) for c in book.text.chapters}
    plans: dict[str, pacing.ChapterPacing | None] = {}
    loud = None
    audio_rel: dict[str, str] = {}
    durations: dict[str, float] = {}
    with tempfile.TemporaryDirectory(prefix="hv-pacing-") as work:
        # 2a) Anlatım temposu (H-069): kesim + sessizlik + atempo → geçici WAV
        inputs: dict[str, Path] = {}
        for cid, src in present.items():
            t = timings.get(cid)
            plan = None
            if t is not None and cfg["mode"] != "off":
                end = media.samples(src) / pacing.SR
                plan = pacing.plan_chapter(t, units[cid], cfg, book.level, end, env=media.envelope(src))
            plans[cid] = plan
            if plan is not None:
                inputs[cid] = media.pace(src, plan, Path(work) / f"{cid}.paced.wav")
            else:
                inputs[cid] = src
        # 2b) Ses düzeyi son adım: işlenmiş seslerin birleşik ölçümünden tek kazanç
        if inputs:
            before = media.loudness(list(inputs.values()))
            gain = media.target_lufs - before["I"]
            for cid, src in inputs.items():
                rel = f"audio/{cid}{AUDIO_EXT}"
                media.audio(src, gain, pkg / rel)
                audio_rel[cid] = rel
                durations[cid] = round(media.duration(pkg / rel), 3)
            after = media.loudness([pkg / r for r in audio_rel.values()])
            loud = {"targetLUFS": media.target_lufs, "gainDb": round(gain, 2), "before": before, "after": after}

    # 2c) Zamanlar işlenmiş sese taşınır. Sesi bu ortamda olmayan bölümde plan hizalamadan kurulur
    #     (zaman eşlemesi kesim yerinden bağımsızdır; ses gelince aynı zamanlar çıkar).
    pace_report: dict[str, dict] = {}
    for c in book.text.chapters:
        t = timings.get(c.id)
        if t is None:
            continue
        if c.id not in plans and cfg["mode"] != "off":
            plans[c.id] = pacing.plan_chapter(t, units[c.id], cfg, book.level, pacing.spoken(t)[-1]["end"]
                                              if pacing.spoken(t) else 0.0)
        plan = plans.get(c.id)
        paced = pacing.apply(t, plan)
        raw_wpm, new_wpm = pacing.wpm(t), pacing.wpm(paced)
        pace_report[c.id] = {**(plan.describe() if plan else {"mode": cfg["mode"], "sentencePauseSec": 0.0,
                                                               "tempo": 1.0, "insertedSec": 0.0}),
                             "applied": plan is not None,
                             "wpmRaw": round(raw_wpm, 1) if raw_wpm else None,
                             "wpm": round(new_wpm, 1) if new_wpm else None}
        timings[c.id] = paced
        last = max((x["end"] for x in pacing.spoken(paced)), default=0.0)
        # işlenmiş seste zamanlar örnek düzeyinde kesin: aşım bir hata işaretidir (işlenmemiş seste eski davranış)
        if plan is not None and c.id in durations and last > durations[c.id] + 0.05:
            errors.append(f"{c.id}: zamanlar ses süresini aşıyor ({last} > {durations[c.id]} sn)")

    # 3) Görseller
    def image(name: str | None, out_stem: str) -> str | None:
        if not name:
            return None
        src = book.image_path(name)
        if not src.exists():
            missing.append({"kind": "image", "path": f"images/{name}"})
            return None
        rel = f"images/{out_stem}.webp"
        media.image(src, pkg / rel)
        return rel

    page_meta = book.page_meta()
    page_images = {p.id: image(page_meta.get(p.id, {}).get("image"), p.id) for p in book.text.pages}
    cover = image(book.meta.get("cover"), "cover")

    # 4) pages.json
    chapters, pages = [], []
    for c in book.text.chapters:
        t = timings.get(c.id)
        heading = _sentence(tr, c.heading, t[0] if t else None, misses)
        k = 1
        for p in c.pages:
            sents = []
            for s in p.sentences:
                sents.append(_sentence(tr, s, t[k] if t else None, misses))
                k += 1
            pages.append({"id": p.id, "number": p.number, "chapter": c.id, "image": page_images[p.id],
                          "sentences": sents})
        chapters.append({"id": c.id, "title": c.title, "audio": audio_rel.get(c.id),
                         "duration": durations.get(c.id), "heading": heading, "pages": [p.id for p in c.pages]})
    pages_doc = {"schemaVersion": PACKAGE_SCHEMA_VERSION, "bookId": book.id,
                 "contentVersion": book.meta.get("contentVersion", 1), "level": book.level,
                 "chapters": chapters, "pages": pages}

    # 5) book.json (paket)
    m = book.meta
    keep = ("schemaVersion", "id", "slug", "level", "genre", "title", "titleTr", "blurbTr", "hookEn",
            "contentVersion", "status", "aiGenerated", "palette")
    book_doc = {k: m[k] for k in keep if k in m}
    total = sum(durations.values()) if durations else None
    book_doc.update({
        "cover": cover,
        "wordCount": word_count(book.text.texts()),
        "pageCount": len(book.text.pages),
        "estimatedMinutes": round(total / 60.0, 1) if total else None,
        "chapters": [{"id": c.id, "title": c.title,
                      **({"titleTr": cm["titleTr"]} if cm.get("titleTr") else {}),
                      "audio": audio_rel.get(c.id), "duration": durations.get(c.id),
                      "pages": [{"id": p.id, "image": page_images[p.id]} for p in c.pages]}
                     for c, cm in zip(book.text.chapters, book.chapter_meta() + [{}] * len(book.text.chapters))],
    })

    for name, doc, schema in (("book.json", book_doc, "book.schema.json"), ("pages.json", pages_doc, "pages.schema.json")):
        errors += [f"{name}: {e}" for e in schema_errors(doc, schema)]
        (pkg / name).write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")

    files = sorted(p for p in pkg.rglob("*") if p.is_file() and p.name != "manifest.json")
    manifest = {
        "schemaVersion": 1,
        "contentId": book.id,
        "contentType": "BOOK",
        "contentVersion": book.meta.get("contentVersion", 1),
        "tool": TOOL_ID,
        "textSha256": {c.id: text_sha256(c.tts_text()) for c in book.text.chapters},
        "loudness": loud,
        "pacing": pace_report,
        "missing": missing,
        "files": [{"path": str(p.relative_to(pkg)), "bytes": p.stat().st_size, "sha256": file_digest(p)}
                  for p in files],
    }
    manifest["totalBytes"] = sum(f["bytes"] for f in manifest["files"])
    (pkg / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return BookExport(book.id, pkg, book_doc, pages_doc, manifest, missing, errors, misses, pace_report)
