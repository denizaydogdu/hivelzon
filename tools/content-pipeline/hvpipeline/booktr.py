"""Kitaplarda "Sayfanın Türkçesi"nin Alania ile sesli okunması (H-105).

Birim: **sayfa başına bir Türkçe ses.** Metin, uygulamanın "Sayfanın Türkçesi" panelinde gösterdiği
metnin aynısıdır (mobil `Book.turkishOf`, H-086): bölümün ilk sayfasında bölüm başlığının Türkçesi önce,
sonra sayfanın cümlelerinin onaylı Türkçesi sırasıyla (`ceviri.tr.json`); Türkçesi olmayan cümle atlanır.
Gerekçe: panel sayfa sayfa açılır ve tek "Türkçesini dinle" düğmesi taşır; sayfa sesi uygulamada tek
dosya çalmak demektir (bölüm sesi gibi zaman çizelgesi, sayfa çevirme ya da arka plan oturumu gerekmez).
Duyu hizalaması (`<sayfa>.align.json`) yine üretilir ve depoda tutulur: ileride okunan Türkçe cümle
vurgulanmak istenirse ek ücret gerekmez.

Dosyalar (`kitaplar/<id>/audio/tr/`): `<sayfa>.mp3` (git dışı, -16 LUFS), `<sayfa>.align.json` (depoda),
`_raw/` (ödenmiş ham WAV + Duyu; git dışı). Kayıt `<kitap>/PROMPTS.md`, defter tts_tr ile ortak.

Ses ve söyleniş `book.json` → `narrationTr` (isteğe bağlı):
    {"role": "hi", "pronunciations": [{"term": "Mrs Ada", "say_as": "Misiz Ada"}]}
Rol `icerik/_evren/sesler.json`'dan çözülür (varsayılan `hi`: Hi her yerde tek sesle konuşur, H-083).
Sözlükte yalnız Türkçe okunuşu bozulacak terimler durur; `sesler.json`'daki genel İngilizce ifade sözlüğü
**kullanılmaz** (ör. "at" → "et" Türkçe metindeki "at" kelimesini bozardı). Eşleşme büyük/küçük harfe
duyarlıdır (ör. özel ad "Ada" ile Türkçe "ada" karışmasın).

İdempotentlik tts_tr'dedir: anahtar = metin + model + ses + üslup + söyleniş; metin değişirse yeniden
üretilir, güncel olan atlanır.

**Ek Türkçe metinler (H-109 Faz 2, isteğe bağlı):** kitap sonu soruların Türkçesi
(`comprehension.questions[].promptTr`, parça kimliği soru kimliği: `q1`, `q2`) ve kitap tanıtımı (`blurbTr`,
parça `blurb`). Aynı klasöre (`audio/tr/`), aynı sesle ve sözlükle; kimlik soru kimliğidir, sıra kaymaz.
Araçta bölüm seçimi `parts`: `pages` (varsayılan; H-105), `questions`, `blurb`.
"""

from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path

from . import REPO_ROOT, tts_tr
from .book import Book
from .graph import Issue
from .translation import Translation

TR_AUDIO_DIR = "audio/tr"
DEFAULT_ROLE = "hi"
PARTS = ("pages", "questions", "blurb")
DEFAULT_PARTS = ("pages",)
BLURB_ID = "blurb"
VOICE_MAP = REPO_ROOT / "icerik" / "_evren" / "sesler.json"


class BookTrError(ValueError):
    pass


@dataclass
class PageTr:
    page: str
    lines: list[str]

    @property
    def text(self) -> str:
        return " ".join(self.lines)


def _clean(s) -> str | None:
    t = (s or "").strip() if isinstance(s, str) else None
    return t or None


def _with_stop(s: str) -> str:
    return s if s[-1:] in ".!?…:;\"'”’)" else s + "."


def page_turkish(book: Book, tr: Translation | None = None) -> list[PageTr]:
    """Sayfa sırasıyla sayfanın Türkçesi (yalnız Türkçesi olan sayfalar). Mobil `turkishOf` ile aynı kural.
    Başlığın sonuna nokta eklenir (seste kısa durak)."""
    if tr is None:
        tr = Translation.load(book.dir)
    if tr is None:
        return []
    out: list[PageTr] = []
    for c in book.text.chapters:
        for k, p in enumerate(c.pages):
            lines = []
            if k == 0:
                h = _clean((tr.find(c.title) or {}).get("tr"))
                if h:
                    lines.append(_with_stop(h))
            for s in p.sentences:
                t = _clean((tr.find(s.text) or {}).get("tr"))
                if t:
                    lines.append(t)
            if lines:
                out.append(PageTr(p.id, lines))
    return out


