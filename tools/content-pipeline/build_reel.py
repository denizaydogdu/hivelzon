#!/usr/bin/env python3
"""Reel montajı (H-094): `reeller/<id>/` → `_build/package/` (720×1280 H.264/AAC, faststart).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/build_reel.py reeller/A1-R-CIN-01
    ... --force       # ara dosyaları sil, baştan kur
    ... --no-clips    # hareketli klipleri kullanma (yalnız Ken Burns + durağan kare)

Kaynaklar:
- `reel.json`: kimlik, süre, cue'lar, hedef, paket dosya adları (`video`/`poster`/`image`/`audio`).
- `shots.json`: `prefix`/`params` (görsel üretimi) + **`timeline`** (kurgu).
  `timeline` girişi: `{"shot": "k2", "len": 3.6, "move": [z0,z1,px0,px1,py0,py1], "audio": "s02-02"?,
  "clip": "clips/x.mp4"?}`. `clip` varsa (ve `--no-clips` verilmemişse) kare yerine klip çekilir.
- Kareler: `_raw/<shot>.png`. Ses: `_raw/tts/<cue>.m4a` (yoksa sessiz önizleme).

Çıktı paketi (`_build/package/`): `reel.json`, `<id>.mp4` (**720p**, uygulamanın oynattığı sürüm),
`<id>.webp` (afiş), `stills/<sahne>.webp`, `audio/<cue>.m4a` (varsa), `production.json` (üretim izi).

Ücretli çağrı yok; yalnız yerel ffmpeg/ImageMagick. Çıkış kodu: 0 başarı, 1 hata, 2 kullanım hatası.
"""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import media  # noqa: E402

DEFAULT_MOVE = [1.0, 1.08, 0.45, 0.5, 0.5, 0.55]
AI_LABEL = media.AI_LABEL


