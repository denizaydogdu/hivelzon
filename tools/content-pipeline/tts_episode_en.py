#!/usr/bin/env python3
"""Bölüm replikleri: İngilizce seslendirme (ElevenLabs zaman damgalı; H-085).

Kaynak: bölümün `audio_manifest.json` dosyası ("KONUŞMACI|metin" → ses kimliği). Hi ve "(TR)" satırları
buraya girmez (Türkçe: tts_episode_tr.py). Konuşmacı → ses eşlemesi `icerik/_evren/sesler.json` →
`episodeEnglish.voices` (B1–B4'te kullanılan sesler). Ayarlar B1–B4 ile aynı: `eleven_v3`, hız 0.9,
stability 0.5, similarity 0.75, `language_code` en, `mp3_44100_128`.

Kullanım:
    P=tools/content-pipeline/.venv/bin/python
    # Kuru çalışma (varsayılan): API çağrılmaz; eksik satırlar, sesler ve karakter sayısı yazılır.
    $P tools/content-pipeline/tts_episode_en.py icerik/A1-005-*

    # Gerçek üretim: tavan ve defter açıkça verilmeli (hesap seçimi kullanıcıda).
    $P tools/content-pipeline/tts_episode_en.py icerik/A1-005-* --execute \\
        --cap 10000 --ledger kitaplar/_maliyet/elevenlabs-hesapN-karakter.json --key-file ~/.config/hivelzon/elevenlabs.env

Kurallar: tavan tanımlı değilse ya da toplam tavanı aşacaksa hiçbir çağrı yapılmaz; sesi ve hizalaması olan
satır atlanır (idempotent); sesi tanımsız konuşmacı varsa (ör. onay bekleyen yeni karakter) çalışma durur.
Her çağrı bölümün PROMPTS.md'sine ve defterine yazılır. Anahtar yalnız --execute ile okunur, hiçbir yere yazılmaz.
Çıktı: audio/<kimlik>.mp3 (git dışı) + audio/<kimlik>.align.json (depoda).
Çıkış kodu: 0 tamam, 1 hata ya da tavan, 2 kullanım hatası.
"""

from __future__ import annotations

import argparse
import base64
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import REPO_ROOT, tts, tts_tr  # noqa: E402
from hvpipeline.book import text_sha256  # noqa: E402
from hvpipeline.tts_episode_tr import VOICE_MAP_FILE, load_en_key  # noqa: E402

ICERIK = REPO_ROOT / "icerik"
PROMPTS_HEADING = "## İngilizce replik seslendirme kayıtları (tts_episode_en.py)"
PROMPTS_TABLE = ("| Tarih (UTC) | Kimlik | Konuşmacı | Ses | Model | Hız | Karakter | Metin sha256 |\n"
                 "|---|---|---|---|---|---|---|---|")


def is_turkish_speaker(speaker: str) -> bool:
    s = speaker.upper()
    return s.startswith("HI") or "(TR)" in s


def collect(ep_dir: Path, voices: dict) -> list[dict]:
    mp = ep_dir / "audio_manifest.json"
    if not mp.exists():
        return []
    rows = []
    for key, stem in json.loads(mp.read_text(encoding="utf-8")).items():
        speaker, _, text = key.partition("|")
        speaker, text = speaker.strip(), text.strip()
        if is_turkish_speaker(speaker):
            continue
        v = voices.get(speaker.upper()) or {}
        done = (ep_dir / "audio" / f"{stem}.mp3").exists() and (ep_dir / "audio" / f"{stem}.align.json").exists()
        rows.append({"episode": ep_dir.name[:6], "dir": ep_dir, "stem": stem, "speaker": speaker, "text": text,
                     "voiceId": v.get("voiceId"), "voiceName": v.get("name"), "status": v.get("status"),
                     "done": done})
    return rows


def append_prompts(path: Path, row: dict) -> None:
    text = path.read_text(encoding="utf-8") if path.exists() else "# PROMPTS\n"
    if PROMPTS_HEADING not in text:
        text = text.rstrip("\n") + f"\n\n{PROMPTS_HEADING}\n\n{PROMPTS_TABLE}\n"
    text = text if text.endswith("\n") else text + "\n"
    text += (f"| {row['date']} | {row['stem']} | {row['speaker']} | {row['voice']} | {row['model']} | "
             f"{row['speed']} | {row['chars']} | {row['sha']} |\n")
    tts_tr._atomic_bytes(path, text.encode("utf-8"))


