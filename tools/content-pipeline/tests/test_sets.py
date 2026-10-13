"""H-051: konu setleri ve sahne avı (şema, kırpma ve dokunma bölgesi sınırları, lint, dışa aktarma)."""
import copy
import json
import shutil
from pathlib import Path

import pytest

import content_lint
from hvpipeline import media
from hvpipeline.graph import schema_errors
from hvpipeline.sets import (clip_range, export_sets, lint_set, lint_sets, load_sets, point_in_shape,
                             square_box, word_span)

FX = Path(__file__).parent / "fixtures"
REPO = Path(__file__).resolve().parents[3]
ICERIK = REPO / "icerik"
HAS_MEDIA = all(shutil.which(t) for t in ("ffmpeg", "ffprobe", "magick"))


def _item(**kw):
    d = {"id": "station", "w": "station", "tr": "istasyon", "findTr": "İstasyonu bul",
         "exampleEn": "Meet me at the old station.", "exampleTr": "Benimle eski istasyonda buluş.",
         "crop": [0.1, 0.1, 0.3, 0.2], "hotspots": [{"rect": [0.15, 0.12, 0.2, 0.1]}],
         "audioRef": {"source": "A1-001-test/audio/voice_02", "word": "station"},
         "exampleAudioRef": None}
    d.update(kw)
    return d


@pytest.fixture
def root(tmp_path):
    """Küçük içerik kökü: bir bölüm, sahne görseli, hizalamalı bir kayıt ve bir set."""
    ep = tmp_path / "A1-001-test"
    (ep / "images").mkdir(parents=True)
    (ep / "audio").mkdir()
    (ep / "content.json").write_text(json.dumps({"contentId": "A1-001", "episode": 1}), encoding="utf-8")
    (ep / "images" / "scene.png").write_bytes(b"png")
    shutil.copyfile(FX / "voice_02.align.json", ep / "audio" / "voice_02.align.json")
    (ep / "audio" / "voice_02.mp3").write_bytes(b"mp3")
    sd = tmp_path / "_evren" / "setler"
    sd.mkdir(parents=True)
    doc = {"schemaVersion": 1, "id": "test-room", "season": 1, "level": "A1", "order": 1,
           "titleTr": "Test odası", "unlockAfter": "A1-001", "sceneImage": "A1-001-test/images/scene.png",
           "status": "DRAFT", "items": [_item(), _item(id="clock", w="clock", tr="saat", findTr="Saati bul",
                                                     exampleEn="Look, a clock.", exampleTr="Bak, bir saat.",
                                                     audioRef=None)]}
    (sd / "test-room.json").write_text(json.dumps(doc), encoding="utf-8")
    return tmp_path


def _lint(root, mutate):
    p = root / "_evren" / "setler" / "test-room.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    mutate(doc)
    issues, _ = lint_set(p, doc, root)
    return [i for i in issues if i.level == "error"]


# --- gerçek setler ----------------------------------------------------------------------------

def test_repo_sets_follow_schema_and_lint_clean():
    sets = load_sets(ICERIK, 1)
    ids = [d["id"] for _, d in sets]
    assert ids[:2] == ["alex-room", "maya-shop"]           # kabul: en az iki set B1–B2 görsellerinden
    for p, doc in sets:
        assert schema_errors(doc, "topic-set.schema.json") == [], p
        assert 4 <= len(doc["items"]) <= 10
    for sid, issues, rep in lint_sets(ICERIK):
        assert [str(i) for i in issues if i.level == "error"] == [], sid
        assert rep["pct"] >= 95.0 and rep["pctWithGlossary"] >= 98.0 and rep["maxSentenceWords"] <= 8


def test_repo_sets_unlock_after_their_own_episode():
    unlock = {d["id"]: d["unlockAfter"] for _, d in load_sets(ICERIK, 1)}
    assert unlock["alex-room"] == "A1-001" and unlock["maya-shop"] == "A1-002"
    for _, d in load_sets(ICERIK, 1):
        assert d["sceneImage"].startswith(d["unlockAfter"])  # sahne o bölümün kendi çiziminden


# --- geometri ---------------------------------------------------------------------------------

def test_square_box_expands_short_side_and_clamps_inside_image():
    assert square_box([0.25, 0.25, 0.5, 0.25], 1000, 2000) == (250, 500, 500, 500)
    x, y, w, h = square_box([0.0, 0.9, 0.2, 0.1], 1520, 2688)   # alt köşe: içeri kaydırılır
    assert w == h and x == 0 and y + h <= 2688
    x, y, w, h = square_box([0.0, 0.0, 1.0, 0.8], 1520, 2688)   # kare sığmaz: kısa kenar
    assert w == h == 1520 and x == 0


