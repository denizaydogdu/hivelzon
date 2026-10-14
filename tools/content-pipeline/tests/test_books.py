"""Kitaplık boru hattı (H-066): kaynak biçimi, book-lint, paket, TTS betiği (sahte istemci), sunucu."""

from __future__ import annotations

import base64
import importlib.util
import json
import shutil
import subprocess
import threading
import urllib.request
from pathlib import Path

import pytest

import book_lint
import export_book
import tts_book
from hvpipeline import cefr, tts
from hvpipeline.align import Alignment, AlignmentMismatch, concat_alignments, locate, sentence_timings
from hvpipeline.book import Book, BookError, parse_glossary, parse_text, split_sentences, text_sha256
from hvpipeline.booklint import lint_book
from hvpipeline.bookexport import export_book as export
from hvpipeline.build import file_digest
from hvpipeline.graph import schema_errors

FX = Path(__file__).parent / "fixtures" / "books" / "A1-K99-the-test-box"
REPO = Path(__file__).resolve().parents[3]
HAS_FFMPEG = shutil.which("ffmpeg") is not None and shutil.which("ffprobe") is not None
HAS_MAGICK = shutil.which("magick") is not None
FIXTURE_WORDS = {"A1": 46}   # küçük test kitabı: kelime hedefi testte daraltılır


@pytest.fixture
def book_dir(tmp_path) -> Path:
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    return d


def codes(rep, level="error"):
    return [i.code for i in rep.issues if i.level == level]


class FakeMedia:
    """ffmpeg/ImageMagick yerine: dosyaları yazar, ölçümleri sabit döndürür."""
    target_lufs = -16.0

    def __init__(self):
        self.audio_calls = []
        self.pace_calls = []
        self._dur = {}

    def loudness(self, paths):
        return {"I": -20.0, "TP": -3.0, "LRA": 5.0}

    def audio(self, src, gain, out):
        self.audio_calls.append((src.name, round(gain, 2)))
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"m4a:" + src.read_bytes())
        if src.name in self._dur:
            self._dur[out.name] = self._dur[src.name]
        return out

    def duration(self, path):
        return self._dur.get(path.name, 12.5)

    # anlatım temposu (H-069): kaynak 12,5 sn, zarf yok (kesim aralığın ortası)
    def samples(self, path):
        return int(12.5 * 44100)

    def envelope(self, path):
        return []

    def pace(self, src, plan, out):
        self.pace_calls.append((src.name, plan.pause, plan.tempo))
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"paced:" + src.read_bytes())
        self._dur[out.name] = plan.out_total / plan.sr
        return out

    def image(self, src, out):
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_bytes(b"webp:" + src.read_bytes())
        return out


def set_pacing(d: Path, cfg: dict | None) -> None:
    """book.json → narration.pacing (None: alanı kaldır, seviye varsayılanı)."""
    bj = json.loads((d / "book.json").read_text(encoding="utf-8"))
    bj["narration"].pop("pacing", None)
    if cfg is not None:
        bj["narration"]["pacing"] = cfg
    (d / "book.json").write_text(json.dumps(bj, ensure_ascii=False), encoding="utf-8")


def add_fake_media(d: Path) -> None:
    (d / "images").mkdir(exist_ok=True)
    for n in ("cover.png", "p01.png", "p03.png"):
        (d / "images" / n).write_bytes(b"png")
    for c in ("c1", "c2"):
        (d / "audio" / f"{c}.mp3").write_bytes(b"mp3")


# --- kaynak biçimi ------------------------------------------------------------------------------

def test_parse_text_structure_and_sentences():
    b = Book.load(FX)
    assert b.text.errors == []
    assert b.text.title == "The Test Box"
    assert [c.id for c in b.text.chapters] == ["c1", "c2"]
    assert [p.id for p in b.text.pages] == ["p01", "p02", "p03"]
    assert [p.number for p in b.text.pages] == [1, 2, 3]
    p01 = b.text.pages[0]
    assert [(s.id, s.paragraph) for s in p01.sentences] == [("p01-s01", 1), ("p01-s02", 1), ("p01-s03", 2)]
    # alıntıdan sonra küçük harfle devam eden cümle bölünmez; satırlar paragrafta birleşir
    assert [s.text for s in b.text.pages[1].sentences] == ['"What is in the box?" asks her mum.', "Ece does not know."]
    assert b.text.chapters[0].tts_text().startswith("A Small Box.\n\nEce has a small box.")


