"""Bölüm çevirilerinin Türkçe sesi (H-109 Faz 3): PatientDesk Alania + Duyu, tts_tr ile.

Kapsam: uygulamanın anlam panelinde ("Türkçesini göster") gösterdiği **cümle çevirileri** — `ceviri.tr.json`
`lines[].tr` ve `phrases[].tr`, yalnız pakette gerçekten bir yere bağlananlar (altyazı satırı, kart satırı,
karar repliği, görev kökü, 🎯 hedef ifade). Hangi metnin bağlandığı kuru derlemeden (`build_dry`) okunur;
kalıp (`chunks`) ve kelime anlamları (`words`, bölüm sözlüğü) kelime düzeyindedir, seslendirilmez. Bağlanmayan
satırlar (ör. `TITLE`, `CARD`, `TASK` taslakları) ses almaz.

Parça kimliği sabittir ve İngilizce metinden gelir: `l-<sha256(İngilizce)[:10]>` (satır), `p-<…>` (ifade). Türkçe
düzeltilse de kimlik kaymaz (ses eskimiş sayılır); aynı Türkçe metin bölümde bir kez seslendirilir. Ses Hi
(`icerik/_evren/sesler.json` → `hi`); söyleniş sözlüğü `ceviri.tr.json → pronunciations` (yalnız çeviri sesine
gider; kelime sınırında, büyük/küçük harfe duyarlı).

Dosyalar (`icerik/<bölüm>/audio/ceviri/`): `<parça>.mp3` (git dışı, -16 LUFS), `<parça>.align.json` (depoda),
`_raw/` (ödenmiş ham WAV + Duyu; git dışı). Kayıt bölümün `PROMPTS.md`'si, defter tts_tr ile ortak.

Paket: güncel sesi olan parça `audio/ceviri/<parça>.m4a` (-16 LUFS) olarak kopyalanır; `scenes.json →
episode.translationAudio = {Türkçe metin: yol}` ve altyazı satırında `trAudio` yazılır (Keşfet klipleri satırı
olduğu gibi kopyalar). Eksik ya da eskimiş ses paketi durdurmaz (uygulama düğmeyi göstermez). Ücretli çağrı yok.
"""

from __future__ import annotations

import hashlib
import json
from dataclasses import dataclass
from pathlib import Path

from . import REPO_ROOT, tts_tr
from .lesson import english_in_translation, terms_in
from .translation import TRANSLATION_FILE, norm_text

TL_DIR = "audio/ceviri"
DEFAULT_ROLE = "hi"
VOICE_MAP = REPO_ROOT / "icerik" / "_evren" / "sesler.json"
PROMPTS_FILE = "PROMPTS.md"
# Paketteki `tr` alanlarından ses almayanlar: kelime ve kalıp düzeyi (kalıp, görev kalıbı, bölüm sözlüğü).
_SKIP_KEYS = {"chunks", "stemChunks", "glossary"}


class EpisodeTlError(ValueError):
    pass


def _hash(s: str) -> str:
    return hashlib.sha256(norm_text(s).encode("utf-8")).hexdigest()[:10]


def ceviri(ep_dir: Path) -> dict | None:
    p = Path(ep_dir) / TRANSLATION_FILE
    if not p.exists():
        return None
    try:
        d = json.loads(p.read_text(encoding="utf-8"))
    except (OSError, ValueError) as e:
        raise EpisodeTlError(f"{p} okunamadı: {e}") from e
    if not isinstance(d, dict):
        raise EpisodeTlError(f"{p}: nesne bekleniyordu")
    return d


def collect_tr(doc, out: set[str], skip: bool = False) -> set[str]:
    """Paket belgesindeki (scenes.json, altyazı) cümle düzeyi `tr` metinleri."""
    if isinstance(doc, dict):
        for k, v in doc.items():
            if k == "tr" and isinstance(v, str) and not skip:
                out.add(v.strip())
            elif k == "translationAudio":
                continue
            else:
                collect_tr(v, out, skip or k in _SKIP_KEYS)
    elif isinstance(doc, list):
        for x in doc:
            collect_tr(x, out, skip)
    return out


def used_texts(ep_dir: Path) -> set[str]:
    """Kuru derlemede bir yere bağlanan Türkçe cümleler."""
    from .build import BuildError, build_dry
    try:
        doc, b = build_dry(Path(ep_dir))
    except (BuildError, FileNotFoundError, KeyError) as e:
        raise EpisodeTlError(f"{Path(ep_dir).name}: kuru derleme yapılamadı: {e}") from e
    out: set[str] = set()
    collect_tr(doc, out)
    for sub in b.subs.values():
        collect_tr(sub, out)
    return out


