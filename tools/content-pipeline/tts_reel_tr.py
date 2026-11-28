#!/usr/bin/env python3
"""Keşfet reel alıştırmasının Türkçe sesi (H-109 Faz 1): PatientDesk Alania + Duyu, reel başına en çok iki parça
(`practice-prompt`: soru + Türkçe seçenekler, `practice-explain`: cevap açıklaması). H-109 Faz 3: `--part subtitles`
ile altyazı satırlarının Türkçesi (`sub-<satır>`; anlam panelindeki "Türkçesini dinle"). Ayrıntı: hvpipeline/reeltr.py.

Kullanım:
    P=tools/content-pipeline/.venv/bin/python
    # Kuru çalışma (varsayılan): üretim çağrısı yapılmaz; parça, karakter, tahmini TL ve PatientDesk ücret
    # durumu (yalnız okuma: GET /v1/usage; --offline ile o da yok) yazılır.
    $P tools/content-pipeline/tts_reel_tr.py reeller/A1-R-* reeller/A2-R-* --offline

    # H-109 Faz 3: altyazı Türkçesi (varsayılan bölüm `practice`; ikisi birden için --part iki kez):
    $P tools/content-pipeline/tts_reel_tr.py reeller/*-R-* --part subtitles --offline

    # Gerçek üretim (aylık tavan şart; kaldığı yerden sürer, güncel parçalar atlanır):
    HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=… $P tools/content-pipeline/tts_reel_tr.py reeller/A1-R-* --execute

    # Kurulmuş pakete (_build/package) sesleri ekle (ücretsiz, yerel ffmpeg; video yeniden kurulmaz):
    $P tools/content-pipeline/tts_reel_tr.py reeller/A1-R-* --package

Çıktı: `<reel>/audio/tr/<parça>.mp3` (git dışı, -16 LUFS), `<parça>.align.json` (depoda), `_raw/` (ödenmiş
önbellek, git dışı). Her gerçek çağrı `<reel>/PROMPTS.md`'ye ve aylık deftere yazılır. Anahtar PD_API_KEY
(ortam) ya da ~/.config/hivelzon/patientdesk.env; --execute ile ve kuru çalışmada ücret durumu için okunur
(--offline ile okunmaz), yazdırılmaz.
Çıkış kodu: 0 = tamam, 1 = hata ya da tavan nedeniyle durdu, 2 = kullanım hatası,
3 = tamamlandı ama hizalama uyarısı var (--strict ile).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import reeltr  # noqa: E402
from hvpipeline import tts_tr as tr  # noqa: E402


def main(argv: list[str] | None = None, client=None, finalize=None, sleep=None, billing=None, media=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon reel alıştırmasının Türkçesi (Alania + Duyu)")
    ap.add_argument("reels", nargs="+")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: üretim çağrısı yapılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek çağrı yap")
    g.add_argument("--package", action="store_true", help="kurulmuş pakete Türkçe sesleri ekle (çağrı yok)")
    ap.add_argument("--segment", action="append",
                    help=f"yalnız bu parça(lar) ({reeltr.PROMPT_ID}, {reeltr.EXPLAIN_ID}, {reeltr.SUB_PREFIX}<satır>)")
    ap.add_argument("--part", action="append", choices=reeltr.PARTS,
                    help="bölüm(ler): practice (varsayılan), subtitles (H-109 Faz 3: altyazı Türkçesi)")
    ap.add_argument("--allow-english", action="store_true",
                    help="altyazı Türkçesinde sözlükte olmayan İngilizce kelime/ad olsa da üret (varsayılan: --execute "
                         "reddeder; sözlük sonra eklenirse ses yeniden ücretlenir)")
    ap.add_argument("--force", action="store_true", help="çıktı güncel olsa da yeniden kur (önbellek kullanılır)")
    ap.add_argument("--monthly-char-cap", type=int, help=f"aylık karakter tavanı (yoksa {tr.ENV_CAP})")
    ap.add_argument("--ledger", help=f"aylık kullanım defteri (varsayılan {tr.ENV_LEDGER} ya da {tr.DEFAULT_LEDGER})")
    ap.add_argument("--voice-map", help="ses haritası (varsayılan icerik/_evren/sesler.json)")
    ap.add_argument("--strict", action="store_true", help="hizalama uyarısında çıkış kodu 3")
    ap.add_argument("--offline", action="store_true",
                    help=f"ücret durumunu PatientDesk'ten okuma (ya da {tr.ENV_OFFLINE}=1); ücretli varsayılır")
    a = ap.parse_args(argv)
    parts = tuple(dict.fromkeys(a.part or reeltr.DEFAULT_PARTS))

    dirs = sorted(Path(p) for p in a.reels if (Path(p) / "reel.json").is_file() and not Path(p).name.startswith("_"))
    if not dirs:
        print("Reel klasörü bulunamadı.", file=sys.stderr)
        return 2
    vm = Path(a.voice_map) if a.voice_map else None
    if a.package:
        rc = 0
        for d in dirs:
            try:
                r = reeltr.package_tr(d, media, vm)
            except (reeltr.ReelTrError, tr.TrTtsError, OSError, KeyError, ValueError) as e:
                print(f"HATA {d.name}: {e}", file=sys.stderr)
                rc = 1
                continue
            print(f"== {r.reel_id}: pakette {len(r.packaged)} Türkçe ses"
                  + (f" ({', '.join(r.packaged)})" if r.packaged else ""))
            for x in r.missing:
                print(f"   - UYARI {x['segment']}: {x['reason']} ({x['path']})")
        return rc
    try:
        cap = tr.monthly_cap(a.monthly_char_cap)
        plans = [(d, reeltr.plan_reel(d, vm, a.segment, a.force, parts=parts)) for d in dirs]
    except (reeltr.ReelTrError, tr.TrTtsError, OSError, KeyError, ValueError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    if a.segment and not any(p.jobs for _, p in plans):
        print("HATA: --segment hiçbir parçayla eşleşmedi", file=sys.stderr)
        return 2
    ledger = tr.ledger_path(a.ledger)
    month = tr.month_key()
    used = tr.ledger_used(ledger, month)
    chars = secs = 0
    english: list[str] = []
    for d, plan in plans:
        todo = [j for j in plan.jobs if j.action != "skip"]
        print(f"== {d.name}: {len(plan.jobs)} parça, {sum(j.chars for j in plan.jobs)} karakter; "
              f"yapılacak {len(todo)} (Alania {plan.billable_chars} karakter)")
        for j in todo:
            print(f"   {j.seg.id}: {j.chars} karakter — {j.reason}: {j.seg.text!r}")
        if "subtitles" in parts:
            found = reeltr.english_in_subtitles(reeltr.source_doc(d), [j.seg for j in plan.jobs])
            for w, sids in sorted(found.items()):
                print(f"   UYARI sözlükte olmayan İngilizce kelime/ad {w!r}: {', '.join(sids)} "
                      "(reel.json → narrationTr.translationPronunciations)")
            todo_ids = {j.seg.id for j in todo}
            english += [f"{d.name} {sid}" for sids in found.values() for sid in sids if sid in todo_ids]
        chars += plan.billable_chars
        secs += plan.est_stt_seconds
    print(f"{len(plans)} reel, {sum(len(p.jobs) for _, p in plans)} parça, "
          f"{sum(j.chars for _, p in plans for j in p.jobs)} karakter (yapılacak + güncel)")
    st = billing if billing is not None else tr.billing_status(offline=a.offline,
                                                               needed=tr.work_needed(chars, secs))
    print(f"Toplam Alania: {chars} karakter; Duyu ≈ {secs:.0f} sn (tahmin). Ücret: {tr.cost_text(chars, secs, st)}. "
          f"Bu ay ({month}) kullanılan: {used}; "
          f"tavan: {cap if cap is not None else 'TANIMLI DEĞİL'}")
    english = list(dict.fromkeys(english))
    if english:
        print(f"Not: {len(english)} altyazı çevirisinde sözlükte olmayan İngilizce kelime/ad var; --execute bunları "
              "reddeder (narrationTr.translationPronunciations ya da --allow-english).")
    if not a.execute:
        print(f"Kuru çalışma: {tr.dry_run_note(st)}. Gerçek üretim için --execute.")
        if cap is None:
            print(f"Not: {tr.ENV_CAP} tanımlı değil; --execute reddedilir.")
        return 0
    if english and not a.allow_english:
        print(f"HATA: {len(english)} altyazı çevirisinde sözlükte olmayan İngilizce kelime/ad var "
              f"({', '.join(english[:5])}{' …' if len(english) > 5 else ''}); Alania Türkçe okur ve sözlük sonra "
              "eklenirse ses yeniden ücretlenir. reel.json → narrationTr.translationPronunciations yaz ya da "
              "--allow-english.", file=sys.stderr)
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
    for d, plan in plans:
        if not any(j.action != "skip" for j in plan.jobs):
            continue
        try:
            if call is None and any(j.action in ("tts", "stt") for j in plan.jobs):
                call = tr.HttpClient()
            r = tr.execute(plan, call, cap, ledger, reeltr.prompts_path(d), **kw)
        except tr.TrTtsError as e:
            print(f"HATA {d.name}: {e}", file=sys.stderr)
            return 1
        for x in r.done:
            q = x.quality
            print(f"  {d.name} {x.id}: {x.chars} karakter, {x.duration:.2f} sn, LUFS {x.lufs}, hizalama "
                  f"{q['exact']}+{q['fuzzy']}/{q['words']} (skor {q['score']}){'' if q['ok'] else ' — UYARI'}")
        print(f"== {d.name}: {len(r.done)} parça kuruldu, {len(r.skipped)} atlandı; Alania {r.tts_calls} çağrı / "
              f"{r.chars} karakter, Duyu {r.stt_calls} çağrı / {r.stt_seconds:.1f} sn")
        warned |= bool(r.warnings)
        if r.stopped:
            return 1
    return 3 if warned and a.strict else 0


if __name__ == "__main__":
    sys.exit(main())
