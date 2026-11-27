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
