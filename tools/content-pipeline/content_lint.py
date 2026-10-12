#!/usr/bin/env python3
"""content-lint: hiVelzon bölüm denetimi (H-034).

Kullanım:
    python3 tools/content-pipeline/content_lint.py icerik/A1-0*
    python3 tools/content-pipeline/content_lint.py icerik/A1-001-* --json
    python3 tools/content-pipeline/content_lint.py icerik/A1-001-* --graph-source kurgu

Çıkış kodu: 0 = hata yok (uyarı olabilir), 1 = en az bir hata, 2 = kullanım hatası.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.lint import check_chain, lint_episode  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon content-lint (CEFR kapsama, bağ alanları, scenes grafiği)")
    ap.add_argument("episodes", nargs="+", help="bölüm klasörleri (icerik/A1-001-...)")
    ap.add_argument("--json", action="store_true", help="makinece okunur rapor")
    ap.add_argument("--graph-source", choices=["auto", "package", "kurgu"], default="auto",
                    help="grafik kaynağı: _build/package/scenes.json ya da kurgu.json (varsayılan: varsa paket)")
    ap.add_argument("--no-chain", action="store_true", help="bölümler arası zincir denetimini atla")
    a = ap.parse_args(argv)

    dirs = [Path(p) for p in a.episodes if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Bölüm klasörü bulunamadı.", file=sys.stderr)
        return 2
    reports = [lint_episode(d, a.graph_source) for d in sorted(dirs)]
    chain = []
    if not a.no_chain and len(reports) > 1:
        contents = []
        for d in sorted(dirs):
            try:
                contents.append(json.loads((d / "content.json").read_text(encoding="utf-8")))
            except (OSError, json.JSONDecodeError):
                pass
        chain = check_chain(contents)

    n_err = sum(len(r.errors) for r in reports) + sum(1 for i in chain if i.level == "error")
    if a.json:
        print(json.dumps({"episodes": [r.to_dict() for r in reports], "chain": [str(i) for i in chain],
                          "errors": n_err}, ensure_ascii=False, indent=2))
        return 1 if n_err else 0

    for r in reports:
        status = "HATA" if r.errors else ("UYARI" if r.warnings else "TAMAM")
        print(f"== {r.path.name} ({r.content_id}, {r.level}): {status}")
        if r.coverage:
            cv = r.coverage
            print(f"   kapsama: %{cv['pct']} (sözlükle %{cv['pctWithGlossary']}), {cv['tokens']} token, "
                  f"en uzun cümle {cv['maxSentenceWords']} sözcük")
        if r.graph:
            g = r.graph
            print(f"   grafik [{g['source']}]: {g['nodes']} düğüm, {g['segments']} segment, {g['decisions']} karar, "
                  f"{g['reactions']} tepki, {g['cards']} kart, {g['tasks']} görev, {g['flags']} bayrak")
        else:
            print("   grafik: scenes.json / kurgu.json yok, atlandı")
        if r.translation and "cues" in r.translation:
            t = r.translation
            print(f"   çeviri [{t['status']}]: {t['cuesTranslated']}/{t['cues']} altyazı satırı, "
                  f"{t['wordsGlossed']}/{t['wordsNeedingGloss']} kelime anlamlı (özel adlar hariç; toplam {t['words']}), "
                  f"{t['chunks']} kalıp")
        for i in r.errors + r.warnings:
            print(f"   - {i}")
    if chain:
        print("== Zincir (bölümler arası)")
        for i in chain:
            print(f"   - {i}")
    print(f"Sonuç: {len(reports)} bölüm, {n_err} hata, "
          f"{sum(len(r.warnings) for r in reports)} uyarı")
    return 1 if n_err else 0


if __name__ == "__main__":
    sys.exit(main())
