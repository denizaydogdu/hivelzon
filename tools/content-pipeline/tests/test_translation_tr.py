"""H-109 Faz 3: çevirilerin Türkçe sesi — dilbilgisi örnek/"Söyle" Türkçesi (`tts_lesson.py --part translation`),
bölüm çevirileri (`tts_episode_tr.py --part translation`) ve reel altyazı Türkçesi (`tts_reel_tr.py --part
subtitles`). Ağ yok: sahte istemci ve sahte medya; gerçek depo yalnız okunur."""

from __future__ import annotations

import json
import shutil
from pathlib import Path

import pytest

import tts_episode_tr
import tts_reel_tr
from hvpipeline import episodetl, lessonaudio as la, reeltr, tts_tr as tr
from hvpipeline.grammarexport import export_lesson
from hvpipeline.grammarlint import lint_lesson
from hvpipeline.graph import schema_errors
from hvpipeline.lesson import Lesson, english_in_translation
from hvpipeline.reels import lint_reel
from test_grammar import FX, ROOTS, FakeMedia, FakeTr, add_fake_mp3s, run_tts
from test_tts_tr import FakeClient, fake_finalize

REPO = Path(__file__).resolve().parents[3]
EP = REPO / "icerik" / "A1-001-a-strange-message"
TL = {"c01-ex1-tl": "Ece kutuyu açar.", "c03-ex1-tl": "O futbol oynar.", "c03-ex2-tl": "O okula gider.",
      "c03-ex3-tl": "Kedi burada uyur."}


@pytest.fixture
def lesson_dir(tmp_path) -> Path:
    d = tmp_path / "dilbilgisi" / FX.name
    shutil.copytree(FX, d)
    return d


def _json(p: Path, fn) -> None:
    doc = json.loads(p.read_text(encoding="utf-8"))
    fn(doc)
    p.write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


# --- İngilizce kelime/ad denetimi ----------------------------------------------------------------

def test_english_in_translation_flags_names_and_quoted_words_not_turkish_words():
    assert english_in_translation("Ben Alex.") == ["Alex"]
    assert english_in_translation("Cumartesileri Lumen Point'teyim.") == ["Point'teyim", "Lumen"]
    assert english_in_translation("He mi? Bir erkek mi?") == ["He"]
    # İngilizce listede de olan Türkçe kelimeler ve Türkçe ek gösterimleri yanlış alarm değil
    for t in ("Bu bir not.", "Bir de pasta, lütfen.", "Pardon, telefonum.", "…-in yakınında.", "Bay Kaya geldi.",
              "Ben Maya.", "Onun adı Elif."):
        assert english_in_translation(t) == [], t
    prons = [{"term": "Lumen Point", "say_as": "Lumın Poynt"}, {"term": "Alex", "say_as": "Aleks"}]
    assert english_in_translation("Cumartesileri Lumen Point'teyim.", prons) == []
    assert english_in_translation("Ben Alex. Lumen tek başına.", prons) == ["Lumen"]


# --- dilbilgisi ----------------------------------------------------------------------------------

def test_lesson_translation_items_dedupe_skip_wrong_notes_and_include_say(lesson_dir):
    lesson = Lesson.load(lesson_dir)
    # "O okula gider." örneklerde, kuralda ve "Söyle"de geçer: bir kez, ilk yerin kimliğiyle; "Ek eksik." çeviri değil
    assert {f"{i}-tl": t for i, t in lesson.translation_items()} == TL
    segs = lesson.translation_segments()
    assert [s.id for s in segs] == list(TL) and all(s.pronunciations is None for s in segs)
    # varsayılan plan çeviri içermez; yalnız `translation` istenince
    assert not [j for j in la.plan_lesson(lesson).tr.jobs if j.seg.id.endswith("-tl")]
    plan = la.plan_lesson(lesson, ("tr",), parts=("translation",))
    assert [j.seg.id for j in plan.tr.jobs] == list(TL) and plan.en.jobs == []
    # anlatım ve açıklama sözlükleri çeviri parçasına karışmaz; kendi sözlüğü kelime sınırında eşleşir
    _json(lesson_dir / "lesson.json", lambda d: d.update(
        pronunciations=[{"term": "O", "say_as": "Ou"}], feedbackPronunciations=[{"term": "O", "say_as": "Ou"}],
        translationPronunciations=[{"term": "Ece", "say_as": "Ece"}, {"term": "kut", "say_as": "kat"}]))
    by = {s.id: s for s in Lesson.load(lesson_dir).translation_segments()}
    assert by["c01-ex1-tl"].pronunciations == [{"term": "Ece", "say_as": "Ece"}]
    assert by["c03-ex2-tl"].pronunciations is None
    _json(lesson_dir / "lesson.json", lambda d: d.update(translationPronunciations=[{"term": "Ece"}]))
    with pytest.raises(tr.TrTtsError):
        Lesson.load(lesson_dir).translation_segments()
    assert "translation-audio" in [i.code for i in lint_lesson(lesson_dir, **ROOTS).errors]


