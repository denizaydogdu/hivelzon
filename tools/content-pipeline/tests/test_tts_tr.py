"""H-075: Türkçe anlatım (Alania + Duyu). Ağ yok: sahte istemci."""

from __future__ import annotations

import io
import json
import shutil
import wave
from pathlib import Path

import pytest

import tts_tr
from hvpipeline import media, tts_tr as tr
from hvpipeline.align import Alignment, sentence_timings, locate

SECRET = "pd_test_DO_NOT_WRITE_0123456789"
TEXT1 = "Merhaba Alex! Bu kelimenin anlamı: kapı. Hadi birlikte söyleyelim."
TEXT2 = "İngilizcede he, she ve it ile fiile -s takısı gelir."


def make_wav(seconds: float, rate: int = 48000) -> bytes:
    buf = io.BytesIO()
    with wave.open(buf, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(b"\x00\x00" * int(seconds * rate))
    return buf.getvalue()


def fake_words(text: str, t0: float = 0.2, per_char: float = 0.06, gap: float = 0.05, replace=None) -> list[dict]:
    """Duyu benzeri kelimeler: noktalama kelimeye yapışık; `replace` ile yanlış duyma."""
    out, t = [], t0
    for w in text.split():
        d = per_char * len(w)
        word = (replace or {}).get(w, w)
        if word:
            out.append({"word": word, "start": round(t, 3), "end": round(t + d, 3)})
        t += d + gap
    return out


class FakeClient:
    def __init__(self, replace=None, rate_limit_first: int = 0):
        self.speech_calls: list[dict] = []
        self.stt_calls: list[str] = []
        self.replace = replace or {}
        self.rate_limit_first = rate_limit_first
        self.last_text = {}

    def speech(self, payload):
        if self.rate_limit_first:
            self.rate_limit_first -= 1
            raise tr.RateLimited(2.5)
        self.speech_calls.append(payload)
        wav = make_wav(0.4 + 0.065 * len(payload["input"]))
        self.last_text[len(wav)] = payload["input"]
        return wav, {"x-characters": str(len(payload["input"])), "x-audio-seconds": "3.10",
                     "x-request-id": f"req-{len(self.speech_calls)}", "x-model-release": "2026.10.1"}

    def transcribe(self, wav, filename):
        self.stt_calls.append(filename)
        text = self.last_text[len(wav)]
        words = fake_words(text, replace=self.replace)
        return ({"text": " ".join(w["word"] for w in words), "words": words, "language": "tr",
                 "duration": tr.wav_duration(wav)}, {"x-request-id": f"stt-{len(self.stt_calls)}"})


def fake_finalize(wav: Path, out: Path):
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(b"ID3-fake" + wav.read_bytes()[:16])
    return -16.0


@pytest.fixture
def seg_file(tmp_path):
    p = tmp_path / "ders.json"
    p.write_text(json.dumps({"instructions": "sıcak, sakin", "segments": [
        {"id": "s01", "text": TEXT1}, {"id": "s02", "text": TEXT2}]}, ensure_ascii=False), encoding="utf-8")
    return p


def run(seg_file, tmp_path, client, *extra):
    return tts_tr.main([str(seg_file), "--out-dir", str(tmp_path / "out"), "--ledger", str(tmp_path / "l.json"),
                        "--prompts", str(tmp_path / "PROMPTS.md"), *extra],
                       client=client, finalize=fake_finalize, sleep=lambda s: None)


# --- girdi ---------------------------------------------------------------------------------------

def test_markdown_segments(tmp_path):
    p = tmp_path / "d.md"
    p.write_text("# Başlık\n<!-- not -->\n## g1\nBirinci satır\nikinci satır.\n\n## g2\nİkinci parça.\n",
                 encoding="utf-8")
    segs = tr.load_segments(p)
    assert [(s.id, s.text) for s in segs] == [("g1", "Birinci satır ikinci satır."), ("g2", "İkinci parça.")]


def test_segment_validation(tmp_path):
    p = tmp_path / "d.json"
    p.write_text(json.dumps([{"id": "a", "text": "x"}, {"id": "a", "text": "y"}]), encoding="utf-8")
    with pytest.raises(tr.TrTtsError, match="tekrar"):
        tr.load_segments(p)
    p.write_text(json.dumps([{"id": "a", "text": "x" * (tr.MAX_CHARS + 1)}]), encoding="utf-8")
    with pytest.raises(tr.TrTtsError, match="sınır"):
        tr.load_segments(p)


# --- kuru çalışma, tavan, idempotentlik ----------------------------------------------------------

def test_dry_run_never_calls_api(seg_file, tmp_path, capsys, monkeypatch):
    monkeypatch.setenv(tr.ENV_KEY, SECRET)
    monkeypatch.delenv(tr.ENV_CAP, raising=False)

    class Boom:
        def speech(self, *a):
            raise AssertionError("kuru çalışmada API çağrılmamalı")
        transcribe = speech
    assert run(seg_file, tmp_path, Boom()) == 0
    out = capsys.readouterr().out
    n = len(TEXT1) + len(TEXT2)
    assert "Kuru çalışma" in out and f"{n} karakter" in out and "TL" in out and "TANIMLI DEĞİL" in out
    assert SECRET not in out
    assert not (tmp_path / "l.json").exists() and not (tmp_path / "out").exists()


def test_execute_refused_without_cap(seg_file, tmp_path, monkeypatch, capsys):
    monkeypatch.delenv(tr.ENV_CAP, raising=False)
    fc = FakeClient()
    assert run(seg_file, tmp_path, fc, "--execute") == 1
    assert fc.speech_calls == [] and "tavan" in capsys.readouterr().err
    with pytest.raises(tr.TrTtsError, match="tavan"):
        tr.execute(tr.plan_segments(tr.load_segments(seg_file), tmp_path / "o"), fc, None,
                   tmp_path / "l.json", tmp_path / "P.md")


def test_cap_stops_before_call(seg_file, tmp_path):
    tr.ledger_add(tmp_path / "l.json", tr.month_key(), chars=1990)
    fc = FakeClient()
    assert run(seg_file, tmp_path, fc, "--execute", "--monthly-char-cap", "2000") == 1
    assert fc.speech_calls == []
    assert not (tmp_path / "out" / "s01.mp3").exists()


def test_execute_writes_outputs_logs_and_is_idempotent(seg_file, tmp_path, monkeypatch, capsys):
    monkeypatch.setenv(tr.ENV_KEY, SECRET)
    fc = FakeClient()
    assert run(seg_file, tmp_path, fc, "--execute", "--monthly-char-cap", "2000") == 0
    assert len(fc.speech_calls) == 2 and len(fc.stt_calls) == 2
    p = fc.speech_calls[0]
    assert p == {"model": "alania-v2", "voice": "alania2-f1", "input": TEXT1, "instructions": "sıcak, sakin"}
    out = tmp_path / "out"
    doc = json.loads((out / "s01.align.json").read_text(encoding="utf-8"))
    assert doc["textSha256"] == tr.text_sha256(TEXT1) and doc["quality"]["ok"] is True
    assert doc["lang"] == "tr" and doc["loudnessLufs"] == -16.0
    assert (out / "s01.mp3").read_bytes().startswith(b"ID3-fake")
    ledger = json.loads((tmp_path / "l.json").read_text(encoding="utf-8"))[tr.month_key()]
    assert ledger["characters"] == len(TEXT1) + len(TEXT2) and ledger["calls"] == 2 and ledger["duyuCalls"] == 2
    prompts = (tmp_path / "PROMPTS.md").read_text(encoding="utf-8")
    assert tr.PROMPTS_HEADING in prompts
    assert f"| s01 | alania-v2 | alania2-f1 | 2026.10.1 | {len(TEXT1)} | 3.1 | req-1 | {tr.text_sha256(TEXT1)[:16]} |" in prompts
    assert "| s01 | duyu-1 | - |" in prompts
    for f in [*tmp_path.rglob("*")]:
        if f.is_file():
            assert SECRET.encode() not in f.read_bytes(), f
    assert SECRET not in capsys.readouterr().out
    # ikinci çalışma: hiç çağrı yok, kayıt değişmez
    fc2 = FakeClient()
    assert run(seg_file, tmp_path, fc2, "--execute", "--monthly-char-cap", "2000") == 0
    assert fc2.speech_calls == [] and fc2.stt_calls == []
    assert prompts == (tmp_path / "PROMPTS.md").read_text(encoding="utf-8")
    # çıktılar silinse de ödenmiş ham ses ve Duyu önbellekten gelir
    (out / "s01.mp3").unlink()
    (out / "s01.align.json").unlink()
    plan = tr.plan_segments(tr.load_segments(seg_file), out)
    assert [j.action for j in plan.jobs] == ["build", "skip"] and plan.billable_chars == 0
    assert run(seg_file, tmp_path, fc2, "--execute", "--monthly-char-cap", "2000") == 0
    assert fc2.speech_calls == [] and (out / "s01.align.json").exists()
    # metin değişince yalnız o parça yeniden üretilir
    d = json.loads(seg_file.read_text(encoding="utf-8"))
    d["segments"][1]["text"] = TEXT2.replace("gelir", "eklenir")
    seg_file.write_text(json.dumps(d, ensure_ascii=False), encoding="utf-8")
    plan = tr.plan_segments(tr.load_segments(seg_file), out)
    assert [j.action for j in plan.jobs] == ["skip", "tts"]


def test_stt_only_when_raw_audio_cached(seg_file, tmp_path):
    fc = FakeClient()
    assert run(seg_file, tmp_path, fc, "--execute", "--monthly-char-cap", "2000") == 0
    for f in (tmp_path / "out" / "_raw").glob("*.duyu.json"):
        f.unlink()
    (tmp_path / "out" / "s01.mp3").unlink()
    fc2 = FakeClient()
    fc2.last_text = fc.last_text
    assert run(seg_file, tmp_path, fc2, "--execute", "--monthly-char-cap", "2000") == 0
    assert fc2.speech_calls == [] and len(fc2.stt_calls) == 1


def test_retry_after_honoured(seg_file, tmp_path):
    fc = FakeClient(rate_limit_first=2)
    slept = []
    plan = tr.plan_segments(tr.load_segments(seg_file), tmp_path / "out")
    r = tr.execute(plan, fc, 2000, tmp_path / "l.json", tmp_path / "P.md", finalize=fake_finalize,
                   sleep=slept.append, log=lambda s: None)
    assert slept == [2.5, 2.5] and len(fc.speech_calls) == 2 and len(r.done) == 2
    # vazgeçme: hep 429
    fc = FakeClient(rate_limit_first=99)
    with pytest.raises(tr.TrTtsError, match="429"):
        tr.with_retry(fc.speech, {"input": "x"}, sleep=lambda s: None, log=lambda s: None)


def test_credentials_from_file_and_env(tmp_path, monkeypatch):
    f = tmp_path / "pd.env"
    f.write_text(f"export PD_API_KEY='{SECRET}'\nPD_API_URL=https://voice.example\n", encoding="utf-8")
    monkeypatch.delenv(tr.ENV_KEY, raising=False)
    monkeypatch.delenv(tr.ENV_URL, raising=False)
    assert tr.load_credentials(f) == (SECRET, "https://voice.example")
    monkeypatch.setenv(tr.ENV_KEY, "envkey")
    assert tr.load_credentials(f)[0] == "envkey"
    monkeypatch.delenv(tr.ENV_KEY)
    with pytest.raises(tr.TrTtsError, match=tr.ENV_KEY):
        tr.load_credentials(tmp_path / "none.env")
    c = tr.HttpClient(key_file=f)
    assert SECRET not in repr(vars(c).get("base"))


# --- hizalama ------------------------------------------------------------------------------------

def test_mapping_exact_with_punctuation_and_case():
    words = fake_words(TEXT1)
    words[0]["word"] = "merhaba"         # küçük harf
    words[4]["word"] = "anlamı"          # iki nokta düşmüş
    mapped, q = tr.map_words(TEXT1, words, 6.0)
    assert [w.token.text for w in mapped] == ["Merhaba", "Alex", "Bu", "kelimenin", "anlamı", "kapı", "Hadi",
                                              "birlikte", "söyleyelim"]
    assert q.ok and q.exact == 9
    assert mapped[5].start == words[5]["start"] and mapped[5].end == words[5]["end"]


def test_mapping_mishearing_is_fuzzy_and_positioned():
    words = fake_words(TEXT1, replace={"kapı.": "kapu.", "Alex!": "Aleks!"})
    mapped, q = tr.map_words(TEXT1, words, 6.0)
    by = {w.token.text: w for w in mapped}
    assert by["kapı"].status == "fuzzy" and by["kapı"].heard == "kapu."
    assert by["kapı"].start == words[5]["start"]
    assert by["Alex"].status in ("fuzzy", "weak") and by["Alex"].start == words[1]["start"]
    assert q.ok    # tek tük yanlış duyma uyarı değildir


def test_mapping_dropped_and_garbled_words_warn():
    # Duyu iki kelimeyi hiç duymamış, iki kelimeyi tamamen başka duymuş
    words = fake_words(TEXT1, replace={"Bu": "", "kelimenin": "", "Hadi": "saat", "birlikte": "yedide"})
    mapped, q = tr.map_words(TEXT1, words, 6.0)
    assert len(mapped) == 9 and not q.ok and q.warnings
    by = {w.token.text: w for w in mapped}
    assert by["Bu"].status == "missing" and by["kelimenin"].status == "missing"
    # eksik kelimeler komşuların arasına, sırayla yerleşir
    assert by["Alex"].end <= by["Bu"].start <= by["kelimenin"].start <= by["anlamı"].start
    starts = [w.start for w in mapped]
    assert starts == sorted(starts)


def test_mapping_split_and_merge():
    text = "Hadi birlikte söyleyelim."
    words = [{"word": "Hadi", "start": 0.1, "end": 0.4}, {"word": "bir", "start": 0.45, "end": 0.6},
             {"word": "likte", "start": 0.6, "end": 0.9}, {"word": "söyleyelim.", "start": 0.95, "end": 1.6}]
    mapped, q = tr.map_words(text, words, 2.0)
    assert q.ok and mapped[1].start == 0.45 and mapped[1].end == 0.9
    text2 = "Hi'nin bu derste dediği şu."
    words2 = fake_words("Hi'nin buderste dediği şu.")
    mapped2, q2 = tr.map_words(text2, words2, 3.0)
    assert [w.token.text for w in mapped2] == ["Hi'nin", "bu", "derste", "dediği", "şu"]
    assert mapped2[1].start == words2[1]["start"] and mapped2[2].end == words2[1]["end"]


def test_char_alignment_compatible_with_align_py(tmp_path):
    words = fake_words(TEXT1)
    mapped, _ = tr.map_words(TEXT1, words, 6.0)
    al = tr.char_alignment(TEXT1, mapped)
    assert al.text == TEXT1 and len(al.starts) == len(al.ends) == len(TEXT1)
    assert all(s <= e for s, e in zip(al.starts, al.ends))
    assert al.starts == sorted(al.starts) and al.ends == sorted(al.ends)
    # noktalama sıfır süreli, önceki kelimenin sonunda
    i = TEXT1.index("!")
    assert al.starts[i] == al.ends[i] == pytest.approx(mapped[1].end)
    # dosyaya yaz → align.py okur → cümle zamanları Duyu kelime zamanlarına eşit
    p = tmp_path / "s.align.json"
    p.write_text(json.dumps({"alignment": tr.alignment_json(al)}), encoding="utf-8")
    back = Alignment.load(p)
    sents = ["Merhaba Alex!", "Bu kelimenin anlamı: kapı.", "Hadi birlikte söyleyelim."]
    t = sentence_timings(back, sents)
    assert t[0]["start"] == pytest.approx(words[0]["start"], abs=1e-3)
    assert t[1]["words"][0]["w"] == "Bu" and t[1]["words"][0]["start"] == pytest.approx(words[2]["start"], abs=1e-3)
    assert t[2]["end"] == pytest.approx(words[-1]["end"], abs=1e-3)
    assert len(locate(back, sents)) == 3


@pytest.mark.skipif(not shutil.which("ffmpeg"), reason="ffmpeg yok")
def test_finalize_audio_hits_target_loudness(tmp_path):
    import math
    import struct
    rate = 48000
    frames = b"".join(struct.pack("<h", int(3000 * math.sin(2 * math.pi * 220 * n / rate))) for n in range(rate * 2))
    src = tmp_path / "a.wav"
    with wave.open(str(src), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(frames)
    lufs = tr.finalize_audio(src, tmp_path / "a.mp3")
    assert (tmp_path / "a.mp3").exists() and abs(lufs - media.TARGET_LUFS) < 1.0
