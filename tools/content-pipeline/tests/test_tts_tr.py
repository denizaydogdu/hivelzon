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
    assert "ücret durumu doğrulanamadı: çevrimdışı" in out and "ilk ay" not in out   # H-108 (conftest)
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
    for f in (tmp_path / "out" / "_raw").glob("*.duyu*.json"):     # ana yanıt önbelleği de (H-114)
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


# --- H-114: defter kilidi, girdi doğrulama, Duyu zamanları -----------------------------------------

def _slow_writes(monkeypatch, module):
    """Okuma ile yazma arasını genişletir: kilitsiz okuma-değiştirme-yazma güncelleme kaybeder."""
    import time as _time
    orig = module._atomic_bytes

    def slow(path, data):
        _time.sleep(0.005)
        orig(path, data)
    monkeypatch.setattr(module, "_atomic_bytes", slow)


def _hammer(fn, n_threads=2, n=15):
    import threading
    errs: list[BaseException] = []

    def work():
        try:
            for _ in range(n):
                fn()
        except BaseException as e:  # noqa: BLE001
            errs.append(e)
    ts = [threading.Thread(target=work) for _ in range(n_threads)]
    for t in ts:
        t.start()
    for t in ts:
        t.join(20)
    assert not errs


def test_h114_tr_ledger_add_concurrent_no_lost_update(tmp_path, monkeypatch):
    led, month = tmp_path / "l.json", tr.month_key()
    _slow_writes(monkeypatch, tr)
    _hammer(lambda: tr.ledger_add(led, month, chars=7, stt_seconds=1.5))
    m = json.loads(led.read_text(encoding="utf-8"))[month]
    assert m == {"characters": 2 * 15 * 7, "calls": 30, "duyuSeconds": 45.0, "duyuCalls": 30}


def test_h114_en_ledger_add_concurrent_no_lost_update(tmp_path, monkeypatch):
    from hvpipeline import tts
    import time as _time
    led, month = tmp_path / "en.json", tts.month_key()
    real_replace = tts.os.replace

    def slow_replace(a, b):
        _time.sleep(0.005)
        real_replace(a, b)
    monkeypatch.setattr(tts.os, "replace", slow_replace)
    _hammer(lambda: tts.ledger_add(led, month, 3))
    assert json.loads(led.read_text(encoding="utf-8"))[month] == {"characters": 90, "calls": 30}


def test_h114_tr_cap_checked_against_concurrent_run(tmp_path):
    """İki eşzamanlı çalıştırma aynı defteri paylaşır; tavana yalnız biri sığar. İkincisi tavanı ilkinin
    harcamasıyla birlikte (kilit altında, çağrıdan hemen önce okunan defterle) denetler ve çağrı yapmaz."""
    import threading
    led, cap = tmp_path / "l.json", len(TEXT1) + 5
    in_call, release = threading.Event(), threading.Event()

    class Slow(FakeClient):
        def speech(self, payload):
            in_call.set()
            release.wait(0.5)
            return super().speech(payload)
    a, b = Slow(), FakeClient()
    res = {}

    def go(name, client):
        plan = tr.plan_segments([tr.Segment("s01", TEXT1)], tmp_path / name)
        res[name] = tr.execute(plan, client, cap, led, tmp_path / f"{name}.md", finalize=fake_finalize,
                               sleep=lambda s: None, log=lambda s: None)
    t1 = threading.Thread(target=go, args=("a", a))
    t1.start()
    assert in_call.wait(5)
    t2 = threading.Thread(target=go, args=("b", b))
    t2.start()
    t2.join(0.2)
    release.set()
    t1.join(10)
    t2.join(10)
    assert len(a.speech_calls) + len(b.speech_calls) == 1
    assert res["b"].stopped and "tavan" in res["b"].stopped
    assert json.loads(led.read_text(encoding="utf-8"))[tr.month_key()]["characters"] == len(TEXT1)


def test_h114_ledger_lock_is_reentrant_and_creates_sidecar(tmp_path):
    from hvpipeline import ledgerlock
    led = tmp_path / "l.json"
    with ledgerlock.ledger_lock(led):
        tr.ledger_add(led, "2026-11", chars=3)       # aynı iş parçacığında kilitlenmez
        assert tr.ledger_used(led, "2026-11") == 3
    assert (tmp_path / "l.json.lock").exists()
    assert json.loads(led.read_text(encoding="utf-8"))["2026-11"]["characters"] == 3   # biçim aynı


