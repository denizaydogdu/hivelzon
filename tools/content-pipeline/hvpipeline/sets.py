"""Konu setleri ve sahne avı (H-051).

Kaynak: `icerik/_evren/setler/<set-id>.json` (şema: schema/topic-set.schema.json; belge: docs/BOLUM-PAKETI.md §7).
Her set bir bölüm sahne görseline bağlıdır ve o bölüm bitince açılır (`unlockAfter`). Öğeler:
kelime (`w`), Türkçesi (`tr`), A1 örnek cümle, sahne görselinde kırpma (`crop`, normalleştirilmiş
`x,y,w,h`) ve dokunma bölgeleri (`hotspots`: `rect` ya da `polygon`, normalleştirilmiş). Ses yalnızca
karakter kelimeyi bölümde gerçekten söylüyorsa vardır: `audioRef` kelime zamanlarıyla kesilir
(`<bölüm>/audio/<ad>.align.json`); ek ses üretimi yoktur.

Paket: `/packages/_season/S<n>/sets/` →
    <id>.json            set verisi (uygulama okur)
    <id>/scene.webp      sahne avı görseli (1080 genişlik, yazısız)
    <id>/<öğe>.webp      öğe kartı görseli (512×512; kırpma kareye genişletilir)
    <id>/<öğe>.m4a       kelimenin sesi (varsa), <öğe>.example.m4a örnek cümlenin sesi (varsa)
season.json → `topicSets` (özet liste).
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path

from .cefr import LEVELS, coverage, lemma, load_wordlist
from .graph import Issue, schema_errors

SETS_DIR = Path("_evren") / "setler"
SETS_PACKAGE_DIR = "sets"
SCENE_WIDTH = 1080
ITEM_SIZE = 512
MAX_SENTENCE_WORDS = {"A1": 8, "A2": 12}
COVERAGE_TARGET = 98.0
COVERAGE_FLOOR = 95.0
AUDIO_PAD_BEFORE = 0.04
AUDIO_PAD_AFTER = 0.10


def sets_dir(icerik_root: Path) -> Path:
    return Path(icerik_root) / SETS_DIR


def load_sets(icerik_root: Path, season: int | None = None) -> list[tuple[Path, dict]]:
    """Kaynak setler (`order`a göre). Okunamayan dosya ValueError verir."""
    out = []
    d = sets_dir(icerik_root)
    if not d.is_dir():
        return out
    for p in sorted(d.glob("*.json")):
        try:
            doc = json.loads(p.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            raise ValueError(f"{p}: geçersiz JSON: {e}") from e
        if season is None or int(doc.get("season", 0)) == season:
            out.append((p, doc))
    out.sort(key=lambda x: (x[1].get("order", 0), x[1].get("id", "")))
    return out


def find_episode_dir(icerik_root: Path, content_id: str) -> Path | None:
    dirs = sorted(q for q in Path(icerik_root).glob(f"{content_id}-*") if (q / "content.json").exists())
    return dirs[0] if dirs else None


# --- geometri -------------------------------------------------------------------------------

def square_box(crop: list[float], width: int, height: int) -> tuple[int, int, int, int]:
    """Normalleştirilmiş kırpmayı piksel karesine çevirir: kısa kenar merkezden uzatılır,
    görsel dışına taşarsa içeri kaydırılır; kare sığmazsa kısa kenara kırpılır. (x, y, kenar, kenar)."""
    x, y, w, h = crop
    cx, cy = (x + w / 2) * width, (y + h / 2) * height
    side = max(w * width, h * height)
    side = min(side, width, height)
    left = min(max(cx - side / 2, 0), width - side)
    top = min(max(cy - side / 2, 0), height - side)
    s = int(round(side))
    return int(round(left)), int(round(top)), s, s


def shape_points(shape: dict) -> list[tuple[float, float]]:
    if "rect" in shape:
        x, y, w, h = shape["rect"]
        return [(x, y), (x + w, y), (x + w, y + h), (x, y + h)]
    return [(float(a), float(b)) for a, b in shape["polygon"]]


def point_in_shape(px: float, py: float, shape: dict) -> bool:
    """Uygulamadaki isabet denetiminin Python eşi (çift-tek kuralı; kenar dahil)."""
    if "rect" in shape:
        x, y, w, h = shape["rect"]
        return x <= px <= x + w and y <= py <= y + h
    pts = shape_points(shape)
    inside = False
    j = len(pts) - 1
    for i in range(len(pts)):
        xi, yi = pts[i]
        xj, yj = pts[j]
        if (yi > py) != (yj > py) and px < (xj - xi) * (py - yi) / (yj - yi) + xi:
            inside = not inside
        j = i
    return inside


def polygon_area(pts: list[tuple[float, float]]) -> float:
    return abs(sum(pts[i][0] * pts[i - 1][1] - pts[i - 1][0] * pts[i][1] for i in range(len(pts)))) / 2


def bbox(shapes: list[dict]) -> tuple[float, float, float, float]:
    pts = [p for s in shapes for p in shape_points(s)]
    xs, ys = [p[0] for p in pts], [p[1] for p in pts]
    return min(xs), min(ys), max(xs), max(ys)


# --- ses ------------------------------------------------------------------------------------

@dataclass
class WordSpan:
    start: float
    end: float
    text: str


def align_path(icerik_root: Path, source: str) -> Path:
    return Path(icerik_root) / f"{source}.align.json"


def audio_path(icerik_root: Path, source: str) -> Path:
    return Path(icerik_root) / f"{source}.mp3"


def word_span(align: dict, word: str) -> WordSpan | None:
    """Hizalamadaki ilk eşleşen kelimenin (ya da kelime grubunun) zamanı; büyük/küçük harf duyarsız."""
    al = align.get("alignment") or align.get("normalized_alignment") or {}
    chars = al.get("characters") or []
    starts = al.get("character_start_times_seconds") or []
    ends = al.get("character_end_times_seconds") or []
    text = "".join(chars)
    m = re.search(rf"(?<![\w']){re.escape(word)}(?![\w'])", text, re.IGNORECASE)
    if not m or m.end() > len(ends):
        return None
    return WordSpan(float(starts[m.start()]), float(ends[m.end() - 1]), m.group(0))


def clip_range(span: WordSpan, duration: float | None = None) -> tuple[float, float]:
    start = max(0.0, span.start - AUDIO_PAD_BEFORE)
    end = span.end + AUDIO_PAD_AFTER
    if duration is not None:
        end = min(end, duration)
    return round(start, 3), round(end, 3)


# --- denetim (content-lint) -----------------------------------------------------------------

def _word_level(w: str, level: str) -> str | None:
    """Çok kelimeli ifadede en yüksek seviye; listede olmayan kelime için None."""
    wl = load_wordlist("B2")
    worst = None
    for t in re.findall(r"[a-zçğıöşüé]+", w.lower()):
        lem = lemma(t, wl.allowed)
        lv = wl.levels.get(lem) or wl.levels.get(t) or wl.levels.get(t.replace("é", "e"))
        if lv is None:
            return None
        if worst is None or LEVELS.index(lv) > LEVELS.index(worst):
            worst = lv
    return worst


def lint_set(path: Path, doc: dict, icerik_root: Path) -> tuple[list[Issue], dict]:
    """Bir konu setinin denetimi: şema, kapsama, cümle uzunluğu, kırpma ve dokunma bölgeleri,
    Türkçe anlam, ses kaynağı, bölüm ve görsel varlığı."""
    root = Path(icerik_root)
    issues: list[Issue] = []
    for e in schema_errors(doc, "topic-set.schema.json"):
        issues.append(Issue("error", "set-schema", e))
    sid = doc.get("id", "?")
    if path.stem != sid:
        issues.append(Issue("error", "set-schema", f"dosya adı ({path.name}) set kimliğiyle ({sid}) aynı olmalı"))
    items = doc.get("items") or []
    if not isinstance(items, list):
        return issues, {}
    level = doc.get("level", "A1")
    if doc.get("status") != "APPROVED":
        issues.append(Issue("warning", "set-status",
                            f"{sid}: durum {doc.get('status')} (Türkçe anlamlar ve örnekler editör onayı bekliyor, H-028)"))
    ep = find_episode_dir(root, str(doc.get("unlockAfter", "")))
    if ep is None:
        issues.append(Issue("error", "set-unlock", f"{sid}: unlockAfter bölümü yok: {doc.get('unlockAfter')}"))
    img = root / str(doc.get("sceneImage", ""))
    if not img.is_file():
        issues.append(Issue("error", "set-image", f"{sid}: sahne görseli yok: {doc.get('sceneImage')}"))
    seen_ids, seen_w = set(), set()
    gloss = list(doc.get("glossary") or [])
    for it in items:
        if not isinstance(it, dict):
            continue
        iid = it.get("id", "?")
        where = f"{sid}/{iid}"
        if iid in seen_ids:
            issues.append(Issue("error", "set-item", f"{where}: aynı öğe kimliği iki kez"))
        seen_ids.add(iid)
        w = str(it.get("w", "")).strip()
        if w.lower() in seen_w:
            issues.append(Issue("error", "set-item", f"{where}: aynı kelime iki kez: {w}"))
        seen_w.add(w.lower())
        if not str(it.get("tr", "")).strip():
            issues.append(Issue("error", "set-meaning", f"{where}: Türkçe anlam (tr) boş"))
        if not str(it.get("findTr", "")).strip():
            issues.append(Issue("error", "set-meaning", f"{where}: sahne avı Türkçe yardım satırı (findTr) boş"))
        lv = _word_level(w, level) if w else None
        above = bool(it.get("aboveLevel"))
        if level in LEVELS:
            over = lv is None or LEVELS.index(lv) > LEVELS.index(level)
            if over and not above:
                issues.append(Issue("error", "set-level",
                                    f"{where}: \"{w}\" {lv or 'CEFR-J listesinde yok'}; {level} üstü kelime "
                                    "`aboveLevel: true` ile işaretlenmeli (Türkçesi kartta sözlük işlevi görür)"))
            elif above and not over:
                issues.append(Issue("warning", "set-level", f"{where}: \"{w}\" {lv}; aboveLevel gereksiz"))
        if above:
            gloss.append(w)
        # kırpma ve dokunma bölgeleri
        crop = it.get("crop")
        if isinstance(crop, list) and len(crop) == 4:
            x, y, cw, ch = crop
            if cw <= 0 or ch <= 0 or x < 0 or y < 0 or x + cw > 1 + 1e-9 or y + ch > 1 + 1e-9:
                issues.append(Issue("error", "set-crop", f"{where}: kırpma görselin dışında: {crop}"))
        shapes = it.get("hotspots") or []
        for s in shapes:
            if not isinstance(s, dict):
                continue
            if "rect" in s and isinstance(s["rect"], list) and len(s["rect"]) == 4:
                x, y, hw, hh = s["rect"]
                if hw <= 0 or hh <= 0 or x + hw > 1 + 1e-9 or y + hh > 1 + 1e-9:
                    issues.append(Issue("error", "set-hotspot", f"{where}: dokunma bölgesi görselin dışında: {s['rect']}"))
            elif "polygon" in s and isinstance(s["polygon"], list) and len(s["polygon"]) >= 3:
                if polygon_area(shape_points(s)) < 1e-5:
                    issues.append(Issue("error", "set-hotspot", f"{where}: çokgenin alanı sıfır"))
        if shapes and isinstance(crop, list) and len(crop) == 4:
            try:
                bx0, by0, bx1, by1 = bbox([s for s in shapes if isinstance(s, dict)])
                x, y, cw, ch = crop
                if bx1 < x or bx0 > x + cw or by1 < y or by0 > y + ch:
                    issues.append(Issue("error", "set-crop", f"{where}: kırpma hiçbir dokunma bölgesiyle kesişmiyor"))
            except (ValueError, KeyError, TypeError):
                pass
        # ses
        for key in ("audioRef", "exampleAudioRef"):
            ref = it.get(key)
            if not isinstance(ref, dict):
                continue
            ap, al = audio_path(root, ref.get("source", "")), align_path(root, ref.get("source", ""))
            if not ap.is_file() or not al.is_file():
                issues.append(Issue("error", "set-audio", f"{where}: ses kaynağı yok: {ref.get('source')} (.mp3 ve .align.json)"))
                continue
            word = ref.get("word")
            if word:
                span = word_span(json.loads(al.read_text(encoding="utf-8")), word)
                if span is None:
                    issues.append(Issue("error", "set-audio", f"{where}: \"{word}\" kaydın hizalamasında yok ({ref.get('source')})"))
        ex_audio = it.get("exampleAudioRef")
        if isinstance(ex_audio, dict):
            al = align_path(root, ex_audio.get("source", ""))
            if al.is_file():
                spoken = json.loads(al.read_text(encoding="utf-8")).get("text", "")
                if _norm(spoken) != _norm(it.get("exampleEn", "")):
                    issues.append(Issue("error", "set-audio",
                                        f"{where}: örnek cümle sesi farklı bir cümle: \"{spoken}\""))
    # dil: örnek cümleler (CEFR kapsama + cümle uzunluğu)
    examples = [str(it.get("exampleEn", "")) for it in items if isinstance(it, dict)]
    rep = {"id": sid, "items": len(items), "audio": sum(1 for it in items if isinstance(it, dict) and it.get("audioRef"))}
    if level in LEVELS and examples:
        max_words = MAX_SENTENCE_WORDS.get(level, 10_000)
        cov = coverage(examples, level, gloss=gloss, max_words=max_words)
        rep.update({"tokens": cov.tokens, "pct": round(cov.pct, 1), "pctWithGlossary": round(cov.pct_with_gloss, 1),
                    "maxSentenceWords": cov.max_sentence_words})
        if cov.pct < COVERAGE_TARGET and not (cov.pct >= COVERAGE_FLOOR and cov.pct_with_gloss >= COVERAGE_TARGET):
            issues.append(Issue("error", "set-coverage",
                                f"{sid}: örnek cümle kapsaması %{cov.pct:.1f} (sözlükle %{cov.pct_with_gloss:.1f}); "
                                f"hedef %{COVERAGE_TARGET:.0f}"))
        elif cov.pct < COVERAGE_TARGET:
            issues.append(Issue("warning", "set-coverage",
                                f"{sid}: örnek cümle kapsaması %{cov.pct:.1f} (sözlükle %{cov.pct_with_gloss:.1f}); "
                                "alt sınır yalnızca sözlük + görselle geçerli (seviye üstü kelime kartta Türkçesiyle)"))
        ungl = cov.unglossed()
        if ungl:
            issues.append(Issue("warning", "set-off-list",
                                f"{sid}: örneklerde liste dışı sözcük: " + ", ".join(f"{k}[{v[0]}]" for k, v in sorted(ungl.items()))))
        for s in cov.long_sentences:
            issues.append(Issue("error", "set-sentence-length", f"{sid}: {level} için cümle en çok {max_words} sözcük: \"{s}\""))
    return issues, rep


def _norm(s: str) -> str:
    return " ".join(re.sub(r"[^\w' ]+", " ", s.replace("’", "'").lower()).split())


def lint_sets(icerik_root: Path) -> list[tuple[str, list[Issue], dict]]:
    out = []
    try:
        sets = load_sets(icerik_root)
    except ValueError as e:
        return [("?", [Issue("error", "set-schema", str(e))], {})]
    ids = set()
    for p, doc in sets:
        issues, rep = lint_set(p, doc, icerik_root)
        key = (doc.get("season"), doc.get("id"))
        if key in ids:
            issues.append(Issue("error", "set-schema", f"aynı set kimliği iki kez: {doc.get('id')}"))
        ids.add(key)
        out.append((doc.get("id", p.stem), issues, rep))
    return out


# --- dışa aktarma ---------------------------------------------------------------------------

def item_kind(w: str) -> str:
    return "word" if len(w.split()) == 1 else "phrase"


def export_sets(icerik_root: Path, season: int, out: Path, *, crop=None, scene=None, cut=None, gain=None,
                probe=None, size=None) -> list[dict]:
    """Setleri sezon paketine yazar; season.json için özet listeyi döndürür.

    crop(src, box, out): öğe görseli (WebP 512); scene(src, out): sahne görseli (WebP 1080);
    cut(src, start, end, gain_db, out): ses kesiti (m4a); gain(src) → dB (-16 LUFS hedefine);
    probe(src) → süre; size(src) → (genişlik, yükseklik). Verilmeyen adım atlanır (testler).
    Hatası olan set (content-lint) dışa aktarılmaz: ValueError.
    """
    root = Path(icerik_root)
    sets = load_sets(root, season)
    base = Path(out) / SETS_PACKAGE_DIR
    summary = []
    keep: set[str] = set()
    for path, doc in sets:
        errs = [i for i in lint_set(path, doc, root)[0] if i.level == "error"]
        if errs:
            raise ValueError(f"{path.name}: " + "; ".join(str(e) for e in errs[:5]))
        sid = doc["id"]
        keep.add(sid)
        d = base / sid
        d.mkdir(parents=True, exist_ok=True)
        src = root / doc["sceneImage"]
        width, height = size(src) if size else (1520, 2688)
        if scene:
            scene(src, d / "scene.webp")
        ep = find_episode_dir(root, doc["unlockAfter"])
        number = None
        if ep is not None:
            number = json.loads((ep / "content.json").read_text(encoding="utf-8")).get("episode")
        gains: dict[str, float] = {}
        items = []
        for it in doc["items"]:
            iid = it["id"]
            box = square_box(it["crop"], width, height)
            if crop:
                crop(src, box, d / f"{iid}.webp")
            entry = {"id": iid, "w": it["w"], "kind": item_kind(it["w"]), "tr": it["tr"],
                     "findEn": it.get("findEn") or f"Find the {it['w']}!", "findTr": it["findTr"],
                     "exampleEn": it["exampleEn"], "exampleTr": it["exampleTr"],
                     "aboveLevel": bool(it.get("aboveLevel")),
                     "image": f"{sid}/{iid}.webp",
                     "crop": [round(v, 4) for v in it["crop"]],
                     "hotspots": it["hotspots"]}
            for key, suffix, field in (("audioRef", "", "audio"), ("exampleAudioRef", ".example", "exampleAudio")):
                ref = it.get(key)
                name = f"{sid}/{iid}{suffix}.m4a"
                if not ref:
                    (base / name).unlink(missing_ok=True)
                    continue
                mp3 = audio_path(root, ref["source"])
                dur = probe(mp3) if probe else None
                if ref.get("word"):
                    span = word_span(json.loads(align_path(root, ref["source"]).read_text(encoding="utf-8")), ref["word"])
                    start, end = clip_range(span, dur)
                else:
                    start, end = 0.0, round(dur, 3) if dur else None
                if cut:
                    if ref["source"] not in gains:
                        gains[ref["source"]] = gain(mp3) if gain else 0.0
                    cut(mp3, start, end, gains[ref["source"]], base / name)
                entry[field] = name
                entry[field + "Source"] = {"source": ref["source"], "start": start, "end": end}
            items.append(entry)
        pkg = {"schemaVersion": 1, "id": sid, "season": season, "level": doc["level"], "order": doc["order"],
               "titleTr": doc["titleTr"], "unlockAfter": doc["unlockAfter"], "unlockEpisode": number,
               "status": doc["status"], "scene": {"image": f"{sid}/scene.webp", "width": width, "height": height},
               "items": items}
        tmp = base / f".{sid}.json.tmp"
        tmp.write_text(json.dumps(pkg, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        tmp.replace(base / f"{sid}.json")
        wanted = {"scene.webp"} | {Path(e["image"]).name for e in items} | {
            Path(e[f]).name for e in items for f in ("audio", "exampleAudio") if e.get(f)}
        for p in d.iterdir():
            if p.is_file() and p.name not in wanted and (scene or crop or cut):
                p.unlink()   # kaldırılan öğenin eski görseli ya da sesi kalmasın
        files = sorted(p for p in d.iterdir() if p.is_file() and not p.name.startswith("."))
        summary.append({"id": sid, "order": doc["order"], "titleTr": doc["titleTr"], "unlockAfter": doc["unlockAfter"],
                        "unlockEpisode": number, "itemCount": len(items),
                        "cover": f"{sid}/scene.webp", "path": f"{SETS_PACKAGE_DIR}/{sid}.json",
                        "bytes": sum(p.stat().st_size for p in files) + (base / f"{sid}.json").stat().st_size})
    # Kaynağı silinen setlerin eski paketleri kalmasın.
    if base.is_dir():
        for p in base.iterdir():
            name = p.name[:-5] if p.suffix == ".json" else p.name
            if name not in keep and not p.name.startswith("."):
                if p.is_dir():
                    for q in p.iterdir():
                        q.unlink()
                    p.rmdir()
                else:
                    p.unlink()
    return summary
