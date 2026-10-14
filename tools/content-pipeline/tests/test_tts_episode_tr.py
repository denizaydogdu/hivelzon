"""H-083: bölüm ve Hi verisindeki Türkçe sesler (Alania + Duyu; İngilizce ifadeler Sarah). Ağ yok."""

from __future__ import annotations

import base64
import json
from pathlib import Path

import pytest

import tts_episode_tr
from hvpipeline import hi, media, tts_tr as tr
from hvpipeline import tts_episode_tr as ep
from hvpipeline.align import Alignment
from hvpipeline.build import AudioItem
from hvpipeline.export import is_turkish

from test_tts_tr import FakeClient, fake_finalize

KURGU = """{
  "kurguVersion": 2,
  "contentId": "A1-901",
  "start": "r-k1-b",
  "gate": {},
  "nodes": [
    {
      "id": "r-k1-b", "type": "reaction",
      "bubble": {"speaker": "HI", "lang": "tr", "text": "Böyle de söyleyebilirsin: \\"Again, please.\\"", "speechTr": "Böyle de söyleyebilirsin: {Again, please.}"},
      "next": "h-02"
    },
    {
      "id": "h-02", "type": "card", "kind": "hi", "advance": "tap",
      "lines": [{"speaker": "HI", "text": "Bugün birlikte bakalım.", "lang": "tr"}],
      "audio": "hi_02",
      "next": "c-alex"
    },
    {
      "id": "c-alex", "type": "card", "kind": "line", "advance": "tap",
      "lines": [{"speaker": "ALEX", "text": "Neden orada?", "lang": "tr"}],
      "next": "c-note"
    },
    {
      "id": "c-note", "type": "card", "kind": "note", "advance": "tap", "voiceRole": "nermin",
      "lines": [{"text": "Cuma. Unutma.", "lang": "tr"}, {"text": "— N.", "lang": "tr"}],
      "speechTr": "Cuma. Unutma.",
      "next": "c-en"
    },
    {
      "id": "c-en", "type": "card", "kind": "note", "advance": "tap",
      "lines": [{"text": "The station is near.", "lang": "en"}],
      "next": "c-oq"
    },
    {
      "id": "c-oq", "type": "card", "kind": "openQuestion", "advance": "tap", "questionId": "Q1",
      "lines": [{"text": "AÇIK SORU", "lang": "tr", "style": "caption"}, {"text": "Kim olacak?", "lang": "tr", "style": "heading"}],
      "speechTr": "Açık soru: Kim olacak?",
      "next": null
    }
  ]
}
"""


def voice_map(root: Path, ledger: Path) -> None:
    (root / "_evren").mkdir(parents=True, exist_ok=True)
    roles = {"hi": {"voice": "alania2-f1", "speaker": "HI"},
             "alex": {"voice": "alania2-nisa", "speaker": "ALEX (TR)"},
             "nermin": {"voice": "alania2-selin", "speaker": "NERMIN (TR)", "instructions": "yavaş, sıcak"},
             "narrator": {"voice": "alania2-m1", "speaker": "ANLATICI (TR)"}}
    doc = {"schemaVersion": 1, "turkish": {"model": "alania-v2", "roles": roles},
           "english": {"voiceId": "EXAVITQu4vr4xnSDxMaL", "name": "Sarah", "modelId": "eleven_v3", "speed": 0.9,
                       "keyFile": str(root / "yok.env"), "ledger": str(ledger), "monthlyCharCap": 10000},
           "mixed": {"default": "b", "gap": 0.15},
           "pronunciations": [{"term": "Again, please", "say_as": "Egeyn pliiz"}]}
    (root / ep.VOICE_MAP_FILE).write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")


