"""H-114 (son tur): harcama hemen deftere, Duyu ana yanıt önbelleği, PROMPTS eşzamanlılığı, kilit bekleme
bildirimi, ay anahtarı, önbellek tahmini ve ses dosyası adı doğrulaması. Ağ yok: sahte istemciler."""

from __future__ import annotations

import base64
import json
import threading
import time
from pathlib import Path
from types import SimpleNamespace

import pytest

import tts_episode_en
import tts_episode_tr
import tts_reel
from hvpipeline import ledgerlock, lessonaudio, tts, tts_tr as tr
from hvpipeline import tts_episode_tr as ep
from hvpipeline.book import Book
from hvpipeline.lesson import EnSegment

from test_tts_tr import TEXT1, FakeClient, fake_finalize, make_wav

MONTH = tr.month_key()


def _month(led: Path) -> dict:
    return json.loads(led.read_text(encoding="utf-8"))[MONTH]


def _bad_en(voice, payload):
    """ElevenLabs HTTP 200 ama gövde bozuk (alignment yok): ücret yine de ödenmiştir."""
    return {"audio_base64": base64.b64encode(b"ID3").decode()}


# --- A: ücretli çağrı döner dönmez defter ----------------------------------------------------------

def test_a_tr_malformed_alania_body_is_still_recorded(tmp_path):
    class C(FakeClient):
        def speech(self, payload):
            self.speech_calls.append(payload)
            return b"<html>hata</html>", {}
    led, plan = tmp_path / "l.json", tr.plan_segments([tr.Segment("s01", TEXT1)], tmp_path / "out")
    with pytest.raises(tr.TrTtsError, match="WAV"):
        tr.execute(plan, C(), 100_000, led, tmp_path / "P.md", finalize=fake_finalize, log=lambda s: None)
    assert _month(led)["characters"] == len(TEXT1) and _month(led)["calls"] == 1
    assert not plan.raw_wav(plan.jobs[0]).exists()


def test_a_tr_order_ledger_then_cache_then_prompts(tmp_path, monkeypatch):
    def boom(*a, **k):
        raise OSError("PROMPTS yazılamadı")
    monkeypatch.setattr(tr, "append_prompts", boom)
    led, plan = tmp_path / "l.json", tr.plan_segments([tr.Segment("s01", TEXT1)], tmp_path / "out")
    with pytest.raises(OSError):
        tr.execute(plan, FakeClient(), 100_000, led, tmp_path / "P.md", finalize=fake_finalize, log=lambda s: None)
    assert _month(led)["characters"] == len(TEXT1) and plan.raw_wav(plan.jobs[0]).exists()


def test_a_lesson_en_malformed_body_is_still_recorded(tmp_path):
    led = tmp_path / "en.json"
    plan = lessonaudio.plan_en([EnSegment("e1", "I am here.", "c1", "example")], tmp_path / "en", "v", "m", 1.0)
    with pytest.raises(tts.TtsError):
        lessonaudio.execute_en(plan, _bad_en, 1000, led, tmp_path / "P.md", log=lambda s: None)
    assert _month(led) == {"characters": 10, "calls": 1}


def test_a_run_en_malformed_body_is_still_recorded(tmp_path):
    led = tmp_path / "en.json"
    piece = ep.EnPiece("x1", "Again, please.", "kx", tmp_path / "o", tmp_path / "P.md")
    with pytest.raises(ep.EpisodeTtsError):
        ep.run_en([piece], {"voiceId": "v", "modelId": "m", "speed": 1.0, "name": "S"}, _bad_en, 1000, led,
                  log=lambda s: None)
    assert _month(led) == {"characters": 14, "calls": 1}


def test_a_book_malformed_body_is_still_recorded(tmp_path):
    from test_books import FX
    import shutil
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    for f in (d / "audio").glob("*"):
        f.unlink()
    led, plan = tmp_path / "l.json", tts.plan_book(Book.load(d))
    with pytest.raises(tts.TtsError):
        tts.execute(plan, _bad_en, 100_000, led, log=lambda s: None)
    assert _month(led)["calls"] == 1 and _month(led)["characters"] == len(plan.jobs[0].parts[0])


def test_a_episode_en_malformed_body_is_still_recorded(tmp_path):
    from test_tts_episode_en import setup
    root, epd = setup(tmp_path)
    led = tmp_path / "l.json"
    assert tts_episode_en.main([str(epd), "--root", str(root), "--execute", "--cap", "100", "--only", "x_01_alex",
                                "--ledger", str(led)], client=_bad_en) == 1
    assert _month(led) == {"characters": len("Sorry, I'm late."), "calls": 1}


