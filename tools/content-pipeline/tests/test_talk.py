"""H-090: Konuş görevleri (yönlendirmeli sahneler ve kısa mesaj yazma)."""
import copy
import json
import shutil
from pathlib import Path

import pytest

import content_lint
from hvpipeline.talk import (TALK_PACKAGE_FILE, check_message, contains_in_order, covered_targets, export_talk,
                             lint_talk, lint_task, load_tasks, match_tokens, talk_dir)

REPO = Path(__file__).resolve().parents[3]
ICERIK = REPO / "icerik"
VECTORS = json.loads((REPO / "mobile" / "test" / "fixtures" / "talk_check_vectors.json").read_text(encoding="utf-8"))


def _errors(issues):
    return [str(i) for i in issues if i.level == "error"]


def _codes(issues):
    return {i.code for i in issues if i.level == "error"}


def _doc(tid):
    return json.loads((talk_dir(ICERIK) / f"{tid}.json").read_text(encoding="utf-8"))


def _lint(doc, root=ICERIK):
    return lint_task(Path(f"{doc['id']}.json"), doc, root)[0]


# --- gerçek içerik ---------------------------------------------------------------------------

def test_real_tasks_are_clean_and_complete():
    results = lint_talk(ICERIK)
    for tid, issues, _ in results:
        assert _errors(issues) == [], tid
    kinds = {}
    for _, doc in load_tasks(ICERIK, 1):
        kinds.setdefault(doc["kind"], []).append(doc["id"])
    # Kabul kriteri: 3 sahne (kafe, yol sorma, yeni komşu) + kısa mesajlar.
    assert sorted(kinds["scene"]) == ["ask-the-way", "cafe-rosa", "maya-neighbour"]
    assert len(kinds["message"]) >= 2
    for tid in kinds["scene"]:
        doc = _doc(tid)
        assert 3 <= len(doc["turns"]) <= 5
        for t in doc["turns"]:
            assert len(t["accept"]) >= 3, (tid, t["id"])   # aynı anlam için birkaç doğal cevap
    # İçerik taslaktır: editör onayı bekler (H-028).
    assert all(doc["status"] == "DRAFT" for _, doc in load_tasks(ICERIK))


def test_cafe_scene_comes_after_rosa_appears():
    """Rosa B9'da tanışılır (CHARACTER_PROFILES); kafe sahnesi B9'dan önce açılmaz."""
    assert _doc("cafe-rosa")["unlockAfter"] == "A1-009"
    assert _doc("maya-neighbour")["unlockAfter"] == "A1-002"
    assert _doc("ask-the-way")["unlockAfter"] == "A1-003"


def test_content_lint_reports_talk(capsys):
    content_lint.main([str(p) for p in sorted(ICERIK.glob("A1-00[1-3]-*"))] + ["--no-chain", "--no-sets",
                                                                             "--no-hi", "--no-clips"])
    out = capsys.readouterr().out
    assert "== Konuş görevi cafe-rosa (scene)" in out
    assert "6 Konuş görevi" in out


# --- eşleştirme ------------------------------------------------------------------------------

def test_match_tokens_normalizes_like_the_app():
    assert match_tokens("I'm from İzmir, Türkiye.") == ["i", "am", "from", "izmir", "turkiye"]
    assert match_tokens("I'm from Turkey") == ["i", "am", "from", "turkiye"]
    assert match_tokens("Where's the café?") == ["where", "is", "the", "cafe"]
    assert match_tokens("It's 12, please.") == ["it", "is", "twelve", "please"]
    assert match_tokens("I can't") == ["i", "can", "not"]
    assert match_tokens("Where is…?") == ["where", "is"]


@pytest.mark.parametrize("v", VECTORS["checks"], ids=lambda v: v["text"])
def test_message_check_vectors(v):
    assert check_message(v["text"], v["check"]) is v["expect"]


@pytest.mark.parametrize("v", VECTORS["covered"], ids=lambda v: v["text"])
def test_covered_target_vectors(v):
    # H-096: kanıt yalnız geçerli (tek cümlede) eşleşen kalıplardan.
    assert covered_targets(v["targets"], v["text"], v["check"]) == v["expect"]