@pytest.fixture
def root(tmp_path):
    r = tmp_path / "icerik"
    voice_map(r, tmp_path / "en-ledger.json")
    d = r / "A1-901-test"
    (d / "audio").mkdir(parents=True)
    (d / "kurgu.json").write_text(KURGU, encoding="utf-8")
    (r / "_evren" / "kopru-gorevleri.json").write_text(json.dumps({"schemaVersion": 1, "status": "DRAFT", "tasks": [
        {"id": "bt-a1-901", "contentId": "A1-901", "titleTr": "Dene", "textTr": "İçinden \"Yes, I can.\" de.",
         "speechTr": "İçinden {Yes, I can.} de."}]}, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return r


def en_mp3(tmp_path: Path) -> bytes:
    p = tmp_path / "en.mp3"
    if not p.exists():
        media.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i", "sine=frequency=440:duration=0.6",
                   "-c:a", "libmp3lame", "-b:a", "128k", str(p)])
    return p.read_bytes()


class FakeEn:
    def __init__(self, tmp_path):
        self.calls: list[str] = []
        self.audio = base64.b64encode(en_mp3(tmp_path)).decode()

    def __call__(self, voice, payload):
        text = payload["text"]
        self.calls.append(text)
        n = len(text)
        return {"audio_base64": self.audio, "alignment": {
            "characters": list(text), "character_start_times_seconds": [0.05 + 0.04 * k for k in range(n)],
            "character_end_times_seconds": [0.09 + 0.04 * k for k in range(n)]}}


def run(root, ep_dir, tr_client, en_client, *extra):
    return tts_episode_tr.main([str(ep_dir), "--hi", "--root", str(root), *extra], tr_client=tr_client,
                               en_client=en_client, finalize=fake_finalize, sleep=lambda s: None)


# --- metin ve toplama ----------------------------------------------------------------------------

def test_split_marked_and_plain():
    s = "Soru {Can you…?} ile başlıyorsa cevap {Yes, I can.} olur."
    assert [(p.lang, p.text) for p in ep.split_marked(s)] == [
        ("tr", "Soru"), ("en", "Can you…?"), ("tr", "ile başlıyorsa cevap"), ("en", "Yes, I can."), ("tr", "olur.")]
    assert ep.plain(s) == "Soru Can you…? ile başlıyorsa cevap Yes, I can. olur."
    with pytest.raises(ep.EpisodeTtsError, match="işaret"):
        ep.split_marked("Bozuk {işaret")


def test_collect_roles_modes_and_stems(root):
    vm = ep.VoiceMap.load(root)
    items = {it.stem: it for it in ep.collect_episode(root / "A1-901-test", vm)}
    assert set(items) == {"tr_r-k1-b", "hi_02", "tr_c-alex", "tr_c-note", "tr_c-oq"}   # İngilizce not kartı yok
    assert (items["tr_r-k1-b"].role, items["tr_r-k1-b"].mode) == ("hi", "b")
    assert (items["hi_02"].role, items["hi_02"].mode, items["hi_02"].has_ref) == ("hi", "tr", True)
    assert items["tr_c-alex"].role == "alex" and items["tr_c-note"].role == "nermin"
    assert items["tr_c-oq"].role == "narrator" and items["tr_c-oq"].text == "Açık soru: Kim olacak?"
    hi_items = ep.collect_hi(root, vm)
    assert [(i.stem, i.mode) for i in hi_items] == [("bridge-bt-a1-901", "b")]


def test_voice_map_requires_alania(root):
    p = root / ep.VOICE_MAP_FILE
    d = json.loads(p.read_text(encoding="utf-8"))
    d["turkish"]["roles"]["hi"]["voice"] = "SAz9YHcvj6GT2YYXdXww"
    p.write_text(json.dumps(d), encoding="utf-8")
    with pytest.raises(ep.EpisodeTtsError, match="Alania"):
        ep.VoiceMap.load(root)


def test_insert_key_keeps_hand_format():
    text = '{\n  "nodes": [\n    {\n      "id": "a", "bubble": {"text": "x"},\n      "next": null\n    }\n  ]\n}\n'
    out = ep.insert_key(text, ("nodes", 0, "bubble"), "audio", {"id": "tr_a", "speaker": "HI"})
    assert '"bubble": {"text": "x", "audio": {"id": "tr_a", "speaker": "HI"}},' in out
    out2 = ep.insert_key(out, ("nodes", 0), "speechTr", "y")
    assert '"next": null, "speechTr": "y"\n    }' in out2
    assert json.loads(out2)["nodes"][0]["speechTr"] == "y"


