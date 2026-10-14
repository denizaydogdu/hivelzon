"""H-073: ortak cümle bölücü (kısaltma, baş harf, sayı) ve Unicode özel adlar (Lucía, Şebnem, Ayşe)."""

from __future__ import annotations

import json
import shutil
from pathlib import Path
from types import SimpleNamespace

import pytest

from hvpipeline import cefr
from hvpipeline.book import Book, parse_text
from hvpipeline.booklint import load_translation
from hvpipeline.grammarlint import _check_language
from hvpipeline.sentsplit import name_keys, split_sentences

FX = Path(__file__).parent / "fixtures" / "books" / "A1-K99-the-test-box"
NAMES = name_keys(["Serra", "Lucía"])


# --- cümle bölücü ---------------------------------------------------------------------------------

@pytest.mark.parametrize("text, expected", [
    ("Mr. Brown is here. He is tall.", ["Mr. Brown is here.", "He is tall."]),
    ("Mrs. Hale and Dr. Okafor met on St. Mark's Road. It rained.",
     ["Mrs. Hale and Dr. Okafor met on St. Mark's Road.", "It rained."]),
    ("Bring something warm, e.g. a coat. Then go.", ["Bring something warm, e.g. a coat.", "Then go."]),
    ("He meant the other one, i.e. The Grey House. Nobody laughed.",
     ["He meant the other one, i.e. The Grey House.", "Nobody laughed."]),
    ("They lived at No. 3 Rope Street. It was small.", ["They lived at No. 3 Rope Street.", "It was small."]),
    ("I said no. Then I left.", ["I said no.", "Then I left."]),
    ("It cost 3.5 million. Nobody paid.", ["It cost 3.5 million.", "Nobody paid."]),
    ("The price rose by 2.75 per cent in 1894. That was a lot.",
     ["The price rose by 2.75 per cent in 1894.", "That was a lot."]),
    ("We met at 7 a.m. Then we ate.", ["We met at 7 a.m. Then we ate."]),   # a.m. bilinen kısaltma (eski davranış)
    ("See vol. 2 for details. Thanks.", ["See vol. 2 for details.", "Thanks."]),
])
def test_split_abbreviations_and_numbers(text, expected):
    assert split_sentences(text) == expected


def test_initials_need_known_name_title_or_second_initial():
    # bilinen özel ad (kitabın properNouns'u)
    assert split_sentences("It was signed A. Serra. Nobody knew her.", NAMES) == \
        ["It was signed A. Serra.", "Nobody knew her."]
    # unvan (İngiliz yazımında noktasız)
    assert split_sentences("Ms A. Vale called. She was angry.") == ["Ms A. Vale called.", "She was angry."]
    assert split_sentences("Professor K. Lind smiled.") == ["Professor K. Lind smiled."]
    # iki baş harf
    assert split_sentences("A book by J. R. Hale lay open. I read it.") == \
        ["A book by J. R. Hale lay open.", "I read it."]
    # imza: tek harf + yeni cümle bölünür (A1-001 "This is E. Meet me at the old station.")
    assert split_sentences("This is E. Meet me at the old station.") == ["This is E.", "Meet me at the old station."]
    # ad bilinmiyorsa bölünür (yanlışlıkla iki cümleyi birleştirmemek için)
    assert split_sentences("It was signed A. Serra.") == ["It was signed A.", "Serra."]


def test_existing_quote_rules_unchanged():
    assert split_sentences('"Stop!" says Lina. "Why?" No answer.') == ['"Stop!" says Lina.', '"Why?"', "No answer."]
    assert split_sentences('"Stop!" Lina says.') == ['"Stop!"', "Lina says."]
    assert split_sentences('He said, "Mr. Kim is late." Then he sat.') == ['He said, "Mr. Kim is late."', "Then he sat."]


