from pathlib import Path

import pytest

from hvpipeline.align import Alignment, Part, merge_parts, part_cues, shot_cues

FX = Path(__file__).parent / "fixtures"


@pytest.fixture
def voice():
    return Alignment.load(FX / "voice_02.align.json")


def test_sentence_chunks_merge_short_parts(voice):
    cues = part_cues(Part("VOICE", voice))
    texts = [c.text for c in cues]
    # "This is E." 3 sözcük; "Friday." tek sözcük → sonrakiyle birleşir
    assert texts == ["This is E.", "Meet me at the old station.", "Friday. Seven o'clock."]
    for c in cues:
        assert c.start < c.end
        assert c.words[0]["start"] == pytest.approx(c.start)
        assert " ".join(w["w"] for w in c.words) == c.text


def test_shot_cues_end_before_next_and_tail(voice):
    cues = shot_cues([Part("VOICE", voice)])
    for a, b in zip(cues, cues[1:]):
        assert a.end <= b.start + 1e-9
    last_word_end = voice.ends[-1]
    assert cues[-1].end == pytest.approx(last_word_end + 0.15)


def test_lead_compensation_moves_first_cue_only(voice):
    base = shot_cues([Part("VOICE", voice)])
    lead = base[0].start + 0.12
    moved = shot_cues([Part("VOICE", voice)], lead=lead)
    assert moved[0].start == pytest.approx(lead)
    assert [c.start for c in moved[1:]] == [c.start for c in base[1:]]


def test_atempo_scales_times(voice):
    slow = voice.scaled(0.8)
    assert slow.ends[-1] == pytest.approx(voice.ends[-1] / 0.8)


def test_merge_parts_offsets_and_speakers():
    a = Alignment.load(FX / "b2_05_maya.align.json")
    b = Alignment.load(FX / "b2_06_alex.align.json")
    parts = merge_parts([("MAYA", a, 3.0), ("ALEX", b, 2.0)], gap=0.35)
    cues = shot_cues(parts)
    assert {c.speaker for c in cues} == {"MAYA", "ALEX"}
    alex = [c for c in cues if c.speaker == "ALEX"]
    assert alex[0].start >= 3.35  # 3,0 sn ses + 0,35 sn boşluk
    assert all(c.speaker == "MAYA" for c in cues if c.start < 3.35)


def test_cue_shift(voice):
    c = part_cues(Part("VOICE", voice))[0]
    s = c.shifted(10.0)
    assert s.start == pytest.approx(c.start + 10) and s.words[-1]["end"] == pytest.approx(c.words[-1]["end"] + 10)