def test_tts_lesson_translation_dry_run_execute_lint_and_idempotent(lesson_dir, tmp_path, capsys, monkeypatch):
    monkeypatch.delenv("HIVELZON_TR_TTS_MONTHLY_CHAR_CAP", raising=False)
    ft = FakeTr()
    n = sum(len(t) for t in TL.values())
    assert run_tts(lesson_dir, tmp_path, "--part", "translation", "--offline", tr_client=ft) == 0
    out = capsys.readouterr().out
    assert ft.speech_calls == [] and f"Bölümler: translation; 1 ders, Türkçe 4 parça / {n} karakter" in out
    w = [i for i in lint_lesson(lesson_dir, **ROOTS).warnings if i.code == "translation-audio"]
    assert len(w) == 1 and "4/4" in w[0].message
    assert run_tts(lesson_dir, tmp_path, "--part", "translation", "--execute", "--tr-cap", "5000",
                   tr_client=ft) == 0
    assert [x["input"] for x in ft.speech_calls] == list(TL.values())
    rep = lint_lesson(lesson_dir, **ROOTS)
    assert not [i for i in rep.issues if i.code.startswith("translation")], [str(i) for i in rep.issues]
    assert rep.stats["audio"]["translation"] == {"segments": 4, "chars": n, "aligned": 4, "audio": 4, "stale": 0}
    man = json.loads((lesson_dir / "audio" / "lesson-audio.json").read_text(encoding="utf-8"))
    assert schema_errors(man, "lesson-audio.schema.json") == []
    assert [s["id"] for c in man["cards"] for s in c["segments"] if s["role"] == "translation" and s["present"]] \
        == list(TL)
    ft2 = FakeTr()
    assert run_tts(lesson_dir, tmp_path, "--part", "translation", "--execute", "--tr-cap", "5000",
                   tr_client=ft2) == 0
    assert ft2.speech_calls == []
    # sözlük değişti: ses eskir (yeniden ücretlenir), lint uyarır
    _json(lesson_dir / "lesson.json", lambda d: d.update(translationPronunciations=[{"term": "Kedi",
                                                                                      "say_as": "Kedi"}]))
    w = [str(i) for i in lint_lesson(lesson_dir, **ROOTS).warnings if i.code == "translation-audio"]
    assert len(w) == 1 and "c03-ex3-tl" in w[0] and "eski" in w[0]
    # sahipsiz ses dosyası
    (lesson_dir / "audio" / "tr" / "c09-ex9-tl.align.json").write_text("{}", encoding="utf-8")
    w = [str(i) for i in lint_lesson(lesson_dir, **ROOTS).warnings if i.code == "translation-audio"]
    assert any("c09-ex9-tl" in m and "çevirisi yok" in m for m in w)


