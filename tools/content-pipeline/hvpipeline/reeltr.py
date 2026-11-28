"""Keşfet reel alıştırmasının Türkçe sesi (H-109 Faz 1): PatientDesk Alania + Duyu, tts_tr ile.

Birim: reel başına en çok iki parça, kimlikler sabit (soru sırasına ya da seçenek sırasına bağlı değil):
- `practice-prompt`: sorunun Türkçesi (`practice.promptTr`) ve seçenekler (hepsi Türkçeyse, kaynaktaki sırayla
  — uygulama seçenekleri karıştırmadan aynı sırayla gösterir; her seçenek kısa durakla);
- `practice-explain`: cevaptan sonra görünen açıklama (`practice.explainTr`).
H-109 Faz 3 (`subtitles` bölümü, yalnız istenince planlanır): altyazı satırlarının Türkçesi (`cues[].tr`, anlam
panelinde "Türkçesini göster"), satır başına bir parça `sub-<satır>` (ör. `sub-s02-01`); aynı Türkçe metin bir kez.
Söyleniş sözlüğü ayrı: `narrationTr.translationPronunciations` (alıştırma sesinin anahtarı değişmesin).
Metin uygulamada gösterilenin aynısıdır. Ses Hi (`icerik/_evren/sesler.json` → `hi`; reel.json →
`narrationTr.role` ile değiştirilebilir); söyleniş sözlüğü isteğe bağlı `narrationTr.pronunciations`
(kelime sınırında, büyük/küçük harfe duyarlı; kitaplardaki kural).

Dosyalar (`reeller/<id>/audio/tr/`): `<parça>.mp3` (git dışı, -16 LUFS), `<parça>.align.json` (depoda),
`_raw/` (ödenmiş ham WAV + Duyu; git dışı). Kayıt `reeller/<id>/PROMPTS.md`, defter tts_tr ile ortak.

Paket (`_build/package/`): güncel sesi olan parça `audio/tr/<parça>.m4a` olarak kopyalanır (-16 LUFS) ve paket
`reel.json` → `practice.audioTr = {"prompt": {audio, duration, textSha256}, "explain": {…}}` yazılır; altyazı
satırı sesi `cues[].trAudio = "audio/tr/sub-<satır>.m4a"` (satırın Türkçesi sesli metinle birebir aynıysa). Eksik
ya da eskimiş ses paketi durdurmaz (uygulama düğmeyi göstermez). Ücretli çağrı yoktur.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path

from . import REPO_ROOT, tts_tr
from .book import text_sha256

TR_AUDIO_DIR = "audio/tr"
PROMPT_ID = "practice-prompt"
EXPLAIN_ID = "practice-explain"
PACKAGE_KEYS = {PROMPT_ID: "prompt", EXPLAIN_ID: "explain"}
SUB_PREFIX = "sub-"
PARTS = ("practice", "subtitles")
DEFAULT_PARTS = ("practice",)
DEFAULT_ROLE = "hi"
VOICE_MAP = REPO_ROOT / "icerik" / "_evren" / "sesler.json"
PROMPTS_FILE = "PROMPTS.md"


class ReelTrError(ValueError):
    pass


def _clean(s) -> str | None:
    t = s.strip() if isinstance(s, str) else ""
    return t or None


def _with_stop(s: str) -> str:
    return s if s[-1:] in ".!?…:;\"'”’)" else s + "."


def source_doc(root: Path) -> dict:
    """Kaynak `reel.json` (paket değil): seslendirme kaynaktan yapılır."""
    p = Path(root) / "reel.json"
    try:
        doc = json.loads(p.read_text(encoding="utf-8"))
    except (OSError, ValueError) as e:
        raise ReelTrError(f"{p} okunamadı: {e}") from e
    if not isinstance(doc, dict):
        raise ReelTrError(f"{p}: nesne bekleniyordu")
    return doc


def practice_turkish(doc: dict) -> list[tuple[str, str]]:
    """(parça kimliği, metin) — yalnız Türkçe metni olan parçalar."""
    p = doc.get("practice")
    if not isinstance(p, dict):
        return []
    out = []
    prompt = _clean(p.get("promptTr"))
    if prompt:
        opts = p.get("options") if isinstance(p.get("options"), list) else []
        texts = [_clean(o.get("text")) for o in opts if isinstance(o, dict)]
        all_tr = bool(texts) and all(t for t in texts) and \
            all((o.get("lang") or "tr") == "tr" for o in opts if isinstance(o, dict))
        parts = [_with_stop(prompt)] + ([_with_stop(t) for t in texts] if all_tr else [])
        out.append((PROMPT_ID, " ".join(parts)))
    explain = _clean(p.get("explainTr"))
    if explain:
        out.append((EXPLAIN_ID, explain))
    return out


def subtitle_turkish(doc: dict) -> list[tuple[str, str]]:
    """H-109 Faz 3: (parça kimliği, metin) — altyazı satırlarının Türkçesi, satır sırasıyla; aynı metin bir kez."""
    out, seen = [], set()
    for c in doc.get("cues") or []:
        if not isinstance(c, dict) or not isinstance(c.get("id"), str):
            continue
        t = _clean(c.get("tr"))
        if t and t not in seen:
            seen.add(t)
            out.append((f"{SUB_PREFIX}{c['id']}", t))
    return out


def part_of(seg_id: str) -> str:
    return "subtitles" if seg_id.startswith(SUB_PREFIX) else "practice"


def narration_tr(doc: dict) -> dict:
    n = doc.get("narrationTr") or {}
    return n if isinstance(n, dict) else {}


def voice_for(doc: dict, voice_map: Path | None = None) -> tuple[str, str | None, str]:
    role = narration_tr(doc).get("role") or DEFAULT_ROLE
    p = Path(voice_map or VOICE_MAP)
    d = json.loads(p.read_text(encoding="utf-8"))["turkish"]
    r = d["roles"].get(role)
    if r is None:
        raise ReelTrError(f"{doc.get('id')}: narrationTr.role bilinmiyor: {role} ({p})")
    if not str(r.get("voice", "")).startswith("alania"):
        raise ReelTrError(f"{doc.get('id')}: Türkçe ses Alania olmalı ({r.get('voice')})")
    return r["voice"], r.get("instructions"), d.get("model", tts_tr.TTS_MODEL)


def _terms_in(text: str, prons: list[dict]) -> list[dict] | None:
    out, seen = [], set()
    for q in prons:
        term = q["term"]
        if term not in seen and re.search(rf"(?<![\w'’]){re.escape(term)}(?![\w])", text):
            out.append({"term": term, "say_as": q["say_as"]})
            seen.add(term)
    return out or None


def translation_pronunciations(doc: dict) -> list[dict]:
    return tts_tr.check_pronunciations(narration_tr(doc).get("translationPronunciations"),
                                       f"{doc.get('id')} narrationTr.translationPronunciations", ReelTrError)


def segments(doc: dict, voice_map: Path | None = None, only: list[str] | None = None,
             parts: tuple[str, ...] = DEFAULT_PARTS) -> list[tts_tr.Segment]:
    bad = [p for p in parts if p not in PARTS]
    if bad:
        raise ReelTrError(f"bilinmeyen bölüm: {', '.join(bad)} ({', '.join(PARTS)})")
    _, ins, _ = voice_for(doc, voice_map)
    segs = []
    if "practice" in parts:
        prons = tts_tr.check_pronunciations(narration_tr(doc).get("pronunciations"),
                                            f"{doc.get('id')} narrationTr", ReelTrError)
        segs += [tts_tr.Segment(sid, text, ins, _terms_in(text, prons))
                 for sid, text in practice_turkish(doc) if not only or sid in only]
    if "subtitles" in parts:
        tprons = translation_pronunciations(doc)
        segs += [tts_tr.Segment(sid, text, ins, _terms_in(text, tprons))
                 for sid, text in subtitle_turkish(doc) if not only or sid in only]
    try:
        return tts_tr.check_segments(segs, allow_empty=True)
    except tts_tr.TrTtsError as e:
        raise ReelTrError(f"{doc.get('id')}: {e}") from e


def out_dir(root: Path) -> Path:
    return Path(root) / TR_AUDIO_DIR


def plan_reel(root: Path, voice_map: Path | None = None, only: list[str] | None = None,
              force: bool = False, doc: dict | None = None, parts: tuple[str, ...] = DEFAULT_PARTS) -> tts_tr.Plan:
    doc = doc if doc is not None else source_doc(root)
    voice, _, model = voice_for(doc, voice_map)
    return tts_tr.plan_segments(segments(doc, voice_map, only, parts), out_dir(root), voice, model, force)


def english_in_subtitles(doc: dict, segs: list[tts_tr.Segment] | None = None) -> dict[str, list[str]]:
    """Altyazı Türkçesinde sözlükle karşılanmamış İngilizce kelime/ad → parçalar (H-109 Faz 3)."""
    from .lesson import english_in_translation
    try:
        prons = translation_pronunciations(doc)
    except ReelTrError:
        prons = []
    found: dict[str, list[str]] = {}
    for sid, text in ([(s.id, s.text) for s in segs] if segs is not None else subtitle_turkish(doc)):
        if part_of(sid) != "subtitles":
            continue
        for w in english_in_translation(text, prons):
            found.setdefault(w, []).append(sid)
    return found


def prompts_path(root: Path) -> Path:
    return Path(root) / PROMPTS_FILE


# --- durum (lint ve paket ortak) -----------------------------------------------------------------

@dataclass
class SegAudio:
    id: str
    text: str
    state: str          # ok | no-audio (hizalama var, mp3 bu ortamda yok) | stale | none
    align: Path
    audio: Path
    quality_ok: bool | None = None


def seg_audio(root: Path, doc: dict | None = None, voice_map: Path | None = None,
              parts: tuple[str, ...] = PARTS) -> list[SegAudio]:
    """Türkçesi olan her parça için ses durumu (varsayılan bütün bölümler: alıştırma + altyazı). `stale`:
    hizalamanın anahtarı güncel metinle uyuşmuyor."""
    plan = plan_reel(root, voice_map, doc=doc, parts=parts)
    out = []
    for j in plan.jobs:
        ap, mp = plan.align(j), plan.audio(j)
        if not ap.exists():
            out.append(SegAudio(j.seg.id, j.seg.text, "none", ap, mp))
            continue
        try:
            a = json.loads(ap.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            out.append(SegAudio(j.seg.id, j.seg.text, "stale", ap, mp))
            continue
        q = (a.get("quality") or {}).get("ok")
        state = "stale" if a.get("key") != j.key else ("ok" if mp.exists() else "no-audio")
        out.append(SegAudio(j.seg.id, j.seg.text, state, ap, mp, q))
    return out


def check_reel(root: Path, doc: dict | None = None, voice_map: Path | None = None) -> tuple[list[tuple[str, str]], dict]:
    """reel-lint: (düzey, ileti) listesi ve sayım. Eksik ses reel başına tek uyarı; eskimiş ses, yerelde
    olmayan ses dosyası, zayıf hizalama ve sahipsiz dosya uyarı; bozuk söyleniş sözlüğü hata."""
    try:
        segs = seg_audio(root, doc, voice_map, parts=("practice",))
    except (ReelTrError, OSError, KeyError, ValueError) as e:
        return [("error", str(e))], {}
    issues: list[tuple[str, str]] = []
    try:       # altyazı bölümündeki bir veri hatası alıştırma denetimini durdurmaz (H-109 Faz 3)
        segs += seg_audio(root, doc, voice_map, parts=("subtitles",))
    except (ReelTrError, OSError, KeyError, ValueError) as e:
        issues.append(("error", f"altyazı Türkçesi ses parçaları kurulamadı: {e}"))

    def stats(ss: list[SegAudio]) -> dict:
        return {"segments": len(ss), "chars": sum(len(s.text) for s in ss),
                "aligned": sum(1 for s in ss if s.state in ("ok", "no-audio")),
                "audio": sum(1 for s in ss if s.state == "ok"), "stale": sum(1 for s in ss if s.state == "stale")}

    practice = [s for s in segs if part_of(s.id) == "practice"]
    subs = [s for s in segs if part_of(s.id) == "subtitles"]
    st = stats(practice) | {"subtitles": stats(subs)}
    none = [s.id for s in practice if s.state == "none"]
    if none:
        issues.append(("warning", f"alıştırmanın Türkçe sesi yok: {', '.join(none)} (tts_reel_tr.py)"))
    sub_none = [s.id for s in subs if s.state == "none"]
    if sub_none:
        issues.append(("warning", f"{len(sub_none)}/{len(subs)} altyazı çevirisinin Türkçe sesi yok "
                                  f"({', '.join(sub_none[:4])}{' …' if len(sub_none) > 4 else ''}); "
                                  "tts_reel_tr.py --part subtitles"))
    src = doc if doc is not None else source_doc(root)
    found = english_in_subtitles(src)
    if found:
        issues.append(("warning", f"altyazı Türkçesinde söyleniş sözlüğünde olmayan İngilizce kelime/ad: "
                                  f"{', '.join(sorted(found))} (Alania Türkçe okur → reel.json "
                                  "`narrationTr.translationPronunciations`)"))
    for s in segs:
        if s.state == "stale":
            issues.append(("warning", f"{s.id}: Türkçe ses eski metinden; pakete girmez — tts_reel_tr.py ile "
                                      "yeniden üret"))
        elif s.state == "no-audio":
            issues.append(("warning", f"{s.id}: Türkçe ses bu ortamda yok (git dışı medya): "
                                      f"{s.audio.relative_to(root)}"))
        if s.state in ("ok", "no-audio") and s.quality_ok is False:
            issues.append(("warning", f"{s.id}: Türkçe ses hizalaması zayıf (Duyu); kulakla dinlenmeli"))
    known = {s.id for s in segs}
    d = out_dir(root)
    if d.exists():
        for f in sorted(d.glob("*.align.json")):
            sid = f.name.removesuffix(".align.json")
            if sid not in known:
                issues.append(("warning", f"{sid}: Türkçe sesi var ama metni yok ({f.relative_to(root)})"))
    return issues, st


def check_package(pkg_doc: dict, pkg_dir: Path) -> list[tuple[str, str]]:
    """Paket `reel.json` → `practice.audioTr`: dosya var mı, metin sha256'sı güncel metinle aynı mı."""
    p = pkg_doc.get("practice")
    at = p.get("audioTr") if isinstance(p, dict) else None
    if at is None:
        return _check_package_cues(pkg_doc, pkg_dir)
    if not isinstance(at, dict):
        return [("error", "practice.audioTr nesne olmalı")] + _check_package_cues(pkg_doc, pkg_dir)
    texts = {PACKAGE_KEYS[sid]: t for sid, t in practice_turkish(pkg_doc)}
    out = []
    for k, v in at.items():
        if k not in PACKAGE_KEYS.values() or not isinstance(v, dict) or not isinstance(v.get("audio"), str):
            out.append(("error", f"practice.audioTr.{k}: `prompt|explain: {{audio, duration, textSha256}}` olmalı"))
            continue
        if not (pkg_dir / v["audio"]).exists():
            out.append(("warning", f"practice.audioTr.{k}: ses dosyası yok: {v['audio']}"))
        if k not in texts or v.get("textSha256") != text_sha256(texts[k]):
            out.append(("warning", f"practice.audioTr.{k}: ses başka bir metinden; paketi yeniden kur "
                                   "(tts_reel_tr.py --package)"))
    return out + _check_package_cues(pkg_doc, pkg_dir)