def test_point_in_rect_and_concave_polygon():
    rect = {"rect": [0.2, 0.2, 0.2, 0.1]}
    assert point_in_shape(0.3, 0.25, rect) and point_in_shape(0.2, 0.2, rect)
    assert not point_in_shape(0.41, 0.25, rect)
    # "L" biçimli içbükey çokgen: girintideki nokta dışarıda kalır.
    poly = {"polygon": [[0.1, 0.1], [0.5, 0.1], [0.5, 0.2], [0.2, 0.2], [0.2, 0.5], [0.1, 0.5]]}
    assert point_in_shape(0.15, 0.4, poly)
    assert point_in_shape(0.4, 0.15, poly)
    assert not point_in_shape(0.4, 0.4, poly)


def test_word_span_uses_alignment_and_pads():
    al = json.loads((FX / "voice_02.align.json").read_text(encoding="utf-8"))
    span = word_span(al, "station")
    assert span is not None and span.text == "station" and span.end > span.start
    s, e = clip_range(span, duration=span.end + 0.05)
    assert s == round(max(0.0, span.start - 0.04), 3) and e == round(span.end + 0.05, 3)
    assert word_span(al, "stat") is None          # kelime sınırı
    assert word_span(al, "harbour") is None


# --- lint ---------------------------------------------------------------------------------------

def test_fixture_set_is_clean(root):
    assert _lint(root, lambda d: None) == []


@pytest.mark.parametrize("mutate,code", [
    (lambda d: d["items"][0].update(crop=[0.8, 0.1, 0.3, 0.2]), "set-crop"),
    (lambda d: d["items"][0].update(crop=[0.6, 0.6, 0.1, 0.1]), "set-crop"),         # bölgeyle kesişmiyor
    (lambda d: d["items"][0].update(hotspots=[{"rect": [0.9, 0.9, 0.2, 0.05]}]), "set-hotspot"),
    (lambda d: d["items"][0].update(hotspots=[{"polygon": [[0.1, 0.1], [0.2, 0.2], [0.3, 0.3]]}]), "set-hotspot"),
    (lambda d: d["items"][0].update(hotspots=[{"polygon": [[0.1, 1.2], [0.2, 0.2], [0.3, 0.1]]}]), "set-schema"),
    (lambda d: d["items"][0].update(hotspots=[]), "set-schema"),
    (lambda d: d["items"][0].update(tr=""), "set-schema"),
    (lambda d: d["items"][0].update(findTr=" "), "set-meaning"),
    (lambda d: d["items"][0].update(exampleEn="Meet me at the old station on Friday at seven."), "set-sentence-length"),
    (lambda d: d["items"][0].update(w="lighthouse"), "set-level"),
    (lambda d: d["items"][0].update(audioRef={"source": "A1-001-test/audio/voice_02", "word": "harbour"}), "set-audio"),
    (lambda d: d["items"][0].update(audioRef={"source": "A1-001-test/audio/yok", "word": "station"}), "set-audio"),
    (lambda d: d["items"][0].update(exampleAudioRef={"source": "A1-001-test/audio/voice_02"}), "set-audio"),
    (lambda d: d["items"].append(copy.deepcopy(d["items"][0])), "set-item"),
    (lambda d: d.update(unlockAfter="A1-009"), "set-unlock"),
    (lambda d: d.update(id="other-room"), "set-schema"),
])
def test_lint_catches_set_errors(root, mutate, code):
    errs = _lint(root, mutate)
    assert any(e.code == code for e in errs), [str(e) for e in errs]


def test_missing_git_ignored_media_is_a_warning_not_an_error(root):
    # Görsel/ses git dışında; CI'da bulunmaz. Denetim uyarı verir, hata vermez.
    p = root / "_evren" / "setler" / "test-room.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    doc.update(sceneImage="A1-001-test/images/yok.png")
    issues, _ = lint_set(p, doc, root)
    assert not [i for i in issues if i.level == "error" and i.code in ("set-image", "set-media")]
    assert any(i.level == "warning" and i.code == "set-media" for i in issues)


def test_above_level_word_is_allowed_when_marked(root):
    def mutate(d):
        d["items"][0].update(w="lighthouse", aboveLevel=True, exampleEn="The lighthouse is near the sea.",
                             audioRef=None)
    errs = _lint(root, mutate)
    assert not [e for e in errs if e.code == "set-level"]
    # Küçük fikstürde tek seviye üstü kelime kapsamayı %95 altına düşürür: kural yine işler.
    assert [e.code for e in errs] == ["set-coverage"]


