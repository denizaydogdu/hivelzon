"""H-048: Hi-A verisi (hata kataloğu, konu tanıtımları, köprü görevleri, "Bu ne demek?" dizini)."""
import copy
import json
import re
import shutil
from pathlib import Path

import pytest

import content_lint
from hvpipeline.hi import (BRIDGE_FILE, CATALOG_FILE, ERROR_TYPES, INTROS_FILE, build_lookup, export_hi,
                           lint_bridge, lint_catalog, lint_hi, lint_intros)

REPO = Path(__file__).resolve().parents[3]
ICERIK = REPO / "icerik"
DART_TAXONOMY = REPO / "mobile" / "lib" / "shared" / "meaning" / "error_taxonomy.dart"
HAS_PACKAGES = (ICERIK / "A1-001-a-strange-message" / "_build" / "package" / "scenes.json").exists()
needs_packages = pytest.mark.skipif(not HAS_PACKAGES, reason="bölüm paketleri yok (git dışı medya)")


def _src(name):
    return json.loads((ICERIK / "_evren" / name).read_text(encoding="utf-8"))


def _errors(issues):
    return [str(i) for i in issues if i.level == "error"]


def test_taxonomy_matches_dart_enum():
    """Katalogdaki hata türleri uygulamadaki sınıflandırmayla aynı (sürüm 1)."""
    dart = DART_TAXONOMY.read_text(encoding="utf-8")
    codes = set(re.findall(r"^\s+\w+\('([a-z_]+)', '", dart, re.MULTILINE))
    assert codes == ERROR_TYPES
    assert "kErrorTaxonomyVersion = 1" in dart


@needs_packages
def test_real_sources_are_clean():
    for name, issues in lint_hi(ICERIK):
        assert _errors(issues) == [], name


@needs_packages
def test_real_catalog_covers_every_wrong_decision_in_b1_b4():
    doc = _src(CATALOG_FILE)
    mapped = {(d["contentId"], d["node"], d["option"]) for d in doc["decisionErrors"]}
    wrong = set()
    for d in sorted(ICERIK.glob("A1-00[1-4]-*")):
        s = json.loads((d / "_build" / "package" / "scenes.json").read_text(encoding="utf-8"))
        for n in s["nodes"]:
            if n["type"] == "decision":
                wrong |= {(s["episode"]["id"], n["id"], o["id"]) for o in n["options"] if not o.get("correct")}
    assert mapped == wrong


def test_catalog_lint_catches_bad_entries(tmp_path):
    doc = _src(CATALOG_FILE)
    bad = copy.deepcopy(doc)
    bad["decisionErrors"] = []
    bad["entries"][0]["errorType"] = "grammar"
    bad["entries"][1]["id"] = bad["entries"][2]["id"]
    bad["entries"][3]["examples"] = [{"wrong": "x", "right": "x"}]
    bad["entries"][4]["explanationTr"] = "Bunu hep kaçırdın."
    bad["entries"][5]["examples"] = []
    errs = "\n".join(_errors(lint_catalog(bad, tmp_path)))
    assert "sınıflandırmada yok" in errs
    assert "aynı id iki kez" in errs
    assert "wrong ile right aynı" in errs
    assert "suçlayıcı dil" in errs
    assert "1–2 örnek gerekli" in errs


@needs_packages
def test_catalog_lint_rejects_mapping_to_correct_option_or_missing_entry():
    doc = _src(CATALOG_FILE)
    bad = copy.deepcopy(doc)
    bad["decisionErrors"] = [{"contentId": "A1-001", "node": "k1", "option": "a", "errorType": "verb_form"},
                             {"contentId": "A1-001", "node": "k2", "option": "b", "errorType": "word_choice",
                              "entry": "yok-boyle"},
                             {"contentId": "A1-001", "node": "kx", "option": "b", "errorType": "word_choice"}]
    errs = "\n".join(_errors(lint_catalog(bad, ICERIK)))
    assert "doğru cevap" in errs
    assert "katalogda yok" in errs
    assert "karar düğümü yok" in errs


@needs_packages
def test_intro_lint_checks_trigger_and_lines():
    doc = _src(INTROS_FILE)
    bad = copy.deepcopy(doc)
    bad["intros"][0]["trigger"]["match"] = "Where are you?"
    bad["intros"][1]["trigger"]["node"] = "k1"            # karar düğümü: segment değil
    bad["intros"][2]["linesTr"] = ["tek satır"]
    bad["intros"][3]["grammarTarget"] = "passive_voice"
    bad["intros"][4]["trigger"]["cue"] = "k1-ok-99"
    errs = "\n".join(_errors(lint_intros(bad, ICERIK)))
    assert "geçmiyor" in errs
    assert "video segmenti olmalı" in errs
    assert "2–3 Türkçe satır" in errs
    assert "content.json'da yok" in errs
    assert "altyazı satırı" in errs