def test_tts_lesson_translation_refuses_unresolved_english(lesson_dir, tmp_path, capsys):
    s = (lesson_dir / "lesson.md").read_text(encoding="utf-8")
    (lesson_dir / "lesson.md").write_text(s.replace("| Kedi burada uyur.", "| Alex'in kedisi burada uyur."),
                                          encoding="utf-8")
    w = [str(i) for i in lint_lesson(lesson_dir, **ROOTS).warnings if i.code == "translation-english"]
    assert len(w) == 1 and "Alex'in" in w[0]
    ft = FakeTr()
    assert run_tts(lesson_dir, tmp_path, "--part", "translation", "--execute", "--tr-cap", "5000",
                   tr_client=ft) == 1
    assert ft.speech_calls == [] and "translationPronunciations" in capsys.readouterr().err
    _json(lesson_dir / "lesson.json", lambda d: d.update(translationPronunciations=[{"term": "Alex",
                                                                                      "say_as": "Aleks"}]))
    assert not [i for i in lint_lesson(lesson_dir, **ROOTS).warnings if i.code == "translation-english"]
    assert run_tts(lesson_dir, tmp_path, "--part", "translation", "--execute", "--tr-cap", "5000",
                   tr_client=ft) == 0
    sent = {x["input"]: x for x in ft.speech_calls}
    assert sent["Alex'in kedisi burada uyur."]["pronunciations"] == [{"term": "Alex", "say_as": "Aleks"}]


def test_grammar_export_packages_translation_audio_once_and_skips_stale(lesson_dir, tmp_path):
    add_fake_mp3s(lesson_dir)
    assert run_tts(lesson_dir, tmp_path, "--part", "translation", "--execute", "--tr-cap", "5000",
                   tr_client=FakeTr()) == 0
    r = export_lesson(lesson_dir, media=FakeMedia(), **ROOTS)
    assert r.errors == [] and r.manifest["translationMissing"] == []
    cards = json.loads((lesson_dir / "_build" / "package" / "cards.json").read_text(encoding="utf-8"))
    assert schema_errors(cards, "cards.schema.json") == []
    ex = {e["id"]: e.get("trAudio") for c in cards["cards"] for e in c["examples"]}
    # aynı Türkçe ("O okula gider.") her yerde aynı ses
    assert ex["c01-ex1"] == "audio/c01-ex1-tl.m4a" and ex["c03-ex2"] == "audio/c03-ex2-tl.m4a"
    assert ex["c04-ex1"] == "audio/c03-ex2-tl.m4a" and ex["c07-ex1"] == "audio/c03-ex2-tl.m4a"
    say = next(p for c in cards["cards"] for p in c["practice"] if p["kind"] == "say")
    assert say["trAudio"] == "audio/c03-ex2-tl.m4a" and say["trDuration"] == 9.0
    wrong = [w for c in cards["cards"] for w in c["wrong"]]
    assert wrong and all("trAudio" not in w for w in wrong)
    paths = [f["path"] for f in r.manifest["files"]]
    assert paths.count("audio/c03-ex2-tl.m4a") == 1 and set(TL) <= set(r.manifest["textSha256"])
    # metin sesten sonra değişti: o ses pakete girmez, paket yine kurulur
    s = (lesson_dir / "lesson.md").read_text(encoding="utf-8")
    (lesson_dir / "lesson.md").write_text(s.replace("| Kedi burada uyur.", "| Kedi hep burada uyur."),
                                          encoding="utf-8")
    r = export_lesson(lesson_dir, media=FakeMedia(), **ROOTS)
    assert r.errors == [] and [x["segment"] for x in r.manifest["translationMissing"]] == ["c03-ex3-tl"]
    ex = {e["id"]: e for c in r.cards["cards"] for e in c["examples"]}
    assert "trAudio" not in ex["c03-ex3"] and ex["c03-ex1"]["trAudio"] == "audio/c03-ex1-tl.m4a"


# --- bölüm çevirileri ----------------------------------------------------------------------------

def _episode_copy(tmp_path: Path) -> Path:
    """Gerçek A1-001'in kuru derlemeye yeten kopyası (görsel/video yok)."""
    d = tmp_path / "icerik" / EP.name
    (d / "audio").mkdir(parents=True)
    for f in ("content.json", "kurgu.json", "ceviri.tr.json", "story.en.md"):
        if (EP / f).exists():
            shutil.copy(EP / f, d / f)
    for f in (EP / "audio").glob("*.align.json"):
        shutil.copy(f, d / "audio" / f.name)
    return d


