"""H-077: dilbilgisi dersi paketi — kaynak biçimi, grammar-lint, ses planı (sahte istemciler), paket,
dev sunucu ve bölüm/kitap `grammarTopics`. Ağ çağrısı yoktur."""

from __future__ import annotations

import base64
import importlib.util
import json
import shutil
import threading
import urllib.error
import urllib.request
from pathlib import Path

import pytest

import export_grammar
import grammar_lint
import tts_lesson
from hvpipeline import lessonaudio as la, tts, tts_tr as tr
from hvpipeline.booklint import lint_book
from hvpipeline.bookexport import export_book
from hvpipeline.build import build_dry
from hvpipeline.graph import schema_errors
from hvpipeline.grammarexport import export_lesson
from hvpipeline.grammarlint import lint_lesson
from hvpipeline.lesson import (Lesson, LessonError, check_grammar_topics, english_in_turkish, parse_diagram,
                               parse_lesson_md, text_sha256)
from hvpipeline.lint import lint_episode
from hvpipeline.storylinks import StoryIndex

FXROOT = Path(__file__).parent / "fixtures"
GRAMMAR = FXROOT / "grammar"
LESSON_ID = "G-A1-99-third-person-s"
FX = GRAMMAR / LESSON_ID
BOOKS = FXROOT / "books"
REPO = Path(__file__).resolve().parents[3]
ROOTS = {"icerik_root": FXROOT, "books_root": BOOKS}


def codes(rep, level="error"):
    return [i.code for i in rep.issues if i.level == level]


# --- sahte hizalamalar ---------------------------------------------------------------------------

def _duyu_words(text: str, t0: float = 0.2, per_char: float = 0.06, gap: float = 0.05) -> list[dict]:
    out, t = [], t0
    for w in text.split():
        d = per_char * len(w)
        out.append({"word": w, "start": round(t, 3), "end": round(t + d, 3)})
        t += d + gap
    return out


def tr_align_doc(lesson: Lesson, seg) -> dict:
    """tts_tr.execute çıktısıyla aynı biçim (Duyu yerine düzenli sahte kelime zamanları)."""
    v = lesson.tr_voice()
    words, q = tr.map_words(seg.text, _duyu_words(seg.text))
    al = tr.char_alignment(seg.text, words)
    return {"text": seg.text, "textSha256": text_sha256(seg.text), "key": tr.seg_key(seg, v["voice"], v["model"]),
            "lang": "tr", "model_id": v["model"], "voice_id": v["voice"], "timing": tr.STT_MODEL,
            "duration": round(al.end + 0.3, 3), "loudnessLufs": -16.0, "quality": q.as_json(),
            "words": [{"w": w.token.text, "start": round(w.start, 3), "end": round(w.end, 3), "status": w.status}
                      for w in words],
            "alignment": tr.alignment_json(al)}


def en_alignment(text: str, t0: float = 0.1, per_char: float = 0.05) -> dict:
    n = len(text)
    return {"characters": list(text),
            "character_start_times_seconds": [round(t0 + k * per_char, 4) for k in range(n)],
            "character_end_times_seconds": [round(t0 + (k + 1) * per_char, 4) for k in range(n)]}


def en_align_doc(lesson: Lesson, seg) -> dict:
    v = lesson.en_voice()
    return {"text": seg.text, "textSha256": text_sha256(seg.text),
            "key": la.en_key(seg.text, v["voiceId"], v["modelId"], float(v["speed"])), "lang": "en",
            "voice_id": v["voiceId"], "model_id": v["modelId"], "speed": float(v["speed"]),
            "alignment": en_alignment(seg.text)}


def fixture_alignments(lesson_dir: Path = FX) -> dict[Path, dict]:
    lesson = Lesson.load(lesson_dir)
    out = {}
    for s in lesson.tr_segments():
        out[lesson.tr_paths(s.id)[1]] = tr_align_doc(lesson, s)
    for s in lesson.en_segments():
        out[lesson.en_paths(s.id)[1]] = en_align_doc(lesson, s)
    return out


def _dump(doc: dict) -> str:
    return json.dumps(doc, ensure_ascii=False) + "\n"


def write_fixture_alignments(lesson_dir: Path = FX) -> None:
    """Fikstür metni değişince: python -c 'import sys; sys.path[:0]=["tests","."];
    import test_grammar as t; t.write_fixture_alignments()' (tools/content-pipeline içinde)."""
    for p, doc in fixture_alignments(lesson_dir).items():
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(_dump(doc), encoding="utf-8")


def add_fake_mp3s(lesson_dir: Path) -> None:
    lesson = Lesson.load(lesson_dir)
    for s in lesson.tr_segments():
        lesson.tr_paths(s.id)[0].write_bytes(b"ID3-tr-" + s.id.encode())
    for s in lesson.en_segments():
        lesson.en_paths(s.id)[0].write_bytes(b"ID3-en-" + s.id.encode())


