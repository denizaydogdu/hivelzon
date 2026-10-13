"""ceviri.tr.json birleştirme ve content-lint çeviri denetimi (H-046)."""
import json
import shutil
from pathlib import Path

import pytest

from hvpipeline.build import build_dry
from hvpipeline.graph import schema_errors
from hvpipeline.lint import lint_episode
from hvpipeline.translation import chunk_pattern, split_words, word_key, _find_span, GAP

FX = Path(__file__).parent / "fixtures"

LINES = [
    {"en": "Hi, Alex!", "speaker": "MAYA", "tr": "Merhaba Alex!", "chunks": [], "words": {"hi": "merhaba"}},
    {"en": "I'm Maya.", "speaker": "MAYA", "tr": "Ben Maya.", "chunks": [{"en": "I'm", "tr": "Ben …-im"}],
     "words": {"i'm": "ben …-im"}},
    {"en": "Are you new here?", "speaker": "MAYA", "tr": "Burada yeni misin?",
     "chunks": [{"en": "Are you new", "tr": "Yeni misin"}],
     "words": {"are": "-sin (olmak)", "you": "sen", "new": "yeni", "here": "burada"}},
    {"en": "Yes.  I'm your new neighbour.", "speaker": "ALEX", "tr": "Evet. Yeni komşunum.",
     "chunks": [{"en": "your new neighbour", "tr": "yeni komşun"}],
     "words": {"yes": "evet", "i'm": "ben …-im", "your": "senin", "new": "yeni", "neighbour": "komşu"},
     "source": "subs/s01"},
    {"en": "The station is between the shop and the café.", "speaker": "NOTE",
     "tr": "İstasyon dükkânla kafenin arasında.",
     "chunks": [{"en": "between … and …", "tr": "… ile … arasında"}],
     "words": {"the": "(belirli)", "station": "istasyon", "is": "-dır", "between": "arasında", "shop": "dükkân",
               "and": "ve", "café": "kafe"}},
    {"en": "Meet me at the ___.", "speaker": "TASK", "tr": "Benimle ___ buluş.", "chunks": [],
     "words": {"meet": "buluşmak", "me": "benimle", "at": "-de", "the": "(belirli)"}},
]


def make_episode(tmp_path: Path, lines=LINES, status="DRAFT", translation=True) -> Path:
    for f in ("b2_05_maya.align.json", "b2_06_alex.align.json"):
        shutil.copy(FX / f, tmp_path / f)
    ep = tmp_path / "ep"
    shutil.copytree(FX / "ep-good", ep)
    k = json.loads((ep / "kurgu.json").read_text(encoding="utf-8"))
    k["nodes"][-1]["next"] = "c2"
    k["nodes"] += [
        {"id": "c2", "type": "card", "kind": "note", "advance": "tap",
         "lines": [{"text": "The station is between the shop and the café.", "lang": "en"},
                   {"text": "Bölüm 2: Hi, Alex!", "lang": "en"},
                   {"text": "Türkçe satır", "lang": "tr"}],
         "next": "t2"},
        {"id": "t2", "type": "task", "kind": "fillBlank", "role": "comprehension", "prompt": {"tr": "Tamamla"},
         "items": [{"id": "i1", "stem": "Meet me at the ___.", "blanks": [{"id": "b1", "accept": "any"}]}],
         "next": None},
    ]
    (ep / "kurgu.json").write_text(json.dumps(k, ensure_ascii=False), encoding="utf-8")
    if translation:
        (ep / "ceviri.tr.json").write_text(json.dumps({"status": status, "lines": lines}, ensure_ascii=False),
                                           encoding="utf-8")
    return ep


def test_word_key_and_split():
    assert word_key("“Fri…”") == "fri"
    assert word_key("o'clock.") == "o'clock"
    assert word_key("2:00.") == "2:00"
    assert word_key("It’s") == "it's"
    assert word_key("·") == "" and word_key("___.") == ""
    assert split_words("Turn left / right. · Go") == ["Turn", "left", "right.", "Go"]
    assert split_words("This is ___.") == ["This", "is", "___."]