@pytest.mark.parametrize("doc,match", [
    ({"segments": [{"id": "a", "text": "Merhaba.", "instructions": 5}]}, "instructions"),
    ({"instructions": ["sıcak"], "segments": [{"id": "a", "text": "Merhaba."}]}, "instructions"),
    ([{"id": "a", "text": "Merhaba.", "pronunciations": "Alex=Aleks"}], "pronunciations"),
    ([{"id": "a", "text": "Merhaba.", "pronunciations": [{"term": "Alex"}]}], "pronunciations"),
    ([{"id": "a", "text": "Merhaba.", "pronunciations": [["Alex", "Aleks"]]}], "pronunciations"),
    (["a"], "parça"),
    ([{"id": "a", "text": None}], "parça"),
    ([{"id": None, "text": "Merhaba."}], "parça"),
    ({"segments": 5}, "parça"),
])
def test_h114_json_segment_fields_validated(tmp_path, doc, match):
    p = tmp_path / "d.json"
    p.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
    with pytest.raises(tr.TrTtsError, match=match):
        tr.load_segments(p)


def test_h114_cli_reports_bad_instructions_without_traceback(tmp_path, capsys):
    p = tmp_path / "d.json"
    p.write_text(json.dumps([{"id": "a", "text": "Merhaba.", "instructions": 5}]), encoding="utf-8")
    assert tts_tr.main([str(p), "--ledger", str(tmp_path / "l.json")]) == 2
    assert "HATA" in capsys.readouterr().err


def test_h114_valid_pronunciations_still_accepted(tmp_path):
    p = tmp_path / "d.json"
    p.write_text(json.dumps([{"id": "a", "text": "Alex geldi.", "instructions": "sakin",
                              "pronunciations": [{"term": "Alex", "say_as": "Aleks"}]}]), encoding="utf-8")
    s = tr.load_segments(p)[0]
    assert s.instructions == "sakin" and s.pronunciations == [{"term": "Alex", "say_as": "Aleks"}]


@pytest.mark.parametrize("bad", [
    {"start": float("nan"), "end": 0.9},
    {"start": 0.5, "end": float("inf")},
    {"start": -0.2, "end": 0.9},
    {"start": 0.9, "end": 0.5},
    {"start": "x", "end": 0.9},
    {"start": None, "end": 0.9},
    {"start": 0.5, "end": 99.0},          # sesin süresinin çok ötesinde
])
def test_h114_invalid_duyu_times_never_reach_alignment(bad):
    text = "Bir iki üç dört"
    words = [{"word": "Bir", "start": 0.0, "end": 0.4}, {"word": "iki", **bad},
             {"word": "üç", "start": 1.0, "end": 1.4}, {"word": "dört", "start": 1.5, "end": 2.0}]
    ws, q = tr.map_words(text, words, duration=2.2)
    import math as _m
    for w in ws:
        assert _m.isfinite(w.start) and _m.isfinite(w.end) and 0.0 <= w.start <= w.end <= 2.2 + 0.5
    assert ws[1].status == "missing" and 0.4 <= ws[1].start <= ws[1].end <= 1.0
    assert not q.ok and any("geçersiz" in m for m in q.warnings)
    al = tr.char_alignment(text, ws)
    assert all(_m.isfinite(x) for x in al.starts + al.ends)


def test_h114_duyu_gaps_ignore_invalid_times():
    words = [{"word": "a", "start": 0.0, "end": 0.4}, {"word": "b", "start": "x", "end": float("nan")},
             {"word": "c", "start": 0.6, "end": 1.0}]
    assert tr.duyu_gaps(words, duration=1.2) == []


def _lock_is_held_elsewhere(ledger) -> bool:
    import fcntl
    import os as _os
    from hvpipeline import ledgerlock
    fd = _os.open(ledgerlock.lock_path(ledger), _os.O_RDWR | _os.O_CREAT, 0o644)
    try:
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        return True
    else:
        fcntl.flock(fd, fcntl.LOCK_UN)
        return False
    finally:
        _os.close(fd)


