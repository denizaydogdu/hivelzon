"""Keşfet klipleri (H-040): bölüm kayıtlarından kesilen kısa klipler.

Kaynak: `icerik/_evren/klipler/S<n>.json` (belge: docs/BOLUM-PAKETI.md §9). Her klip bir bölümün bir ya da
birkaç ardışık segmentinden (`parts`: düğüm + başlangıç/bitiş, segment başına göre saniye) kesilir, en çok
30 sn sürer, kendi başına anlaşılır (hiçbir altyazı satırı ortadan bölünmez) ve tek bir öğrenme hedefi
taşır (`target`: ifade ya da kelime, Türkçesiyle; isteğe bağlı `grammar` = dilbilgisi dersi G-ID).
İsteğe bağlı `quiz`: Keşfet'in 4–5 klipte bir gösterdiği soru kartı (puan yok, sakin geri bildirim).

Ücretli üretim yok: görüntü ve ses bölüm paketinin 720p segmentlerinden (`_build/package/segments/*.720p.mp4`)
ffmpeg ile kesilir; ses her klipte ayrı ölçülüp -16 LUFS'a getirilir (kazanç + sınırlayıcı).

Paket: `/packages/_season/S<n>/` →
    clips.json          klip listesi: kimlik, bölüm, başlık, hedef, dilbilgisi, quiz, altyazı satırları
                        (klibe göre zamanlar, kelime zamanları, Türkçe, kalıplar), ses ölçümü
    clips/<id>.mp4      720×1280 H.264 + AAC, faststart
    clips/<id>.webp     ilk kare (yüklenirken görünür)
season.json → `clips` (özet).

Yalnızca editörün onayladığı içerikten klip türetilir (CLAUDE.md): kaynak bölüm `APPROVED` (ya da
SCHEDULED/PUBLISHED) değilse ve klip dosyası onaylı değilse uyarı verilir; `require_approved=True` ile
(yayın denetimi) bunlar hataya döner.
"""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

from .graph import Issue
from .hi import BLAMING
from .sets import find_episode_dir

CLIPS_DIR = Path("_evren") / "klipler"
CLIPS_PACKAGE_FILE = "clips.json"
CLIPS_MEDIA_DIR = "clips"
MAX_SECONDS = 30.0
MIN_SECONDS = 3.0
EDGE = 0.05            # sınır toleransı (sn): segment sonu ve altyazı satırı kenarları
APPROVED = frozenset({"APPROVED", "SCHEDULED", "PUBLISHED"})
VIDEO_NODES = frozenset({"segment", "recap", "reaction"})
TARGET_KINDS = frozenset({"phrase", "word"})
ID_RE = re.compile(r"^S(\d+)-K\d{2}$")
GRAMMAR_RE = re.compile(r"^G-[ABC][12]-\d{2}-[a-z0-9-]+$")
MEDIA_VERSION = "1"    # kesim/kodlama ayarı değişince önbellek anahtarı değişir
TITLE_MAX = 40


def clips_dir(icerik_root: Path) -> Path:
    return Path(icerik_root) / CLIPS_DIR


def clips_source(icerik_root: Path, season: int) -> Path:
    return clips_dir(icerik_root) / f"S{season}.json"


def grammar_root(icerik_root: Path) -> Path:
    """Dilbilgisi dersleri depo kökünde (`dilbilgisi/`), içerik kökünün kardeşi."""
    return Path(icerik_root).resolve().parent / "dilbilgisi"


# --- metin ----------------------------------------------------------------------------------

def _norm(w: str) -> str:
    return re.sub(r"[^a-z0-9']", "", w.lower().replace("’", "'"))


def phrase_variants(phrase: str) -> list[list[str]]:
    """"Turn left / right." → [turn, left] ve [turn, right]; "Where is…?" → [where, is] (önek)."""
    tokens = [t for t in re.split(r"\s+", phrase.replace("…", " ").replace("...", " ")) if t]
    if "/" in tokens:
        i = tokens.index("/")
        if 0 < i < len(tokens) - 1:
            variants = [tokens[:i] + tokens[i + 2:], tokens[:i - 1] + tokens[i + 1:]]
        else:
            variants = [tokens]
    else:
        variants = [tokens]
    out = []
    for v in variants:
        parts = [p for p in (_norm(t) for t in v) if p]
        if parts:
            out.append(parts)
    return out


