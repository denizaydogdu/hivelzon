"""kurgu.json (kaynak kurgu tanımı) → bölüm paketi (scenes.json + segmentler + altyazılar).

Kaynak: geçici b1_v3.py, b2_kurgu.py, b3_kurgu.py, b4_kurgu.py (hangi görsel ve sesin nerede
kullanıldığı). Bu modül saf Python'dur; medya işleri bir arka uca (DryMedia ya da FfmpegMedia)
devredilir. DryMedia hiçbir dosya üretmez; süreleri hizalamadan tahmin eder (CI ve lint için).
"""

from __future__ import annotations

import hashlib
import json
import re
from dataclasses import dataclass, field
from pathlib import Path

from . import __version__
from .align import Alignment, Cue, merge_parts, round_cue, shot_cues
from .season import SeasonSource, title_caption
from .story import header_field
from .translation import Miss, Translation

KURGU_FILE = "kurgu.json"
SCHEMA_VERSION = 2  # 2: title (zorunlu başlangıç) ve recap düğümleri (H-050)
SPEAKER_TOKENS = {"alex": "ALEX", "maya": "MAYA", "voice": "VOICE", "hi": "HI", "man": "MAN",
                  "mrs": "MRS BROOKS", "sam": "SAM", "officer": "OFFICER", "tom": "TOM", "rosa": "ROSA",
                  "jordan": "JORDAN", "grant": "MR GRANT"}
LINK_FIELDS = ("previously", "payoff", "openQuestion", "answers", "cluesUnlocked", "callbackPhrases")


class BuildError(ValueError):
    pass


def slug_name(s: str) -> str:
    return re.sub(r"[^A-Za-z0-9._-]+", "-", s).strip("-")


@dataclass
class AudioItem:
    """Tek bir ses dosyası: kaynak mp3, hizalama, konuşmacı, telsiz filtresi."""
    key: str
    mp3: Path
    align: Path
    speaker: str
    radio: bool = False


@dataclass
class ShotPlan:
    source: Path
    clip: bool
    len: float | None
    move: list[float]
    items: list[AudioItem]
    atempo: float | None
    aoff: float
    gap: float
    signs: list[dict]
    subtitles: bool = True
    # build sırasında doldurulur
    audio: Path | None = None
    lead: float = 0.0
    cues: list[Cue] = field(default_factory=list)


@dataclass
class TextOnly:
    node: str
    what: str
    reason: str


class Episode:
    def __init__(self, ep_dir: Path):
        self.dir = Path(ep_dir).resolve()
        self.content = json.loads((self.dir / "content.json").read_text(encoding="utf-8"))
        self.story_text = (self.dir / "story.en.md").read_text(encoding="utf-8") \
            if (self.dir / "story.en.md").exists() else ""
        kp = self.dir / KURGU_FILE
        self.kurgu = json.loads(kp.read_text(encoding="utf-8")) if kp.exists() else None
        self._manifests: dict[Path, dict[str, str]] = {}

    @property
    def id(self) -> str:
        return self.content["contentId"]

    def speaker_for(self, audio_dir: Path, stem: str) -> str:
        if audio_dir not in self._manifests:
            mp = audio_dir.parent / "audio_manifest.json"
            rev = {}
            if mp.exists():
                for k, v in json.loads(mp.read_text(encoding="utf-8")).items():
                    rev[v] = k.split("|", 1)[0].strip()
            self._manifests[audio_dir] = rev
        sp = self._manifests[audio_dir].get(stem)
        if sp:
            return sp
        for tok in stem.split("_"):
            if tok in SPEAKER_TOKENS:
                return SPEAKER_TOKENS[tok]
        raise BuildError(f"{stem}: konuşmacı bulunamadı (audio_manifest.json ya da dosya adı)")

    def audio_item(self, ref) -> AudioItem:
        if isinstance(ref, str):
            ref = {"id": ref}
        radio = bool(ref.get("radio"))
        if "path" in ref:
            base = (self.dir / ref["path"]).resolve()
        else:
            base = self.dir / "audio" / ref["id"]
        mp3 = base.with_suffix(".mp3")
        align = base.with_suffix(".align.json")
        speaker = ref.get("speaker") or self.speaker_for(base.parent, base.name)
        key = f"{base.parent.parent.name[:6]}_{base.name}" + ("_telsiz" if radio else "")
        return AudioItem(key, mp3, align, speaker, radio)

    def image(self, rel: str) -> Path:
        return (self.dir / rel).resolve()


