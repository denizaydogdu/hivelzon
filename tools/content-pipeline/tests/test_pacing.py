"""Kitap anlatım temposu (H-069): kesim + sessizlik + atempo, zaman eşlemesi, auto hesap, book-lint, paket."""

from __future__ import annotations

import json
import shutil
import subprocess
from pathlib import Path

import pytest

from hvpipeline import media, pacing
from hvpipeline.align import Alignment, sentence_timings
from hvpipeline.book import Book
from hvpipeline.bookexport import export_book as export
from hvpipeline.booklint import lint_book
from hvpipeline.graph import schema_errors
from test_books import FIXTURE_WORDS, FX, HAS_FFMPEG, FakeMedia, add_fake_media, set_pacing


@pytest.fixture
def book_dir(tmp_path) -> Path:
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    return d


def fixture_chapter(cid: str = "c1"):
    b = Book.load(FX)
    c = next(c for c in b.text.chapters if c.id == cid)
    t = sentence_timings(Alignment.load(b.align_path(cid)), [s.text for s in c.spoken()])
    return c, t, pacing.chapter_units(c)


def synth(n_sent: int, words: int, speech: float, gap: float) -> tuple[list[dict], list[tuple[str, int]]]:
    """Yapay bölüm: her cümle `words` kelime, `speech` sn; cümleler arası `gap` sn; 4 cümlede bir paragraf,
    8 cümlede bir sayfa; ilk birim başlık."""
    out, units, t = [], [], 0.0
    for i in range(n_sent):
        w = speech / words
        out.append({"start": round(t, 3), "end": round(t + speech, 3),
                    "words": [{"w": f"w{k}", "start": round(t + k * w, 3), "end": round(t + (k + 1) * w - 0.02, 3)}
                              for k in range(words)]})
        units.append(("", 0) if i == 0 else (f"p{(i - 1) // 8 + 1:02d}", (i - 1) % 8 // 4 + 1))
        t += speech + gap
    return out, units


# --- ayar ---------------------------------------------------------------------------------------

def test_settings_level_defaults_and_validation():
    assert pacing.settings({}, "A1")["mode"] == "auto"
    assert pacing.settings({}, "B1")["mode"] == "auto"
    assert pacing.settings({}, "B2")["mode"] == "off"
    assert pacing.settings({}, "C2")["mode"] == "off"
    assert pacing.settings({"narration": {"pacing": {"mode": "off"}}}, "A1")["mode"] == "off"
    m = pacing.settings({"narration": {"pacing": {"mode": "manual"}}}, "B2")
    assert m == {"mode": "manual", "sentencePauseSec": pacing.MANUAL_PAUSE, "tempo": 1.0}
    with pytest.raises(pacing.PacingError):
        pacing.settings({"narration": {"pacing": {"mode": "fast"}}}, "A1")
    with pytest.raises(pacing.PacingError):
        pacing.settings({"narration": {"pacing": {"mode": "manual", "tempo": 0.8}}}, "A1")


def test_schema_accepts_pacing_and_rejects_low_tempo():
    bj = json.loads((FX / "book.json").read_text(encoding="utf-8"))
    bj["narration"]["pacing"] = {"mode": "manual", "sentencePauseSec": 0.9, "tempo": 0.9}
    assert schema_errors(bj, "book.schema.json") == []
    bj["narration"]["pacing"]["tempo"] = 0.8
    assert schema_errors(bj, "book.schema.json")
    bj["narration"]["pacing"] = {"mode": "slow"}
    assert schema_errors(bj, "book.schema.json")


# --- auto hesap ---------------------------------------------------------------------------------

def test_auto_prefers_pauses_and_hits_level_middle():
    t, u = synth(30, 6, 2.2, 0.25)                      # ~140 k/dk ham
    assert pacing.wpm(t) > 130
    pause, tempo = pacing.auto_params(t, pacing.boundaries(t, u), 105.0)
    assert 0 < pause <= pacing.AUTO_MAX_PAUSE and tempo == 1.0
    plan = pacing.plan_chapter(t, u, {"mode": "auto"}, "A1", t[-1]["end"])
    assert (plan.pause, plan.tempo) == (pause, tempo)
    assert pacing.wpm(pacing.apply(t, plan)) == pytest.approx(105, abs=1.0)


def test_auto_uses_tempo_after_max_pause():
    t, u = synth(30, 6, 2.0, 0.05)                      # ~175 k/dk: duraklama tek başına yetmez
    pause, tempo = pacing.auto_params(t, pacing.boundaries(t, u), 105.0)
    assert pause == pacing.AUTO_MAX_PAUSE and pacing.MIN_TEMPO <= tempo < 1.0
    plan = pacing.plan_chapter(t, u, {"mode": "auto"}, "A1", t[-1]["end"])
    assert pacing.wpm(pacing.apply(t, plan)) == pytest.approx(105, abs=1.5)


def test_auto_never_below_min_tempo_and_never_speeds_up():
    t, u = synth(10, 8, 1.0, 0.0)                       # aşırı hızlı: alt sınırlarda kalır
    assert pacing.auto_params(t, pacing.boundaries(t, u), 105.0) == (pacing.AUTO_MAX_PAUSE, pacing.MIN_TEMPO)
    slow, us = synth(10, 4, 3.0, 0.6)                   # zaten yavaş (~70 k/dk): dokunulmaz
    assert pacing.auto_params(slow, pacing.boundaries(slow, us), 105.0) == (0.0, 1.0)
    assert pacing.plan_chapter(slow, us, {"mode": "auto"}, "A1", 40.0) is None


def test_auto_targets_level_middle():
    assert pacing.target_wpm("A1") == 105 and pacing.target_wpm("A2") == 120 and pacing.target_wpm("B1") == 135


# --- zaman kaydırma -----------------------------------------------------------------------------

def test_boundary_kinds_from_fixture():
    c, t, u = fixture_chapter("c1")
    kinds = [b.kind for b in pacing.boundaries(t, u)]
    # başlık→p01 sayfa; p01 s01→s02 aynı paragraf; s02→s03 paragraf; p01→p02 sayfa; p02 içi cümle
    assert kinds == ["page", "sentence", "paragraph", "page", "sentence"]


def test_timing_shift_monotonic_inside_duration_and_gaps():
    c, t, u = fixture_chapter("c1")
    cfg = {"mode": "manual", "sentencePauseSec": 0.8, "tempo": 0.9}
    plan = pacing.plan_chapter(t, u, cfg, "A1", 10.8)
    paced = pacing.apply(t, plan)
    total = plan.out_total / plan.sr
    assert paced[0]["start"] == 0.0
    flat = [(w["start"], w["end"]) for s in paced for w in s["words"]]
    for (a0, a1), (b0, b1) in zip(flat, flat[1:]):
        assert a0 <= a1 <= b0 <= b1
    for s in paced:
        assert s["start"] == s["words"][0]["start"] and s["end"] == s["words"][-1]["end"]
        assert 0 <= s["start"] < s["end"] <= total + 0.0005   # 3 basamak yuvarlama
    # boşluk = max(çarpan × duraklama, doğal boşluk / tempo)  (yuvarlama payı 2 ms)
    for b, s0, s1 in zip(pacing.boundaries(t, u), paced, paced[1:]):
        want = max(pacing.FACTORS[b.kind] * 0.8, b.gap / 0.9)
        assert s1["start"] - s0["end"] == pytest.approx(want, abs=0.002)
    # kelime süreleri tempoyla uzar
    w0, p0 = t[1]["words"][0], paced[1]["words"][0]
    assert p0["end"] - p0["start"] == pytest.approx((w0["end"] - w0["start"]) / 0.9, abs=0.002)
    # eşlenen süre: kaynak / tempo + eklenen sessizlik
    assert total == pytest.approx(10.8 / 0.9 + sum(plan.pauses) / plan.sr, abs=0.001)


def test_cuts_stay_between_sentences_and_follow_quietest_window():
    c, t, u = fixture_chapter("c1")
    bounds = pacing.boundaries(t, u)
    env = [1000.0] * 1100
    b = bounds[0]                                        # başlık sonu 0.775 → 1.3
    env[110] = 5.0                                       # 1.10–1.11 sn en sessiz
    assert pacing.choose_cut(b, env) == pytest.approx(1.105)
    plan = pacing.plan_chapter(t, u, {"mode": "manual", "sentencePauseSec": 0.5, "tempo": 1.0}, "A1", 10.8, env=env)
    for cut, b in zip(plan.cuts, bounds):
        assert b.prev_end * plan.sr <= cut <= b.next_start * plan.sr
    assert plan.cuts == sorted(plan.cuts)
    # zarf yoksa orta nokta; eşlenen zamanlar kesim yerinden bağımsız
    plan2 = pacing.plan_chapter(t, u, {"mode": "manual", "sentencePauseSec": 0.5, "tempo": 1.0}, "A1", 10.8)
    b0 = bounds[0]
    assert plan2.cuts[0] == round((b0.prev_end + b0.next_start) / 2 * plan2.sr) != plan.cuts[0]
    assert pacing.apply(t, plan) == pacing.apply(t, plan2)


def test_cut_moves_to_real_silence_when_alignment_gap_is_not_quiet():
    """ElevenLabs hizalaması gerçek sessizlikten önce bitebilir: boşluk sessiz değilse ±0,25 sn içinde en
    sessiz yer seçilir; cümle zamanları yine kendi parçasında kalır (vurgu duraklamaya düşmez)."""
    c, t, u = fixture_chapter("c1")
    b = pacing.boundaries(t, u)[0]                       # hizalama boşluğu 0.775 → 1.3
    env = [1000.0] * 1100
    for i in range(132, 140):                            # gerçek sessizlik 1.32–1.40 (boşluğun dışında)
        env[i] = 1.0
    cut = pacing.choose_cut(b, env)
    assert 1.32 <= cut <= 1.40
    plan = pacing.plan_chapter(t, u, {"mode": "manual", "sentencePauseSec": 1.0, "tempo": 1.0}, "A1", 10.8, env=env)
    assert plan.cuts[0] == round(cut * plan.sr)
    paced = pacing.apply(t, plan)
    seg1 = plan.out_starts()[1] / plan.sr
    assert paced[1]["start"] == pytest.approx(seg1, abs=0.001)     # sıkıştırıldı: parçanın başı
    assert paced[1]["start"] - paced[0]["end"] >= 1.5 * 1.0 - 0.002
    flat = [x for s in paced for w in s["words"] for x in (w["start"], w["end"])]
    assert flat == sorted(flat)
    # sessiz pencere yoksa (hepsi eşit) hizalama boşluğunun ortası
    assert pacing.choose_cut(b, [1000.0] * 1100) == pytest.approx((b.prev_end + b.next_start) / 2, abs=0.006)


def test_plan_is_deterministic_and_off_is_identity():
    c, t, u = fixture_chapter("c1")
    p1 = pacing.plan_chapter(t, u, {"mode": "auto"}, "A1", 10.8)
    p2 = pacing.plan_chapter(t, u, {"mode": "auto"}, "A1", 10.8)
    assert p1 == p2 and pacing.apply(t, p1) == pacing.apply(t, p2)
    assert pacing.plan_chapter(t, u, {"mode": "off"}, "A1", 10.8) is None
    assert pacing.apply(t, None) == t


def test_filter_has_exact_segment_lengths():
    c, t, u = fixture_chapter("c1")
    plan = pacing.plan_chapter(t, u, {"mode": "manual", "sentencePauseSec": 0.6, "tempo": 0.9}, "A1", 10.8)
    segs = plan.segments()
    f = media.pacing_filter(segs, plan.tempo)
    assert f.count("atempo=0.9") == len(segs) == len(plan.cuts) + 1
    for s in segs:
        assert f"apad=whole_len={s['out'] + s['pad']},atrim=end_sample={s['out'] + s['pad']}" in f


# --- book-lint ----------------------------------------------------------------------------------

def test_lint_reports_raw_and_paced_speed(book_dir):
    rep = lint_book(book_dir, word_targets=FIXTURE_WORDS)
    md = rep.stats["media"]
    assert md["wpmRaw"]["c1"] > 121                      # ham: aralık dışı
    assert md["wpm"]["c1"] == pytest.approx(105, abs=2)  # auto sonrası: aralığın ortası
    assert md["pacing"]["c1"]["mode"] == "auto"
    assert "book-speed" not in [i.code for i in rep.warnings]
    set_pacing(book_dir, {"mode": "off"})
    rep = lint_book(book_dir, word_targets=FIXTURE_WORDS)
    assert any(i.code == "book-speed" and "c1" in i.message for i in rep.warnings)
    assert rep.stats["media"]["wpm"]["c1"] == rep.stats["media"]["wpmRaw"]["c1"]


# --- paket (sahte medya) ------------------------------------------------------------------------

def test_export_paced_timings_and_manifest_fake_media(book_dir):
    add_fake_media(book_dir)
    fm = FakeMedia()
    r = export(book_dir, media=fm)
    assert r.errors == []
    assert [x[0] for x in fm.pace_calls] == ["c1.mp3", "c2.mp3"]
    assert [x[0] for x in fm.audio_calls] == ["c1.paced.wav", "c2.paced.wav"]   # kazanç işlenmiş sese
    pc = r.manifest["pacing"]["c1"]
    assert pc["applied"] and pc["mode"] == "auto" and pc["wpm"] == pytest.approx(105, abs=2)
    ch = r.pages["chapters"][0]
    first_page = r.pages["pages"][0]["sentences"]
    assert ch["heading"]["start"] == 0.0
    assert first_page[0]["start"] - ch["heading"]["end"] >= pacing.FACTORS["page"] * pc["sentencePauseSec"] - 0.002
    assert first_page[-1]["end"] <= ch["duration"]
    assert schema_errors(r.pages, "pages.schema.json") == []
    before = (r.package / "pages.json").read_bytes()
    export(book_dir, media=FakeMedia())
    assert (r.package / "pages.json").read_bytes() == before            # idempotent


def test_export_without_audio_still_paces_timings(book_dir):
    r = export(book_dir, media=FakeMedia())                            # ses yok: hizalamadan plan
    assert r.pacing["c1"]["applied"] and r.pages["chapters"][0]["audio"] is None
    add_fake_media(book_dir)
    r2 = export(book_dir, media=FakeMedia())
    strip = lambda p: [[(s["start"], s["end"]) for s in pg["sentences"]] for pg in p["pages"]]  # noqa: E731
    assert strip(r.pages) == strip(r2.pages)


# --- gerçek ffmpeg: yapay ton sesiyle uçtan uca -------------------------------------------------

def tone_audio(path: Path, timings: list[dict], end: float) -> None:
    """Her cümle aralığında 440 Hz ton, arada tam sessizlik (örnek düzeyinde, aevalsrc)."""
    gate = "+".join(f"between(t,{s['start']},{s['end']})" for s in timings)
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i",
                    f"aevalsrc='0.3*sin(2*PI*440*t)*gt({gate},0)':s=44100:d={end}",
                    "-c:a", "libmp3lame", "-b:a", "128k", str(path)], check=True)