def test_episode_items_are_the_shown_sentences_with_stable_ids(tmp_path):
    used = episodetl.used_texts(EP)
    items = episodetl.translation_items(EP, used)
    texts = [t for _, t in items]
    assert len(texts) == len(set(texts)) and all(t in used for t in texts)
    assert "Beni duyabiliyor musun?" in texts
    assert "Garip Bir Mesaj" not in texts           # başlık satırı pakette anlam metni değil
    assert all(i.startswith(("l-", "p-")) and len(i) == 12 for i, _ in items)
    # kimlik İngilizceden: Türkçe düzeltilince kaymaz
    d = _episode_copy(tmp_path)
    before = dict(episodetl.translation_items(d))
    _json(d / "ceviri.tr.json", lambda c: next(ln for ln in c["lines"] if ln["tr"] == "Beni duyabiliyor musun?")
          .update(tr="Sesimi duyuyor musun?"))
    after = dict(episodetl.translation_items(d))
    sid = next(i for i, t in before.items() if t == "Beni duyabiliyor musun?")
    assert after[sid] == "Sesimi duyuyor musun?" and set(after) == set(before)


def test_collect_tr_skips_word_level_and_glossary():
    doc = {"episode": {"targetPhraseGloss": [{"text": "Hi.", "tr": "Merhaba.", "chunks": [{"tr": "kalıp"}]}],
                       "glossary": [{"w": "pier", "tr": "iskele"}],
                       "translationAudio": {"x": "audio/ceviri/l.m4a"}},
           "nodes": [{"items": [{"stemChunks": [{"tr": "görev kalıbı"}], "tr": "Görev."}]}]}
    assert episodetl.collect_tr(doc, set()) == {"Merhaba.", "Görev."}


def test_episode_attach_package_check_and_stale(tmp_path):
    d = _episode_copy(tmp_path)
    used = episodetl.used_texts(d)
    plan = episodetl.plan_episode(d, used=used)
    assert plan.jobs and all(j.action == "tts" for j in plan.jobs)
    # iki parçanın sesini "üret" (sahte istemci, gerçek tts_tr.execute)
    first = plan.jobs[:2]
    plan.jobs = first
    tr.execute(plan, FakeClient(), 100000, tmp_path / "ledger.json", d / "PROMPTS.md", finalize=fake_finalize,
               sleep=lambda s: None)
    states = {s.id: s.state for s in episodetl.seg_audio(d, used=used)}
    assert [states[j.seg.id] for j in first] == ["ok", "ok"]
    # paket: bellekteki scenes + altyazıya bağlanır, ses bir kez kopyalanır
    doc, b = __import__("hvpipeline.build", fromlist=["build_dry"]).build_dry(d)
    pkg = tmp_path / "pkg"
    fm = FakeMedia()
    r = episodetl.attach(d, pkg, doc, b.subs, media=fm)
    assert sorted(r.packaged) == sorted(j.seg.id for j in first) and r.missing == []
    ta = doc["episode"]["translationAudio"]
    assert ta == {j.seg.text: f"audio/ceviri/{j.seg.id}.m4a" for j in first}
    assert schema_errors(doc, "scenes.schema.json") == []
    linked = [c for s in b.subs.values() for c in s["cues"] if "trAudio" in c]
    assert all(ta[c["tr"]] == c["trAudio"] for c in linked)
    for rel, s in b.subs.items():
        assert schema_errors(s, "subs.schema.json") == [], rel
    assert episodetl.check_package(doc, b.subs, pkg) == []
    # bozuk bağ: paket denetimi uyarır
    if linked:
        linked[0]["trAudio"] = "audio/ceviri/baska.m4a"
        assert episodetl.check_package(doc, b.subs, pkg)
    # Türkçe sesten sonra değişti → eskimiş, pakete girmez; yeniden bağlamada eski dosya kalmaz
    _json(d / "ceviri.tr.json", lambda c: next(ln for ln in c["lines"] if ln["tr"] == first[0].seg.text)
          .update(tr=first[0].seg.text + " Evet."))
    doc, b = __import__("hvpipeline.build", fromlist=["build_dry"]).build_dry(d)
    r = episodetl.attach(d, pkg, doc, b.subs, media=FakeMedia())
    assert r.packaged == [first[1].seg.id] and [x["reason"] for x in r.missing] == ["stale"]
    assert not (pkg / "audio" / "ceviri" / f"{first[0].seg.id}.m4a").exists()