def main(argv: list[str] | None = None, client=None) -> int:
    ap = argparse.ArgumentParser(description="hiVelzon bölüm replikleri: İngilizce TTS (ElevenLabs)")
    ap.add_argument("episodes", nargs="+", help="bölüm klasörleri (icerik/A1-00x-…)")
    ap.add_argument("--root", default=str(ICERIK), help="içerik kökü (ses haritası)")
    ap.add_argument("--execute", action="store_true", help="gerçek çağrı yap (varsayılan kuru çalışma)")
    ap.add_argument("--cap", type=int, help="aylık karakter tavanı (zorunlu, --execute ile)")
    ap.add_argument("--ledger", help="aylık karakter defteri (depo köküne göre ya da mutlak; zorunlu, --execute ile)")
    ap.add_argument("--key-file", help="ELEVENLABS_API_KEY içeren repo dışı dosya (yoksa ortam)")
    ap.add_argument("--only", action="append", help="yalnız bu kimlik(ler)")
    a = ap.parse_args(argv)

    vm_path = Path(a.root) / VOICE_MAP_FILE
    try:
        vm = json.loads(vm_path.read_text(encoding="utf-8"))
        cfg = vm["episodeEnglish"]
    except (OSError, KeyError, ValueError) as e:
        print(f"HATA: ses haritası okunamadı ({vm_path}: episodeEnglish): {e}", file=sys.stderr)
        return 2
    voices = {k.upper(): v for k, v in cfg["voices"].items()}
    rows = [r for d in a.episodes if Path(d).is_dir() for r in collect(Path(d).resolve(), voices)]
    if a.only:
        rows = [r for r in rows if r["stem"] in a.only]
    todo = [r for r in rows if not r["done"]]
    by_voice: dict[str, list[int]] = {}
    print(f"Ses haritası: {vm_path} · model {cfg['modelId']}, hız {cfg['speed']}")
    for r in rows:
        v = f"{r['voiceName']} ({r['voiceId']})" if r["voiceId"] else f"SES YOK ({r['status'] or 'tanımsız'})"
        mark = "güncel" if r["done"] else f"{len(r['text'])} kar."
        print(f"  {r['episode']} {r['stem']:<14} {r['speaker']:<11} {v:<38} {mark:>8}  {r['text']}")
        if not r["done"]:
            agg = by_voice.setdefault(f"{r['speaker']} → {v}", [0, 0])
            agg[0] += 1
            agg[1] += len(r["text"])
    total = sum(len(r["text"]) for r in todo)
    for k, (n, c) in sorted(by_voice.items()):
        print(f"  · {k}: {n} satır, {c} karakter")
    print(f"Toplam: {len(rows)} İngilizce replik, {len(todo)} eksik, {total} karakter (ElevenLabs, karakter başına 1 kredi).")
    missing_voice = sorted({r["speaker"] for r in todo if not r["voiceId"]})
    if missing_voice:
        print(f"UYARI: sesi tanımsız konuşmacı: {', '.join(missing_voice)} (sesler.json → episodeEnglish.voices)")
    if not a.execute:
        print("Kuru çalışma: API çağrılmadı. Gerçek üretim için --execute --cap N --ledger <defter>.")
        return 0
    if missing_voice:
        print("HATA: sesi tanımsız konuşmacı var; hiçbir çağrı yapılmadı.", file=sys.stderr)
        return 1
    if not a.cap or not a.ledger:
        print("HATA: --cap ve --ledger zorunlu (tavan tanımlı değilse ücretli üretim kapalı).", file=sys.stderr)
        return 1
    ledger = Path(a.ledger) if Path(a.ledger).is_absolute() else REPO_ROOT / a.ledger
    month = tts.month_key()
    used = tts.ledger_used(ledger, month)
    if used + total > a.cap:
        print(f"HATA: tavan aşılır ({used} + {total} > {a.cap}); hiçbir çağrı yapılmadı.", file=sys.stderr)
        return 1
    if todo and client is None:
        if a.key_file:
            load_en_key(Path(a.key_file))
        client = tts.http_client()
    for r in todo:
        resp = client(r["voiceId"], tts.payload(r["text"], cfg["modelId"], float(cfg["speed"])))
        if "audio_base64" not in resp or "alignment" not in resp:
            print(f"HATA: {r['stem']}: yanıtta audio_base64/alignment yok", file=sys.stderr)
            return 1
        # Ödeme yapıldı: önce defter ve kayıt, sonra dosyalar (çift ücret olmasın).
        tts.ledger_add(ledger, month, len(r["text"]))
        append_prompts(r["dir"] / "PROMPTS.md", {
            "date": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"), "stem": r["stem"],
            "speaker": r["speaker"], "voice": f"{r['voiceName']} {r['voiceId']}", "model": cfg["modelId"],
            "speed": cfg["speed"], "chars": len(r["text"]), "sha": text_sha256(r["text"])[:16]})
        out = r["dir"] / "audio"
        tts_tr._atomic_bytes(out / f"{r['stem']}.mp3", base64.b64decode(resp["audio_base64"]))
        doc = {"text": r["text"], "voice_id": r["voiceId"], "lang": "en", "alignment": resp["alignment"]}
        if resp.get("normalized_alignment"):
            doc["normalized_alignment"] = resp["normalized_alignment"]
        tts_tr._atomic_bytes(out / f"{r['stem']}.align.json",
                             (json.dumps(doc, ensure_ascii=False) + "\n").encode("utf-8"))
        print(f"  {r['stem']}: {len(r['text'])} karakter")
    print(f"== {len(todo)} replik seslendirildi, {total} karakter (defter {ledger.name}: {used + total}/{a.cap})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