def test_chunk_patterns_with_gaps():
    keys = ["it's", "between", "pier", "2", "and", "pier", "4"]
    assert chunk_pattern("between … and …") == ["between", GAP, "and", GAP]
    assert _find_span(keys, chunk_pattern("between … and …")) == (1, 6)
    assert _find_span(["it's", "monday"], chunk_pattern("It's + gün")) == (0, 1)
    assert _find_span(["where", "is"], chunk_pattern("Where is…?")) == (0, 1)
    assert _find_span(["go", "straight"], chunk_pattern("turn left")) is None


def test_merge_fills_cues_cards_and_stems(tmp_path):
    doc, b = build_dry(make_episode(tmp_path))
    sub = b.subs["subs/s01.en.json"]
    assert schema_errors(sub, "subs.schema.json") == []
    assert schema_errors(doc) == []
    cues = {c["text"]: c for c in sub["cues"]}
    hi = cues["Hi, Alex!"]
    assert hi["tr"] == "Merhaba Alex!"
    assert [w["gloss"] for w in hi["words"]] == ["merhaba", None]  # özel ad: anlam yok
    last = cues["Yes. I'm your new neighbour."]  # boşluk normalleştirmesi
    assert last["chunks"] == [{"en": "your new neighbour", "tr": "yeni komşun", "startWord": 2, "endWord": 4}]
    assert last["words"][4]["gloss"] == "komşu"
    card = next(n for n in doc["nodes"] if n["id"] == "c2")
    note = card["lines"][0]
    assert note["tr"].startswith("İstasyon")
    assert note["chunks"][0]["startWord"] == 3 and note["chunks"][0]["endWord"] == 8
    assert card["lines"][1]["words"] == [{"w": "Hi,", "gloss": "merhaba"}, {"w": "Alex!", "gloss": None}]
    assert "tr" not in card["lines"][2]  # Türkçe satır çevrilmez
    item = next(n for n in doc["nodes"] if n["id"] == "t2")["items"][0]
    assert item["stemTr"] == "Benimle ___ buluş."
    assert [w["w"] for w in item["stemWords"]] == ["Meet", "me", "at", "the", "___."]
    # karar seçenekleri çevrilmez (kullanıcı kararı)
    k1 = next(n for n in doc["nodes"] if n["id"] == "k1")
    assert all(set(o) <= {"id", "text", "lang", "icon", "correct", "setFlag", "audio", "next"} for o in k1["options"])
    assert b.tr_misses == []


def test_without_translation_cues_keep_null_and_lint_warns(tmp_path):
    ep = make_episode(tmp_path, translation=False)
    _, b = build_dry(ep)
    cue = b.subs["subs/s01.en.json"]["cues"][0]
    assert cue["tr"] is None and "chunks" not in cue
    rep = lint_episode(ep, "kurgu")
    assert not [i for i in rep.errors if i.code == "translation"]
    assert any(i.code == "translation" and "çeviri yok" in i.message for i in rep.warnings)


def test_lint_errors_for_missing_line_and_missing_gloss(tmp_path):
    lines = [dict(ln) for ln in LINES if ln["en"] != "Are you new here?"]
    lines[0] = {**lines[0], "words": {}}  # "Hi" anlamsız
    rep = lint_episode(make_episode(tmp_path, lines), "kurgu")
    errs = [i.message for i in rep.errors if i.code == "translation"]
    assert any("çeviri satırı yok" in m and "Are you new here?" in m for m in errs)
    assert any('"Hi," kelimesinin anlamı yok' in m for m in errs)
    assert not any("\"Alex!\" kelimesinin" in m for m in errs)  # özel ad
    assert any("DRAFT" in i.message for i in rep.warnings)


def test_lint_clean_when_approved(tmp_path):
    rep = lint_episode(make_episode(tmp_path, status="APPROVED"), "kurgu")
    assert [i for i in rep.issues if i.code == "translation"] == []
    assert rep.translation["cuesTranslated"] == rep.translation["cues"] == 4
    assert rep.translation["wordsGlossed"] == rep.translation["wordsNeedingGloss"]