class DryMedia:
    """Medya üretmeden plan: süreler hizalamadan tahmin edilir."""
    dry = True

    def item_duration(self, item: AudioItem) -> float:
        return Alignment.load(item.align).end + 0.25

    def shot_audio(self, ep: Episode, shot: ShotPlan, seg_id: str, k: int) -> tuple[Path | None, float, float]:
        if not shot.items:
            return None, 0.0, 0.0
        n = len(shot.items)
        total = sum(self.item_duration(i) for i in shot.items) + (shot.gap * n if n > 1 else 0.0)
        if shot.atempo:
            total /= shot.atempo
        return None, 0.0, total

    def render_segment(self, ep: Episode, seg_id: str, shots: list[ShotPlan]) -> tuple[str, float]:
        from .media import XFADE
        return f"segments/{seg_id}.mp4", sum(s.len for s in shots) - XFADE * (len(shots) - 1)

    def still(self, ep: Episode, image: Path) -> str:
        return f"stills/{slug_name(image.stem)}.jpg"

    def audio_clip(self, ep: Episode, item: AudioItem) -> str:
        return f"audio/{slug_name(item.key)}.m4a"

    def season_duration(self, src: SeasonSource) -> float:
        return src.title_duration


def _frames(x: float) -> float:
    return round(x * 30) / 30


def episode_meta(ep: Episode, translation: Translation | None = None) -> dict:
    c = ep.content
    missing = [f for f in LINK_FIELDS if f not in c]
    if missing:
        raise BuildError(f"{ep.id}: content.json bağ alanları eksik: {', '.join(missing)}")
    mission = header_field(ep.story_text, "Görev kartı") or ""
    meta = {
        "id": c["contentId"], "slug": c["slug"], "level": c["level"], "season": c["season"],
        "number": c["episode"], "title": c["title"], "contentVersion": c.get("version", 1),
        "status": c.get("status", "DRAFT"), "aiGenerated": bool(c.get("aiGenerated", True)),
        "aiLabel": "Yapay zekâ ile üretilmiştir",
        "mission": {"tr": mission} if mission else {"tr": c["title"]},
        "targetPhrases": list(c.get("targetPhrases", [])),
        "prev": c.get("prev"), "next": c.get("next"),
        "links": {f: c.get(f) for f in LINK_FIELDS},
    }
    if translation is not None:
        # 🎯 paneli (H-050): hedef ifadeye dokununca anlam paneli açılır.
        glosses = []
        for phrase in meta["targetPhrases"]:
            g = translation.gloss_phrase(phrase)
            if g:
                glosses.append({"text": phrase, **g})
        if glosses:
            meta["targetPhraseGloss"] = glosses
    if "estimatedMinutes" in c:
        meta["estimatedMinutes"] = c["estimatedMinutes"]
    return meta