def find_target(cues: list[dict], phrase: str) -> str | None:
    """Hedef ifadenin geçtiği ilk altyazı satırının kimliği (sözcük sırasıyla, önek eşleşmesi)."""
    for cue in cues:
        words = [_norm(w["w"]) for w in cue.get("words") or []] or [_norm(t) for t in cue["text"].split()]
        for parts in phrase_variants(phrase):
            for i in range(len(words) - len(parts) + 1):
                if words[i:i + len(parts)] == parts:
                    return cue["id"]
    return None


# --- kaynak ---------------------------------------------------------------------------------

def load_clip_sources(icerik_root: Path, season: int | None = None) -> list[tuple[Path, dict]]:
    d = clips_dir(icerik_root)
    if not d.is_dir():
        return []
    out = []
    for p in sorted(d.glob("S*.json")):
        try:
            doc = json.loads(p.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            raise ValueError(f"{p}: geçersiz JSON: {e}") from e
        if season is None or int(doc.get("season", 0)) == season:
            out.append((p, doc))
    return out


class _Episode:
    """Bölüm klasörü + paketi (scenes.json düğümleri, altyazılar önbellekte)."""

    def __init__(self, root: Path, cid: str):
        self.cid = cid
        self.dir = find_episode_dir(root, cid)
        self.package = self.dir / "_build" / "package" if self.dir else None
        self.content = {}
        self.scenes = None
        self._subs: dict[str, dict | None] = {}
        if self.dir:
            self.content = json.loads((self.dir / "content.json").read_text(encoding="utf-8"))
        if self.package and (self.package / "scenes.json").exists():
            self.scenes = json.loads((self.package / "scenes.json").read_text(encoding="utf-8"))

    @property
    def nodes(self) -> dict[str, dict]:
        return {n["id"]: n for n in (self.scenes or {}).get("nodes", [])}

    @property
    def info(self) -> dict:
        return (self.scenes or {}).get("episode", {})

    def subs(self, node: dict) -> dict | None:
        path = node.get("subtitles")
        if not path:
            return None
        if path not in self._subs:
            f = self.package / path
            self._subs[path] = json.loads(f.read_text(encoding="utf-8")) if f.exists() else None
        return self._subs[path]


def _shift_cue(cue: dict, offset: float, at: float) -> dict:
    """Altyazı satırını klibe göre zamanlar (segment zamanı − parça başı + parçanın klipteki yeri)."""
    d = at - offset

    def t(x: float) -> float:
        return round(max(0.0, x + d), 3)

    out = {k: v for k, v in cue.items() if k not in ("start", "end", "words")}
    out["start"], out["end"] = t(cue["start"]), t(cue["end"])
    out["words"] = [{**w, "start": t(w["start"]), "end": t(w["end"])} for w in cue.get("words") or []]
    return out


def build_clip(clip: dict, episodes: dict[str, _Episode], root: Path) -> tuple[list[Issue], dict | None]:
    """Tek klibin denetimi ve paket kaydı (medya alanları hariç). Hata varsa kayıt None."""
    issues: list[Issue] = []
    cid = clip.get("id", "?")

    def err(code: str, msg: str) -> None:
        issues.append(Issue("error", code, f"{cid}: {msg}"))

    def warn(code: str, msg: str) -> None:
        issues.append(Issue("warning", code, f"{cid}: {msg}"))

    if not ID_RE.match(str(clip.get("id", ""))):
        err("clip-id", "kimlik S<sezon>-K<2 hane> olmalı")
    title = (clip.get("titleTr") or "").strip()
    if not title:
        err("clip-title", "titleTr boş")
    elif len(title) > TITLE_MAX:
        err("clip-title", f"titleTr {TITLE_MAX} karakteri aşıyor")
    ep_id = clip.get("episode", "")
    ep = episodes.get(ep_id)
    if ep is None:
        ep = episodes[ep_id] = _Episode(root, ep_id)
    if ep.dir is None:
        err("clip-episode", f"bölüm {ep_id} yok")
        return issues, None
    if ep.scenes is None:
        err("clip-package", f"{ep_id} paketi yok (önce export_package.py); sınırlar denetlenemedi")
        return issues, None
    parts = clip.get("parts") or []
    if not parts:
        err("clip-parts", "parts boş")
        return issues, None
    nodes = ep.nodes
    cues: list[dict] = []
    out_parts: list[dict] = []
    at = 0.0
    for k, p in enumerate(parts):
        node = nodes.get(p.get("node", ""))
        if node is None:
            err("clip-node", f"parça {k + 1}: düğüm {p.get('node')} {ep_id} paketinde yok")
            continue
        if node.get("type") not in VIDEO_NODES or not node.get("video"):
            err("clip-node", f"parça {k + 1}: {node['id']} videolu bir segment değil")
            continue
        start, end = float(p.get("start", 0)), float(p.get("end", 0))
        dur = float(node.get("duration") or 0)
        if not (0 <= start < end):
            err("clip-bounds", f"parça {k + 1} ({node['id']}): başlangıç {start} / bitiş {end} geçersiz")
            continue
        if end > dur + EDGE:
            err("clip-bounds", f"parça {k + 1} ({node['id']}): bitiş {end} sn segment süresini ({dur} sn) aşıyor")
            continue
        r720 = (node.get("renditions") or {}).get("720p")
        if not r720:
            err("clip-rendition", f"parça {k + 1} ({node['id']}): 720p sürümü yok")
        elif not (ep.package / r720).exists():
            err("clip-rendition", f"parça {k + 1}: {r720} dosyası yok")
        subs = ep.subs(node)
        if subs is None:
            warn("clip-subs", f"parça {k + 1} ({node['id']}): altyazı yok (sessiz parça)")
        else:
            for c in subs.get("cues", []):
                if c["end"] <= start + EDGE or c["start"] >= end - EDGE:
                    continue   # aralığın dışında
                if c["start"] < start - EDGE or c["end"] > end + EDGE:
                    err("clip-cue-cut", f"parça {k + 1} ({node['id']}): “{c['text']}” satırı ortadan bölünüyor "
                                        f"({c['start']}–{c['end']} sn; klip {start}–{end} sn)")
                    continue
                cues.append(_shift_cue(c, start, at))
        out_parts.append({"node": node["id"], "start": round(start, 3), "end": round(end, 3),
                          "at": round(at, 3), "video": r720})
        at += end - start
    total = round(at, 3)
    if total > MAX_SECONDS + 1e-6:
        err("clip-duration", f"süre {total} sn; en çok {MAX_SECONDS:.0f} sn")
    elif out_parts and total < MIN_SECONDS:
        err("clip-duration", f"süre {total} sn; en az {MIN_SECONDS:.0f} sn")
    if out_parts and not cues:
        err("clip-cues", "klipte hiç altyazı satırı yok")
    target = clip.get("target") or {}
    target_cue = None
    if target.get("kind") not in TARGET_KINDS:
        err("clip-target", f"target.kind {sorted(TARGET_KINDS)} olmalı")
    if not (target.get("en") or "").strip() or not (target.get("tr") or "").strip():
        err("clip-target", "target.en ve target.tr dolu olmalı")
    elif cues:
        target_cue = find_target(cues, target["en"])
        if target_cue is None:
            err("clip-target", f"hedef “{target['en']}” klibin altyazısında geçmiyor")
    grammar = clip.get("grammar")
    grammar_doc = None
    if grammar is not None:
        if not GRAMMAR_RE.match(str(grammar)):
            err("clip-grammar", f"dilbilgisi kimliği {grammar} geçersiz")
        else:
            gdir = grammar_root(root)
            lesson = gdir / grammar / "lesson.json"
            if lesson.exists():
                grammar_doc = json.loads(lesson.read_text(encoding="utf-8"))
            elif gdir.is_dir():
                err("clip-grammar", f"dilbilgisi dersi {grammar} yok (dilbilgisi/{grammar}/lesson.json)")
            else:
                warn("clip-grammar", "dilbilgisi/ klasörü yok; ders denetlenemedi")
    quiz = clip.get("quiz")
    if quiz is not None:
        opts = quiz.get("options") or []
        texts = [(o.get("text") or "").strip() for o in opts]
        if not (quiz.get("promptTr") or "").strip():
            err("clip-quiz", "quiz.promptTr boş")
        if not 2 <= len(opts) <= 4:
            err("clip-quiz", "quiz 2–4 seçenek içermeli")
        if sum(1 for o in opts if o.get("correct") is True) != 1:
            err("clip-quiz", "quiz'de tam 1 doğru seçenek olmalı")
        if any(not t for t in texts) or len(set(texts)) != len(texts):
            err("clip-quiz", "quiz seçenekleri dolu ve birbirinden farklı olmalı")
        if any(o.get("lang", "tr") not in ("tr", "en") for o in opts):
            err("clip-quiz", "seçenek dili tr ya da en olmalı")
        for text in (quiz.get("promptTr") or "", quiz.get("explainTr") or ""):
            low = text.lower()
            hit = next((b for b in BLAMING if b in low), None)
            if hit:
                err("clip-quiz-tone", f"suçlayıcı ya da baskı kuran ifade: “{hit}” (K-32)")
    if any(i.level == "error" for i in issues):
        return issues, None
    src_status = ep.content.get("status", "DRAFT")
    info = ep.info
    rec = {
        "id": clip["id"], "episode": ep_id, "episodeNumber": info.get("number"),
        "episodeTitle": info.get("title") or ep.content.get("title"),
        "titleTr": title, "duration": total,
        "target": {"kind": target["kind"], "en": target["en"], "tr": target["tr"], "cue": target_cue},
        "parts": out_parts, "cues": cues, "sourceStatus": src_status,
    }
    if grammar:
        rec["grammar"] = {"id": grammar, "titleTr": (grammar_doc or {}).get("titleTr") or grammar}
    if quiz is not None:
        rec["quiz"] = {
            "promptTr": quiz["promptTr"],
            "options": [{"text": o["text"], "lang": o.get("lang", "tr"), "correct": o.get("correct") is True}
                        for o in quiz["options"]],
            **({"explainTr": quiz["explainTr"]} if quiz.get("explainTr") else {}),
        }
    return issues, rec


def lint_clip_file(path: Path, doc: dict, root: Path, require_approved: bool = False,
                   episodes: dict | None = None) -> tuple[list[Issue], dict, list[dict]]:
    """Klip dosyasının denetimi: (bulgular, özet rapor, geçerli klip kayıtları)."""
    issues: list[Issue] = []
    episodes = {} if episodes is None else episodes
    name = path.name
    if doc.get("schemaVersion") != 1:
        issues.append(Issue("error", "clips-schema", f"{name}: schemaVersion 1 olmalı"))
    season = int(doc.get("season", 0))
    clips = doc.get("clips") or []
    if not clips:
        issues.append(Issue("error", "clips-empty", f"{name}: klip yok"))
    seen: set[str] = set()
    recs: list[dict] = []
    for clip in clips:
        cid = clip.get("id", "?")
        if cid in seen:
            issues.append(Issue("error", "clip-id", f"{cid}: kimlik iki kez"))
            continue
        seen.add(cid)
        m = ID_RE.match(str(cid))
        if m and int(m.group(1)) != season:
            issues.append(Issue("error", "clip-id", f"{cid}: sezon {season} dosyasında başka sezonun kimliği"))
        iss, rec = build_clip(clip, episodes, root)
        issues += iss
        if rec is not None:
            recs.append(rec)
    level = "error" if require_approved else "warning"
    status = doc.get("status", "DRAFT")
    if status not in APPROVED:
        issues.append(Issue(level, "clips-status",
                            f"{name}: durum {status} (klip başlıkları, hedefler ve quiz editör onayı bekliyor, H-028)"))
    drafts = sorted({r["episode"] for r in recs if r["sourceStatus"] not in APPROVED})
    if drafts:
        issues.append(Issue(level, "clip-source-status",
                            f"{name}: kaynak bölüm onaylı değil: {', '.join(drafts)} "
                            "(klipler yalnızca editörün onayladığı içerikten yayınlanır)"))
    report = {"clips": len(clips), "valid": len(recs), "status": status,
              "seconds": round(sum(r["duration"] for r in recs), 1),
              "maxSeconds": max((r["duration"] for r in recs), default=0),
              "quizzes": sum(1 for r in recs if "quiz" in r),
              "grammar": sum(1 for r in recs if "grammar" in r),
              "episodes": sorted({r["episode"] for r in recs})}
    return issues, report, recs


def lint_clips(icerik_root: Path, season: int | None = None,
               require_approved: bool = False) -> list[tuple[str, list[Issue], dict]]:
    out = []
    for p, doc in load_clip_sources(icerik_root, season):
        issues, report, _ = lint_clip_file(p, doc, Path(icerik_root), require_approved)
        out.append((p.name, issues, report))
    return out


# --- dışa aktarma ---------------------------------------------------------------------------

def _media_key(rec: dict, package_dirs: dict[str, Path]) -> str:
    h = hashlib.sha256(MEDIA_VERSION.encode())
    for p in rec["parts"]:
        src = package_dirs[rec["episode"]] / p["video"]
        st = src.stat()
        h.update(f"{p['video']}|{p['start']}|{p['end']}|{st.st_size}|{int(st.st_mtime)}".encode())
    return h.hexdigest()[:16]


def export_clips(icerik_root: Path, season: int, out: Path, cut=None, measure=None, poster=None,
                 probe=None) -> dict | None:
    """Sezon paketine `clips.json` ve `clips/` yazar; season.json için özet döndürür. Kaynak yoksa None.

    cut(parts, gain_db, out): [(kaynak, başlangıç, bitiş)] parçalarını tek klibe keser (media.cut_clip);
    measure(parts) → {"I", "TP", "LRA"}: parçaların birleşik ses ölçümü (media.parts_loudness);
    poster(src, out): ilk kare WebP; probe(path) → süre. `cut` verilmezse yalnızca JSON yazılır (testler).
    Denetim hatası varsa ValueError (hatalı klip pakete girmez).
    """
    root = Path(icerik_root)
    src = clips_source(root, season)
    out = Path(out)
    if not src.exists():
        (out / CLIPS_PACKAGE_FILE).unlink(missing_ok=True)
        return None
    doc = json.loads(src.read_text(encoding="utf-8"))
    episodes: dict = {}
    issues, report, recs = lint_clip_file(src, doc, root, episodes=episodes)
    errs = [str(i) for i in issues if i.level == "error"]
    if errs:
        raise ValueError("; ".join(errs[:5]))
    media_dir = out / CLIPS_MEDIA_DIR
    media_dir.mkdir(parents=True, exist_ok=True)
    package_dirs = {cid: e.package for cid, e in episodes.items() if e.package}
    total = 0
    for rec in recs:
        mp4 = media_dir / f"{rec['id']}.mp4"
        webp = media_dir / f"{rec['id']}.webp"
        rec["video"] = f"{CLIPS_MEDIA_DIR}/{mp4.name}"
        if cut is not None:
            key_file = media_dir / f".{rec['id']}.key.json"
            key = _media_key(rec, package_dirs)
            cached = json.loads(key_file.read_text(encoding="utf-8")) if key_file.exists() else {}
            if cached.get("key") != key or not mp4.exists():
                parts = [(package_dirs[rec["episode"]] / p["video"], p["start"], p["end"]) for p in rec["parts"]]
                before = measure(parts) if measure else None
                gain = round(-16.0 - before["I"], 2) if before else 0.0
                tmp = media_dir / f".tmp-{mp4.name}"
                tmp.unlink(missing_ok=True)
                cut(parts, gain, tmp)
                tmp.replace(mp4)
                after = measure([(mp4, 0.0, None)]) if measure else None
                cached = {"key": key, "loudness": {"before": before, "gainDb": gain, "after": after}}
                (media_dir / f".{rec['id']}.key.tmp").write_text(json.dumps(cached), encoding="utf-8")
                (media_dir / f".{rec['id']}.key.tmp").replace(key_file)
                webp.unlink(missing_ok=True)
            rec["loudness"] = cached.get("loudness")
            if poster is not None and not webp.exists():
                poster(mp4, webp)
            if probe is not None:
                rec["videoDuration"] = round(probe(mp4), 3)
        if webp.exists():
            rec["poster"] = f"{CLIPS_MEDIA_DIR}/{webp.name}"
        if mp4.exists():
            rec["bytes"] = mp4.stat().st_size
            total += rec["bytes"] + (webp.stat().st_size if webp.exists() else 0)
        for p in rec["parts"]:
            p.pop("video", None)
    # Kaynakta artık olmayan kliplerin dosyaları silinir.
    keep = {r["id"] for r in recs}
    for f in media_dir.iterdir():
        stem = f.name.lstrip(".").split(".")[0]
        if stem not in keep:
            f.unlink()
    pkg = {"schemaVersion": 1, "season": season, "level": doc.get("level"), "status": doc.get("status", "DRAFT"),
           "aiLabel": "Yapay zekâ ile üretilmiştir", "clips": recs}
    tmp = out / f".{CLIPS_PACKAGE_FILE}.tmp"
    tmp.write_text(json.dumps(pkg, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    tmp.replace(out / CLIPS_PACKAGE_FILE)
    return {"path": CLIPS_PACKAGE_FILE, "count": len(recs), "status": pkg["status"], "seconds": report["seconds"],
            "quizzes": report["quizzes"], "bytes": total,
            "warnings": [str(i) for i in issues if i.level == "warning"]}
