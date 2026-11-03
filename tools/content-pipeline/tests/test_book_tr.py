"""H-105: kitaplarda "Sayfanın Türkçesi"nin Alania sesi. Ağ yok: sahte istemci ve sahte medya."""

from __future__ import annotations

import json
from pathlib import Path

import pytest

import book_lint
import export_book
import tts_book_tr
from hvpipeline import booktr
from hvpipeline import tts_tr as tr
from hvpipeline.book import Book
from hvpipeline.booklint import lint_book
from hvpipeline.bookexport import export_book as export
from hvpipeline.graph import schema_errors
from test_books import FakeMedia, add_fake_media, book_dir, set_pacing  # noqa: F401  (fixture)
from test_tts_tr import FakeClient, fake_finalize, fake_words

P1 = "Küçük Bir Kutu. Ece'nin küçük bir kutusu var. Kutu kırmızı. Onu açamıyor."


def set_narration_tr(d: Path, cfg: dict | None) -> None:
    bj = json.loads((d / "book.json").read_text(encoding="utf-8"))
    bj.pop("narrationTr", None)
    if cfg is not None:
        bj["narrationTr"] = cfg
    (d / "book.json").write_text(json.dumps(bj, ensure_ascii=False), encoding="utf-8")


def edit_tr(d: Path, en: str, tr: str) -> None:
    p = d / "ceviri.tr.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    for ln in doc["lines"]:
        if ln["en"] == en:
            ln["tr"] = tr
    p.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")


def run(d: Path, tmp_path: Path, client, *extra) -> int:
    return tts_book_tr.main([str(d), "--ledger", str(tmp_path / "ledger.json"), *extra],
                            client=client, finalize=fake_finalize, sleep=lambda s: None)


# --- metin ---------------------------------------------------------------------------------------

def test_page_text_matches_reader_panel(book_dir):
    """Uygulamanın `turkishOf` kuralı: bölümün ilk sayfasında başlık önce; cümleler sırasıyla."""
    pts = booktr.page_turkish(Book.load(book_dir))
    assert [p.page for p in pts] == ["p01", "p02", "p03"]
    assert pts[0].text == P1
    assert pts[1].text == "\"Kutuda ne var?\" diye soruyor annesi. Ece bilmiyor."
    assert pts[2].lines[0] == "Anahtar."


def test_page_without_turkish_is_skipped(book_dir):
    edit_tr(book_dir, "\"What is in the box?\" asks her mum.", "")
    edit_tr(book_dir, "Ece does not know.", "  ")
    assert [p.page for p in booktr.page_turkish(Book.load(book_dir))] == ["p01", "p03"]


def test_pronunciations_are_case_sensitive_and_only_present_terms(book_dir):
    set_narration_tr(book_dir, {"pronunciations": [{"term": "Ece", "say_as": "Ece"},
                                                    {"term": "Kutu", "say_as": "Kuutu"},
                                                    {"term": "Theo", "say_as": "Tiyo"}]})
    segs = {s.id: s for s in booktr.segments(Book.load(book_dir))}
    assert segs["p01"].pronunciations == [{"term": "Ece", "say_as": "Ece"}, {"term": "Kutu", "say_as": "Kuutu"}]
    # "kutuyu" küçük harf: eşleşmez; Theo hiç geçmiyor
    assert segs["p03"].pronunciations == [{"term": "Ece", "say_as": "Ece"}]


def test_voice_role_from_voice_map(book_dir):
    voice, _, model = booktr.voice_for(Book.load(book_dir))
    assert voice == "alania2-f1" and model == "alania-v2"       # Hi (varsayılan rol)
    set_narration_tr(book_dir, {"role": "narrator"})
    assert booktr.voice_for(Book.load(book_dir))[0] == "alania2-m1"
    set_narration_tr(book_dir, {"role": "yok"})
    with pytest.raises(booktr.BookTrError):
        booktr.voice_for(Book.load(book_dir))


def test_book_schema_accepts_narration_tr(book_dir):
    set_narration_tr(book_dir, {"role": "hi", "pronunciations": [{"term": "Theo", "say_as": "Tiyo"}]})
    bj = json.loads((book_dir / "book.json").read_text(encoding="utf-8"))
    assert schema_errors(bj, "book.schema.json") == []
    bj["narrationTr"]["pronunciations"][0].pop("say_as")
    assert schema_errors(bj, "book.schema.json") != []


# --- CLI: kuru çalışma, tavan, üretim, idempotentlik ----------------------------------------------

def test_dry_run_never_calls_api(book_dir, tmp_path, capsys, monkeypatch):
    monkeypatch.delenv("HIVELZON_TR_TTS_MONTHLY_CHAR_CAP", raising=False)
    c = FakeClient()
    assert run(book_dir, tmp_path, c) == 0
    out = capsys.readouterr().out
    assert c.speech_calls == [] and "Kuru çalışma" in out and "3 sayfa" in out and "TANIMLI DEĞİL" in out
    assert not (book_dir / "audio" / "tr").exists()


