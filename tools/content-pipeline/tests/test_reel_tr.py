"""H-109 Faz 1: Keşfet reel alıştırmasının Türkçe sesi (Alania + Duyu). Ağ yok: sahte istemci ve sahte medya."""

from __future__ import annotations

import json
import shutil
from pathlib import Path

import pytest

import tts_reel_tr
from hvpipeline import reeltr
from hvpipeline.book import text_sha256
from hvpipeline.reels import lint_reel
from test_tts_tr import FakeClient, fake_finalize

REPO = Path(__file__).resolve().parents[3]
PROMPT = "Kaç bilet isteniyor? İki. Bir. Üç."
EXPLAIN = "Mia iki bilet istiyor."


class FakeMedia:
    target_lufs = -16.0

    def __init__(self):
        self.calls = []

    def loudness(self, paths):
        return {"I": -20.0}

    def audio(self, src, gain, out):
        self.calls.append((src.name, round(gain, 2)))
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"m4a:" + src.read_bytes())
        return out

    def duration(self, path):
        return 3.5


@pytest.fixture
def reel_dir(tmp_path) -> Path:
    d = tmp_path / "reeller" / "A1-R-CIN-01"
    d.mkdir(parents=True)
    shutil.copy(REPO / "reeller" / "A1-R-CIN-01" / "reel.json", d / "reel.json")
    return d


def run(d: Path, tmp_path: Path, client, *extra, media=None) -> int:
    return tts_reel_tr.main([str(d), "--ledger", str(tmp_path / "ledger.json"), *extra], client=client,
                            finalize=fake_finalize, sleep=lambda s: None, media=media)


def _set(d: Path, fn) -> None:
    doc = json.loads((d / "reel.json").read_text(encoding="utf-8"))
    fn(doc)
    (d / "reel.json").write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


def test_practice_text_is_what_the_app_shows(reel_dir):
    doc = reeltr.source_doc(reel_dir)
    assert reeltr.practice_turkish(doc) == [(reeltr.PROMPT_ID, PROMPT), (reeltr.EXPLAIN_ID, EXPLAIN)]
    # İngilizce seçenek varsa seçenekler okunmaz (Alania İngilizceyi Türkçe okur); açıklama yoksa parça yok
    doc["practice"]["options"][1]["lang"] = "en"
    doc["practice"].pop("explainTr")
    assert reeltr.practice_turkish(doc) == [(reeltr.PROMPT_ID, "Kaç bilet isteniyor?")]
    doc.pop("practice")
    assert reeltr.practice_turkish(doc) == []


def test_segments_voice_and_dictionary(reel_dir):
    segs = reeltr.segments(reeltr.source_doc(reel_dir))
    assert [s.id for s in segs] == ["practice-prompt", "practice-explain"] and segs[0].pronunciations is None
    _set(reel_dir, lambda d: d.update(narrationTr={"pronunciations": [{"term": "Mia", "say_as": "Miya"}]}))
    segs = reeltr.segments(reeltr.source_doc(reel_dir))
    assert segs[0].pronunciations is None and segs[1].pronunciations == [{"term": "Mia", "say_as": "Miya"}]
    assert reeltr.voice_for(reeltr.source_doc(reel_dir))[0] == "alania2-f1"
    _set(reel_dir, lambda d: d.update(narrationTr={"pronunciations": [{"term": "Mia"}]}))
    with pytest.raises(reeltr.ReelTrError):
        reeltr.segments(reeltr.source_doc(reel_dir))


