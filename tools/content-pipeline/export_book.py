#!/usr/bin/env python3
"""Kitap paketini üretir: kitaplar/<id>/_build/package/ (H-066).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_book.py kitaplar/A1-K01-the-blue-door
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_book.py kitaplar/*-K* --require-media

Yalnızca yerel ffmpeg ve ImageMagick kullanır; ücretli servis çağrısı yapmaz. Ses ve görseller git
dışındadır: bu ortamda yoksa paket yine üretilir (sessiz okuma, palet renkli sayfa), eksikler
manifest.json → `missing` listesine yazılır ve UYARI olarak gösterilir. `--require-media` ile hata olur.
Çıkış kodu: 0 = tamam, 1 = hata (şema, hizalama uyuşmazlığı ya da --require-media ile eksik medya).
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.book import BookError  # noqa: E402
from hvpipeline.bookexport import export_book  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon kitap paketi dışa aktarma")
    ap.add_argument("books", nargs="+")
    ap.add_argument("--require-media", action="store_true", help="eksik ses/hizalama/görsel hata sayılır")
    ap.add_argument("--report", help="özet raporu JSON olarak yaz")
    a = ap.parse_args(argv)
    failed = False
    summary = []
    for d in [Path(p) for p in a.books if Path(p).is_dir() and not Path(p).name.startswith("_")]:
        try:
            r = export_book(d)
        except BookError as e:
            print(f"== {d.name}: HATA\n   - {e}")
            failed = True
            continue
        miss_tr = [m for m in r.translation_misses if m.kind != "chunk"]
        bad = bool(r.errors) or (a.require_media and bool(r.missing))
        failed |= bad
        status = "HATA" if bad else ("UYARI" if r.missing or miss_tr else "TAMAM")
        m = r.manifest
        timed = sum(1 for c in r.pages["chapters"] if c["heading"]["start"] is not None)
        print(f"== {r.book_id}: {status}  → {r.package}")
        print(f"   {len(r.pages['chapters'])} bölüm ({timed} zamanlı, {sum(1 for c in r.pages['chapters'] if c['audio'])} sesli), "
              f"{len(r.pages['pages'])} sayfa, {sum(len(p['sentences']) for p in r.pages['pages'])} cümle, "
              f"{sum(1 for p in r.pages['pages'] if p['image'])} görsel; {len(m['files'])} dosya, {m['totalBytes'] / 1e6:.2f} MB")
        if m["loudness"]:
            lo = m["loudness"]
            print(f"   ses: önce {lo['before']['I']} LUFS, kazanç {lo['gainDb']} dB, sonra {lo['after']['I']} LUFS")
        for e in r.errors:
            print(f"   - HATA {e}")
        for x in r.missing:
            tag = "HATA" if a.require_media else "UYARI"
            print(f"   - {tag} [book-media] bu ortamda yok (git dışı medya): {x['path']}")
        if miss_tr:
            print(f"   - UYARI [translation] {len(miss_tr)} eksik çeviri/anlam (book_lint.py ayrıntıyı verir)")
        summary.append({"book": r.book_id, "package": str(r.package), "errors": r.errors, "missing": r.missing,
                        "files": len(m["files"]), "bytes": m["totalBytes"], "loudness": m["loudness"]})
    if a.report:
        Path(a.report).write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