def test_split_sentences_abbreviations_and_quotes():
    assert split_sentences("Mr. Brown is here. He is tall!") == ["Mr. Brown is here.", "He is tall!"]
    # küçük harfle devam eden konuşma eki bölünmez; büyük harfle başlayan (özel ad) bölünür (belgelendi)
    assert split_sentences('"Stop!" says Lina. "Why?" No answer.') == ['"Stop!" says Lina.', '"Why?"', "No answer."]
    assert split_sentences('"Stop!" Lina says.') == ['"Stop!"', "Lina says."]
    assert split_sentences("No end mark") == ["No end mark"]


def test_parse_text_reports_bad_markup():
    t = parse_text("Loose text.\n## Chapter without id\n## [c1] Ok\n### [p1]\n### [p01]\nA *bold* word.\n")
    msgs = " ".join(t.errors)
    assert "sayfanın" in msgs and "`## [c1] Başlık`" in msgs and "`### [p01]`" in msgs and "Markdown" in msgs


def test_parse_glossary_table():
    entries, errors = parse_glossary("# S\n\n| Kelime | Türkçe | Örnek |\n|---|---|---|\n| shine | parlamak | It shines. |\n| key |  | |\n")
    assert errors == []
    assert [(e.en, e.tr, e.example) for e in entries] == [("shine", "parlamak", "It shines."), ("key", "", "")]


def test_book_schema_accepts_fixture():
    assert schema_errors(json.loads((FX / "book.json").read_text(encoding="utf-8")), "book.schema.json") == []


# --- seviyeler ve kelime listesi ----------------------------------------------------------------

def test_levels_include_c2_and_cefrj_unchanged():
    assert cefr.LEVELS == ["A1", "A2", "B1", "B2", "C1", "C2"]
    assert cefr.CEFRJ_LEVELS == ["A1", "A2", "B1", "B2"]
    a1 = cefr.load_wordlist("A1")
    assert "box" in a1.allowed and a1.sources["box"] == "cefrj"


@pytest.fixture
def octanove(tmp_path, monkeypatch):
    """Octanove dosyası testte geçici; depoya indirilmez."""
    def make(present: bool):
        p = tmp_path / "lexicon_ccbysa" / "octanove-vocabulary-profile-c1c2-1.0.csv"
        if present:
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text("# test\nheadword,pos,CEFR,notes,source\nubiquitous,adjective,C1,,octanove\n"
                         "quixotic,adjective,C2,,octanove\n", encoding="utf-8")
        monkeypatch.setattr(cefr, "OCTANOVE", p)
        cefr.load_wordlist.cache_clear()
        return p
    yield make
    cefr.load_wordlist.cache_clear()


def test_c1_c2_use_separate_octanove_list(octanove):
    octanove(True)
    c1 = cefr.load_wordlist("C1")
    assert "ubiquitous" in c1.allowed and "quixotic" not in c1.allowed
    assert c1.sources["ubiquitous"] == "octanove"
    c2 = cefr.load_wordlist("C2")
    assert "quixotic" in c2.allowed and "box" in c2.allowed
    assert "ubiquitous" not in cefr.load_wordlist("B2").allowed   # A1–B2 yalnız CEFR-J


def _make_level(d: Path, level: str) -> None:
    bj = json.loads((d / "book.json").read_text(encoding="utf-8"))
    bj["level"] = level
    bj["id"] = f"{level}-K99"
    bj["slug"] = f"{level}-K99-the-test-box"
    (d / "book.json").write_text(json.dumps(bj), encoding="utf-8")