@pytest.mark.parametrize("v", VECTORS["contains"], ids=lambda v: f"{v['phrase']}<{v['text']}")
def test_contains_vectors(v):
    assert contains_in_order(v["text"], v["phrase"]) is v["expect"]


def test_no_check_means_self_check():
    assert check_message("anything", None) is None


# --- denetim kuralları -----------------------------------------------------------------------

def test_lint_catches_distractor_that_is_also_accepted():
    doc = _doc("cafe-rosa")
    doc["turns"][0]["distractors"][0]["en"] = "can i have a TEA please"
    assert "talk-distractor" in _codes(_lint(doc))


def test_lint_catches_target_missing_from_answers():
    doc = _doc("cafe-rosa")
    doc["turns"][2]["targets"] = ["How much is it?"]
    assert any("hiçbir kabul edilen cevapta geçmiyor" in e for e in _errors(_lint(doc)))


def test_lint_catches_unknown_or_future_target():
    doc = _doc("maya-neighbour")
    doc["turns"][0]["targets"] = ["Can I have a tea, please?"]   # B9 hedefi, B2'den sonra açılan sahnede
    doc["turns"][0]["accept"].append("Can I have a tea, please?")
    assert any("targetPhrases" in e for e in _errors(_lint(doc)))


def test_lint_catches_duplicate_answers_and_long_sentences():
    doc = _doc("ask-the-way")
    doc["turns"][0]["accept"].append("Excuse me. Where's the bus stop?")
    doc["turns"][1]["line"]["en"] = "Go straight and then turn left near the old blue café."
    codes = _codes(_lint(doc))
    assert "talk-accept" in codes
    assert "talk-sentence-length" in codes


def test_lint_catches_spoiler_image_and_missing_image():
    doc = _doc("maya-neighbour")
    doc["image"] = {"episode": "A1-009", "path": "stills/B9-04-k1-pov.webp"}
    assert any("spoiler" in e for e in _errors(_lint(doc)))
    doc["image"] = {"episode": "A1-002", "path": "stills/B2-99-yok.webp"}
    assert "talk-image" in _codes(_lint(doc))


def test_lint_message_rules():
    doc = _doc("late-maya")
    bad = copy.deepcopy(doc)
    bad["model"]["en"] = "See you soon."
    assert "talk-check" in _codes(_lint(bad))
    bad = copy.deepcopy(doc)
    bad["check"]["none"] = ["late"]
    assert "talk-check" in _codes(_lint(bad))
    bad = copy.deepcopy(_doc("hi-intro"))
    del bad["selfCheckTr"]
    assert "talk-check" in _codes(_lint(bad))
    bad = copy.deepcopy(doc)
    del bad["targets"]
    assert "talk-schema" in _codes(_lint(bad))


def test_lint_scene_schema():
    doc = _doc("cafe-rosa")
    bad = copy.deepcopy(doc)
    bad["turns"] = bad["turns"][:2]
    assert "talk-schema" in _codes(_lint(bad))
    bad = copy.deepcopy(doc)
    bad["turns"][1]["id"] = "t5"
    assert "talk-turn" in _codes(_lint(bad))
    bad = copy.deepcopy(doc)
    bad["targets"] = ["Thank you."]
    assert "talk-schema" in _codes(_lint(bad))


# --- dışa aktarma ----------------------------------------------------------------------------

def _copy_root(tmp_path, episodes=("A1-000", "A1-001", "A1-002", "A1-003", "A1-004", "A1-005", "A1-009")):
    root = tmp_path / "icerik"
    (root / "_evren").mkdir(parents=True)
    shutil.copytree(talk_dir(ICERIK), talk_dir(root))
    for cid in episodes:
        src = next(ICERIK.glob(f"{cid}-*"))
        dst = root / src.name
        (dst / "images").mkdir(parents=True)
        shutil.copy(src / "content.json", dst / "content.json")
        if (src / "audio_manifest.json").exists():
            shutil.copy(src / "audio_manifest.json", dst / "audio_manifest.json")
        for j in (src / "images").glob("*.json"):
            shutil.copy(j, dst / "images" / j.name)
    return root


