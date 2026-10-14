"""H-040: Keşfet klipleri (kaynak denetimi, altyazı kaydırma, dışa aktarma, kesim ve ses düzeyi)."""
import copy
import json
import shutil
import subprocess
from pathlib import Path

import pytest

import content_lint
from hvpipeline import media
from hvpipeline.clips import (MAX_SECONDS, export_clips, find_target, lint_clip_file, lint_clips,
                              load_clip_sources, phrase_variants)

REPO = Path(__file__).resolve().parents[3]
ICERIK = REPO / "icerik"
HAS_FFMPEG = all(shutil.which(t) for t in ("ffmpeg", "ffprobe"))
HAS_MEDIA = HAS_FFMPEG and shutil.which("magick") is not None
REAL_PACKAGES = all(any(ICERIK.glob(f"A1-00{n}-*/_build/package/scenes.json")) for n in range(1, 5))


def _cue(cid, start, end, text, tr="tr"):
    words, t = [], start
    toks = text.split()
    step = (end - start) / len(toks)
    for w in toks:
        words.append({"w": w, "start": round(t, 3), "end": round(t + step * 0.9, 3), "gloss": "g"})
        t += step
    return {"id": cid, "start": start, "end": end, "speaker": "MAYA", "text": text, "tr": tr, "words": words,
            "chunks": []}


def _subs(seg, duration, cues):
    return {"schemaVersion": 1, "segment": seg, "lang": "en", "duration": duration, "cues": cues}


def _clip(**kw):
    d = {"id": "S1-K01", "episode": "A1-001",
         "parts": [{"node": "s02", "start": 0, "end": 10.0}, {"node": "k1-ok", "start": 0, "end": 3.0}],
         "titleTr": "Telsizde bir ses",
         "target": {"kind": "phrase", "en": "Can you hear me?", "tr": "Beni duyabiliyor musun?"},
         "grammar": "G-A1-07-can",
         "quiz": {"promptTr": "Kısa cevap hangisi?",
                  "options": [{"text": "Yes, I can.", "lang": "en", "correct": True},
                              {"text": "Yes, I am.", "lang": "en"}],
                  "explainTr": "Can you…? sorusuna Yes, I can."}}
    d.update(kw)
    return d


@pytest.fixture
def root(tmp_path):
    """Küçük içerik kökü: paketi olan bir bölüm (iki segment, altyazı), bir ders ve bir klip dosyası."""
    icerik = tmp_path / "icerik"
    ep = icerik / "A1-001-test"
    pkg = ep / "_build" / "package"
    (pkg / "segments").mkdir(parents=True)
    (pkg / "subs").mkdir()
    (ep / "content.json").write_text(json.dumps({"contentId": "A1-001", "title": "A Test", "status": "DRAFT"}),
                                     encoding="utf-8")
    nodes = []
    for nid, dur in (("s02", 10.0), ("k1-ok", 3.0), ("s03", 40.0)):
        (pkg / "segments" / f"{nid}.720p.mp4").write_bytes(b"mp4")
        nodes.append({"id": nid, "type": "segment", "video": f"segments/{nid}.mp4",
                      "renditions": {"720p": f"segments/{nid}.720p.mp4", "1080p": f"segments/{nid}.mp4"},
                      "duration": dur, "subtitles": f"subs/{nid}.en.json"})
    nodes.append({"id": "k1", "type": "decision"})
    (pkg / "scenes.json").write_text(json.dumps({"schemaVersion": 2, "episode": {"id": "A1-001", "number": 1,
                                                                                  "title": "A Test"},
                                                 "nodes": nodes}), encoding="utf-8")
    subs = {
        "s02": _subs("s02", 10.0, [_cue("s02-01", 0.5, 2.0, "Hello? Hello?"),
                                   _cue("s02-02", 6.0, 8.0, "Can you hear me?")]),
        "k1-ok": _subs("k1-ok", 3.0, [_cue("k1-ok-01", 0.4, 2.2, "Yes, I can hear you.")]),
        "s03": _subs("s03", 40.0, [_cue("s03-01", 1.0, 3.0, "This is E.")]),
    }
    for nid, doc in subs.items():
        (pkg / "subs" / f"{nid}.en.json").write_text(json.dumps(doc), encoding="utf-8")
    g = tmp_path / "dilbilgisi" / "G-A1-07-can"
    g.mkdir(parents=True)
    (g / "lesson.json").write_text(json.dumps({"id": "G-A1-07-can", "titleTr": "can / can't"}), encoding="utf-8")
    cd = icerik / "_evren" / "klipler"
    cd.mkdir(parents=True)
    doc = {"schemaVersion": 1, "season": 1, "level": "A1", "status": "DRAFT", "clips": [_clip()]}
    (cd / "S1.json").write_text(json.dumps(doc), encoding="utf-8")
    return icerik


