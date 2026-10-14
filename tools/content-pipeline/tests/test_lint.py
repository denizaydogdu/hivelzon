import json
from pathlib import Path

import pytest

import content_lint
from hvpipeline.cefr import coverage, tokens
from hvpipeline.lint import check_chain, check_links, lint_episode
from hvpipeline.story import english_lines

FX = Path(__file__).parent / "fixtures"
REPO = Path(__file__).resolve().parents[3]


def test_story_parser_skips_header_and_turkish():
    text = (FX / "ep-good" / "story.en.md").read_text(encoding="utf-8")
    lines = english_lines(text)
    kinds = [(ln.kind, ln.speaker) for ln in lines]
    assert ("speech", "MAYA") in kinds and ("speech", "ALEX") in kinds
    assert all("(TR)" not in (s or "") for _, s in kinds)
    assert all("far too long" not in ln.text for ln in lines)  # `>` başlık satırı
    assert any(ln.kind == "option" and ln.text == "Meet nice." for ln in lines)
    assert any(ln.kind == "sign" for ln in lines)
    assert any(ln.text.startswith("Sorry?") for ln in lines)  # [TEPKİ] satırı


def test_tokens_expand_contractions_and_drop_fragments():
    assert tokens("I'm Maya's friend. It's seven o'clock. Fri… can't") == [
        "i", "am", "maya", "friend", "it", "is", "seven", "oclock", "can", "not"]


def test_coverage_counts_glossary_and_excludes_proper_nouns():
    cov = coverage(["Maya is at the harbour."], "A1", gloss=["harbour"])
    assert cov.tokens == 4  # maya hariç
    assert cov.in_list == 3 and cov.glossed == 1
    assert cov.pct == 75.0 and cov.pct_with_gloss == 100.0


def test_lemma_irregular_past_and_comparatives():
    """A2 past simple ve karşılaştırma biçimleri başsözcüğe iner (H-069)."""
    cov = coverage(["Max sang. He spoke and held it. Finn was faster, happier and redder. It was the biggest."], "A2",
                   proper={"max", "finn"})
    assert cov.in_list == cov.tokens, cov.off_list


def test_glossary_note_does_not_push_listed_word_off_list():
    """Sözlükteki öğretim notu (going to, sang) listedeki sözcüğü 'sözlükle' sayılana düşürmez."""
    cov = coverage(["We're going to cook. Max sang."], "A2", gloss=["going to", "sang"], proper={"max"})
    assert cov.glossed == 0 and cov.pct == 100.0


def test_sentence_length_rule_a1():
    cov = coverage(["One two three four five six seven eight nine."], "A1")
    assert cov.long_sentences and cov.max_sentence_words == 9
    assert not coverage(["One two three four five six seven eight."], "A1").long_sentences


def test_good_episode_passes():
    rep = lint_episode(FX / "ep-good")
    assert rep.errors == [], [str(i) for i in rep.errors]
    assert rep.coverage["pct"] >= 95
    assert rep.graph["source"].startswith("kurgu") and rep.graph["decisions"] == 1


def test_broken_episode_fails_with_expected_errors():
    rep = lint_episode(FX / "ep-broken")
    codes = {i.code for i in rep.errors}
    assert {"links", "flags", "coverage", "sentence-length", "schema", "unreachable",
            "no-correct", "wrong-no-return", "missing-file"} <= codes, codes


def test_links_previously_null_only_for_first_episode():
    base = {"previously": None, "payoff": "x", "openQuestion": "Q1", "answers": [],
            "cluesUnlocked": [], "callbackPhrases": []}
    assert not [i for i in check_links({**base, "prev": None}) if i.level == "error"]
    assert [i for i in check_links({**base, "prev": "A1-000"}) if i.level == "error"]


def test_chain_question_must_close_within_three_episodes():
    eps = [{"contentId": f"A1-00{n}", "season": 1, "episode": n, "openQuestion": f"Q{n}",
            "answers": [f"Q{n - 1}"] if n > 1 else []} for n in range(1, 6)]
    assert check_chain(eps) == []
    eps[1]["answers"] = []  # Q1 hiç kapanmıyor
    msgs = [str(i) for i in check_chain(eps)]
    assert any("Q1 en geç 3" in m for m in msgs)


def test_cli_exit_codes(capsys):
    assert content_lint.main([str(FX / "ep-good")]) == 0
    assert content_lint.main([str(FX / "ep-broken")]) == 1
    out = capsys.readouterr().out
    assert "HATA" in out


@pytest.mark.skipif(not (REPO / "icerik" / "A1-001-a-strange-message" / "kurgu.json").exists(),
                    reason="depo içeriği yok")
def test_real_episodes_pass_lint_from_kurgu():
    dirs = sorted((REPO / "icerik").glob("A1-00[1-4]-*"))
    assert len(dirs) == 4
    for d in dirs:
        rep = lint_episode(d, graph_source="kurgu")
        assert rep.errors == [], (d.name, [str(i) for i in rep.errors])
        assert rep.graph and rep.graph["decisions"] <= 4


def test_write_reports_creates_per_episode_summary(tmp_path):
    import shutil
    shutil.copytree(FX, tmp_path / "fx")  # bölümler kardeş hizalama dosyalarına bakar
    good = tmp_path / "fx" / "ep-good"
    broken = tmp_path / "fx" / "ep-broken"
    assert content_lint.main([str(good), str(broken), "--write-reports", "--no-chain"]) == 1
    ok = json.loads((good / "_build" / "lint.json").read_text(encoding="utf-8"))
    bad = json.loads((broken / "_build" / "lint.json").read_text(encoding="utf-8"))
    assert ok["tool"] == "content-lint" and ok["errors"] == [] and ok["generatedAt"].endswith("Z")
    assert ok["contentId"] and isinstance(ok["warnings"], list)
    assert len(bad["errors"]) > 0
    assert not list(good.glob("_build/*.tmp"))
