#!/usr/bin/env python3
"""Kitaplarda "Sayfanın Türkçesi"nin sesi: PatientDesk Alania + Duyu, sayfa başına bir ses (H-105).

Metin uygulamanın "Sayfanın Türkçesi" panelindekiyle aynıdır (hvpipeline/booktr.py). Ses ve söyleniş
sözlüğü `book.json` → `narrationTr` (varsayılan rol `hi`, `icerik/_evren/sesler.json`).

Kullanım:
    P=tools/content-pipeline/.venv/bin/python
    # Kuru çalışma (varsayılan): API çağrılmaz; sayfa, karakter ve tahmini TL yazılır.
    $P tools/content-pipeline/tts_book_tr.py kitaplar/A1-K*

    # Gerçek üretim (aylık tavan şart; kaldığı yerden sürer, güncel sayfalar atlanır):
    HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=1500000 $P tools/content-pipeline/tts_book_tr.py kitaplar/A1-K* --execute

    # Duyu dökümünde şüpheli kelimeler (söyleniş denetimi; API çağrılmaz):
    $P tools/content-pipeline/tts_book_tr.py kitaplar/A2-K* --suspects

Çıktı: `<kitap>/audio/tr/<sayfa>.mp3` (git dışı, -16 LUFS), `<sayfa>.align.json` (depoda), `_raw/` (ödenmiş
önbellek, git dışı). Her gerçek çağrı `<kitap>/PROMPTS.md`'ye ve aylık deftere yazılır. Anahtar PD_API_KEY
(ortam) ya da ~/.config/hivelzon/patientdesk.env; yalnız --execute ile okunur, yazdırılmaz.
Çıkış kodu: 0 = tamam, 1 = hata ya da tavan nedeniyle durdu, 2 = kullanım hatası,
3 = tamamlandı ama hizalama uyarısı var (--strict ile).
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import booktr  # noqa: E402
from hvpipeline import tts_tr as tr  # noqa: E402
from hvpipeline.book import Book, BookError  # noqa: E402


def suspects(book: Book) -> list[str]:
    """Hizalama dosyalarından zayıf/eksik eşleşen kelimeler ve söyleniş sözlüğündeki terimlerin duyuluşu."""
    out = []
    terms = [p["term"] for p in booktr.narration_tr(book).get("pronunciations") or [] if isinstance(p, dict)]
    for ap in sorted(booktr.out_dir(book).glob("*.align.json")):
        d = json.loads(ap.read_text(encoding="utf-8"))
        bad = [f"{w['w']}→{w.get('heard') or '∅'}" for w in d.get("words", []) if w.get("status") in ("weak", "missing")]
        named = [f"{w['w']}→{w.get('heard') or w['w']}" for w in d.get("words", [])
                 if any(w["w"].startswith(t.split()[0]) for t in terms) and w.get("status") != "exact"]
        q = d.get("quality") or {}
        if bad or named or q.get("ok") is False:
            out.append(f"  {book.id} {ap.name.removesuffix('.align.json')}: skor {q.get('score')}"
                       + (f"; zayıf/eksik: {', '.join(bad[:10])}" if bad else "")
                       + (f"; sözlük terimi: {', '.join(named[:6])}" if named else ""))
    return out


def main(argv: list[str] | None = None, client=None, finalize=None, sleep=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon kitap sayfalarının Türkçesi (Alania + Duyu)")
    ap.add_argument("books", nargs="+")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: API çağrılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek çağrı yap")
    g.add_argument("--suspects", action="store_true", help="Duyu dökümünde şüpheli kelimeleri listele")
    ap.add_argument("--page", action="append", help="yalnızca bu sayfa(lar) (p01 …)")
    ap.add_argument("--force", action="store_true", help="çıktı güncel olsa da yeniden kur (önbellek kullanılır)")
    ap.add_argument("--monthly-char-cap", type=int, help=f"aylık karakter tavanı (yoksa {tr.ENV_CAP})")
    ap.add_argument("--ledger", help=f"aylık kullanım defteri (varsayılan {tr.ENV_LEDGER} ya da {tr.DEFAULT_LEDGER})")
    ap.add_argument("--voice-map", help="ses haritası (varsayılan icerik/_evren/sesler.json)")
    ap.add_argument("--strict", action="store_true", help="hizalama uyarısında çıkış kodu 3")
    a = ap.parse_args(argv)

    dirs = [Path(p) for p in a.books if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Kitap klasörü bulunamadı.", file=sys.stderr)
        return 2
    vm = Path(a.voice_map) if a.voice_map else None
    try:
        cap = tr.monthly_cap(a.monthly_char_cap)
        books = [Book.load(d) for d in sorted(dirs)]
        plans = [(b, booktr.plan_book(b, vm, a.page, a.force)) for b in books]
    except (BookError, booktr.BookTrError, tr.TrTtsError, OSError, KeyError, ValueError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    if a.suspects:
        rows = [r for b in books for r in suspects(b)]
        print("\n".join(rows) if rows else "Şüpheli satır yok.")
        return 0
    ledger = tr.ledger_path(a.ledger)
    month = tr.month_key()
    used = tr.ledger_used(ledger, month)
    chars = secs = 0
    for b, plan in plans:
        todo = [j for j in plan.jobs if j.action != "skip"]
        print(f"== {b.id}: {len(plan.jobs)} sayfa, {sum(j.chars for j in plan.jobs)} karakter; "
              f"yapılacak {len(todo)} (Alania {plan.billable_chars} karakter)")
        for j in todo:
            print(f"   {j.seg.id}: {j.chars} karakter — {j.reason}")
        chars += plan.billable_chars
        secs += plan.est_stt_seconds
    print(f"Toplam Alania: {chars} karakter; Duyu ≈ {secs:.0f} sn (tahmin). Tarife ≈ {tr.estimate_tl(chars, secs):.2f} TL "
          f"(kampanya dönemi ücretsiz). Bu ay ({month}) kullanılan: {used}; "
          f"tavan: {cap if cap is not None else 'TANIMLI DEĞİL'}")
    if not a.execute:
        print("Kuru çalışma: API çağrılmadı. Gerçek üretim için --execute.")
        if cap is None:
            print(f"Not: {tr.ENV_CAP} tanımlı değil; --execute reddedilir.")
        return 0
    if cap is None:
        print(f"HATA: aylık karakter tavanı tanımlı değil ({tr.ENV_CAP}); ücretli üretim kapalı.", file=sys.stderr)
        return 1
    kw = {}
    if finalize is not None:
        kw["finalize"] = finalize
    if sleep is not None:
        kw["sleep"] = sleep
    call = client
    warned = False
    for b, plan in plans:
        if not any(j.action != "skip" for j in plan.jobs):
            continue
        try:
            if call is None and any(j.action in ("tts", "stt") for j in plan.jobs):
                call = tr.HttpClient()
            r = tr.execute(plan, call, cap, ledger, b.dir / "PROMPTS.md", **kw)
        except tr.TrTtsError as e:
            print(f"HATA {b.id}: {e}", file=sys.stderr)
            return 1
        for d in r.done:
            q = d.quality
            print(f"  {b.id} {d.id}: {d.chars} karakter, {d.duration:.2f} sn, LUFS {d.lufs}, hizalama "
                  f"{q['exact']}+{q['fuzzy']}/{q['words']} (skor {q['score']}){'' if q['ok'] else ' — UYARI'}")
        print(f"== {b.id}: {len(r.done)} sayfa kuruldu, {len(r.skipped)} atlandı; Alania {r.tts_calls} çağrı / "
              f"{r.chars} karakter, Duyu {r.stt_calls} çağrı / {r.stt_seconds:.1f} sn")
        warned |= bool(r.warnings)
        if r.stopped:
            return 1
    return 3 if warned and a.strict else 0


if __name__ == "__main__":
    sys.exit(main())