def _issues(root, mutate=None, require_approved=False):
    p = root / "_evren" / "klipler" / "S1.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    if mutate:
        mutate(doc)
    issues, report, recs = lint_clip_file(p, doc, root, require_approved=require_approved)
    return issues, report, recs


def _codes(issues, level="error"):
    return {i.code for i in issues if i.level == level}


# --- metin ----------------------------------------------------------------------------------

def test_phrase_variants_and_prefix_match():
    assert phrase_variants("Turn left / right.") == [["turn", "left"], ["turn", "right"]]
    assert phrase_variants("Where is…?") == [["where", "is"]]
    cues = [_cue("a", 0, 1, "OK. Friday."), _cue("b", 1, 2, "Where is the old station?"),
            _cue("c", 2, 3, "It’s between Pier 2 and Pier 4.")]
    assert find_target(cues, "Where is…?") == "b"
    assert find_target(cues, "It's between…") == "c"
    assert find_target(cues, "friday") == "a"
    assert find_target(cues, "Go straight.") is None


# --- denetim --------------------------------------------------------------------------------

def test_valid_clip_shifts_cues_into_clip_time(root):
    issues, report, recs = _issues(root)
    assert not _codes(issues)
    assert report["valid"] == 1 and report["quizzes"] == 1 and report["seconds"] == 13.0
    rec = recs[0]
    assert rec["duration"] == 13.0
    assert [c["id"] for c in rec["cues"]] == ["s02-01", "s02-02", "k1-ok-01"]
    # İkinci parça klibin 10. saniyesinde başlar: k1-ok-01 0,4 → 10,4.
    k = rec["cues"][2]
    assert (k["start"], k["end"]) == (10.4, 12.2)
    assert k["words"][0]["start"] == 10.4
    assert rec["target"]["cue"] == "s02-02"
    assert rec["grammar"] == {"id": "G-A1-07-can", "titleTr": "can / can't"}
    assert rec["episodeNumber"] == 1 and rec["episodeTitle"] == "A Test"
    assert rec["quiz"]["options"][1]["correct"] is False


def test_clip_trimmed_inside_segment_keeps_relative_times(root):
    def m(d):
        d["clips"][0]["parts"] = [{"node": "s02", "start": 5.0, "end": 9.0}]
        d["clips"][0].pop("quiz")
    issues, _, recs = _issues(root, m)
    assert not _codes(issues)
    assert [c["id"] for c in recs[0]["cues"]] == ["s02-02"]
    assert recs[0]["cues"][0]["start"] == 1.0 and recs[0]["duration"] == 4.0


@pytest.mark.parametrize("mutate,code", [
    (lambda c: c["parts"][0].update(end=10.5), "clip-bounds"),            # segment 10 sn
    (lambda c: c["parts"][0].update(start=4.0, end=3.0), "clip-bounds"),
    (lambda c: c["parts"][0].update(end=7.0), "clip-cue-cut"),            # "Can you hear me?" 6–8 sn
    (lambda c: c["parts"][0].update(node="nope"), "clip-node"),
    (lambda c: c["parts"][0].update(node="k1"), "clip-node"),             # karar düğümü videosuz
    (lambda c: c.update(parts=[{"node": "s03", "start": 0, "end": 31.0}]), "clip-duration"),
    (lambda c: c.update(parts=[{"node": "k1-ok", "start": 0, "end": 2.5}]), "clip-duration"),
    (lambda c: c.update(target={"kind": "phrase", "en": "Go straight.", "tr": "Düz git."}), "clip-target"),
    (lambda c: c.update(target={"kind": "grammar", "en": "x", "tr": "y"}), "clip-target"),
    (lambda c: c.update(grammar="G-A1-99-nope"), "clip-grammar"),
    (lambda c: c.update(grammar="can"), "clip-grammar"),
    (lambda c: c["quiz"]["options"][1].update(correct=True), "clip-quiz"),
    (lambda c: c["quiz"].update(options=c["quiz"]["options"][:1]), "clip-quiz"),
    (lambda c: c["quiz"].update(explainTr="Yanlış yaptın, son şans."), "clip-quiz-tone"),
    (lambda c: c.update(titleTr=""), "clip-title"),
    (lambda c: c.update(id="K1"), "clip-id"),
    (lambda c: c.update(episode="A1-009"), "clip-episode"),
])
def test_lint_errors(root, mutate, code):
    issues, _, recs = _issues(root, lambda d: mutate(d["clips"][0]))
    assert code in _codes(issues)
    assert recs == []