class Builder:
    def __init__(self, ep: Episode, media):
        if ep.kurgu is None:
            raise BuildError(f"{ep.dir.name}: {KURGU_FILE} yok")
        self.ep = ep
        self.media = media
        self.subs: dict[str, dict] = {}
        self.text_only: list[TextOnly] = []
        self.segments: dict[str, list[ShotPlan]] = {}
        self.translation = Translation.load(ep.dir)
        self.tr_misses: list[Miss] = []
        self.season = SeasonSource.load(ep.dir.parent, int(ep.content.get("season", 1)))

    # --- yardımcılar ---
    def _shot(self, spec: dict) -> ShotPlan:
        ep = self.ep
        if "clip" in spec:
            src, clip = ep.image(spec["clip"]), True
        else:
            src, clip = ep.image(spec["image"]), False
        items = [ep.audio_item(r) for r in spec.get("audio", [])]
        for it in items:
            if it.speaker.upper().startswith("HI") or "(TR)" in it.speaker:
                raise BuildError(f"{it.key}: Hi/Türkçe replik segment içine konmaz; card(kind=hi) ya da balon kullanın")
        return ShotPlan(src, clip, spec.get("len"), spec.get("move", [1.0, 1.06, .5, .5, .5, .5]), items,
                        spec.get("atempo"), spec.get("aoff", 0.5), spec.get("gap", 0.35),
                        spec.get("signs", []), spec.get("subtitles", True))

    def _plan_shots(self, node_id: str, specs: list[dict]) -> list[ShotPlan]:
        from .media import TAIL, XFADE
        shots = [self._shot(s) for s in specs]
        t0 = 0.0
        for k, sh in enumerate(shots):
            path, lead, adur = self.media.shot_audio(self.ep, sh, node_id, k)
            sh.audio, sh.lead = path, lead
            if sh.len is None:
                if not sh.items:
                    raise BuildError(f"{node_id}: sessiz çekimde len zorunlu")
                sh.len = sh.aoff + adur + TAIL
            sh.len = _frames(sh.len)
            if sh.items and sh.subtitles:
                durs = [self._item_dur(i) for i in sh.items]
                atempo = sh.atempo or 1.0
                parts = merge_parts([(i.speaker, Alignment.load(i.align), d) for i, d in zip(sh.items, durs)], sh.gap)
                for p in parts:
                    p.align = p.align.scaled(atempo)
                cues = shot_cues(parts, lead=sh.lead)
                sh.cues = [c.shifted(t0 + sh.aoff) for c in cues]
            t0 += sh.len - XFADE
        return shots

    def _item_dur(self, item: AudioItem) -> float:
        return self.media.item_duration(item)

    def _video_node(self, node_id: str, specs: list[dict]) -> dict:
        shots = self._plan_shots(node_id, specs)
        path, duration = self.media.render_segment(self.ep, node_id, shots)
        self.segments[node_id] = shots
        cues = [c for s in shots for c in s.cues]
        out = {"video": path, "duration": round(duration, 3)}
        if cues:
            rel = f"subs/{node_id}.en.json"
            sub_cues = []
            for k, c in enumerate(cues):
                cue = dict(id=f"{node_id}-{k + 1:02d}", tr=None, **round_cue(c))
                if self.translation is not None:
                    self.translation.annotate_cue(cue, f"{rel}#{cue['id']}", self.tr_misses)
                sub_cues.append(cue)
            self.subs[rel] = {
                "schemaVersion": 1, "segment": node_id, "lang": "en", "duration": round(duration, 3),
                "cues": sub_cues,
            }
            out["subtitles"] = rel
        else:
            out["subtitles"] = None
        return out

    def _audio(self, ref) -> str:
        return self.media.audio_clip(self.ep, self.ep.audio_item(ref))

    def _still(self, rel: str) -> str:
        return self.media.still(self.ep, self.ep.image(rel))

    def _gloss(self, text: str, where: str) -> dict | None:
        if self.translation is None:
            return None
        return self.translation.gloss_text(text, where, self.tr_misses)

    def _gloss_lines(self, lines: list[dict], where: str) -> list[dict]:
        """Kart satırlarına (lang en) Türkçe cümle, kelime anlamları ve kalıplar eklenir."""
        out = []
        for ln in lines:
            ln = dict(ln)
            if ln.get("lang", "en") == "en":
                g = self._gloss(ln["text"], where)
                if g:
                    ln.update(g)
            out.append(ln)
        return out

    def _bubble(self, node_id: str, spec: dict, what: str) -> dict:
        b = {"speaker": spec.get("speaker", "HI"), "lang": spec.get("lang", "tr"), "text": spec["text"]}
        if spec.get("audio"):
            b["audio"] = self._audio(spec["audio"])
        else:
            self.text_only.append(TextOnly(node_id, what, spec.get("why", "ses dosyası yok")))
        return b

    # --- düğümler ---
    def node(self, spec: dict) -> dict:
        t = spec["type"]
        common = {k: spec[k] for k in ("scene", "checkpoint") if k in spec}
        nid = spec["id"]
        if t == "segment":
            return {"id": nid, "type": t, **common, **self._video_node(nid, spec["shots"]), "next": spec.get("next")}
        if t == "title":
            # Bölüm başlık ekranı (H-050): sezonun yazısız kısa animasyonu + uygulamanın çizdiği başlık.
            c = self.ep.content
            src = self.season
            return {"id": nid, "type": t, **common, "season": c["season"], "episode": c["episode"],
                    "caption": title_caption(c["season"], c["episode"]), "title": c["title"],
                    "seasonVideo": src.title_background, "seasonPoster": src.title_poster,
                    "duration": round(self.media.season_duration(src), 3), "next": spec.get("next")}
        if t == "recap":
            # "Önceki bölümde" (H-050): başlıktan sonra, atlanabilir kısa video.
            return {"id": nid, "type": t, **common, **self._video_node(nid, spec["shots"]),
                    "skippable": True, "next": spec.get("next")}
        if t == "reaction":
            out = {"id": nid, "type": t}
            if spec.get("shots"):
                out.update(self._video_node(nid, spec["shots"]))
            else:
                self.text_only.append(TextOnly(nid, "tepki videosu", spec.get("why", "tepki için görsel/ses yok")))
            if spec.get("bubble"):
                out["bubble"] = self._bubble(nid, spec["bubble"], "tepki balonu (Hi)")
            out["next"] = spec["next"]
            return out
        if t == "card":
            out = {"id": nid, "type": t, "kind": spec["kind"], **common}
            for k in ("title", "lines", "variants", "advance", "duration", "clueIds", "questionId", "answers"):
                if k in spec:
                    out[k] = spec[k]
            out["lines"] = self._gloss_lines(out["lines"], f"card {nid}")
            if "variants" in out:
                out["variants"] = [{**v, "lines": self._gloss_lines(v["lines"], f"card {nid} (varyant)")}
                                   for v in out["variants"]]
            if spec.get("audio"):
                out["audio"] = self._audio(spec["audio"])
            elif spec["kind"] in ("hi", "line"):
                self.text_only.append(TextOnly(nid, f"kart ({spec['kind']})", spec.get("why", "ses dosyası yok")))
            if spec.get("background"):
                out["background"] = self._still(spec["background"])
            out["next"] = spec.get("next")
            return out
        if t == "decision":
            out = {"id": nid, "type": t, **common, "prompt": spec["prompt"]}
            if spec.get("cue"):
                cue = {"speaker": spec["cue"]["speaker"], "text": spec["cue"]["text"]}
                if spec["cue"].get("audio"):
                    cue["audio"] = self._audio(spec["cue"]["audio"])
                g = self._gloss(cue["text"], f"decision {nid} cue")
                if g:
                    cue.update(g)
                out["cue"] = cue
            for k in ("pov", "skill", "cefr", "targetPhrase"):
                if k in spec:
                    out[k] = spec[k]
            if spec.get("background"):
                out["background"] = self._still(spec["background"])
            opts = []
            for o in spec["options"]:
                oo = {k: o[k] for k in ("id", "text", "lang", "icon", "correct", "setFlag") if k in o}
                if o.get("audio"):
                    oo["audio"] = self._audio(o["audio"])
                oo["next"] = o["next"]
                opts.append(oo)
            out["options"] = opts
            if spec.get("hints"):
                out["hints"] = spec["hints"]
            return out
        if t == "task":
            out = {"id": nid, "type": t, "kind": spec["kind"], "role": spec["role"], **common}
            for k in ("skill", "cefr", "prompt", "context", "result"):
                if k in spec:
                    out[k] = spec[k]
            if spec.get("audio"):
                out["audio"] = self._audio(spec["audio"])
            if spec.get("background"):
                out["background"] = self._still(spec["background"])
            items = []
            for it in spec["items"]:
                ii = {k: v for k, v in it.items() if k != "options"}
                if it.get("stem"):
                    g = self._gloss(it["stem"], f"task {nid}.{it.get('id')} stem")
                    if g:
                        ii["stemTr"], ii["stemWords"], ii["stemChunks"] = g["tr"], g["words"], g["chunks"]
                if "options" in it:
                    ii["options"] = []
                    for o in it["options"]:
                        oo = {k: o[k] for k in ("id", "text", "lang", "correct") if k in o}
                        if o.get("audio"):
                            oo["audio"] = self._audio(o["audio"])
                        ii["options"].append(oo)
                items.append(ii)
            out["items"] = items
            if spec.get("feedback", {}).get("wrong"):
                out["feedback"] = {"wrong": self._bubble(nid, spec["feedback"]["wrong"], "görev geri bildirimi (Hi)")}
            if spec.get("noMediaReason"):
                self.text_only.append(TextOnly(nid, "görev görseli", spec["noMediaReason"]))
            out["next"] = spec.get("next")
            return out
        raise BuildError(f"{nid}: bilinmeyen düğüm türü {t}")

    def build(self) -> dict:
        k = self.ep.kurgu
        flags = [{kk: f[kk] for kk in ("id", "values", "callbackIn") if kk in f}
                 for f in self.ep.content.get("flags", [])]
        doc = {
            "schemaVersion": SCHEMA_VERSION,
            "episode": episode_meta(self.ep, self.translation),
            "flags": flags,
        }
        if k.get("externalFlags"):
            doc["externalFlags"] = k["externalFlags"]
        doc["gate"] = {"rule": "all", **k["gate"]}
        doc["start"] = k["start"]
        doc["nodes"] = [self.node(n) for n in k["nodes"]]
        return doc


def build_dry(ep_dir: Path) -> tuple[dict, Builder]:
    ep = Episode(ep_dir)
    b = Builder(ep, DryMedia())
    return b.build(), b


def file_digest(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


TOOL_ID = f"hiVelzon content-pipeline {__version__}"