def test_c2_book_without_octanove_warns_not_checked(tmp_path, octanove):
    octanove(False)
    d = tmp_path / "C2-K99-the-test-box"
    shutil.copytree(FX, d)
    _make_level(d, "C2")
    rep = lint_book(d, word_targets={"C2": 46})
    assert rep.coverage is None
    assert any("liste yok; kapsama denetlenmedi" in str(i) and i.level == "warning" for i in rep.issues)
    assert "book-schema" not in codes(rep) and "coverage" not in codes(rep)


def test_c1_book_with_octanove_counts_coverage(tmp_path, octanove):
    octanove(True)
    d = tmp_path / "C1-K99-the-test-box"
    shutil.copytree(FX, d)
    _make_level(d, "C1")
    rep = lint_book(d, word_targets={"C1": 46})
    assert rep.coverage is not None and rep.coverage["pct"] == 100.0


# --- book-lint ----------------------------------------------------------------------------------

def test_fixture_book_lints_clean_with_test_word_target():
    rep = lint_book(FX, word_targets=FIXTURE_WORDS)
    assert rep.errors == [], [str(i) for i in rep.errors]
    assert rep.coverage["pct"] == 100.0
    assert rep.translation["unitsTranslated"] == rep.translation["units"] == 10
    assert rep.translation["wordsGlossed"] == rep.translation["wordsNeedingGloss"]
    assert rep.stats["media"]["aligned"] == 2
    # git dışı medya: uyarı, hata değil
    assert "book-media" in codes(rep, "warning")


def test_lint_cli_word_count_rule(capsys):
    assert book_lint.main([str(FX)]) == 1
    out = capsys.readouterr().out
    assert "[book-words]" in out and "560–840" in out


def test_lint_catches_rule_violations(book_dir):
    text = (book_dir / "text.en.md").read_text(encoding="utf-8")
    text = text.replace("The box is red.", "The box is red and blue and green and very old.")
    text = text.replace("### [p03]\n", "### [p03]\n\n### [p04]\n")
    (book_dir / "text.en.md").write_text(text, encoding="utf-8")
    (book_dir / "glossary.md").write_text("| Kelime | Türkçe |\n|---|---|\n| mum |  |\n", encoding="utf-8")
    rep = lint_book(book_dir, word_targets=FIXTURE_WORDS)
    errs = codes(rep)
    assert "sentence-length" in errs          # A1 ≤ 8 kelime
    assert "book-structure" in errs           # p04 book.json'da yok
    assert "book-page-empty" in errs          # p03 boş kaldı
    assert "glossary-meaning" in errs         # Türkçe yok
    assert "translation" in errs              # değişen cümlenin çevirisi yok
    assert "book-align" in errs               # metin değişti, hizalama uyuşmuyor


def test_lint_a2_sentence_limit_and_translation_status(book_dir):
    _make_level(book_dir, "A2")
    target = book_dir.parent / "A2-K99-the-test-box"
    book_dir.rename(target)
    tr = json.loads((target / "ceviri.tr.json").read_text(encoding="utf-8"))
    tr["status"] = "DRAFT"
    (target / "ceviri.tr.json").write_text(json.dumps(tr), encoding="utf-8")
    rep = lint_book(target, word_targets={"A2": 46})
    assert "sentence-length" not in codes(rep)
    assert any("DRAFT" in str(i) for i in rep.warnings)


def test_lint_requires_files_and_matching_ids(book_dir):
    (book_dir / "rights-and-review.md").unlink()
    bj = json.loads((book_dir / "book.json").read_text(encoding="utf-8"))
    bj["chapters"][1]["pages"].append({"id": "p04"})
    bj["status"] = "READY"
    (book_dir / "book.json").write_text(json.dumps(bj), encoding="utf-8")
    rep = lint_book(book_dir, word_targets=FIXTURE_WORDS)
    errs = codes(rep)
    assert "book-files" in errs and "book-structure" in errs and "book-schema" in errs


# --- hizalama -----------------------------------------------------------------------------------