def test_h114_lesson_en_paid_call_runs_under_ledger_lock(tmp_path):
    import base64 as _b64
    from hvpipeline import lessonaudio
    from hvpipeline.lesson import EnSegment
    led = tmp_path / "en.json"
    seen = []

    def client(voice, payload):
        seen.append(_lock_is_held_elsewhere(led))
        n = len(payload["text"])
        return {"audio_base64": _b64.b64encode(b"ID3").decode(), "alignment": {
            "characters": list(payload["text"]), "character_start_times_seconds": [0.0] * n,
            "character_end_times_seconds": [0.1] * n}}
    plan = lessonaudio.plan_en([EnSegment("e1", "I am here.", "c1", "example")], tmp_path / "en", "v", "m", 1.0)
    try:
        lessonaudio.execute_en(plan, client, 1000, led, tmp_path / "P.md", log=lambda s: None)
    except Exception:   # noqa: BLE001 — sahte mp3 sonraki kurguda düşebilir; burada yalnız kilit sınanır
        pass
    assert seen == [True]
    assert json.loads(led.read_text(encoding="utf-8"))[tr.month_key()]["characters"] == len("I am here.")


def test_h114_fill_gaps_drops_invalid_gap_words():
    class C:
        def transcribe(self, wav, filename):
            return {"words": [{"word": "orta", "start": 0.5, "end": 1.0},
                              {"word": "bozuk", "start": "x", "end": float("nan")}]}, {}
    words = [{"word": "a", "start": 0.0, "end": 0.4}, {"word": "c", "start": 5.0, "end": 5.4}]
    out, spent = tr.fill_gaps(C(), make_wav(6.0), words, "k", sleep=lambda s: None, log=lambda s: None,
                              duration=6.0)
    assert [w["word"] for w in out] == ["a", "orta", "c"] and spent == pytest.approx(4.6)


# --- H-114 ek: kilit beklenirken önbellek yeniden denetlenir (çift ücret yok) ----------------------

class Race:
    """İlk ücretli çağrı `release` gelene (en çok 0,5 sn) kadar bekler; ikinci çalıştırma bu sırada başlar."""

    def __init__(self):
        import threading
        self.in_call, self.release = threading.Event(), threading.Event()
        self.first = True
        self.errors: list[BaseException] = []

    def gate(self):
        if self.first:
            self.first = False
            self.in_call.set()
            self.release.wait(0.5)

    def run(self, first, second):
        import threading

        def wrap(fn):
            def go():
                try:
                    fn()
                except BaseException as e:  # noqa: BLE001 — çağıran sayıları denetler
                    self.errors.append(e)
            return go
        # daemon: gerçek bir kilitlenme test koşusunu asmaz; süreler yavaş CI makinesi için geniş (H-114,
        # CI 45624677439'da 10 sn yetmedi). Bitmeyen iş parçacığı yanlış bir eşitlik hatası yerine açıkça raporlanır.
        t1 = threading.Thread(target=wrap(first), daemon=True)
        t1.start()
        assert self.in_call.wait(30), "ilk çalıştırma ücretli çağrıya ulaşmadı"
        t2 = threading.Thread(target=wrap(second), daemon=True)
        t2.start()
        t2.join(0.2)
        self.release.set()
        t1.join(60)
        t2.join(60)
        alive = [n for n, t in (("ilk", t1), ("ikinci", t2)) if t.is_alive()]
        assert not alive, f"çalıştırma bitmedi (kilitlenme?): {alive}"


def test_h114_tr_same_segment_concurrent_runs_pay_once(tmp_path):
    led, race = tmp_path / "l.json", Race()

    class C(FakeClient):
        def speech(self, payload):
            race.gate()
            return super().speech(payload)
    c = C()

    def go():
        plan = tr.plan_segments([tr.Segment("s01", TEXT1)], tmp_path / "out")
        tr.execute(plan, c, 100_000, led, tmp_path / "P.md", finalize=fake_finalize, sleep=lambda s: None,
                   log=lambda s: None)
    race.run(go, go)
    m = json.loads(led.read_text(encoding="utf-8"))[tr.month_key()]
    assert len(c.speech_calls) == 1 and m["calls"] == 1 and m["characters"] == len(TEXT1)
    assert len(c.stt_calls) == 1 and m["duyuCalls"] == 1


