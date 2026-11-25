"""Maliyet defteri kilidi (H-114).

Aynı defteri paylaşan eşzamanlı çalıştırmalar (iki terminal, iki araç) tavan denetimini birlikte geçip
birbirinin defter yazısını ezmesin diye defterin yanındaki `<defter>.lock` dosyasında özel, danışma
niteliğinde `fcntl.flock` kilidi tutulur. Yalnız macOS/Linux.

- Kilit aynı iş parçacığında yeniden girilebilir (iç içe `ledger_add` kilitlenmez).
- Farklı iş parçacıkları ve süreçler birbirini bekler (flock açık dosya tanımına bağlıdır; her giriş
  kendi dosyasını açar).
- Kilit doluysa bir kez "defter kilidi bekleniyor" yazılır (çağıranın `log`u ya da stderr), sonra süresiz
  beklenir.
- Süreç çökerse işletim sistemi kilidi bırakır. `.lock` dosyası silinmez (silmek, bekleyen bir sürecin
  eski dosyayı kilitlemesine yol açar); git dışıdır.
"""

from __future__ import annotations

import fcntl
import os
import sys
import tempfile
import threading
from contextlib import contextmanager
from pathlib import Path
from typing import Callable, Iterator

_held = threading.local()


def lock_path(ledger: Path) -> Path:
    ledger = Path(ledger)
    return ledger.with_name(ledger.name + ".lock")


@contextmanager
def ledger_lock(ledger: Path, log: Callable[[str], None] | None = None) -> Iterator[None]:
    """Defter kilidi: okuma-denetim-yazma (ve ücretli çağrı) bu blok içinde yapılır. PROMPTS.md gibi başka
    paylaşılan dosyalar için de kullanılır (yan dosya `<dosya>.lock`)."""
    key = str(Path(ledger).resolve())
    depth: dict = getattr(_held, "depth", None) or {}
    _held.depth = depth
    if depth.get(key):
        depth[key] += 1
        try:
            yield
        finally:
            depth[key] -= 1
        return
    lp = lock_path(ledger)
    lp.parent.mkdir(parents=True, exist_ok=True)
    fd = os.open(lp, os.O_RDWR | os.O_CREAT, 0o644)
    try:
        try:
            fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            msg = f"defter kilidi bekleniyor: {ledger} (başka bir çalıştırma ücretli çağrı yapıyor)"
            if log is not None:
                log(msg)
            else:
                print(msg, file=sys.stderr, flush=True)
            fcntl.flock(fd, fcntl.LOCK_EX)
        depth[key] = 1
        try:
            yield
        finally:
            depth.pop(key, None)
            fcntl.flock(fd, fcntl.LOCK_UN)
    finally:
        os.close(fd)


def atomic_bytes(path: Path, data: bytes) -> None:
    """Atomik yazma: aynı klasörde benzersiz geçici dosya + `os.replace` (H-114: iki yazıcı aynı `X.tmp`
    adında çakışmaz). Hata olursa geçici dosya silinir."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=f".{path.name}.", suffix=".tmp", dir=path.parent)
    try:
        with os.fdopen(fd, "wb") as f:
            f.write(data)
        os.replace(tmp, path)
    except BaseException:
        try:
            os.unlink(tmp)
        except FileNotFoundError:
            pass
        raise
