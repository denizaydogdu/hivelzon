"""Dışa aktarıcının ffmpeg gerektirmeyen parçaları (kuru derleme)."""
import json
from pathlib import Path

import pytest

from hvpipeline.build import BuildError, Episode, build_dry
from hvpipeline.graph import check_scenes, schema_errors
from hvpipeline.media import XFADE, measure_onset

FX = Path(__file__).parent / "fixtures"
REPO = Path(__file__).resolve().parents[3]


def test_dry_build_produces_valid_scenes_and_subs():
    doc, b = build_dry(FX / "ep-good")
    assert schema_errors(doc) == []
    assert [i for i in check_scenes(doc) if i.level == "error"] == []
    assert doc["episode"]["links"]["openQuestion"] == "Q9"
    assert doc["episode"]["mission"]["tr"] == "Komşunla tanış."
    assert doc["schemaVersion"] == 2 and doc["start"] == "title"
    title = doc["nodes"][0]
    assert title == {"id": "title", "type": "title", "season": 1, "episode": 901,
                     "caption": "SEZON 1 · BÖLÜM 901", "title": "Test Episode",
                     "seasonVideo": "jenerik-baslik.mp4",
                     "seasonRenditions": {"720p": "jenerik-baslik.720p.mp4", "1080p": "jenerik-baslik.mp4"},
                     "seasonPoster": "jenerik-baslik.webp",
                     "duration": 2.5, "next": "s01"}
    seg = doc["nodes"][1]
    assert seg["video"] == "segments/s01.mp4" and seg["subtitles"] == "subs/s01.en.json"
    # H-054: video alanı 1080p kalır; 720p sürüm yanında.
    assert seg["renditions"] == {"720p": "segments/s01.720p.mp4", "1080p": "segments/s01.mp4"}
    sub = b.subs["subs/s01.en.json"]
    assert schema_errors(sub, "subs.schema.json") == []
    assert [c["speaker"] for c in sub["cues"]][0] == "MAYA"
    # İkinci çekim (sessiz, 2 sn) xfade ile eklenir
    shots = b.segments["s01"]
    assert seg["duration"] == pytest.approx(shots[0].len + 2.0 - XFADE, abs=1e-3)


def test_text_only_recorded_for_reaction_without_video():
    _, b = build_dry(FX / "ep-good")
    got = {(t.node, t.what) for t in b.text_only}
    assert ("r1", "tepki videosu") in got
    assert ("r1", "tepki balonu (Hi)") in got


def test_hi_line_inside_segment_is_rejected(tmp_path):
    ep = tmp_path / "ep"
    ep.mkdir()
    (ep / "content.json").write_text((FX / "ep-good" / "content.json").read_text(encoding="utf-8"), encoding="utf-8")
    k = json.loads((FX / "ep-good" / "kurgu.json").read_text(encoding="utf-8"))
    k["nodes"][1]["shots"][0]["audio"] = [{"path": str(FX / "b2_05_maya"), "speaker": "HI (TR)"}]
    (ep / "kurgu.json").write_text(json.dumps(k), encoding="utf-8")
    with pytest.raises(BuildError):
        build_dry(ep)


def test_speaker_from_manifest_and_filename(tmp_path):
    ep = tmp_path / "ep"
    (ep / "audio").mkdir(parents=True)
    (ep / "content.json").write_text('{"contentId": "A1-999"}', encoding="utf-8")
    (ep / "audio_manifest.json").write_text('{"MRS BROOKS|Hello.": "x_12_mrs"}', encoding="utf-8")
    e = Episode(ep)
    assert e.speaker_for(ep / "audio", "x_12_mrs") == "MRS BROOKS"
    assert e.speaker_for(ep / "audio", "alex_k1_a") == "ALEX"
    with pytest.raises(BuildError):
        e.speaker_for(ep / "audio", "zzz_01")


def test_missing_audio_estimated_from_manifest(tmp_path):
    """H-085: İngilizce ses henüz yokken kuru derleme, audio_manifest.json metninden tahmini hizalama kullanır."""
    import shutil
    ep = tmp_path / "ep-good"
    shutil.copytree(FX / "ep-good", ep)
    for f in ("b2_05_maya.align.json", "b2_06_alex.align.json"):
        shutil.copy(FX / f, tmp_path / f)
    k = json.loads((ep / "kurgu.json").read_text(encoding="utf-8"))
    k["nodes"][1]["shots"][1] = {"image": "images/none.png", "audio": ["x_07_jordan"]}
    (ep / "kurgu.json").write_text(json.dumps(k), encoding="utf-8")
    (ep / "audio_manifest.json").write_text('{"JORDAN|Hello! Is that a radio?": "x_07_jordan"}', encoding="utf-8")
    doc, b = build_dry(ep)
    assert b.ep.estimated == ["x_07_jordan"]
    cues = b.subs["subs/s01.en.json"]["cues"]
    assert cues[-1]["speaker"] == "JORDAN" and cues[-1]["text"] == "Hello! Is that a radio?"
    # Manifestte de yoksa eskisi gibi hata
    (ep / "audio_manifest.json").write_text("{}", encoding="utf-8")
    with pytest.raises(FileNotFoundError):
        build_dry(ep)


def test_measure_onset_finds_rise_near_expected():
    env = [0.0] * 300 + [1000.0] * 50 + [0.0] * 100
    assert measure_onset(env, 3.1) == pytest.approx(3.0)
    assert measure_onset([0.0] * 100, 0.5) is None


@pytest.mark.skipif(not (REPO / "icerik" / "A1-004-the-note" / "kurgu.json").exists(), reason="depo içeriği yok")
@pytest.mark.parametrize("ep", ["A1-001-a-strange-message", "A1-002-the-new-neighbour",
                                "A1-003-find-the-station", "A1-004-the-note"])
def test_real_episode_dry_build(ep):
    doc, b = build_dry(REPO / "icerik" / ep)
    assert schema_errors(doc) == []
    assert [str(i) for i in check_scenes(doc) if i.level == "error"] == []
    # H-050: her bölüm başlıkla açılır; açılışta görev ve başlık kartı yok; B2+ özetle sürer.
    by_id = {n["id"]: n for n in doc["nodes"]}
    title = by_id[doc["start"]]
    assert title["type"] == "title" and title["seasonVideo"] == "jenerik-baslik.mp4"
    assert title["caption"] == f"SEZON 1 · BÖLÜM {doc['episode']['number']}"
    assert not any(n["type"] == "card" and n.get("kind") in ("title", "mission") for n in doc["nodes"])
    first = by_id[title["next"]]
    if doc["episode"]["number"] == 1:
        assert first["type"] == "segment" and first.get("checkpoint")
    else:
        assert first["type"] == "recap" and first["skippable"] and first["duration"] <= 15
    assert {g["text"] for g in doc["episode"].get("targetPhraseGloss", [])} <= set(doc["episode"]["targetPhrases"])
    for rel, sub in b.subs.items():
        assert schema_errors(sub, "subs.schema.json") == [], rel
        starts = [c["start"] for c in sub["cues"]]
        assert starts == sorted(starts)
        assert all(0 <= c["start"] < c["end"] <= sub["duration"] + 0.5 for c in sub["cues"])