def _reel_setup(tmp_path, monkeypatch, client, rid="A1-R-SPO-09", cues=("Here you go.",)):
    monkeypatch.chdir(tmp_path)
    (tmp_path / "reeller").mkdir(exist_ok=True)
    led = tmp_path / "ledger.json"
    monkeypatch.setattr(tts_reel.T, "ledger_path", lambda _: led)
    monkeypatch.setattr(tts_reel.T, "http_client", lambda: client)
    monkeypatch.setattr(tts_reel, "_duration", lambda _: 1.0)
    root = tmp_path / rid
    root.mkdir()
    (root / "reel.json").write_text(json.dumps({"id": rid, "cues": [
        {"id": f"s01-0{k}", "speaker": "ELIF", "text": t} for k, t in enumerate(cues, start=1)]}), encoding="utf-8")
    return root, led


def test_a_reel_malformed_body_is_still_recorded(tmp_path, monkeypatch):
    root, led = _reel_setup(tmp_path, monkeypatch, lambda v, p: {"oops": 1})
    assert tts_reel.main([str(root), "--execute", "--monthly-char-cap", "100"]) == 1
    assert _month(led) == {"characters": 12, "calls": 1}


# --- B: Duyu her çağrıda deftere; ana yanıt önbellekte ----------------------------------------------

class DuyuGapClient:
    """Ana yazıya dökme sesin ilk saniyesini verir (sonda 9,5 sn boşluk); boşluk çağrısı istenirse düşer."""

    def __init__(self, gap_fails: bool):
        self.gap_fails = gap_fails
        self.calls: list[str] = []

    def speech(self, payload):
        raise AssertionError("Alania çağrılmamalı (ham ses önbellekte)")

    def transcribe(self, wav, filename):
        self.calls.append(filename)
        if filename.endswith(".wav") and "-" not in filename:
            return {"text": "Merhaba", "duration": 10.0,
                    "words": [{"word": "Merhaba", "start": 0.1, "end": 0.5}]}, {"x-request-id": "m"}
        if self.gap_fails:
            raise tr.TrTtsError("PatientDesk HTTP 500: boşluk")
        return {"words": [{"word": "Alex", "start": 0.2, "end": 0.6}]}, {"x-request-id": "g"}


def test_b_duyu_main_recorded_and_cached_when_gap_fails(tmp_path):
    led = tmp_path / "l.json"
    plan = tr.plan_segments([tr.Segment("s01", "Merhaba Alex")], tmp_path / "out")
    tr._atomic_bytes(plan.raw_wav(plan.jobs[0]), make_wav(10.0))
    c1 = DuyuGapClient(gap_fails=True)
    with pytest.raises(tr.TrTtsError, match="boşluk"):
        tr.execute(tr.plan_segments([tr.Segment("s01", "Merhaba Alex")], tmp_path / "out"), c1, 100_000, led,
                   tmp_path / "P.md", finalize=fake_finalize, sleep=lambda s: None, log=lambda s: None)
    assert _month(led)["duyuSeconds"] == 10.0 and _month(led)["duyuCalls"] == 1
    c2 = DuyuGapClient(gap_fails=False)
    r = tr.execute(tr.plan_segments([tr.Segment("s01", "Merhaba Alex")], tmp_path / "out"), c2, 100_000, led,
                   tmp_path / "P.md", finalize=fake_finalize, sleep=lambda s: None, log=lambda s: None)
    assert len(c2.calls) == 1 and "-" in c2.calls[0]           # yalnız boşluk yeniden ödendi
    assert _month(led)["duyuSeconds"] == pytest.approx(10.0 + 9.5) and _month(led)["duyuCalls"] == 2
    assert r.done and r.done[0].quality["exact"] == 2


# --- C: PROMPTS eşzamanlılığı ve benzersiz geçici dosya ----------------------------------------------

def _row(i: int) -> dict:
    sha = f"{i:04d}" + "0" * 60
    return {"date": "2026-11-25T00:00:00Z", "segment": f"s{i}", "model": "m", "voice": "v", "release": "-",
            "chars": 1, "seconds": 1.0, "request_id": "-", "sha": sha, "speed": 1.0, "file": "f",
            "chapter": "c", "part": "1/1", "stem": f"s{i}", "speaker": "A", "reel": "R", "cue": f"c{i}"}