def test_sentence_timings_are_sentence_level():
    b = Book.load(FX)
    c1 = b.text.chapters[0]
    al = Alignment.load(FX / "audio" / "c1.align.json")
    t = sentence_timings(al, [s.text for s in c1.spoken()])
    assert len(t) == len(c1.spoken()) == 6
    assert [w["w"] for w in t[4]["words"]] == ['"What', "is", "in", "the", 'box?"', "asks", "her", "mum."]
    for a, b2 in zip(t, t[1:]):
        assert a["start"] < a["end"] <= b2["start"]
    assert t[0]["words"][0]["start"] == t[0]["start"]


def test_locate_detects_changed_text():
    al = Alignment.load(FX / "audio" / "c2.align.json")
    with pytest.raises(AlignmentMismatch):
        locate(al, ["The Key", "There is a cat under the bed."])


def test_concat_alignments_offsets():
    a = Alignment(list("Hi."), [0.0, 0.1, 0.2], [0.1, 0.2, 0.3])
    b = Alignment(list("Yo."), [0.0, 0.1, 0.2], [0.1, 0.2, 0.3])
    m = concat_alignments([(a, 1.0), (b, 1.0)], gap=0.4)
    assert m.text == "Hi. Yo."
    assert m.starts[4] == pytest.approx(1.4)
    assert [len(x) for x in locate(m, ["Hi.", "Yo."])] == [3, 3]


# --- paket --------------------------------------------------------------------------------------

def test_export_with_fake_media(book_dir):
    set_pacing(book_dir, {"mode": "off"})     # tempo işlemi ayrı testte (test_pacing.py)
    add_fake_media(book_dir)
    fm = FakeMedia()
    r = export(book_dir, media=fm)
    assert r.errors == [] and r.missing == []
    pkg = book_dir / "_build" / "package"
    pages = json.loads((pkg / "pages.json").read_text(encoding="utf-8"))
    assert schema_errors(pages, "pages.schema.json") == []
    assert schema_errors(json.loads((pkg / "book.json").read_text(encoding="utf-8")), "book.schema.json") == []
    assert [p["image"] for p in pages["pages"]] == ["images/p01.webp", None, "images/p03.webp"]
    ch = pages["chapters"][0]
    assert ch["audio"] == "audio/c1.m4a" and ch["duration"] == 12.5
    assert ch["heading"]["tr"] == "Küçük Bir Kutu" and ch["heading"]["start"] is not None
    s = pages["pages"][1]["sentences"][0]
    assert s["tr"].startswith('"Kutuda ne var?"')
    assert {w["w"]: w["gloss"] for w in s["words"]}["mum."] == "anne"
    assert s["chunks"] == [{"en": "What is in the box?", "tr": "Kutuda ne var?", "startWord": 0, "endWord": 4}]
    assert all(w["start"] is not None for p in pages["pages"] for x in p["sentences"] for w in x["words"])
    # tek kazanç: bütün bölümler -20 LUFS ölçüldü → +4 dB
    assert fm.audio_calls == [("c1.mp3", 4.0), ("c2.mp3", 4.0)]
    m = json.loads((pkg / "manifest.json").read_text(encoding="utf-8"))
    assert m["contentType"] == "BOOK" and m["loudness"]["gainDb"] == 4.0
    paths = {f["path"]: f for f in m["files"]}
    assert set(paths) == {"book.json", "pages.json", "audio/c1.m4a", "audio/c2.m4a",
                          "images/cover.webp", "images/p01.webp", "images/p03.webp"}
    assert paths["pages.json"]["sha256"] == file_digest(pkg / "pages.json")
    book = json.loads((pkg / "book.json").read_text(encoding="utf-8"))
    assert book["cover"] == "images/cover.webp" and book["pageCount"] == 3
    assert book["estimatedMinutes"] == pytest.approx(25 / 60, abs=0.05)
    assert "narration" not in book and "properNouns" not in book


