"""Sezon paketindeki Türkçe metinlerin sesi (H-109 Faz 3b): PatientDesk Alania + Duyu, tts_tr ile. Ses Hi.

Kullanıcı kararı (2026-11-27): Türkçe gösterilen her yerde Türkçe ses. Üç yer, her biri ayrı bölüm (`--part`):

- `talk` — Konuş (`icerik/_evren/konusma/*.json`): karakter repliğinin Türkçesi (`turns[].line.tr`), mesaj
  görevinin örnek cevabının Türkçesi (`model.tr`) ve kapanış repliğinin Türkçesi (`outro.tr`). Uygulamada
  Türkçe bir destektir: "Türkçesi" açılınca görünür; düğme de yalnız o zaman görünür. Parça kimliği
  `<görev>-<tur>-line`, `<görev>-model`, `<görev>-outro`. Pakette `talk/ceviri-<parça>.m4a`, satırda `trAudio`.
- `sets` — Konu setlerinin örnek cümlesinin Türkçesi (`items[].exampleTr`; Defter/Kelime tekrarı kartının arka
  yüzünde, cevaptan sonra görünür). Parça `<set>-<öğe>-ex`; pakette `sets/<set>/tr-<öğe>.m4a`, öğede
  `exampleTrAudio` (`sets/` altına göre yol). Soru yüzünde Türkçe gösterilmez; uygulama düğmeyi yalnız Türkçe
  metnin görünür olduğu kart yüzünde çizer (cevabı ele vermez).
- `clips` — Keşfet bölüm kliplerinin alıştırması (`klipler/S<n>.json → clips[].quiz`), reel alıştırmasının
  (H-109 Faz 1, `reeltr.py`) aynı kuralıyla: `<klip>-prompt` (soru + seçenekler, yalnız hepsi Türkçeyse,
  kaynaktaki sırayla) ve `<klip>-explain` (cevaptan sonra görünen açıklama). Pakette
  `clips/<klip>.tr-prompt.m4a`, `quiz.audioTr = {prompt|explain: {audio, textSha256}}`.

Söyleniş sözlükleri (yalnız bu seslere gider; Hi'nin yönlendirme seslerinin anahtarı değişmez): Konuş görevinde
`translationPronunciations`, konu setinde `translationPronunciations`, klip dosyasında `pronunciations`. Kelime
sınırında, büyük/küçük harfe duyarlı (kitaplardaki kural). Sözlükte olmayan İngilizce kelime/ad lint uyarısıdır;
`--execute` reddeder (`--allow-english` ile geçilir).

Kimlikler sabittir (tur/öğe/klip kimliği; metin sırası değişse de kaymaz). Aynı Türkçe metin bir birimde (görev,
set, klip) bir kez seslendirilir; sesin kimliği metnin ilk geçtiği yerdendir (o yer silinir ya da metni değişirse
kalan yer yeni kimlikle bir kez daha seslendirilir — birkaç karakter; şu anki içerikte tekrar yok). Anahtar = metin + ses + model + üslup + söyleniş: biri değişince ses eskir ve
pakete girmez.

Dosyalar: `icerik/_evren/konusma/audio/ceviri/`, `icerik/_evren/setler/audio/ceviri/`,
`icerik/_evren/klipler/audio/tr/` → `<parça>.mp3` (git dışı, -16 LUFS), `<parça>.align.json` (depoda), `_raw/`
(ödenmiş ham WAV + Duyu; git dışı), kayıt aynı klasörde `PROMPTS.md`; defter tts_tr ile ortak.
Paket sezon dışa aktarmasında (`export_package.py --season <n>`) kurulur; eksik ya da eskimiş ses paketi
durdurmaz (alan yazılmaz, uygulama düğmeyi göstermez). Ücretli çağrı yoktur.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path

from . import REPO_ROOT, tts_tr
from .book import text_sha256
from .lesson import english_in_translation, terms_in

PARTS = ("talk", "sets", "clips")
DEFAULT_ROLE = "hi"
ICERIK = REPO_ROOT / "icerik"
VOICE_MAP_FILE = Path("_evren") / "sesler.json"
SOURCE_DIRS = {"talk": Path("_evren") / "konusma", "sets": Path("_evren") / "setler",
               "clips": Path("_evren") / "klipler"}
AUDIO_DIRS = {"talk": Path("audio") / "ceviri", "sets": Path("audio") / "ceviri", "clips": Path("audio") / "tr"}
PROMPTS_FILE = "PROMPTS.md"
PRON_KEYS = {"talk": "translationPronunciations", "sets": "translationPronunciations", "clips": "pronunciations"}
LABELS = {"talk": "Konuş çevirisi", "sets": "konu seti örnek Türkçesi", "clips": "klip alıştırması"}
TALK_PKG_PREFIX = "ceviri-"
CLIP_KEYS = ("prompt", "explain")


class SeasonTrError(ValueError):
    pass


def _clean(s) -> str | None:
    t = s.strip() if isinstance(s, str) else ""
    return t or None


def _with_stop(s: str) -> str:
    return s if s[-1:] in ".!?…:;\"'”’)" else s + "."


# --- birimler ------------------------------------------------------------------------------------

@dataclass
class Unit:
    """Bir kaynak birimi (Konuş görevi, konu seti ya da klip) ve Türkçe parçaları."""
    part: str
    uid: str
    path: Path
    items: list[tuple[str, str]]          # (parça kimliği, metin); aynı metin bir kez
    prons: list[dict] = field(default_factory=list)
    texts: dict[str, str] = field(default_factory=dict)   # yer adı → metin (paket bağı için; tekrarlar dahil)


def _dedupe(spots: list[tuple[str, str, str]]) -> tuple[list[tuple[str, str]], dict[str, str]]:
    """(yer, parça kimliği, metin) → planlanacak parçalar (aynı metin bir kez) ve yer → metin."""
    out, seen, texts = [], set(), {}
    for where, sid, text in spots:
        texts[where] = text
        if text not in seen:
            seen.add(text)
            out.append((sid, text))
    return out, texts


def talk_spots(doc: dict) -> list[tuple[str, str, str]]:
    """Konuş görevi: (yer, parça kimliği, Türkçe). Yer: `<tur>` (replik), `model`, `outro`."""
    tid = str(doc.get("id") or "")
    out = []
    for i, t in enumerate(doc.get("turns") or []):
        if not isinstance(t, dict):
            continue
        turn = str(t.get("id") or f"t{i + 1}")
        line = t.get("line")
        tr = _clean(line.get("tr")) if isinstance(line, dict) else None
        if tr:
            out.append((turn, f"{tid}-{turn}-line", tr))
    for key in ("model", "outro"):
        obj = doc.get(key)
        tr = _clean(obj.get("tr")) if isinstance(obj, dict) else None
        if tr:
            out.append((key, f"{tid}-{key}", tr))
    return out


def set_spots(doc: dict) -> list[tuple[str, str, str]]:
    sid = str(doc.get("id") or "")
    out = []
    for it in doc.get("items") or []:
        if not isinstance(it, dict):
            continue
        tr = _clean(it.get("exampleTr"))
        iid = str(it.get("id") or "")
        if tr and iid:
            out.append((iid, f"{sid}-{iid}-ex", tr))
    return out


def quiz_texts(quiz: dict) -> dict[str, str]:
    """Klip alıştırmasının seslendirilen metinleri (reel alıştırmasıyla aynı kural): `prompt` = soru + seçenekler
    (yalnız hepsi Türkçeyse, kaynaktaki sırayla), `explain` = açıklama."""
    out = {}
    prompt = _clean(quiz.get("promptTr"))
    if prompt:
        opts = [o for o in quiz.get("options") or [] if isinstance(o, dict)]
        texts = [_clean(o.get("text")) for o in opts]
        all_tr = bool(texts) and all(texts) and all((o.get("lang") or "tr") == "tr" for o in opts)
        out["prompt"] = " ".join([_with_stop(prompt)] + ([_with_stop(t) for t in texts] if all_tr else []))
    explain = _clean(quiz.get("explainTr"))
    if explain:
        out["explain"] = explain
    return out


def clip_spots(clip: dict) -> list[tuple[str, str, str]]:
    cid = str(clip.get("id") or "")
    q = clip.get("quiz")
    if not cid or not isinstance(q, dict):
        return []
    return [(k, f"{cid}-{k}", t) for k, t in quiz_texts(q).items()]


def _prons(doc: dict, part: str, where: str) -> list[dict]:
    return tts_tr.check_pronunciations(doc.get(PRON_KEYS[part]), f"{where} {PRON_KEYS[part]}", SeasonTrError)


def talk_unit(path: Path, doc: dict) -> Unit:
    tid = str(doc.get("id") or Path(path).stem)
    items, texts = _dedupe(talk_spots(doc))
    return Unit("talk", tid, Path(path), items, _prons(doc, "talk", f"Konuş {tid}"), texts)


def set_unit(path: Path, doc: dict) -> Unit:
    sid = str(doc.get("id") or Path(path).stem)
    items, texts = _dedupe(set_spots(doc))
    return Unit("sets", sid, Path(path), items, _prons(doc, "sets", f"set {sid}"), texts)


def clip_units(path: Path, doc: dict) -> list[Unit]:
    prons = _prons(doc, "clips", Path(path).name)
    out = []
    for c in doc.get("clips") or []:
        if not isinstance(c, dict):
            continue
        items, texts = _dedupe(clip_spots(c))
        if items:
            out.append(Unit("clips", str(c.get("id")), Path(path), items, prons, texts))
    return out


def _load(path: Path) -> dict:
    try:
        d = json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError) as e:
        raise SeasonTrError(f"{path} okunamadı: {e}") from e
    if not isinstance(d, dict):
        raise SeasonTrError(f"{path}: nesne bekleniyordu")
    return d


def units(icerik_root: Path, part: str, season: int | None = None) -> list[Unit]:
    if part not in PARTS:
        raise SeasonTrError(f"bilinmeyen bölüm: {part} ({', '.join(PARTS)})")
    d = Path(icerik_root) / SOURCE_DIRS[part]
    if not d.is_dir():
        return []
    out: list[Unit] = []
    pattern = "S*.json" if part == "clips" else "*.json"
    for p in sorted(d.glob(pattern)):
        doc = _load(p)
        if season is not None and int(doc.get("season", 0) or 0) != season:
            continue
        if part == "talk":
            out.append(talk_unit(p, doc))
        elif part == "sets":
            out.append(set_unit(p, doc))
        else:
            out += clip_units(p, doc)
    return out


# --- plan ----------------------------------------------------------------------------------------

def voice(icerik_root: Path | None = None, voice_map: Path | None = None) -> tuple[str, str | None, str]:
    p = Path(voice_map) if voice_map else Path(icerik_root or ICERIK) / VOICE_MAP_FILE
    d = json.loads(p.read_text(encoding="utf-8"))["turkish"]
    r = d["roles"].get(DEFAULT_ROLE)
    if r is None or not str(r.get("voice", "")).startswith("alania"):
        raise SeasonTrError(f"{p}: `{DEFAULT_ROLE}` rolü Alania sesi olmalı")
    return r["voice"], r.get("instructions"), d.get("model", tts_tr.TTS_MODEL)


def out_dir(icerik_root: Path, part: str) -> Path:
    return Path(icerik_root) / SOURCE_DIRS[part] / AUDIO_DIRS[part]


def prompts_path(icerik_root: Path, part: str) -> Path:
    return out_dir(icerik_root, part) / PROMPTS_FILE


def segments(us: list[Unit], instructions: str | None, only: list[str] | None = None) -> list[tts_tr.Segment]:
    segs = [tts_tr.Segment(sid, text, instructions, terms_in(text, u.prons))
            for u in us for sid, text in u.items if not only or sid in only]
    try:
        return tts_tr.check_segments(segs, allow_empty=True)
    except tts_tr.TrTtsError as e:
        raise SeasonTrError(str(e)) from e


def plan_part(icerik_root: Path, part: str, voice_map: Path | None = None, only: list[str] | None = None,
              force: bool = False, us: list[Unit] | None = None) -> tts_tr.Plan:
    v, ins, model = voice(icerik_root, voice_map)
    us = units(icerik_root, part) if us is None else us
    return tts_tr.plan_segments(segments(us, ins, only), out_dir(icerik_root, part), v, model, force)


def english_report(us: list[Unit], ids: set[str] | None = None) -> dict[str, list[str]]:
    """Sözlükle karşılanmamış İngilizce kelime/ad → parçalar."""
    found: dict[str, list[str]] = {}
    for u in us:
        for sid, text in u.items:
            if ids is not None and sid not in ids:
                continue
            for w in english_in_translation(text, u.prons):
                found.setdefault(w, []).append(sid)
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


def seg_audio(icerik_root: Path, part: str, us: list[Unit], voice_map: Path | None = None) -> list[SegAudio]:
    """Planlanan her parça için ses durumu. `stale`: hizalamanın anahtarı (metin + ses + model + üslup +
    söyleniş) güncel parçayla uyuşmuyor."""
    plan = plan_part(icerik_root, part, voice_map, us=us)
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


def current_audio(icerik_root: Path, unit: Unit, voice_map: Path | None = None) -> dict[str, Path]:
    """Birimin güncel sesi olan metinleri: {Türkçe metin: mp3}. Eskimiş, eksik ya da yalnız hizalaması olan ses
    girmez (paket yalnız güncel sesi taşır)."""
    if not unit.items:
        return {}
    return {s.text: s.audio for s in seg_audio(icerik_root, unit.part, [unit], voice_map) if s.state == "ok"}


def check_unit(icerik_root: Path, unit_or_error, voice_map: Path | None = None) -> tuple[list[tuple[str, str, str]], dict]:
    """Lint: (düzey, kod, ileti) ve sayım. Eksik ses birim başına tek uyarı; eskimiş ses, yerelde olmayan ses
    dosyası, zayıf hizalama uyarı; sözlükte olmayan İngilizce birim başına tek uyarı; bozuk sözlük hata."""
    if not (Path(icerik_root) / VOICE_MAP_FILE).exists() and voice_map is None:
        return [], {}           # ses haritası yok (test kökleri): Türkçe ses denetlenmez (Konuş H-104 kuralı)
    if isinstance(unit_or_error, Exception):
        return [("error", "tr-audio", str(unit_or_error))], {}
    u: Unit = unit_or_error
    code = {"talk": "talk-tr-audio", "sets": "set-tr-audio", "clips": "clip-tr-audio"}[u.part]
    if not u.items:
        return [], {}
    try:
        segs = seg_audio(icerik_root, u.part, [u], voice_map)
    except (SeasonTrError, tts_tr.TrTtsError, OSError, KeyError, ValueError) as e:
        return [("error", code, f"{u.uid}: {e}")], {}
    tool = f"tts_season_tr.py --part {u.part}"
    issues: list[tuple[str, str, str]] = []
    st = {"segments": len(segs), "chars": sum(len(s.text) for s in segs),
          "aligned": sum(1 for s in segs if s.state in ("ok", "no-audio")),
          "audio": sum(1 for s in segs if s.state == "ok"), "stale": sum(1 for s in segs if s.state == "stale")}
    none = [s.id for s in segs if s.state == "none"]
    if none:
        issues.append(("warning", code, f"{u.uid}: {len(none)}/{len(segs)} {LABELS[u.part]} Türkçe sesi yok "
                                        f"({', '.join(none[:4])}{' …' if len(none) > 4 else ''}); {tool}"))
    for s in segs:
        if s.state == "stale":
            issues.append(("warning", code, f"{s.id}: Türkçe ses eski metinden ya da ayardan; pakete girmez — "
                                            f"{tool} ile yeniden üret"))
        elif s.state == "no-audio":
            issues.append(("warning", code, f"{s.id}: Türkçe ses bu ortamda yok (git dışı medya): {s.audio.name}"))
        if s.state in ("ok", "no-audio") and s.quality_ok is False:
            issues.append(("warning", code, f"{s.id}: Türkçe sesin hizalaması zayıf (Duyu); kulakla dinlenmeli"))
    found = english_report([u])
    if found:
        issues.append(("warning", code.replace("-audio", "-english"),
                       f"{u.uid}: {LABELS[u.part]} metninde söyleniş sözlüğünde olmayan İngilizce kelime/ad: "
                       f"{', '.join(sorted(found))} (Alania Türkçe okur → {u.path.name} `{PRON_KEYS[u.part]}`)"))
    return issues, st


def orphan_audio(icerik_root: Path, part: str, us: list[Unit]) -> list[str]:
    """Sesi olup artık metni planlanmayan parçalar (sahipsiz dosya)."""
    known = {sid for u in us for sid, _ in u.items}
    d = out_dir(icerik_root, part)
    if not d.exists():
        return []
    return [f.name.removesuffix(".align.json") for f in sorted(d.glob("*.align.json"))
            if f.name.removesuffix(".align.json") not in known]


def safe_units(icerik_root: Path, part: str, path: Path, doc: dict):
    """Lint için: birim(ler) ya da bozuk sözlük hatası (export/lint ana denetimini durdurmaz)."""
    try:
        if part == "talk":
            return [talk_unit(path, doc)]
        if part == "sets":
            return [set_unit(path, doc)]
        return clip_units(path, doc)
    except (SeasonTrError, tts_tr.TrTtsError, TypeError, ValueError) as e:
        return [e]


# --- paket ---------------------------------------------------------------------------------------

def talk_package_name(sid: str) -> str:
    return f"{TALK_PKG_PREFIX}{sid}.m4a"


def set_package_name(set_id: str, item_id: str) -> str:
    return f"{set_id}/tr-{item_id}.m4a"


def clip_package_name(clip_id: str, key: str) -> str:
    return f"{clip_id}.tr-{key}.m4a"


def package_sources(icerik_root: Path, unit: Unit, voice_map: Path | None = None) -> dict[str, tuple[Path, str, str]]:
    """Yer → (güncel mp3, parça kimliği, metin). Aynı metni paylaşan yerler aynı sesi (ilk parçayı) alır."""
    try:
        cur = current_audio(icerik_root, unit, voice_map)
    except (SeasonTrError, tts_tr.TrTtsError, OSError, KeyError, ValueError):
        return {}
    first = {text: sid for sid, text in unit.items}
    return {where: (cur[text], first[text], text) for where, text in unit.texts.items() if text in cur}


__all__ = ["PARTS", "SeasonTrError", "Unit", "units", "plan_part", "seg_audio", "check_unit", "english_report",
           "orphan_audio", "package_sources", "quiz_texts", "text_sha256", "out_dir", "prompts_path"]