def test_export_writes_package_with_reused_episode_audio(tmp_path):
    root = _copy_root(tmp_path)
    # Rosa'nın "Here you are." kaydı (B9 b9_17_rosa) bu ortamda var sayılır.
    (root / "A1-009-the-cafe-on-the-hill" / "audio").mkdir()
    (root / "A1-009-the-cafe-on-the-hill" / "audio" / "b9_17_rosa.mp3").write_bytes(b"mp3")
    calls = []

    def audio(src, out):
        calls.append(src.name)
        Path(out).write_bytes(b"m4a")

    out = tmp_path / "S1"
    summary = export_talk(root, 1, out, audio=audio)
    assert summary["tasks"] == 6 and summary["scenes"] == 3 and summary["messages"] == 3
    assert calls == ["b9_17_rosa.mp3"]
    assert summary["audio"] == 1
    assert any("b2_02_maya.mp3" in m for m in summary["audioMissing"])   # var ama medya yok → cihaz sesi
    pkg = json.loads((out / TALK_PACKAGE_FILE).read_text(encoding="utf-8"))
    tasks = {t["id"]: t for t in pkg["tasks"]}
    assert [t["id"] for t in pkg["tasks"]] == ["hi-intro", "maya-neighbour", "ask-the-way", "meet-note",
                                                "late-maya", "cafe-rosa"]
    cafe = tasks["cafe-rosa"]
    assert cafe["unlockEpisode"] == 9
    assert cafe["turns"][1]["line"] == {"en": "Here you are.", "tr": "Buyurun.", "audio": "talk/cafe-rosa-t2.m4a"}
    assert "audio" not in cafe["turns"][0]["line"]
    assert cafe["targets"] == ["Can I have a tea, please?", "How much is it?", "Thank you.", "Here you are."]
    assert (out / "talk" / "cafe-rosa-t2.m4a").exists()
    assert "author" not in cafe and "schemaVersion" not in cafe
    # Konuşanı satırda verilen kapanış (Mrs Brooks) da aranır; `speaker` pakete girmez.
    assert "speaker" not in tasks["maya-neighbour"]["outro"]
    # Kaynak kalkınca eski paket silinir.
    shutil.rmtree(talk_dir(root))
    assert export_talk(root, 1, out) is None
    assert not (out / TALK_PACKAGE_FILE).exists()


def test_export_refuses_lint_errors(tmp_path):
    root = _copy_root(tmp_path)
    p = talk_dir(root) / "late-maya.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    doc["model"]["en"] = "See you."
    p.write_text(json.dumps(doc), encoding="utf-8")
    with pytest.raises(ValueError):
        export_talk(root, 1, tmp_path / "S1")


def test_export_audio_temp_file_keeps_m4a_extension(tmp_path):
    # ffmpeg çıktı biçimini uzantıdan çıkarır: geçici dosya da .m4a ile bitmeli
    # (".m4a.tmp" → "Invalid argument").
    root = _copy_root(tmp_path)
    (root / "A1-009-the-cafe-on-the-hill" / "audio").mkdir()
    (root / "A1-009-the-cafe-on-the-hill" / "audio" / "b9_17_rosa.mp3").write_bytes(b"mp3")
    outs = []

    def audio(src, out):
        outs.append(Path(out))
        Path(out).write_bytes(b"m4a")

    export_talk(root, 1, tmp_path / "S1", audio=audio)
    assert outs and all(p.suffix == ".m4a" for p in outs)


# --- Hi'nin Türkçe sesleri (H-104) ----------------------------------------------------------