def translation_items(ep_dir: Path, used: set[str] | None = None) -> list[tuple[str, str]]:
    """(parça kimliği, Türkçe metin): `lines` sonra `phrases`, dosyadaki sırayla; yalnız bağlananlar; aynı Türkçe
    metin bir kez. `used` verilmezse kuru derlemeden hesaplanır."""
    d = ceviri(ep_dir)
    if d is None:
        return []
    if used is None:
        used = used_texts(ep_dir)
    out, seen_tr, seen_en = [], set(), set()
    for kind, key in (("l", "lines"), ("p", "phrases")):
        for ln in d.get(key) or []:
            if not isinstance(ln, dict):
                continue
            en, t = norm_text(ln.get("en", "")), (ln.get("tr") or "").strip() if isinstance(ln.get("tr"), str) else ""
            if not en or not t:
                continue
            if kind == "l":
                if en in seen_en:       # Translation.find ilk satırı kullanır
                    continue
                seen_en.add(en)
            if t in seen_tr or t not in used:
                continue
            seen_tr.add(t)
            out.append((f"{kind}-{_hash(en)}", t))
    return out


def pronunciations(ep_dir: Path, doc: dict | None = None) -> list[dict]:
    d = doc if doc is not None else (ceviri(ep_dir) or {})
    return tts_tr.check_pronunciations(d.get("pronunciations"), f"{Path(ep_dir).name} {TRANSLATION_FILE}",
                                       EpisodeTlError)


def voice(voice_map: Path | None = None) -> tuple[str, str | None, str]:
    p = Path(voice_map or VOICE_MAP)
    d = json.loads(p.read_text(encoding="utf-8"))["turkish"]
    r = d["roles"].get(DEFAULT_ROLE)
    if r is None or not str(r.get("voice", "")).startswith("alania"):
        raise EpisodeTlError(f"{p}: `{DEFAULT_ROLE}` rolü Alania sesi olmalı")
    return r["voice"], r.get("instructions"), d.get("model", tts_tr.TTS_MODEL)


def segments(ep_dir: Path, voice_map: Path | None = None, only: list[str] | None = None,
             used: set[str] | None = None) -> list[tts_tr.Segment]:
    _, ins, _ = voice(voice_map)
    prons = pronunciations(ep_dir)
    segs = [tts_tr.Segment(sid, text, ins, terms_in(text, prons))
            for sid, text in translation_items(ep_dir, used) if not only or sid in only]
    try:
        return tts_tr.check_segments(segs, allow_empty=True)
    except tts_tr.TrTtsError as e:
        raise EpisodeTlError(f"{Path(ep_dir).name}: {e}") from e


def out_dir(ep_dir: Path) -> Path:
    return Path(ep_dir) / TL_DIR


def plan_episode(ep_dir: Path, voice_map: Path | None = None, only: list[str] | None = None, force: bool = False,
                 used: set[str] | None = None) -> tts_tr.Plan:
    v, _, model = voice(voice_map)
    return tts_tr.plan_segments(segments(ep_dir, voice_map, only, used), out_dir(ep_dir), v, model, force)


def prompts_path(ep_dir: Path) -> Path:
    return Path(ep_dir) / PROMPTS_FILE


def english_report(ep_dir: Path, segs: list[tts_tr.Segment]) -> dict[str, list[str]]:
    """Sözlükle karşılanmamış İngilizce kelime/ad → parçalar."""
    try:
        prons = pronunciations(ep_dir)
    except EpisodeTlError:
        prons = []
    found: dict[str, list[str]] = {}
    for s in segs:
        for w in english_in_translation(s.text, prons):
            found.setdefault(w, []).append(s.id)
    return found


# --- durum (lint ve paket ortak) -----------------------------------------------------------------

@dataclass
class SegAudio:
    id: str
    text: str
    state: str          # ok | no-audio (hizalama var, mp3 bu ortamda yok) | stale | none
    align: Path
    audio: Path
    quality_ok: bool | None = None


def seg_audio(ep_dir: Path, voice_map: Path | None = None, used: set[str] | None = None) -> list[SegAudio]:
    """Sesi planlanan her çeviri için durum. `stale`: hizalamanın anahtarı (metin + ses + model + üslup +
    söyleniş) güncel parçayla uyuşmuyor."""
    plan = plan_episode(ep_dir, voice_map, used=used)
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


