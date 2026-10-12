"""Bölüm paketini gerçekten üretir: ffmpeg arka ucu, yazma, manifest ve doğrulama."""

from __future__ import annotations

import hashlib
import json
import shutil
from pathlib import Path

from . import media
from .build import TOOL_ID, AudioItem, Builder, Episode, ShotPlan, file_digest, slug_name
from .graph import check_scenes, schema_errors

CACHE_VERSION = "1"


def _key(*parts) -> str:
    h = hashlib.sha256()
    for p in parts:
        if isinstance(p, Path):
            st = p.stat()
            p = f"{p}:{st.st_size}:{int(st.st_mtime)}"
        h.update(json.dumps(p, sort_keys=True, default=str).encode())
    return h.hexdigest()[:16]


class FfmpegMedia:
    dry = False

    def __init__(self, build_dir: Path, pkg_dir: Path, label: bool = True):
        self.cache = build_dir / "cache"
        self.pkg = pkg_dir
        self.label = media.label_png(self.cache / "label.png") if label else None
        self.joined: dict[str, Path] = {}      # segment id → ara .mov
        self.clips: dict[str, Path] = {}       # paket yolu → ham ses kaynağı
        self.stills: dict[str, Path] = {}

    def _src(self, item: AudioItem) -> Path:
        if not item.mp3.exists():
            raise media.MediaError(f"ses dosyası yok: {item.mp3}")
        if item.radio:
            return media.radio(item.mp3, self.cache / "radio" / f"{slug_name(item.key)}.mp3")
        return item.mp3

    def item_duration(self, item: AudioItem) -> float:
        return media.probe_duration(self._src(item))

    def shot_audio(self, ep: Episode, shot: ShotPlan, seg_id: str, k: int):
        if not shot.items:
            return None, 0.0, 0.0
        srcs = [self._src(i) for i in shot.items]
        if len(srcs) == 1:
            path = srcs[0]
        else:
            path = media.concat_audio(srcs, shot.gap, self.cache / "groups" / f"{_key(srcs, shot.gap)}.wav")
        if shot.atempo:
            path = media.tempo(path, shot.atempo, self.cache / "tempo" / f"{_key(path, shot.atempo)}.wav")
        return path, media.onset_lead(path), media.probe_duration(path)

    def render_segment(self, ep: Episode, seg_id: str, shots: list[ShotPlan]):
        movs = []
        for k, sh in enumerate(shots):
            overlays = []
            for j, sg in enumerate(sh.signs):
                png = media.sign_png(sg, self.cache / "signs" / f"{_key(sg)}.png")
                overlays.append((png, sg["start"], sg["end"]))
            spec = {"source": sh.source, "clip": sh.clip, "len": sh.len, "move": sh.move,
                    "audio": sh.audio, "aoff": sh.aoff, "overlays": overlays}
            key = _key(CACHE_VERSION, sh.source, sh.audio if sh.audio else None, sh.len, sh.move, sh.aoff,
                       [(str(p), a, b) for p, a, b in overlays], sh.clip, bool(self.label))
            movs.append(media.render_shot(spec, self.cache / "shots" / f"{key}.mov", self.label))
        joined = media.join_shots(movs, [s.len for s in shots],
                                  self.cache / "segments" / f"{_key(CACHE_VERSION, movs)}.mov")
        self.joined[seg_id] = joined
        return f"segments/{seg_id}.mp4", media.probe_duration(joined)

    def still(self, ep: Episode, image: Path) -> str:
        rel = f"stills/{slug_name(image.stem)}.jpg"
        self.stills[rel] = image
        return rel

    def audio_clip(self, ep: Episode, item: AudioItem) -> str:
        rel = f"audio/{slug_name(item.key)}.m4a"
        self.clips[rel] = self._src(item)
        return rel

    def season_duration(self, src) -> float:
        """Başlık ekranı süresi: sezonun yazısız kısa animasyonunun gerçek süresi (H-050)."""
        f = (src.media_dir / src.title_background) if src.media_dir else None
        if f is None or not f.exists():
            raise media.MediaError(f"başlık arka planı yok: {f} (kurgu.py --baslik-arka)")
        return media.probe_duration(f)