def _check_package_cues(pkg_doc: dict, pkg_dir: Path) -> list[tuple[str, str]]:
    """H-109 Faz 3: altyazı satırı `trAudio` → `audio/tr/sub-*.m4a` ve dosya var mı."""
    out = []
    for c in pkg_doc.get("cues") or []:
        if not isinstance(c, dict) or "trAudio" not in c:
            continue
        a = c["trAudio"]
        if not isinstance(a, str) or not re.fullmatch(rf"{TR_AUDIO_DIR}/{SUB_PREFIX}[A-Za-z0-9_.-]+\.m4a", a) \
                or ".." in a:
            out.append(("error", f"cues[{c.get('id')}].trAudio: `{TR_AUDIO_DIR}/{SUB_PREFIX}<satır>.m4a` olmalı"))
        elif not _clean(c.get("tr")):
            out.append(("warning", f"cues[{c.get('id')}].trAudio: satırın Türkçesi yok"))
        elif not (pkg_dir / a).exists():
            out.append(("warning", f"cues[{c.get('id')}].trAudio: ses dosyası yok: {a}"))
    return out


# --- paket ---------------------------------------------------------------------------------------

@dataclass
class PackageResult:
    reel_id: str
    packaged: list[str]
    missing: list[dict]


def package_tr(root: Path, media=None, voice_map: Path | None = None) -> PackageResult:
    """Kurulmuş paketi (`_build/package/reel.json`) Türkçe alıştırma sesiyle günceller. Video yeniden kurulmaz.
    Eski `audioTr` ve eski `audio/tr/` dosyaları önce kaldırılır (metin değiştiyse eski ses kalmasın)."""
    root = Path(root)
    pkg = root / "_build" / "package"
    rj = pkg / "reel.json"
    if not rj.is_file():
        raise ReelTrError(f"paket yok: {rj} (önce build_reel.py)")
    doc = json.loads(rj.read_text(encoding="utf-8"))
    if media is None:
        from .bookexport import LocalMedia
        media = LocalMedia()
    src = source_doc(root)
    practice = doc.get("practice") if isinstance(doc.get("practice"), dict) else None
    cues = [c for c in doc.get("cues") or [] if isinstance(c, dict)]
    if (practice is not None and "audioTr" in practice) or any("trAudio" in c for c in cues):
        # Önce eski bağ, sonra eski dosyalar kaldırılır; parça kurulumu aşağıda hata verse de pakette
        # eskimiş ses ya da silinmiş sese işaret eden bağ kalmaz.
        if practice is not None:
            practice.pop("audioTr", None)
        for c in cues:
            c.pop("trAudio", None)
        rj.write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    tr_dir = pkg / TR_AUDIO_DIR
    if tr_dir.exists():
        for f in tr_dir.glob("*.m4a"):
            f.unlink()
    segs = seg_audio(root, src, voice_map, parts=("practice",))
    sub_error = None
    try:       # altyazı bölümündeki bir veri hatası alıştırma sesini paketten düşürmez
        segs += seg_audio(root, src, voice_map, parts=("subtitles",))
    except (ReelTrError, OSError, KeyError, ValueError) as e:
        sub_error = str(e)
    packaged, missing, audio_tr = [], [], {}
    pkg_texts = dict(practice_turkish(doc))
    cue_texts = {t for _, t in subtitle_turkish(doc)}
    sub_audio: dict[str, str] = {}
    for s in segs:
        sub = part_of(s.id) == "subtitles"
        if s.state != "ok" or (practice is None and not sub):
            if s.state in ("no-audio", "stale"):
                missing.append({"segment": s.id, "reason": s.state, "path": str(s.audio.relative_to(root))})
            continue
        if sub:
            if s.text not in cue_texts:      # paket kaynaktan eski: paketi önce yeniden kur
                missing.append({"segment": s.id, "reason": "package-stale", "path": str(rj.relative_to(root))})
                continue
            rel = f"{TR_AUDIO_DIR}/{s.id}.m4a"
            i = media.loudness([s.audio]).get("I")
            gain = media.target_lufs - i if isinstance(i, (int, float)) and i > -70.0 else 0.0
            media.audio(s.audio, gain, pkg / rel)
            sub_audio[s.text] = rel
            packaged.append(s.id)
            continue
        if pkg_texts.get(s.id) != s.text:     # paket kaynaktan eski: paketi önce yeniden kur
            missing.append({"segment": s.id, "reason": "package-stale", "path": str(rj.relative_to(root))})
            continue
        rel = f"{TR_AUDIO_DIR}/{s.id}.m4a"
        i = media.loudness([s.audio]).get("I")
        gain = media.target_lufs - i if isinstance(i, (int, float)) and i > -70.0 else 0.0
        media.audio(s.audio, gain, pkg / rel)
        audio_tr[PACKAGE_KEYS[s.id]] = {"audio": rel, "duration": round(media.duration(pkg / rel), 3),
                                        "textSha256": text_sha256(s.text)}
        packaged.append(s.id)
    for c in cues:
        a = sub_audio.get(_clean(c.get("tr")) or "")
        if a:
            c["trAudio"] = a
    if practice is not None and audio_tr:
        practice["audioTr"] = audio_tr
    if practice is not None or sub_audio:
        rj.write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    if sub_error:
        missing.append({"segment": "subtitles", "reason": "error", "path": sub_error})
    return PackageResult(str(doc.get("id")), packaged, missing)