def test_export_reports_missing_media_without_failing(book_dir):
    (book_dir / "audio" / "c2.align.json").unlink()
    r = export(book_dir, media=FakeMedia())
    kinds = sorted((x["kind"], x.get("chapter", x["path"])) for x in r.missing)
    assert ("alignment", "c2") in kinds and ("audio", "c1") in kinds and ("image", "images/p01.png") in kinds
    pages = r.pages
    assert pages["chapters"][0]["audio"] is None and pages["chapters"][0]["heading"]["start"] is not None
    assert pages["pages"][2]["sentences"][0]["start"] is None          # c2: zaman yok (sessiz okuma)
    assert schema_errors(pages, "pages.schema.json") == []
    assert r.manifest["missing"] == r.missing


def test_export_cli_require_media(book_dir, capsys, monkeypatch):
    monkeypatch.setattr("hvpipeline.bookexport.LocalMedia", FakeMedia)
    assert export_book.main([str(book_dir)]) == 0
    assert "git dışı medya" in capsys.readouterr().out
    assert export_book.main([str(book_dir), "--require-media"]) == 1


def test_export_fails_on_alignment_mismatch(book_dir):
    p = book_dir / "text.en.md"
    p.write_text(p.read_text(encoding="utf-8").replace("little cat", "little dog"), encoding="utf-8")
    with pytest.raises(BookError, match="hizalama"):
        export(book_dir, media=FakeMedia())


@pytest.mark.skipif(not (HAS_FFMPEG and HAS_MAGICK), reason="ffmpeg/ImageMagick yok")
def test_export_real_media_loudness_and_webp(book_dir):
    set_pacing(book_dir, {"mode": "off"})     # 6 sn'lik ton hizalamayla uyuşmaz; tempo test_pacing.py'de
    (book_dir / "images").mkdir()
    for c, f in (("c1", 330), ("c2", 440)):
        subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i", f"sine=frequency={f}:duration=6",
                        "-af", "volume=-12dB", "-c:a", "libmp3lame", "-b:a", "128k", str(book_dir / "audio" / f"{c}.mp3")],
                       check=True)
    for n in ("cover.png", "p01.png", "p03.png"):
        subprocess.run(["magick", "-size", "600x800", "gradient:#FFE08A-#D9534F", str(book_dir / "images" / n)], check=True)
    r = export(book_dir)
    assert r.missing == [] and r.errors == []
    pkg = r.package
    assert (pkg / "audio" / "c1.m4a").stat().st_size > 1000
    assert abs(r.manifest["loudness"]["after"]["I"] - (-16.0)) < 1.5
    out = subprocess.check_output(["magick", "identify", "-format", "%m %w", str(pkg / "images" / "p01.webp")]).decode()
    assert out == "WEBP 1080"
    assert r.pages["chapters"][0]["duration"] == pytest.approx(6.0, abs=0.1)


# --- TTS (ücretli API çağrılmaz; sahte istemci) -------------------------------------------------

def fake_response(text: str) -> dict:
    chars = list(text)
    starts = [round(0.08 * i, 3) for i in range(len(chars))]
    return {"audio_base64": base64.b64encode(b"ID3-fake-" + text_sha256(text)[:8].encode()).decode(),
            "alignment": {"characters": chars, "character_start_times_seconds": starts,
                          "character_end_times_seconds": [round(s + 0.08, 3) for s in starts]}}


class FakeClient:
    def __init__(self):
        self.calls = []

    def __call__(self, voice_id, payload):
        self.calls.append((voice_id, payload))
        return fake_response(payload["text"])


def _fresh_audio(d: Path) -> None:
    for f in (d / "audio").glob("*"):
        f.unlink()


SECRET = "sk_test_DO_NOT_WRITE_0123456789"


def test_tts_dry_run_never_calls_api(book_dir, tmp_path, capsys, monkeypatch):
    monkeypatch.setenv(tts.ENV_KEY, SECRET)
    monkeypatch.delenv(tts.ENV_CAP, raising=False)
    _fresh_audio(book_dir)

    def boom(*a, **k):
        raise AssertionError("kuru çalışmada API çağrılmamalı")
    assert tts_book.main([str(book_dir), "--ledger", str(tmp_path / "l.json")], client=boom) == 0
    out = capsys.readouterr().out
    assert "Kuru çalışma" in out and "ÜRET" in out and "kredi" in out and "TANIMLI DEĞİL" in out
    assert SECRET not in out
    assert not (tmp_path / "l.json").exists()