def check_episode(ep_dir: Path, voice_map: Path | None = None) -> tuple[list[tuple[str, str, str]], dict]:
    """content-lint: (düzey, kod, ileti) ve sayım. Eksik ses bölüm başına tek uyarı; eskimiş ses, yerelde
    olmayan ses dosyası, zayıf hizalama, sahipsiz dosya uyarı; sözlükte olmayan İngilizce bölüm başına tek
    uyarı; bozuk sözlük ya da kurulamayan plan hata."""
    ep_dir = Path(ep_dir)
    if ceviri(ep_dir) is None:
        return [], {}
    try:
        segs = seg_audio(ep_dir, voice_map)
        planned = segments(ep_dir, voice_map, used={s.text for s in segs})
    except (EpisodeTlError, tts_tr.TrTtsError, OSError, KeyError, ValueError) as e:
        return [("error", "translation-audio", str(e))], {}
    issues: list[tuple[str, str, str]] = []
    st = {"segments": len(segs), "chars": sum(len(s.text) for s in segs),
          "aligned": sum(1 for s in segs if s.state in ("ok", "no-audio")),
          "audio": sum(1 for s in segs if s.state == "ok"), "stale": sum(1 for s in segs if s.state == "stale")}
    none = [s.id for s in segs if s.state == "none"]
    if none:
        issues.append(("warning", "translation-audio",
                       f"{len(none)}/{len(segs)} çevirinin Türkçe sesi yok ({', '.join(none[:4])}"
                       f"{' …' if len(none) > 4 else ''}); tts_episode_tr.py --part translation"))
    for s in segs:
        if s.state == "stale":
            issues.append(("warning", "translation-audio", f"{s.id}: çeviri sesi eski metinden ya da ayardan; pakete "
                                                           "girmez — tts_episode_tr.py --part translation ile yeniden üret"))
        elif s.state == "no-audio":
            issues.append(("warning", "translation-audio", f"{s.id}: çeviri sesi bu ortamda yok (git dışı medya): "
                                                           f"{s.audio.relative_to(ep_dir)}"))
        if s.state in ("ok", "no-audio") and s.quality_ok is False:
            issues.append(("warning", "translation-audio", f"{s.id}: çeviri sesinin hizalaması zayıf (Duyu); "
                                                           "kulakla dinlenmeli"))
    found = english_report(ep_dir, planned)
    if found:
        issues.append(("warning", "translation-english",
                       f"çevirilerde söyleniş sözlüğünde olmayan İngilizce kelime/ad: {', '.join(sorted(found))} "
                       f"({len({q for v in found.values() for q in v})} çeviride; Alania Türkçe okur → "
                       f"{TRANSLATION_FILE} `pronunciations`)"))
    known = {s.id for s in segs}
    d = out_dir(ep_dir)
    if d.exists():
        for f in sorted(d.glob("*.align.json")):
            sid = f.name.removesuffix(".align.json")
            if sid not in known:
                issues.append(("warning", "translation-audio", f"{sid}: çeviri sesi var ama çevirisi yok ya da "
                                                               f"bağlanmıyor ({f.relative_to(ep_dir)})"))
    return issues, st


def check_package(doc: dict, subs: dict[str, dict], pkg_dir: Path) -> list[tuple[str, str]]:
    """Paket: `episode.translationAudio` ve altyazı `trAudio` dosyası var mı, metne bağlı mı."""
    out = []
    ta = (doc.get("episode") or {}).get("translationAudio")
    if ta is not None and not isinstance(ta, dict):
        return [("error", "episode.translationAudio {Türkçe metin: yol} olmalı")]
    ta = ta or {}
    for text, rel in ta.items():
        if not isinstance(rel, str) or not rel.startswith(TL_DIR + "/"):
            out.append(("error", f"translationAudio[{text!r}]: `{TL_DIR}/<parça>.m4a` olmalı"))
        elif not (pkg_dir / rel).exists():
            out.append(("warning", f"translationAudio: ses dosyası yok: {rel}"))
    paths = set(ta.values())
    for rel_sub, sub in subs.items():
        for c in sub.get("cues", []):
            a = c.get("trAudio")
            if a is None:
                continue
            if ta.get((c.get("tr") or "").strip()) != a:
                out.append(("warning", f"{rel_sub}#{c.get('id')}: trAudio satırın Türkçesine bağlı değil "
                                       "(paketi yeniden kur: tts_episode_tr.py --part translation --package)"))
            elif a not in paths:
                out.append(("warning", f"{rel_sub}#{c.get('id')}: trAudio dosyası yok: {a}"))
    return out


# --- paket ---------------------------------------------------------------------------------------

@dataclass
class PackageResult:
    episode: str
    packaged: list[str]
    missing: list[dict]