def export_episode(ep_dir: Path, label: bool = True, clean: bool = True) -> dict:
    ep = Episode(ep_dir)
    build_dir = ep.dir / "_build"
    pkg = build_dir / "package"
    if clean and pkg.exists():
        shutil.rmtree(pkg)
    pkg.mkdir(parents=True, exist_ok=True)
    fm = FfmpegMedia(build_dir, pkg, label=label)
    b = Builder(ep, fm)
    doc = b.build()

    # Ses düzeyi: bütün segmentlerin birleşik ölçümünden tek kazanç (bölüm içi tutarlılık).
    ids = list(fm.joined)
    before = media.loudness([fm.joined[i] for i in ids])
    gain = media.TARGET_LUFS - before["I"]
    for sid in ids:
        media.finalize(fm.joined[sid], gain, pkg / "segments" / f"{sid}.mp4")
    for rel, src in fm.clips.items():
        media.audio_clip(src, gain, pkg / rel)
    for rel, img in fm.stills.items():
        media.still(img, pkg / rel)

    # Gerçek süreleri yaz
    for n in doc["nodes"]:
        if n.get("video"):
            n["duration"] = round(media.probe_duration(pkg / n["video"]), 3)
    for rel, sub in b.subs.items():
        seg = pkg / "segments" / f"{sub['segment']}.mp4"
        sub["duration"] = round(media.probe_duration(seg), 3)
        (pkg / rel).parent.mkdir(parents=True, exist_ok=True)
        (pkg / rel).write_text(json.dumps(sub, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    (pkg / "scenes.json").write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    after = media.loudness([pkg / "segments" / f"{i}.mp4" for i in ids])
    sync = verify_sync(pkg, b)
    probes = probe_segments(pkg, ids)
    issues = check_scenes(doc)
    sub_errors = {rel: schema_errors(sub, "subs.schema.json") for rel, sub in b.subs.items()}

    files = sorted(p for p in pkg.rglob("*") if p.is_file() and p.name != "manifest.json")
    manifest = {
        "schemaVersion": 1,
        "contentId": ep.id,
        "contentVersion": doc["episode"]["contentVersion"],
        "tool": TOOL_ID,
        "loudness": {"targetLUFS": media.TARGET_LUFS, "gainDb": round(gain, 2),
                     "before": before, "after": after},
        "textOnly": [{"node": t.node, "what": t.what, "reason": t.reason} for t in b.text_only],
        "files": [{"path": str(p.relative_to(pkg)), "bytes": p.stat().st_size, "sha256": file_digest(p)}
                  for p in files],
    }
    manifest["totalBytes"] = sum(f["bytes"] for f in manifest["files"])
    (pkg / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return {"episode": ep.id, "package": pkg, "doc": doc, "manifest": manifest, "sync": sync,
            "probes": probes, "issues": issues, "subErrors": sub_errors, "textOnly": b.text_only}


def verify_sync(pkg: Path, b: Builder) -> list[dict]:
    """Her çekimin ilk ipucu başlangıcı ile çıktıdaki gerçek ses başlangıcını karşılaştırır (D-001)."""
    rows = []
    for sid, shots in b.segments.items():
        env = media.envelope(pkg / "segments" / f"{sid}.mp4")
        for k, sh in enumerate(shots):
            if not sh.cues:
                continue
            exp = sh.cues[0].start
            # Karar ölçümü %10 eşik: yumuşak başlayan sözcükleri ("It's") de yakalar; ilk-ipucu telafisiyle
            # aynı eşik. %35 (kurgu.py v3) yalnızca bilgi için: A1-004 k2-ok'ta "It's"i kaçırıp "seven"i ölçüyordu.
            meas = media.measure_onset(env, exp, rel=0.10)
            strict = media.measure_onset(env, exp)
            rows.append({"segment": sid, "shot": k, "cue": sh.cues[0].text, "expected": round(exp, 3),
                         "measured": meas, "delta": None if meas is None else round(meas - exp, 3),
                         "measuredStrict": strict, "deltaStrict": None if strict is None else round(strict - exp, 3)})
    return rows


def probe_segments(pkg: Path, ids: list[str]) -> list[dict]:
    out = []
    for sid in ids:
        p = pkg / "segments" / f"{sid}.mp4"
        st = media.probe_streams(p)
        v = next(s for s in st if s["codec_type"] == "video")
        a = next(s for s in st if s["codec_type"] == "audio")
        with open(p, "rb") as f:
            head = f.read(64 * 1024)
        faststart = 0 <= head.find(b"moov") < head.find(b"mdat") if b"mdat" in head else b"moov" in head
        out.append({"segment": sid, "duration": round(media.probe_duration(p), 3),
                    "v": f"{v['codec_name']} {v.get('profile', '')} {v['width']}x{v['height']} {v.get('pix_fmt', '')}",
                    "a": f"{a['codec_name']} {a.get('sample_rate')} Hz {a.get('channels')}ch",
                    "vdur": float(v.get("duration", 0)), "adur": float(a.get("duration", 0)),
                    "faststart": faststart, "bytes": p.stat().st_size})
    return out
