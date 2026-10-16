"""Konuş sekmesi görevleri (H-090): yönlendirmeli sahneler ve kısa mesaj yazma.

Kaynak: `icerik/_evren/konusma/<id>.json` (şema: schema/talk-task.schema.json; belge: docs/BOLUM-PAKETI.md §9).
İki tür vardır:

- `scene`: bir karakterle 3–5 turluk prova. Her turda karakterin İngilizce satırı (Türkçesi istenince),
  Türkçe görev cümlesi (`promptTr`), aynı anlama gelen birkaç doğal kabul edilen cevap (`accept`; ilki örnek
  cevap) ve kibar tepkili 1–2 yakın ama kabul edilmeyen seçenek (`distractors`) vardır. Yapay zekâ yok (H-007).
- `message`: 1–2 cümlelik mesaj yazma. Güvenilir hoşgörülü kural varsa (`check.all`: her grupta en az bir
  kelime ya da kalıp; `check.none`: anlamı tersine çeviren kelimeler) uygulama denetler; yoksa (`check: null`)
  örnek cevap + öz değerlendirme gösterilir. Kesin puan yok.

Görev, `unlockAfter` bölümü bitince açılır. `targets`: bölümlerin hedef ifadeleri; kullanıcı yardımsız
(seçenek görmeden) ürettiği cevapta bu ifadeyi kullanırsa uygulama "kendi kullandı" kanıtı yazar (H-089).

Ses: ücretli üretim yok. Karakter satırı bölüm kaydında **aynen** varsa (`audio_manifest.json`,
`KONUŞAN|metin`) o kayıt kesilmeden pakete alınır; yoksa uygulama cihazın İngilizce sesini kullanır.
Görseller bölüm paketinin `stills/` görselleridir (kopyalanmaz; uygulama bölüm paketinden okur).

Paket: `/packages/_season/S<n>/talk.json` (+ `talk/<görev>-<tur>.m4a`); season.json → `talk` özeti.
"""

from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path

from .cefr import CEFRJ_LEVELS as LEVELS, coverage
from .graph import Issue, schema_errors
from .sets import find_episode_dir

TALK_DIR = Path("_evren") / "konusma"
TALK_PACKAGE_FILE = "talk.json"
TALK_AUDIO_DIR = "talk"
MAX_SENTENCE_WORDS = {"A1": 8, "A2": 12}
COVERAGE_TARGET = 98.0
COVERAGE_FLOOR = 95.0


def talk_dir(icerik_root: Path) -> Path:
    return Path(icerik_root) / TALK_DIR