def test_tts_episode_translation_cli(tmp_path, capsys, monkeypatch):
    monkeypatch.delenv("HIVELZON_TR_TTS_MONTHLY_CHAR_CAP", raising=False)
    d = _episode_copy(tmp_path)
    c = FakeClient()

    monkeypatch.setenv(tr.ENV_LEDGER, str(tmp_path / "env-ledger.json"))   # gerçek defter asla

    def run(*extra):
        return tts_episode_tr.main([str(d), "--part", "translation", "--offline", "--tr-ledger",
                                    str(tmp_path / "ledger.json"), *extra], tr_client=c,
                                   finalize=fake_finalize, sleep=lambda s: None)
    assert run() == 0
    out = capsys.readouterr().out
    n = sum(len(t) for _, t in episodetl.translation_items(d))
    assert c.speech_calls == [] and f"çeviri, {n} karakter (yapılacak + güncel)" in out
    assert not (d / "audio" / "ceviri").exists()
    assert run("--execute") == 1 and c.speech_calls == []                    # tavan yok
    # sözlükte olmayan ad → --execute reddeder; --allow-english ile geçer
    _json(d / "ceviri.tr.json", lambda x: x["lines"].append({"en": "Can you hear me?", "tr": "x"}))  # tekrar: yok sayılır
    _json(d / "ceviri.tr.json", lambda x: next(ln for ln in x["lines"] if ln["tr"] == "Beni duyabiliyor musun?")
          .update(tr="Alex, beni duyabiliyor musun?"))
    assert run("--execute", "--tr-cap", "100000") == 1 and c.speech_calls == []
    assert "pronunciations" in capsys.readouterr().err
    _json(d / "ceviri.tr.json", lambda x: x.update(pronunciations=[{"term": "Alex", "say_as": "Aleks"}]))
    assert run("--execute", "--tr-cap", "100000") == 0
    assert len(c.speech_calls) == len(episodetl.translation_items(d))
    assert json.loads((tmp_path / "ledger.json").read_text(encoding="utf-8"))[tr.month_key()]["characters"] == \
        sum(len(t) for _, t in episodetl.translation_items(d))
    assert not (tmp_path / "env-ledger.json").exists()
    sent = {x["input"]: x for x in c.speech_calls}
    assert sent["Alex, beni duyabiliyor musun?"]["pronunciations"] == [{"term": "Alex", "say_as": "Aleks"}]
    assert "| l-" in (d / "PROMPTS.md").read_text(encoding="utf-8")
    c.speech_calls.clear()
    assert run("--execute", "--tr-cap", "100000") == 0 and c.speech_calls == []   # güncel: çağrı yok
    # kullanım hataları: konuşma bayrakları translation ile karışmaz; --package yalnız translation ile
    with pytest.raises(SystemExit):
        tts_episode_tr.main([str(d), "--part", "translation", "--hi"])
    with pytest.raises(SystemExit):
        tts_episode_tr.main([str(d), "--package"])
    assert tts_episode_tr.main([str(d), "--part", "translation", "--package"]) == 0    # paket yok: atlanır


def test_repo_episodes_have_no_translation_audio_errors():
    for d in sorted((REPO / "icerik").glob("A1-0*")):
        found, _ = episodetl.check_episode(d)
        assert not [m for lv, _, m in found if lv == "error"], (d.name, found)
        assert not [m for _, code, m in found if code == "translation-english"], (d.name, found)


# --- reel altyazı Türkçesi -----------------------------------------------------------------------

@pytest.fixture
def reel_dir(tmp_path) -> Path:
    d = tmp_path / "reeller" / "A1-R-BOK-01"
    d.mkdir(parents=True)
    shutil.copy(REPO / "reeller" / "A1-R-BOK-01" / "reel.json", d / "reel.json")
    return d