def test_pronunciations_only_for_terms_in_text(root):
    vm = ep.VoiceMap.load(root)
    assert vm.pron_for("Söyle: Again, please.") == [{"term": "Again, please", "say_as": "Egeyn pliiz"}]
    assert vm.pron_for("Tekrar söyle.") is None


# --- kuru çalışma ve yürütme ---------------------------------------------------------------------

def test_dry_run_counts_and_never_calls(root, capsys, monkeypatch):
    monkeypatch.delenv(tr.ENV_CAP, raising=False)

    class Boom:
        def speech(self, *a):
            raise AssertionError("kuru çalışmada API çağrılmamalı")
        transcribe = speech

    def boom_en(*a):
        raise AssertionError("kuru çalışmada ElevenLabs çağrılmamalı")
    assert run(root, root / "A1-901-test", Boom(), boom_en) == 0
    out = capsys.readouterr().out
    assert "Kuru çalışma" in out and "İngilizce 25 karakter" in out and "TANIMLI DEĞİL" in out
    assert not (root / "A1-901-test" / "audio" / "hi_02.mp3").exists()


def test_execute_builds_all_updates_sources_and_is_idempotent(root, tmp_path, monkeypatch, capsys):
    monkeypatch.setenv(tr.ENV_CAP, "100000")
    monkeypatch.setenv(tr.ENV_LEDGER, str(tmp_path / "tr-ledger.json"))
    epd = root / "A1-901-test"
    # Eski ElevenLabs sesi: yedeklenir, silinmez.
    (epd / "audio" / "hi_02.mp3").write_bytes(b"eski")
    (epd / "audio" / "hi_02.align.json").write_text(json.dumps({"text": "x", "voice_id": "River", "lang": "tr",
                                                                "alignment": {}}), encoding="utf-8")
    fc, fe = FakeClient(), FakeEn(tmp_path)
    assert run(root, epd, fc, fe, "--execute") == 0
    assert (epd / "audio" / "_raw" / "elevenlabs" / "hi_02.mp3").read_bytes() == b"eski"
    # İngilizce ifadeler Sarah'ya, yalnız bir kez (aynı ifade tek ücret)
    assert sorted(fe.calls) == ["Again, please.", "Yes, I can."]
    assert json.loads((tmp_path / "en-ledger.json").read_text())[tr.month_key()]["characters"] == 25
    # b kipi: birleşik hizalama düz metinle aynı, parçalar kayıtlı
    d = json.loads((epd / "audio" / "tr_r-k1-b.align.json").read_text(encoding="utf-8"))
    assert d["text"] == "Böyle de söyleyebilirsin: Again, please." and d["variant"] == "b"
    assert [p["lang"] for p in d["parts"]] == ["tr", "en"] and d["voice_id"] == "alania2-f1"
    assert "".join(Alignment.load(epd / "audio" / "tr_r-k1-b.align.json").chars) == d["text"]
    # rol sesleri
    voices = {p["voice"] for p in fc.speech_calls}
    assert voices == {"alania2-f1", "alania2-nisa", "alania2-selin", "alania2-m1"}
    nermin = next(p for p in fc.speech_calls if p["voice"] == "alania2-selin")
    assert nermin["instructions"] == "yavaş, sıcak" and nermin["input"] == "Cuma. Unutma."
    # kaynaklar güncellendi: kurgu.json (el biçimi) ve Hi verisi
    k = json.loads((epd / "kurgu.json").read_text(encoding="utf-8"))
    nodes = {n["id"]: n for n in k["nodes"]}
    assert nodes["r-k1-b"]["bubble"]["audio"] == {"id": "tr_r-k1-b", "speaker": "HI"}
    assert nodes["c-alex"]["audio"] == {"id": "tr_c-alex", "speaker": "ALEX (TR)"}
    assert nodes["h-02"]["audio"] == "hi_02"
    assert "c-en" in nodes and "audio" not in nodes["c-en"]
    b = json.loads((root / "_evren" / "kopru-gorevleri.json").read_text(encoding="utf-8"))
    assert b["tasks"][0]["audio"] == "hi-ses/bridge-bt-a1-901.mp3"
    assert (root / "_evren" / "hi-ses" / "bridge-bt-a1-901.align.json").exists()
    # Kayıt: Türkçe ve İngilizce çağrılar PROMPTS.md'de
    prompts = (epd / "PROMPTS.md").read_text(encoding="utf-8")
    assert "tts_tr.py" in prompts and ep.EN_PROMPTS_HEADING in prompts
    # denetim temiz
    vm = ep.VoiceMap.load(root)
    assert [i for i in ep.check_items(ep.collect_episode(epd, vm)) if i[0] == "error"] == []
    # ikinci çalıştırma: hiçbir çağrı yok
    fc2 = FakeClient()

    def boom_en(*a):
        raise AssertionError("güncel seste ElevenLabs çağrılmamalı")
    capsys.readouterr()
    assert run(root, epd, fc2, boom_en, "--execute") == 0
    assert fc2.speech_calls == [] and fc2.stt_calls == []
    assert "0 ses kuruldu" in capsys.readouterr().out