def extra_turkish(book: Book, parts=("questions", "blurb")) -> list[PageTr]:
    """H-109 Faz 2: kitap sonu soruların Türkçesi (soru kimliğiyle) ve tanıtım (`blurb`). Metin uygulamada
    gösterilenin aynısıdır; boş/eksik alan atlanır. Kimlik soru kimliğidir (q1, q2): sıra değişse de kaymaz."""
    out: list[PageTr] = []
    if "questions" in parts:
        comp = book.meta.get("comprehension")
        qs = comp.get("questions") if isinstance(comp, dict) else None
        for q in qs if isinstance(qs, list) else []:
            if not isinstance(q, dict) or not isinstance(q.get("id"), str):
                continue
            t = _clean(q.get("promptTr"))
            if t:
                out.append(PageTr(q["id"], [t]))
    if "blurb" in parts:
        t = _clean(book.meta.get("blurbTr"))
        if t:
            out.append(PageTr(BLURB_ID, [t]))
    return out


def turkish_units(book: Book, parts=DEFAULT_PARTS) -> list[PageTr]:
    """Seçilen bölümlerin Türkçe parçaları: sayfalar (H-105) + ek metinler (H-109)."""
    bad = [p for p in parts if p not in PARTS]
    if bad:
        raise BookTrError(f"bilinmeyen bölüm: {', '.join(bad)} ({', '.join(PARTS)})")
    out = page_turkish(book) if "pages" in parts else []
    return out + extra_turkish(book, parts)


def narration_tr(book: Book) -> dict:
    n = book.meta.get("narrationTr") or {}
    return n if isinstance(n, dict) else {}


def voice_for(book: Book, voice_map: Path | None = None) -> tuple[str, str | None, str]:
    """(ses, üslup, model) — rol sesler.json'dan."""
    role = narration_tr(book).get("role") or DEFAULT_ROLE
    p = Path(voice_map or VOICE_MAP)
    d = json.loads(p.read_text(encoding="utf-8"))["turkish"]
    r = d["roles"].get(role)
    if r is None:
        raise BookTrError(f"{book.id}: narrationTr.role bilinmiyor: {role} ({p})")
    if not str(r.get("voice", "")).startswith("alania"):
        raise BookTrError(f"{book.id}: Türkçe ses Alania olmalı ({r.get('voice')})")
    return r["voice"], r.get("instructions"), d.get("model", tts_tr.TTS_MODEL)


def pron_for(text: str, prons: list[dict]) -> list[dict] | None:
    out, seen = [], set()
    for p in prons:
        term = p.get("term")
        if not term or term in seen or not p.get("say_as"):
            continue
        if re.search(rf"(?<![\w']){re.escape(term)}(?![\w])", text):
            out.append({"term": term, "say_as": p["say_as"]})
            seen.add(term)
    return out or None


def segments(book: Book, voice_map: Path | None = None, pages: list[str] | None = None,
             parts=DEFAULT_PARTS) -> list[tts_tr.Segment]:
    _, ins, _ = voice_for(book, voice_map)
    # H-118: söyleniş sözlüğü ve kurulan parçalar tts_tr ile aynı denetimden geçer (bozuk girdi ücretli
    # çağrıdan önce açık iletiyle durur; önceden sözlük dışı öğe sessizce atlanır, `term` metin değilse çökerdi).
    prons = tts_tr.check_pronunciations(narration_tr(book).get("pronunciations"), f"{book.id} narrationTr",
                                        BookTrError)
    out = []
    for pt in turkish_units(book, parts):
        if pages and pt.page not in pages:
            continue
        if len(pt.text) > tts_tr.MAX_CHARS:
            raise BookTrError(f"{book.id} {pt.page}: {len(pt.text)} karakter (istek sınırı {tts_tr.MAX_CHARS})")
        out.append(tts_tr.Segment(pt.page, pt.text, ins, pron_for(pt.text, prons)))
    try:
        return tts_tr.check_segments(out, allow_empty=True)
    except tts_tr.TrTtsError as e:
        raise BookTrError(f"{book.id}: {e}") from e


def out_dir(book: Book) -> Path:
    return book.dir / TR_AUDIO_DIR