def run_reel(d: Path, tmp_path: Path, client, *extra, media=None) -> int:
    return tts_reel_tr.main([str(d), "--ledger", str(tmp_path / "ledger.json"), *extra], client=client,
                            finalize=fake_finalize, sleep=lambda s: None, media=media)


def test_reel_subtitles_part_is_opt_in_and_dedupes(reel_dir):
    doc = reeltr.source_doc(reel_dir)
    subs = reeltr.subtitle_turkish(doc)
    assert [i for i, _ in subs] == ["sub-s02-01", "sub-s02-02", "sub-s02-03"]
    assert [s.id for s in reeltr.segments(doc)] == ["practice-prompt", "practice-explain"]
    assert [s.id for s in reeltr.segments(doc, parts=("subtitles",))] == [i for i, _ in subs]
    doc["cues"][2]["tr"] = doc["cues"][0]["tr"]
    assert [i for i, _ in reeltr.subtitle_turkish(doc)] == ["sub-s02-01", "sub-s02-02"]
    with pytest.raises(reeltr.ReelTrError):
        reeltr.segments(doc, parts=("bilinmeyen",))


def test_reel_subtitles_execute_package_and_english_refusal(reel_dir, tmp_path, capsys):
    c = FakeClient()
    assert run_reel(reel_dir, tmp_path, c, "--part", "subtitles", "--offline") == 0
    assert "1 reel, 3 parça" in capsys.readouterr().out and c.speech_calls == []
    # sözlükte olmayan ad → reddeder (alıştırma sözlüğü buraya karışmaz)
    _json(reel_dir / "reel.json", lambda d: (d["cues"][0].update(tr="Affedersiniz Alex."),
                                            d.update(narrationTr={"pronunciations": [{"term": "Alex",
                                                                                      "say_as": "Aleks"}]})))
    assert run_reel(reel_dir, tmp_path, c, "--part", "subtitles", "--execute", "--monthly-char-cap", "100000") == 1
    assert c.speech_calls == [] and "translationPronunciations" in capsys.readouterr().err
    w = [str(i) for i in lint_reel(reel_dir).warnings if "İngilizce" in i.message]
    assert len(w) == 1 and "Alex" in w[0]
    _json(reel_dir / "reel.json", lambda d: d["narrationTr"].update(
        translationPronunciations=[{"term": "Alex", "say_as": "Aleks"}]))
    assert run_reel(reel_dir, tmp_path, c, "--part", "subtitles", "--execute", "--monthly-char-cap", "100000") == 0
    assert [x["input"] for x in c.speech_calls][0] == "Affedersiniz Alex."
    assert c.speech_calls[0]["pronunciations"] == [{"term": "Alex", "say_as": "Aleks"}]
    rep = lint_reel(reel_dir)
    assert rep.tr_audio["subtitles"] == {"segments": 3, "chars": rep.tr_audio["subtitles"]["chars"], "aligned": 3,
                                         "audio": 3, "stale": 0}
    # paket: satırlara `trAudio`; alıştırma sesi yok (üretilmedi) → audioTr yazılmaz
    pkg = reel_dir / "_build" / "package"
    pkg.mkdir(parents=True)
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    assert run_reel(reel_dir, tmp_path, None, "--package", media=FakeMedia()) == 0
    doc = json.loads((pkg / "reel.json").read_text(encoding="utf-8"))
    assert [cue.get("trAudio") for cue in doc["cues"]] == [f"audio/tr/sub-{i}.m4a" for i in
                                                           ("s02-01", "s02-02", "s02-03")]
    assert "audioTr" not in doc["practice"]
    assert reeltr.check_package(doc, pkg) == []
    doc["cues"][0]["trAudio"] = "../disari.m4a"
    assert [lv for lv, _ in reeltr.check_package(doc, pkg)] == ["error"]
    # satır değişti: eski ses bağlanmaz, eski dosya kalmaz
    _json(reel_dir / "reel.json", lambda d: d["cues"][1].update(tr="Bu kitap iyi mi?"))
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    r = reeltr.package_tr(reel_dir, FakeMedia())
    assert "sub-s02-02" not in r.packaged and {"segment": "sub-s02-02", "reason": "stale",
                                               "path": "audio/tr/sub-s02-02.mp3"} in r.missing
    doc = json.loads((pkg / "reel.json").read_text(encoding="utf-8"))
    assert "trAudio" not in doc["cues"][1] and not (pkg / "audio" / "tr" / "sub-s02-02.m4a").exists()