WRITERS = {
    "tts_tr": lambda p, r: tr.append_prompts(p, r),
    "tts_episode_tr_en": lambda p, r: ep.append_en_prompts(p, r),
    "lessonaudio_en": lambda p, r: lessonaudio.append_en_prompts(p, r),
    "tts_book": lambda p, r: tts.append_prompts(SimpleNamespace(dir=p.parent, id="B"), r),
    "tts_episode_en": lambda p, r: tts_episode_en.append_prompts(p, r),
    "tts_reel": lambda p, r: tts_reel._append_prompts(p, r),
}


@pytest.mark.parametrize("name", sorted(WRITERS))
def test_c_prompts_concurrent_appends_keep_every_row(tmp_path, monkeypatch, name):
    p = tmp_path / ("PROMPTS.md" if name != "tts_book" else tts.PROMPTS_FILE)
    real = Path.read_text

    def slow_read(self, *a, **k):
        out = real(self, *a, **k)
        if self.name.endswith(".md"):
            time.sleep(0.003)
        return out
    monkeypatch.setattr(Path, "read_text", slow_read)
    errs: list[BaseException] = []

    def work(base):
        try:
            for i in range(12):
                WRITERS[name](p, _row(base + i))
        except BaseException as e:  # noqa: BLE001
            errs.append(e)
    ts = [threading.Thread(target=work, args=(b,)) for b in (0, 100)]
    for t in ts:
        t.start()
    for t in ts:
        t.join(30)
    assert not errs
    text = real(p, encoding="utf-8")
    assert sum(1 for i in [*range(12), *range(100, 112)] if f"{i:04d}000000000000" in text) == 24


@pytest.mark.parametrize("writer", [tr._atomic_bytes, tts._atomic_bytes, lessonaudio._atomic_bytes])
def test_c_atomic_writes_never_collide_on_temp_name(tmp_path, writer):
    target, errs = tmp_path / "x.json", []

    def work(tag):
        try:
            for i in range(150):
                writer(target, f"{tag}{i}".encode())
        except BaseException as e:  # noqa: BLE001
            errs.append(e)
    ts = [threading.Thread(target=work, args=(t,)) for t in "ab"]
    for t in ts:
        t.start()
    for t in ts:
        t.join(30)
    assert not errs and target.read_bytes()[:1] in (b"a", b"b")
    assert [f.name for f in tmp_path.iterdir()] == ["x.json"]


# --- D: kilit bekleme bildirimi ----------------------------------------------------------------------

def _hold(path, held, release):
    with ledgerlock.ledger_lock(path):
        held.set()
        release.wait(5)


def test_d_lock_wait_is_announced_once_via_log(tmp_path):
    led, held, release, msgs = tmp_path / "l.json", threading.Event(), threading.Event(), []
    t = threading.Thread(target=_hold, args=(led, held, release))
    t.start()
    assert held.wait(5)
    done = threading.Event()

    def waiter():
        with ledgerlock.ledger_lock(led, log=msgs.append):
            done.set()
    w = threading.Thread(target=waiter)
    w.start()
    time.sleep(0.1)
    assert not done.is_set() and len(msgs) == 1 and "defter kilidi bekleniyor" in msgs[0] and str(led) in msgs[0]
    release.set()
    t.join(5)
    w.join(5)
    assert done.is_set() and len(msgs) == 1


def test_d_lock_wait_defaults_to_stderr_and_is_silent_when_free(tmp_path, capsys):
    led = tmp_path / "l.json"
    with ledgerlock.ledger_lock(led):
        pass
    assert capsys.readouterr().err == ""
    held, release = threading.Event(), threading.Event()
    t = threading.Thread(target=_hold, args=(led, held, release))
    t.start()
    assert held.wait(5)
    threading.Timer(0.1, release.set).start()
    with ledgerlock.ledger_lock(led):
        pass
    t.join(5)
    assert "defter kilidi bekleniyor" in capsys.readouterr().err


# --- E: ay anahtarı her ücretli çağrıda kilit altında --------------------------------------------------

def _months(seq):
    it = iter(seq)
    last = {"v": None}

    def mk(now=None):
        last["v"] = next(it, last["v"])
        return last["v"]
    return mk


def test_e_episode_en_month_key_taken_at_each_paid_call(tmp_path, monkeypatch):
    from test_tts_episode_en import Fake, setup
    root, epd = setup(tmp_path)
    led = tmp_path / "l.json"
    monkeypatch.setattr(tts_episode_en.tts, "month_key", _months(["2026-11", "2026-12"]))
    assert tts_episode_en.main([str(epd), "--root", str(root), "--execute", "--cap", "100", "--only", "x_01_alex",
                                "--ledger", str(led)], client=Fake()) == 0
    assert json.loads(led.read_text(encoding="utf-8")) == {"2026-12": {"characters": 16, "calls": 1}}


