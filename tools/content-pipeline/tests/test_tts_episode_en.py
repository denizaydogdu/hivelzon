"""tts_episode_en.py (H-085): bölüm İngilizce replikleri; kuru çalışma, tavan, eksik ses, idempotent yürütme."""
import base64
import json
from pathlib import Path

import tts_episode_en as en


def setup(tmp_path: Path, jordan_voice: str | None = None) -> tuple[Path, Path]:
    root = tmp_path / "icerik"
    (root / "_evren").mkdir(parents=True)
    voices = {"ALEX": {"name": "Jessica", "voiceId": "v-alex"},
              "JORDAN": {"name": "J" if jordan_voice else None, "voiceId": jordan_voice, "status": "ONAY BEKLİYOR"}}
    (root / "_evren" / "sesler.json").write_text(json.dumps(
        {"episodeEnglish": {"modelId": "eleven_v3", "speed": 0.9, "voices": voices}}), encoding="utf-8")
    ep = root / "A1-905-test"
    (ep / "audio").mkdir(parents=True)
    (ep / "audio_manifest.json").write_text(json.dumps({
        "ALEX|Sorry, I'm late.": "x_01_alex", "JORDAN|No problem!": "x_02_jordan",
        "HI (TR)|Merhaba.": "x_03_hi"}), encoding="utf-8")
    return root, ep


class Fake:
    def __init__(self):
        self.calls = []

    def __call__(self, voice, payload):
        self.calls.append((voice, payload["text"]))
        t = payload["text"]
        return {"audio_base64": base64.b64encode(b"mp3").decode(),
                "alignment": {"characters": list(t), "character_start_times_seconds": [0.0] * len(t),
                              "character_end_times_seconds": [0.1] * len(t)}}


def test_dry_run_counts_and_skips_turkish(tmp_path, capsys):
    root, ep = setup(tmp_path)
    assert en.main([str(ep), "--root", str(root)], client=Fake()) == 0
    out = capsys.readouterr().out
    assert "2 eksik, 27 karakter" in out and "JORDAN" in out and "Merhaba" not in out


def test_execute_blocks_on_missing_voice_and_cap(tmp_path, capsys):
    root, ep = setup(tmp_path)
    f = Fake()
    assert en.main([str(ep), "--root", str(root), "--execute", "--cap", "100", "--ledger", str(tmp_path / "l.json")],
                   client=f) == 1
    root2, ep2 = setup(tmp_path / "b", jordan_voice="v-j")
    assert en.main([str(ep2), "--root", str(root2), "--execute", "--ledger", str(tmp_path / "l.json")], client=f) == 1
    assert en.main([str(ep2), "--root", str(root2), "--execute", "--cap", "10", "--ledger", str(tmp_path / "l.json")],
                   client=f) == 1
    assert f.calls == []


def test_execute_writes_audio_align_ledger_and_is_idempotent(tmp_path):
    root, ep = setup(tmp_path, jordan_voice="v-j")
    led = tmp_path / "l.json"
    f = Fake()
    assert en.main([str(ep), "--root", str(root), "--execute", "--cap", "100", "--ledger", str(led)], client=f) == 0
    assert sorted(f.calls) == [("v-alex", "Sorry, I'm late."), ("v-j", "No problem!")]
    d = json.loads((ep / "audio" / "x_01_alex.align.json").read_text(encoding="utf-8"))
    assert d["text"] == "Sorry, I'm late." and d["lang"] == "en" and d["voice_id"] == "v-alex"
    assert "tts_episode_en.py" in (ep / "PROMPTS.md").read_text(encoding="utf-8")
    assert list(json.loads(led.read_text()).values())[0]["characters"] == 27
    f2 = Fake()
    assert en.main([str(ep), "--root", str(root), "--execute", "--cap", "100", "--ledger", str(led)], client=f2) == 0
    assert f2.calls == []
