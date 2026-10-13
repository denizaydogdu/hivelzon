"""Sezon paketi (H-050): jenerik videoları ve sezon bilgisi.

Kaynak: icerik/_evren/jenerik/season.json + _build/ altındaki videolar (kurgu.py).
Çıktı:  icerik/_evren/_build/season/S<n>/ → season.json, jenerik-tam.mp4, jenerik-kisa.mp4, jenerik-baslik.mp4.
Geliştirme sunucusu bu klasörü /packages/_season/S<n>/ adresinde sunar.

- jenerik-tam.mp4: sezonun ilk açılışında Hikâye sekmesinde bir kez oynar ("Jeneriği izle" ile yeniden).
- jenerik-baslik.mp4: yazısız kısa animasyon; her bölümün başlık ekranının arka planı (title düğümü).
- jenerik-baslik.webp: başlık arka planının ilk karesi (H-054: WebP, önceden jpg); video ilk karesi gelene dek başlık ekranında görünür
  (bölüm açılışında boş/siyah kare olmaz).
- jenerik-kisa.mp4: yazılı 2 sn kısa sürüm (bilgi için; bölüm başında kullanılmaz).

Sezon haritası (H-035): `_evren/harita/season-<nn>.json` kataloğu varsa season.json'a `episodes`
(12 bölüm: number, contentId, title, teaserTr, teaserStatus, available, mapPos) eklenir. Başlık
bölümün content.json'ından, `available` paketin (`<bölüm>/_build/package/scenes.json`) varlığından
gelir. `_evren/harita/map.jpg` varsa pakete WebP olarak (`map.webp`, H-054) yazılır ve `map` alanı
(image, width, height) eklenir; yoksa uygulama haritayı kodla çizer.

H-054: her jenerik videosunun yanında 720p sürümü (`<ad>.720p.mp4`) bulunur; `renditions` alanı ikisini
listeler. `video` alanı 1080p kalır (eski uygulamalar onu oynatır).

Konu setleri (H-051): `_evren/setler/*.json` varsa `sets/` altına set verisi, sahne ve öğe görselleri
(WebP) ve ses kesitleri yazılır; season.json'a `topicSets` özeti eklenir (bkz. sets.py).
"""

from __future__ import annotations

import json
import shutil
from dataclasses import dataclass
from pathlib import Path

from .sets import export_sets, sets_dir

SEASON_SOURCE = Path("_evren") / "jenerik" / "season.json"
SEASON_BUILD = Path("_evren") / "_build" / "season"
SEASON_PACKAGE_PREFIX = "_season"
MAP_DIR = Path("_evren") / "harita"


@dataclass
class SeasonSource:
    season: int
    title: str
    title_background: str = "jenerik-baslik.mp4"
    title_duration: float = 2.5
    title_poster: str = "jenerik-baslik.webp"
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
                           # Afiş her zaman WebP (H-054); kaynakta eski .jpg adı yazılıysa uzantı değişir.
                           title_poster=Path(d.get("titlePoster", "jenerik-baslik.webp")).with_suffix(".webp").name,
                           intro=d.get("intro"), short=d.get("short"), level=d.get("level"),
                           media_dir=p.parent / "_build")
        return cls(season=season, title=f"Sezon {season}")

    def package_dir(self, icerik_root: Path) -> Path:
        return Path(icerik_root) / SEASON_BUILD / f"S{self.season}"


def title_caption(season: int, number: int) -> str:
    return f"SEZON {season} · BÖLÜM {number}"


def catalogue_path(icerik_root: Path, season: int) -> Path:
    return Path(icerik_root) / MAP_DIR / f"season-{season:02d}.json"


def jpeg_size(path: Path) -> tuple[int, int]:
    """JPEG genişlik ve yüksekliği (SOF işaretinden; dış araç gerekmez)."""
    data = Path(path).read_bytes()
    if data[:2] != b"\xff\xd8":
        raise ValueError(f"{path} JPEG değil")
    i = 2
    while i + 9 < len(data):
        if data[i] != 0xFF:
            i += 1
            continue
        marker = data[i + 1]
        if marker in (0xD8, 0x01) or 0xD0 <= marker <= 0xD7 or marker == 0xFF:
            i += 1 if marker == 0xFF else 2
            continue
        length = int.from_bytes(data[i + 2:i + 4], "big")
        if 0xC0 <= marker <= 0xCF and marker not in (0xC4, 0xC8, 0xCC):
            h = int.from_bytes(data[i + 5:i + 7], "big")
            w = int.from_bytes(data[i + 7:i + 9], "big")
            return w, h
        i += 2 + length
    raise ValueError(f"{path}: boyut bulunamadı")


