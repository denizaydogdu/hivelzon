"""grammar-lint: dilbilgisi dersi denetimi (H-077; docs/DILBILGISI.md §4, §5, §9).

Denetimler:
- `lesson.json` şeması; kimlik, klasör adı ve seviye uyumu; zorunlu dosyalar; önkoşullar ve `linksTo`.
- Kart sırası (hook → explain… → examples → contrast → practice → seeInStory → rule) ve zorunlu kartlar.
- Türkçe anlatım: kancada, anlatımda, karşılaştırmada ve kuralda zorunlu; anlatım kartında en çok 3 cümle,
  diğer kartlarda 4 (uyarı); cümle en çok 20 kelime (15 üstü uyarı). Türkçe anlatımda İngilizce kelime ya da
  `-s` gibi ek gösterimi uyarıdır (Alania yanlış okur: İngilizce örnek parçasına taşı ya da söyleniş sözlüğüne yaz).
- Örnekler: örnek kartında 3–5 örnek; her örneğin Türkçesi ve [[ ]] ile işaretli hedefi.
- Kapsama (K-07, bölüm ve kitapla aynı kural): İngilizce örnekler ve alıştırmalar, dersin seviyesine göre.
- Alıştırma: 3–5 soru; cevap anahtarı geçerli (seç: tek doğru; boşluk: tek ___ ve cevap; sırala: aynı
  kelimeler; söyle: metin). Yanlış cevap açıklaması yoksa uyarı.
- "Hikâyede gör" bağları gerçek bölüm altyazı satırına ya da kitap cümlesine birebir çözülmeli.
- Ses: hizalama metinle uyuşmalı (textSha256 ve karakterler; hata); ses ya da hizalama yoksa uyarı.
- Öğretmen kontrolü (`teacherReview`) APPROVED ve sonrası için zorunlu.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass, field
from pathlib import Path

from .align import Alignment, AlignmentMismatch, sentence_timings
from .cefr import LEVELS, NO_LIST_MSG, coverage, has_extra_list
from .graph import Issue, schema_errors
from .lesson import (BLANK, CARD_TYPES, LESSON_FILE, CARDS_FILE, PROMPTS_FILE, REQUIRED_CARDS, REPEATABLE_CARDS,
                     REVIEW_REQUIRED, RIGHTS_FILE, ID_RE, Lesson, LessonError, english_in_turkish, known_lessons,
                     text_sha256, tr_words)
from .lint import MAX_SENTENCE_WORDS, coverage_issues
from .storylinks import StoryIndex

EXAMPLES_MIN, EXAMPLES_MAX = 3, 5
PRACTICE_MIN, PRACTICE_MAX = 3, 5
MAX_EXPLAIN_SENTENCES = 3
MAX_CARD_SENTENCES = 4
MAX_TR_WORDS = 20
SOFT_TR_WORDS = 15
NARRATION_REQUIRED = ("hook", "explain", "contrast", "rule")


@dataclass
class LessonReport:
    path: Path
    lesson_id: str = "?"
    level: str = "?"
    issues: list[Issue] = field(default_factory=list)
    stats: dict = field(default_factory=dict)
    coverage: dict | None = None
    links: list[dict] = field(default_factory=list)

    @property
    def errors(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "error"]

    @property
    def warnings(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "warning"]

    def to_dict(self) -> dict:
        return {"path": str(self.path), "lessonId": self.lesson_id, "level": self.level, "stats": self.stats,
                "coverage": self.coverage, "links": self.links,
                "errors": [str(i) for i in self.errors], "warnings": [str(i) for i in self.warnings]}


def _check_meta(lesson: Lesson, root: Path, index: StoryIndex) -> list[Issue]:
    out = []
    m = lesson.meta
    for e in schema_errors(m, "lesson.schema.json"):
        out.append(Issue("error", "lesson-schema", f"{LESSON_FILE}: {e}"))
    name = lesson.dir.name
    if not ID_RE.match(name):
        out.append(Issue("error", "lesson-id", f"klasör adı `G-<SEVİYE>-<2 hane>-<kisa-ad>` olmalı: {name}"))
    if m.get("id") and m["id"] != name:
        out.append(Issue("error", "lesson-id", f"klasör adı kimlikle aynı olmalı: {name} / {m['id']}"))
    if m.get("id") and m.get("level") and not str(m["id"]).startswith(f"G-{m['level']}-"):
        out.append(Issue("error", "lesson-id", f"kimlik seviyeyle başlamalı: {m['id']} / {m['level']}"))
    t = lesson.text.title
    if t is not None and m.get("id") and t != m["id"]:
        out.append(Issue("error", "lesson-id", f"{CARDS_FILE} başlığı kimlikle aynı olmalı: {t!r} / {m['id']!r}"))
    for f in (CARDS_FILE, RIGHTS_FILE, PROMPTS_FILE):
        if not (lesson.dir / f).exists():
            out.append(Issue("error", "lesson-files", f"zorunlu dosya yok: {f}"))
    if m.get("status") in REVIEW_REQUIRED:
        tr = m.get("teacherReview")
        if not (isinstance(tr, dict) and tr.get("by") and tr.get("at")):
            out.append(Issue("error", "teacher-review",
                             f"durum {m['status']}: öğretmen ya da editör kontrolü (`teacherReview` by/at) zorunlu "
                             "(DILBILGISI §5: yayın şartı)"))
    known = known_lessons(root)
    for p in m.get("prerequisites", []) or []:
        if p == m.get("id"):
            out.append(Issue("error", "prerequisite", f"ders kendisine önkoşul olamaz: {p}"))
        elif isinstance(p, str) and p not in known:
            out.append(Issue("warning", "prerequisite", f"önkoşul ders henüz yok: {p}"))
    links = m.get("linksTo") or {}
    for ep in links.get("episodes", []) or []:
        if ep not in index.episodes():
            out.append(Issue("error", "links-to", f"`linksTo.episodes`: bölüm bulunamadı: {ep}"))
    for bk in links.get("books", []) or []:
        if bk not in index.books():
            out.append(Issue("error", "links-to", f"`linksTo.books`: kitap bulunamadı: {bk}"))
    return out


def _check_cards(lesson: Lesson) -> list[Issue]:
    out = [Issue("error", "lesson-text", f"{CARDS_FILE}: {e}") for e in lesson.text.errors]
    cards = [c for c in lesson.cards if c.type in CARD_TYPES]
    types = [c.type for c in cards]
    for t in REQUIRED_CARDS:
        if t not in types:
            out.append(Issue("error", "card-missing", f"zorunlu kart yok: {t}"))
    if "seeInStory" not in types:
        out.append(Issue("warning", "card-missing", "\"Hikâyede gör\" kartı (seeInStory) yok"))
    for t in set(types):
        if t not in REPEATABLE_CARDS and types.count(t) > 1:
            out.append(Issue("error", "card-order", f"`{t}` kartı bir kez olur ({types.count(t)} kez var)"))
    order = [CARD_TYPES.index(t) for t in types]
    for a, b, ca, cb in zip(order, order[1:], cards, cards[1:]):
        if b < a:
            out.append(Issue("error", "card-order", f"kart sırası: {cb.id} `{cb.type}`, {ca.id} `{ca.type}`'tan sonra "
                                                    f"gelemez (sıra: {' → '.join(CARD_TYPES)})"))
            break
    for c in cards:
        where = f"{c.id} ({c.type})"
        sents = c.sentences
        if c.type in NARRATION_REQUIRED and not sents:
            out.append(Issue("error", "narration", f"{where}: Türkçe anlatım yok"))
        lim = MAX_EXPLAIN_SENTENCES if c.type == "explain" else MAX_CARD_SENTENCES
        if len(sents) > lim:
            out.append(Issue("error" if c.type == "explain" else "warning", "narration-length",
                             f"{where}: {len(sents)} cümle (en çok {lim})"))
        for s in sents:
            n = len(tr_words(s))
            if n > MAX_TR_WORDS:
                out.append(Issue("error", "narration-length", f"{where}: cümle {n} kelime (en çok {MAX_TR_WORDS}): \"{s}\""))
            elif n > SOFT_TR_WORDS:
                out.append(Issue("warning", "narration-length", f"{where}: uzun cümle ({n} kelime; {SOFT_TR_WORDS} önerilir): \"{s}\""))
        if c.paragraphs:
            en = english_in_turkish(c.narration, lesson.pronunciations)
            if en:
                out.append(Issue("warning", "narration-english",
                                 f"{where}: Türkçe anlatımda İngilizce kelime ya da ek: {', '.join(en)} "
                                 "(Alania Türkçe okur: İngilizce örnek parçasına (+) taşı ya da `pronunciations`'a yaz)"))
        for e in c.examples:
            if not e.en.strip():
                out.append(Issue("error", "example", f"{e.id}: İngilizce metin boş (satır {e.line})"))
                continue
            if "[[" in e.en or "]]" in e.en or e.marked.count("[[") != e.marked.count("]]"):
                out.append(Issue("error", "example", f"{e.id}: [[ ]] işareti hatalı: {e.marked!r}"))
            if e.wrong:
                continue
            if not e.tr:
                out.append(Issue("error", "example-tr", f"{e.id}: Türkçe karşılık yok (`+ EN | TR`): {e.en!r}"))
            if c.type in ("examples", "rule", "contrast") and not e.targets:
                out.append(Issue("error", "example-target", f"{e.id}: hedef yapı [[ ]] ile işaretlenmemiş: {e.en!r}"))
        if c.type == "examples":
            n = len(c.right)
            if not EXAMPLES_MIN <= n <= EXAMPLES_MAX:
                out.append(Issue("error", "example-count", f"{where}: {n} örnek ({EXAMPLES_MIN}–{EXAMPLES_MAX} olmalı)"))
        if c.type == "hook":
            if not c.links:
                out.append(Issue("warning", "hook", f"{where}: kanca hikâyeden ya da kitaptan gerçek bir cümle ister (`- episode|book …`)"))
            if not c.right:
                out.append(Issue("warning", "hook", f"{where}: kanca cümlesinin sesli örneği (+) yok"))
        if c.type == "contrast":
            if not c.wrong:
                out.append(Issue("warning", "contrast", f"{where}: tipik hata (`x …`) yok"))
            if not c.right:
                out.append(Issue("warning", "contrast", f"{where}: doğru biçim (`+ … | …`) yok"))
        if c.type == "rule" and not c.right:
            out.append(Issue("error", "rule", f"{where}: kural kartı bir örnek ve Türkçesini ister (`+ EN | TR`)"))
        if c.type == "seeInStory" and not c.links:
            out.append(Issue("error", "see-in-story", f"{where}: bağ yok (`- episode …` ya da `- book …`)"))
        if c.practice and c.type != "practice":
            out.append(Issue("error", "practice", f"{where}: alıştırma (?) yalnız practice kartında olur"))
        if c.type == "practice":
            n = len(c.practice)
            if not PRACTICE_MIN <= n <= PRACTICE_MAX:
                out.append(Issue("error", "practice-count", f"{where}: {n} soru ({PRACTICE_MIN}–{PRACTICE_MAX} olmalı)"))
            for p in c.practice:
                out += _check_practice(p)
    return out


_PUNCT = re.compile(r"[.,!?;:\"“”]")


def _words(s: str) -> list[str]:
    return [w.lower() for w in _PUNCT.sub(" ", s.replace("’", "'")).split()]


def _check_practice(p) -> list[Issue]:
    out = []
    k = f"{p.id} ({p.kind}, satır {p.line})"
    if p.kind == "choose":
        if p.stem.count(BLANK) != 1:
            out.append(Issue("error", "answer-key", f"{k}: soru metninde tek bir {BLANK} olmalı"))
        if len(p.options) < 2:
            out.append(Issue("error", "answer-key", f"{k}: en az 2 seçenek"))
        if len(p.correct) != 1:
            out.append(Issue("error", "answer-key", f"{k}: tam olarak bir doğru seçenek (*) olmalı; {len(p.correct)} var"))
        if any(not o for o in p.options):
            out.append(Issue("error", "answer-key", f"{k}: boş seçenek"))
        if len({o.lower() for o in p.options}) != len(p.options):
            out.append(Issue("error", "answer-key", f"{k}: seçenekler tekrar ediyor"))
    elif p.kind == "fill":
        if p.stem.count(BLANK) != 1:
            out.append(Issue("error", "answer-key", f"{k}: soru metninde tek bir {BLANK} olmalı"))
        if not p.answers:
            out.append(Issue("error", "answer-key", f"{k}: cevap yok (`? fill | metin ___ | cevap`)"))
    elif p.kind == "order":
        if len(p.tokens) < 2:
            out.append(Issue("error", "answer-key", f"{k}: en az 2 parça (`a / b / c`)"))
        if len(p.answers) != 1:
            out.append(Issue("error", "answer-key", f"{k}: tek cevap cümlesi olmalı"))
        else:
            if sorted(_words(" ".join(p.tokens))) != sorted(_words(p.answers[0])):
                out.append(Issue("error", "answer-key", f"{k}: parçalar cevapla aynı kelimeleri taşımıyor: "
                                                        f"{p.tokens} / {p.answers[0]!r}"))
            elif _words(" ".join(p.tokens)) == _words(p.answers[0]):
                out.append(Issue("warning", "answer-key", f"{k}: parçalar zaten doğru sırada"))
    elif p.kind == "say":
        if not p.stem.strip():
            out.append(Issue("error", "answer-key", f"{k}: söylenecek cümle yok"))
    if p.kind in ("choose", "fill", "order") and not p.feedback:
        out.append(Issue("warning", "practice-feedback", f"{k}: yanlış cevap için kısa Türkçe açıklama (`! …`) yok"))
    return out


def _check_language(lesson: Lesson) -> tuple[list[Issue], dict | None]:
    level = lesson.level
    texts = lesson.english_texts()
    if level not in LEVELS:
        return [Issue("error", "coverage", f"bilinmeyen seviye: {level} (A1–C2)")], None
    if not texts:
        return [Issue("error", "coverage", "İngilizce örnek yok")], None
    if not has_extra_list(level):
        return [Issue("warning", "coverage", f"{level}: Octanove C1/C2 {NO_LIST_MSG}")], None
    max_words = MAX_SENTENCE_WORDS.get(level, 10_000)
    proper = set()
    for p in lesson.meta.get("properNouns", []) or []:
        proper.update(w.lower() for w in re.findall(r"[A-Za-z']+", p))
    cov = coverage(texts, level, gloss=lesson.meta.get("glossary", []) or [], proper=proper, max_words=max_words)
    issues, rep = coverage_issues(cov, level, max_words)
    rep["texts"] = len(texts)
    return issues, rep


def _check_links(lesson: Lesson, index: StoryIndex) -> tuple[list[Issue], list[dict]]:
    out, resolved = [], []
    lt = lesson.meta.get("linksTo") or {}
    declared = {"episode": set(lt.get("episodes", []) or []), "book": set(lt.get("books", []) or [])}
    for c in lesson.cards:
        for ln in c.links:
            r = index.resolve(ln.kind, ln.target, ln.text, ln.hint)
            if r.error:
                out.append(Issue("error", "story-link", f"{c.id} satır {ln.line}: {r.error}"))
                continue
            for w in r.warnings:
                out.append(Issue("warning", "story-link", f"{c.id} satır {ln.line}: {w}"))
            if ln.target not in declared[ln.kind]:
                out.append(Issue("warning", "story-link", f"{c.id}: {ln.target} `linksTo` içinde yok"))
            resolved.append({"card": c.id, **r.target})
    return out, resolved


def _check_audio(lesson: Lesson) -> tuple[list[Issue], dict]:
    issues: list[Issue] = []
    st = {"trSegments": 0, "trAligned": 0, "trAudio": 0, "enSegments": 0, "enAligned": 0, "enAudio": 0}
    cards = {c.id: c for c in lesson.cards}
    jobs = [("tr", s.id, s.text, cards[s.id[:-3]].sentences, *lesson.tr_paths(s.id)) for s in lesson.tr_segments()]
    jobs += [("en", s.id, s.text, [s.text], *lesson.en_paths(s.id)) for s in lesson.en_segments()]
    for lang, sid, text, sents, mp3, aj in jobs:
        st[f"{lang}Segments"] += 1
        rel = aj.relative_to(lesson.dir)
        if not aj.exists():
            issues.append(Issue("warning", "lesson-audio", f"{sid}: hizalama yok ({rel}); ses henüz üretilmedi (tts_lesson.py)"))
            continue
        try:
            doc = json.loads(aj.read_text(encoding="utf-8"))
            sha = doc.get("textSha256")
            if sha and sha != text_sha256(text):
                issues.append(Issue("error", "lesson-align", f"{sid}: hizalama başka bir metinden (textSha256 farklı); "
                                                             "metin TTS'ten sonra değişti: tts_lesson.py ile yeniden üret"))
                continue
            sentence_timings(Alignment.load(aj), sents)
        except AlignmentMismatch as e:
            issues.append(Issue("error", "lesson-align", f"{sid}: {e} (tts_lesson.py ile yeniden üret)"))
            continue
        except (OSError, ValueError, KeyError) as e:
            issues.append(Issue("error", "lesson-align", f"{sid}: hizalama okunamadı: {e}"))
            continue
        st[f"{lang}Aligned"] += 1
        q = doc.get("quality")
        if lang == "tr" and isinstance(q, dict) and q.get("ok") is False:
            issues.append(Issue("warning", "lesson-align", f"{sid}: Duyu eşleşmesi zayıf (skor {q.get('score')}); "
                                                           "parça dinlenmeden kullanılmaz"))
        if mp3.exists():
            st[f"{lang}Audio"] += 1
        else:
            issues.append(Issue("warning", "lesson-media", f"{sid}: ses dosyası bu ortamda yok (git dışı medya): "
                                                           f"{mp3.relative_to(lesson.dir)}"))
    return issues, st


def lint_lesson(lesson_dir: Path, grammar_root: Path | None = None, icerik_root: Path | None = None,
                books_root: Path | None = None) -> LessonReport:
    rep = LessonReport(Path(lesson_dir))
    try:
        lesson = Lesson.load(lesson_dir)
    except LessonError as e:
        rep.issues.append(Issue("error", "lesson", str(e)))
        return rep
    root = Path(grammar_root) if grammar_root else lesson.dir.parent
    index = StoryIndex(icerik_root, books_root)
    rep.lesson_id, rep.level = lesson.id, lesson.level
    rep.issues += _check_meta(lesson, root, index)
    rep.issues += _check_cards(lesson)
    li, rep.coverage = _check_language(lesson)
    rep.issues += li
    lk, rep.links = _check_links(lesson, index)
    rep.issues += lk
    ai, audio = _check_audio(lesson)
    rep.issues += ai
    rep.stats = {"cards": len(lesson.cards), "examples": sum(len(c.right) for c in lesson.cards),
                 "practice": sum(len(c.practice) for c in lesson.cards), "links": len(rep.links),
                 "narrationChars": sum(len(s.text) for s in lesson.tr_segments()),
                 "exampleChars": sum(len(s.text) for s in lesson.en_segments()), "audio": audio}
    return rep
