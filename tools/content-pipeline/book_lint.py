#!/usr/bin/env python3
"""book-lint: Kitaplık kitabı denetimi (H-066).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/book_lint.py kitaplar/A1-K01-*
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/book_lint.py kitaplar/*-K* --json

Kurallar: docs/KITAPLIK.md §4–§6 (kapsama, cümle uzunluğu, kelime sayısı, sözlük, çeviri, ses, görsel).
Çıkış kodu: 0 = hata yok (uyarı olabilir), 1 = en az bir hata, 2 = kullanım hatası.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.booklint import lint_book  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon book-lint (Kitaplık kitabı denetimi)")
    ap.add_argument("books", nargs="+", help="kitap klasörleri (kitaplar/A1-K01-...)")
    ap.add_argument("--json", action="store_true", help="makinece okunur rapor")
    a = ap.parse_args(argv)
    dirs = [Path(p) for p in a.books if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Kitap klasörü bulunamadı.", file=sys.stderr)
        return 2
    reports = [lint_book(d) for d in sorted(dirs)]
    n_err = sum(len(r.errors) for r in reports)
    if a.json:
        print(json.dumps({"books": [r.to_dict() for r in reports], "errors": n_err}, ensure_ascii=False, indent=2))
        return 1 if n_err else 0
    for r in reports:
        status = "HATA" if r.errors else ("UYARI" if r.warnings else "TAMAM")
        print(f"== {r.path.name} ({r.book_id}, {r.level}): {status}")
        st = r.stats
        if st:
            lo, hi = st.get("wordTarget", ["?", "?"])
            print(f"   {st.get('chapters')} bölüm, {st.get('pages')} sayfa, {st.get('sentences')} cümle, "
                  f"{st.get('words')} kelime (hedef {lo}–{hi})")
        if r.coverage:
            cv = r.coverage
            print(f"   kapsama: %{cv['pct']} (sözlükle %{cv['pctWithGlossary']}), {cv['tokens']} token, "
                  f"en uzun cümle {cv['maxSentenceWords']} sözcük")
        if r.translation:
            t = r.translation
            print(f"   çeviri [{t['status']}]: {t['unitsTranslated']}/{t['units']} cümle, "
                  f"{t['wordsGlossed']}/{t['wordsNeedingGloss']} kelime anlamlı")
        md = st.get("media") if st else None
        if md:
            wpm = ", ".join(f"{k} {v} k/dk" for k, v in md["wpm"].items()) or "ölçülmedi"
            print(f"   ses: {md['aligned']}/{md['chapters']} bölüm hizalı, {md['audio']} ses dosyası; hız {wpm}; "
                  f"görsel {md['imagesPresent']}/{md['images']}")
        for i in r.errors + r.warnings:
            print(f"   - {i}")
    warns = sum(len(r.warnings) for r in reports)
    print(f"Sonuç: {len(reports)} kitap, {n_err} hata, {warns} uyarı")
    return 1 if n_err else 0


if __name__ == "__main__":
    sys.exit(main())
