import json
from pathlib import Path

from hvpipeline.graph import check_scenes

FX = Path(__file__).parent / "fixtures"


def codes(doc):
    return {(i.level, i.code) for i in check_scenes(doc)}


def load(name):
    return json.loads((FX / name).read_text(encoding="utf-8"))


def test_good_graph_has_no_errors():
    errs = [i for i in check_scenes(load("scenes-good.json")) if i.level == "error"]
    assert errs == []


def test_broken_graph_reports_every_rule():
    issues = check_scenes(load("scenes-broken.json"))
    got = {i.code for i in issues if i.level == "error"}
    for expected in ("schema", "unreachable", "dangling", "no-correct", "wrong-no-return",
                     "flags", "decisions", "flag-undeclared", "dead-end", "gate", "title-start"):
        assert expected in got, (expected, sorted(got))
    msgs = "\n".join(map(str, issues))
    assert "ulaşılamayan düğüm: orphan" in msgs
    assert "k1: doğru seçenek yok" in msgs
    assert "k2/b: yanlış seçenekten aynı karara dönüş yolu yok" in msgs
    assert "en fazla 4 karar" in msgs


def test_wrong_option_must_go_to_reaction():
    doc = load("scenes-good.json")
    k1 = next(n for n in doc["nodes"] if n["id"] == "k1")
    k1["options"][2]["next"] = "k1"
    assert ("error", "wrong-no-reaction") in codes(doc)


def test_reaction_returning_elsewhere_is_error():
    doc = load("scenes-good.json")
    r1 = next(n for n in doc["nodes"] if n["id"] == "r1")
    r1["next"] = "s2"
    assert ("error", "wrong-no-return") in codes(doc)


def test_unreachable_node_detected():
    doc = load("scenes-good.json")
    doc["nodes"].append({"id": "lost", "type": "card", "kind": "note",
                         "lines": [{"text": "x", "lang": "tr"}], "next": None})
    assert ("error", "unreachable") in codes(doc)


def test_flag_value_must_be_declared():
    doc = load("scenes-good.json")
    k1 = next(n for n in doc["nodes"] if n["id"] == "k1")
    k1["options"][0]["setFlag"]["value"] = "rude"
    assert ("error", "flag-value") in codes(doc)


def test_choice_task_needs_exactly_one_correct():
    doc = load("scenes-good.json")
    t1 = next(n for n in doc["nodes"] if n["id"] == "t1")
    t1["items"][0]["options"][1]["correct"] = True
    assert ("error", "task") in codes(doc)


def test_order_task_answer_must_use_tokens():
    doc = load("scenes-good.json")
    t1 = next(n for n in doc["nodes"] if n["id"] == "t1")
    t1.update(kind="order", items=[{"id": "i1", "tokens": ["a", "b"], "answer": ["a", "c"]}])
    assert ("error", "task") in codes(doc)


def test_start_must_be_title():
    doc = load("scenes-good.json")
    doc["start"] = "s1"
    msgs = [str(i) for i in check_scenes(doc) if i.code == "title-start"]
    assert msgs and "başlık" in msgs[0]


def test_nothing_may_precede_title():
    doc = load("scenes-good.json")
    s2 = next(n for n in doc["nodes"] if n["id"] == "s2")
    s2["next"] = "title"  # başlığa geri dönen yol
    assert ("error", "title-first") in codes(doc)


def test_long_recap_is_warning():
    doc = load("scenes-good.json")
    rc = next(n for n in doc["nodes"] if n["type"] == "recap")
    assert ("warning", "recap-length") not in codes(doc)
    rc["duration"] = 15.5
    got = codes(doc)
    assert ("warning", "recap-length") in got
    assert not any(lvl == "error" for lvl, _ in got)


def test_recap_must_follow_title():
    doc = load("scenes-good.json")
    title = doc["nodes"][0]
    title["next"] = "s1"
    s1 = next(n for n in doc["nodes"] if n["id"] == "s1")
    rc = next(n for n in doc["nodes"] if n["type"] == "recap")
    rc["next"], s1["next"] = "k1", "rc"
    assert ("warning", "recap-position") in codes(doc)