def test_tts_execute_refused_without_cap(book_dir, tmp_path, monkeypatch, capsys):
    monkeypatch.delenv(tts.ENV_CAP, raising=False)
    _fresh_audio(book_dir)
    fc = FakeClient()
    assert tts_book.main([str(book_dir), "--execute", "--ledger", str(tmp_path / "l.json")], client=fc) == 1
    assert fc.calls == []
    assert "tavan" in capsys.readouterr().err


def test_tts_execute_writes_audio_alignment_log_and_is_idempotent(book_dir, tmp_path, monkeypatch):
    monkeypatch.setenv(tts.ENV_KEY, SECRET)
    monkeypatch.setenv(tts.ENV_CAP, "10000")
    _fresh_audio(book_dir)
    ledger = tmp_path / "l.json"
    fc = FakeClient()
    assert tts_book.main([str(book_dir), "--execute", "--ledger", str(ledger)], client=fc) == 0
    assert len(fc.calls) == 2
    voice, payload = fc.calls[0]
    assert voice == "test-voice-id"
    assert payload["model_id"] == "eleven_v3" and payload["language_code"] == "en"
    assert payload["voice_settings"] == {"stability": 0.5, "similarity_boost": 0.75, "speed": 0.9}
    b = Book.load(book_dir)
    assert payload["text"] == b.text.chapters[0].tts_text()
    doc = json.loads((book_dir / "audio" / "c1.align.json").read_text(encoding="utf-8"))
    assert doc["textSha256"] == text_sha256(payload["text"])
    assert (book_dir / "audio" / "c1.mp3").read_bytes().startswith(b"ID3-fake")
    prompts = (book_dir / "PROMPTS.md").read_text(encoding="utf-8")
    assert tts.PROMPTS_HEADING in prompts and "| c1 | 1/1 | test-voice-id | eleven_v3 | 0.9 |" in prompts
    used = json.loads(ledger.read_text(encoding="utf-8"))
    month = tts.month_key()
    assert used[month]["characters"] == sum(len(c.tts_text()) for c in b.text.chapters)
    # anahtar hiçbir dosyaya yazılmaz
    for f in [*book_dir.rglob("*"), ledger]:
        if f.is_file():
            assert SECRET.encode() not in f.read_bytes(), f
    # lint yeni hizalamayı kabul eder; export zamanları üretir
    assert "book-align" not in codes(lint_book(book_dir, word_targets=FIXTURE_WORDS))
    # ikinci çalışma: hiçbir çağrı yok
    fc2 = FakeClient()
    assert tts_book.main([str(book_dir), "--execute", "--ledger", str(ledger)], client=fc2) == 0
    assert fc2.calls == []
    assert prompts == (book_dir / "PROMPTS.md").read_text(encoding="utf-8")
    # metin değişince yalnız o bölüm yeniden üretilir
    p = book_dir / "text.en.md"
    p.write_text(p.read_text(encoding="utf-8").replace("little cat", "little dog"), encoding="utf-8")
    plan = tts.plan_book(Book.load(book_dir))
    assert [(j.chapter.id, j.action) for j in plan.jobs] == [("c1", "skip"), ("c2", "generate")]


def test_tts_cap_stops_before_call(book_dir, tmp_path, monkeypatch):
    _fresh_audio(book_dir)
    ledger = tmp_path / "l.json"
    tts.ledger_add(ledger, tts.month_key(), 9990)
    fc = FakeClient()
    assert tts_book.main([str(book_dir), "--execute", "--monthly-char-cap", "10000", "--ledger", str(ledger)],
                         client=fc) == 1
    assert fc.calls == []
    assert not (book_dir / "audio" / "c1.mp3").exists()