@pytest.fixture
def lesson_dir(tmp_path) -> Path:
    d = tmp_path / "dilbilgisi" / LESSON_ID
    shutil.copytree(FX, d)
    return d


class FakeMedia:
    target_lufs = -16.0

    def __init__(self):
        self.calls = []

    def loudness(self, paths):
        return {"I": -20.0, "TP": -3.0, "LRA": 4.0}

    def audio(self, src, gain, out):
        self.calls.append((src.name, round(gain, 2)))
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"m4a:" + src.read_bytes())
        return out

    def duration(self, path):
        return 9.0


# --- kaynak biçimi -------------------------------------------------------------------------------

def test_parse_fixture_cards():
    lesson = Lesson.load(FX)
    assert lesson.text.errors == [] and lesson.text.title == LESSON_ID
    assert [c.type for c in lesson.cards] == ["hook", "explain", "examples", "contrast", "practice", "seeInStory", "rule"]
    assert [c.id for c in lesson.cards][:2] == ["c01", "c02"]
    explain = lesson.cards[1]
    assert explain.title == "Ek nereden geliyor?" and len(explain.sentences) == 2
    assert [d.kind for d in explain.diagrams] == ["suffix", "boxes"]
    assert explain.diagrams[0].spec["words"][1] == {"base": "go", "suffix": "es", "word": "goes"}
    ex = lesson.cards[2].examples
    assert [e.id for e in ex] == ["c03-ex1", "c03-ex2", "c03-ex3"]
    assert ex[0].en == "She plays football." and ex[0].tr == "O futbol oynar."
    assert ex[0].targets == [{"start": 4, "end": 9, "text": "plays"}]
    contrast = lesson.cards[3]
    assert [e.id for e in contrast.wrong] == ["c04-x1"] and [e.id for e in contrast.right] == ["c04-ex1"]
    pr = lesson.cards[4].practice
    assert [p.kind for p in pr] == ["choose", "fill", "order", "say"]
    assert pr[0].options == ["go", "goes"] and pr[0].correct == [1] and pr[0].feedback
    assert pr[0].solved() == "She goes to school." and pr[1].solved() == "He plays football."
    assert pr[2].tokens == ["the box", "opens", "Ece"] and pr[2].solved() == "Ece opens the box."
    links = lesson.cards[5].links
    assert [(ln.kind, ln.target, ln.hint) for ln in links] == [("episode", "A1-901", "s01"), ("book", "A1-K99", None)]
    # Türkçe parça kart başına; söyleniş sözlüğü yalnız terimi geçen parçaya gider
    segs = lesson.tr_segments()
    assert [s.id for s in segs] == ["c01-tr", "c02-tr", "c04-tr", "c06-tr", "c07-tr"]
    assert segs[1].pronunciations == [{"term": "-s", "say_as": "se"}] and segs[0].pronunciations is None
    assert segs[0].instructions == "sıcak, sakin, yavaş"
    assert [s.id for s in lesson.en_segments()] == ["c01-ex1", "c03-ex1", "c03-ex2", "c03-ex3", "c04-ex1",
                                                    "c05-q4", "c07-ex1"]
    assert lesson.en_voice() == {"voiceId": "EXAVITQu4vr4xnSDxMaL", "modelId": "eleven_v3", "speed": 0.9}


def test_parse_reports_bad_markup():
    t = parse_lesson_md("metin dışarıda\n## nope\n## explain\nBu *vurgulu* bir cümle.\n? guess | x\n"
                        "- movie X | y\n@diagram cloud | a\n! yalnız\n")
    joined = " ".join(t.errors)
    for frag in ("kartın", "kart başlığı", "düz metindir", "alıştırma türü", "bağ", "şema türü", "`!`"):
        assert frag in joined, frag


def test_parse_diagram_specs():
    assert parse_diagram("timeline", "past: I played | now: I play")[0]["points"][1] == {"at": "now", "text": "I play"}
    assert parse_diagram("timeline", "yesterday: x")[1]
    assert parse_diagram("boxes", "one")[1]
    assert parse_diagram("suffix", "go-es")[1]


def test_english_in_turkish_heuristic():
    assert english_in_turkish("İngilizcede he, she ve it ile fiile -s takısı gelir. She plays.") == \
        ["he", "she", "it", "-s", "She", "plays"]
    assert english_in_turkish("Fiile -s eklenir.", [{"term": "-s", "say_as": "se"}]) == []
    # yaygın Türkçe kelimeler ve Türkçe harfli kelimeler işaretlenmez
    assert english_in_turkish("Her gün bir test yap, sonra say. Şimdi kural geliyor; ben ve sen ile ek yok.") == []
    assert english_in_turkish("Bu kelime box'tır.") == ["box'tır"]


# --- grammar-lint --------------------------------------------------------------------------------

def test_fixture_alignments_match_text():
    """Fikstür hizalamaları metinle aynı (metin değişirse write_fixture_alignments)."""
    for p, doc in fixture_alignments().items():
        assert p.exists(), p
        assert json.loads(p.read_text(encoding="utf-8")) == json.loads(_dump(doc)), p.name