def test_execute_refused_without_cap(book_dir, tmp_path, monkeypatch):
    monkeypatch.delenv("HIVELZON_TR_TTS_MONTHLY_CHAR_CAP", raising=False)
    c = FakeClient()
    assert run(book_dir, tmp_path, c, "--execute") == 1
    assert c.speech_calls == []


def test_execute_writes_pages_and_is_idempotent(book_dir, tmp_path):
    set_narration_tr(book_dir, {"pronunciations": [{"term": "Ece", "say_as": "Ece"}]})
    c = FakeClient()
    assert run(book_dir, tmp_path, c, "--execute", "--monthly-char-cap", "100000") == 0
    out = book_dir / "audio" / "tr"
    assert sorted(p.name for p in out.glob("*.mp3")) == ["p01.mp3", "p02.mp3", "p03.mp3"]
    al = json.loads((out / "p01.align.json").read_text(encoding="utf-8"))
    assert al["text"] == P1 and al["voice_id"] == "alania2-f1" and al["quality"]["ok"]
    assert c.speech_calls[0]["input"] == P1 and c.speech_calls[0]["pronunciations"] == [{"term": "Ece", "say_as": "Ece"}]
    assert len(list((out / "_raw").glob("*.wav"))) == 3
    led = json.loads((tmp_path / "ledger.json").read_text(encoding="utf-8"))
    assert sum(m["characters"] for m in led.values()) == sum(len(x["input"]) for x in c.speech_calls)
    assert "| p01 | alania-v2 | alania2-f1 |" in (book_dir / "PROMPTS.md").read_text(encoding="utf-8")
    # ikinci çalıştırma: çağrı yok
    c2 = FakeClient()
    assert run(book_dir, tmp_path, c2, "--execute", "--monthly-char-cap", "100000") == 0
    assert c2.speech_calls == [] and c2.stt_calls == []
    # yalnız değişen sayfa yeniden üretilir
    edit_tr(book_dir, "Ece does not know.", "Ece de bilmiyor.")
    c3 = FakeClient()
    assert run(book_dir, tmp_path, c3, "--execute", "--monthly-char-cap", "100000") == 0
    assert [x["input"] for x in c3.speech_calls] == ["\"Kutuda ne var?\" diye soruyor annesi. Ece de bilmiyor."]


def test_cap_stops_before_paid_call(book_dir, tmp_path):
    c = FakeClient()
    assert run(book_dir, tmp_path, c, "--execute", "--monthly-char-cap", str(len(P1) + 5)) == 1
    assert len(c.speech_calls) == 1                      # yalnız p01 sığdı
    assert (book_dir / "audio" / "tr" / "p01.mp3").exists()
    assert not (book_dir / "audio" / "tr" / "p02.mp3").exists()


def test_strict_returns_3_on_alignment_warning(book_dir, tmp_path):
    c = FakeClient(replace={"Kutu": "Kuti", "kırmızı.": "", "Onu": "", "açamıyor.": ""})
    assert run(book_dir, tmp_path, c, "--execute", "--monthly-char-cap", "100000", "--strict") == 3


# --- lint ve paket --------------------------------------------------------------------------------

def produce(book_dir: Path, tmp_path: Path) -> None:
    assert run(book_dir, tmp_path, FakeClient(), "--execute", "--monthly-char-cap", "100000") == 0


def test_lint_without_turkish_audio_is_silent(book_dir):
    rep = lint_book(book_dir)
    assert not [i for i in rep.issues if i.code.startswith("book-tr")]
    assert rep.stats["trAudio"] == {"pages": 3, "aligned": 0, "audio": 0, "stale": 0}


def test_lint_reports_stale_and_missing_turkish_audio_as_warnings(book_dir, tmp_path, capsys):
    produce(book_dir, tmp_path)
    rep = lint_book(book_dir)
    assert rep.stats["trAudio"] == {"pages": 3, "aligned": 3, "audio": 3, "stale": 0}
    assert not [i for i in rep.issues if i.code.startswith("book-tr")]
    edit_tr(book_dir, "It is a little cat!", "Minik bir kedi!")
    (book_dir / "audio" / "tr" / "p01.mp3").unlink()
    rep = lint_book(book_dir)
    msgs = [str(i) for i in rep.warnings]
    assert any("p03" in m and "eski metinden" in m for m in msgs)
    assert any("p01" in m and "Türkçe ses bu ortamda yok" in m for m in msgs)
    assert not [i for i in rep.errors if "tr" in i.code]
    assert book_lint.main([str(book_dir)]) in (0, 1)
    assert "Türkçe sayfa sesi: 2/3 sayfa hizalı" in capsys.readouterr().out