def test_reel_subtitle_data_error_keeps_practice_audio(reel_dir, tmp_path):
    """QA: altyazı bölümündeki veri hatası (bozuk çeviri sözlüğü) alıştırma sesini paketten düşürmez."""
    assert run_reel(reel_dir, tmp_path, FakeClient(), "--execute", "--monthly-char-cap", "100000") == 0
    _json(reel_dir / "reel.json", lambda d: d.update(narrationTr={"translationPronunciations": [{"term": "X"}]}))
    found, st = reeltr.check_reel(reel_dir)
    assert st["audio"] == 2 and any(lv == "error" and "altyazı" in m for lv, m in found)
    pkg = reel_dir / "_build" / "package"
    pkg.mkdir(parents=True)
    shutil.copy(reel_dir / "reel.json", pkg / "reel.json")
    r = reeltr.package_tr(reel_dir, FakeMedia())
    assert r.packaged == ["practice-prompt", "practice-explain"]
    assert [x["reason"] for x in r.missing] == ["error"]
    assert set(json.loads((pkg / "reel.json").read_text(encoding="utf-8"))["practice"]["audioTr"]) == \
        {"prompt", "explain"}


def test_episode_package_survives_bad_translation_audio(tmp_path):
    """QA: bozuk tek çeviri sesi paketi durdurmaz; yerinde güncelleme silinmiş sese bağ bırakmaz."""
    from hvpipeline.build import build_dry
    from hvpipeline.media import MediaError
    d = _episode_copy(tmp_path)
    plan = episodetl.plan_episode(d, used=episodetl.used_texts(d))
    plan.jobs = plan.jobs[:2]
    tr.execute(plan, FakeClient(), 100000, tmp_path / "ledger.json", d / "PROMPTS.md", finalize=fake_finalize,
               sleep=lambda s: None)
    bad = plan.jobs[0].seg.id

    class Broken(FakeMedia):
        def loudness(self, paths):
            if paths[0].stem == bad:
                raise MediaError("bozuk mp3")
            return super().loudness(paths)
    doc, b = build_dry(d)
    pkg = d / "_build" / "package"
    (pkg / "subs").mkdir(parents=True)
    for rel, sub in b.subs.items():
        (pkg / rel).write_text(json.dumps(sub, ensure_ascii=False), encoding="utf-8")
    (pkg / "scenes.json").write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
    (pkg / "manifest.json").write_text(json.dumps({"files": [], "translationMissing": ["eski"]}), encoding="utf-8")
    r = episodetl.package_built(d, Broken())
    assert r.packaged == [plan.jobs[1].seg.id] and [x["reason"] for x in r.missing] == ["media"]
    sc = json.loads((pkg / "scenes.json").read_text(encoding="utf-8"))
    assert list(sc["episode"]["translationAudio"].values()) == [f"audio/ceviri/{plan.jobs[1].seg.id}.m4a"]
    m = json.loads((pkg / "manifest.json").read_text(encoding="utf-8"))
    assert m["translationMissing"] == r.missing and any(f["path"].startswith("audio/ceviri/") for f in m["files"])
    # yarıda düşen kopyalamada: eski bağsız belgeler dosyalar silinmeden önce yazılmış olur
    class Crash(FakeMedia):
        def loudness(self, paths):
            raise KeyboardInterrupt
    with pytest.raises(KeyboardInterrupt):
        episodetl.package_built(d, Crash())
    sc = json.loads((pkg / "scenes.json").read_text(encoding="utf-8"))
    assert "translationAudio" not in sc["episode"]