def test_fixture_lesson_lints_clean():
    rep = lint_lesson(FX, **ROOTS)
    assert rep.errors == [], [str(i) for i in rep.errors]
    # yalnız git dışı ses uyarıları
    assert set(codes(rep, "warning")) == {"lesson-media"}, [str(i) for i in rep.warnings]
    assert rep.coverage["pct"] >= 98.0
    au = rep.stats["audio"]
    assert (au["trSegments"], au["trAligned"], au["enSegments"], au["enAligned"]) == (5, 5, 7, 7)
    links = {ln["kind"]: ln for ln in rep.links}
    assert links["episode"]["node"] == "s01" and links["episode"]["cueId"] == "s01-04"
    assert links["episode"]["cueText"] == "Yes. I'm your new neighbour."
    book = [ln for ln in rep.links if ln["kind"] == "book"]
    assert [(b["page"], b["sentenceId"]) for b in book] == [("p03", "p03-s02"), ("p01", "p01-s01")]


def test_lint_cli(capsys):
    assert grammar_lint.main([str(FX), "--icerik-root", str(FXROOT), "--books-root", str(BOOKS)]) == 0
    out = capsys.readouterr().out
    assert "kart" in out and "kapsama" in out and "0 hata" in out
    assert grammar_lint.main([str(FX), "--json", "--icerik-root", str(FXROOT), "--books-root", str(BOOKS)]) == 0
    assert json.loads(capsys.readouterr().out)["lessons"][0]["lessonId"] == LESSON_ID


def _edit(lesson_dir: Path, old: str, new: str, name: str = "lesson.md") -> None:
    p = lesson_dir / name
    s = p.read_text(encoding="utf-8")
    assert old in s, old
    p.write_text(s.replace(old, new, 1), encoding="utf-8")


def test_lint_catches_card_and_answer_key_errors(lesson_dir):
    _edit(lesson_dir, "Ben ve sen ile ek gelmez.", "Ben ve sen ile ek gelmez. Bir. İki. Üç.")
    _edit(lesson_dir, "+ He [[goes]] to school. | O okula gider.\n", "+ He goes to school.\n")
    _edit(lesson_dir, "+ The cat [[sleeps]] here. | Kedi burada uyur.\n", "")
    _edit(lesson_dir, "| go | *goes", "| *go | *goes")
    _edit(lesson_dir, "| the box / opens / Ece |", "| the box / opens / Ali |")
    _edit(lesson_dir, "? fill | He ___ football. (play) | plays", "? fill | He plays football. | plays")
    _edit(lesson_dir, "- book A1-K99 | Ece has a small box.", "- book A1-K99 | Ece has a big box.")
    _edit(lesson_dir, "- episode A1-901 s01 |", "- episode A1-999 |")
    rep = lint_lesson(lesson_dir, **ROOTS)
    errs = codes(rep)
    for c in ("narration-length", "example-tr", "example-target", "example-count", "answer-key", "story-link",
              "lesson-align"):
        assert c in errs, (c, [str(i) for i in rep.errors])
    msgs = " ".join(str(i) for i in rep.errors)
    assert "tam olarak bir doğru" in msgs and "aynı kelimeleri" in msgs and "tek bir ___" in msgs
    assert "birebir cümle yok" in msgs and "bölüm bulunamadı: A1-999" in msgs
    # metni değişen parçalar: hizalama hatası (c02-tr ve c03 örnekleri)
    assert any("c02-tr" in str(i) and "textSha256" in str(i) for i in rep.errors)


def test_lint_card_order_required_cards_and_english_words(lesson_dir):
    s = (lesson_dir / "lesson.md").read_text(encoding="utf-8")
    hook, rest = s.split("## explain", 1)
    head, hook_body = hook.split("## hook", 1)
    rest = rest.replace("## rule\nTek kişiden söz ederken fiile ek gelir.\n+ She [[goes]] to school. | O okula gider.\n", "")
    (lesson_dir / "lesson.md").write_text(head + "## explain" + rest + "## hook" + hook_body, encoding="utf-8")
    _edit(lesson_dir, "Bu cümlede ilginç bir şey var.", "Bu cümlede goes kelimesi var.")
    rep = lint_lesson(lesson_dir, **ROOTS)
    assert "card-order" in codes(rep) and "card-missing" in codes(rep)
    assert any("rule" in str(i) for i in rep.errors if i.code == "card-missing")
    warn = [str(i) for i in rep.warnings if i.code == "narration-english"]
    assert warn and "goes" in warn[0]


