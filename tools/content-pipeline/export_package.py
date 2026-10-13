#!/usr/bin/env python3
"""Bölüm paketini üretir: icerik/<id>/_build/package/ (H-034).

Kullanım:
    python3 tools/content-pipeline/export_package.py icerik/A1-001-a-strange-message [icerik/A1-002-…]
    python3 tools/content-pipeline/export_package.py icerik/A1-00[1-4]-* --report rapor.json
    python3 tools/content-pipeline/export_package.py --season 1          # yalnızca sezon paketi (H-035)

Yalnızca yerel ffmpeg ve ImageMagick kullanır; ücretli servis çağrısı yapmaz. Var olmayan ses için
düğüm yalnızca metin (Hi balonu) olarak kalır ve manifest'teki textOnly listesine yazılır.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import media  # noqa: E402
from hvpipeline.build import file_digest  # noqa: E402
from hvpipeline.export import export_episode  # noqa: E402
from hvpipeline.season import export_season  # noqa: E402

SYNC_LIMIT = 0.2
AV_LIMIT = 0.05
FRAME = 1 / 30   # 720p sürüm süresi 1080p ile en çok 1 kare farklı olabilir (H-054)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon bölüm paketi dışa aktarma")
    ap.add_argument("episodes", nargs="*")
    ap.add_argument("--season", type=int, help="yalnızca bu sezonun paketini üret (bölümlere dokunmaz)")
    ap.add_argument("--root", default=str(Path(__file__).resolve().parents[2] / "icerik"),
                    help="--season için içerik kökü")
    # Uygulama içi paketlerde etiket gömülmez; uygulama bölüm başında kısa bir not gösterir
    # (kullanıcı kararı 2026-10-12). Sosyal medya kesitleri için --ai-label ile gömülür (K-14).
    ap.add_argument("--ai-label", action="store_true", help="'Yapay zekâ ile üretilmiştir' yazısını videoya göm (sosyal medya)")
    ap.add_argument("--report", help="özet raporu JSON olarak yaz")
    a = ap.parse_args(argv)
    summary, failed = [], False
    # Sezon paketi (H-050): bölümlerin başlık ekranı ve sezon jeneriği /packages/_season/S<n>/ altında.
    if not a.episodes and a.season is None:
        ap.error("bölüm klasörü ya da --season gerekli")
    seasons = {}
    if a.season is not None:
        seasons[(Path(a.root).resolve(), a.season)] = True
    for d in a.episodes:
        c = json.loads((Path(d) / "content.json").read_text(encoding="utf-8"))
        seasons.setdefault((Path(d).resolve().parent, int(c.get("season", 1))), True)
    for d in a.episodes:
        r = export_episode(Path(d), label=a.ai_label)
        m, doc = r["manifest"], r["doc"]
        deltas = [abs(s["delta"]) for s in r["sync"] if s["delta"] is not None]
        unmeasured = [s for s in r["sync"] if s["delta"] is None]
        maxd = max(deltas) if deltas else None
        av = max((abs(p["vdur"] - p["adur"]) for p in r["probes"]), default=0.0)
        d720 = [abs(s["delta"]) for s in r["sync720"] if s["delta"] is not None]
        max720 = max(d720) if d720 else None
        by1080 = {p["segment"]: p for p in r["probes"]}
        dur_diff = max((abs(p["duration"] - by1080[p["segment"]]["duration"]) for p in r["probes720"]), default=0.0)
        bad720 = [p["segment"] for p in r["probes720"]
                  if not p["v"].startswith("h264 High 720x1280 yuv420p") or not p["faststart"]]
        errs = [str(i) for i in r["issues"] if i.level == "error"]
        sub_errs = {k: v for k, v in r["subErrors"].items() if v}
        nodes = doc["nodes"]
        row = {
            "episode": r["episode"], "package": str(r["package"]),
            "segments": sum(1 for n in nodes if n["type"] == "segment"),
            "recaps": [{"id": n["id"], "duration": n["duration"]} for n in nodes if n["type"] == "recap"],
            "title": next(({"duration": n["duration"], "next": n["next"]} for n in nodes if n["type"] == "title"), None),
            "videoFiles": len(r["probes"]),
            "decisions": sum(1 for n in nodes if n["type"] == "decision"),
            "reactions": sum(1 for n in nodes if n["type"] == "reaction"),
            "cards": sum(1 for n in nodes if n["type"] == "card"),
            "tasks": sum(1 for n in nodes if n["type"] == "task"),
            "textOnly": m["textOnly"],
            "syncMax": maxd, "syncChecked": len(deltas), "syncUnmeasured": len(unmeasured),
            "avDurationMaxDiff": round(av, 3), "loudness": m["loudness"], "bytes": m["totalBytes"],
            "graphErrors": errs, "subsSchemaErrors": sub_errs,
            "probes": r["probes"], "sync": r["sync"],
            "r720": {"syncMax": max720, "syncChecked": len(d720), "durationMaxDiff": round(dur_diff, 3),
                     "kbpsMax": max((p["kbps"] for p in r["probes720"]), default=None),
                     "kbps": {p["segment"]: p["kbps"] for p in r["probes720"]},
                     "kbps1080": {p["segment"]: p["kbps"] for p in r["probes"]},
                     "badFormat": bad720, "probes": r["probes720"], "sync": r["sync720"]},
            "renditionBytes": m["renditionBytes"],
        }
        summary.append(row)
        ok = (not errs and not sub_errs and (maxd is None or maxd <= SYNC_LIMIT) and not unmeasured
              and (max720 is None or max720 <= SYNC_LIMIT) and len(d720) == len(deltas)
              and dur_diff <= FRAME + 1e-3 and not bad720)
        failed |= not ok
        print(f"== {r['episode']}: {'TAMAM' if ok else 'SORUN'}  → {r['package']}")
        print(f"   video dosyası {row['videoFiles']} (segment {row['segments']} + özet {len(row['recaps'])} + tepki videosu), "
              f"karar {row['decisions']}, kart {row['cards']}, görev {row['tasks']}, yalnızca metin {len(m['textOnly'])}")
        print(f"   açılış: başlık {row['title']}; özet {row['recaps'] or 'yok'}")
        strict = [abs(s["deltaStrict"]) for s in r["sync"] if s.get("deltaStrict") is not None]
        row["syncMaxStrict"] = max(strict) if strict else None
        print(f"   senkron: en büyük fark {maxd} sn (%10 eşik; bilgi: %35 eşikle {row['syncMaxStrict']} sn), "
              f"{len(deltas)} ölçüm, ölçülemeyen {len(unmeasured)}; "
              f"ses-görüntü süre farkı en çok {row['avDurationMaxDiff']} sn")
        print(f"   ses: önce {m['loudness']['before']['I']} LUFS, kazanç {m['loudness']['gainDb']} dB, "
              f"sonra {m['loudness']['after']['I']} LUFS (TP {m['loudness']['after']['TP']})")
        print(f"   720p: senkron en büyük fark {max720} sn ({len(d720)} ölçüm), süre farkı en çok {dur_diff:.3f} sn, "
              f"bit hızı en çok {row['r720']['kbpsMax']} kb/sn, biçim sorunu {bad720 or 'yok'}")
        rb = m["renditionBytes"]
        print(f"   boyut: paket {m['totalBytes'] / 1e6:.1f} MB, {len(m['files'])} dosya; uygulamanın indirdiği "
              f"720p {rb['720p'] / 1e6:.1f} MB, 1080p {rb['1080p'] / 1e6:.1f} MB")
        for e in errs:
            print(f"   - {e}")
        for k, v in sub_errs.items():
            print(f"   - {k}: {v[:3]}")
    # Sezon paketi bölümlerden sonra: harita kataloğundaki `available` yeni paketleri de görür (H-035).
    for (root, n) in seasons:
        sr = export_season(root, n, probe=media.probe_duration, digest=file_digest, poster=media.still,
                           rendition=media.rendition_720, image=media.to_webp)
        sd = sr["doc"]
        print(f"== Sezon {n} paketi → {sr['dir']}")
        print("   " + ", ".join(f"{k} {sd[k]['video']} {sd[k].get('duration')} sn"
                                for k in ("intro", "short", "titleBackground") if k in sd)
              + f"; boyut {sd['totalBytes'] / 1e6:.1f} MB"
              + (f" (uygulama 720p: {sd['renditionBytes']['720p'] / 1e6:.1f} MB)" if "renditionBytes" in sd else ""))
        if "episodes" in sd:
            avail = [e["number"] for e in sd["episodes"] if e["available"]]
            print(f"   harita: {len(sd['episodes'])} bölüm, oynanabilir {avail}; "
                  f"görsel {sd.get('map', {}).get('image', 'yok (kodla çizilir)')}")
    if a.report:
        Path(a.report).write_text(json.dumps(summary, ensure_ascii=False, indent=2, default=str), encoding="utf-8")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