def test_bridge_lint_safety_and_one_per_episode(tmp_path):
    (tmp_path / "A1-001-x").mkdir()
    (tmp_path / "A1-001-x" / "content.json").write_text("{}", encoding="utf-8")
    doc = {"schemaVersion": 1, "status": "DRAFT", "tasks": [
        {"id": "a", "contentId": "A1-001", "titleTr": "T", "textTr": "Menünün fotoğrafını çek ve yükle."},
        {"id": "b", "contentId": "A1-001", "titleTr": "T", "textTr": "Üç kelime oku."},
    ]}
    errs = "\n".join(_errors(lint_bridge(doc, tmp_path)))
    assert "güvenlik" in errs
    assert "en fazla 1" in errs


def test_real_bridge_tasks_are_safe():
    doc = _src(BRIDGE_FILE)
    assert len({t["contentId"] for t in doc["tasks"]}) == len(doc["tasks"])
    assert _errors(lint_bridge(doc, ICERIK)) == []


@needs_packages
def test_lookup_uses_approved_lines_without_wrong_forms():
    entries, used = build_lookup(ICERIK)
    assert used == ["A1-001", "A1-002", "A1-003", "A1-004"]
    by = {e["en"].lower(): e for e in entries}
    assert by["station"]["tr"] == "istasyon"
    assert by["station"]["audio"]["path"].startswith("segments/")
    assert by["station"]["audio"]["end"] > by["station"]["audio"]["start"]
    assert by["excuse me"]["kind"] == "phrase"
    # Yanlış seçimlerin tepki satırları örnek olmaz.
    examples = {e.get("exampleEn") for e in entries}
    assert "Yes, I am." not in examples and "Harbour where?" not in examples
    assert len(by) == len(entries)          # tekrar yok


@needs_packages
def test_lookup_skips_unapproved_translation(tmp_path):
    src = ICERIK / "A1-001-a-strange-message"
    ep = tmp_path / src.name
    shutil.copytree(src / "_build" / "package", ep / "_build" / "package",
                    ignore=shutil.ignore_patterns("*.mp4", "*.m4a", "*.webp", "*.jpg"))
    shutil.copyfile(src / "content.json", ep / "content.json")
    t = json.loads((src / "ceviri.tr.json").read_text(encoding="utf-8"))
    t["status"] = "DRAFT"
    (ep / "ceviri.tr.json").write_text(json.dumps(t), encoding="utf-8")
    assert build_lookup(tmp_path) == ([], [])


@needs_packages
def test_export_writes_hi_json(tmp_path):
    summary = export_hi(ICERIK, 1, tmp_path)
    doc = json.loads((tmp_path / "hi.json").read_text(encoding="utf-8"))
    assert summary["path"] == "hi.json"
    assert summary["errorCatalog"] == len(doc["errorCatalog"]) >= 6
    assert summary["topicIntros"] == len(doc["topicIntros"]) == 5
    assert summary["bridgeTasks"] == 4
    assert doc["taxonomyVersion"] == 1
    assert doc["status"]["errorCatalog"] == "APPROVED"  # kullanıcı onayı 2026-10-13
    assert {d["entry"] for d in doc["decisionErrors"] if d.get("entry")} <= {e["id"] for e in doc["errorCatalog"]}


def test_export_without_sources_returns_none(tmp_path):
    out = tmp_path / "out"
    out.mkdir()
    (out / "hi.json").write_text("{}", encoding="utf-8")
    assert export_hi(tmp_path, 1, out) is None
    assert not (out / "hi.json").exists()   # eski paket kalmaz


def test_export_refuses_lint_errors(tmp_path):
    (tmp_path / "_evren").mkdir()
    (tmp_path / "_evren" / BRIDGE_FILE).write_text(json.dumps(
        {"schemaVersion": 1, "status": "DRAFT",
         "tasks": [{"id": "x", "contentId": "A1-009", "titleTr": "T", "textTr": "Oku."}]}), encoding="utf-8")
    with pytest.raises(ValueError, match="A1-009"):
        export_hi(tmp_path, 1, tmp_path / "out")


@needs_packages
def test_content_lint_reports_hi_sources(capsys):
    eps = [str(p) for p in sorted(ICERIK.glob("A1-00[1-4]-*"))]
    assert content_lint.main([*eps, "--no-chain"]) == 0
    out = capsys.readouterr().out
    assert "== Hi verisi hata-katalogu.json: TAMAM" in out
    assert "3 Hi dosyası" in out