def test_lint_teacher_review_required_for_approved(lesson_dir):
    m = json.loads((lesson_dir / "lesson.json").read_text(encoding="utf-8"))
    m["status"] = "APPROVED"
    (lesson_dir / "lesson.json").write_text(json.dumps(m, ensure_ascii=False), encoding="utf-8")
    assert "teacher-review" in codes(lint_lesson(lesson_dir, **ROOTS))
    m["teacherReview"] = {"by": "Öğretmen A", "at": "2026-10-20", "notes": "kural doğru"}
    (lesson_dir / "lesson.json").write_text(json.dumps(m, ensure_ascii=False), encoding="utf-8")
    assert "teacher-review" not in codes(lint_lesson(lesson_dir, **ROOTS))


def test_lint_schema_ids_files_and_links_to(lesson_dir, tmp_path):
    m = json.loads((lesson_dir / "lesson.json").read_text(encoding="utf-8"))
    m["level"] = "A2"
    m["linksTo"]["books"].append("A1-K98")
    m["prerequisites"] = [LESSON_ID, "G-A1-01-to-be"]
    (lesson_dir / "lesson.json").write_text(json.dumps(m, ensure_ascii=False), encoding="utf-8")
    (lesson_dir / "PROMPTS.md").unlink()
    rep = lint_lesson(lesson_dir, **ROOTS)
    errs = codes(rep)
    assert "lesson-id" in errs and "lesson-files" in errs and "links-to" in errs and "prerequisite" in errs
    assert any("henüz yok: G-A1-01-to-be" in str(i) for i in rep.warnings)
    bad = tmp_path / "G-A1-1-x"
    shutil.copytree(FX, bad)
    assert "lesson-id" in codes(lint_lesson(bad, **ROOTS))


def test_lint_missing_alignment_is_warning(lesson_dir):
    (lesson_dir / "audio" / "en" / "c03-ex1.align.json").unlink()
    rep = lint_lesson(lesson_dir, **ROOTS)
    assert rep.errors == []
    assert any("c03-ex1" in str(i) and "hizalama yok" in str(i) for i in rep.warnings)


def test_lint_coverage_rule(lesson_dir):
    _edit(lesson_dir, "+ The cat [[sleeps]] here. | Kedi burada uyur.",
          "+ The cat [[photosynthesizes]] quickly. | Kedi hızla fotosentez yapar.")
    rep = lint_lesson(lesson_dir, **ROOTS)
    assert "coverage" in codes(rep)


# --- "Hikâyede gör" çözümü ------------------------------------------------------------------------

def test_story_index_resolves_exact_sentences():
    idx = StoryIndex(FXROOT, BOOKS)
    assert "A1-901" in idx.episodes() and "A1-K99" in idx.books()
    r = idx.resolve("episode", "A1-901", "Are you new here?")
    assert r.error is None and r.target["cueId"] == "s01-03" and r.target["start"] is not None
    assert idx.resolve("episode", "A1-901", "Are you new here").error      # noktalama da birebir
    assert idx.resolve("episode", "A1-901", "Are you new here?", "s99").error
    r = idx.resolve("book", "A1-K99", "There is a key under the bed.")
    assert r.target == {"kind": "book", "bookId": "A1-K99", "chapter": "c2", "page": "p03",
                        "sentenceId": "p03-s01", "text": "There is a key under the bed.", "start": None, "end": None}
    assert idx.resolve("book", "A1-K99", "There is a key under the bed.", "p01").error


# --- ses planı (tts_lesson.py; sahte istemciler) ---------------------------------------------------

