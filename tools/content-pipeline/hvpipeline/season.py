"""Sezon paketi (H-050): jenerik videoları ve sezon bilgisi.

Kaynak: icerik/_evren/jenerik/season.json + _build/ altındaki videolar (kurgu.py).
Çıktı:  icerik/_evren/_build/season/S<n>/ → season.json, jenerik-tam.mp4, jenerik-kisa.mp4, jenerik-baslik.mp4.
Geliştirme sunucusu bu klasörü /packages/_season/S<n>/ adresinde sunar.

- jenerik-tam.mp4: sezonun ilk açılışında Hikâye sekmesinde bir kez oynar ("Jeneriği izle" ile yeniden).
- jenerik-baslik.mp4: yazısız kısa animasyon; her bölümün başlık ekranının arka planı (title düğümü).
- jenerik-baslik.jpg: başlık arka planının ilk karesi; video ilk karesi gelene dek başlık ekranında görünür
  (bölüm açılışında boş/siyah kare olmaz).
- jenerik-kisa.mp4: yazılı 2 sn kısa sürüm (bilgi için; bölüm başında kullanılmaz).
"""

from __future__ import annotations

import json
import shutil
from dataclasses import dataclass
from pathlib import Path

SEASON_SOURCE = Path("_evren") / "jenerik" / "season.json"
SEASON_BUILD = Path("_evren") / "_build" / "season"
SEASON_PACKAGE_PREFIX = "_season"


@dataclass
class SeasonSource:
    season: int
    title: str
    title_background: str = "jenerik-baslik.mp4"
    title_duration: float = 2.5
    title_poster: str = "jenerik-baslik.jpg"
    intro: str | None = None
    short: str | None = None
    level: str | None = None
    media_dir: Path | None = None   # kaynak videoların klasörü (_build)

    @classmethod
    def load(cls, icerik_root: Path, season: int) -> "SeasonSource":
        """Sezon kaynağı; yoksa (test fikstürleri) varsayılanlar."""
        p = Path(icerik_root) / SEASON_SOURCE
        if p.exists():
            d = json.loads(p.read_text(encoding="utf-8"))
            if int(d.get("season", 0)) == season:
                return cls(season=season, title=d.get("title", f"Sezon {season}"),
                           title_background=d.get("titleBackground", "jenerik-baslik.mp4"),
                           title_duration=float(d.get("titleDuration", 2.5)),
                           title_poster=d.get("titlePoster", "jenerik-baslik.jpg"),
                           intro=d.get("intro"), short=d.get("short"), level=d.get("level"),
                           media_dir=p.parent / "_build")
        return cls(season=season, title=f"Sezon {season}")

    def package_dir(self, icerik_root: Path) -> Path:
        return Path(icerik_root) / SEASON_BUILD / f"S{self.season}"


def title_caption(season: int, number: int) -> str:
    return f"SEZON {season} · BÖLÜM {number}"


def export_season(icerik_root: Path, season: int, probe=None, digest=None, poster=None) -> dict:
    """Sezon paketini kopyalar ve season.json yazar. Video yoksa hata verir (kurgu.py çalıştırılmalı)."""
    src = SeasonSource.load(icerik_root, season)
    if src.media_dir is None:
        raise FileNotFoundError(f"{SEASON_SOURCE} yok (sezon {season})")
    out = src.package_dir(icerik_root)
    out.mkdir(parents=True, exist_ok=True)
    entries = {}
    for key, name in (("intro", src.intro), ("short", src.short), ("titleBackground", src.title_background)):
        if not name:
            continue
        f = src.media_dir / name
        if not f.exists():
            raise FileNotFoundError(f"{f} yok: önce `python3 icerik/_evren/jenerik/kurgu.py` "
                                    f"(başlık arka planı için --baslik-arka) çalıştırılmalı")
        tmp = out / f".{name}.tmp"
        shutil.copyfile(f, tmp)
        tmp.replace(out / name)
        e = {"video": name}
        if probe is not None:
            e["duration"] = round(probe(out / name), 3)
        if key == "titleBackground" and poster is not None and src.title_poster:
            # İlk kare (afiş): önce geçici adla yazılır.
            tmpj = out / f".tmp-{src.title_poster}"
            tmpj.unlink(missing_ok=True)
            poster(out / name, tmpj)
            tmpj.replace(out / src.title_poster)
            e["poster"] = src.title_poster
        entries[key] = e
    doc = {"schemaVersion": 1, "season": season, "title": src.title, "level": src.level,
           "aiLabel": "Yapay zekâ ile üretilmiştir", **entries}
    files = sorted(p for p in out.iterdir() if p.is_file() and p.suffix in (".mp4", ".jpg")
                   and not p.name.startswith("."))
    doc["files"] = [{"path": p.name, "bytes": p.stat().st_size,
                     **({"sha256": digest(p)} if digest else {})} for p in files]
    doc["totalBytes"] = sum(f["bytes"] for f in doc["files"])
    tmp = out / ".season.json.tmp"
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(out / "season.json")
    return {"dir": out, "doc": doc}
