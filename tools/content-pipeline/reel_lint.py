#!/usr/bin/env python3
"""reel-lint: Bağımsız konu reeli denetimi (H-094).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/reel_lint.py reeller/A1-R-CIN-01
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/reel_lint.py reeller/* --json

Kurallar: docs/REEL-PAKETI.md (kimlik, seviye/kategori, hedef, altyazı, soru, medya).
Çıkış kodu: 0 = hata yok (uyarı olabilir), 1 = en az bir hata, 2 = kullanım hatası.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.reels import as_dict, lint_reel  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon reel-lint (bağımsız konu reeli denetimi)")
    ap.add_argument("reels", nargs="+", help="reel klasörleri (reeller/A1-R-CIN-01)")
    ap.add_argument("--json", action="store_true", help="makinece okunur rapor")
    a = ap.parse_args(argv)
    dirs = [Path(p) for p in a.reels if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Reel klasörü bulunamadı.", file=sys.stderr)
        return 2
    reports = [lint_reel(d) for d in sorted(dirs)]
    n_err = sum(len(r.errors) for r in reports)
    if a.json:
        print(json.dumps({"reels": [as_dict(r) for r in reports], "errors": n_err}, ensure_ascii=False, indent=2))
        return 1 if n_err else 0
    for r in reports:
        status = "HATA" if r.errors else ("UYARI" if r.warnings else "TAMAM")
        reel = r.reel
        if reel:
            print(f"== {reel.id} ({reel.level}, {reel.category_tr}): {status}")
        else:
            print(f"== {r.path}: {status}")
        for i in r.errors + r.warnings:
            print(f"   - {i}")
    warns = sum(len(r.warnings) for r in reports)
    print(f"Sonuç: {len(reports)} reel, {n_err} hata, {warns} uyarı")
    return 1 if n_err else 0


if __name__ == "__main__":
    sys.exit(main())