class FakeTr:
    """Alania + Duyu: metne göre WAV ve düzenli kelime zamanları."""

    def __init__(self):
        self.speech_calls, self.stt_calls, self.text = [], [], {}

    def speech(self, payload):
        import io
        import wave
        self.speech_calls.append(payload)
        buf = io.BytesIO()
        with wave.open(buf, "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(16000)
            w.writeframes(b"\x00\x00" * int(16000 * (0.5 + 0.07 * len(payload["input"]))) + b"\x00\x00" * len(self.speech_calls))
        data = buf.getvalue()
        self.text[len(data)] = payload["input"]
        return data, {"x-request-id": f"req-{len(self.speech_calls)}", "x-model-release": "t"}

    def transcribe(self, wav, filename):
        self.stt_calls.append(filename)
        return {"text": "", "words": _duyu_words(self.text[len(wav)]), "duration": tr.wav_duration(wav)}, {}


class FakeEn:
    def __init__(self):
        self.calls = []

    def __call__(self, voice, payload):
        self.calls.append((voice, payload))
        return {"audio_base64": base64.b64encode(b"ID3-en:" + payload["text"].encode()).decode(),
                "alignment": en_alignment(payload["text"])}


def fake_finalize(wav, out):
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(b"ID3-tr:" + wav.read_bytes()[:8])
    return -16.0


def _strip_audio(lesson_dir: Path) -> None:
    shutil.rmtree(lesson_dir / "audio")


def run_tts(lesson_dir, tmp_path, *extra, tr_client=None, en_client=None):
    return tts_lesson.main([str(lesson_dir), "--tr-ledger", str(tmp_path / "tr.json"),
                            "--en-ledger", str(tmp_path / "en.json"), *extra],
                           tr_client=tr_client, en_client=en_client, finalize=fake_finalize, sleep=lambda s: None)


def test_tts_lesson_dry_run_never_calls(lesson_dir, tmp_path, capsys, monkeypatch):
    _strip_audio(lesson_dir)
    monkeypatch.delenv(tr.ENV_CAP, raising=False)
    monkeypatch.delenv(tts.ENV_CAP, raising=False)

    class Boom:
        def speech(self, *a):
            raise AssertionError("kuru çalışmada API çağrılmamalı")
        transcribe = __call__ = speech
    assert run_tts(lesson_dir, tmp_path, tr_client=Boom(), en_client=Boom()) == 0
    out = capsys.readouterr().out
    lesson = Lesson.load(lesson_dir)
    tr_chars = sum(len(s.text) for s in lesson.tr_segments())
    en_chars = sum(len(t) for t in {s.text for s in lesson.en_segments()})   # aynı metin bir kez
    assert f"Türkçe (Alania): {tr_chars} karakter" in out and f"İngilizce (ElevenLabs): {en_chars} karakter" in out
    assert "Kuru çalışma" in out and "TANIMLI DEĞİL" in out
    assert not (lesson_dir / "audio").exists() and not (tmp_path / "tr.json").exists()
    plan = la.plan_lesson(lesson)
    assert plan.en.billable_chars == sum(len(t) for t in {s.text for s in lesson.en_segments()})


def test_tts_lesson_execute_requires_both_caps(lesson_dir, tmp_path, monkeypatch, capsys):
    _strip_audio(lesson_dir)
    monkeypatch.delenv(tr.ENV_CAP, raising=False)
    monkeypatch.delenv(tts.ENV_CAP, raising=False)
    ft, fe = FakeTr(), FakeEn()
    assert run_tts(lesson_dir, tmp_path, "--execute", "--tr-cap", "5000", tr_client=ft, en_client=fe) == 1
    assert ft.speech_calls == [] and fe.calls == [] and "HIVELZON_TTS_MONTHLY_CHAR_CAP" in capsys.readouterr().err


def test_tts_lesson_execute_writes_audio_manifest_and_is_idempotent(lesson_dir, tmp_path):
    _strip_audio(lesson_dir)
    ft, fe = FakeTr(), FakeEn()
    assert run_tts(lesson_dir, tmp_path, "--execute", "--tr-cap", "5000", "--en-cap", "5000",
                   tr_client=ft, en_client=fe) == 0
    lesson = Lesson.load(lesson_dir)
    # "She goes to school." üç parçada geçiyor: bir kez ücretlenir, diğerleri önbellekten kurulur
    assert len(ft.speech_calls) == 5 and len(ft.stt_calls) == 5 and len(fe.calls) == 5
    unique_en = {s.text for s in lesson.en_segments()}
    assert sorted(p["text"] for _, p in fe.calls) == sorted(unique_en)
    p2 = ft.speech_calls[1]
    assert p2["pronunciations"] == [{"term": "-s", "say_as": "se"}] and p2["voice"] == "alania2-f1"
    voice, payload = fe.calls[0]
    assert voice == "EXAVITQu4vr4xnSDxMaL" and payload["text"] == "Ece opens the box."
    assert payload["model_id"] == "eleven_v3" and payload["voice_settings"]["speed"] == 0.9
    for s in lesson.tr_segments():
        mp3, aj = lesson.tr_paths(s.id)
        assert mp3.exists() and json.loads(aj.read_text(encoding="utf-8"))["textSha256"] == text_sha256(s.text)
    for s in lesson.en_segments():
        mp3, aj = lesson.en_paths(s.id)
        assert mp3.read_bytes() == b"ID3-en:" + s.text.encode()
    man = json.loads((lesson_dir / "audio" / "lesson-audio.json").read_text(encoding="utf-8"))
    assert schema_errors(man, "lesson-audio.schema.json") == []
    assert all(seg["present"] for c in man["cards"] for seg in c["segments"])
    c01 = man["cards"][0]["segments"]
    assert [(x["id"], x["lang"], x["role"]) for x in c01] == [("c01-tr", "tr", "narration"), ("c01-ex1", "en", "example")]
    assert man["cards"][4]["segments"][0]["role"] == "say"
    prompts = (lesson_dir / "PROMPTS.md").read_text(encoding="utf-8")
    assert tr.PROMPTS_HEADING in prompts and la.EN_PROMPTS_HEADING in prompts
    assert "| c03-ex1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 |" in prompts
    led_tr = json.loads((tmp_path / "tr.json").read_text(encoding="utf-8"))[tr.month_key()]
    led_en = json.loads((tmp_path / "en.json").read_text(encoding="utf-8"))[tts.month_key()]
    assert led_tr["characters"] == sum(len(s.text) for s in lesson.tr_segments())
    assert led_en["characters"] == sum(len(t) for t in unique_en) and led_en["calls"] == 5
    # lint: hizalamalar metinle uyuşuyor, ses var
    rep = lint_lesson(lesson_dir, **ROOTS)
    assert rep.errors == [] and rep.warnings == [], [str(i) for i in rep.issues]
    # ikinci çalışma: hiç çağrı yok, kayıt değişmez
    ft2, fe2 = FakeTr(), FakeEn()
    assert run_tts(lesson_dir, tmp_path, "--execute", "--tr-cap", "5000", "--en-cap", "5000",
                   tr_client=ft2, en_client=fe2) == 0
    assert ft2.speech_calls == [] and fe2.calls == []
    assert prompts == (lesson_dir / "PROMPTS.md").read_text(encoding="utf-8")
    # örnek değişince yalnız o parça istenir; silinen çıktı ödenmiş önbellekten kurulur
    (lesson_dir / "audio" / "en" / "c03-ex2.mp3").unlink()
    _edit(lesson_dir, "+ The cat [[sleeps]] here.", "+ The dog [[sleeps]] here.")
    plan = la.plan_lesson(Lesson.load(lesson_dir))
    acts = {j.seg.id: j.action for j in plan.en.jobs}
    assert acts["c03-ex3"] == "tts" and acts["c03-ex2"] == "build" and acts["c03-ex1"] == "skip"
    assert all(j.action == "skip" for j in plan.tr.jobs)
    assert run_tts(lesson_dir, tmp_path, "--execute", "--tr-cap", "5000", "--en-cap", "5000",
                   tr_client=ft2, en_client=fe2) == 0
    assert [p["text"] for _, p in fe2.calls] == ["The dog sleeps here."]


def test_tts_lesson_en_cap_stops_before_call(lesson_dir, tmp_path):
    _strip_audio(lesson_dir)
    tts.ledger_add(tmp_path / "en.json", tts.month_key(), 4990)
    ft, fe = FakeTr(), FakeEn()
    assert run_tts(lesson_dir, tmp_path, "--execute", "--tr-cap", "5000", "--en-cap", "5000", "--lang", "en",
                   tr_client=ft, en_client=fe) == 1
    assert fe.calls == [] and ft.speech_calls == []


def test_tts_lesson_manifest_only(lesson_dir, tmp_path):
    assert run_tts(lesson_dir, tmp_path, "--manifest-only") == 0
    man = json.loads((lesson_dir / "audio" / "lesson-audio.json").read_text(encoding="utf-8"))
    assert schema_errors(man, "lesson-audio.schema.json") == []
    seg = man["cards"][0]["segments"][0]
    assert seg["present"] is False and seg["duration"] and seg["quality"]["ok"] is True   # hizalama var, mp3 yok


# --- paket ---------------------------------------------------------------------------------------

def test_export_end_to_end(lesson_dir):
    add_fake_mp3s(lesson_dir)
    fm = FakeMedia()
    r = export_lesson(lesson_dir, media=fm, **ROOTS)
    assert r.errors == [] and r.missing == []
    pkg = lesson_dir / "_build" / "package"
    ld = json.loads((pkg / "lesson.json").read_text(encoding="utf-8"))
    cards = json.loads((pkg / "cards.json").read_text(encoding="utf-8"))
    assert schema_errors(ld, "lesson.schema.json") == [] and schema_errors(cards, "cards.schema.json") == []
    assert "narration" not in ld and "pronunciations" not in ld and ld["teacherReview"] is None
    assert ld["cardCount"] == 7 and ld["durations"]["narration"] == 45.0 and ld["durations"]["examples"] == 63.0
    assert ld["estimatedMinutes"] == round((108 + 40) / 60, 1)
    assert sorted(p.name for p in (pkg / "audio").iterdir()) == sorted(
        [f"{s}.m4a" for s in ("c01-tr", "c02-tr", "c04-tr", "c06-tr", "c07-tr", "c01-ex1", "c03-ex1", "c03-ex2",
                              "c03-ex3", "c04-ex1", "c05-q4", "c07-ex1")])
    assert all(g == 4.0 for _, g in fm.calls)   # her parça -16 LUFS'a ayrı
    c = {x["type"]: x for x in cards["cards"]}
    nar = c["explain"]["narration"]
    assert nar["audio"] == "audio/c02-tr.m4a" and len(nar["sentences"]) == 2
    assert nar["sentences"][0]["words"][0]["w"] == "Tek" and nar["sentences"][0]["start"] is not None
    assert nar["sentences"][1]["start"] > nar["sentences"][0]["end"]
    ex = c["examples"]["examples"][0]
    assert ex["audio"] == "audio/c03-ex1.m4a" and ex["targets"] == [{"start": 4, "end": 9, "text": "plays"}]
    assert [w["w"] for w in ex["words"]] == ["She", "plays", "football."] and ex["start"] == 0.1
    assert c["contrast"]["wrong"] == [{"id": "c04-x1", "en": "She go to school.", "tr": "Ek eksik."}]
    assert c["explain"]["diagrams"][0]["kind"] == "suffix"
    pr = c["practice"]["practice"]
    assert pr[0]["options"] == [{"text": "go", "correct": False}, {"text": "goes", "correct": True}]
    assert pr[0]["feedbackTr"] and pr[2]["answer"] == "Ece opens the box." and pr[3]["audio"] == "audio/c05-q4.m4a"
    links = c["seeInStory"]["links"]
    assert links[0] == {"kind": "episode", "episodeId": "A1-901", "node": "s01", "cueId": "s01-04",
                        "text": "I'm your new neighbour.", "cueText": "Yes. I'm your new neighbour.",
                        "start": links[0]["start"], "end": links[0]["end"]}
    assert links[1]["kind"] == "book" and links[1]["page"] == "p01" and links[1]["sentenceId"] == "p01-s01"
    assert c["hook"]["links"][0]["page"] == "p03"
    man = json.loads((pkg / "manifest.json").read_text(encoding="utf-8"))
    assert man["contentType"] == "GRAMMAR_LESSON" and man["missing"] == []
    assert man["textSha256"]["c03-ex1"] == text_sha256("She plays football.")
    assert {f["path"] for f in man["files"]} >= {"lesson.json", "cards.json", "audio/c02-tr.m4a"}


def test_export_without_media_reports_missing(lesson_dir, capsys):
    r = export_lesson(lesson_dir, media=FakeMedia(), **ROOTS)
    assert r.errors == [] and len(r.missing) == 12 and {m["kind"] for m in r.missing} == {"audio"}
    nar = r.cards["cards"][1]["narration"]
    assert nar["audio"] is None and nar["sentences"][0]["start"] is not None   # zamanlar hizalamadan
    assert r.lesson["durations"]["total"] is None and r.lesson["estimatedMinutes"] is None
    args = [str(lesson_dir), "--icerik-root", str(FXROOT), "--books-root", str(BOOKS)]
    assert export_grammar.main(args, media=FakeMedia()) == 0
    assert export_grammar.main(args + ["--require-media"], media=FakeMedia()) == 1
    assert "lesson-media" in capsys.readouterr().out


def test_export_fails_on_changed_text(lesson_dir):
    _edit(lesson_dir, "+ She [[plays]] football.", "+ She [[plays]] tennis.")
    with pytest.raises(LessonError, match="textSha256"):
        export_lesson(lesson_dir, media=FakeMedia(), **ROOTS)


# --- grammarTopics (bölüm ve kitap) ---------------------------------------------------------------

def test_check_grammar_topics(tmp_path):
    root = tmp_path / "dilbilgisi"
    assert check_grammar_topics(None, root) == []
    assert check_grammar_topics([LESSON_ID], root)[0][0] == "warning"          # hiç ders yok
    shutil.copytree(FX, root / LESSON_ID)
    assert check_grammar_topics([LESSON_ID], root) == []
    out = check_grammar_topics([LESSON_ID, "G-A1-98-missing", "bad-id", LESSON_ID], root)
    assert [lv for lv, _ in out].count("error") == 2 and any(lv == "warning" for lv, _ in out)
    assert check_grammar_topics("G-A1-99-x", root)[0][0] == "error"


def test_book_grammar_topics_lint_and_export(tmp_path):
    book = tmp_path / "kitaplar" / "A1-K99-the-test-box"
    shutil.copytree(BOOKS / "A1-K99-the-test-box", book)
    root = tmp_path / "dilbilgisi"
    shutil.copytree(FX, root / LESSON_ID)
    base = {str(i) for i in lint_book(book, {"A1": 46}, grammar_root=root).issues}
    m = json.loads((book / "book.json").read_text(encoding="utf-8"))
    m["grammarTopics"] = [LESSON_ID]
    (book / "book.json").write_text(json.dumps(m, ensure_ascii=False), encoding="utf-8")
    assert {str(i) for i in lint_book(book, {"A1": 46}, grammar_root=root).issues} == base
    m["grammarTopics"] = ["G-A1-98-missing"]
    (book / "book.json").write_text(json.dumps(m, ensure_ascii=False), encoding="utf-8")
    assert "grammar-topics" in codes(lint_book(book, {"A1": 46}, grammar_root=root))
    m["grammarTopics"] = [LESSON_ID]
    (book / "book.json").write_text(json.dumps(m, ensure_ascii=False), encoding="utf-8")
    r = export_book(book, media=_BookMedia())
    assert r.book["grammarTopics"] == [LESSON_ID] and r.errors == []


class _BookMedia(FakeMedia):
    def samples(self, path):
        return int(12.5 * 44100)

    def envelope(self, path):
        return []

    def image(self, src, out):
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"webp")
        return out


