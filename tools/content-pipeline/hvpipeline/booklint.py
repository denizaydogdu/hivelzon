"""book-lint: Kitaplık kitabı denetimi (H-066; docs/KITAPLIK.md §4–§6).

Denetimler:
- `book.json` şeması; kimlik, klasör adı ve seviye uyumu.
- `text.en.md` işaretleri; bölüm ve sayfa listesinin `book.json` ile birebir aynı olması; boş sayfa yok.
- Kapsama (K-07, bölümlerle aynı kural): ≥ %98 hedef, %95 alt sınır yalnızca sözlükle.
  A1–B2 kümülatif CEFR-J; C1/C2 CEFR-J + Octanove C1/C2 (ayrı CC BY-SA dosyası). Dosya yoksa uyarı:
  "liste yok; kapsama denetlenmedi".
- Cümle uzunluğu (A1 ≤ 8, A2 ≤ 12), kelime sayısı seviye hedefi ± %20.
- Sözlük: her girdinin Türkçesi (hata), örnek cümlesi (uyarı), metinde geçmesi (uyarı).
- Çeviri (`ceviri.tr.json`): durum, her cümlenin Türkçesi ve özel ad dışındaki her kelimenin anlamı.
- Ses: hizalama metinle uyuşuyor mu (hata), ses/hizalama var mı ve anlatım hızı (uyarı; git dışı medya).
  Hız, dışa aktarmadaki anlatım temposundan (pacing.py, H-069) SONRAKİ etkin hızdır; ham hız da raporlanır.
- Görsel: `book.json`'da adı geçen görsel bu ortamda var mı (uyarı; git dışı medya).
- `grammarTopics` (isteğe bağlı, H-077): dilbilgisi dersi kimlikleri; ders klasöründe ders varsa bulunmalı
  (hata), hiç ders yoksa uyarı.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path

from . import pacing
from .align import Alignment, AlignmentMismatch, sentence_timings
from .book import (BOOK_FILE, BOOK_LEVELS, DIR_RE, PROMPTS_FILE, RIGHTS_FILE, TEXT_FILE, GLOSSARY_FILE,
                   WORD_TOLERANCE, Book, BookError, text_sha256)
from .cefr import LEVELS, NO_LIST_MSG, coverage, has_extra_list, sentences
from .graph import Issue, schema_errors
from .lesson import check_grammar_topics
from .lint import MAX_SENTENCE_WORDS, coverage_issues
from .translation import TRANSLATION_FILE, Miss, Translation, norm_text, word_key


@dataclass
class BookReport:
    path: Path
    book_id: str = "?"
    level: str = "?"
    issues: list[Issue] = field(default_factory=list)
    stats: dict = field(default_factory=dict)
    coverage: dict | None = None
    translation: dict | None = None

    @property
    def errors(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "error"]

    @property
    def warnings(self) -> list[Issue]:
        return [i for i in self.issues if i.level == "warning"]

    def to_dict(self) -> dict:
        return {"path": str(self.path), "bookId": self.book_id, "level": self.level, "stats": self.stats,
                "coverage": self.coverage, "translation": self.translation,
                "errors": [str(i) for i in self.errors], "warnings": [str(i) for i in self.warnings]}


def word_count(texts: list[str]) -> int:
    return sum(len(s) for t in texts for s in sentences(t))


def annotate(tr: Translation, text: str, words: list[str], where: str, misses: list[Miss]):
    """Cümle → (tr, kelime anlamları, kalıplar); bölüm altyazısıyla aynı kural (zorunlu)."""
    return tr._annotate(text, words, where, misses, True)


def load_translation(book: Book) -> Translation | None:
    tr = Translation.load(book.dir)
    if tr is not None:
        tr.proper = frozenset(set(tr.proper) | book.proper_nouns)
    return tr


def _check_structure(book: Book) -> list[Issue]:
    out = []
    m = book.meta
    for e in schema_errors(m, "book.schema.json"):
        out.append(Issue("error", "book-schema", f"{BOOK_FILE}: {e}"))
    name = book.dir.name
    if not DIR_RE.match(name):
        out.append(Issue("error", "book-id", f"klasör adı `<SEVİYE>-K<NN>-<kisa-baslik>` olmalı: {name}"))
    if m.get("id") and not name.startswith(f"{m['id']}-"):
        out.append(Issue("error", "book-id", f"klasör adı kimlikle başlamalı: {name} / {m.get('id')}"))
    if m.get("slug") and m["slug"] != name:
        out.append(Issue("error", "book-id", f"slug klasör adıyla aynı olmalı: {m['slug']} / {name}"))
    if m.get("id") and m.get("level") and not str(m["id"]).startswith(m["level"] + "-"):
        out.append(Issue("error", "book-id", f"kimlik seviyeyle başlamalı: {m['id']} / {m['level']}"))
    for f in (TEXT_FILE, GLOSSARY_FILE, RIGHTS_FILE, PROMPTS_FILE):
        if not (book.dir / f).exists():
            out.append(Issue("error", "book-files", f"zorunlu dosya yok: {f}"))
    t = book.text
    for e in t.errors:
        out.append(Issue("error", "book-text", f"{TEXT_FILE}: {e}"))
    if t.title is not None and m.get("title") and norm_text(t.title) != norm_text(m["title"]):
        out.append(Issue("error", "book-text", f"{TEXT_FILE} başlığı book.json ile farklı: {t.title!r} / {m['title']!r}"))
    # bölüm ve sayfa listesi birebir aynı
    meta_ch = [(c.get("id"), c.get("title"), [p.get("id") for p in c.get("pages", []) if isinstance(p, dict)])
               for c in book.chapter_meta() if isinstance(c, dict)]
    text_ch = [(c.id, c.title, [p.id for p in c.pages]) for c in t.chapters]
    if [c[0] for c in meta_ch] != [c[0] for c in text_ch]:
        out.append(Issue("error", "book-structure", f"bölümler book.json'da {[c[0] for c in meta_ch]}, "
                                                    f"{TEXT_FILE}'de {[c[0] for c in text_ch]}"))
    for (mid, mtitle, mpages), (tid, ttitle, tpages) in zip(meta_ch, text_ch):
        if mid != tid:
            continue
        if mtitle and norm_text(mtitle) != norm_text(ttitle):
            out.append(Issue("error", "book-structure", f"{mid} başlığı farklı: book.json {mtitle!r}, metin {ttitle!r}"))
        if mpages != tpages:
            out.append(Issue("error", "book-structure", f"{mid} sayfaları book.json'da {mpages}, {TEXT_FILE}'de {tpages}"))
    seen = set()
    for p in t.pages:
        if p.id in seen:
            out.append(Issue("error", "book-structure", f"sayfa kimliği iki kez geçiyor: {p.id}"))
        seen.add(p.id)
        if not p.sentences:
            out.append(Issue("error", "book-page-empty", f"{p.id}: sayfada metin yok"))
    lv = BOOK_LEVELS.get(m.get("level"))
    if lv and t.chapters:
        lo, hi = lv["pages"]
        if not lo <= len(t.pages) <= hi:
            out.append(Issue("warning", "book-length", f"{m['level']} için sayfa {lo}–{hi} önerilir; kitapta {len(t.pages)}"))
        lo, hi = lv["chapters"]
        if not lo <= len(t.chapters) <= hi:
            out.append(Issue("warning", "book-length", f"{m['level']} için bölüm {lo}–{hi} önerilir; kitapta {len(t.chapters)}"))
    return out


def _check_language(book: Book, word_targets: dict | None) -> tuple[list[Issue], dict | None, dict]:
    level = book.level
    texts = book.text.texts()
    stats = {"chapters": len(book.text.chapters), "pages": len(book.text.pages),
             "sentences": len(book.text.sentences()), "words": word_count(texts)}
    issues: list[Issue] = []
    if level not in LEVELS:
        return [Issue("error", "coverage", f"bilinmeyen seviye: {level} (A1–C2)")], None, stats
    target = (word_targets or {}).get(level, BOOK_LEVELS[level]["words"])
    lo, hi = round(target * (1 - WORD_TOLERANCE)), round(target * (1 + WORD_TOLERANCE))
    stats["wordTarget"] = [lo, hi]
    if not lo <= stats["words"] <= hi:
        issues.append(Issue("error", "book-words",
                            f"{level} kitap ~{target} kelime (± %{WORD_TOLERANCE * 100:.0f}: {lo}–{hi}); kitapta {stats['words']}"))
    if not has_extra_list(level):
        issues.append(Issue("warning", "coverage", f"{level}: Octanove C1/C2 {NO_LIST_MSG}"))
        return issues, None, stats
    max_words = MAX_SENTENCE_WORDS.get(level, 10_000)
    gloss = [g.en for g in book.glossary]
    cov = coverage(texts, level, gloss=gloss, proper=book.proper_nouns, max_words=max_words)
    ci, rep = coverage_issues(cov, level, max_words)
    issues += ci
    return issues, rep, stats


def _check_glossary(book: Book) -> list[Issue]:
    out = [Issue("error", "glossary", f"{GLOSSARY_FILE}: {e}") for e in book.glossary_errors]
    body = " " + " ".join(book.text.texts()).lower() + " "
    seen = set()
    for g in book.glossary:
        key = g.en.lower()
        if key in seen:
            out.append(Issue("warning", "glossary", f"sözlükte iki kez: {g.en!r}"))
        seen.add(key)
        if not g.tr:
            out.append(Issue("error", "glossary-meaning", f"sözlük girdisinin Türkçesi yok: {g.en!r} (satır {g.line})"))
        if not g.example:
            out.append(Issue("warning", "glossary-example", f"sözlük girdisinin örnek cümlesi yok: {g.en!r}"))
        if key not in body:
            out.append(Issue("warning", "glossary-unused", f"sözlük girdisi metinde geçmiyor: {g.en!r}"))
    return out


def _check_translation(book: Book) -> tuple[list[Issue], dict | None]:
    if not (book.dir / TRANSLATION_FILE).exists():
        return [Issue("warning", "translation", f"çeviri yok ({TRANSLATION_FILE})")], None
    try:
        tr = load_translation(book)
    except (json.JSONDecodeError, OSError) as e:
        return [Issue("error", "translation", f"{TRANSLATION_FILE} okunamadı: {e}")], None
    issues = []
    if tr.status != "APPROVED":
        issues.append(Issue("warning", "translation", f"çeviri durumu {tr.status} (kullanıcı/editör onayı bekliyor, H-028)"))
    for k in tr.duplicates:
        issues.append(Issue("warning", "translation", f"aynı İngilizce metne iki farklı Türkçe: \"{k}\""))
    misses: list[Miss] = []
    units = [(c.heading, c.id) for c in book.text.chapters] + [(s, s.id) for s in book.text.sentences()]
    words_total = need = glossed = 0
    for s, where in units:
        words = norm_text(s.text).split(" ")
        _, gl, _ = annotate(tr, s.text, words, where, misses)
        words_total += len(words)
        for w, g in zip(words, gl):
            if tr.needs_gloss(word_key(w)):
                need += 1
                glossed += g is not None
    for m in misses:
        if m.kind == "line":
            msg, lvl = f"{m.where}: çeviri satırı yok: \"{m.text}\"", "error"
        elif m.kind == "word":
            msg, lvl = f"{m.where}: \"{m.detail}\" kelimesinin anlamı yok (\"{m.text}\")", "error"
        else:
            msg, lvl = f"{m.where}: kalıp cümlede bulunamadı: \"{m.detail}\"", "warning"
        issues.append(Issue(lvl, "translation", msg))
    rep = {"status": tr.status, "units": len(units),
           "unitsTranslated": len(units) - sum(1 for m in misses if m.kind == "line"),
           "words": words_total, "wordsNeedingGloss": need, "wordsGlossed": glossed}
    return issues, rep


def _check_media(book: Book) -> tuple[list[Issue], dict]:
    issues: list[Issue] = []
    audio = {"chapters": len(book.text.chapters), "aligned": 0, "audio": 0, "wpm": {}, "wpmRaw": {}, "pacing": {}}
    lv = BOOK_LEVELS.get(book.level)
    try:
        cfg = pacing.settings(book.meta, book.level)
    except pacing.PacingError as e:
        issues.append(Issue("error", "book-pacing", str(e)))
        cfg = None
    for c in book.text.chapters:
        ap = book.align_path(c.id)
        if not ap.exists():
            issues.append(Issue("warning", "book-audio", f"{c.id}: hizalama yok ({ap.relative_to(book.dir)}); "
                                                         "ses henüz üretilmedi (tts_book.py)"))
            continue
        try:
            doc = json.loads(ap.read_text(encoding="utf-8"))
            al = Alignment.load(ap)
            timings = sentence_timings(al, [s.text for s in c.spoken()])
        except AlignmentMismatch as e:
            issues.append(Issue("error", "book-align", f"{c.id}: {e} (metin TTS'ten sonra değişti: sesi yeniden üret)"))
            continue
        except (OSError, ValueError, KeyError) as e:
            issues.append(Issue("error", "book-align", f"{c.id}: hizalama okunamadı: {e}"))
            continue
        audio["aligned"] += 1
        sha = doc.get("textSha256")
        if sha and sha != text_sha256(c.tts_text()):
            issues.append(Issue("warning", "book-align", f"{c.id}: hizalama başka bir metin sürümünden (textSha256 farklı; "
                                                         "cümleler yine eşleşiyor, noktalama değişmiş olabilir)"))
        if pacing.spoken(timings) and lv:
            # Etkin hız: dışa aktarmadaki anlatım temposundan sonra (H-069; plan hizalamadan, kesim yerinden bağımsız)
            plan = None
            if cfg is not None and cfg["mode"] != "off":
                plan = pacing.plan_chapter(timings, pacing.chapter_units(c), cfg, book.level,
                                           pacing.spoken(timings)[-1]["end"])
            raw = pacing.wpm(timings)
            eff = pacing.wpm(pacing.apply(timings, plan)) if plan else raw
            raw = round(raw) if raw else None
            wpm = round(eff) if eff else None
            audio["wpmRaw"][c.id] = raw
            audio["wpm"][c.id] = wpm
            audio["pacing"][c.id] = plan.describe() if plan else {"mode": cfg["mode"] if cfg else "?"}
            lo, hi = lv["wpm"]
            if wpm is not None and not (lo * 0.9 <= wpm <= hi * 1.1):
                how = (f"tempo sonrası ~{wpm} k/dk (ham ~{raw}; duraklama {plan.pause} sn, tempo {plan.tempo})"
                       if plan else f"~{wpm} k/dk (tempo işlemi yok)")
                issues.append(Issue("warning", "book-speed", f"{c.id}: anlatım hızı {how}; {book.level} için {lo}–{hi} "
                                                             "(narration.speed ya da narration.pacing ayarlanabilir)"))
        if book.audio_path(c.id).exists():
            audio["audio"] += 1
        else:
            issues.append(Issue("warning", "book-media", f"{c.id}: ses dosyası bu ortamda yok (git dışı medya): "
                                                         f"{book.audio_path(c.id).relative_to(book.dir)}"))
    images = []
    if book.meta.get("cover"):
        images.append(book.meta["cover"])
    images += [p["image"] for p in book.page_meta().values() if p.get("image")]
    missing = [n for n in images if not book.image_path(n).exists()]
    for n in missing:
        issues.append(Issue("warning", "book-media", f"görsel bu ortamda yok (git dışı medya): images/{n}"))
    audio["images"] = len(images)
    audio["imagesPresent"] = len(images) - len(missing)
    return issues, audio


def lint_book(book_dir: Path, word_targets: dict | None = None, grammar_root: Path | None = None) -> BookReport:
    rep = BookReport(Path(book_dir))
    try:
        book = Book.load(book_dir)
    except BookError as e:
        rep.issues.append(Issue("error", "book", str(e)))
        return rep
    rep.book_id, rep.level = book.id, book.level
    rep.issues += _check_structure(book)
    li, rep.coverage, rep.stats = _check_language(book, word_targets)
    rep.issues += li
    rep.issues += _check_glossary(book)
    ti, rep.translation = _check_translation(book)
    rep.issues += ti
    mi, rep.stats["media"] = _check_media(book)
    rep.issues += mi
    rep.issues += [Issue(lv, "grammar-topics", msg)
                   for lv, msg in check_grammar_topics(book.meta.get("grammarTopics"), grammar_root)]
    return rep