def test_tts_multi_part_chapter_uses_cache_and_concat(book_dir, tmp_path, monkeypatch):
    _fresh_audio(book_dir)
    monkeypatch.setitem(tts.MAX_CHARS, "eleven_v3", 60)
    plan = tts.plan_book(Book.load(book_dir))
    assert len(plan.jobs[0].parts) > 1 and all(len(p) <= 60 for p in plan.jobs[0].parts)
    joined = []

    def concat(paths, gap, out):
        joined.append((len(paths), gap))
        out.write_bytes(b"".join(p.read_bytes() for p in paths))
        return out
    fc = FakeClient()
    ledger = tmp_path / "l.json"
    r = tts.execute(plan, fc, 10_000, ledger, concat=concat, duration=lambda p: 5.0, log=lambda s: None)
    assert r.generated == ["c1", "c2"] and joined and joined[0][1] == tts.PART_GAP
    n_calls = len(fc.calls)
    # hizalama birleşik metinle uyuşur → paket zamanları üretilir
    b = Book.load(book_dir)
    al = Alignment.load(book_dir / "audio" / "c1.align.json")
    t = sentence_timings(al, [s.text for s in b.text.chapters[0].spoken()])
    assert t[-1]["start"] > 5.0
    # bölüm dosyaları silinse bile ödenmiş parçalar önbellekten gelir: yeni çağrı yok
    (book_dir / "audio" / "c1.mp3").unlink()
    (book_dir / "audio" / "c1.align.json").unlink()
    fc2 = FakeClient()
    tts.execute(tts.plan_book(Book.load(book_dir)), fc2, 10_000, ledger, concat=concat,
                duration=lambda p: 5.0, log=lambda s: None)
    assert fc2.calls == [] and n_calls == len(fc.calls)
    assert (book_dir / "audio" / "c1.align.json").exists()


def test_tts_http_client_requires_env_key(monkeypatch):
    monkeypatch.delenv(tts.ENV_KEY, raising=False)
    with pytest.raises(tts.TtsError, match=tts.ENV_KEY):
        tts.http_client()


def test_split_parts_respects_limit():
    text = "A b c.\n\n" + " ".join(["Word word word."] * 10)
    parts = tts.split_parts(text, 40)
    assert all(len(p) <= 40 for p in parts)
    assert "".join(parts).replace("\n", "").replace(" ", "") == text.replace("\n", "").replace(" ", "")


# --- geliştirme içerik sunucusu -----------------------------------------------------------------

def _load_server():
    spec = importlib.util.spec_from_file_location("hv_serve", REPO / "tools" / "dev-content-server" / "serve.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_dev_server_serves_books_with_range(book_dir):
    add_fake_media(book_dir)
    export(book_dir, media=FakeMedia())
    serve = _load_server()
    serve.Handler.root = book_dir.parent / "icerik-yok"
    serve.Handler.books_root = book_dir.parent
    serve.Handler.quiet = True
    srv = serve.ThreadingHTTPServer(("127.0.0.1", 0), serve.Handler)
    th = threading.Thread(target=srv.serve_forever, daemon=True)
    th.start()
    try:
        base = f"http://127.0.0.1:{srv.server_address[1]}"
        idx = json.loads(urllib.request.urlopen(f"{base}/books/index.json").read())
        assert [b["id"] for b in idx["books"]] == ["A1-K99"]
        assert idx["books"][0]["level"] == "A1" and "dir" not in idx["books"][0]
        pages = json.loads(urllib.request.urlopen(f"{base}/books/A1-K99/pages.json").read())
        assert pages["bookId"] == "A1-K99"
        req = urllib.request.Request(f"{base}/books/A1-K99/audio/c1.m4a", headers={"Range": "bytes=0-3"})
        with urllib.request.urlopen(req) as r:
            assert r.status == 206 and r.read() == b"m4a:" and r.headers["Content-Type"] == "audio/mp4"
        with pytest.raises(urllib.error.HTTPError) as e:
            urllib.request.urlopen(f"{base}/books/A1-K00/book.json")
        assert e.value.code == 404
        # bölüm dizini kitaplardan etkilenmez
        assert json.loads(urllib.request.urlopen(f"{base}/packages/index.json").read())["packages"] == []
    finally:
        srv.shutdown()
        srv.server_close()