def load_tasks(icerik_root: Path, season: int | None = None) -> list[tuple[Path, dict]]:
    """Kaynak görevler (`order`a göre). Okunamayan dosya ValueError verir."""
    d = talk_dir(icerik_root)
    out = []
    if not d.is_dir():
        return out
    for p in sorted(d.glob("*.json")):
        try:
            doc = json.loads(p.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            raise ValueError(f"{p}: geçersiz JSON: {e}") from e
        if season is None or int(doc.get("season", 0)) == season:
            out.append((p, doc))
    out.sort(key=lambda x: (x[1].get("order", 0), x[1].get("id", "")))
    return out


# --- eşleştirme (uygulamadaki `SpeechMatcher.tokenize` ile aynı kurallar, sadeleştirilmiş) -------

_CONTR = {"can't": ["can", "not"], "cannot": ["can", "not"], "won't": ["will", "not"], "i'm": ["i", "am"],
          "let's": ["let", "us"]}
_S_IS = {"it", "he", "she", "that", "this", "there", "here", "what", "where", "who", "how", "when", "why"}
_ONES = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven",
         "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
_TENS = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
_CANON = {"here": "hear", "to": "two", "too": "two", "for": "four", "write": "right", "their": "there",
          "know": "no", "won": "one", "okay": "ok", "yeah": "yes", "turkey": "turkiye", "harbor": "harbour",
          "neighbor": "neighbour", "bye": "by", "buy": "by", "hey": "hi", "high": "hi", "meat": "meet"}


def _fold(s: str) -> str:
    s = s.replace("İ", "I").replace("ı", "i")
    return "".join(c for c in unicodedata.normalize("NFKD", s) if not unicodedata.combining(c))


def _num(n: int) -> list[str]:
    if n < 20:
        return [_ONES[n]]
    if n < 100:
        return [_TENS[n // 10]] + ([_ONES[n % 10]] if n % 10 else [])
    return [_ONES[n // 100], "hundred"] + (_num(n % 100) if n % 100 else [])


def match_tokens(text: str) -> list[str]:
    """Karşılaştırma için kelimeler: küçük harf, aksansız, kısaltmalar açık, sayılar kelimeyle, `…` atılır."""
    t = _fold(text.replace("’", "'").replace("‘", "'")).lower()
    t = re.sub(r"\b(\d{1,2}):00\b", r"\1", t)
    t = re.sub(r"[^\w'\s]", " ", t)
    out: list[str] = []
    for raw in t.split():
        w = raw.strip("'")
        if not w:
            continue
        parts: list[str]
        if w in _CONTR:
            parts = _CONTR[w]
        elif w.endswith("n't"):
            parts = [w[:-3], "not"]
        elif w.endswith("'s") and w[:-2] in _S_IS:
            parts = [w[:-2], "is"]
        else:
            parts = [w]
            for suf, full in (("'re", "are"), ("'ve", "have"), ("'ll", "will"), ("'d", "would"), ("'m", "am")):
                if w.endswith(suf) and len(w) > len(suf):
                    parts = [w[: -len(suf)], full]
                    break
            else:
                parts = [w.replace("'", "")]
        for p in parts:
            if p.isdigit() and int(p) < 1000:
                out += [_CANON.get(x, x) for x in _num(int(p))]
            elif p:
                out.append(_CANON.get(p, p))
    return out


def contains_in_order(text: str, phrase: str) -> bool:
    """[phrase]'in kelimeleri (`…` hariç) [text]'te aynı sırayla geçiyor mu (arada başka kelime olabilir)."""
    want = match_tokens(phrase)
    if not want:
        return False
    i = 0
    for w in match_tokens(text):
        if w == want[i]:
            i += 1
            if i == len(want):
                return True
    return False


def _has_phrase(tokens: list[str], phrase: str) -> bool:
    p = match_tokens(phrase)
    return bool(p) and any(tokens[i:i + len(p)] == p for i in range(len(tokens) - len(p) + 1))


def check_message(text: str, check: dict | None) -> bool | None:
    """Mesaj kuralı (uygulamadaki `MessageCheck` ile aynı): her `all` grubundan en az bir kalıp geçer ve
    `none` kelimelerinden hiçbiri yoktur. Kural yoksa None (öz değerlendirme)."""
    if not check:
        return None
    toks = match_tokens(text)
    if any(_has_phrase(toks, n) for n in check.get("none") or []):
        return False
    return all(any(_has_phrase(toks, alt) for alt in group) for group in check.get("all") or [])


# --- denetim (content-lint) -----------------------------------------------------------------

def _episode_targets(root: Path) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {}
    for c in sorted(root.glob("[A-C][12]-[0-9][0-9][0-9]-*/content.json")):
        try:
            doc = json.loads(c.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        out[c.parent.name[:6]] = list(doc.get("targetPhrases") or [])
    return out


def _episode_glossary(root: Path, upto: str) -> list[str]:
    out: list[str] = []
    for c in sorted(root.glob("[A-C][12]-[0-9][0-9][0-9]-*/content.json")):
        if c.parent.name[:6] > upto:
            continue
        try:
            doc = json.loads(c.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        for g in doc.get("glossary") or []:
            w = g.get("word") if isinstance(g, dict) else g
            if isinstance(w, str):
                out.append(w)
    return out


def manifest_audio(root: Path, speaker: str | None, en: str) -> tuple[Path, str] | None:
    """Satır bölüm kaydında aynen var mı: (bölüm klasörü, kayıt adı). Konuşan + metin birebir eşleşmeli."""
    if not speaker:
        return None
    key = f"{speaker}|{en}"
    for m in sorted(Path(root).glob("[A-C][12]-[0-9][0-9][0-9]-*/audio_manifest.json")):
        try:
            doc = json.loads(m.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        if isinstance(doc, dict) and key in doc:
            return m.parent, doc[key]
    return None


def _lines(doc: dict) -> list[tuple[str, dict]]:
    """(yer, satır): karakter satırları ve kapanış. Konuşan satırda yoksa görevin karakteri."""
    speaker = (doc.get("character") or {}).get("speaker")
    out = []
    for t in doc.get("turns") or []:
        if isinstance(t, dict) and isinstance(t.get("line"), dict):
            out.append((str(t.get("id", "?")), {"speaker": speaker, **t["line"]}))
    if isinstance(doc.get("outro"), dict):
        out.append(("outro", {"speaker": speaker, **doc["outro"]}))
    return out


def lint_task(path: Path, doc: dict, icerik_root: Path) -> tuple[list[Issue], dict]:
    """Bir görevin denetimi: şema, kilit bölümü, görsel, hedef ifadeler, kabul listesi ile yakın seçenekler,
    mesaj kuralı, CEFR kapsama ve cümle uzunluğu."""
    root = Path(icerik_root)
    issues: list[Issue] = []
    for e in schema_errors(doc, "talk-task.schema.json"):
        issues.append(Issue("error", "talk-schema", e))
    tid = str(doc.get("id", "?"))
    if path.stem != tid:
        issues.append(Issue("error", "talk-schema", f"dosya adı ({path.name}) görev kimliğiyle ({tid}) aynı olmalı"))
    if doc.get("status") != "APPROVED":
        issues.append(Issue("warning", "talk-status",
                            f"{tid}: durum {doc.get('status')} (İngilizce ve Türkçe metinler editör onayı bekliyor, H-028)"))
    level = doc.get("level", "A1")
    unlock = str(doc.get("unlockAfter", ""))
    if find_episode_dir(root, unlock) is None:
        issues.append(Issue("error", "talk-unlock", f"{tid}: unlockAfter bölümü yok: {unlock}"))
    img = doc.get("image") if isinstance(doc.get("image"), dict) else {}
    ep = find_episode_dir(root, str(img.get("episode", "")))
    if ep is None:
        issues.append(Issue("error", "talk-image", f"{tid}: görselin bölümü yok: {img.get('episode')}"))
    else:
        stem = Path(str(img.get("path", ""))).stem
        if not (ep / "images" / f"{stem}.json").is_file():
            issues.append(Issue("error", "talk-image", f"{tid}: bölümde böyle bir görsel yok: {ep.name}/images/{stem}"))
        elif not (ep / "_build" / "package" / img.get("path", "")).is_file():
            issues.append(Issue("warning", "talk-media",
                                f"{tid}: görsel bölüm paketinde yok (git dışı medya ya da paket eski): {img.get('path')}"))
    if str(img.get("episode", "")) > unlock:
        issues.append(Issue("error", "talk-image", f"{tid}: görsel kilit bölümünden sonraki bir bölümden (spoiler)"))
    known = _episode_targets(root)
    open_targets = {t for k, v in known.items() if k <= unlock for t in v}
    all_targets = list(doc.get("targets") or []) + [
        tg for t in doc.get("turns") or [] if isinstance(t, dict) for tg in t.get("targets") or []]
    for t in dict.fromkeys(all_targets):
        if t not in open_targets:
            issues.append(Issue("error", "talk-target",
                                f"{tid}: hedef ifade \"{t}\" {unlock} ve öncesindeki bölümlerin targetPhrases listesinde yok"))
    english: list[str] = []
    rep = {"id": tid, "kind": doc.get("kind"), "turns": 0, "accepted": 0, "audioMatches": 0}
    if doc.get("kind") == "scene":
        turns = [t for t in doc.get("turns") or [] if isinstance(t, dict)]
        rep["turns"] = len(turns)
        ids = [t.get("id") for t in turns]
        if ids != [f"t{i + 1}" for i in range(len(turns))]:
            issues.append(Issue("error", "talk-turn", f"{tid}: tur kimlikleri sırayla t1, t2… olmalı: {ids}"))
        for t in turns:
            where = f"{tid}/{t.get('id', '?')}"
            acc = [a for a in t.get("accept") or [] if isinstance(a, str)]
            rep["accepted"] += len(acc)
            norm = [tuple(match_tokens(a)) for a in acc]
            if len(set(norm)) != len(norm):
                issues.append(Issue("error", "talk-accept", f"{where}: aynı cevap iki kez (yazım farkı sayılmaz)"))
            for d in t.get("distractors") or []:
                if isinstance(d, dict) and tuple(match_tokens(d.get("en", ""))) in set(norm):
                    issues.append(Issue("error", "talk-distractor",
                                        f"{where}: yakın seçenek kabul listesinde de var: \"{d.get('en')}\""))
            for tg in t.get("targets") or []:
                if not any(contains_in_order(a, tg) for a in acc):
                    issues.append(Issue("error", "talk-target",
                                        f"{where}: hedef \"{tg}\" hiçbir kabul edilen cevapta geçmiyor"))
            english += acc
            if isinstance(t.get("line"), dict):
                english.append(t["line"].get("en", ""))
        if doc.get("targets") is not None:
            issues.append(Issue("error", "talk-schema", f"{tid}: sahnede hedefler turlarda yazılır (görev düzeyinde targets yok)"))
        if isinstance(doc.get("outro"), dict):
            english.append(doc["outro"].get("en", ""))
        for where, line in _lines(doc):
            if manifest_audio(root, line.get("speaker"), line.get("en", "")):
                rep["audioMatches"] += 1
    elif doc.get("kind") == "message":
        model = (doc.get("model") or {}).get("en", "")
        english.append(model)
        check = doc.get("check")
        if check:
            if check_message(model, check) is not True:
                issues.append(Issue("error", "talk-check", f"{tid}: örnek cevap kendi kuralından geçmiyor"))
            for n in check.get("none") or []:
                for g in check.get("all") or []:
                    if n in g:
                        issues.append(Issue("error", "talk-check", f"{tid}: \"{n}\" hem gerekli hem yasak"))
        elif not doc.get("selfCheckTr"):
            issues.append(Issue("error", "talk-check", f"{tid}: kural yoksa öz değerlendirme maddeleri (selfCheckTr) gerekli"))
        for tg in doc.get("targets") or []:
            if not contains_in_order(model, tg):
                issues.append(Issue("warning", "talk-target",
                                    f"{tid}: hedef \"{tg}\" örnek cevapta geçmiyor (yalnız kullanıcı kullanırsa sayılır)"))
    if level in LEVELS and english:
        max_words = MAX_SENTENCE_WORDS.get(level, 10_000)
        cov = coverage(english, level, gloss=_episode_glossary(root, unlock), max_words=max_words)
        rep.update({"tokens": cov.tokens, "pct": round(cov.pct, 1), "pctWithGlossary": round(cov.pct_with_gloss, 1),
                    "maxSentenceWords": cov.max_sentence_words})
        if cov.pct < COVERAGE_TARGET and not (cov.pct >= COVERAGE_FLOOR and cov.pct_with_gloss >= COVERAGE_TARGET):
            issues.append(Issue("error", "talk-coverage",
                                f"{tid}: CEFR-J kapsaması %{cov.pct:.1f} (sözlükle %{cov.pct_with_gloss:.1f}); "
                                f"hedef %{COVERAGE_TARGET:.0f}"))
        elif cov.pct < COVERAGE_TARGET:
            issues.append(Issue("warning", "talk-coverage",
                                f"{tid}: CEFR-J kapsaması %{cov.pct:.1f} (sözlükle %{cov.pct_with_gloss:.1f}); "
                                "alt sınır yalnızca bölüm sözlüğüyle geçerli"))
        ungl = cov.unglossed()
        if ungl:
            issues.append(Issue("warning", "talk-off-list",
                                f"{tid}: liste dışı sözcük: " + ", ".join(f"{k}[{v[0]}]" for k, v in sorted(ungl.items()))))
        for s in cov.long_sentences:
            issues.append(Issue("error", "talk-sentence-length", f"{tid}: {level} için cümle en çok {max_words} sözcük: \"{s}\""))
    return issues, rep


def lint_talk(icerik_root: Path) -> list[tuple[str, list[Issue], dict]]:
    out = []
    try:
        tasks = load_tasks(icerik_root)
    except ValueError as e:
        return [("konusma", [Issue("error", "talk-schema", str(e))], {})]
    seen: set[str] = set()
    for p, doc in tasks:
        issues, rep = lint_task(p, doc, icerik_root)
        tid = str(doc.get("id", p.stem))
        if tid in seen:
            issues.append(Issue("error", "talk-schema", f"{tid}: aynı kimlik iki kez"))
        seen.add(tid)
        out.append((tid, issues, rep))
    return out


# --- dışa aktarma ---------------------------------------------------------------------------

def _episode_number(content_id: str) -> int:
    return int(content_id.split("-")[1])


def export_talk(icerik_root: Path, season: int, out: Path, audio=None) -> dict | None:
    """Sezon paketine `talk.json` yazar; season.json için özet döndürür. Kaynak yoksa None (eski paket silinir).
    Denetim hatası varsa ValueError (hatalı veri pakete girmez).
    audio(src_mp3, out_m4a): bölüm kaydında aynen geçen satırın sesini pakete yazar; verilmezse ses alanı düşer
    (uygulama cihaz sesini kullanır)."""
    root = Path(icerik_root)
    out = Path(out)
    tasks = load_tasks(root, season)
    if not tasks:
        (out / TALK_PACKAGE_FILE).unlink(missing_ok=True)
        return None
    errs = [f"{tid}: {i}" for tid, iss, _ in lint_talk(root) for i in iss if i.level == "error"]
    if errs:
        raise ValueError("; ".join(errs[:5]))
    adir = out / TALK_AUDIO_DIR
    used: set[str] = set()
    missing: list[str] = []
    pkg_tasks = []
    for _, doc in tasks:
        task = {k: v for k, v in doc.items() if k not in ("schemaVersion", "author", "date", "approvedBy")}
        task["unlockEpisode"] = _episode_number(doc["unlockAfter"])
        if doc.get("kind") == "scene":   # görevin hedefleri = turların hedefleri (sırayla, tekil)
            task["targets"] = list(dict.fromkeys(tg for t in doc["turns"] for tg in t.get("targets") or []))
        speaker = (doc.get("character") or {}).get("speaker")

        def with_audio(line: dict, name: str) -> dict:
            line = dict(line)
            spk = line.pop("speaker", None) or speaker
            hit = manifest_audio(root, spk, line["en"])
            if hit is None:
                return line
            ep, rec = hit
            src = ep / "audio" / f"{rec}.mp3"
            rel = f"{TALK_AUDIO_DIR}/{doc['id']}-{name}.m4a"
            if audio is not None and src.exists():
                adir.mkdir(parents=True, exist_ok=True)
                tmp = adir / f".{doc['id']}-{name}.m4a.tmp"
                tmp.unlink(missing_ok=True)
                audio(src, tmp)
                tmp.replace(out / rel)
                line["audio"] = rel
                used.add(rel)
            else:
                missing.append(f"{ep.name}/audio/{rec}.mp3")
            return line

        if doc.get("kind") == "scene":
            task["turns"] = [{**t, "line": with_audio(t["line"], t["id"])} for t in doc["turns"]]
            if doc.get("outro"):
                task["outro"] = with_audio(doc["outro"], "outro")
        pkg_tasks.append(task)
    pkg = {"schemaVersion": 1, "season": season, "tasks": pkg_tasks}
    out.mkdir(parents=True, exist_ok=True)
    tmp = out / f".{TALK_PACKAGE_FILE}.tmp"
    tmp.write_text(json.dumps(pkg, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    tmp.replace(out / TALK_PACKAGE_FILE)
    if adir.is_dir():   # eski sesler kalmasın
        for f in adir.iterdir():
            if f"{TALK_AUDIO_DIR}/{f.name}" not in used:
                f.unlink()
    return {"path": TALK_PACKAGE_FILE, "tasks": len(pkg_tasks),
            "scenes": sum(1 for t in pkg_tasks if t["kind"] == "scene"),
            "messages": sum(1 for t in pkg_tasks if t["kind"] == "message"),
            "audio": len(used), "audioMissing": missing,
            "bytes": (out / TALK_PACKAGE_FILE).stat().st_size}
