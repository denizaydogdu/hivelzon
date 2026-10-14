#!/usr/bin/env python3
"""Kitap seslendirmesi: ElevenLabs zaman damgalı TTS (H-066).

Kullanım:
    # Kuru çalışma (varsayılan): API çağrılmaz; karakter ve tahmini kredi yazılır.
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_book.py kitaplar/A1-K01-the-blue-door

    # Gerçek üretim (ÜCRETLİ; önce maliyet gösterilir ve kullanıcı onayı alınır):
    ELEVENLABS_API_KEY=... HIVELZON_TTS_MONTHLY_CHAR_CAP=10000 \\
      tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_book.py kitaplar/A1-K01-the-blue-door --execute

Kurallar (hvpipeline/tts.py):
- Anahtar yalnızca ortamdan (ELEVENLABS_API_KEY) ve yalnızca --execute ile okunur; dosyaya/loga yazılmaz.
- Aylık karakter tavanı tanımlı değilse --execute reddedilir.
- Sesi ve hizalaması güncel olan bölüm atlanır (textSha256); ödenmiş parçalar audio/_parts/ önbelleğinden.
- Her gerçek çağrı <kitap>/PROMPTS.md'ye ve aylık kullanım defterine yazılır.
Çıkış kodu: 0 = tamam, 1 = hata ya da tavan nedeniyle durdu, 2 = kullanım hatası.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline.book import Book, BookError  # noqa: E402
from hvpipeline import tts  # noqa: E402


def main(argv: list[str] | None = None, client=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon kitap seslendirmesi (ElevenLabs, zaman damgalı)")
    ap.add_argument("books", nargs="+")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: API çağrılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek (ücretli) çağrı yap")
    ap.add_argument("--chapter", action="append", help="yalnızca bu bölüm(ler) (c1, c2 …)")
    ap.add_argument("--force", action="store_true", help="güncel olsa da yeniden üret (yine tavan ve --execute gerekir)")
    ap.add_argument("--monthly-char-cap", type=int, help=f"aylık karakter tavanı (yoksa {tts.ENV_CAP})")
    ap.add_argument("--ledger", help=f"aylık kullanım defteri (varsayılan {tts.ENV_LEDGER} ya da {tts.DEFAULT_LEDGER})")
    a = ap.parse_args(argv)

    try:
        cap = tts.monthly_cap(a.monthly_char_cap)
    except tts.TtsError as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    ledger = tts.ledger_path(a.ledger)
    month = tts.month_key()
    used = tts.ledger_used(ledger, month)
    plans = []
    for d in [Path(p) for p in a.books if Path(p).is_dir() and not Path(p).name.startswith("_")]:
        try:
            plans.append(tts.plan_book(Book.load(d), a.chapter, a.force))
        except (BookError, tts.TtsError) as e:
            print(f"== {d.name}: HATA {e}")
            return 1
    if not plans:
        print("Kitap klasörü bulunamadı.", file=sys.stderr)
        return 2
    total = sum(tts.plan_billable(p) for p in plans)
    credits = sum(p.credits() for p in plans)
    for p in plans:
        print("\n".join(tts.describe(p)))
    print(f"Toplam istenecek: {total} karakter ≈ {credits:.0f} kredi (tahmin; model fiyatı doğrulanmalı). "
          f"Bu ay ({month}) kullanılan: {used}; tavan: {cap if cap is not None else 'TANIMLI DEĞİL'}")
    if not a.execute:
        print("Kuru çalışma: API çağrılmadı. Gerçek üretim için maliyet onayından sonra --execute.")
        if cap is None:
            print(f"Not: {tts.ENV_CAP} tanımlı değil; --execute reddedilir.")
        return 0
    if cap is None:
        print(f"HATA: aylık karakter tavanı tanımlı değil ({tts.ENV_CAP}); ücretli üretim kapalı.", file=sys.stderr)
        return 1
    if used + total > cap:
        print(f"UYARI: toplam {total} karakter tavanı aşar ({used} + {total} > {cap}); tavana kadar üretilip durulur.")
    try:
        call = client or tts.http_client()
        failed = False
        for p in plans:
            r = tts.execute(p, call, cap, ledger)
            print(f"== {p.book.id}: üretilen {r.generated or '-'}, atlanan {r.skipped or '-'}, "
                  f"{r.calls} çağrı, {r.chars} karakter")
            if r.stopped:
                failed = True
                break
    except tts.TtsError as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 1
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