def test_book_parser_uses_proper_nouns_for_initials(tmp_path):
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    bj = json.loads((d / "book.json").read_text(encoding="utf-8"))
    bj["properNouns"] = list(bj.get("properNouns", [])) + ["Serra"]
    (d / "book.json").write_text(json.dumps(bj, ensure_ascii=False), encoding="utf-8")
    t = (d / "text.en.md").read_text(encoding="utf-8")
    first = t.index("\n### [p01]\n") + len("\n### [p01]\n")
    (d / "text.en.md").write_text(t[:first] + "The card says A. Serra. It is old.\n\n" + t[first:], encoding="utf-8")
    book = Book.load(d)
    texts = [s.text for s in book.text.pages[0].sentences]
    assert texts[:2] == ["The card says A. Serra.", "It is old."]
    # parse_text yalnız (ad yok): baş harf bilinmiyor, bölünür
    assert [s.text for s in parse_text((d / "text.en.md").read_text()).pages[0].sentences][:2] == \
        ["The card says A.", "Serra."]


def test_cefr_sentences_keep_abbreviations_and_initials_together():
    assert cefr.sentences("Mr. Brown met Dr. Okafor. They talked.") == [["Mr", "Brown", "met", "Dr", "Okafor"],
                                                                         ["They", "talked"]]
    assert cefr.sentences("Room No. 3 is free. Take it.") == [["Room", "No", "is", "free"], ["Take", "it"]]
    # eski davranış korunur: alıntıdan sonraki konuşma eki ayrı sayılır
    assert cefr.sentences('"Stop!" says Lina.') == [["Stop"], ["says", "Lina"]]


# --- Unicode özel adlar --------------------------------------------------------------------------

def test_name_keys_unicode():
    keys = name_keys(["Lucía", "Tomás", "Zoë", "Ilse", "Şebnem", "Çağrı", "Ömer", "İlse Kaya", "O'Neill", "Ayşe"])
    for k in ("lucía", "tomás", "zoë", "ilse", "şebnem", "çağrı", "ömer", "kaya", "o'neill", "ayşe"):
        assert k in keys, k
    # eski hata: "Lucía" → "luc" + "a" (a artikeli özel ad sayılıyordu)
    assert "a" not in keys and "luc" not in keys and "s" not in keys


def test_cefr_tokens_keep_accented_letters():
    toks = cefr.tokens("Lucía, Zoë and Şebnem's friend Ömer met Çağrı in the 1890s.")
    assert "lucía" in toks and "zoë" in toks and "şebnem" in toks and "ömer" in toks and "çağrı" in toks
    assert "luc" not in toks and "s" not in toks
    assert [len(s) for s in cefr.sentences("Lucía met Tomás. Zoë waved.")] == [3, 2]


def test_coverage_ignores_unicode_proper_nouns():
    cov = cefr.coverage(["Lucía and Tomás see Şebnem and Ömer."], "A1",
                        proper=name_keys(["Lucía", "Tomás", "Şebnem", "Ömer"]), max_words=20)
    assert cov.off_list == {}
    assert cov.tokens == 3   # and, see, and


def test_book_translation_treats_accented_names_as_proper(tmp_path):
    d = tmp_path / FX.name
    shutil.copytree(FX, d)
    bj = json.loads((d / "book.json").read_text(encoding="utf-8"))
    bj["properNouns"] = ["Lucía", "Tomás", "Zoë", "Şebnem", "Çağrı", "Ömer", "İlse"]
    (d / "book.json").write_text(json.dumps(bj, ensure_ascii=False), encoding="utf-8")
    tr = load_translation(Book.load(d))
    for k in ("lucía", "tomás", "zoë", "şebnem", "çağrı", "ömer", "i̇lse"):
        assert not tr.needs_gloss(k), k
    assert tr.needs_gloss("a") and tr.needs_gloss("s")


def test_grammar_lesson_proper_nouns_unicode():
    """A1 dalgasında G-A1-05'te "Ayşe" adı "ş" yüzünden liste dışı sayıldığı için değiştirilmişti."""
    lesson = SimpleNamespace(level="A1", meta={"properNouns": ["Ayşe", "Zoë"], "glossary": []},
                             english_texts=lambda: ["Her name is Ayşe.", "Zoë is my friend."])
    issues, rep = _check_language(lesson)
    assert not [i for i in issues if i.level == "error"], [str(i) for i in issues]
    assert rep["offList"] == {} if "offList" in rep else True
