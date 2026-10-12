"""content-lint denetimleri: bağ alanları, CEFR kapsama, cümle uzunluğu, scenes grafiği, zincir.

Kurallar: CLAUDE.md (kapsama kuralı, CEFR tablosu, bağ kuralları), OYUN-TASARIMI §4.3 ve §12.4.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path

from .build import KURGU_FILE, BuildError, build_dry
from .cefr import LEVELS, coverage
from .graph import Issue, check_scenes
from .season import SeasonSource
from .story import read_story
from .translation import TRANSLATION_FILE, Translation, word_key

LINK_FIELDS = ("previously", "payoff", "openQuestion", "answers", "cluesUnlocked", "callbackPhrases")
COVERAGE_TARGET = 98.0
COVERAGE_FLOOR = 95.0
MAX_SENTENCE_WORDS = {"A1": 8, "A2": 12}
QUESTION_WINDOW = 3
MAX_OPEN_EPISODE_QUESTIONS = 2


@dataclass
class EpisodeReport:
    path: Path
    content_id: str = "?"
    level: str = "?"
    issues: list[Issue] = field(default_factory=list)
    coverage: dict | None = None
    graph: dict | None = None
    translation: dict | None = None

    @property
    def errors(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "error"]

    @property
    def warnings(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "warning"]

    def to_dict(self) -> dict:
        return {"path": str(self.path), "contentId": self.content_id, "level": self.level,
                "coverage": self.coverage, "graph": self.graph, "translation": self.translation,
                "errors": [str(i) for i in self.errors], "warnings": [str(i) for i in self.warnings]}


def check_links(c: dict) -> list[Issue]:
    out = []
    first = c.get("prev") is None
    for f in LINK_FIELDS:
        if f not in c:
            out.append(Issue("error", "links", f"content.json zorunlu bağ alanı eksik: {f}"))
    for f in ("payoff", "openQuestion"):
        if f in c and not (isinstance(c[f], str) and c[f].strip()):
            out.append(Issue("error", "links", f"content.json `{f}` boş olamaz"))
    if "previously" in c:
        v = c["previously"]
        if v is None and not first:
            out.append(Issue("error", "links", "`previously` yalnızca ilk bölümde (prev = null) boş olabilir"))
        elif v is not None and not (isinstance(v, str) and v.strip()):
            out.append(Issue("error", "links", "`previously` metin olmalı"))
    for f in ("answers", "cluesUnlocked", "callbackPhrases"):
        if f in c and not isinstance(c[f], list):
            out.append(Issue("error", "links", f"`{f}` liste olmalı"))
    if isinstance(c.get("callbackPhrases"), list) and not c["callbackPhrases"] and not first:
        out.append(Issue("warning", "links", "`callbackPhrases` boş (önceki bölüme geri dönüş yok)"))
    flags = c.get("flags") or []
    if len(flags) > 3:
        out.append(Issue("error", "flags", f"content.json'da {len(flags)} bayrak var (K-28: en fazla 3)"))
    return out


def check_language(ep_dir: Path, c: dict) -> tuple[list[Issue], dict | None]:
    level = c.get("level", "A1")
    story = ep_dir / "story.en.md"
    if not story.exists():
        return [Issue("error", "story", "story.en.md yok")], None
    lines = read_story(story)
    if level not in LEVELS:
        return [Issue("warning", "coverage", f"{level}: CEFR-J listesi A1-B2 kapsıyor; kapsama denetlenmedi")], None
    max_words = MAX_SENTENCE_WORDS.get(level, 10_000)
    cov = coverage([ln.text for ln in lines], level, gloss=c.get("glossary", []), max_words=max_words)
    issues = []
    pct, pctg = cov.pct, cov.pct_with_gloss
    ungl = cov.unglossed()
    if pct >= COVERAGE_TARGET:
        pass
    elif pct >= COVERAGE_FLOOR and pctg >= COVERAGE_TARGET:
        issues.append(Issue("warning", "coverage",
                            f"{level} kapsama %{pct:.1f} (hedef %{COVERAGE_TARGET:.0f}); sözlükle %{pctg:.1f}. "
                            "Alt sınır yalnızca sözlük + görsel destekle geçerli; görsel desteği editör doğrular."))
    else:
        issues.append(Issue("error", "coverage",
                            f"{level} kapsama %{pct:.1f}, sözlükle %{pctg:.1f}: hedef %{COVERAGE_TARGET:.0f}; "
                            f"%{COVERAGE_FLOOR:.0f}-%{COVERAGE_TARGET:.0f} arası yalnızca sözlükle tamamlanırsa kabul"))
    if ungl:
        issues.append(Issue("warning", "off-list",
                            "sözlükte olmayan liste dışı sözcükler: "
                            + ", ".join(f"{k}[{v[0]}]×{v[1]}" for k, v in sorted(ungl.items(), key=lambda x: -x[1][1]))))
    for s in cov.long_sentences:
        issues.append(Issue("error", "sentence-length", f"{level} için cümle en çok {max_words} sözcük: \"{s}\""))
    rep = {"tokens": cov.tokens, "pct": round(pct, 1), "pctWithGlossary": round(pctg, 1),
           "maxSentenceWords": cov.max_sentence_words, "sentencesOver": len(cov.long_sentences),
           "offList": {k: v for k, v in sorted(cov.off_list.items())}, "lines": len(lines)}
    return issues, rep


def check_graph(ep_dir: Path, c: dict, source: str = "auto") -> tuple[list[Issue], dict | None]:
    pkg = ep_dir / "_build" / "package" / "scenes.json"
    has_kurgu = (ep_dir / KURGU_FILE).exists()
    if source in ("auto", "package") and pkg.exists():
        doc = json.loads(pkg.read_text(encoding="utf-8"))
        origin = "package"
        issues = check_scenes(doc)
        issues += _check_package_files(pkg.parent, doc)
        issues += _check_season_files(ep_dir, doc)
    elif has_kurgu and source in ("auto", "kurgu"):
        try:
            doc, _ = build_dry(ep_dir)
        except (BuildError, FileNotFoundError, KeyError) as e:
            return [Issue("error", "kurgu", f"{KURGU_FILE} okunamadı: {e}")], None
        origin = "kurgu (kuru derleme)"
        issues = check_scenes(doc)
    else:
        return [], None
    nodes = doc.get("nodes", [])
    count = lambda t: sum(1 for n in nodes if n.get("type") == t)  # noqa: E731
    rep = {"source": origin, "nodes": len(nodes), "segments": count("segment"), "decisions": count("decision"),
           "reactions": count("reaction"), "cards": count("card"), "tasks": count("task"),
           "titles": count("title"), "recaps": count("recap"),
           "flags": len(doc.get("flags", []))}
    dp = c.get("decisionPoints")
    if isinstance(dp, int) and dp != rep["decisions"]:
        issues.append(Issue("warning", "decision-count",
                            f"content.json decisionPoints={dp}, grafikte {rep['decisions']} karar düğümü"))
    return issues, rep


def check_translation(ep_dir: Path) -> tuple[list[Issue], dict | None]:
    """ceviri.tr.json denetimi (H-046): her altyazı ipucunun Türkçesi ve her kelimenin (özel ad hariç)
    anlamı olmalı. Kart, karar repliği ve görev kökü için eksikler uyarıdır."""
    if not (ep_dir / TRANSLATION_FILE).exists():
        return [Issue("warning", "translation", f"çeviri yok ({TRANSLATION_FILE})")], None
    try:
        tr = Translation.load(ep_dir)
    except (json.JSONDecodeError, OSError) as e:
        return [Issue("error", "translation", f"{TRANSLATION_FILE} okunamadı: {e}")], None
    issues = []
    if tr.status != "APPROVED":
        issues.append(Issue("warning", "translation", f"çeviri durumu {tr.status} (editör onayı bekliyor, H-028)"))
    for k in tr.duplicates:
        issues.append(Issue("warning", "translation", f"aynı İngilizce metne iki farklı Türkçe: \"{k}\""))
    if not (ep_dir / KURGU_FILE).exists():
        return issues, {"lines": len(tr.lines), "status": tr.status}
    try:
        _, b = build_dry(ep_dir)
    except (BuildError, FileNotFoundError, KeyError) as e:
        issues.append(Issue("error", "translation", f"çeviri denetimi için kuru derleme yapılamadı: {e}"))
        return issues, None
    cues = [c for s in b.subs.values() for c in s["cues"]]
    for m in b.tr_misses:
        if m.kind == "line":
            msg = f"{m.where}: çeviri satırı yok: \"{m.text}\""
        elif m.kind == "word":
            msg = f"{m.where}: \"{m.detail}\" kelimesinin anlamı yok (\"{m.text}\")"
        else:
            msg = f"{m.where}: kalıp cümlede bulunamadı: \"{m.detail}\""
        issues.append(Issue("error" if m.required and m.kind != "chunk" else "warning", "translation", msg))
    rep = {"lines": len(tr.lines), "status": tr.status, "cues": len(cues),
           "cuesTranslated": sum(1 for c in cues if c.get("tr")),
           "words": sum(len(c["words"]) for c in cues),
           "wordsNeedingGloss": len(need := [w for c in cues for w in c["words"]
                                             if tr.needs_gloss(word_key(w["w"]))]),
           "wordsGlossed": sum(1 for w in need if w.get("gloss")),
           "chunks": sum(len(c.get("chunks", [])) for c in cues)}
    return issues, rep


def _check_package_files(pkg: Path, doc: dict) -> list[Issue]:
    refs = set()
    for n in doc.get("nodes", []):
        for k in ("video", "subtitles", "audio", "background", "poster"):
            if isinstance(n.get(k), str):
                refs.add(n[k])
        for o in n.get("options", []):
            if o.get("audio"):
                refs.add(o["audio"])
        for it in n.get("items", []):
            for o in it.get("options", []):
                if o.get("audio"):
                    refs.add(o["audio"])
        for b in (n.get("bubble"), (n.get("feedback") or {}).get("wrong"), n.get("cue")):
            if b and b.get("audio"):
                refs.add(b["audio"])
    return [Issue("error", "missing-file", f"pakette dosya yok: {r}") for r in sorted(refs) if not (pkg / r).exists()]


def _check_season_files(ep_dir: Path, doc: dict) -> list[Issue]:
    """Başlık ekranının arka planı sezon paketinde (/packages/_season/S<n>/) var mı (H-050)."""
    out = []
    for n in doc.get("nodes", []):
        if n.get("type") != "title":
            continue
        src = SeasonSource.load(ep_dir.parent, int(n.get("season", 1)))
        for key in ("seasonVideo", "seasonPoster"):
            if not n.get(key):
                continue
            f = src.package_dir(ep_dir.parent) / str(n[key])
            if not f.exists():
                out.append(Issue("warning", "season-missing",
                                 f"sezon paketinde başlık dosyası yok: {f} (export_package.py sezon paketini üretir)"))
    return out


def lint_episode(ep_dir: Path, graph_source: str = "auto") -> EpisodeReport:
    ep_dir = Path(ep_dir)
    rep = EpisodeReport(ep_dir)
    cp = ep_dir / "content.json"
    if not cp.exists():
        rep.issues.append(Issue("error", "content", "content.json yok"))
        return rep
    try:
        c = json.loads(cp.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        rep.issues.append(Issue("error", "content", f"content.json geçersiz JSON: {e}"))
        return rep
    rep.content_id, rep.level = c.get("contentId", "?"), c.get("level", "?")
    rep.issues += check_links(c)
    li, rep.coverage = check_language(ep_dir, c)
    rep.issues += li
    gi, rep.graph = check_graph(ep_dir, c, graph_source)
    rep.issues += gi
    ti, rep.translation = check_translation(ep_dir)
    rep.issues += ti
    return rep


def _qid(a: str) -> tuple[str, str]:
    q, _, mod = a.partition(":")
    return q.strip(), mod.strip()


def is_episode_question(q: str) -> bool:
    """Bölüm sorusu (Q1, Q2…). Sezon (S1-Q) ve seri (SQ0) soruları kural dışı (§4.3)."""
    return bool(re.fullmatch(r"Q\d+", q))


def check_chain(contents: list[dict]) -> list[Issue]:
    """Açılan bölüm sorusu en geç 3 bölümde kapanır; aynı anda en fazla 2 bölüm sorusu açık."""
    issues = []
    eps = sorted(contents, key=lambda c: (c.get("season", 0), c.get("episode", 0)))
    by_num = {c.get("episode"): c for c in eps}
    open_q: dict[str, int] = {}
    for c in eps:
        n = c.get("episode")
        for a in c.get("answers", []):
            q, mod = _qid(a)
            if mod != "partial":
                open_q.pop(q, None)
        q = c.get("openQuestion")
        if q and is_episode_question(q):
            open_q[q] = n
            window = [n + k for k in range(1, QUESTION_WINDOW + 1)]
            if all(w in by_num for w in window):
                closed = any(_qid(a) == (q, "") for w in window for a in by_num[w].get("answers", []))
                if not closed:
                    issues.append(Issue("error", "chain",
                                        f"{c.get('contentId')}: {q} en geç {QUESTION_WINDOW} bölümde kapanmıyor"))
        if len(open_q) > MAX_OPEN_EPISODE_QUESTIONS:
            issues.append(Issue("error", "chain",
                                f"{c.get('contentId')} sonrası açık bölüm sorusu {len(open_q)}: {sorted(open_q)} "
                                f"(en fazla {MAX_OPEN_EPISODE_QUESTIONS})"))
    return issues