@pytest.mark.skipif(not HAS_FFMPEG, reason="ffmpeg yok")
def test_export_real_ffmpeg_pacing_matches_audio(book_dir):
    set_pacing(book_dir, {"mode": "manual", "sentencePauseSec": 0.7, "tempo": 0.9})
    b = Book.load(book_dir)
    for c in b.text.chapters:
        t = sentence_timings(Alignment.load(b.align_path(c.id)), [s.text for s in c.spoken()])
        tone_audio(b.audio_path(c.id), t, t[-1]["end"] + 0.3)
    r = export(book_dir)
    assert r.errors == [] and not [m for m in r.missing if m["kind"] != "image"]
    lo = r.manifest["loudness"]["after"]
    assert abs(lo["I"] - (-16.0)) < 1.0 and lo["TP"] <= -1.0
    for ch in r.pages["chapters"]:
        sents = [ch["heading"]] + [s for p in r.pages["pages"] if p["chapter"] == ch["id"] for s in p["sentences"]]
        env = media.envelope(r.package / ch["audio"])
        peak = max(env)
        level = lambda t: max(env[int(t * 100) - 1:int(t * 100) + 2]) / peak  # noqa: E731
        assert sents[-1]["end"] <= ch["duration"] + 0.001
        for s in sents:
            assert level((s["start"] + s["end"]) / 2) > 0.5                     # cümle ortasında ton
            onset = media.measure_onset(env, s["start"])
            assert onset == pytest.approx(s["start"], abs=0.04), (ch["id"], s["id"])
        for a, z in zip(sents, sents[1:]):
            assert level((a["end"] + z["start"]) / 2) < 0.02                    # araya sessizlik
            assert z["start"] - a["end"] >= 0.7 - 0.002
    # idempotent: ikinci dışa aktarma aynı zamanları ve aynı sesi üretir
    sha = {f["path"]: f["sha256"] for f in r.manifest["files"]}
    r2 = export(book_dir)
    assert r2.pages == r.pages
    assert {f["path"]: f["sha256"] for f in r2.manifest["files"]} == sha
