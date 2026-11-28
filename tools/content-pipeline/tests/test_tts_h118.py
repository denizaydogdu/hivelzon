"""H-118: faster `_dp_align` (same result) and pronunciation/segment checks before paid calls."""
import json
import random
from difflib import SequenceMatcher

import pytest

from hvpipeline import tts_tr
from hvpipeline.tts_episode_tr import EpisodeTtsError, VoiceMap


# --- _dp_align: reference (pre-H-118 algorithm) ---------------------------------------------------

def _ref_align(orig, heard):
    sim, ok, gap, bias = tts_tr.sim, tts_tr.FUZZY_OK, tts_tr._GAP, tts_tr._PAIR_BIAS
    n, m = len(orig), len(heard)
    NEG = float("-inf")
    best = [[NEG] * (m + 1) for _ in range(n + 1)]
    back = [[None] * (m + 1) for _ in range(n + 1)]
    best[0][0] = 0.0
    for i in range(n + 1):
        for j in range(m + 1):
            cur = best[i][j]
            if cur == NEG:
                continue
            steps = []
            if i < n and j < m:
                s = sim(orig[i], heard[j])
                steps.append((1, 1, s + bias, s))
            if i + 1 < n and j < m:
                s = sim(orig[i] + orig[i + 1], heard[j])
                steps.append((2, 1, s + 2 * bias - 0.05 if s >= ok else NEG, s))
            if i < n and j + 1 < m:
                s = sim(orig[i], heard[j] + heard[j + 1])
                steps.append((1, 2, s + 2 * bias - 0.05 if s >= ok else NEG, s))
            if i < n:
                steps.append((1, 0, gap, 0.0))
            if j < m:
                steps.append((0, 1, gap, 0.0))
            for di, dj, gain, s in steps:
                v = cur + gain
                if v > best[i + di][j + dj]:
                    best[i + di][j + dj] = v
                    back[i + di][j + dj] = (i, j, s)
    out, i, j = [], n, m
    while (i, j) != (0, 0):
        pi, pj, s = back[i][j]
        out.append((list(range(pi, i)), list(range(pj, j)), s))
        i, j = pi, pj
    return out[::-1]


_WORDS = ["bir", "kapı", "mavi", "ev", "kedi", "şehir", "ışık", "gün", "yol", "çay", "o", "ne", "Lina", "anne",
          "dördüncü", "kat", "kapıyı", "açtı", "ve", "içeri", "girdi", "a", "bu"]


