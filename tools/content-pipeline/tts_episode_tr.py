#!/usr/bin/env python3
"""Bölümlerdeki ve Hi verisindeki Türkçe sesler: PatientDesk Alania + Duyu (H-083).

Kullanıcı kararı (2026-10-14): "Uygulamadaki Türkçe konuşan her yer Alania ile." Roller ve sesler:
icerik/_evren/sesler.json. Toplanan yerler ve kipler: hvpipeline/tts_episode_tr.py.

Kullanım:
    P=tools/content-pipeline/.venv/bin/python
    # Kuru çalışma (varsayılan): API çağrılmaz; her ses, kip, karakter (Türkçe/İngilizce) yazılır.
    $P tools/content-pipeline/tts_episode_tr.py icerik/A1-00[1-4]-* --hi

    # Gerçek üretim (iki tavan da tanımlı olmalı):
    HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=500000 \\
      $P tools/content-pipeline/tts_episode_tr.py icerik/A1-00[1-4]-* --hi --execute

    # Karışık dil karşılaştırması (a: tümü Alania + söyleniş sözlüğü, b: Alania + Sarah):
    $P tools/content-pipeline/tts_episode_tr.py icerik/A1-002-* --only b2_17_hi --compare-dir .yerel/h083 --execute

Çıktı: bölümde audio/<ad>.mp3 + audio/<ad>.align.json; Hi verisinde icerik/_evren/hi-ses/<ad>.{mp3,align.json}.
Ödenmiş ham önbellek: audio/_raw/ (git dışı). Eski ElevenLabs Türkçe sesleri audio/_raw/elevenlabs/ altına
kopyalanır. Sesi hazır olup kaynağında başvurusu olmayan yerlere `audio` eklenir (kurgu.json el biçimi korunur).
Anahtarlar: PD_API_KEY (ortam ya da ~/.config/hivelzon/patientdesk.env), ELEVENLABS_API_KEY (ortam ya da
sesler.json english.keyFile); yalnız --execute ile ve yalnız iş varsa okunur, hiçbir yere yazılmaz.
Çıkış kodu: 0 tamam, 1 hata ya da tavan, 2 kullanım hatası, 3 hizalama uyarısı (--strict).
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import tts, tts_tr as tr  # noqa: E402
from hvpipeline import tts_episode_tr as ep  # noqa: E402

ICERIK = Path(__file__).resolve().parents[2] / "icerik"


def main(argv: list[str] | None = None, tr_client=None, en_client=None, finalize=None, sleep=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon Türkçe sesler (Alania + Duyu; İngilizce ifadeler Sarah)")
    ap.add_argument("episodes", nargs="*", help="bölüm klasörleri (icerik/A1-00x-…)")
    ap.add_argument("--hi", action="store_true", help="Hi verisini de seslendir (hata notu, konu tanıtımı, köprü görevi)")
    ap.add_argument("--root", default=str(ICERIK), help="içerik kökü (ses haritası ve Hi verisi)")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true", default=True, help="varsayılan: API çağrılmaz")
    g.add_argument("--execute", action="store_true", help="gerçek çağrı yap")
    ap.add_argument("--only", action="append", help="yalnız bu ses(ler) (ad, ör. hi_01, tr_c-oq, note-articles)")
    ap.add_argument("--force", action="store_true", help="güncel olsa da yeniden kur (önbellek kullanılır)")
    ap.add_argument("--tr-cap", type=int, help=f"Türkçe aylık karakter tavanı (yoksa {tr.ENV_CAP})")
    ap.add_argument("--en-cap", type=int, help="İngilizce aylık karakter tavanı (yoksa sesler.json english.monthlyCharCap)")
    ap.add_argument("--compare-dir", help="karışık dil satırlarının a ve b sürümlerini bu klasöre de yaz")
    ap.add_argument("--no-update", action="store_true", help="kurgu.json ve Hi verisine audio ekleme")
    ap.add_argument("--strict", action="store_true", help="hizalama uyarısında çıkış kodu 3")
    a = ap.parse_args(argv)
    if not a.episodes and not a.hi:
        ap.error("bölüm klasörü ya da --hi gerekli")

    root = Path(a.root)
    try:
        vm = ep.VoiceMap.load(root)
        items: list[ep.Item] = []
        for d in a.episodes:
            items += ep.collect_episode(Path(d), vm)
        if a.hi:
            items += ep.collect_hi(root, vm)
        if a.only:
            items = [it for it in items if it.stem in a.only]
            if not items:
                print("HATA: --only hiçbir sesle eşleşmedi", file=sys.stderr)
                return 2
        plans = [ep.plan_item(it, vm, a.force, compare=bool(a.compare_dir) and it.mode != "tr") for it in items]
        tr_cap = tr.monthly_cap(a.tr_cap)
    except (OSError, ValueError, KeyError, ep.EpisodeTtsError, tr.TrTtsError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 2
    en_cap = a.en_cap if a.en_cap is not None else vm.en.get("monthlyCharCap")
    tr_ledger, en_ledger = tr.ledger_path(), ep.en_ledger(vm)
    month = tr.month_key()

    print(f"Ses haritası: {vm.path}")
    print("\n".join(ep.describe(plans, vm)))
    t = ep.totals(plans)
    tr_used, en_used = tr.ledger_used(tr_ledger, month), tts.ledger_used(en_ledger, month)
    print(f"Toplam: {len(plans)} ses ({sum(1 for p in plans if p.action == 'skip')} güncel); Türkçe {t.tr_all} karakter, "
          f"İngilizce {t.en_all} karakter.")
    print(f"Ödenecek: Alania {t.tr_chars} karakter (bu ay {tr_used}; tavan {tr_cap if tr_cap else 'TANIMLI DEĞİL'}; "
          f"≈ {tr.estimate_tl(t.tr_chars, t.tr_chars / tr.EST_CHARS_PER_SEC):.2f} TL, PatientDesk kampanyasında ücretsiz) · "
          f"ElevenLabs {vm.en['name']} {t.en_chars} karakter (bu ay {en_used}; tavan {en_cap if en_cap else 'TANIMLI DEĞİL'}; "
          f"defter {en_ledger.name})")
    if not a.execute:
        print("Kuru çalışma: API çağrılmadı. Gerçek üretim için --execute.")
        return 0
    if t.tr_chars and tr_cap is None:
        print(f"HATA: Türkçe aylık tavan tanımlı değil ({tr.ENV_CAP}); ücretli üretim kapalı.", file=sys.stderr)
        return 1
    if t.en_chars and not en_cap:
        print("HATA: İngilizce aylık tavan tanımlı değil; ücretli üretim kapalı.", file=sys.stderr)
        return 1
    if t.en_chars and en_used + t.en_chars > en_cap:
        print(f"HATA: İngilizce tavan aşılır ({en_used} + {t.en_chars} > {en_cap}); hiçbir çağrı yapılmadı.",
              file=sys.stderr)
        return 1

    work = [p for p in plans if p.action != "skip"]
    try:
        for p in work:
            ep.backup_old(p.item)
        tr_pieces = [tp for p in work for tp in p.tr] + [p.compare_a for p in plans if p.compare_a]
        need_tr = any(not tp.raw_wav().exists() for tp in tr_pieces)
        call = tr_client or (tr.HttpClient() if need_tr else None)
        tr_chars, tr_calls, warns = ep.run_tr(tr_pieces, call, tr_cap, tr_ledger, finalize=finalize, sleep=sleep)
        en_pieces = [e for p in work for e in p.en]
        en_chars = en_calls = 0
        if en_pieces:
            need_en = any(not e.raw_mp3().exists() for e in en_pieces)
            if need_en and en_client is None:
                ep.load_en_key(Path(vm.en["keyFile"]))
            ecall = en_client or (tts.http_client() if need_en else None)
            en_chars, en_calls = ep.run_en(en_pieces, vm.en, ecall, en_cap, en_ledger)
        for p in work:
            if p.item.mode == "b":
                doc = ep.build_mixed(p, vm, finalize=finalize)
                q = doc["quality"]
                print(f"  {p.item.stem}: b kipi {len(doc['parts'])} parça, {doc['duration']} sn, LUFS {doc['loudnessLufs']}, "
                      f"Türkçe hizalama {q['exact']}+{q['fuzzy']}/{q['words']} (skor {q['score']})"
                      f"{'' if q['ok'] else ' — UYARI'}")
                if not q["ok"]:
                    warns += [f"{p.item.stem}: {w}" for w in q["warnings"]]
                    warns = [w for w in warns if not w.startswith(f"UYARI {p.item.stem}.p")]
            else:
                ep.write_item_tr(p, vm)
        if a.compare_dir:
            out = Path(a.compare_dir)
            out.mkdir(parents=True, exist_ok=True)
            for p in plans:
                if not p.compare_a:
                    continue
                if p.item.mode != "b" or not p.item.audio().exists():
                    continue
                va = p.compare_a.out_dir
                shutil.copy2(va / f"{p.item.stem}.mp3", out / f"{p.item.stem}-a-alania-soylenis.mp3")
                shutil.copy2(va / f"{p.item.stem}.align.json", out / f"{p.item.stem}-a-alania-soylenis.align.json")
                shutil.copy2(p.item.audio(), out / f"{p.item.stem}-b-alania-sarah.mp3")
                shutil.copy2(p.item.align(), out / f"{p.item.stem}-b-alania-sarah.align.json")
                print(f"  karşılaştırma: {out / (p.item.stem + '-a-alania-soylenis.mp3')} · "
                      f"{out / (p.item.stem + '-b-alania-sarah.mp3')}")
        if not a.no_update:
            changed = ep.update_sources(items, vm)
            if changed:
                print("Güncellenen kaynaklar: " + ", ".join(changed))
    except (ep.EpisodeTtsError, tr.TrTtsError, tts.TtsError) as e:
        print(f"HATA: {e}", file=sys.stderr)
        return 1
    print(f"== {len(work)} ses kuruldu, {len(plans) - len(work)} güncel; Alania {tr_calls} çağrı / {tr_chars} karakter, "
          f"ElevenLabs {en_calls} çağrı / {en_chars} karakter")
    for w in warns:
        print(f"UYARI {w}")
    if warns and a.strict:
        return 3
    return 0


if __name__ == "__main__":
    sys.exit(main())