@pytest.mark.parametrize("ep", ["A1-001-a-strange-message", "A1-002-the-new-neighbour",
                                "A1-003-find-the-station", "A1-004-the-note"])
def test_real_episodes_have_full_translation(ep):
    repo = Path(__file__).resolve().parents[3]
    d = repo / "icerik" / ep
    if not (d / "ceviri.tr.json").exists():
        pytest.skip("çeviri yok")
    _, b = build_dry(d)
    assert [m for m in b.tr_misses if m.required] == []


def test_target_phrase_gloss_from_line_or_chunk(tmp_path):
    """🎯 paneli (H-050): hedef ifadenin anlamı birebir satırdan ya da kalıptan gelir."""
    from hvpipeline.translation import Translation
    (tmp_path / "ceviri.tr.json").write_text(json.dumps({"status": "DRAFT", "lines": LINES}), encoding="utf-8")
    tr = Translation.load(tmp_path)
    exact = tr.gloss_phrase("Are you new here?")
    assert exact["tr"] == "Burada yeni misin?" and exact["words"][3] == {"w": "here?", "gloss": "burada"}
    chunk = tr.gloss_phrase("your new neighbour")
    assert chunk["tr"] == "yeni komşun" and [w["gloss"] for w in chunk["words"]] == ["senin", "yeni", "komşu"]
    assert tr.gloss_phrase("between ... and ...")["tr"] == "… ile … arasında"
    assert tr.gloss_phrase("Listen.") is None


def test_phrases_give_meaning_to_target_phrase_and_glossary(tmp_path):
    """H-052: altyazıda geçmeyen hedef ifade (`phrases`) ve bölüm sözlüğü anlamı."""
    from hvpipeline.translation import Translation
    doc = {"status": "DRAFT", "lines": LINES,
           "phrases": [{"en": "Listen.", "tr": "Dinle.", "words": {"listen": "dinlemek"}},
                       {"en": "next to", "tr": "…-in yanında"}]}
    (tmp_path / "ceviri.tr.json").write_text(json.dumps(doc), encoding="utf-8")
    tr = Translation.load(tmp_path)
    g = tr.gloss_phrase("Listen.")
    assert g["tr"] == "Dinle." and g["words"] == [{"w": "Listen.", "gloss": "dinlemek"}]
    # Satır önce gelir: phrases altyazı eşlemesine girmez.
    assert tr.find("Listen.") is None
    assert tr.glossary_meaning("neighbour") == "komşu"
    assert tr.glossary_meaning("next to") == "…-in yanında"
    assert tr.glossary_meaning("your new neighbour") == "yeni komşun"
    assert tr.glossary_meaning("harbour") is None


def test_export_has_glossary_and_lint_requires_target_meaning(tmp_path):
    ep = make_episode(tmp_path, status="APPROVED")
    c = json.loads((ep / "content.json").read_text(encoding="utf-8"))
    c["targetPhrases"] = ["Are you new here?", "Listen."]
    c["glossary"] = ["neighbour", "harbour"]
    (ep / "content.json").write_text(json.dumps(c, ensure_ascii=False), encoding="utf-8")
    doc, _ = build_dry(ep)
    assert doc["episode"]["glossary"] == [{"w": "neighbour", "tr": "komşu"}, {"w": "harbour"}]
    assert schema_errors(doc) == []
    rep = lint_episode(ep, "kurgu")
    errs = [i for i in rep.errors if i.code == "target-meaning"]
    assert len(errs) == 1 and "Listen." in errs[0].message
    assert [i.code for i in rep.warnings if "harbour" in i.message] == ["glossary-meaning"]
    # phrases ile anlam verilince hata kalkar.
    t = json.loads((ep / "ceviri.tr.json").read_text(encoding="utf-8"))
    t["phrases"] = [{"en": "Listen.", "tr": "Dinle."}, {"en": "harbour", "tr": "liman"}]
    (ep / "ceviri.tr.json").write_text(json.dumps(t, ensure_ascii=False), encoding="utf-8")
    rep = lint_episode(ep, "kurgu")
    assert [i for i in rep.issues if i.code in ("target-meaning", "glossary-meaning")] == []
    doc, _ = build_dry(ep)
    assert {"text": "Listen.", "tr": "Dinle.", "chunks": [], "words": [{"w": "Listen.", "gloss": None}]} \
        in doc["episode"]["targetPhraseGloss"]


