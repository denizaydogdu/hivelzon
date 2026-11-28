"""H-109 Faz 3b: Konuş çevirileri, konu seti örnek Türkçesi ve Keşfet klip alıştırmasının Türkçe sesi.

Ağ yok: sahte istemci ve sahte ses yazıcı. Gerçek içerik yalnız okunur; üretim ve paket geçici klasöre yazılır.
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path

import pytest

import tts_season_tr
from hvpipeline import clips as clipsmod
from hvpipeline import seasontr
from hvpipeline.sets import export_sets, lint_sets
from hvpipeline.talk import export_talk, lint_talk
from test_tts_tr import FakeClient, fake_finalize

REPO = Path(__file__).resolve().parents[3]
ICERIK = REPO / "icerik"


@pytest.fixture
def root(tmp_path) -> Path:
    """Geçici içerik kökü: ses haritası, Konuş görevleri, konu setleri ve klip dosyası (gerçek veriden kopya)."""
    r = tmp_path / "icerik"
    ev = r / "_evren"
    for sub in ("konusma", "setler", "klipler"):
        (ev / sub).mkdir(parents=True)
        for p in (ICERIK / "_evren" / sub).glob("*.json"):
            shutil.copy(p, ev / sub / p.name)
    shutil.copy(ICERIK / "_evren" / "sesler.json", ev / "sesler.json")
    return r


def run(root: Path, tmp_path: Path, client, *extra) -> int:
    return tts_season_tr.main(["--root", str(root), "--ledger", str(tmp_path / "ledger.json"), *extra],
                              client=client, finalize=fake_finalize, sleep=lambda s: None)


def _edit(path: Path, fn) -> None:
    doc = json.loads(path.read_text(encoding="utf-8"))
    fn(doc)
    path.write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


def test_spots_and_stable_ids():
    doc = {"id": "cafe", "turns": [{"id": "t1", "line": {"en": "Hi", "tr": "Merhaba."}},
                                   {"id": "t2", "line": {"en": "Bye", "tr": "Merhaba."}},
                                   {"id": "t3", "line": {"en": "X", "tr": "  "}}],
           "outro": {"en": "Bye", "tr": "Hoşça kal."}, "model": {"en": "M", "tr": "Örnek."}}
    assert seasontr.talk_spots(doc) == [("t1", "cafe-t1-line", "Merhaba."), ("t2", "cafe-t2-line", "Merhaba."),
                                        ("model", "cafe-model", "Örnek."), ("outro", "cafe-outro", "Hoşça kal.")]
    u = seasontr.talk_unit(Path("cafe.json"), doc)
    # aynı Türkçe metin bir kez seslendirilir; ikinci yer aynı sesi alır
    assert u.items == [("cafe-t1-line", "Merhaba."), ("cafe-model", "Örnek."), ("cafe-outro", "Hoşça kal.")]
    assert u.texts["t2"] == "Merhaba."
    s = seasontr.set_unit(Path("oda.json"), {"id": "oda", "items": [{"id": "radio", "exampleTr": "Telsiz."}]})
    assert s.items == [("oda-radio-ex", "Telsiz.")]


def test_clip_quiz_text_follows_reel_rule():
    q = {"promptTr": "Ne demek?", "options": [{"text": "Evet", "lang": "tr"}, {"text": "Hayır"}],
         "explainTr": "Açıklama."}
    assert seasontr.quiz_texts(q) == {"prompt": "Ne demek? Evet. Hayır.", "explain": "Açıklama."}
    q["options"][0]["lang"] = "en"            # İngilizce seçenek varsa seçenekler okunmaz
    assert seasontr.quiz_texts(q) == {"prompt": "Ne demek?", "explain": "Açıklama."}
    assert seasontr.clip_spots({"id": "S1-K01"}) == []


def test_real_content_has_no_uncovered_english():
    """Sözlükte olmayan İngilizce kelime/ad 0 (Alania İngilizceyi Türkçe okur; sözlük sonra eklenirse yeniden
    ücretlenir). Türkçe okunuşu yeterli adlar (Maya) yanlış alarm değildir."""
    for part in seasontr.PARTS:
        us = seasontr.units(ICERIK, part)
        assert us, part
        assert seasontr.english_report(us) == {}, part


def test_part_is_required_and_dry_run_calls_nothing(root, tmp_path, capsys, monkeypatch):
    monkeypatch.delenv("HIVELZON_TR_TTS_MONTHLY_CHAR_CAP", raising=False)
    with pytest.raises(SystemExit):
        run(root, tmp_path, FakeClient())
    c = FakeClient()
    assert run(root, tmp_path, c, "--part", "talk") == 0
    out = capsys.readouterr().out
    n = sum(len(t) for u in seasontr.units(root, "talk") for _, t in u.items)
    assert c.speech_calls == [] and f"Toplam Alania: {n} karakter" in out
    assert not seasontr.out_dir(root, "talk").exists()
    assert run(root, tmp_path, c, "--part", "talk", "--execute") == 1           # tavan yok
    assert c.speech_calls == []


def test_english_without_dictionary_is_refused(root, tmp_path, capsys):
    _edit(root / "_evren" / "konusma" / "cafe-rosa.json", lambda d: d.pop("translationPronunciations"))
    c = FakeClient()
    assert run(root, tmp_path, c, "--part", "talk", "--execute", "--monthly-char-cap", "100000") == 1
    assert c.speech_calls == [] and "Alex" in capsys.readouterr().out


def test_execute_idempotent_lint_states_and_stale(root, tmp_path):
    c = FakeClient()
    assert run(root, tmp_path, c, "--part", "sets", "--execute", "--monthly-char-cap", "100000") == 0
    us = seasontr.units(root, "sets")
    assert len(c.speech_calls) == sum(len(u.items) for u in us)
    alex = next(x for x in c.speech_calls if x["input"] == "Alex pencereden dışarı bakıyor.")
    assert alex["pronunciations"] == [{"term": "Alex", "say_as": "Aleks"}] and alex["voice"] == "alania2-f1"
    d = seasontr.out_dir(root, "sets")
    assert (d / "alex-room-window-ex.mp3").exists() and (d / "PROMPTS.md").exists()
    c2 = FakeClient()
    assert run(root, tmp_path, c2, "--part", "sets", "--execute", "--monthly-char-cap", "100000") == 0
    assert c2.speech_calls == []                                                   # güncel: atlanır
    u = next(x for x in us if x.uid == "alex-room")
    issues, st = seasontr.check_unit(root, u)
    assert st["audio"] == st["segments"] == 10 and not issues
    # söyleniş sözlüğü değişti → ses eskir (pakete girmez), lint uyarır
    p = root / "_evren" / "setler" / "alex-room.json"
    _edit(p, lambda doc: doc.update(translationPronunciations=[{"term": "Alex", "say_as": "Aleksi"}]))
    u = seasontr.set_unit(p, json.loads(p.read_text(encoding="utf-8")))
    issues, st = seasontr.check_unit(root, u)
    assert st["stale"] == 2 and sum("eski metinden" in m for _, _, m in issues) == 2
    assert set(seasontr.current_audio(root, u)) == {t for _, t in u.items} - {
        "Alex pencereden dışarı bakıyor.", "Alex'in masasında üç kitap var."}
    # bozuk sözlük: hata
    _edit(p, lambda doc: doc.update(translationPronunciations=[{"term": "Alex"}]))
    bad = seasontr.safe_units(root, "sets", p, json.loads(p.read_text(encoding="utf-8")))
    assert isinstance(bad[0], Exception) and seasontr.check_unit(root, bad[0])[0][0][0] == "error"
    # sahipsiz ses
    (d / "eski-ex.align.json").write_text("{}", encoding="utf-8")
    assert seasontr.orphan_audio(root, "sets", us) == ["eski-ex"]


def test_lint_missing_audio_is_one_warning_per_unit_and_no_voice_map_is_silent(root):
    u = next(x for x in seasontr.units(root, "talk") if x.uid == "cafe-rosa")
    issues, st = seasontr.check_unit(root, u)
    assert [c for _, c, _ in issues] == ["talk-tr-audio"] and st["audio"] == 0 and st["segments"] == 5
    (root / "_evren" / "sesler.json").unlink()
    assert seasontr.check_unit(root, u) == ([], {})


def _fake_writer(calls: list):
    def write(src: Path, out: Path):
        calls.append((Path(src).name, Path(out).name))
        Path(out).parent.mkdir(parents=True, exist_ok=True)
        Path(out).write_bytes(b"m4a")
    return write


def test_real_lint_has_no_tr_audio_errors():
    for rows in (lint_talk(ICERIK), lint_sets(ICERIK)):
        for uid, iss, _ in rows:
            assert not [i for i in iss if i.level == "error" and "tr-" in i.code], uid


def test_export_talk_and_sets_package_only_current_audio(tmp_path, monkeypatch):
    """Gerçek içerik; sesler geçici klasörde (out_dir yamalı). Güncel ses pakete girer, eskimiş girmez."""
    audio_root = tmp_path / "ses"
    monkeypatch.setattr(seasontr, "out_dir", lambda r, part: audio_root / part)
    c = FakeClient()
    assert tts_season_tr.main(["--root", str(ICERIK), "--ledger", str(tmp_path / "l.json"), "--part", "talk",
                               "--part", "sets", "--execute", "--monthly-char-cap", "100000",
                               "--segment", "cafe-rosa-t1-line", "--segment", "cafe-rosa-outro",
                               "--segment", "meet-note-model", "--segment", "alex-room-radio-ex"],
                              client=c, finalize=fake_finalize, sleep=lambda s: None) == 0
    assert len(c.speech_calls) == 4
    out = tmp_path / "pkg"
    calls: list = []
    summary = export_talk(ICERIK, 1, out, audio=_fake_writer(calls))
    doc = json.loads((out / "talk.json").read_text(encoding="utf-8"))
    tasks = {t["id"]: t for t in doc["tasks"]}
    cafe = tasks["cafe-rosa"]
    assert cafe["turns"][0]["line"]["trAudio"] == "talk/ceviri-cafe-rosa-t1-line.m4a"
    assert "trAudio" not in cafe["turns"][1]["line"]                     # sesi yok → alan yok
    assert cafe["outro"]["trAudio"] == "talk/ceviri-cafe-rosa-outro.m4a"
    assert tasks["meet-note"]["model"]["trAudio"] == "talk/ceviri-meet-note-model.m4a"
    assert "translationPronunciations" not in cafe and (out / "talk" / "ceviri-cafe-rosa-t1-line.m4a").exists()
    assert summary["trAudio"] == 3 and "cafe-rosa:t2" in summary["trAudioMissing"]
    # karakter satırı ses sayısına Türkçe çeviri dosyaları girmez (qa bulgusu, 2026-11-28)
    line_files = [f for f in (out / "talk").iterdir() if not f.name.startswith("ceviri-")]
    assert summary["audio"] == len(line_files) - summary["hiAudio"]
    summary = export_sets(ICERIK, 1, out, tr_audio=_fake_writer(calls))
    sets = json.loads((out / "sets" / "alex-room.json").read_text(encoding="utf-8"))
    radio = next(i for i in sets["items"] if i["id"] == "radio")
    assert radio["exampleTrAudio"] == "alex-room/tr-radio.m4a" and (out / "sets" / "alex-room" / "tr-radio.m4a").exists()
    assert all("exampleTrAudio" not in i for i in sets["items"] if i["id"] != "radio")
    # anahtar değişirse (ör. söyleniş sözlüğü düzeltildi) eski ses pakete girmez ve eski dosya silinir
    real_unit = seasontr.set_unit

    def changed(path, doc):
        u = real_unit(path, doc)
        u.prons = [{"term": "E", "say_as": "İ"}]
        return u
    monkeypatch.setattr(seasontr, "set_unit", changed)
    export_sets(ICERIK, 1, out, tr_audio=_fake_writer(calls))
    sets = json.loads((out / "sets" / "alex-room.json").read_text(encoding="utf-8"))
    assert all("exampleTrAudio" not in i for i in sets["items"])
    assert not (out / "sets" / "alex-room" / "tr-radio.m4a").exists()


@pytest.mark.skipif(not all((ICERIK / d / "_build" / "package" / "scenes.json").exists()
                            for d in ("A1-001-a-strange-message", "A1-002-the-new-neighbour")),
                    reason="bölüm paketleri yok (git dışı; export_package.py ile kurulur)")
def test_export_clips_quiz_audio(tmp_path, monkeypatch):
    audio_root = tmp_path / "ses"
    monkeypatch.setattr(seasontr, "out_dir", lambda r, part: audio_root / part)
    c = FakeClient()
    assert tts_season_tr.main(["--root", str(ICERIK), "--ledger", str(tmp_path / "l.json"), "--part", "clips",
                               "--execute", "--monthly-char-cap", "100000", "--segment", "S1-K04-prompt",
                               "--segment", "S1-K04-explain", "--segment", "S1-K01-explain"],
                              client=c, finalize=fake_finalize, sleep=lambda s: None) == 0
    k04 = next(x for x in c.speech_calls if x["input"].startswith("“Nice to meet you.”"))
    assert k04["input"].endswith("Yardımcı olabilir miyim?")                  # Türkçe seçenekler okunur
    assert {"term": "Nice to meet you", "say_as": "Nays tu miit yu"} in k04["pronunciations"]
    out = tmp_path / "pkg"
    try:
        clipsmod.export_clips(ICERIK, 1, out, tr_audio=_fake_writer([]))
    except ValueError as e:      # klip sınırları bölüm paketlerine bağlı; yerel paket eksikse atlanır
        pytest.skip(f"klip dışa aktarması bu ortamda kurulamadı: {e}")
    doc = json.loads((out / "clips.json").read_text(encoding="utf-8"))
    recs = {r["id"]: r for r in doc["clips"]}
    at = recs["S1-K04"]["quiz"]["audioTr"]
    assert set(at) == {"prompt", "explain"} and at["prompt"]["audio"] == "clips/S1-K04.tr-prompt.m4a"
    assert set(recs["S1-K01"]["quiz"]["audioTr"]) == {"explain"}
    assert "audioTr" not in recs["S1-K02"]["quiz"]
    assert (out / "clips" / "S1-K04.tr-explain.m4a").exists()