def attach(ep_dir: Path, pkg: Path, doc: dict, subs: dict[str, dict], media=None,
           voice_map: Path | None = None, before_unlink=None) -> PackageResult:
    """Bellekteki paket belgelerine (scenes.json + altyazılar) çeviri seslerini bağlar ve güncel sesleri
    `pkg/audio/ceviri/` altına kopyalar. Eski bağlar ve eski dosyalar önce kaldırılır. Sesler kuru derlemenin
    değil **paketin** gerçekten gösterdiği metinlere göre bağlanır."""
    ep_dir, pkg = Path(ep_dir), Path(pkg)
    episode = doc.setdefault("episode", {})
    episode.pop("translationAudio", None)
    for sub in subs.values():
        for c in sub.get("cues", []):
            c.pop("trAudio", None)
    if before_unlink is not None:      # yerinde güncellemede: eski bağsız belgeler dosyalar silinmeden yazılır
        before_unlink()
    tdir = pkg / TL_DIR
    if tdir.exists():
        for f in tdir.glob("*.m4a"):
            f.unlink()
    if ceviri(ep_dir) is None:
        return PackageResult(str(episode.get("id")), [], [])
    shown: set[str] = set()
    collect_tr(doc, shown)
    for sub in subs.values():
        collect_tr(sub, shown)
    segs = seg_audio(ep_dir, voice_map, used=shown)
    if media is None:
        from .bookexport import LocalMedia
        media = LocalMedia()
    packaged, missing, by_text = [], [], {}
    for s in segs:
        if s.state != "ok":
            if s.state in ("no-audio", "stale"):
                missing.append({"segment": s.id, "reason": s.state, "path": str(s.audio.relative_to(ep_dir))})
            continue
        rel = f"{TL_DIR}/{s.id}.m4a"
        try:       # bozuk tek ses paketi durdurmaz: o çeviri sessiz kalır
            i = media.loudness([s.audio]).get("I")
            gain = media.target_lufs - i if isinstance(i, (int, float)) and i > -70.0 else 0.0
            media.audio(s.audio, gain, pkg / rel)
        except Exception as e:  # noqa: BLE001 — MediaError, OSError …
            (pkg / rel).unlink(missing_ok=True)
            missing.append({"segment": s.id, "reason": "media", "path": f"{s.audio.relative_to(ep_dir)}: {e}"})
            continue
        by_text[s.text] = rel
        packaged.append(s.id)
    if by_text:
        episode["translationAudio"] = dict(sorted(by_text.items()))
        for sub in subs.values():
            for c in sub.get("cues", []):
                a = by_text.get((c.get("tr") or "").strip()) if isinstance(c.get("tr"), str) else None
                if a:
                    c["trAudio"] = a
    return PackageResult(str(episode.get("id")), packaged, missing)


def package_built(ep_dir: Path, media=None, voice_map: Path | None = None) -> PackageResult:
    """Kurulmuş paketi (`_build/package`) yerinde günceller: video yeniden kurulmaz; scenes.json, altyazılar ve
    manifest dosya listesi yeniden yazılır."""
    from .build import file_digest
    from .export import rendition_bytes
    ep_dir = Path(ep_dir)
    pkg = ep_dir / "_build" / "package"
    sp = pkg / "scenes.json"
    if not sp.is_file():
        raise EpisodeTlError(f"paket yok: {sp} (önce export_package.py)")
    doc = json.loads(sp.read_text(encoding="utf-8"))
    subs = {}
    for f in sorted((pkg / "subs").glob("*.json")) if (pkg / "subs").exists() else []:
        subs[f"subs/{f.name}"] = json.loads(f.read_text(encoding="utf-8"))
    def write() -> None:
        for rel, sub in subs.items():
            (pkg / rel).write_text(json.dumps(sub, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
        sp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    r = attach(ep_dir, pkg, doc, subs, media, voice_map, before_unlink=write)
    write()
    mp = pkg / "manifest.json"
    if mp.exists():
        m = json.loads(mp.read_text(encoding="utf-8"))
        files = sorted(p for p in pkg.rglob("*") if p.is_file() and p.name != "manifest.json")
        m["files"] = [{"path": str(p.relative_to(pkg)), "bytes": p.stat().st_size, "sha256": file_digest(p)}
                      for p in files]
        m["totalBytes"] = sum(f["bytes"] for f in m["files"])
        m["translationMissing"] = r.missing
        if "renditionBytes" in m:
            m["renditionBytes"] = rendition_bytes(m["files"])
        mp.write_text(json.dumps(m, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return r


__all__ = ["EpisodeTlError", "translation_items", "segments", "plan_episode", "seg_audio", "check_episode",
           "check_package", "attach", "package_built", "english_report", "TL_DIR"]