def test_export_packages_turkish_page_audio(book_dir, tmp_path):
    set_pacing(book_dir, {"mode": "off"})
    add_fake_media(book_dir)
    produce(book_dir, tmp_path)
    fm = FakeMedia()
    r = export(book_dir, media=fm)
    assert r.errors == [] and r.missing == [] and r.tr_missing == []
    pkg = book_dir / "_build" / "package"
    pages = json.loads((pkg / "pages.json").read_text(encoding="utf-8"))
    assert schema_errors(pages, "pages.schema.json") == []
    assert [p.get("trAudio") for p in pages["pages"]] == ["audio/tr/p01.m4a", "audio/tr/p02.m4a", "audio/tr/p03.m4a"]
    assert pages["pages"][0]["trDuration"] == 12.5
    assert ("p01.mp3", 4.0) in fm.audio_calls                # sayfa başına -16 LUFS
    m = r.manifest
    assert m["trAudio"] == {"pages": 3, "packaged": 3, "aligned": 3, "stale": 0}
    assert "audio/tr/p02.m4a" in {f["path"] for f in m["files"]}


def test_export_skips_stale_or_absent_turkish_audio_and_never_requires_it(book_dir, tmp_path, capsys, monkeypatch):
    set_pacing(book_dir, {"mode": "off"})
    add_fake_media(book_dir)
    r = export(book_dir, media=FakeMedia())
    assert all("trAudio" not in p for p in r.pages["pages"]) and r.tr_missing == []
    produce(book_dir, tmp_path)
    edit_tr(book_dir, "It is a little cat!", "Minik bir kedi!")
    (book_dir / "audio" / "tr" / "p01.mp3").unlink()
    r = export(book_dir, media=FakeMedia())
    assert [p.get("trAudio") for p in r.pages["pages"]] == [None, "audio/tr/p02.m4a", None]
    assert sorted((x["page"], x["reason"]) for x in r.tr_missing) == [("p01", "no-audio"), ("p03", "stale")]
    assert r.missing == []
    monkeypatch.setattr("hvpipeline.bookexport.LocalMedia", FakeMedia)
    assert export_book.main([str(book_dir), "--require-media"]) == 0
    out = capsys.readouterr().out
    assert "UYARI [book-tr-audio] p03" in out and "1/3 sayfa pakette" in out


class SkippingClient(FakeClient):
    """Duyu uzun seste ortadaki kelimeleri atlar (2026-11-03 gözlemi); kesit ayrıca dökülünce bulunur."""

    def transcribe(self, wav, filename):
        self.stt_calls.append(filename)
        if len(wav) in self.last_text:
            text = self.last_text[len(wav)]
            words = fake_words(text)
            self.full = words
            kept = words[:2] + [w for w in words if w["start"] > words[2]["start"] + 3.2]
            assert len(kept) < len(words)
            return {"text": "", "words": kept, "language": "tr", "duration": tr.wav_duration(wav)}, {}
        # kesit: [a, b] aralığındaki kelimeler kesite göre zamanlı
        a = self.full[1]["end"]
        b = next(w["start"] for w in self.full if w["start"] > self.full[2]["start"] + 3.2)
        mid = [{**w, "start": round(w["start"] - a, 3), "end": round(w["end"] - a, 3)}
               for w in self.full if w["start"] >= a and w["end"] <= b]
        return {"text": "", "words": mid, "language": "tr", "duration": b - a}, {}


def test_duyu_gap_is_retranscribed(book_dir, tmp_path, monkeypatch):
    long = "Bir iki üç dört beş altı yedi sekiz dokuz on on bir on iki on üç on dört on beş on altı."
    edit_tr(book_dir, "Ece has a small box.", long)
    c = SkippingClient()
    assert run(book_dir, tmp_path, c, "--execute", "--monthly-char-cap", "100000", "--page", "p01") == 0
    al = json.loads((book_dir / "audio" / "tr" / "p01.align.json").read_text(encoding="utf-8"))
    assert al["quality"]["ok"] and al["quality"]["missing"] == 0
    assert len(c.stt_calls) == 2 and c.stt_calls[1].endswith(".wav") and "-" in c.stt_calls[1]


def test_duyu_gaps_include_head_and_tail():
    w = [{"word": "a", "start": 0.2, "end": 0.5}, {"word": "b", "start": 0.6, "end": 1.0},
         {"word": "c", "start": 5.0, "end": 5.4}]
    assert tr.duyu_gaps(w) == [(1.0, 5.0)]
    assert tr.duyu_gaps(w, duration=20.0) == [(1.0, 5.0), (5.4, 20.0)]
    assert tr.duyu_gaps([{"word": "x", "start": 4.0, "end": 4.3}], duration=5.0) == [(0.0, 4.0)]
    assert tr.duyu_gaps([], duration=9.0) == []