def _with_voice(root):
    """Ses haritası (yalnız varsa Konuş sesleri denetlenir) ve iki Hi sesi: biri hazır, biri medyasız."""
    shutil.copy(ICERIK / "_evren" / "sesler.json", root / "_evren" / "sesler.json")

    def strip(o):   # gerçek kaynaktaki Hi ses başvuruları (bu ortamda hizalaması yok)
        if isinstance(o, dict):
            return {k: strip(v) for k, v in o.items() if not k.endswith("Audio")}
        return [strip(v) for v in o] if isinstance(o, list) else o
    for q in talk_dir(root).glob("*.json"):
        q.write_text(json.dumps(strip(json.loads(q.read_text(encoding="utf-8"))), ensure_ascii=False, indent=2),
                     encoding="utf-8")
    p = talk_dir(root) / "cafe-rosa.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    doc["introAudio"] = "hi-ses/konusma-cafe-rosa-intro.mp3"
    doc["turns"][0]["promptAudio"] = "hi-ses/konusma-cafe-rosa-t1-prompt.mp3"
    p.write_text(json.dumps(doc, ensure_ascii=False, indent=2), encoding="utf-8")
    hs = root / "_evren" / "hi-ses"
    hs.mkdir(parents=True, exist_ok=True)
    from hvpipeline import tts_episode_tr as ep
    vm = ep.VoiceMap.load(root)
    for it in ep.collect_talk_task(p, doc, root, vm):
        if it.stem in ("konusma-cafe-rosa-intro", "konusma-cafe-rosa-t1-prompt"):
            (hs / f"{it.stem}.align.json").write_text(json.dumps(
                {"text": it.text, "voice_id": "alania2-f1", "timing": "duyu-1", "quality": {"ok": True}},
                ensure_ascii=False), encoding="utf-8")
    (hs / "konusma-cafe-rosa-intro.mp3").write_bytes(b"mp3")   # t1-prompt: medya git dışı, yok
    return root


def test_export_hi_voice_to_package(tmp_path):
    root = _with_voice(_copy_root(tmp_path))
    written = []

    def audio(src, out):
        written.append(src.name)
        Path(out).write_bytes(b"m4a")

    out = tmp_path / "S1"
    summary = export_talk(root, 1, out, audio=audio)
    assert summary["hiAudio"] == 1 and summary["hiAudioMissing"] == ["hi-ses/konusma-cafe-rosa-t1-prompt.mp3"]
    assert "konusma-cafe-rosa-intro.mp3" in written
    pkg = {t["id"]: t for t in json.loads((out / TALK_PACKAGE_FILE).read_text(encoding="utf-8"))["tasks"]}
    cafe = pkg["cafe-rosa"]
    assert cafe["introAudio"] == "talk/konusma-cafe-rosa-intro.m4a"
    assert (out / "talk" / "konusma-cafe-rosa-intro.m4a").exists()
    assert "promptAudio" not in cafe["turns"][0]          # medya yok → alan düşer, uygulamada düğme görünmez
    # Kaynağa özgü alanlar pakete girmez.
    blob = json.dumps(pkg, ensure_ascii=False)
    assert "SpeechTr" not in blob and "pronunciations" not in blob and "hi-ses/" not in blob
    # Yeniden dışa aktarımda eski Hi sesleri silinmez (kullanılanlar listesinde).
    export_talk(root, 1, out, audio=audio)
    assert (out / "talk" / "konusma-cafe-rosa-intro.m4a").exists()


def test_lint_hi_voice_reference_needs_alignment(tmp_path):
    root = _with_voice(_copy_root(tmp_path))
    (root / "_evren" / "hi-ses" / "konusma-cafe-rosa-intro.align.json").unlink()
    results = {tid: iss for tid, iss, _ in lint_talk(root)}
    errs = [str(i) for i in _errors(results["cafe-rosa"])]
    assert any("konusma-cafe-rosa-intro" in e and "hizalama" in e for e in errs)
    # medyası olmayan (git dışı) ses yalnız uyarı
    warns = [str(i) for i in results["cafe-rosa"] if i.level == "warning"]
    assert any("konusma-cafe-rosa-t1-prompt.mp3" in w for w in warns)


def test_lint_hi_voice_wrong_reference_is_error(tmp_path):
    root = _with_voice(_copy_root(tmp_path))
    p = talk_dir(root) / "cafe-rosa.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    doc["introAudio"] = "hi-ses/baska.mp3"
    p.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
    errs = [str(i) for i in _errors({tid: iss for tid, iss, _ in lint_talk(root)}["cafe-rosa"])]
    assert any("konusma-cafe-rosa-intro" in e for e in errs)