def test_duplicate_id_and_other_season(root):
    issues, _, _ = _issues(root, lambda d: d["clips"].append(copy.deepcopy(d["clips"][0])))
    assert "clip-id" in _codes(issues)
    issues, _, _ = _issues(root, lambda d: d["clips"][0].update(id="S2-K01"))
    assert "clip-id" in _codes(issues)


def test_max_duration_is_thirty_seconds(root):
    def m(d):
        d["clips"][0].update(parts=[{"node": "s03", "start": 0, "end": MAX_SECONDS}],
                             target={"kind": "phrase", "en": "This is…", "tr": "Bu…"}, quiz=None)
        d["clips"][0].pop("quiz")
    issues, _, recs = _issues(root, m)
    assert not _codes(issues) and recs[0]["duration"] == 30.0


def test_unapproved_content_warns_and_fails_release_check(root):
    issues, _, recs = _issues(root)
    assert {"clips-status", "clip-source-status"} <= _codes(issues, "warning")
    assert recs[0]["sourceStatus"] == "DRAFT"
    issues, _, _ = _issues(root, require_approved=True)
    assert {"clips-status", "clip-source-status"} <= _codes(issues)
    # Onaylı bölüm + onaylı klip dosyası: yayın denetimi temiz.
    cj = root / "A1-001-test" / "content.json"
    cj.write_text(json.dumps({"contentId": "A1-001", "status": "APPROVED"}), encoding="utf-8")
    issues, _, _ = _issues(root, lambda d: d.update(status="APPROVED"), require_approved=True)
    assert not _codes(issues) and not _codes(issues, "warning")


def test_missing_package_is_an_error(root):
    shutil.rmtree(root / "A1-001-test" / "_build")
    issues, _, _ = _issues(root)
    assert "clip-package" in _codes(issues)


def test_content_lint_reports_clips(root, capsys):
    rc = content_lint.main([str(root / "A1-001-test"), "--no-sets", "--no-hi", "--no-chain", "--json"])
    out = json.loads(capsys.readouterr().out)
    assert out["clips"][0]["file"] == "S1.json" and out["clips"][0]["valid"] == 1
    assert out["clips"][0]["errors"] == []
    rc2 = content_lint.main([str(root / "A1-001-test"), "--no-sets", "--no-hi", "--json", "--require-approved"])
    out2 = json.loads(capsys.readouterr().out)
    assert rc2 == 1 and out2["clips"][0]["errors"]
    assert rc in (0, 1)   # bölümün kendi denetimi (fikstür bölümü eksik alanlı) klipten bağımsız


# --- dışa aktarma ---------------------------------------------------------------------------

def test_export_writes_clips_json_and_removes_stale_media(root, tmp_path):
    out = tmp_path / "S1"
    (out / "clips").mkdir(parents=True)
    (out / "clips" / "S1-K99.mp4").write_bytes(b"old")
    summary = export_clips(root, 1, out)
    assert summary["count"] == 1 and summary["quizzes"] == 1 and summary["status"] == "DRAFT"
    doc = json.loads((out / "clips.json").read_text(encoding="utf-8"))
    assert doc["aiLabel"] == "Yapay zekâ ile üretilmiştir"
    c = doc["clips"][0]
    assert c["video"] == "clips/S1-K01.mp4"
    assert [p["node"] for p in c["parts"]] == ["s02", "k1-ok"] and "video" not in c["parts"][0]
    assert not (out / "clips" / "S1-K99.mp4").exists()
    # Kaynak silinince paket dosyası da kalkar.
    (root / "_evren" / "klipler" / "S1.json").unlink()
    assert export_clips(root, 1, out) is None
    assert not (out / "clips.json").exists()


def test_export_refuses_invalid_clips(root, tmp_path):
    p = root / "_evren" / "klipler" / "S1.json"
    doc = json.loads(p.read_text(encoding="utf-8"))
    doc["clips"][0]["parts"][0]["end"] = 7.0
    p.write_text(json.dumps(doc), encoding="utf-8")
    with pytest.raises(ValueError, match="clip-cue-cut"):
        export_clips(root, 1, tmp_path / "S1")


def test_export_calls_media_once_and_caches(root, tmp_path):
    calls = []

    def cut(parts, gain, out):
        calls.append((parts, gain))
        Path(out).write_bytes(b"x" * 100)

    def measure(parts):
        return {"I": -14.0 if len(parts) == 2 else -16.0, "TP": -2.0, "LRA": 3.0}

    out = tmp_path / "S1"
    export_clips(root, 1, out, cut=cut, measure=measure)
    assert len(calls) == 1 and calls[0][1] == -2.0
    assert [(p[1], p[2]) for p in calls[0][0]] == [(0, 10.0), (0, 3.0)]
    c = json.loads((out / "clips.json").read_text(encoding="utf-8"))["clips"][0]
    assert c["loudness"]["gainDb"] == -2.0 and c["loudness"]["after"]["I"] == -16.0 and c["bytes"] == 100
    export_clips(root, 1, out, cut=cut, measure=measure)
    assert len(calls) == 1   # kaynak değişmedi: yeniden kesilmez


