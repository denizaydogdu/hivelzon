#!/usr/bin/env python3
"""Reel hareket klipleri (H-094): `reeller/<id>/clips.json` → `clips/<ad>.mp4`.

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/gen_reel_clips.py reeller/A1-R-SPO-01 --dry-run
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/gen_reel_clips.py reeller/A1-R-SPO-01 --execute

- `clips.json`: `model`, `params`, `clips[]` (`name`, `prompt`, `start` = başlangıç karesi yolu).
- **İdempotent:** `clips/<ad>.mp4` varsa üretilmez (`--force` ile yeniden).
- Ücretli çağrı **yalnız `--execute`** ile ve **her çağrıdan önce** `generate cost` çalıştırılır;
  kayıt `_raw/clip-jobs.json`'a yazılır (job kimliği, kredi, kaynak kare).
- **Ses:** pilotta müzik/ortam sesi yok; `params` içinde `generate_audio: false` verilir.

Çıkış kodu: 0 başarı, 1 üretim hatası, 2 kullanım hatası.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path

CLI = "higgsfield"


def _run(args: list[str]) -> tuple[int, str]:
    p = subprocess.run([CLI, *args], capture_output=True, text=True)
    return p.returncode, p.stdout + p.stderr


def _flags(params: dict) -> list[str]:
    out: list[str] = []
    for k, v in params.items():
        if isinstance(v, bool):
            out += [f"--{k.replace('_', '-')}", "true" if v else "false"]
        else:
            out += [f"--{k.replace('_', '-')}", str(v)]
    return out


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="Reel hareket klipleri (H-094)")
    ap.add_argument("reel")
    ap.add_argument("--execute", action="store_true")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--force", action="store_true")
    a = ap.parse_args(argv)

    root = Path(a.reel)
    spec = json.loads((root / "clips.json").read_text(encoding="utf-8"))
    model, params = spec["model"], spec["params"]
    clips_dir = root / "clips"
    raw = root / "_raw"
    ledger_path = raw / "clip-jobs.json"
    ledger = json.loads(ledger_path.read_text(encoding="utf-8")) if ledger_path.is_file() else []

    print(f"{root.name}: {len(spec['clips'])} klip · {model} {params}")
    total = spent = 0.0
    for clip in spec["clips"]:
        code, out = _run(["generate", "cost", model, "--prompt", clip["prompt"], *_flags(params), "--json"])
        if code != 0:
            print(f"hata: maliyet alınamadı: {out.strip()[:300]}", file=sys.stderr)
            return 1
        credits = float(json.loads(out)["credits"])
        total += credits
        dest = clips_dir / f"{clip['name']}.mp4"
        done = dest.is_file() and not a.force
        print(f"  {clip['name']:10} {credits:5.2f} kr  start={clip['start']:12} {'(var, atlanır)' if done else ''}")
        if not a.execute or done:
            continue
        start = root / clip["start"]
        if not start.is_file():
            print(f"hata: başlangıç karesi yok: {start}", file=sys.stderr)
            return 1
        code, out = _run(["generate", "create", model, "--prompt", clip["prompt"],
                          "--start-image", str(start), *_flags(params),
                          "--wait", "--wait-timeout", "12m", "--json"])
        if code != 0:
            print(f"hata: üretim başarısız: {out.strip()[:300]}", file=sys.stderr)
            return 1
        job = json.loads(out)[0]
        url = job.get("result_url") or job.get("min_result_url")
        dest.parent.mkdir(parents=True, exist_ok=True)
        p = subprocess.run(["curl", "-sL", url, "-o", str(dest)], capture_output=True, text=True)
        if p.returncode != 0 or not dest.is_file() or dest.stat().st_size == 0:
            print(f"hata: indirme başarısız: {url}", file=sys.stderr)
            return 1
        spent += credits
        rec = {"name": clip["name"], "job": job["id"], "created_at": job.get("created_at"),
               "credits": credits, "start": clip["start"], "file": f"clips/{clip['name']}.mp4",
               "sha256": hashlib.sha256(dest.read_bytes()).hexdigest()[:16],
               "prompt_sha256": hashlib.sha256(clip["prompt"].encode()).hexdigest()[:16],
               "model": model, "params": params}
        ledger = [r for r in ledger if r["name"] != clip["name"]] + [rec]
        ledger_path.write_text(json.dumps(ledger, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"       -> {dest}  job={job['id']}  {credits} kr")
    if a.execute:
        print(f"Bu turda harcanan: {spent:.2f} kr (hepsi üretilseydi {total:.2f} kr)")
    else:
        print(f"Toplam: {total:.2f} kr  (kuru çalışma; üretim yok)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
