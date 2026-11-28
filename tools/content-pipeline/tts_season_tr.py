#!/usr/bin/env python3
"""Sezon paketindeki Türkçe metinlerin sesi (H-109 Faz 3b): PatientDesk Alania + Duyu, ses Hi.

Bölümler (`--part`, en az biri zorunlu; yalnız istenen planlanır): `talk` (Konuş: karakter repliği, örnek cevap ve
kapanışın Türkçesi), `sets` (konu seti örnek cümlesinin Türkçesi), `clips` (Keşfet bölüm kliplerinin alıştırması:
soru + Türkçe seçenekler, açıklama). Ayrıntı: hvpipeline/seasontr.py.

Kullanım:
    P=tools/content-pipeline/.venv/bin/python
    # Kuru çalışma (varsayılan): üretim çağrısı yapılmaz; parça, karakter, tahmini TL ve PatientDesk ücret
    # durumu (yalnız okuma: GET /v1/usage; --offline ile o da yok) yazılır.
    $P tools/content-pipeline/tts_season_tr.py --part talk --part sets --part clips --offline

    # Gerçek üretim (aylık tavan şart; kaldığı yerden sürer, güncel parçalar atlanır):
    HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=… $P tools/content-pipeline/tts_season_tr.py --part talk --execute

    # Pakete ekleme: sezon paketi yeniden kurulur (yalnız güncel sesler girer):
    $P tools/content-pipeline/export_package.py --season 1

Çıktı: `icerik/_evren/konusma/audio/ceviri/`, `icerik/_evren/setler/audio/ceviri/`, `icerik/_evren/klipler/audio/tr/`
→ `<parça>.mp3` (git dışı, -16 LUFS), `<parça>.align.json` (depoda), `_raw/` (ödenmiş önbellek, git dışı). Her gerçek
çağrı aynı klasördeki `PROMPTS.md`'ye ve aylık deftere yazılır. Anahtar PD_API_KEY (ortam) ya da
~/.config/hivelzon/patientdesk.env; --execute ile ve kuru çalışmada ücret durumu için okunur (--offline ile
okunmaz), yazdırılmaz.
Çıkış kodu: 0 = tamam, 1 = hata ya da tavan nedeniyle durdu, 2 = kullanım hatası,
3 = tamamlandı ama hizalama uyarısı var (--strict ile).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import seasontr  # noqa: E402
from hvpipeline import tts_tr as tr  # noqa: E402

ICERIK = Path(__file__).resolve().parents[2] / "icerik"


def main(argv: list[str] | None = None, client=None, finalize=None, sleep=None, billing=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon sezon paketindeki Türkçe metinlerin sesi (Alania + Duyu)")
    ap.add_argument("--part", action="append", choices=seasontr.PARTS, required=True,
                    help="bölüm(ler): talk (Konuş çevirileri), sets (konu seti örnek Türkçesi), clips (klip alıştırması)")
    ap.add_argument("--root", default=str(ICERIK), help="içerik kökü (varsayılan icerik/)")
    ap.add_argument("--season", type=int, help="yalnız bu sezonun görevleri/setleri/klipleri")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: üretim çağrısı yapılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek çağrı yap")
    ap.add_argument("--segment", action="append", help="yalnız bu parça(lar) (ör. cafe-rosa-t1-line, S1-K01-prompt)")
    ap.add_argument("--allow-english", action="store_true",
                    help="sözlükte olmayan İngilizce kelime/ad olsa da üret (varsayılan: --execute reddeder; sözlük "
                         "sonra eklenirse ses yeniden ücretlenir)")
    ap.add_argument("--force", action="store_true", help="çıktı güncel olsa da yeniden kur (önbellek kullanılır)")
    ap.add_argument("--monthly-char-cap", type=int, help=f"aylık karakter tavanı (yoksa {tr.ENV_CAP})")
    ap.add_argument("--ledger", help=f"aylık kullanım defteri (varsayılan {tr.ENV_LEDGER} ya da {tr.DEFAULT_LEDGER})")
    ap.add_argument("--voice-map", help="ses haritası (varsayılan <kök>/_evren/sesler.json)")
    ap.add_argument("--strict", action="store_true", help="hizalama uyarısında çıkış kodu 3")
    ap.add_argument("--offline", action="store_true",
                    help=f"ücret durumunu PatientDesk'ten okuma (ya da {tr.ENV_OFFLINE}=1); ücretli varsayılır")
    a = ap.parse_args(argv)
    parts = tuple(dict.fromkeys(a.part))
    root = Path(a.root)
    vm = Path(a.voice_map) if a.voice_map else None
    try:
        cap = tr.monthly_cap(a.monthly_char_cap)
        plans = []
        for part in parts:
            us = seasontr.units(root, part, a.season)
            plans.append((part, us, seasontr.plan_part(root, part, vm, a.segment, a.force, us=us)))
    except (seasontr.SeasonTrError, tr.TrTtsError, OSError, KeyError, ValueError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    if a.segment and not any(p.jobs for _, _, p in plans):
        print("HATA: --segment hiçbir parçayla eşleşmedi", file=sys.stderr)
        return 2
    ledger = tr.ledger_path(a.ledger)
    month = tr.month_key()
    used = tr.ledger_used(ledger, month)
    chars = secs = 0
    english: list[str] = []
    for part, us, plan in plans:
        todo = [j for j in plan.jobs if j.action != "skip"]
        print(f"== {part} ({seasontr.LABELS[part]}): {len(us)} birim, {len(plan.jobs)} parça, "
              f"{sum(j.chars for j in plan.jobs)} karakter; yapılacak {len(todo)} (Alania {plan.billable_chars} karakter)")
        for j in todo:
            print(f"   {j.seg.id}: {j.chars} karakter — {j.reason}: {j.seg.text!r}")
        found = seasontr.english_report(us, {j.seg.id for j in plan.jobs})
        for w, sids in sorted(found.items()):
            print(f"   UYARI sözlükte olmayan İngilizce kelime/ad {w!r}: {', '.join(sids)} "
                  f"(`{seasontr.PRON_KEYS[part]}`)")
        todo_ids = {j.seg.id for j in todo}
        english += [f"{part} {sid}" for sids in found.values() for sid in sids if sid in todo_ids]
        chars += plan.billable_chars
        secs += plan.est_stt_seconds
    print(f"{len(plans)} bölüm, {sum(len(p.jobs) for _, _, p in plans)} parça, "
          f"{sum(j.chars for _, _, p in plans for j in p.jobs)} karakter (yapılacak + güncel)")
    st = billing if billing is not None else tr.billing_status(offline=a.offline,
                                                               needed=tr.work_needed(chars, secs))
    print(f"Toplam Alania: {chars} karakter; Duyu ≈ {secs:.0f} sn (tahmin). Ücret: {tr.cost_text(chars, secs, st)}. "
          f"Bu ay ({month}) kullanılan: {used}; tavan: {cap if cap is not None else 'TANIMLI DEĞİL'}")
    english = list(dict.fromkeys(english))
    if english:
        print(f"Not: {len(english)} parçada sözlükte olmayan İngilizce kelime/ad var; --execute bunları reddeder "
              "(söyleniş sözlüğü ya da --allow-english).")
    if not a.execute:
        print(f"Kuru çalışma: {tr.dry_run_note(st)}. Gerçek üretim için --execute.")
        if cap is None:
            print(f"Not: {tr.ENV_CAP} tanımlı değil; --execute reddedilir.")
        return 0
    if english and not a.allow_english:
        print(f"HATA: {len(english)} parçada sözlükte olmayan İngilizce kelime/ad var ({', '.join(english[:5])}"
              f"{' …' if len(english) > 5 else ''}); Alania Türkçe okur ve sözlük sonra eklenirse ses yeniden "
              "ücretlenir. Söyleniş sözlüğünü yaz ya da --allow-english.", file=sys.stderr)
        return 1
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
    for part, _, plan in plans:
        if not any(j.action != "skip" for j in plan.jobs):
            continue
        try:
            if call is None and any(j.action in ("tts", "stt") for j in plan.jobs):
                call = tr.HttpClient()
            r = tr.execute(plan, call, cap, ledger, seasontr.prompts_path(root, part), **kw)
        except tr.TrTtsError as e:
            print(f"HATA {part}: {e}", file=sys.stderr)
            return 1
        for x in r.done:
            q = x.quality
            print(f"  {part} {x.id}: {x.chars} karakter, {x.duration:.2f} sn, LUFS {x.lufs}, hizalama "
                  f"{q['exact']}+{q['fuzzy']}/{q['words']} (skor {q['score']}){'' if q['ok'] else ' — UYARI'}")
        print(f"== {part}: {len(r.done)} parça kuruldu, {len(r.skipped)} atlandı; Alania {r.tts_calls} çağrı / "
              f"{r.chars} karakter, Duyu {r.stt_calls} çağrı / {r.stt_seconds:.1f} sn")
        warned |= bool(r.warnings)
        if r.stopped:
            return 1
    return 3 if warned and a.strict else 0


if __name__ == "__main__":
    sys.exit(main())