def test_e_reel_month_key_taken_at_each_paid_call(tmp_path, monkeypatch):
    root, led = _reel_setup(tmp_path, monkeypatch, lambda v, p: {"audio_base64": base64.b64encode(b"m").decode()})
    monkeypatch.setattr(tts_reel.T, "month_key", _months(["2026-11", "2026-12"]))
    assert tts_reel.main([str(root), "--execute", "--monthly-char-cap", "100"]) == 0
    assert json.loads(led.read_text(encoding="utf-8")) == {"2026-12": {"characters": 12, "calls": 1}}


# --- F: kitap tahmini yürütmeyle aynı önbellek koşulunu kullanır ---------------------------------------

def test_f_book_estimate_counts_part_with_json_but_no_mp3(tmp_path):
    from test_books import FX
    import shutil
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    for f in (d / "audio").glob("*"):
        f.unlink()
    plan = tts.plan_book(Book.load(d))
    full = tts.plan_billable(plan)
    first = plan.jobs[0].parts[0]
    key = tts._part_key(first, plan.voice_id, plan.model_id, plan.speed)
    pd = d / tts.AUDIO_DIR / "_parts"
    pd.mkdir(parents=True, exist_ok=True)
    (pd / f"{key}.json").write_text("{}", encoding="utf-8")          # mp3 yok: yürütme yeniden öder
    plan = tts.plan_book(Book.load(d))
    assert tts.plan_billable(plan) == full and plan.jobs[0].cached_parts == 0
    (pd / f"{key}.mp3").write_bytes(b"ID3")
    plan = tts.plan_book(Book.load(d))
    assert tts.plan_billable(plan) == full - len(first) and plan.jobs[0].cached_parts == 1


# --- G: kurgu.json `audio` başvurusu dosya adı olarak güvenli olmalı ------------------------------------

@pytest.mark.parametrize("ref", ["../../evil", "/tmp/evil", "a/b", "a\\b", "..", ".", "",
                                 {"id": "../x"}, {"id": "/etc/x"}, {"id": "ok/../../x"}, {"id": 5},
                                 {"path": "../.."}, {"path": "/"}])
def test_g_unsafe_audio_reference_rejected(tmp_path, ref, capsys):
    from test_tts_episode_tr import voice_map
    root = tmp_path / "icerik"
    voice_map(root, tmp_path / "en.json")
    d = root / "A1-902-test"
    (d / "audio").mkdir(parents=True)
    (d / "kurgu.json").write_text(json.dumps({"kurguVersion": 2, "contentId": "A1-902", "start": "h", "gate": {},
        "nodes": [{"id": "h", "type": "card", "kind": "hi", "advance": "tap", "audio": ref,
                   "lines": [{"speaker": "HI", "text": "Merhaba.", "lang": "tr"}], "next": None}]}),
        encoding="utf-8")
    with pytest.raises(ep.EpisodeTtsError, match="ses adı"):
        ep.collect_episode(d, ep.VoiceMap.load(root))
    assert tts_episode_tr.main([str(d), "--root", str(root)], tr_client=FakeClient()) == 2
    assert "HATA" in capsys.readouterr().err


@pytest.mark.parametrize("ref", ["hi_02", {"id": "tr_c-alex", "speaker": "ALEX"}, {"path": "audio/hi_03.mp3"}])
def test_g_safe_audio_reference_accepted(tmp_path, ref):
    from test_tts_episode_tr import voice_map
    root = tmp_path / "icerik"
    voice_map(root, tmp_path / "en.json")
    d = root / "A1-902-test"
    (d / "audio").mkdir(parents=True)
    (d / "kurgu.json").write_text(json.dumps({"kurguVersion": 2, "contentId": "A1-902", "start": "h", "gate": {},
        "nodes": [{"id": "h", "type": "card", "kind": "hi", "advance": "tap", "audio": ref,
                   "lines": [{"speaker": "HI", "text": "Merhaba.", "lang": "tr"}], "next": None}]}),
        encoding="utf-8")
    items = ep.collect_episode(d, ep.VoiceMap.load(root))
    assert items[0].audio().parent == d / "audio"