def test_dry_run_execute_idempotent_lint_and_package(reel_dir, tmp_path, capsys, monkeypatch):
    monkeypatch.delenv("HIVELZON_TR_TTS_MONTHLY_CHAR_CAP", raising=False)
    c = FakeClient()
    assert run(reel_dir, tmp_path, c) == 0
    out = capsys.readouterr().out
    n = len(PROMPT) + len(EXPLAIN)
    assert c.speech_calls == [] and f"Toplam Alania: {n} karakter" in out and "1 reel, 2 parça" in out
    assert not (reel_dir / "audio").exists()
    assert run(reel_dir, tmp_path, c, "--execute") == 1                       # tavan yok
    assert c.speech_calls == []
    # lint: ses yok → reel başına tek uyarı
    w = [str(i) for i in lint_reel(reel_dir).warnings if i.code == "reel.tr-audio"]
    # alıştırma ve (H-109 Faz 3) altyazı Türkçesi: her biri reel başına tek uyarı
    assert len(w) == 2 and "practice-prompt, practice-explain" in w[0] and "altyazı çevirisinin" in w[1]
    assert run(reel_dir, tmp_path, c, "--execute", "--monthly-char-cap", "100000") == 0
    assert [x["input"] for x in c.speech_calls] == [PROMPT, EXPLAIN]
    od = reel_dir / "audio" / "tr"
    assert sorted(p.name for p in od.glob("*.mp3")) == ["practice-explain.mp3", "practice-prompt.mp3"]
    assert "| practice-prompt | alania-v2 | alania2-f1 |" in (reel_dir / "PROMPTS.md").read_text(encoding="utf-8")
    c2 = FakeClient()
    assert run(reel_dir, tmp_path, c2, "--execute", "--monthly-char-cap", "100000") == 0
    assert c2.speech_calls == []
    rep = lint_reel(reel_dir)
    assert not practice_issues(rep), [str(i) for i in rep.issues]
    assert {k: v for k, v in rep.tr_audio.items() if k != "subtitles"} == \
        {"segments": 2, "chars": n, "aligned": 2, "audio": 2, "stale": 0}
    assert rep.tr_audio["subtitles"]["segments"] == 3 and rep.tr_audio["subtitles"]["audio"] == 0
    # paket: kurulmuş paketin reel.json'u güncellenir (video yeniden kurulmaz)
    assert run(reel_dir, tmp_path, None, "--package") == 1                    # paket yok
    pkg = reel_dir / "_build" / "package"
    pkg.mkdir(parents=True)
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    fm = FakeMedia()
    assert run(reel_dir, tmp_path, None, "--package", media=fm) == 0
    doc = json.loads((pkg / "reel.json").read_text(encoding="utf-8"))
    assert doc["practice"]["audioTr"] == {
        "prompt": {"audio": "audio/tr/practice-prompt.m4a", "duration": 3.5, "textSha256": text_sha256(PROMPT)},
        "explain": {"audio": "audio/tr/practice-explain.m4a", "duration": 3.5, "textSha256": text_sha256(EXPLAIN)}}
    assert (pkg / "audio" / "tr" / "practice-prompt.m4a").exists() and all(g == 4.0 for _, g in fm.calls)
    rep = lint_reel(reel_dir)       # paket tercih edilir
    assert rep.ok and not practice_issues(rep), [str(i) for i in rep.issues]
    # açıklama değişti: eski ses pakete girmez, kaynak ve paket uyarı verir
    _set(reel_dir, lambda d: d["practice"].update(explainTr="Mia iki bilet istiyor, lütfen."))
    rep = lint_reel(reel_dir)
    msgs = [str(i) for i in rep.warnings if i.code == "reel.tr-audio"]
    assert any("practice-explain" in m and "eski metinden" in m for m in msgs)
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    r = reeltr.package_tr(reel_dir, FakeMedia())
    assert r.packaged == ["practice-prompt"] and [x["segment"] for x in r.missing] == ["practice-explain"]
    doc = json.loads((pkg / "reel.json").read_text(encoding="utf-8"))
    assert set(doc["practice"]["audioTr"]) == {"prompt"}
    assert not (pkg / "audio" / "tr" / "practice-explain.m4a").exists()


def practice_issues(rep) -> list[str]:
    """Alıştırma sesinin uyarıları (H-109 Faz 3 altyazı Türkçesi ayrı test dosyasında)."""
    return [str(i) for i in rep.issues if i.code == "reel.tr-audio" and "altyazı" not in i.message]


def test_package_audio_with_old_text_is_flagged(reel_dir):
    pkg = reel_dir / "_build" / "package"
    pkg.mkdir(parents=True)
    _set(reel_dir, lambda d: d["practice"].update(audioTr={"prompt": {
        "audio": "audio/tr/practice-prompt.m4a", "duration": 1.0, "textSha256": "eski"}}))
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    msgs = [str(i) for i in lint_reel(reel_dir).warnings if i.code == "reel.tr-audio"]
    assert any("ses dosyası yok" in m for m in msgs) and any("başka bir metinden" in m for m in msgs)


def test_trial_reels_have_no_tr_audio_errors():
    for d in sorted(p for p in (REPO / "reeller").iterdir() if p.is_dir()):
        rep = lint_reel(d)
        assert not [i for i in rep.errors if i.code == "reel.tr-audio"], d.name
        assert rep.tr_audio and rep.tr_audio["segments"] == 2


def test_package_failure_leaves_no_link_to_deleted_audio(reel_dir, tmp_path):
    assert run(reel_dir, tmp_path, FakeClient(), "--execute", "--monthly-char-cap", "100000") == 0
    pkg = reel_dir / "_build" / "package"
    pkg.mkdir(parents=True)
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    reeltr.package_tr(reel_dir, FakeMedia())

    class Broken(FakeMedia):
        def audio(self, src, gain, out):
            raise OSError("ffmpeg düştü")
    with pytest.raises(OSError):
        reeltr.package_tr(reel_dir, Broken())
    doc = json.loads((pkg / "reel.json").read_text(encoding="utf-8"))
    assert "audioTr" not in doc["practice"]



def test_failed_segment_build_removes_old_package_audio(reel_dir, tmp_path, monkeypatch):
    # qa bulgusu (2026-11-28): parça kurulumu hata verirse eski audio/tr/*.m4a pakette kalmamalı
    assert run(reel_dir, tmp_path, FakeClient(), "--execute", "--monthly-char-cap", "100000") == 0
    pkg = reel_dir / "_build" / "package"
    pkg.mkdir(parents=True)
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    reeltr.package_tr(reel_dir, FakeMedia())
    assert list((pkg / reeltr.TR_AUDIO_DIR).glob("*.m4a"))

    def boom(*a, **k):
        raise reeltr.ReelTrError("bozuk söyleniş sözlüğü")
    monkeypatch.setattr(reeltr, "seg_audio", boom)
    with pytest.raises(reeltr.ReelTrError):
        reeltr.package_tr(reel_dir, FakeMedia())
    assert not list((pkg / reeltr.TR_AUDIO_DIR).glob("*.m4a"))
    assert "audioTr" not in json.loads((pkg / "reel.json").read_text(encoding="utf-8"))["practice"]