def build_catalogue(icerik_root: Path, season: int) -> dict | None:
    """Harita kataloğu: kaynak yoksa None. Hatalı kayıtlar ValueError verir."""
    root = Path(icerik_root)
    p = catalogue_path(root, season)
    if not p.exists():
        return None
    d = json.loads(p.read_text(encoding="utf-8"))
    status = d.get("teaserStatus", "DRAFT")
    episodes, seen = [], set()
    for e in d.get("episodes", []):
        n, cid = int(e["number"]), e["contentId"]
        if n in seen:
            raise ValueError(f"{p}: bölüm {n} iki kez")
        seen.add(n)
        x, y = (float(v) for v in e["mapPos"])
        if not (0 <= x <= 1 and 0 <= y <= 1):
            raise ValueError(f"{p}: bölüm {n} mapPos 0–1 dışında")
        teaser = (e.get("teaserTr") or "").strip()
        if not teaser:
            raise ValueError(f"{p}: bölüm {n} teaserTr boş")
        dirs = sorted(q for q in root.glob(f"{cid}-*") if (q / "content.json").exists())
        title = cid
        available = False
        if dirs:
            c = json.loads((dirs[0] / "content.json").read_text(encoding="utf-8"))
            title = c.get("title", cid)
            available = (dirs[0] / "_build" / "package" / "scenes.json").exists()
        episodes.append({"number": n, "contentId": cid, "title": title, "teaserTr": teaser,
                         "teaserStatus": e.get("teaserStatus", status), "available": available,
                         "mapPos": [round(x, 4), round(y, 4)]})
    episodes.sort(key=lambda e: e["number"])
    return {"episodes": episodes, "map": d.get("map")}


def rendition_file(name: str, rendition: str = "720p") -> str:
    """`jenerik-baslik.mp4` → `jenerik-baslik.720p.mp4` (media.rendition_name ile aynı kural)."""
    p = Path(name)
    return f"{p.stem}.{rendition}{p.suffix}"


def export_season(icerik_root: Path, season: int, probe=None, digest=None, poster=None,
                  rendition=None, image=None, set_media: dict | None = None) -> dict:
    """Sezon paketini kopyalar ve season.json yazar. Video yoksa hata verir (kurgu.py çalıştırılmalı).

    rendition(src, out): 720p sürümü üretir (H-054); verilmezse yalnızca 1080p kopyalanır.
    image(src, out): haritayı WebP'ye çevirir (H-054); verilmezse görsel olduğu gibi kopyalanır.
    set_media: konu setlerinin medya adımları (H-051; `sets.export_sets` anahtar sözcükleri: crop, scene,
    cut, gain, probe, size). `_evren/setler/` varsa setler her durumda yazılır; medya adımı verilmezse
    yalnızca JSON üretilir (testler).
    """
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
        if rendition is not None:
            r720 = rendition_file(name)
            tmpr = out / f".tmp-{r720}"
            tmpr.unlink(missing_ok=True)
            rendition(out / name, tmpr)
            tmpr.replace(out / r720)
            e["renditions"] = {"720p": r720, "1080p": name}
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
    cat = build_catalogue(icerik_root, season)
    if cat is not None:
        doc["episodes"] = cat["episodes"]
        name = cat.get("map")
        art = Path(icerik_root) / MAP_DIR / name if name else None
        packed = Path(name).with_suffix(".webp").name if (name and image is not None) else name
        stale = {name, Path(name).with_suffix(".webp").name} if name else set()
        if art is not None and art.exists():
            w, h = jpeg_size(art)
            tmp = out / f".tmp-{packed}"
            tmp.unlink(missing_ok=True)
            if image is not None:
                # Kayıpsız kaynak (map.png) varsa ondan: iki kez kayıplı sıkıştırma olmaz.
                lossless = art.with_suffix(".png")
                image(lossless if lossless.exists() else art, tmp)
            else:
                shutil.copyfile(art, tmp)
            tmp.replace(out / packed)
            doc["map"] = {"image": packed, "width": w, "height": h}
            stale.discard(packed)
        for old in stale:
            (out / old).unlink(missing_ok=True)   # eski kopya kalmasın: uygulama kodla çizer
    if sets_dir(icerik_root).is_dir():
        doc["topicSets"] = export_sets(icerik_root, season, out, **(set_media or {}))
    # Eski biçimler (H-054 öncesi jpg afiş) temizlenir; yalnızca güncel dosyalar listelenir.
    if poster is not None:
        (out / Path(src.title_poster).with_suffix(".jpg").name).unlink(missing_ok=True)
    files = sorted(p for p in out.iterdir() if p.is_file() and p.suffix in (".mp4", ".jpg", ".webp")
                   and not p.name.startswith("."))
    doc["files"] = [{"path": p.name, "bytes": p.stat().st_size,
                     **({"sha256": digest(p)} if digest else {})} for p in files]
    doc["totalBytes"] = sum(f["bytes"] for f in doc["files"])
    if rendition is not None:
        shared = sum(f["bytes"] for f in doc["files"] if not f["path"].endswith(".mp4"))
        r720 = sum(f["bytes"] for f in doc["files"] if f["path"].endswith(".720p.mp4"))
        r1080 = sum(f["bytes"] for f in doc["files"] if f["path"].endswith(".mp4")
                    and not f["path"].endswith(".720p.mp4"))
        doc["renditionBytes"] = {"720p": shared + r720, "1080p": shared + r1080}
    tmp = out / ".season.json.tmp"
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(out / "season.json")
    return {"dir": out, "doc": doc}
