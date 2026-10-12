"""FSRS eşdeğerlik test verisi üretir (H-036, K-04).

Kaynak: py-fsrs (open-spaced-repetition/py-fsrs, MIT), referans uygulama.
Çıktı: mobile/test/fixtures/fsrs_vectors.json — Dart portu (lib/shared/fsrs/)
bu dosyayla test edilir; ileride Java portu (sunucu) da aynı dosyayla test edilir.

Kullanım (ağ gerekir, yalnızca veri yenilenirken):
    uv run --no-project --with 'fsrs==6.3.2' python tools/fsrs-vectors/generate_vectors.py
"""
from __future__ import annotations

import argparse
import importlib.metadata
import json
from datetime import datetime, timedelta, timezone
from pathlib import Path

from fsrs import Card, Rating, Scheduler, State

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "mobile" / "test" / "fixtures" / "fsrs_vectors.json"

R = {"again": Rating.Again, "hard": Rating.Hard, "good": Rating.Good, "easy": Rating.Easy}

# hiVelzon yapılandırması (lib/shared/fsrs/fsrs_config.dart ile aynı olmalı).
APP = {
    "desiredRetention": 0.9,
    "learningStepsSeconds": [600],
    "relearningStepsSeconds": [600],
    "maximumInterval": 36500,
}
PY_DEFAULT = {
    "desiredRetention": 0.9,
    "learningStepsSeconds": [60, 600],
    "relearningStepsSeconds": [600],
    "maximumInterval": 36500,
}


def iso(d: datetime) -> str:
    return d.astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%fZ")


def scheduler(cfg: dict) -> Scheduler:
    return Scheduler(
        desired_retention=cfg["desiredRetention"],
        learning_steps=[timedelta(seconds=s) for s in cfg["learningStepsSeconds"]],
        relearning_steps=[timedelta(seconds=s) for s in cfg["relearningStepsSeconds"]],
        maximum_interval=cfg["maximumInterval"],
        enable_fuzzing=False,
    )


def run(name: str, cfg: dict, start: datetime, steps: list[tuple[str, str]]) -> dict:
    """steps: (rating, when) — when: 'due' | '+<n>s' | '+<n>d' (son incelemeden sonra)."""
    s = scheduler(cfg)
    card = Card(card_id=1, due=start)
    at = start
    out = []
    for rating, when in steps:
        if card.last_review is not None:
            if when == "due":
                at = card.due
            elif when.endswith("s"):
                at = card.last_review + timedelta(seconds=float(when[1:-1]))
            elif when.endswith("d"):
                at = card.last_review + timedelta(days=float(when[1:-1]))
        retr = s.get_card_retrievability(card, current_datetime=at)
        card, _ = s.review_card(card, R[rating], review_datetime=at)
        out.append({
            "rating": rating,
            "reviewAt": iso(at),
            "retrievabilityBefore": retr,
            "expected": {
                "state": card.state.name.lower(),
                "step": card.step,
                "stability": card.stability,
                "difficulty": card.difficulty,
                "due": iso(card.due),
            },
        })
    return {"name": name, "config": cfg, "start": iso(start), "reviews": out}


def lcg_sequence(seed: int, n: int) -> list[tuple[str, str]]:
    """Belirlenimci sözde rastgele dizi (Dart tarafı RNG'yi taklit etmez; dizi dosyada)."""
    x = seed
    names = ["again", "hard", "good", "easy"]
    weights = [2, 2, 5, 1]
    pool = [r for r, w in zip(names, weights) for _ in range(w)]
    whens = ["due", "due", "due", "+120s", "+3d", "+20d"]
    seq = []
    for _ in range(n):
        x = (1103515245 * x + 12345) % (2**31)
        r = pool[x % len(pool)]
        x = (1103515245 * x + 12345) % (2**31)
        w = whens[x % len(whens)]
        seq.append((r, w))
    return seq


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--out", default=str(OUT))
    args = ap.parse_args()
    t0 = datetime(2026, 10, 12, 9, 0, tzinfo=timezone.utc)
    cases = [
        run("py-fsrs test_review_card (varsayılan adımlar)", PY_DEFAULT,
            datetime(2022, 11, 29, 12, 30, tzinfo=timezone.utc),
            [(r, "due") for r in ["good"] * 6 + ["again"] * 2 + ["good"] * 5]),
        run("py-fsrs test_memo_state", PY_DEFAULT,
            datetime(2022, 11, 29, 12, 30, tzinfo=timezone.utc),
            [("again", "+0d"), ("good", "+0d"), ("good", "+1d"), ("good", "+3d"),
             ("good", "+8d"), ("good", "+21d"), ("good", "+0d")]),
        run("app: Bilmiyorum → oturum sonunda doğru → ertesi gün", APP, t0,
            [("again", "due"), ("good", "+180s"), ("good", "due"), ("good", "due")]),
        run("app: oturumda iki kez yanlış", APP, t0,
            [("again", "due"), ("again", "+120s"), ("good", "due"), ("good", "due")]),
        run("app: yeni kart Good → Good → Easy", APP, t0,
            [("good", "due"), ("good", "due"), ("easy", "due"), ("good", "due")]),
        run("app: yeni kart Hard (tek adım ×1,5)", APP, t0,
            [("hard", "due"), ("hard", "+900s"), ("good", "due")]),
        run("app: yeni kart Easy", APP, t0, [("easy", "due"), ("good", "due")]),
        run("app: unutma (lapse) ve yeniden öğrenme", APP, t0,
            [("good", "due"), ("good", "due"), ("good", "due"), ("again", "due"),
             ("good", "+300s"), ("good", "due")]),
        run("app: geç tekrar (30 gün)", APP, t0,
            [("good", "due"), ("good", "due"), ("good", "+30d"), ("hard", "+45d")]),
    ]
    for seed in range(1, 9):
        cases.append(run(f"app: belirlenimci dizi {seed}", APP, t0, lcg_sequence(seed, 14)))
    doc = {
        "description": "FSRS eşdeğerlik verisi (H-036). Dart ve Java portları bu çıktıyı üretmelidir.",
        "source": "py-fsrs (MIT) — https://github.com/open-spaced-repetition/py-fsrs",
        "pyFsrsVersion": importlib.metadata.version("fsrs"),
        "parameters": list(Scheduler().parameters),
        "fuzzing": False,
        "tolerance": {"relative": 1e-9},
        "notes": "Tarih alanları UTC. 'step' öğrenme/yeniden öğrenme adımıdır (review'da null).",
        "cases": cases,
    }
    Path(args.out).write_text(json.dumps(doc, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    n = sum(len(c["reviews"]) for c in cases)
    print(f"{len(cases)} vaka, {n} inceleme → {args.out}")


if __name__ == "__main__":
    main()