def test_episode_grammar_topics_lint_and_meta(tmp_path):
    shutil.copytree(FXROOT, tmp_path / "fx", ignore=shutil.ignore_patterns("grammar", "books"))
    ep = tmp_path / "fx" / "ep-good"
    root = tmp_path / "dilbilgisi"
    shutil.copytree(FX, root / LESSON_ID)
    base = [str(i) for i in lint_episode(ep, grammar_root=root).issues]
    c = json.loads((ep / "content.json").read_text(encoding="utf-8"))
    c["grammarTopics"] = [LESSON_ID]
    (ep / "content.json").write_text(json.dumps(c, ensure_ascii=False), encoding="utf-8")
    assert [str(i) for i in lint_episode(ep, grammar_root=root).issues] == base
    doc, _ = build_dry(ep)
    assert doc["episode"]["grammarTopics"] == [LESSON_ID] and schema_errors(doc) == []
    c["grammarTopics"] = ["G-A1-98-missing"]
    (ep / "content.json").write_text(json.dumps(c, ensure_ascii=False), encoding="utf-8")
    assert "grammar-topics" in codes(lint_episode(ep, grammar_root=root))
    # alan yoksa paket de taşımaz (eski çıktı değişmez)
    del c["grammarTopics"]
    (ep / "content.json").write_text(json.dumps(c, ensure_ascii=False), encoding="utf-8")
    assert "grammarTopics" not in build_dry(ep)[0]["episode"]