def test_content_lint_cli_includes_sets(root, capsys):
    code = content_lint.main([str(root / "A1-001-test"), "--json"])
    out = json.loads(capsys.readouterr().out)
    assert [s["id"] for s in out["sets"]] == ["test-room"]
    assert out["sets"][0]["errors"] == []
    # Bölümün kendisi bu küçük fikstürde eksik (story.en.md yok); set hatası yok.
    assert code == 1
    assert content_lint.main([str(root / "A1-001-test"), "--json", "--no-sets"]) == 1
    assert "sets" in json.loads(capsys.readouterr().out)


# --- dışa aktarma -------------------------------------------------------------------------------

def test_export_sets_json_only(root, tmp_path):
    out = tmp_path / "pkg"
    summary = export_sets(root, 1, out, probe=lambda p: 4.0)
    assert summary == [{"id": "test-room", "order": 1, "titleTr": "Test odası", "unlockAfter": "A1-001",
                        "unlockEpisode": 1, "itemCount": 2, "cover": "test-room/scene.webp",
                        "path": "sets/test-room.json", "bytes": summary[0]["bytes"]}]
    doc = json.loads((out / "sets" / "test-room.json").read_text(encoding="utf-8"))
    st, cl = doc["items"]
    assert st["findEn"] == "Find the station!" and st["kind"] == "word" and st["image"] == "test-room/station.webp"
    assert st["audio"] == "test-room/station.m4a" and st["audioSource"]["end"] > st["audioSource"]["start"]
    assert "audio" not in cl and doc["scene"]["image"] == "test-room/scene.webp"
    assert doc["unlockEpisode"] == 1 and doc["status"] == "DRAFT"


def test_export_refuses_set_with_errors(root, tmp_path):
    p = root / "_evren" / "setler" / "test-room.json"
    d = json.loads(p.read_text(encoding="utf-8"))
    d["items"][0]["tr"] = ""
    p.write_text(json.dumps(d), encoding="utf-8")
    with pytest.raises(ValueError):
        export_sets(root, 1, tmp_path / "pkg")


def test_export_removes_stale_sets(root, tmp_path):
    out = tmp_path / "pkg"
    stale = out / "sets" / "old-set"
    stale.mkdir(parents=True)
    (stale / "x.webp").write_bytes(b"x")
    (out / "sets" / "old-set.json").write_text("{}")
    export_sets(root, 1, out)
    assert not stale.exists() and not (out / "sets" / "old-set.json").exists()


@pytest.mark.skipif(not HAS_MEDIA, reason="ffmpeg/ImageMagick yok")
@pytest.mark.skipif(not (ICERIK / "A1-001-a-strange-message" / "images" / "T1-oda.png").is_file(),
                    reason="git dışı bölüm görselleri bu ortamda yok")
def test_export_real_set_media(tmp_path):
    """Gerçek bir set (alex-room): 512 px WebP öğe görselleri, 1080 px sahne, kelime sesi kesiti."""
    root = tmp_path / "icerik"
    (root / "_evren" / "setler").mkdir(parents=True)
    shutil.copyfile(ICERIK / "_evren" / "setler" / "alex-room.json", root / "_evren" / "setler" / "alex-room.json")
    for ep in ("A1-001-a-strange-message", "A1-002-the-new-neighbour", "A1-003-find-the-station", "A1-004-the-note"):
        (root / ep).symlink_to(ICERIK / ep)
    out = tmp_path / "pkg"
    export_sets(root, 1, out, crop=media.crop_webp, scene=media.scene_webp, cut=media.cut_audio,
                gain=media.gain_to_target, probe=media.probe_duration, size=media.image_size)
    d = out / "sets" / "alex-room"
    assert media.image_size(d / "radio.webp") == (512, 512)
    w, h = media.image_size(d / "scene.webp")
    assert w == 1080 and abs(h / w - 2688 / 1520) < 0.01
    doc = json.loads((out / "sets" / "alex-room.json").read_text(encoding="utf-8"))
    radio = next(i for i in doc["items"] if i["id"] == "radio")
    clip = media.probe_duration(d / "radio.m4a")
    src = radio["audioSource"]
    assert abs(clip - (src["end"] - src["start"])) < 0.08 and 0.2 < clip < 1.0
    assert media.probe_duration(d / "radio.example.m4a") > clip
    assert not (d / "window.m4a").exists()          # sesi olmayan öğeye ses üretilmez
