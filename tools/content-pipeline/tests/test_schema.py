import copy
import json
from pathlib import Path

import pytest

from hvpipeline.graph import load_schema, schema_errors

FX = Path(__file__).parent / "fixtures"


def load(name):
    return json.loads((FX / name).read_text(encoding="utf-8"))


def test_good_fixture_is_schema_valid():
    assert schema_errors(load("scenes-good.json")) == []


def test_schema_version_is_1():
    doc = load("scenes-good.json")
    doc["schemaVersion"] = 2
    assert any("schemaVersion" in e for e in schema_errors(doc))


def test_unknown_field_rejected():
    doc = load("scenes-good.json")
    doc["nodes"][0]["burnedSubtitles"] = True
    assert any("tanımsız alan: burnedSubtitles" in e for e in schema_errors(doc))


def test_segment_requires_mp4_and_duration():
    doc = load("scenes-good.json")
    seg = doc["nodes"][0]
    seg["video"] = "videos/x.mov"
    del seg["duration"]
    errs = schema_errors(doc)
    assert any("kalıba uymuyor" in e for e in errs)
    assert any("zorunlu alan eksik: duration" in e for e in errs)


def test_more_than_three_flags_rejected_by_schema():
    doc = load("scenes-good.json")
    doc["flags"] = [{"id": f"f{i}", "values": ["a", "b"]} for i in range(4)]
    assert any("en çok 3" in e for e in schema_errors(doc))


def test_reaction_needs_video_or_bubble():
    doc = load("scenes-good.json")
    r = next(n for n in doc["nodes"] if n["type"] == "reaction")
    del r["bubble"]
    assert schema_errors(doc)


def test_task_kind_requires_matching_item_fields():
    doc = load("scenes-good.json")
    t = next(n for n in doc["nodes"] if n["type"] == "task")
    t["kind"] = "order"
    assert any("tokens" in e for e in schema_errors(doc))


def test_gate_requires_active_task():
    doc = load("scenes-good.json")
    doc["gate"]["activeTask"] = []
    assert any("activeTask" in e for e in schema_errors(doc))


def test_subs_schema_accepts_builder_output_shape():
    sub = {"schemaVersion": 1, "segment": "s1", "lang": "en", "duration": 3.0,
           "cues": [{"id": "s1-01", "start": 0.5, "end": 1.2, "speaker": "ALEX", "text": "Hi!", "tr": None,
                     "words": [{"w": "Hi!", "start": 0.5, "end": 0.9}]}]}
    assert schema_errors(sub, "subs.schema.json") == []


def test_cross_check_with_reference_validator():
    js = pytest.importorskip("jsonschema")
    schema = load_schema()
    js.Draft202012Validator.check_schema(schema)
    v = js.Draft202012Validator(schema)
    good = load("scenes-good.json")
    assert list(v.iter_errors(good)) == []
    broken = load("scenes-broken.json")
    assert list(v.iter_errors(broken)) and schema_errors(broken)
    # Aynı bozulmalarda iki doğrulayıcı da hata vermeli
    for mutate in (lambda d: d.update(schemaVersion=3),
                   lambda d: d["nodes"][0].pop("video"),
                   lambda d: d["nodes"][1]["options"].pop() and d["nodes"][1]["options"].pop()):
        d = copy.deepcopy(good)
        mutate(d)
        assert bool(list(v.iter_errors(d))) == bool(schema_errors(d))