def test_en_cap_blocks_before_any_call(root, tmp_path, monkeypatch, capsys):
    monkeypatch.setenv(tr.ENV_CAP, "100000")
    monkeypatch.setenv(tr.ENV_LEDGER, str(tmp_path / "tr-ledger.json"))
    fc = FakeClient()

    def boom_en(*a):
        raise AssertionError("tavan aşılınca çağrı yok")
    assert run(root, root / "A1-901-test", fc, boom_en, "--execute", "--en-cap", "10") == 1
    assert fc.speech_calls == [] and "tavan" in capsys.readouterr().err


def test_stale_text_is_lint_error(root, tmp_path, monkeypatch):
    monkeypatch.setenv(tr.ENV_CAP, "100000")
    monkeypatch.setenv(tr.ENV_LEDGER, str(tmp_path / "tr-ledger.json"))
    epd = root / "A1-901-test"
    assert run(root, epd, FakeClient(), FakeEn(tmp_path), "--execute") == 0
    k = (epd / "kurgu.json").read_text(encoding="utf-8").replace("Neden orada?", "Neden şimdi orada?")
    (epd / "kurgu.json").write_text(k, encoding="utf-8")
    errs = [i for i in ep.check_items(ep.collect_episode(epd, ep.VoiceMap.load(root))) if i[0] == "error"]
    assert len(errs) == 1 and "güncel değil" in errs[0][2]


# --- dışa aktarma --------------------------------------------------------------------------------

def test_is_turkish_clip(tmp_path):
    al = tmp_path / "x.align.json"
    al.write_text(json.dumps({"lang": "tr"}), encoding="utf-8")
    assert is_turkish(AudioItem("k", tmp_path / "x.mp3", al, "ANLATICI (TR)"))
    assert is_turkish(AudioItem("k", tmp_path / "y.mp3", tmp_path / "yok.json", "HI"))
    assert not is_turkish(AudioItem("k", tmp_path / "y.mp3", tmp_path / "yok.json", "MAYA"))


def test_hi_export_audio(tmp_path):
    root = tmp_path
    (root / "_evren" / "hi-ses").mkdir(parents=True)
    (root / "_evren" / "hi-ses" / "bridge-x.mp3").write_bytes(b"mp3")
    entries = [{"id": "x", "textTr": "a", "speechTr": "a", "audio": "hi-ses/bridge-x.mp3"},
               {"id": "y", "textTr": "b", "audio": "hi-ses/bridge-y.mp3"}, {"id": "z", "textTr": "c"}]
    written = []
    missing: list[str] = []
    out = hi._with_audio(entries, root, tmp_path / "pkg",
                         lambda s, o: (written.append((s.name, o.name)), o.write_bytes(b"m4a")), missing)
    assert out[0] == {"id": "x", "textTr": "a", "audio": "hi/bridge-x.m4a"}
    assert "audio" not in out[1] and missing == ["hi-ses/bridge-y.mp3"]
    assert out[2] == {"id": "z", "textTr": "c"}
    assert written == [("bridge-x.mp3", "bridge-x.m4a")]