def test_g_unsafe_hi_and_talk_ids_rejected(tmp_path):
    from test_tts_episode_tr import voice_map
    root = tmp_path / "icerik"
    voice_map(root, tmp_path / "en.json")
    vm = ep.VoiceMap.load(root)
    (root / "_evren" / "hata-katalogu.json").write_text(json.dumps(
        {"entries": [{"id": "../../x", "explanationTr": "Açıklama."}]}), encoding="utf-8")
    with pytest.raises(ep.EpisodeTtsError, match="ses adı"):
        ep.collect_hi(root, vm)
    doc = {"id": "a/../../b", "introTr": "Merhaba."}
    with pytest.raises(ep.EpisodeTtsError, match="ses adı"):
        ep.collect_talk_task(root / "t.json", doc, root, vm)
    doc = {"id": "ok", "turns": [{"id": "../t", "promptTr": "Söyle."}]}
    with pytest.raises(ep.EpisodeTtsError, match="ses adı"):
        ep.collect_talk_task(root / "t.json", doc, root, vm)


# --- 2026-11-27: yanıtı yarıda kesilen çağrı da ücretlidir ----------------------------------------------

def _truncated_en(voice, payload):
    """ElevenLabs HTTP 200 verdi, gövde yarıda kesildi (IncompleteRead): ücret ödenmiştir."""
    raise tts.TtsPaidError("ElevenLabs yanıtı yarıda kesildi (IncompleteRead)")


def test_paid_truncated_book_call_is_recorded_and_not_cached(tmp_path):
    from test_books import FX
    import shutil
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    for f in (d / "audio").glob("*"):
        f.unlink()
    led, plan = tmp_path / "l.json", tts.plan_book(Book.load(d))
    with pytest.raises(tts.TtsPaidError):
        tts.execute(plan, _truncated_en, 100_000, led, log=lambda s: None)
    assert _month(led)["calls"] == 1 and _month(led)["characters"] == len(plan.jobs[0].parts[0])
    assert not list((d / "audio").rglob("*.mp3"))


def test_paid_truncated_lesson_and_run_en_calls_are_recorded(tmp_path):
    led = tmp_path / "en.json"
    plan = lessonaudio.plan_en([EnSegment("e1", "I am here.", "c1", "example")], tmp_path / "en", "v", "m", 1.0)
    with pytest.raises(tts.TtsPaidError):
        lessonaudio.execute_en(plan, _truncated_en, 1000, led, tmp_path / "P.md", log=lambda s: None)
    assert _month(led) == {"characters": 10, "calls": 1}
    piece = ep.EnPiece("x1", "Again, please.", "kx", tmp_path / "o", tmp_path / "P.md")
    with pytest.raises(tts.TtsPaidError):
        ep.run_en([piece], {"voiceId": "v", "modelId": "m", "speed": 1.0, "name": "S"}, _truncated_en, 1000, led,
                  log=lambda s: None)
    assert _month(led) == {"characters": 24, "calls": 2}


def test_paid_truncated_episode_en_call_is_recorded(tmp_path):
    from test_tts_episode_en import setup
    root, epd = setup(tmp_path)
    led = tmp_path / "l.json"
    with pytest.raises(tts.TtsPaidError):
        tts_episode_en.main([str(epd), "--root", str(root), "--execute", "--cap", "100", "--only", "x_01_alex",
                             "--ledger", str(led)], client=_truncated_en)
    assert _month(led) == {"characters": len("Sorry, I'm late."), "calls": 1}


def test_http_client_turns_incomplete_body_into_paid_error(monkeypatch):
    import http.client
    import urllib.request

    class Resp:
        def __enter__(self):
            return self

        def __exit__(self, *a):
            return False

        def read(self):
            raise http.client.IncompleteRead(b"x" * 10, 90)

    monkeypatch.setenv(tts.ENV_KEY, "test-key")
    monkeypatch.setattr(urllib.request, "urlopen", lambda req, timeout=None: Resp())
    with pytest.raises(tts.TtsPaidError, match="yarıda kesildi"):
        tts.http_client()("v", {"text": "hi"})


def test_failure_before_response_is_not_a_paid_error(monkeypatch):
    import urllib.request

    def refuse(req, timeout=None):
        raise ConnectionRefusedError("no route")

    monkeypatch.setenv(tts.ENV_KEY, "test-key")
    monkeypatch.setattr(urllib.request, "urlopen", refuse)
    with pytest.raises(ConnectionRefusedError):
        tts.http_client()("v", {"text": "hi"})


def test_http_client_turns_invalid_json_into_paid_error(monkeypatch):
    import urllib.request

    class Resp:
        def __enter__(self):
            return self

        def __exit__(self, *a):
            return False

        def read(self):
            return b'{"audio_base64": "SUQz'  # gövde yarıda, JSON eksik

    monkeypatch.setenv(tts.ENV_KEY, "test-key")
    monkeypatch.setattr(urllib.request, "urlopen", lambda req, timeout=None: Resp())
    with pytest.raises(tts.TtsPaidError, match="geçersiz JSON"):
        tts.http_client()("v", {"text": "hi"})