@pytest.mark.parametrize("ep", ["A1-001-a-strange-message", "A1-002-the-new-neighbour",
                                "A1-003-find-the-station", "A1-004-the-note"])
def test_real_episodes_target_phrases_have_meaning(ep):
    repo = Path(__file__).resolve().parents[3]
    rep = lint_episode(repo / "icerik" / ep)
    assert [i for i in rep.issues if i.code in ("target-meaning", "glossary-meaning")] == []


def test_season_package_export(tmp_path):
    """Sezon paketi (H-050): jenerik videoları kopyalanır, season.json yazılır."""
    from hvpipeline.season import SeasonSource, export_season, title_caption
    src = tmp_path / "_evren" / "jenerik"
    (src / "_build").mkdir(parents=True)
    (src / "season.json").write_text(json.dumps({
        "season": 1, "title": "The Missing Signal", "intro": "jenerik-tam.mp4", "short": "jenerik-kisa.mp4",
        "titleBackground": "jenerik-baslik.mp4", "titleDuration": 2.5}), encoding="utf-8")
    for name in ("jenerik-tam.mp4", "jenerik-kisa.mp4", "jenerik-baslik.mp4"):
        (src / "_build" / name).write_bytes(b"x" * 10)
    r = export_season(tmp_path, 1, probe=lambda p: 2.533, poster=lambda src, out: out.write_bytes(b"j" * 5))
    out = tmp_path / "_evren" / "_build" / "season" / "S1"
    assert r["dir"] == out and (out / "jenerik-baslik.mp4").exists()
    doc = json.loads((out / "season.json").read_text(encoding="utf-8"))
    assert doc["title"] == "The Missing Signal"
    assert doc["titleBackground"] == {"video": "jenerik-baslik.mp4", "duration": 2.533, "poster": "jenerik-baslik.webp"}
    assert (out / "jenerik-baslik.webp").read_bytes() == b"jjjjj"
    assert doc["intro"]["video"] == "jenerik-tam.mp4" and doc["totalBytes"] == 35
    assert SeasonSource.load(tmp_path, 2).title == "Sezon 2"  # kaynak yoksa varsayılan
    assert title_caption(1, 3) == "SEZON 1 · BÖLÜM 3"
    (src / "_build" / "jenerik-baslik.mp4").unlink()
    with pytest.raises(FileNotFoundError):
        export_season(tmp_path, 1)


def _season_src(tmp_path):
    src = tmp_path / "_evren" / "jenerik"
    (src / "_build").mkdir(parents=True)
    (src / "season.json").write_text(json.dumps({
        "season": 1, "title": "The Missing Signal", "titleBackground": "jenerik-baslik.mp4"}), encoding="utf-8")
    (src / "_build" / "jenerik-baslik.mp4").write_bytes(b"x" * 10)
    return src


def _tiny_jpeg(w, h):
    # SOI + APP0 (boş) + SOF0 + EOI: boyut okuyucusu için yeterli.
    app0 = b"\xff\xe0" + (4).to_bytes(2, "big") + b"\x00\x00"
    sof = b"\xff\xc0" + (11).to_bytes(2, "big") + b"\x08" + h.to_bytes(2, "big") + w.to_bytes(2, "big") + b"\x01\x01\x11\x00"
    return b"\xff\xd8" + app0 + sof + b"\xff\xd9"


