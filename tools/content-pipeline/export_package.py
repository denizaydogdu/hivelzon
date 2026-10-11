#!/usr/bin/env python3
"""Bölüm paketini üretir: icerik/<id>/_build/package/ (H-034).

Kullanım:
    python3 tools/content-pipeline/export_package.py icerik/A1-001-a-strange-message [icerik/A1-002-…]
    python3 tools/content-pipeline/export_package.py icerik/A1-00[1-4]-* --report rapor.json

Yalnızca yerel ffmpeg ve ImageMagick kullanır; ücretli servis çağrısı yapmaz. Var olmayan ses için
düğüm yalnızca metin (Hi balonu) olarak kalır ve manifest'teki textOnly listesine yazılır.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.export import export_episode  # noqa: E402

SYNC_LIMIT = 0.2
AV_LIMIT = 0.05


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon bölüm paketi dışa aktarma")
    ap.add_argument("episodes", nargs="+")
    ap.add_argument("--no-ai-label", action="store_true", help="'Yapay zekâ ile üretilmiştir' yazısını gömme")
    ap.add_argument("--report", help="özet raporu JSON olarak yaz")
    a = ap.parse_args(argv)
    summary, failed = [], False
    for d in a.episodes:
        r = export_episode(Path(d), label=not a.no_ai_label)
        m, doc = r["manifest"], r["doc"]
        deltas = [abs(s["delta"]) for s in r["sync"] if s["delta"] is not None]
        unmeasured = [s for s in r["sync"] if s["delta"] is None]
        maxd = max(deltas) if deltas else None
        av = max((abs(p["vdur"] - p["adur"]) for p in r["probes"]), default=0.0)
        errs = [str(i) for i in r["issues"] if i.level == "error"]
        sub_errs = {k: v for k, v in r["subErrors"].items() if v}
        nodes = doc["nodes"]
        row = {
            "episode": r["episode"], "package": str(r["package"]),
            "segments": sum(1 for n in nodes if n["type"] == "segment"),
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
        }
        summary.append(row)
        ok = not errs and not sub_errs and (maxd is None or maxd <= SYNC_LIMIT) and not unmeasured
        failed |= not ok
        print(f"== {r['episode']}: {'TAMAM' if ok else 'SORUN'}  → {r['package']}")
        print(f"   video dosyası {row['videoFiles']} (segment {row['segments']} + tepki videosu), karar {row['decisions']}, "
              f"kart {row['cards']}, görev {row['tasks']}, yalnızca metin {len(m['textOnly'])}")
        strict = [abs(s["deltaStrict"]) for s in r["sync"] if s.get("deltaStrict") is not None]
        row["syncMaxStrict"] = max(strict) if strict else None
        print(f"   senkron: en büyük fark {maxd} sn (%10 eşik; bilgi: %35 eşikle {row['syncMaxStrict']} sn), "
              f"{len(deltas)} ölçüm, ölçülemeyen {len(unmeasured)}; "
              f"ses-görüntü süre farkı en çok {row['avDurationMaxDiff']} sn")
        print(f"   ses: önce {m['loudness']['before']['I']} LUFS, kazanç {m['loudness']['gainDb']} dB, "
              f"sonra {m['loudness']['after']['I']} LUFS (TP {m['loudness']['after']['TP']})")
        print(f"   boyut: {m['totalBytes'] / 1e6:.1f} MB, {len(m['files'])} dosya")
        for e in errs:
            print(f"   - {e}")
        for k, v in sub_errs.items():
            print(f"   - {k}: {v[:3]}")
    if a.report:
        Path(a.report).write_text(json.dumps(summary, ensure_ascii=False, indent=2, default=str), encoding="utf-8")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
