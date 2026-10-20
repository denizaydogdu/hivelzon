#!/usr/bin/env python3
"""Reel kare üretimi (H-094): `reeller/<id>/shots.json` → Higgsfield görselleri.

Kullanım:
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/gen_reel_images.py reeller/A1-R-CIN-01 --dry-run
    tools/content-pipeline/.venv/bin/python tools/content-pipeline/gen_reel_images.py reeller/A1-R-CIN-01 --execute

- `shots.json`: `model`, `params`, `prefix`, `shots[]` (`name`, `prompt`, `ref?`).
- **İdempotent:** `_raw/<name>.png` varsa üretilmez (`--force` ile yeniden).
- Referans: `ref` bir kare adıysa o karenin **job kimliği** `image_references`'a verilir
  (yerel dosya yüklemek yerine); böylece aynı kare ikinci kez yüklenmez.
- Ücretli çağrı **yalnız `--execute`** ile ve **her çağrıdan önce** `generate cost` çalıştırılır;
  kredi `_raw/jobs.json`'a, prompt/kare bilgisi oraya yazılır.
- Kuru çalışma çıktısı: kare başına ve toplam kredi.

Çıkış kodu: 0 başarı, 1 üretim hatası, 2 kullanım hatası.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
import time
from pathlib import Path

CLI = "higgsfield"


def _run(args: list[str]) -> tuple[int, str]:
    proc = subprocess.run([CLI, *args], capture_output=True, text=True)
    return proc.returncode, proc.stdout + proc.stderr


def _cost(model: str, params: dict, prompt: str) -> float:
    args = ["generate", "cost", model, "--prompt", prompt, "--json"]
    for k, v in params.items():
        args += [f"--{k.replace('_', '-')}", str(v)]
    code, out = _run(args)
    if code != 0:
        raise SystemExit(f"maliyet alınamadı: {out.strip()[:400]}")
    return float(json.loads(out)["credits"])


def _create(model: str, params: dict, prompt: str, refs: list[str]) -> dict:
    args = ["generate", "create", model, "--prompt", prompt, "--wait", "--wait-timeout", "8m", "--json"]
    for k, v in params.items():
        args += [f"--{k.replace('_', '-')}", str(v)]
    for r in refs:
        args += ["--image-references", r]
    code, out = _run(args)
    if code != 0:
        raise SystemExit(f"üretim başarısız: {out.strip()[:400]}")
    return json.loads(out)[0]


def _download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    code, out = _run_str(["curl", "-sL", url, "-o", str(dest)])
    if code != 0 or not dest.is_file() or dest.stat().st_size == 0:
        raise SystemExit(f"indirme başarısız: {url} ({out.strip()[:200]})")


def _run_str(args: list[str]) -> tuple[int, str]:
    proc = subprocess.run(args, capture_output=True, text=True)
    return proc.returncode, proc.stdout + proc.stderr


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="Reel kare üretimi (H-094)")
    ap.add_argument("reel", help="reel klasörü (reeller/A1-R-CIN-01)")
    ap.add_argument("--execute", action="store_true", help="ücretli üretimi başlat")
    ap.add_argument("--dry-run", action="store_true", help="yalnız maliyet (varsayılan)")
    ap.add_argument("--force", action="store_true", help="var olan kareyi yeniden üret")
    a = ap.parse_args(argv)

    root = Path(a.reel)
    spec = json.loads((root / "shots.json").read_text(encoding="utf-8"))
    model, params, prefix = spec["model"], spec["params"], spec.get("prefix", "")
    raw = root / "_raw"
    ledger_path = raw / "jobs.json"
    ledger = json.loads(ledger_path.read_text(encoding="utf-8")) if ledger_path.is_file() else []

    jobs_by_name = {r["name"]: r["job"] for r in ledger}

    print(f"{root.name}: {len(spec['shots'])} kare · {model} {params}")
    total = 0.0
    spent = 0.0
    for shot in spec["shots"]:
        full = (shot["prompt"].strip() + " " + prefix.strip()).strip()
        credits = _cost(model, params, full)
        total += credits
        ref = shot.get("ref")
        done = (raw / f"{shot['name']}.png").is_file() and not a.force
        print(f"  {shot['name']:4} {credits:5.2f} kr  ref={ref or '-':6} {'(var, atlanır)' if done else ''}")
        if not a.execute:
            continue
        if done:
            continue
        spent += credits
        refs = [jobs_by_name[ref]] if ref and ref in jobs_by_name else ([str(raw / f'{ref}.png')] if ref else [])
        job = _create(model, params, full, refs)
        dest = raw / f"{shot['name']}.png"
        _download(job["result_url"], dest)
        rec = {
            "name": shot["name"],
            "job": job["id"],
            "created_at": job.get("created_at"),
            "credits": credits,
            "ref": ref,
            "file": f"_raw/{shot['name']}.png",
            "sha256": hashlib.sha256(dest.read_bytes()).hexdigest()[:16],
            "prompt_sha256": hashlib.sha256(full.encode()).hexdigest()[:16],
            "params": params,
            "model": model,
        }
        ledger = [r for r in ledger if r["name"] != shot["name"]] + [rec]
        ledger_path.write_text(json.dumps(ledger, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        jobs_by_name[shot["name"]] = job["id"]
        print(f"       -> {dest}  job={job['id']}  {credits} kr")
        time.sleep(1)
    if a.execute:
        print(f"Bu turda harcanan: {spent:.2f} kr (hepsi üretilseydi {total:.2f} kr)")
    else:
        print(f"Toplam: {total:.2f} kr  (kuru çalışma; üretim yok)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