def plan_book(book: Book, voice_map: Path | None = None, pages: list[str] | None = None,
              force: bool = False, parts=DEFAULT_PARTS) -> tts_tr.Plan:
    voice, _, model = voice_for(book, voice_map)
    return tts_tr.plan_segments(segments(book, voice_map, pages, parts), out_dir(book), voice, model, force)


# --- durum (lint ve dışa aktarma ortak) ------------------------------------------------------------

@dataclass
class PageAudio:
    page: str
    state: str          # ok | no-audio (hizalama var, mp3 bu ortamda yok) | stale | none
    align: Path
    audio: Path
    quality_ok: bool | None = None


def page_audio(book: Book, voice_map: Path | None = None, parts=DEFAULT_PARTS) -> list[PageAudio]:
    """Türkçesi olan her sayfa (ya da `parts` ile ek metin) için ses durumu. `stale`: hizalamanın anahtarı
    güncel metinle uyuşmuyor."""
    try:
        plan = plan_book(book, voice_map, parts=parts)
    except (BookTrError, OSError, KeyError, ValueError):
        return []
    out = []
    for j in plan.jobs:
        ap, mp = plan.align(j), plan.audio(j)
        if not ap.exists():
            out.append(PageAudio(j.seg.id, "none", ap, mp))
            continue
        try:
            doc = json.loads(ap.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            out.append(PageAudio(j.seg.id, "stale", ap, mp))
            continue
        q = (doc.get("quality") or {}).get("ok")
        if doc.get("key") != j.key:
            out.append(PageAudio(j.seg.id, "stale", ap, mp, q))
        elif not mp.exists():
            out.append(PageAudio(j.seg.id, "no-audio", ap, mp, q))
        else:
            out.append(PageAudio(j.seg.id, "ok", ap, mp, q))
    return out


def check_book(book: Book, voice_map: Path | None = None) -> tuple[list[Issue], dict]:
    """book-lint: Türkçe sayfa sesi isteğe bağlıdır. Hiç üretilmemiş kitap sorun değildir; üretilmiş seste
    metin değiştiyse (eskimiş) ya da hizalaması olan sesin dosyası yoksa uyarı. Sahipsiz dosya uyarı.
    Ek metinler (kitap sonu sorular, tanıtım; H-109) aynı kurallarla `extra` istatistiğinde."""
    issues: list[Issue] = []
    try:
        voice_for(book, voice_map)
        segments(book, voice_map, parts=PARTS)   # H-118: bozuk söyleniş sözlüğü / parça lint hatası olur
    except (BookTrError, OSError, KeyError, ValueError) as e:
        return [Issue("error", "book-tr-audio", str(e))], {}
    pa = page_audio(book, voice_map)
    ex = page_audio(book, voice_map, parts=("questions", "blurb"))
    stats = {"pages": len(pa), "aligned": sum(1 for x in pa if x.state in ("ok", "no-audio")),
             "audio": sum(1 for x in pa if x.state == "ok"), "stale": sum(1 for x in pa if x.state == "stale"),
             "extra": {"segments": len(ex), "aligned": sum(1 for x in ex if x.state in ("ok", "no-audio")),
                       "audio": sum(1 for x in ex if x.state == "ok"),
                       "stale": sum(1 for x in ex if x.state == "stale")}}
    for x in pa + ex:
        rel = x.align.relative_to(book.dir)
        if x.state == "stale":
            issues.append(Issue("warning", "book-tr-audio",
                                f"{x.page}: Türkçe ses eski metinden ({rel}); pakete girmez — "
                                "tts_book_tr.py ile yeniden üret"))
        elif x.state == "no-audio":
            issues.append(Issue("warning", "book-media", f"{x.page}: Türkçe ses bu ortamda yok (git dışı medya): "
                                                         f"{x.audio.relative_to(book.dir)}"))
        if x.state in ("ok", "no-audio") and x.quality_ok is False:
            issues.append(Issue("warning", "book-tr-align", f"{x.page}: Türkçe ses hizalaması zayıf (Duyu); "
                                                            "kulakla dinlenmeli"))
    known = {x.page for x in pa + ex}
    d = out_dir(book)
    if d.exists():
        for f in sorted(d.glob("*.align.json")):
            pid = f.name.removesuffix(".align.json")
            if pid not in known:
                issues.append(Issue("warning", "book-tr-audio",
                                    f"{pid}: Türkçe sesi var ama sayfanın, sorunun ya da tanıtımın Türkçesi yok "
                                    f"({f.relative_to(book.dir)})"))
    return issues, stats