# --- medya (ffmpeg) -------------------------------------------------------------------------

def _tone(path: Path, seconds: float, volume_db: float, freq: int):
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i",
                    f"color=c=0x336699:s=720x1280:r=30:d={seconds}", "-f", "lavfi", "-i",
                    f"sine=frequency={freq}:sample_rate=44100:duration={seconds}", "-af", f"volume={volume_db}dB",
                    "-c:v", "libx264", "-pix_fmt", "yuv420p", "-c:a", "aac", "-shortest", str(path)], check=True)


@pytest.mark.skipif(not HAS_FFMPEG, reason="ffmpeg yok")
def test_cut_clip_joins_parts_at_minus_16_lufs(tmp_path):
    a, b = tmp_path / "a.mp4", tmp_path / "b.mp4"
    _tone(a, 6, -8, 440)
    _tone(b, 4, -26, 660)
    parts = [(a, 1.0, 5.0), (b, 0.5, 3.5)]
    before = media.parts_loudness(parts)
    gain = round(-16.0 - before["I"], 2)
    out = media.cut_clip(parts, gain, tmp_path / "clip.mp4")
    assert abs(media.probe_duration(out) - 7.0) < 0.1
    after = media.parts_loudness([(out, 0.0, None)])
    assert abs(after["I"] + 16.0) <= 1.0
    streams = media.probe_streams(out)
    v = next(s for s in streams if s["codec_type"] == "video")
    assert (v["width"], v["height"], v["pix_fmt"]) == (720, 1280, "yuv420p")


@pytest.mark.skipif(not (HAS_MEDIA and REAL_PACKAGES), reason="bölüm paketleri ya da medya araçları yok")
def test_real_season_clips_cut_and_level(tmp_path):
    """Gerçek kaynaktan bir klip (iki parça) kesilir; süre ve ses düzeyi tutar."""
    _, doc = load_clip_sources(ICERIK, 1)[0]
    doc = copy.deepcopy(doc)
    doc["clips"] = [c for c in doc["clips"] if c["id"] == "S1-K01"]
    root = tmp_path / "icerik"
    (root / "_evren" / "klipler").mkdir(parents=True)
    for d in ICERIK.glob("A1-001-*"):
        (root / d.name).symlink_to(d)
    (root / "_evren" / "klipler" / "S1.json").write_text(json.dumps(doc), encoding="utf-8")
    (tmp_path / "dilbilgisi").symlink_to(REPO / "dilbilgisi")
    out = tmp_path / "S1"
    s = export_clips(root, 1, out, cut=media.cut_clip, measure=media.parts_loudness, poster=media.frame_webp,
                     probe=media.probe_duration)
    c = json.loads((out / "clips.json").read_text(encoding="utf-8"))["clips"][0]
    assert s["count"] == 1 and abs(c["videoDuration"] - c["duration"]) < 0.1
    assert abs(c["loudness"]["after"]["I"] + 16.0) <= 0.5
    assert (out / "clips" / "S1-K01.webp").exists()


# --- gerçek kaynak --------------------------------------------------------------------------

def test_real_source_shape():
    """S1 kaynağı: 16–24 klip, her biri tek hedef taşır, quiz'ler denetimden geçer (paket gerekmez)."""
    _, doc = load_clip_sources(ICERIK, 1)[0]
    clips = doc["clips"]
    assert 16 <= len(clips) <= 24
    assert len({c["id"] for c in clips}) == len(clips)
    for c in clips:
        assert c["target"]["en"] and c["target"]["tr"]
        assert sum(p["end"] - p["start"] for p in c["parts"]) <= MAX_SECONDS
    # 4–5 klipte bir quiz kartı çıkabilmesi için her 4'lü blokta en az bir quiz var.
    for i in range(0, len(clips) - 3, 4):
        assert any("quiz" in c for c in clips[i:i + 4])


@pytest.mark.skipif(not REAL_PACKAGES, reason="bölüm paketleri yok (git dışı)")
def test_real_source_lints_clean_against_packages():
    (name, issues, report), = lint_clips(ICERIK, 1)
    assert not [str(i) for i in issues if i.level == "error"]
    assert report["valid"] == report["clips"] and report["maxSeconds"] <= MAX_SECONDS
