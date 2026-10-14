#!/usr/bin/env python3
"""Dilbilgisi dersi paketini üretir: dilbilgisi/<G-ID>/_build/package/ (H-077).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_grammar.py dilbilgisi/G-A1-03-third-person-s
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_grammar.py dilbilgisi/G-* --require-media

Yalnızca yerel ffmpeg kullanır; ücretli servis çağrısı yapmaz. Ses dosyaları git dışındadır: bu ortamda yoksa
paket yine üretilir (sessiz okuma), eksikler manifest.json → `missing` listesine yazılır ve UYARI olarak
gösterilir. `--require-media` ile hata olur. Önce grammar_lint.py çalıştırılır (bu araç denetim yapmaz;
yalnız şema, hizalama ve bağ çözümü hatalarını bildirir).
Çıkış kodu: 0 = tamam, 1 = hata.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.grammarexport import export_lesson  # noqa: E402
from hvpipeline.lesson import LessonError  # noqa: E402


def main(argv: list[str] | None = None, media=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon dilbilgisi dersi paketi")
    ap.add_argument("lessons", nargs="+")
    ap.add_argument("--require-media", action="store_true", help="eksik ses/hizalama hata sayılır")
    ap.add_argument("--icerik-root", help="bölüm klasörü (varsayılan: depo icerik/)")
    ap.add_argument("--books-root", help="kitap klasörü (varsayılan: depo kitaplar/)")
    ap.add_argument("--report", help="özet raporu JSON olarak yaz")
    a = ap.parse_args(argv)
    failed = False
    summary = []
    dirs = [Path(p) for p in a.lessons if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Ders klasörü bulunamadı.", file=sys.stderr)
        return 1
    for d in dirs:
        try:
            r = export_lesson(d, media=media, icerik_root=a.icerik_root and Path(a.icerik_root),
                              books_root=a.books_root and Path(a.books_root))
        except LessonError as e:
            print(f"== {d.name}: HATA\n   - {e}")
            failed = True
            continue
        bad = bool(r.errors) or (a.require_media and bool(r.missing))
        failed |= bad
        status = "HATA" if bad else ("UYARI" if r.missing else "TAMAM")
        m, ld = r.manifest, r.lesson
        cards = r.cards["cards"]
        print(f"== {r.lesson_id}: {status}  → {r.package}")
        print(f"   {len(cards)} kart, {sum(len(c['examples']) for c in cards)} örnek, "
              f"{sum(len(c['practice']) for c in cards)} soru, {sum(len(c['links']) for c in cards)} bağ; "
              f"ses {ld['durations']['total']} sn, ~{ld['estimatedMinutes']} dk; {len(m['files'])} dosya, "
              f"{m['totalBytes'] / 1e6:.2f} MB")
        for e in r.errors:
            print(f"   - HATA {e}")
        for x in r.missing:
            tag = "HATA" if a.require_media else "UYARI"
            print(f"   - {tag} [lesson-media] bu ortamda yok: {x['path']}")
        summary.append({"lesson": r.lesson_id, "package": str(r.package), "errors": r.errors, "missing": r.missing,
                        "files": len(m["files"]), "bytes": m["totalBytes"]})
    if a.report:
        Path(a.report).write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
