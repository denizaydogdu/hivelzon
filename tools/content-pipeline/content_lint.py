#!/usr/bin/env python3
"""content-lint: hiVelzon bölüm denetimi (H-034).

Kullanım:
    python3 tools/content-pipeline/content_lint.py icerik/A1-0*
    python3 tools/content-pipeline/content_lint.py icerik/A1-001-* --json
    python3 tools/content-pipeline/content_lint.py icerik/A1-001-* --graph-source kurgu
    python3 tools/content-pipeline/content_lint.py icerik/A1-0* --write-reports   # _build/lint.json (H-041)

Çıkış kodu: 0 = hata yok (uyarı olabilir), 1 = en az bir hata, 2 = kullanım hatası.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.lint import check_chain, lint_episode  # noqa: E402
from hvpipeline.hi import has_hi_sources, lint_hi  # noqa: E402
from hvpipeline.sets import lint_sets, sets_dir  # noqa: E402


def write_reports(reports, chain) -> list[Path]:
    """Bölüm başına lint özeti: <bölüm>/_build/lint.json (H-041).

    Backend içe aktarması hata/uyarı sayısını buradan alır; rapor paketten (manifest.json) eskiyse yok sayılır.
    Zincir (bölümler arası) bulguları, mesajında bölümün kimliği geçiyorsa o bölüme eklenir. Atomik yazılır.
    """
    from datetime import datetime, timezone
    import os

    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    written = []
    for r in reports:
        cid = r.content_id or ""
        mine = [i for i in chain if cid and cid in str(i)]
        doc = {
            "tool": "content-lint", "schemaVersion": 1, "contentId": r.content_id, "level": r.level,
            "generatedAt": now,
            "errors": [str(i) for i in r.errors] + [str(i) for i in mine if i.level == "error"],
            "warnings": [str(i) for i in r.warnings] + [str(i) for i in mine if i.level != "error"],
            "coverage": r.coverage,
        }
        out = r.path / "_build" / "lint.json"
        out.parent.mkdir(parents=True, exist_ok=True)
        tmp = out.with_suffix(".json.tmp")
        tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        os.replace(tmp, out)
        written.append(out)
    return written


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon content-lint (CEFR kapsama, bağ alanları, scenes grafiği)")
    ap.add_argument("episodes", nargs="+", help="bölüm klasörleri (icerik/A1-001-...)")
    ap.add_argument("--json", action="store_true", help="makinece okunur rapor")
    ap.add_argument("--graph-source", choices=["auto", "package", "kurgu"], default="auto",
                    help="grafik kaynağı: _build/package/scenes.json ya da kurgu.json (varsayılan: varsa paket)")
    ap.add_argument("--no-chain", action="store_true", help="bölümler arası zincir denetimini atla")
    ap.add_argument("--no-sets", action="store_true", help="konu seti denetimini atla (H-051)")
    ap.add_argument("--no-hi", action="store_true", help="Hi-A verisi denetimini atla (H-048)")
    ap.add_argument("--write-reports", action="store_true",
                    help="her bölüm için <bölüm>/_build/lint.json yaz (backend içe aktarması okur, H-041)")
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

    # Konu setleri (H-051): bölümlerle aynı içerik kökündeki _evren/setler/.
    sets = []
    roots = {d.resolve().parent for d in dirs}
    if not a.no_sets:
        for root in sorted(roots):
            if sets_dir(root).is_dir():
                sets += lint_sets(root)
    # Hi-A verisi (H-048): hata kataloğu, konu tanıtımları, köprü görevleri.
    hi = []
    if not a.no_hi:
        for root in sorted(roots):
            if has_hi_sources(root):
                hi += lint_hi(root)
    n_err = (sum(len(r.errors) for r in reports) + sum(1 for i in chain if i.level == "error")
             + sum(1 for _, iss, _ in sets for i in iss if i.level == "error")
             + sum(1 for _, iss in hi for i in iss if i.level == "error"))
    if a.write_reports:
        write_reports(reports, chain)
    if a.json:
        print(json.dumps({"episodes": [r.to_dict() for r in reports], "chain": [str(i) for i in chain],
                          "sets": [{"id": sid, **rep, "errors": [str(i) for i in iss if i.level == "error"],
                                    "warnings": [str(i) for i in iss if i.level == "warning"]}
                                   for sid, iss, rep in sets],
                          "hi": [{"file": name, "errors": [str(i) for i in iss if i.level == "error"],
                                  "warnings": [str(i) for i in iss if i.level == "warning"]} for name, iss in hi],
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
            print(f"   grafik [{g['source']}]: {g['nodes']} düğüm, {g['titles']} başlık, {g['recaps']} özet, {g['segments']} segment, {g['decisions']} karar, "
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
    for sid, iss, rep in sets:
        errs = [i for i in iss if i.level == "error"]
        print(f"== Konu seti {sid}: {'HATA' if errs else ('UYARI' if iss else 'TAMAM')}")
        if rep.get("tokens"):
            print(f"   {rep['items']} öğe ({rep['audio']} sesli); örnek cümle kapsaması %{rep['pct']} "
                  f"(sözlükle %{rep['pctWithGlossary']}), en uzun cümle {rep['maxSentenceWords']} sözcük")
        for i in iss:
            print(f"   - {i}")
    for name, iss in hi:
        errs = [i for i in iss if i.level == "error"]
        print(f"== Hi verisi {name}: {'HATA' if errs else ('UYARI' if iss else 'TAMAM')}")
        for i in iss:
            print(f"   - {i}")
    warns = (sum(len(r.warnings) for r in reports) + sum(1 for _, iss, _ in sets for i in iss if i.level == "warning")
             + sum(1 for _, iss in hi for i in iss if i.level == "warning"))
    print(f"Sonuç: {len(reports)} bölüm, {len(sets)} konu seti, {len(hi)} Hi dosyası, {n_err} hata, {warns} uyarı")
    return 1 if n_err else 0


if __name__ == "__main__":
    sys.exit(main())