def test_season_catalogue_episodes_and_map(tmp_path):
    """Harita kataloğu (H-035): başlık content.json'dan, available paketten, map.jpg kopyalanır."""
    from hvpipeline.season import build_catalogue, export_season, jpeg_size
    _season_src(tmp_path)
    for n, slug, built in ((1, "a-strange-message", True), (2, "the-new-neighbour", False)):
        d = tmp_path / f"A1-00{n}-{slug}"
        d.mkdir()
        (d / "content.json").write_text(json.dumps({"contentId": f"A1-00{n}", "title": slug.title()}), encoding="utf-8")
        if built:
            (d / "_build" / "package").mkdir(parents=True)
            (d / "_build" / "package" / "scenes.json").write_text("{}", encoding="utf-8")
    harita = tmp_path / "_evren" / "harita"
    harita.mkdir(parents=True)
    cat = {"season": 1, "map": "map.jpg", "teaserStatus": "DRAFT", "episodes": [
        {"number": 2, "contentId": "A1-002", "mapPos": [0.2, 0.7], "teaserTr": "İkinci."},
        {"number": 1, "contentId": "A1-001", "mapPos": [0.4, 0.8], "teaserTr": "Birinci."},
        {"number": 3, "contentId": "A1-003", "mapPos": [0.5, 0.5], "teaserTr": "Üçüncü."}]}
    (harita / "season-01.json").write_text(json.dumps(cat), encoding="utf-8")

    # Görsel yok: episodes yazılır, map alanı yok.
    doc = export_season(tmp_path, 1, poster=lambda s, o: o.write_bytes(b"j"))["doc"]
    assert [e["number"] for e in doc["episodes"]] == [1, 2, 3]
    e1, e2, e3 = doc["episodes"]
    assert e1 == {"number": 1, "contentId": "A1-001", "title": "A-Strange-Message", "teaserTr": "Birinci.",
                  "teaserStatus": "DRAFT", "available": True, "mapPos": [0.4, 0.8]}
    assert e2["available"] is False and e3["title"] == "A1-003" and e3["available"] is False
    assert "map" not in doc

    # Görsel var: kopyalanır, boyutu yazılır, files listesine girer.
    (harita / "map.jpg").write_bytes(_tiny_jpeg(1520, 2688))
    assert jpeg_size(harita / "map.jpg") == (1520, 2688)
    doc = export_season(tmp_path, 1, poster=lambda s, o: o.write_bytes(b"j"))["doc"]
    assert doc["map"] == {"image": "map.jpg", "width": 1520, "height": 2688}
    assert "map.jpg" in [f["path"] for f in doc["files"]]

    # Görsel kaldırılınca paketteki eski kopya da silinir.
    (harita / "map.jpg").unlink()
    doc = export_season(tmp_path, 1, poster=lambda s, o: o.write_bytes(b"j"))["doc"]
    assert "map" not in doc and "map.jpg" not in [f["path"] for f in doc["files"]]

    # Hatalı kayıtlar reddedilir.
    cat["episodes"][0]["mapPos"] = [1.2, 0.5]
    (harita / "season-01.json").write_text(json.dumps(cat), encoding="utf-8")
    with pytest.raises(ValueError):
        build_catalogue(tmp_path, 1)
    cat["episodes"][0]["mapPos"] = [0.2, 0.5]
    cat["episodes"][0]["teaserTr"] = " "
    (harita / "season-01.json").write_text(json.dumps(cat), encoding="utf-8")
    with pytest.raises(ValueError):
        build_catalogue(tmp_path, 1)
    assert build_catalogue(tmp_path, 2) is None


def test_real_season_catalogue_is_complete():
    """Depodaki Sezon 1 kataloğu: 12 bölüm, sıralı, yol aşağıdan yukarı, ipuçları dolu."""
    from pathlib import Path
    from hvpipeline.season import build_catalogue
    root = Path(__file__).resolve().parents[3] / "icerik"
    cat = build_catalogue(root, 1)
    eps = cat["episodes"]
    assert [e["number"] for e in eps] == list(range(1, 13))
    assert [e["contentId"] for e in eps] == [f"A1-{n:03d}" for n in range(1, 13)]
    assert all(e["title"] != e["contentId"] for e in eps)
    assert eps[0]["mapPos"][1] > eps[-1]["mapPos"][1]   # liman altta, fener üstte
    assert all(len(e["teaserTr"]) <= 90 for e in eps)
