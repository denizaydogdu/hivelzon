#!/usr/bin/env python3
"""grammar-lint: dilbilgisi dersi denetimi (H-077).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/grammar_lint.py dilbilgisi/G-A1-*
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/grammar_lint.py dilbilgisi/G-* --json

Kurallar: docs/DILBILGISI.md §4, §5, §9 (kart sırası, Türkçe anlatım, örnekler, kapsama, cevap anahtarı,
"Hikâyede gör" bağları, ses ve hizalama, öğretmen kontrolü).
Çıkış kodu: 0 = hata yok (uyarı olabilir), 1 = en az bir hata, 2 = kullanım hatası.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.grammarlint import lint_lesson  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon grammar-lint (dilbilgisi dersi denetimi)")
    ap.add_argument("lessons", nargs="+", help="ders klasörleri (dilbilgisi/G-A1-03-...)")
    ap.add_argument("--json", action="store_true", help="makinece okunur rapor")
    ap.add_argument("--icerik-root", help="bölüm klasörü (varsayılan: depo icerik/)")
    ap.add_argument("--books-root", help="kitap klasörü (varsayılan: depo kitaplar/)")
    a = ap.parse_args(argv)
    dirs = [Path(p) for p in a.lessons if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Ders klasörü bulunamadı.", file=sys.stderr)
        return 2
    reports = [lint_lesson(d, icerik_root=a.icerik_root and Path(a.icerik_root),
                           books_root=a.books_root and Path(a.books_root)) for d in sorted(dirs)]
    n_err = sum(len(r.errors) for r in reports)
    if a.json:
        print(json.dumps({"lessons": [r.to_dict() for r in reports], "errors": n_err}, ensure_ascii=False, indent=2))
        return 1 if n_err else 0
    for r in reports:
        status = "HATA" if r.errors else ("UYARI" if r.warnings else "TAMAM")
        print(f"== {r.path.name} ({r.lesson_id}, {r.level}): {status}")
        st = r.stats
        if st:
            au = st["audio"]
            print(f"   {st['cards']} kart, {st['examples']} örnek, {st['practice']} soru, {st['links']} bağ; "
                  f"Türkçe {st['narrationChars']} karakter, İngilizce {st['exampleChars']} karakter")
            print(f"   ses: Türkçe {au['trAligned']}/{au['trSegments']} hizalı ({au['trAudio']} ses), "
                  f"İngilizce {au['enAligned']}/{au['enSegments']} hizalı ({au['enAudio']} ses)")
        if r.coverage:
            cv = r.coverage
            print(f"   kapsama: %{cv['pct']} (sözlükle %{cv['pctWithGlossary']}), {cv['tokens']} token, "
                  f"en uzun cümle {cv['maxSentenceWords']} sözcük")
        for i in r.errors + r.warnings:
            print(f"   - {i}")
    warns = sum(len(r.warnings) for r in reports)
    print(f"Sonuç: {len(reports)} ders, {n_err} hata, {warns} uyarı")
    return 1 if n_err else 0


if __name__ == "__main__":
    sys.exit(main())