def _sha16(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()[:16]


def _ledger(root: Path, name: str) -> list[dict]:
    path = root / "_raw" / name
    return json.loads(path.read_text(encoding="utf-8")) if path.is_file() else []


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="Reel montajı (H-094)")
    ap.add_argument("reel", help="reel klasörü (reeller/A1-R-CIN-01)")
    ap.add_argument("--force", action="store_true", help="ara dosyaları yok sayıp yeniden kur")
    ap.add_argument("--no-clips", action="store_true", help="hareketli klipleri kullanma")
    a = ap.parse_args(argv)

    root = Path(a.reel)
    if not (root / "reel.json").is_file() or not (root / "shots.json").is_file():
        print(f"hata: {root}/reel.json ya da shots.json yok", file=sys.stderr)
        return 2

    reel = json.loads((root / "reel.json").read_text(encoding="utf-8"))
    spec = json.loads((root / "shots.json").read_text(encoding="utf-8"))
    timeline = spec.get("timeline")
    if not timeline:
        print("hata: shots.json içinde `timeline` yok", file=sys.stderr)
        return 2

    build = root / "_build"
    if a.force and build.exists():
        shutil.rmtree(build)
    shots_dir = build / "shots"
    pkg = build / "package"
    raw = root / "_raw"
    pkg.mkdir(parents=True, exist_ok=True)

    # 1. Çekimler (Ken Burns ya da klip)
    movs: list[Path] = []
    lens: list[float] = []
    has_audio = False
    plan: list[dict] = []
    for i, seg in enumerate(timeline):
        name, length = seg["shot"], float(seg["len"])
        clip_rel = seg.get("clip")
        clip = (root / clip_rel) if clip_rel else None
        use_clip = bool(clip and clip.is_file() and not a.no_clips)
        src = clip if use_clip else raw / f"{name}.png"
        if not src.is_file():
            print(f"hata: kaynak yok: {src}", file=sys.stderr)
            return 1
        out = shots_dir / f"{i:02d}-{name}.mov"
        shot: dict = {"source": src, "len": length, "move": seg.get("move") or DEFAULT_MOVE,
                      "clip": use_clip}
        audio_cue = seg.get("audio")
        if audio_cue:
            cue_file = next((p for p in (raw / "tts" / f"{audio_cue}.mp3",
                                         raw / "tts" / f"{audio_cue}.m4a") if p.is_file()), None)
            if cue_file is not None:
                shot["audio"] = cue_file
                shot["aoff"] = float(seg.get("aoff", media.AOFF))
                has_audio = True
        media.render_shot(shot, out, None)
        movs.append(out)
        lens.append(length)
        plan.append({"shot": name, "len": length, "clip": use_clip, "audio": audio_cue,
                     "source": str(src.relative_to(root))})

    # 2. Birleştirme (xfade)
    joined = media.join_shots(movs, lens, build / "joined.mov")
    total = sum(lens) - media.XFADE * (len(movs) - 1)

    # 3. Ses dengesi (yalnız ses varsa) ve son master
    gain = 0.0
    if has_audio:
        gain = round(media.TARGET_LUFS - media.loudness([joined])["I"], 2)
    master = media.finalize(joined, gain, build / "master.mp4")

    # 4. 720p sürüm = paketin oynatılan videosu
    video = pkg / reel["video"]
    media.rendition_720(master, video)

    # 5. Afiş (ilk kare) ve Defter kartı durağan görseli
    media.still(raw / f"{timeline[0]['shot']}.png", pkg / reel["poster"])
    cue_id = (reel.get("target") or {}).get("cue", "")
    scene = cue_id.rsplit("-", 1)[0] if cue_id else (reel.get("id", "reel"))
    key_shot = next((s["shot"] for s in timeline if cue_id and s.get("audio") == cue_id),
                    timeline[min(1, len(timeline) - 1)]["shot"])
    media.still(raw / f"{key_shot}.png", pkg / "stills" / f"{scene}.webp")

    # 6. Hedef ifadenin sesi (varsa)
    audio_out = None
    for cue in reel.get("cues", []):
        src = next((p for p in (raw / "tts" / f"{cue['id']}.mp3", raw / "tts" / f"{cue['id']}.m4a")
                    if p.is_file()), None)
        if src is not None:
            out = pkg / "audio" / f"{cue['id']}.m4a"
            media.cut_audio(src, 0.0, None, media.gain_to_target(src), out)
            if cue["id"] == cue_id:
                audio_out = f"audio/{cue['id']}.m4a"

    # 7. Paket reel.json (kimlik bilgisi paketle gider) + üretim izi
    doc = dict(reel)
    if audio_out:
        doc["audio"] = audio_out
    doc["image"] = f"stills/{scene}.webp"
    (pkg / "reel.json").write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n",
                                   encoding="utf-8")

    img_ledger = _ledger(root, "jobs.json")
    clip_ledger = _ledger(root, "clip-jobs.json")
    used = {p["shot"] for p in plan}
    credits = {
        "images": round(sum(r["credits"] for r in img_ledger if r["name"] in used), 2),
        "clips": round(sum(r["credits"] for r in clip_ledger), 2),
    }
    credits["total"] = round(credits["images"] + credits["clips"], 2)
    production = {
        "reelId": reel["id"], "contentVersion": reel.get("contentVersion"),
        "builtAt": dt.datetime.now().astimezone().isoformat(timespec="seconds"),
        "builder": "tools/content-pipeline/build_reel.py",
        "aiLabel": AI_LABEL,
        "video": {"file": reel["video"], "width": media.R720_W, "height": media.R720_H,
                  "seconds": round(total, 2), "master": "1080×1920 (build/master.mp4)"},
        "hasAudio": has_audio,
        "timeline": plan,
        "credits": credits,
        "jobs": {"images": img_ledger, "clips": clip_ledger},
        "sources": {f"stills/{scene}.webp": _sha16(pkg / "stills" / f"{scene}.webp")},
    }
    (pkg / "production.json").write_text(json.dumps(production, ensure_ascii=False, indent=1) + "\n",
                                         encoding="utf-8")

    size = video.stat().st_size / 1e6
    print(f"{reel['id']}: {total:.2f} sn · {media.R720_W}×{media.R720_H} · {size:.1f} MB · "
          f"ses={'var' if has_audio else 'YOK (sessiz önizleme)'} · kare={len(movs)}")
    print(f"  paket: {pkg}")
    print(f"  kredi: görsel {credits['images']} + hareket {credits['clips']} = {credits['total']} kr")
    for p in plan:
        print(f"    {p['shot']:4} {p['len']:4.1f} sn  {'klip' if p['clip'] else 'kare':4}  {p['source']}")
    if abs(total - float(reel.get("duration", total))) > 0.4:
        print(f"  uyarı: süre {total:.2f} sn, reel.json'da {reel.get('duration')} sn")
    if not has_audio:
        print("  not: konuşma sesi yok — ElevenLabs anahtarı gelince `_raw/tts/<cue>.m4a` konur ve "
              "`--force` ile yeniden kurulur.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