def test_real_content_has_no_grammar_topic_errors():
    """Depodaki bölüm ve kitaplar: alan isteğe bağlı; olmayan alan hiçbir uyarı üretmez."""
    for cp in sorted((REPO / "icerik").glob("A1-*/content.json")):
        c = json.loads(cp.read_text(encoding="utf-8"))
        assert all(lv != "error" for lv, _ in check_grammar_topics(c.get("grammarTopics")))


# --- dev içerik sunucusu ---------------------------------------------------------------------------

def _load_server():
    spec = importlib.util.spec_from_file_location("hv_serve_g", REPO / "tools" / "dev-content-server" / "serve.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_dev_server_serves_grammar(lesson_dir):
    add_fake_mp3s(lesson_dir)
    export_lesson(lesson_dir, media=FakeMedia(), **ROOTS)
    serve = _load_server()
    serve.Handler.root = lesson_dir.parent / "icerik-yok"
    serve.Handler.books_root = lesson_dir.parent / "kitap-yok"
    serve.Handler.grammar_root = lesson_dir.parent
    serve.Handler.quiet = True
    srv = serve.ThreadingHTTPServer(("127.0.0.1", 0), serve.Handler)
    th = threading.Thread(target=srv.serve_forever, daemon=True)
    th.start()
    try:
        base = f"http://127.0.0.1:{srv.server_address[1]}"
        idx = json.loads(urllib.request.urlopen(f"{base}/grammar/index.json").read())
        g = idx["lessons"][0]
        assert [x["id"] for x in idx["lessons"]] == [LESSON_ID] and "dir" not in g
        assert g["titleTr"] == "Üçüncü tekil -s" and g["level"] == "A1" and g["cardCount"] == 7
        cards = json.loads(urllib.request.urlopen(f"{base}/grammar/{LESSON_ID}/cards.json").read())
        assert cards["lessonId"] == LESSON_ID
        req = urllib.request.Request(f"{base}/grammar/{LESSON_ID}/audio/c02-tr.m4a", headers={"Range": "bytes=0-3"})
        with urllib.request.urlopen(req) as r:
            assert r.status == 206 and r.read() == b"m4a:" and r.headers["Content-Type"] == "audio/mp4"
        with pytest.raises(urllib.error.HTTPError) as e:
            urllib.request.urlopen(f"{base}/grammar/G-A1-00-none/lesson.json")
        assert e.value.code == 404
        assert json.loads(urllib.request.urlopen(f"{base}/books/index.json").read())["books"] == []
    finally:
        srv.shutdown()
        srv.server_close()


def test_dev_server_indexes_include_grammar_topics(tmp_path):
    serve = _load_server()
    pkg = tmp_path / "kitaplar" / "A1-K99-x" / "_build" / "package"
    pkg.mkdir(parents=True)
    (pkg / "book.json").write_text(json.dumps({"id": "A1-K99", "grammarTopics": [LESSON_ID], "chapters": []}),
                                   encoding="utf-8")
    eps = tmp_path / "icerik" / "A1-901-x" / "_build" / "package"
    eps.mkdir(parents=True)
    (eps / "scenes.json").write_text(json.dumps({"episode": {"id": "A1-901", "grammarTopics": [LESSON_ID]}}),
                                     encoding="utf-8")
    (tmp_path / "icerik" / "A1-902-y" / "_build" / "package").mkdir(parents=True)
    (tmp_path / "icerik" / "A1-902-y" / "_build" / "package" / "scenes.json").write_text(
        json.dumps({"episode": {"id": "A1-902"}}), encoding="utf-8")
    assert serve.discover_books(tmp_path / "kitaplar")["A1-K99"]["grammarTopics"] == [LESSON_ID]
    pk = serve.discover_packages(tmp_path / "icerik")
    assert pk["A1-901"]["grammarTopics"] == [LESSON_ID] and "grammarTopics" not in pk["A1-902"]