def test_h114_tr_duyu_concurrent_runs_pay_once(tmp_path):
    """Ham WAV önbellekte (yalnız Duyu): iki eşzamanlı çalıştırma Duyu'yu bir kez öder."""
    led, race = tmp_path / "l.json", Race()
    c = FakeClient()
    plan0 = tr.plan_segments([tr.Segment("s01", TEXT1)], tmp_path / "out")
    wav, _ = c.speech(tr.tts_payload(plan0.jobs[0].seg))
    tr._atomic_bytes(plan0.raw_wav(plan0.jobs[0]), wav)

    class C(FakeClient):
        def transcribe(self, w, filename):
            race.gate()
            return c.transcribe(w, filename)
    c2 = C()

    def go():
        plan = tr.plan_segments([tr.Segment("s01", TEXT1)], tmp_path / "out")
        assert plan.jobs[0].action == "stt"
        tr.execute(plan, c2, 100_000, led, tmp_path / "P.md", finalize=fake_finalize, sleep=lambda s: None,
                   log=lambda s: None)
    race.run(go, go)
    assert len(c.stt_calls) == 1
    assert json.loads(led.read_text(encoding="utf-8"))[tr.month_key()]["duyuCalls"] == 1


def test_h114_lesson_en_same_segment_concurrent_runs_pay_once(tmp_path):
    import base64 as _b64
    from hvpipeline import lessonaudio
    from hvpipeline.lesson import EnSegment
    led, race, calls = tmp_path / "en.json", Race(), []

    def client(voice, payload):
        calls.append(payload["text"])
        race.gate()
        n = len(payload["text"])
        return {"audio_base64": _b64.b64encode(b"ID3").decode(), "alignment": {
            "characters": list(payload["text"]), "character_start_times_seconds": [0.0] * n,
            "character_end_times_seconds": [0.1] * n}}

    def go():
        plan = lessonaudio.plan_en([EnSegment("e1", "I am here.", "c1", "example")], tmp_path / "en", "v", "m", 1.0)
        lessonaudio.execute_en(plan, client, 1000, led, tmp_path / "P.md", log=lambda s: None)
    race.run(go, go)
    assert calls == ["I am here."]
    assert json.loads(led.read_text(encoding="utf-8"))[tr.month_key()] == {"characters": 10, "calls": 1}


@pytest.mark.parametrize("bad", [None, 5, ["iki", 0.5, 0.9], {"start": 0.5, "end": 0.9},
                                 {"word": 7, "start": 0.5, "end": 0.9}])
def test_h114_malformed_duyu_word_entries_are_dropped(bad):
    """Duyu `words` içinde sözlük olmayan ya da `word` alanı metin olmayan girdi geçersiz kelimedir."""
    import math as _m
    text = "Bir iki üç dört"
    words = [{"word": "Bir", "start": 0.0, "end": 0.4}, bad,
             {"word": "üç", "start": 1.0, "end": 1.4}, {"word": "dört", "start": 1.5, "end": 2.0}]
    ws, q = tr.map_words(text, words, duration=2.2)
    assert ws[1].status == "missing" and all(_m.isfinite(w.start) and _m.isfinite(w.end) for w in ws)
    assert not q.ok and any("geçersiz" in m for m in q.warnings)
    assert tr.duyu_gaps(words, duration=2.2) == []

    class C:
        def transcribe(self, wav, filename):
            return {"words": [bad, {"word": "orta", "start": 0.5, "end": 1.0}]}, {}
    gap_words = [{"word": "a", "start": 0.0, "end": 0.4}, bad, {"word": "c", "start": 5.0, "end": 5.4}]
    out, _ = tr.fill_gaps(C(), make_wav(6.0), gap_words, "k", sleep=lambda s: None, log=lambda s: None,
                          duration=6.0)
    # özgün listedeki bozuk girdi yerinde kalır (önbelleğe olduğu gibi yazılır; map_words atar), eklenmez
    assert [w["word"] for w in out if tr._word_ok(w)] == ["a", "orta", "c"]
    assert sum(1 for w in out if not tr._word_ok(w)) == (0 if isinstance(bad, dict) and isinstance(bad.get("word"), str) else 1)