def _perturb(rng, words):
    out = []
    for w in words:
        r = rng.random()
        if r < 0.08:
            continue
        if r < 0.16 and len(w) > 2:
            out += [w[: len(w) // 2], w[len(w) // 2:]]
            continue
        if r < 0.24 and out:
            out[-1] += w
            continue
        if r < 0.36:
            w = w.replace("ı", "i").replace("ş", "s") if rng.random() < 0.5 else w[:-1] + "x"
        if r < 0.42:
            out.append("ee")
        out.append(w)
    return out


@pytest.mark.parametrize("seed", range(60))
def test_dp_align_matches_reference(seed):
    rng = random.Random(seed)
    orig = [rng.choice(_WORDS) for _ in range(rng.randint(0, 40))]
    heard = _perturb(rng, orig)
    if rng.random() < 0.2:
        heard = [rng.choice(_WORDS) for _ in range(rng.randint(0, 10))]
    assert tts_tr._dp_align(orig, heard) == _ref_align(orig, heard)


def test_dp_align_edge_cases():
    for orig, heard in [([], []), (["a"], []), ([], ["a"]), (["", "x"], ["x", ""]), (["ab", "cd"], ["abcd"]),
                        (["abcd"], ["ab", "cd"])]:
        assert tts_tr._dp_align(orig, heard) == _ref_align(orig, heard)


def test_quick_ratio_gate_is_an_upper_bound():
    # sim_gate skips SequenceMatcher.ratio() only when its cheap upper bounds are below FUZZY_OK.
    rng = random.Random(7)
    for _ in range(500):
        a = "".join(rng.choice("abcıs") for _ in range(rng.randint(1, 9)))
        b = "".join(rng.choice("abcıs") for _ in range(rng.randint(1, 9)))
        sm = SequenceMatcher(None, a, b)
        assert sm.ratio() <= sm.quick_ratio() <= sm.real_quick_ratio() + 1e-12
        assert sm.real_quick_ratio() == pytest.approx(2.0 * min(len(a), len(b)) / (len(a) + len(b)))


# --- pronunciation and segment checks ----------------------------------------------------------------

@pytest.mark.parametrize("prons", [
    "Lina", {"term": "Lina", "say_as": "Lina"}, [["Lina", "Lina"]], [{"term": "Lina"}], [{"term": "", "say_as": "x"}],
    [{"term": 3, "say_as": "x"}], [{"term": "Lina", "say_as": "Lina", "extra": 1}],
])
def test_bad_pronunciations_are_rejected(prons):
    assert tts_tr.pron_problem(prons)
    with pytest.raises(tts_tr.TrTtsError, match="pronunciations"):
        tts_tr.check_pronunciations(prons, "here")
    with pytest.raises(EpisodeTtsError):
        tts_tr.check_pronunciations(prons, "here", EpisodeTtsError)


def test_good_pronunciations_are_copied():
    src = [{"term": "Lina", "say_as": "Lina"}]
    out = tts_tr.check_pronunciations(src, "here")
    assert out == src and out[0] is not src[0]
    assert tts_tr.check_pronunciations(None, "here") == []


def test_check_segments_allow_empty_and_validates():
    assert tts_tr.check_segments([], allow_empty=True) == []
    with pytest.raises(tts_tr.TrTtsError):
        tts_tr.check_segments([tts_tr.Segment("p01", "Merhaba", None, [{"term": "x"}])], allow_empty=True)
    with pytest.raises(tts_tr.TrTtsError):
        tts_tr.check_segments([tts_tr.Segment("p01", "a", None), tts_tr.Segment("p01", "b", None)])


def test_voice_map_rejects_bad_pronunciations(tmp_path):
    p = tmp_path / "_evren" / "sesler.json"
    p.parent.mkdir()
    doc = {"turkish": {"roles": {"hi": {"voice": "alania2-f1"}}}, "english": {},
           "pronunciations": [{"term": "Lina"}]}
    p.write_text(json.dumps(doc), encoding="utf-8")
    with pytest.raises(EpisodeTtsError, match="say_as"):
        VoiceMap.load(tmp_path)
    doc["pronunciations"] = [{"term": "Lina", "say_as": "Lina"}]
    p.write_text(json.dumps(doc), encoding="utf-8")
    assert VoiceMap.load(tmp_path).pronunciations == doc["pronunciations"]


# --- Codex review findings (2026-11-27) -------------------------------------------------------------

def test_export_book_with_no_book_dirs_fails(tmp_path, capsys):
    import export_book
    assert export_book.main([str(tmp_path / "missing"), str(tmp_path / "_hidden")]) == 1
    assert "bulunamadı" in capsys.readouterr().err


@pytest.mark.parametrize("reel, timeline", [
    ({"video": "../escape.mp4", "poster": "p.webp"}, [{"shot": "s1"}]),
    ({"video": "/tmp/x.mp4", "poster": "p.webp"}, [{"shot": "s1"}]),
    ({"video": "v.mp4", "poster": "sub/p.webp"}, [{"shot": "s1"}]),
    ({"video": "v.mp4", "poster": "p.webp", "cues": [{"id": "../a"}]}, [{"shot": "s1"}]),
    ({"video": "v.mp4", "poster": "p.webp"}, [{"shot": "../s1"}]),
    ({"poster": "p.webp"}, [{"shot": "s1"}]),
])
def test_build_reel_rejects_unsafe_names(tmp_path, reel, timeline, capsys):
    import build_reel
    root = tmp_path / "A1-R-X-01"
    root.mkdir()
    (root / "reel.json").write_text(json.dumps(reel), encoding="utf-8")
    (root / "shots.json").write_text(json.dumps({"timeline": timeline}), encoding="utf-8")
    assert build_reel.main([str(root)]) == 2
    assert "güvenli değil" in capsys.readouterr().err
    assert not (tmp_path / "escape.mp4").exists()


def test_build_reel_accepts_safe_names():
    import build_reel
    reel = {"video": "A1-R-CIN-01.mp4", "poster": "A1-R-CIN-01.webp", "cues": [{"id": "s01-01"}]}
    assert build_reel._unsafe_names(reel, [{"shot": "s1"}, {"shot": "k_2"}]) == []


@pytest.mark.parametrize("seg", [{"shot": "s1", "audio": "../../x"}, {"shot": "s1", "clip": "../x.mp4"},
                                 {"shot": "s1", "clip": "/tmp/x.mp4"}, {"shot": "s1", "clip": "clips/a/b.mp4"},
                                 {"shot": "s1", "clip": "x.mp4"}])
def test_build_reel_rejects_unsafe_timeline_paths(seg):
    import build_reel
    assert build_reel._unsafe_names({"video": "v.mp4", "poster": "p.webp"}, [seg])


def test_build_reel_accepts_real_timeline_paths():
    import build_reel
    seg = {"shot": "k3", "audio": "s01-02", "clip": "clips/cin-k3.mp4"}
    assert build_reel._unsafe_names({"video": "v.mp4", "poster": "p.webp"}, [seg]) == []


@pytest.mark.parametrize("reel", [{"target": {"cue": "../../x-1"}}, {"id": "../x"}, {"target": {"cue": "a/b-1"}}])
def test_build_reel_rejects_unsafe_scene_names(reel):
    import build_reel
    assert build_reel._unsafe_names({"video": "v.mp4", "poster": "p.webp", **reel}, [{"shot": "s1"}])


def test_build_reel_rejects_symlinked_clip_outside(tmp_path, capsys):
    import build_reel
    outside = tmp_path / "secret.mp4"
    outside.write_bytes(b"x")
    root = tmp_path / "A1-R-X-01"
    (root / "clips").mkdir(parents=True)
    (root / "clips" / "k1.mp4").symlink_to(outside)
    (root / "reel.json").write_text(json.dumps({"video": "v.mp4", "poster": "p.webp"}), encoding="utf-8")
    (root / "shots.json").write_text(json.dumps({"timeline": [{"shot": "s1", "len": 1, "clip": "clips/k1.mp4"}]}),
                                     encoding="utf-8")
    assert build_reel.main([str(root)]) == 2
    assert "clips/ dizini dışına" in capsys.readouterr().err


def test_build_reel_rejects_symlinked_clips_dir(tmp_path, capsys):
    import build_reel
    ext = tmp_path / "ext"
    ext.mkdir()
    (ext / "k1.mp4").write_bytes(b"x")
    root = tmp_path / "A1-R-X-01"
    root.mkdir()
    (root / "clips").symlink_to(ext)
    (root / "reel.json").write_text(json.dumps({"video": "v.mp4", "poster": "p.webp"}), encoding="utf-8")
    (root / "shots.json").write_text(json.dumps({"timeline": [{"shot": "s1", "len": 1, "clip": "clips/k1.mp4"}]}),
                                     encoding="utf-8")
    assert build_reel.main([str(root)]) == 2
    assert "clips/ dizini dışına" in capsys.readouterr().err


def test_ffmpeg_inputs_force_mp3_demuxer():
    # ffmpeg sometimes probes short mp3 files as VVC video (2026-11-27)
    from hvpipeline import media
    assert media._inp("a/b.mp3") == ["-f", "mp3", "-i", "a/b.mp3"]
    assert media._inp("a/b.MP3")[:2] == ["-f", "mp3"]
    assert media._inp("a/b.wav") == ["-i", "a/b.wav"]
    assert media._probe_fmt("x.mp3") == ["-f", "mp3"] and media._probe_fmt("x.m4a") == []


@pytest.mark.parametrize("target", ["s01-01", ["x"], 3])
def test_build_reel_rejects_non_object_target(target):
    import build_reel
    assert build_reel._unsafe_names({"video": "v.mp4", "poster": "p.webp", "target": target}, [{"shot": "s1"}])


@pytest.mark.parametrize("text, spoken", [
    ("(Hatalı sıra: Yedi cuma.)", "Hatalı sıra: Yedi cuma."),
    ("(Hatalı) Geç kaldım, beni üzgün.", "Hatalı: Geç kaldım, beni üzgün."),
    ("(Hatalı: O (erkek) beyaz saçlı.)", "Hatalı: O (erkek) beyaz saçlı."),
    ("O [erkek] uzun boylu.", "O (erkek) uzun boylu."),
    ("İstasyon nerede? (eksik cümle)", "İstasyon nerede? (eksik cümle)"),
    ("Bak!", "Bak!"),
])
def test_spoken_text_opens_leading_parenthesis(text, spoken):
    # Alania treats a leading parenthetical as an instruction (2026-11-28)
    assert tts_tr.spoken_text(text) == spoken
    assert tts_tr.tts_payload(tts_tr.Segment("x", text, None))["input"] == spoken


def test_segment_with_nothing_to_speak_is_rejected():
    with pytest.raises(tts_tr.TrTtsError, match="okunacak metin yok"):
        tts_tr.check_segments([tts_tr.Segment("x", "( )", None)])


@pytest.mark.parametrize("text", ["(Hatalı sıra: Yedi cuma.", "((x)) y"])
def test_unopenable_leading_parenthesis_is_rejected(text):
    with pytest.raises(tts_tr.TrTtsError, match="parantezle başlıyor"):
        tts_tr.check_segments([tts_tr.Segment("x", text, None)])
