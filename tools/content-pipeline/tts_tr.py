#!/usr/bin/env python3
"""Türkçe anlatım: PatientDesk Alania TTS + Duyu kelime zamanları (H-075).

Girdi: kimlikli parça listesi.
  JSON: [{"id": "s01", "text": "…", "instructions"?: "…", "pronunciations"?: [{"term","say_as"}]}]
        ya da {"instructions"?: "…", "segments": [...]}
  Markdown: her parça "## <kimlik>" başlığı ve altındaki metin.

Kullanım:
    # Kuru çalışma (varsayılan): API çağrılmaz; karakter ve tahmini TL yazılır.
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_tr.py ders.md --out-dir dilbilgisi/x/audio

    # Gerçek üretim (aylık tavan şart; ücretli dönemde önce maliyet onayı):
    HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=50000 \\
      tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_tr.py ders.md --out-dir … --execute

Çıktı (--out-dir): <kimlik>.mp3 (-16 LUFS, 44,1 kHz 128 kb/sn), <kimlik>.align.json (ElevenLabs
`alignment` biçimi + kelime listesi + kalite), _raw/<anahtar>.wav ve .duyu.json (ödenmiş önbellek).
Anahtar: PD_API_KEY (ortam) ya da ~/.config/hivelzon/patientdesk.env; yalnız --execute ile okunur.
Çıkış kodu: 0 = tamam, 1 = hata ya da tavan nedeniyle durdu, 2 = kullanım hatası,
3 = tamamlandı ama hizalama uyarısı var (--strict ile).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import tts_tr as tr  # noqa: E402


def main(argv: list[str] | None = None, client=None, finalize=None, sleep=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon Türkçe anlatım (Alania + Duyu)")
    ap.add_argument("segments", help="parça dosyası (.json ya da .md)")
    ap.add_argument("--out-dir", help="çıktı klasörü (varsayılan: parça dosyasının yanında audio/)")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: API çağrılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek çağrı yap")
    ap.add_argument("--only", action="append", help="yalnızca bu parça(lar)")
    ap.add_argument("--force", action="store_true", help="çıktı güncel olsa da yeniden kur (önbellek kullanılır)")
    ap.add_argument("--voice", default=tr.VOICE)
    ap.add_argument("--model", default=tr.TTS_MODEL)
    ap.add_argument("--monthly-char-cap", type=int, help=f"aylık karakter tavanı (yoksa {tr.ENV_CAP})")
    ap.add_argument("--ledger", help=f"aylık kullanım defteri (varsayılan {tr.ENV_LEDGER} ya da {tr.DEFAULT_LEDGER})")
    ap.add_argument("--prompts", help="çağrı kaydı (varsayılan: parça dosyasının yanında PROMPTS.md)")
    ap.add_argument("--strict", action="store_true", help="hizalama uyarısında çıkış kodu 3")
    a = ap.parse_args(argv)

    src = Path(a.segments)
    try:
        segs = tr.load_segments(src)
        cap = tr.monthly_cap(a.monthly_char_cap)
    except (OSError, ValueError, KeyError, tr.TrTtsError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    if a.only:
        segs = [s for s in segs if s.id in a.only]
        if not segs:
            print("HATA: --only hiçbir parçayla eşleşmedi", file=sys.stderr)
            return 2
    out_dir = Path(a.out_dir) if a.out_dir else src.parent / "audio"
    prompts = Path(a.prompts) if a.prompts else src.parent / "PROMPTS.md"
    ledger = tr.ledger_path(a.ledger)
    month = tr.month_key()
    used = tr.ledger_used(ledger, month)
    plan = tr.plan_segments(segs, out_dir, a.voice, a.model, a.force)
    print("\n".join(tr.describe(plan)))
    chars, secs = plan.billable_chars, plan.est_stt_seconds
    print(f"Toplam Alania: {chars} karakter; Duyu ≈ {secs:.0f} sn (tahmin). Tahmini maliyet ≈ "
          f"{tr.estimate_tl(chars, secs):.2f} TL ({tr.TL_PER_1000_CHARS} TL/1000 karakter + "
          f"{tr.TL_PER_AUDIO_HOUR} TL/ses saati; ilk ay ücretsiz). "
          f"Bu ay ({month}) kullanılan: {used}; tavan: {cap if cap is not None else 'TANIMLI DEĞİL'}")
    if not a.execute:
        print("Kuru çalışma: API çağrılmadı. Gerçek üretim için --execute.")
        if cap is None:
            print(f"Not: {tr.ENV_CAP} tanımlı değil; --execute reddedilir.")
        return 0
    if cap is None:
        print(f"HATA: aylık karakter tavanı tanımlı değil ({tr.ENV_CAP}); ücretli üretim kapalı.", file=sys.stderr)
        return 1
    if used + chars > cap:
        print(f"UYARI: toplam {chars} karakter tavanı aşar ({used} + {chars} > {cap}); tavana kadar üretilip durulur.")
    kw = {}
    if finalize is not None:
        kw["finalize"] = finalize
    if sleep is not None:
        kw["sleep"] = sleep
    try:
        call = client or (tr.HttpClient() if any(j.action in ("tts", "stt") for j in plan.jobs) else None)
        r = tr.execute(plan, call, cap, ledger, prompts, **kw)
    except tr.TrTtsError as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 1
    for d in r.done:
        q = d.quality
        print(f"  {d.id}: {d.chars} karakter, {d.duration:.2f} sn, LUFS {d.lufs}, hizalama "
              f"{q['exact']}+{q['fuzzy']}/{q['words']} kelime (skor {q['score']}){'' if q['ok'] else ' — UYARI'}")
    print(f"== {len(r.done)} parça kuruldu, {len(r.skipped)} atlandı; Alania {r.tts_calls} çağrı / {r.chars} "
          f"karakter, Duyu {r.stt_calls} çağrı / {r.stt_seconds:.1f} sn")
    if r.stopped:
        return 1
    if r.warnings and a.strict:
        return 3
    return 0


if __name__ == "__main__":
    sys.exit(main())
