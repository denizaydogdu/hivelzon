"""Bağımsız konu reelleri (H-094): kaynak biçimi, reel-lint, mobil eşleşme, sunucu."""

from __future__ import annotations

import importlib.util
import json
import threading
import urllib.error
import urllib.request
from pathlib import Path

import pytest

from hvpipeline.reels import (
    ReelError,
    as_dict,
    discover_reels,
    lint_reel,
    load_reel,
    parse_reel,
    reel_folder,
    write_reports,
)

REPO = Path(__file__).resolve().parents[3]
TRIAL = REPO / "reeller"


def _load_server():
    spec = importlib.util.spec_from_file_location(
        "hv_serve", REPO / "tools" / "dev-content-server" / "serve.py"
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _doc(**over) -> dict:
    doc = {
        "schemaVersion": 1,
        "id": "A1-R-CIN-01",
        "contentVersion": 1,
        "sourceType": "standalone",
        "category": "CIN",
        "level": "A1",
        "titleTr": "Deneme",
        "duration": 9.0,
        "video": "A1-R-CIN-01.mp4",
        "status": "DRAFT",
        "target": {"kind": "phrase", "en": "Hi.", "tr": "Merhaba.", "cue": "c1"},
        "cues": [
            {"id": "c1", "start": 1.0, "end": 2.0, "text": "Hi.", "tr": "Merhaba."}
        ],
    }
    doc.update(over)
    return doc


def test_reel_spectator_is_female_voice():
    """A1-R-SPO-03 seyircisi kadın; SPECTATOR Sarah'ya eşlenmeli (H-094, 2026-10-23)."""
    import tts_reel

    assert tts_reel.voice_for({"speaker": "SPECTATOR"})[0] == "Sarah"


def test_reel_tts_refreshes_cue_file_from_cache(tmp_path, monkeypatch):
    """Metin/ses değişince var olan cue dosyası yeni önbellek parçasıyla yenilenmeli."""
    import tts_reel

    root = tmp_path / "A1-R-SPO-02"
    parts = root / "_raw" / "tts" / "_parts"
    parts.mkdir(parents=True)
    (root / "reel.json").write_text(
        json.dumps({
            "id": "A1-R-SPO-02",
            "cues": [{"id": "s01-03", "speaker": "ELIF", "text": "Here you go."}],
        }),
        encoding="utf-8",
    )
    _, voice = tts_reel.voice_for({"speaker": "ELIF"})
    key = tts_reel.T._part_key("Here you go.", voice, tts_reel.MODEL, tts_reel.SPEED)
    (parts / f"{key}.mp3").write_bytes(b"yeni-sarah-sesi")
    cue_file = root / "_raw" / "tts" / "s01-03.mp3"
    cue_file.write_bytes(b"eski-will-sesi")

    monkeypatch.setattr(tts_reel.T, "ledger_path", lambda _: tmp_path / "ledger.json")
    monkeypatch.setattr(tts_reel.T, "http_client", lambda: lambda *_: pytest.fail("API çağrılmamalı"))
    monkeypatch.setattr(tts_reel, "_duration", lambda _: 1.0)

    assert tts_reel.main([str(root), "--execute", "--monthly-char-cap", "100"]) == 0
    assert cue_file.read_bytes() == b"yeni-sarah-sesi"


def _lint(tmp_path: Path, doc: dict, folder: str = "A1-R-CIN-01"):
    d = tmp_path / folder
    d.mkdir(parents=True, exist_ok=True)
    (d / "reel.json").write_text(
        json.dumps(doc, ensure_ascii=False), encoding="utf-8"
    )
    return lint_reel(d)


def _codes(report) -> set[str]:
    return {i.code for i in report.errors}


# --- kaynak biçimi -------------------------------------------------------------------------------


def test_discover_finds_trial_packages():
    names = [reel_folder(p) for p in discover_reels(TRIAL)]
    assert names == _trial_ids()
    # Pilot kapsamı: 3 kategori × 2 seviye × 3 video = 18 paket (plan §9).
    assert len(names) == 18
    for level in ("A1", "A2"):
        for cat in ("BOK", "CIN", "SPO"):
            assert [f"{level}-R-{cat}-0{i}" for i in (1, 2, 3)] == [
                n for n in names if n.startswith(f"{level}-R-{cat}-")
            ]


def test_load_trial_reel_reads_identity_and_target():
    reel = load_reel(TRIAL / "A1-R-CIN-01")
    assert reel.id == "A1-R-CIN-01"
    assert reel.category == "CIN" and reel.category_tr == "Sinema"
    assert reel.level == "A1"
    assert reel.source_type == "standalone"
    assert reel.target_en == "Two tickets, please."
    assert reel.target_tr == "İki bilet, lütfen."
    assert reel.target_cue == "s02-02" and reel.target_cue in reel.cue_ids
    assert reel.has_practice
    assert reel.image == "stills/s02.webp" and reel.audio == "audio/s02-02.m4a"


def test_parse_reel_rejects_unknown_schema_version():
    with pytest.raises(ReelError):
        parse_reel(_doc(schemaVersion=2))


def test_parse_reel_rejects_missing_required_field():
    doc = _doc()
    doc.pop("video")
    with pytest.raises(ReelError):
        parse_reel(doc)


# --- lint: deneme paketleri temiz ----------------------------------------------------------------


def test_trial_packages_have_no_errors():
    for d in sorted(p for p in TRIAL.iterdir() if p.is_dir()):
        report = lint_reel(d)
        assert report.ok, [str(i) for i in report.errors]
        # Medya henüz üretilmediyse uyarı olur, hata olmaz (P0 kuralı): medya
        # dosyalarının varlığı ortama bağlıdır (depo dışı), bu yüzden burada
        # yalnız "medya asla hata sayılmaz" kuralı sınanır.
        assert not [i for i in report.errors if i.code == "reel.media"]


def _trial_ids() -> list[str]:
    return sorted(p.name for p in TRIAL.iterdir() if p.is_dir() and not p.name.startswith("_"))


def test_mobile_fixture_matches_package():
    """Dart fixture'ları `reeller/` paketleriyle aynı kalmalı (kayma koruması)."""
    ids = _trial_ids()
    assert ids, "deneme paketi yok"
    for rid in ids:
        pkg = (TRIAL / rid / "reel.json").read_text(encoding="utf-8")
        fixture_path = REPO / "mobile" / "test" / "fixtures" / "reels" / f"{rid}.json"
        assert fixture_path.is_file(), f"fixture yok: {fixture_path.name}"
        assert pkg == fixture_path.read_text(encoding="utf-8"), rid


def test_mobile_index_summaries_match_packages():
    """`fixtures/reels/index.json`, paketlerden türeyen özetle aynı olmalı
    (uygulamanın sunucudan gördüğü liste)."""
    server = _load_server()
    expected = [
        {k: v for k, v in r.items() if k != "dir"}
        for r in sorted(server.discover_reels(TRIAL).values(), key=lambda r: r["id"])
    ]
    index = json.loads(
        (REPO / "mobile" / "test" / "fixtures" / "reels" / "index.json").read_text(
            encoding="utf-8"
        )
    )
    assert index["schemaVersion"] == 1
    assert index["reels"] == expected
    assert len(index["reels"]) == len(_trial_ids())


# --- lint: hatalar -------------------------------------------------------------------------------


def test_lint_base_document_has_no_errors(tmp_path):
    report = _lint(tmp_path, _doc())
    assert report.ok, [str(i) for i in report.errors]


def test_lint_requires_folder_to_match_id(tmp_path):
    report = _lint(tmp_path, _doc(), folder="A1-R-CIN-99")
    assert "reel.folder" in _codes(report)


def test_lint_rejects_level_mismatch_in_id(tmp_path):
    report = _lint(tmp_path, _doc(level="A2"))
    assert "reel.id.level" in _codes(report)


def test_lint_rejects_category_mismatch_in_id(tmp_path):
    report = _lint(tmp_path, _doc(category="SPO"))
    assert "reel.id.category" in _codes(report)


def test_lint_rejects_unknown_category(tmp_path):
    report = _lint(tmp_path, _doc(category="TAR", id="A1-R-TAR-01"), folder="A1-R-TAR-01")
    assert "reel.category" in _codes(report)


def test_lint_rejects_episode_clip_in_reels_root(tmp_path):
    report = _lint(tmp_path, _doc(sourceType="episode_clip"))
    assert "reel.sourceType" in _codes(report)


def test_lint_rejects_unknown_status(tmp_path):
    report = _lint(tmp_path, _doc(status="GIZLI"))
    assert "reel.status" in _codes(report)


def test_lint_rejects_missing_target_cue(tmp_path):
    doc = _doc()
    doc["target"]["cue"] = "c9"
    report = _lint(tmp_path, doc)
    assert "reel.target.cue" in _codes(report)


def test_lint_rejects_duplicate_cue_ids(tmp_path):
    doc = _doc()
    doc["cues"].append({"id": "c1", "start": 3.0, "end": 4.0, "text": "Bye.", "tr": "Hoşça kal."})
    report = _lint(tmp_path, doc)
    assert "reel.cue.duplicate" in _codes(report)


def test_lint_requires_one_correct_option(tmp_path):
    doc = _doc(
        practice={
            "promptTr": "Ne?",
            "options": [
                {"text": "A", "correct": True},
                {"text": "B", "correct": True},
            ],
        }
    )
    report = _lint(tmp_path, doc)
    assert "reel.practice.correct" in _codes(report)


def test_lint_requires_target_kind(tmp_path):
    doc = _doc()
    doc["target"]["kind"] = "sentence"
    report = _lint(tmp_path, doc)
    assert "reel.target.kind" in _codes(report)


def test_lint_reports_missing_file(tmp_path):
    report = lint_reel(tmp_path / "A1-R-CIN-01")
    assert "reel.file" in _codes(report)


def test_as_dict_is_machine_readable(tmp_path):
    report = _lint(tmp_path, _doc())
    d = as_dict(report)
    assert d["id"] == "A1-R-CIN-01" and d["errors"] == 0


# --- geliştirme içerik sunucusu ------------------------------------------------------------------


def test_dev_server_serves_reels():
    serve = _load_server()
    serve.Handler.root = REPO / "icerik-yok"
    serve.Handler.books_root = REPO / "kitaplar-yok"
    serve.Handler.grammar_root = REPO / "dilbilgisi-yok"
    serve.Handler.reels_root = TRIAL
    serve.Handler.quiet = True
    srv = serve.ThreadingHTTPServer(("127.0.0.1", 0), serve.Handler)
    th = threading.Thread(target=srv.serve_forever, daemon=True)
    th.start()
    try:
        base = f"http://127.0.0.1:{srv.server_address[1]}"
        idx = json.loads(urllib.request.urlopen(f"{base}/reels/index.json").read())
        assert [r["id"] for r in idx["reels"]] == _trial_ids()
        assert {r["level"] for r in idx["reels"]} == {"A1", "A2"}
        assert {r["category"] for r in idx["reels"]} == {"CIN", "SPO", "BOK"}
        assert idx["reels"][0]["id"] == "A1-R-BOK-01"
        assert idx["reels"][0]["categoryTr"] == "Kitap"
        one = json.loads(urllib.request.urlopen(f"{base}/reels/A1-R-CIN-01/reel.json").read())
        assert one["id"] == "A1-R-CIN-01" and one["target"]["en"] == "Two tickets, please."
        # Backend VideoHostingPort yolu (`_reels/`) da aynı pakete gider.
        alias = json.loads(
            urllib.request.urlopen(f"{base}/packages/_reels/A1-R-CIN-01/reel.json").read()
        )
        assert alias["id"] == "A1-R-CIN-01"
        with pytest.raises(urllib.error.HTTPError):
            urllib.request.urlopen(f"{base}/reels/A2-BOK-09/reel.json")
    finally:
        srv.shutdown()
        srv.server_close()

def test_write_reports_writes_backend_lint_summary(tmp_path):
    """`reel_lint --write-reports`: reel başına `_build/lint.json` (backend onayı için)."""
    d = tmp_path / "A1-R-CIN-01"
    d.mkdir()
    (d / "reel.json").write_text(
        (TRIAL / "A1-R-CIN-01" / "reel.json").read_text(encoding="utf-8"), encoding="utf-8"
    )
    written = write_reports([lint_reel(d)])
    assert written == [d / "_build" / "lint.json"]
    doc = json.loads(written[0].read_text(encoding="utf-8"))
    assert doc["tool"] == "reel-lint"
    assert doc["schemaVersion"] == 1
    assert doc["contentId"] == "A1-R-CIN-01"
    assert doc["level"] == "A1"
    assert doc["errors"] == []
    assert isinstance(doc["warnings"], list)
    assert doc["generatedAt"].endswith("Z")
    # Üretim paketi düzeninde de rapor kaynak köke yazılır (paket içine değil).
    pkg = d / "_build" / "package"
    pkg.mkdir()
    (pkg / "reel.json").write_text((d / "reel.json").read_text(encoding="utf-8"), encoding="utf-8")
    written = write_reports([lint_reel(d)])
    assert written == [d / "_build" / "lint.json"]


def test_write_reports_marks_errors(tmp_path):
    d = tmp_path / "A1-R-CIN-01"
    d.mkdir()
    doc = json.loads((TRIAL / "A1-R-CIN-01" / "reel.json").read_text(encoding="utf-8"))
    doc["level"] = "A2"  # kimlikle uyuşmuyor
    (d / "reel.json").write_text(json.dumps(doc), encoding="utf-8")
    written = write_reports([lint_reel(d)])
    report = json.loads(written[0].read_text(encoding="utf-8"))
    assert any("seviyesi" in e for e in report["errors"])


# --- ses sığma denetimi (H-094 §8) ---------------------------------------------------------------


def _with_audio(tmp_path: Path, *, shot_len: float, cue_len: float, aoff: float = 0.5):
    """shots.json + _raw/tts/timing.json ile üretim tarafı denetimi."""
    d = tmp_path / "A1-R-CIN-01"
    d.mkdir(parents=True, exist_ok=True)
    (d / "reel.json").write_text(json.dumps(_doc(), ensure_ascii=False), encoding="utf-8")
    (d / "shots.json").write_text(
        json.dumps(
            {
                "timeline": [
                    {"shot": "k1", "len": shot_len, "audio": "c1", "aoff": aoff},
                ]
            }
        ),
        encoding="utf-8",
    )
    tts = d / "_raw" / "tts"
    tts.mkdir(parents=True)
    (tts / "timing.json").write_text(json.dumps({"c1": cue_len}), encoding="utf-8")
    return lint_reel(d)


def test_lint_flags_cue_cut_by_shot_length(tmp_path):
    """Ses kare süresinden uzunsa kurguda kesilir: sessiz kırpma hata olmalı."""
    report = _with_audio(tmp_path, shot_len=2.0, cue_len=2.4)
    assert "reel.audio.fit" in _codes(report)
    msg = next(i.message for i in report.errors if i.code == "reel.audio.fit")
    assert "ses kesilir" in msg and "c1 2.40 sn" in msg


def test_lint_accepts_cue_that_fits_shot(tmp_path):
    report = _with_audio(tmp_path, shot_len=3.0, cue_len=2.4)
    assert "reel.audio.fit" not in _codes(report)


def test_lint_skips_audio_fit_when_no_timing(tmp_path):
    """Ses henüz üretilmeden (timing.json yok) denetim susar; uyarı da üretmez."""
    d = tmp_path / "A1-R-CIN-01"
    d.mkdir()
    (d / "reel.json").write_text(json.dumps(_doc(), ensure_ascii=False), encoding="utf-8")
    (d / "shots.json").write_text(
        json.dumps({"timeline": [{"shot": "k1", "len": 1.0, "audio": "c1"}]}),
        encoding="utf-8",
    )
    report = lint_reel(d)
    assert "reel.audio.fit" not in {i.code for i in report.errors + report.warnings}


# --- alt yazı hizası (H-094 §8) -------------------------------------------------------------------


def _with_cues(tmp_path: Path, cue_start: float, shot_len: float = 3.0, aoff: float = 0.5):
    d = tmp_path / "A1-R-CIN-01"
    d.mkdir(parents=True, exist_ok=True)
    doc = _doc()
    doc["cues"][0]["start"] = cue_start
    doc["cues"][0]["end"] = cue_start + 1.0
    (d / "reel.json").write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")
    (d / "shots.json").write_text(
        json.dumps({"timeline": [{"shot": "k1", "len": shot_len, "audio": "c1", "aoff": aoff}]}),
        encoding="utf-8",
    )
    return lint_reel(d)


def test_lint_warns_stale_cue_time_in_source(tmp_path):
    """Kaynak reel.json elle yazılır: çekim 0,5 sn'de konuşurken 1,0 sn → uyarı."""
    report = _with_cues(tmp_path, cue_start=1.0)
    codes = {i.code for i in report.warnings}
    assert "reel.cue.window" in codes
    assert "reel.cue.window" not in _codes(report)


def test_lint_accepts_cue_at_shot_audio_offset(tmp_path):
    report = _with_cues(tmp_path, cue_start=0.5)
    assert "reel.cue.window" not in {i.code for i in report.errors + report.warnings}


def test_lint_rejects_stale_cue_time_in_built_package(tmp_path):
    """Kurulmuş pakette hiza zorunlu: build_reel yeniden hizalar, eski paket geçmez."""
    _with_cues(tmp_path, cue_start=1.0)
    src = tmp_path / "A1-R-CIN-01"
    pkg = src / "_build" / "package"
    pkg.mkdir(parents=True)
    (pkg / "reel.json").write_text((src / "reel.json").read_text(encoding="utf-8"), encoding="utf-8")
    report = lint_reel(src)
    assert "reel.cue.window" in _codes(report)
