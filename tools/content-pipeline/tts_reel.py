#!/usr/bin/env python3
"""Reel sesi (H-094): `reel.json` cue'ları → `_raw/tts/<cue>.mp3` (ElevenLabs, tek anlatıcı).

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_reel.py reeller/A1-R-CIN-01 --dry-run
    ELEVENLABS_API_KEY=... HIVELZON_TTS_MONTHLY_CHAR_CAP=10000 \\
      tools/content-pipeline/.venv/bin/python tools/content-pipeline/tts_reel.py reeller/A1-R-CIN-01 --execute

Kurallar (CLAUDE.md, docs/REEL-PAKETI.md):
- **Tek anlatıcı:** uygulamadaki sesle aynı — Sarah `EXAVITQu4vr4xnSDxMaL`, `eleven_v3`, hız 0.9 (A1/A2).
  (Konuşmacı başına ayrı ses pilot dışı; ayrı karar.)
- **Anahtar** yalnızca çalışma anında ortamdan (`ELEVENLABS_API_KEY`); repoya/loga yazılmaz.
- **Önce kuru çalışma:** karakter sayısı ve tahmini kredi yazılır, API çağrılmaz. Gerçek çağrı `--execute`.
- **Aylık karakter tavanı** ortak defterle (`kitaplar/_maliyet/elevenlabs-karakter.json`) paylaşılır;
  tavan yoksa üretim kapalıdır.
- **İdempotent:** metni/ayarı aynı cue önbellekten gelir (`_raw/tts/_parts/<sha>.mp3`), yeniden ödenmez.
- Karakter ölçümü `_raw/tts/timing.json`'a yazılır (kurgu hizalaması için süreler).

Çıkış kodu: 0 başarı, 1 hata, 2 kullanım hatası.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from hvpipeline import tts as T  # noqa: E402

VOICE = "EXAVITQu4vr4xnSDxMaL"  # Sarah (uygulamayla aynı)
MODEL = "eleven_v3"
SPEED = 0.9
PROMPTS_HEADING = "## Seslendirme kayıtları (tts_reel.py)"
PROMPTS_TABLE = ("| Tarih (UTC) | Reel | Cue | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |\n"
                 "|---|---|---|---|---|---|---|---|---|")


def _sha16(text: str) -> str:
    return T.text_sha256(text)[:16]


def _append_prompts(prompts: Path, row: dict) -> None:
    if not prompts.is_file():
        prompts.write_text("# Reel örnekleri — istem ve üretim kayıtları\n", encoding="utf-8")
    text = prompts.read_text(encoding="utf-8")
    if PROMPTS_HEADING not in text:
        text = text.rstrip("\n") + f"\n\n{PROMPTS_HEADING}\n\n{PROMPTS_TABLE}\n"
    text = text.rstrip("\n") + (f"\n| {row['date']} | {row['reel']} | {row['cue']} | {row['voice']} | "
                               f"{row['model']} | {row['speed']} | {row['chars']} | {row['sha']} | {row['file']} |")
    prompts.write_text(text + "\n", encoding="utf-8")


def _duration(path: Path) -> float:
    out = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration",
                          "-of", "default=nw=1:nk=1", str(path)], capture_output=True, text=True)
    return float(out.stdout.strip())


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="Reel sesi (H-094)")
    ap.add_argument("reel", help="reel klasörü (reeller/A1-R-CIN-01)")
    ap.add_argument("--execute", action="store_true", help="ücretli seslendirmeyi başlat")
    ap.add_argument("--dry-run", action="store_true", help="yalnız karakter sayısı (varsayılan)")
    ap.add_argument("--monthly-char-cap", type=int, default=None, help="aylık karakter tavanı")
    ap.add_argument("--speed", type=float, default=SPEED)
    a = ap.parse_args(argv)

    root = Path(a.reel)
    reel = json.loads((root / "reel.json").read_text(encoding="utf-8"))
    out_dir = root / "_raw" / "tts"
    parts = out_dir / "_parts"
    parts.mkdir(parents=True, exist_ok=True)

    cues = [c for c in reel.get("cues", []) if c.get("text", "").strip()]
    plan: list[dict] = []
    billable = 0
    for c in cues:
        text = c["text"].strip()
        key = T._part_key(text, VOICE, MODEL, a.speed)
        cached = (parts / f"{key}.mp3").is_file()
        plan.append({"cue": c["id"], "text": text, "key": key, "cached": cached, "chars": len(text)})
        if not cached:
            billable += len(text)

    total = sum(p["chars"] for p in plan)
    print(f"{reel['id']}: {len(plan)} cue · toplam {total} karakter · ödenecek {billable} karakter "
          f"(önbellekte {total - billable})")
    print(f"  ses={VOICE} (Sarah) · model={MODEL} · hız={a.speed} · {T.CREDITS_PER_CHAR.get(MODEL, 1.0)} kredi/karakter")
    for p in plan:
        flag = "(önbellek)" if p["cached"] else ""
        print(f"    {p['cue']:8} {p['chars']:3} karakter  {p['text'][:60]} {flag}")
    if not a.execute:
        return 0

    cap = T.monthly_cap(a.monthly_char_cap)
    ledger = T.ledger_path(None)
    month = T.month_key()
    used = T.ledger_used(ledger, month)
    print(f"  tavan: {cap} · bu ay kullanılan: {used} · defter: {ledger}")
    if cap is None:
        print("hata: aylık karakter tavanı yok (HIVELZON_TTS_MONTHLY_CHAR_CAP ya da --monthly-char-cap); "
              "tavan yoksa ücretli üretim kapalıdır", file=sys.stderr)
        return 1
    if used + billable > cap:
        print(f"hata: tavan aşılır ({used} + {billable} > {cap})", file=sys.stderr)
        return 1

    client = T.http_client()
    timing_path = out_dir / "timing.json"
    timing = json.loads(timing_path.read_text(encoding="utf-8")) if timing_path.is_file() else {}
    spent = 0
    for p in plan:
        mp3 = parts / f"{p['key']}.mp3"
        cue_json = out_dir / f"{p['cue']}.json"
        if not mp3.is_file():
            resp = client(VOICE, T.payload(p["text"], MODEL, a.speed))
            if "audio_base64" not in resp:
                print("hata: yanıtta audio_base64 yok", file=sys.stderr)
                return 1
            import base64
            mp3.write_bytes(base64.b64decode(resp["audio_base64"]))
            T.ledger_add(ledger, month, p["chars"])
            spent += p["chars"]
            _append_prompts(Path("reeller/PROMPTS.md"), {
                "date": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"), "reel": reel["id"],
                "cue": p["cue"], "voice": f"Sarah {VOICE}", "model": MODEL, "speed": a.speed,
                "chars": p["chars"], "sha": _sha16(p["text"]), "file": f"_raw/tts/{p['cue']}.mp3"})
            print(f"    {p['cue']}: {p['chars']} karakter üretildi")
        dest = out_dir / f"{p['cue']}.mp3"
        if not dest.is_file():
            subprocess.run(["cp", str(mp3), str(dest)], check=True)
        cue_json.write_text(json.dumps({"cue": p["cue"], "text": p["text"], "sha256": _sha16(p["text"]),
                                        "voice": VOICE, "model": MODEL, "speed": a.speed,
                                        "seconds": round(_duration(dest), 3)},
                                       ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
        timing[p["cue"]] = round(_duration(dest), 3)
    timing_path.write_text(json.dumps(timing, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    print(f"Bu turda harcanan: {spent} karakter · defter güncel: {T.ledger_used(ledger, month)}")
    print("Sıradaki: `build_reel.py <reel> --force` ile sesli sürümü kur.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
