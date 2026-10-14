#!/usr/bin/env python3
"""Dilbilgisi dersi seslendirmesi (H-077): Türkçe anlatım (Alania + Duyu) + İngilizce örnekler (ElevenLabs).

Kullanım:
    # Kuru çalışma (varsayılan): API çağrılmaz; parça başına karakter, tahmini TL ve kredi yazılır.
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_lesson.py dilbilgisi/G-A1-03-third-person-s

    # Gerçek üretim (iki tavan da şart; ücretli dönemde önce maliyet onayı):
    HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=50000 HIVELZON_TTS_MONTHLY_CHAR_CAP=10000 ELEVENLABS_API_KEY=... \\
      tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_lesson.py dilbilgisi/G-… --execute

    # Yalnız bir dil ya da kart; ses haritasını ağ çağrısı yapmadan yeniden yaz:
    … tts_lesson.py dilbilgisi/G-… --lang tr --card c02
    … tts_lesson.py dilbilgisi/G-… --manifest-only

Çıktı: audio/tr/<kart>-tr.{mp3,align.json}, audio/en/<örnek>.{mp3,align.json}, audio/lesson-audio.json.
Anahtarlar: PD_API_KEY (ya da ~/.config/hivelzon/patientdesk.env) ve ELEVENLABS_API_KEY; yalnız --execute ile okunur.
Çıkış kodu: 0 = tamam, 1 = hata ya da tavan nedeniyle durdu, 2 = kullanım hatası,
3 = tamamlandı ama Türkçe hizalama uyarısı var (--strict ile).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import lessonaudio as la, tts, tts_tr as tr  # noqa: E402
from hvpipeline.lesson import Lesson, LessonError, english_in_turkish  # noqa: E402


def main(argv: list[str] | None = None, tr_client=None, en_client=None, finalize=None, sleep=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon dilbilgisi dersi seslendirmesi")
    ap.add_argument("lessons", nargs="+")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: API çağrılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek çağrı yap")
    g.add_argument("--manifest-only", action="store_true", help="yalnız audio/lesson-audio.json'u yaz (çağrı yok)")
    ap.add_argument("--lang", action="append", choices=["tr", "en"], help="yalnız bu dil(ler)")
    ap.add_argument("--card", action="append", help="yalnız bu kart(lar) (c01, c02 …)")
    ap.add_argument("--force", action="store_true", help="çıktı güncel olsa da yeniden kur (önbellek kullanılır)")
    ap.add_argument("--tr-cap", type=int, help=f"Türkçe aylık karakter tavanı (yoksa {tr.ENV_CAP})")
    ap.add_argument("--en-cap", type=int, help=f"İngilizce aylık karakter tavanı (yoksa {tts.ENV_CAP})")
    ap.add_argument("--tr-ledger", help=f"Türkçe defter (varsayılan {tr.DEFAULT_LEDGER})")
    ap.add_argument("--en-ledger", help=f"İngilizce defter (varsayılan {tts.DEFAULT_LEDGER})")
    ap.add_argument("--strict", action="store_true", help="Türkçe hizalama uyarısında çıkış kodu 3")
    a = ap.parse_args(argv)
    langs = tuple(a.lang or ("tr", "en"))

    try:
        tr_cap = tr.monthly_cap(a.tr_cap)
        en_cap = tts.monthly_cap(a.en_cap)
    except (tr.TrTtsError, tts.TtsError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    dirs = [Path(p) for p in a.lessons if Path(p).is_dir() and not Path(p).name.startswith("_")]
    if not dirs:
        print("Ders klasörü bulunamadı.", file=sys.stderr)
        return 2
    plans: list[la.LessonAudioPlan] = []
    for d in dirs:
        try:
            lesson = Lesson.load(d)
            if a.manifest_only:
                print(f"== {lesson.id}: ses haritası → {la.write_manifest(lesson)}")
                continue
            plans.append(la.plan_lesson(lesson, langs, a.card, a.force))
        except (LessonError, tts.TtsError, tr.TrTtsError) as e:
            print(f"== {d.name}: HATA {e}", file=sys.stderr)
            return 2
    if a.manifest_only:
        return 0

    tr_ledger, en_ledger = tr.ledger_path(a.tr_ledger), tts.ledger_path(a.en_ledger)
    month = tr.month_key()
    tr_used, en_used = tr.ledger_used(tr_ledger, month), tts.ledger_used(en_ledger, month)
    tr_chars = sum(p.tr.billable_chars for p in plans)
    tr_secs = sum(p.tr.est_stt_seconds for p in plans)
    en_chars = sum(p.en.billable_chars for p in plans)
    en_credits = sum(p.en.credits() for p in plans)
    for p in plans:
        print("\n".join(la.describe(p)))
        for c in p.lesson.cards:
            if c.paragraphs and (en := english_in_turkish(c.narration, p.lesson.pronunciations)):
                print(f"  UYARI {c.tr_segment_id}: Türkçe anlatımda İngilizce kelime ya da ek: {', '.join(en)} "
                      "(Alania Türkçe okur; grammar_lint.py)")
    print(f"Türkçe (Alania): {tr_chars} karakter; Duyu ≈ {tr_secs:.0f} sn. Tahmini ≈ {tr.estimate_tl(tr_chars, tr_secs):.2f} TL "
          f"(kampanya döneminde ücretsiz). Bu ay ({month}) kullanılan: {tr_used}; tavan: "
          f"{tr_cap if tr_cap is not None else 'TANIMLI DEĞİL'}")
    print(f"İngilizce (ElevenLabs): {en_chars} karakter ≈ {en_credits:.0f} kredi (tahmin). Bu ay kullanılan: {en_used}; "
          f"tavan: {en_cap if en_cap is not None else 'TANIMLI DEĞİL'}")
    if not a.execute:
        print("Kuru çalışma: API çağrılmadı. Gerçek üretim için maliyet onayından sonra --execute.")
        for name, cap in ((tr.ENV_CAP, tr_cap), (tts.ENV_CAP, en_cap)):
            if cap is None:
                print(f"Not: {name} tanımlı değil; --execute reddedilir.")
        return 0

    need_tr = any(j.action != "skip" for p in plans for j in p.tr.jobs)
    need_en = any(j.action == "tts" for p in plans for j in p.en.jobs)
    missing = [n for n, need, cap in ((tr.ENV_CAP, need_tr, tr_cap), (tts.ENV_CAP, need_en, en_cap))
               if need and cap is None]
    if missing:
        print(f"HATA: aylık karakter tavanı tanımlı değil ({', '.join(missing)}); ücretli üretim kapalı.", file=sys.stderr)
        return 1
    kw = {}
    if finalize is not None:
        kw["finalize"] = finalize
    if sleep is not None:
        kw["sleep"] = sleep
    failed = warned = False
    try:
        for p in plans:
            prompts = la.prompts_path(p.lesson)
            if any(j.action != "skip" for j in p.tr.jobs):
                call = tr_client or (tr.HttpClient() if any(j.action in ("tts", "stt") for j in p.tr.jobs) else None)
                r = tr.execute(p.tr, call, tr_cap, tr_ledger, prompts, **kw)
                for d in r.done:
                    q = d.quality
                    print(f"  {d.id}: {d.chars} karakter, {d.duration:.2f} sn, LUFS {d.lufs}, hizalama "
                          f"{q['exact']}+{q['fuzzy']}/{q['words']} (skor {q['score']}){'' if q['ok'] else ' — UYARI'}")
                warned |= bool(r.warnings)
                print(f"== {p.lesson.id} TR: {len(r.done)} kuruldu, {len(r.skipped)} atlandı; Alania {r.tts_calls} çağrı / "
                      f"{r.chars} karakter, Duyu {r.stt_calls} çağrı")
                if r.stopped:
                    failed = True
            if not failed and p.en.jobs:
                call = en_client or (tts.http_client() if any(j.action == "tts" for j in p.en.jobs) else None)
                r2 = la.execute_en(p.en, call, en_cap, en_ledger, prompts)
                print(f"== {p.lesson.id} EN: {len(r2.generated)} kuruldu, {len(r2.skipped)} atlandı; "
                      f"{r2.calls} çağrı / {r2.chars} karakter")
                if r2.stopped:
                    failed = True
            print(f"   ses haritası → {la.write_manifest(p.lesson)}")
            if failed:
                break
    except (tr.TrTtsError, tts.TtsError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 1
    if failed:
        return 1
    if warned and a.strict:
        return 3
    return 0


if __name__ == "__main__":
    sys.exit(main())
