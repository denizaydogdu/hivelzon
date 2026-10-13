"""H-054: 720p video sürümü ve WebP görseller."""
import json
import shutil
import subprocess
from pathlib import Path

import pytest

from hvpipeline import media
from hvpipeline.build import build_dry, renditions_for
from hvpipeline.export import rendition_bytes
from hvpipeline.graph import schema_errors
from hvpipeline.season import export_season, rendition_file

FX = Path(__file__).parent / "fixtures"
HAS_FFMPEG = shutil.which("ffmpeg") is not None and shutil.which("ffprobe") is not None
HAS_MAGICK = shutil.which("magick") is not None


def test_rendition_names():
    assert media.rendition_name("segments/s02.mp4") == "segments/s02.720p.mp4"
    assert media.rendition_name("segments/k1-ok.mp4", "1080p") == "segments/k1-ok.1080p.mp4"
    assert rendition_file("jenerik-baslik.mp4") == "jenerik-baslik.720p.mp4"
    assert renditions_for("segments/s01.mp4") == {"720p": "segments/s01.720p.mp4", "1080p": "segments/s01.mp4"}


def test_every_video_node_lists_both_renditions_and_stills_are_webp():
    doc, _ = build_dry(FX / "ep-good")
    assert schema_errors(doc) == []
    videos = [n for n in doc["nodes"] if n.get("video")]
    assert videos
    for n in videos:
        assert n["renditions"]["1080p"] == n["video"]
        assert n["renditions"]["720p"] == media.rendition_name(n["video"])
    for n in doc["nodes"]:
        if n.get("background"):
            assert n["background"].endswith(".webp")


def test_schema_rejects_bad_rendition_and_accepts_legacy_jpg():
    doc, _ = build_dry(FX / "ep-good")
    seg = next(n for n in doc["nodes"] if n["type"] == "segment")
    seg["renditions"] = {"720p": "segments/s01.720p.mp4"}  # 1080p eksik
    assert schema_errors(doc)
    seg.pop("renditions")                                   # eski paket: renditions yok → geçerli
    seg["poster"] = "stills/old.jpg"
    assert schema_errors(doc) == []


def test_rendition_bytes_counts_shared_files_once_per_rendition():
    files = [{"path": "scenes.json", "bytes": 10}, {"path": "stills/a.webp", "bytes": 20},
             {"path": "segments/s01.mp4", "bytes": 1000}, {"path": "segments/s01.720p.mp4", "bytes": 300}]
    assert rendition_bytes(files) == {"720p": 330, "1080p": 1030}


def test_season_export_with_renditions_and_webp_map(tmp_path):
    src = tmp_path / "_evren" / "jenerik"
    (src / "_build").mkdir(parents=True)
    (src / "season.json").write_text(json.dumps({
        "season": 1, "title": "S", "intro": "jenerik-tam.mp4", "titleBackground": "jenerik-baslik.mp4",
        "titlePoster": "jenerik-baslik.jpg"}), encoding="utf-8")
    for name in ("jenerik-tam.mp4", "jenerik-baslik.mp4"):
        (src / "_build" / name).write_bytes(b"x" * 100)
    harita = tmp_path / "_evren" / "harita"
    harita.mkdir(parents=True)
    (harita / "season-01.json").write_text(json.dumps({"season": 1, "map": "map.jpg", "episodes": []}),
                                           encoding="utf-8")
    from tests.test_translation import _tiny_jpeg
    (harita / "map.jpg").write_bytes(_tiny_jpeg(1520, 2688))
    out = tmp_path / "_evren" / "_build" / "season" / "S1"
    out.mkdir(parents=True)
    (out / "jenerik-baslik.jpg").write_bytes(b"old")   # H-054 öncesi afiş: temizlenmeli
    (out / "map.jpg").write_bytes(b"old")
    seen = []

    def image(s, o):
        seen.append(Path(s).name)
        o.write_bytes(b"w" * 7)

    doc = export_season(tmp_path, 1, poster=lambda s, o: o.write_bytes(b"p" * 5),
                        rendition=lambda s, o: o.write_bytes(b"r" * 30), image=image)["doc"]
    assert doc["titleBackground"]["renditions"] == {"720p": "jenerik-baslik.720p.mp4", "1080p": "jenerik-baslik.mp4"}
    assert doc["titleBackground"]["poster"] == "jenerik-baslik.webp"
    assert doc["intro"]["renditions"]["720p"] == "jenerik-tam.720p.mp4"
    assert doc["map"] == {"image": "map.webp", "width": 1520, "height": 2688}
    assert seen == ["map.jpg"]
    names = sorted(f["path"] for f in doc["files"])
    assert names == ["jenerik-baslik.720p.mp4", "jenerik-baslik.mp4", "jenerik-baslik.webp",
                     "jenerik-tam.720p.mp4", "jenerik-tam.mp4", "map.webp"]
    assert doc["renditionBytes"] == {"720p": 5 + 7 + 60, "1080p": 5 + 7 + 200}


def _sample_video(path: Path, seconds: float = 2.0) -> Path:
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error",
                    "-f", "lavfi", "-i", f"testsrc2=size=1080x1920:rate=30:duration={seconds}",
                    "-f", "lavfi", "-i", f"sine=frequency=440:sample_rate=44100:duration={seconds}",
                    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-profile:v", "high", "-c:a", "aac", "-b:a", "128k",
                    "-ac", "2", "-shortest", "-movflags", "+faststart", str(path)], check=True)
    return path


def _audio_md5(path: Path) -> str:
    return subprocess.check_output(["ffmpeg", "-loglevel", "error", "-i", str(path), "-map", "0:a",
                                    "-c", "copy", "-f", "md5", "-"]).decode().strip()


@pytest.mark.skipif(not HAS_FFMPEG, reason="ffmpeg yok")
def test_rendition_720_keeps_audio_and_duration(tmp_path):
    src = _sample_video(tmp_path / "s.mp4")
    out = media.rendition_720(src, tmp_path / "s.720p.mp4")
    v = next(s for s in media.probe_streams(out) if s["codec_type"] == "video")
    assert (v["codec_name"], v["profile"], v["width"], v["height"], v["pix_fmt"]) == \
        ("h264", "High", 720, 1280, "yuv420p")
    assert abs(media.probe_duration(out) - media.probe_duration(src)) <= 1 / 30 + 1e-3
    assert _audio_md5(out) == _audio_md5(src)          # ses kopyalandı, birebir aynı
    head = out.read_bytes()[:64 * 1024]
    assert 0 <= head.find(b"moov") < head.find(b"mdat") or b"mdat" not in head  # faststart
    assert not (tmp_path / "s.720p.part.mp4").exists()


@pytest.mark.skipif(not (HAS_FFMPEG and HAS_MAGICK), reason="ffmpeg/ImageMagick yok")
def test_still_writes_webp(tmp_path):
    src = tmp_path / "img.png"
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i", "testsrc2=size=1200x1800",
                    "-frames:v", "1", str(src)], check=True)
    out = media.still(src, tmp_path / "stills" / "img.webp")
    data = out.read_bytes()
    assert data[:4] == b"RIFF" and data[8:12] == b"WEBP"
    assert not list((tmp_path / "stills").glob("*.png"))
    jpg = media.still(src, tmp_path / "stills" / "img.jpg")
    assert jpg.read_bytes()[:2] == b"\xff\xd8"
