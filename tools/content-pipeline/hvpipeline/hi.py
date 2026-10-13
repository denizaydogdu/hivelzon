"""Hi-A verisi (H-048): hata kataloğu, konu tanıtımları, köprü görevleri ve "Bu ne demek?" dizini.

Kaynaklar (izlenen içerik, Claude taslağı → kullanıcı onayı):
    icerik/_evren/hata-katalogu.json     Türkçeye göre koçluk (F1): sürümlü hata türleri, Türkçe açıklama,
                                         yanlış → doğru örnekler; `decisionErrors`: yanlış karar seçeneklerinin türü
    icerik/_evren/konu-tanitimlari.json  Hi'nin konu kartı: bölüm + segment + altyazı satırı (tetik)
    icerik/_evren/kopru-gorevleri.json   Gerçek hayat köprü görevi (F4), bölüm başına en fazla 1

Paket: sezon paketinde `hi.json` (season.json → `hi` özeti). "Bu ne demek?" dizini (`lookup`) yalnızca
onaylı çevirisi (`ceviri.tr.json` status APPROVED) olan bölüm paketlerinden üretilir: altyazı satırlarındaki
kelime ve kalıplar (segment sesindeki zamanlarıyla), kart ve görev satırları, hedef ifadeler, sözlük ve
`phrases`. Uygulama dizini yalnızca kullanıcının açtığı bölümlerle süzer (gelecek bölüm metni görünmez).
Yapay zekâ ya da dış servis yok; tamamen deterministik.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

from .graph import Issue
from .translation import TRANSLATION_FILE, word_key

HI_DIR = Path("_evren")
CATALOG_FILE = "hata-katalogu.json"
INTROS_FILE = "konu-tanitimlari.json"
BRIDGE_FILE = "kopru-gorevleri.json"
HI_PACKAGE_FILE = "hi.json"

# mobile/lib/shared/meaning/error_taxonomy.dart (sürüm 1) ile aynı olmalı.
TAXONOMY_VERSION = 1
ERROR_TYPES = frozenset({
    "tense", "verb_form", "agreement", "article", "preposition", "pronoun", "plural", "word_order",
    "word_choice", "missing_extra", "spelling", "punctuation", "recall", "other",
})
ID_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")

# Suçlayıcı ya da baskı kuran dil (K-32, ARAYUZ-METINLERI §1.3): Hi metinlerinde hata.
BLAMING = ("kaçırdın", "başarısız", "yanlış yaptın", "serini kaybettin", "son şans", "hemen şimdi",
           "geride kaldın", "tembel", "ayıp")
# Köprü görevlerinde güvenlik (13+): fotoğraf, yükleme, konum ve paylaşım istenmez.
UNSAFE_TASK = ("fotoğraf çek", "fotoğrafını çek", "yükle", "konumunu", "paylaş", "adresini", "numaranı")


def hi_source(icerik_root: Path, name: str) -> Path:
    return Path(icerik_root) / HI_DIR / name


def _load(p: Path) -> dict | None:
    if not p.exists():
        return None
    try:
        return json.loads(p.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        raise ValueError(f"{p}: geçersiz JSON: {e}") from e


def has_hi_sources(icerik_root: Path) -> bool:
    return any(hi_source(icerik_root, n).exists() for n in (CATALOG_FILE, INTROS_FILE, BRIDGE_FILE))


def find_episode(icerik_root: Path, content_id: str) -> Path | None:
    dirs = sorted(q for q in Path(icerik_root).glob(f"{content_id}-*") if (q / "content.json").exists())
    return dirs[0] if dirs else None


def _package(icerik_root: Path, content_id: str) -> tuple[Path, dict] | None:
    d = find_episode(icerik_root, content_id)
    if d is None:
        return None
    p = d / "_build" / "package" / "scenes.json"
    if not p.exists():
        return None
    return p.parent, json.loads(p.read_text(encoding="utf-8"))


def _sentences(s: str) -> int:
    return len([x for x in re.split(r"(?<=[.!?])\s+(?=[A-ZÇĞİÖŞÜ\"“])", s.strip()) if x])


def _blaming(text: str) -> str | None:
    low = text.replace("İ", "i").replace("I", "ı").lower()
    for w in BLAMING:
        if w in low:
            return w
    return None


# --- denetim ---------------------------------------------------------------------------------

def lint_catalog(doc: dict, icerik_root: Path) -> list[Issue]:
    issues: list[Issue] = []
    E = lambda c, m: issues.append(Issue("error", c, m))  # noqa: E731
    W = lambda c, m: issues.append(Issue("warning", c, m))  # noqa: E731
    if doc.get("schemaVersion") != 1:
        E("hi-catalog", "hata-katalogu: schemaVersion 1 olmalı")
    if doc.get("taxonomyVersion") != TAXONOMY_VERSION:
        E("hi-catalog", f"hata-katalogu: taxonomyVersion {TAXONOMY_VERSION} olmalı (error_taxonomy.dart)")
    if doc.get("status") not in ("DRAFT", "APPROVED"):
        E("hi-catalog", "hata-katalogu: status DRAFT ya da APPROVED olmalı")
    entries = doc.get("entries")
    if not isinstance(entries, list) or not entries:
        E("hi-catalog", "hata-katalogu: entries boş")
        entries = []
    ids: set[str] = set()
    for i, e in enumerate(entries):
        eid = e.get("id", f"#{i}")
        if not isinstance(e.get("id"), str) or not ID_RE.match(e["id"]):
            E("hi-catalog", f"{eid}: id küçük harf ve tireyle yazılmalı")
        if eid in ids:
            E("hi-catalog", f"{eid}: aynı id iki kez")
        ids.add(eid)
        if e.get("errorType") not in ERROR_TYPES:
            E("hi-catalog", f"{eid}: errorType '{e.get('errorType')}' sınıflandırmada yok")
        for f in ("labelTr", "explanationTr"):
            if not str(e.get(f) or "").strip():
                E("hi-catalog", f"{eid}: {f} boş")
        n = _sentences(str(e.get("explanationTr") or ""))
        if n > 3:
            W("hi-catalog", f"{eid}: açıklama {n} cümle (hedef 1–2, en çok 3)")
        ex = e.get("examples")
        if not isinstance(ex, list) or not 1 <= len(ex) <= 2:
            E("hi-catalog", f"{eid}: 1–2 örnek gerekli")
        else:
            for x in ex:
                w, r = str(x.get("wrong") or "").strip(), str(x.get("right") or "").strip()
                if not w or not r:
                    E("hi-catalog", f"{eid}: örnekte wrong/right boş")
                elif w == r:
                    E("hi-catalog", f"{eid}: örnekte wrong ile right aynı")
        if not isinstance(e.get("relatedPhrases", []), list):
            E("hi-catalog", f"{eid}: relatedPhrases dizi olmalı")
        for f in ("labelTr", "explanationTr"):
            b = _blaming(str(e.get(f) or ""))
            if b:
                E("hi-tone", f"{eid}: suçlayıcı dil ('{b}')")
    seen = set()
    for de in doc.get("decisionErrors") or []:
        key = (de.get("contentId"), de.get("node"), de.get("option"))
        tag = "/".join(str(k) for k in key)
        if key in seen:
            E("hi-catalog", f"decisionErrors {tag}: iki kez")
        seen.add(key)
        if de.get("errorType") not in ERROR_TYPES:
            E("hi-catalog", f"decisionErrors {tag}: errorType sınıflandırmada yok")
        if de.get("entry") is not None and de["entry"] not in ids:
            E("hi-catalog", f"decisionErrors {tag}: entry '{de['entry']}' katalogda yok")
        pkg = _package(icerik_root, str(de.get("contentId")))
        if pkg is None:
            W("hi-catalog", f"decisionErrors {tag}: bölüm paketi yok, denetlenemedi")
            continue
        nodes = {n["id"]: n for n in pkg[1].get("nodes", [])}
        node = nodes.get(de.get("node"))
        if node is None or node.get("type") != "decision":
            E("hi-catalog", f"decisionErrors {tag}: karar düğümü yok")
            continue
        opt = next((o for o in node.get("options", []) if o.get("id") == de.get("option")), None)
        if opt is None:
            E("hi-catalog", f"decisionErrors {tag}: seçenek yok")
        elif opt.get("correct"):
            E("hi-catalog", f"decisionErrors {tag}: seçenek doğru cevap; yalnızca yanlış seçenekler eşlenir")
    return issues


def _cue_text(pkg_dir: Path, node: dict, cue_id: str) -> str | None:
    sub = node.get("subtitles")
    if not sub or not (pkg_dir / sub).exists():
        return None
    track = json.loads((pkg_dir / sub).read_text(encoding="utf-8"))
    for c in track.get("cues", []):
        if c.get("id") == cue_id:
            return c.get("text") or ""
    return None


def lint_intros(doc: dict, icerik_root: Path) -> list[Issue]:
    issues: list[Issue] = []
    E = lambda c, m: issues.append(Issue("error", c, m))  # noqa: E731
    W = lambda c, m: issues.append(Issue("warning", c, m))  # noqa: E731
    if doc.get("schemaVersion") != 1:
        E("hi-intro", "konu-tanitimlari: schemaVersion 1 olmalı")
    if doc.get("status") not in ("DRAFT", "APPROVED"):
        E("hi-intro", "konu-tanitimlari: status DRAFT ya da APPROVED olmalı")
    ids: set[str] = set()
    triggers: set[tuple] = set()
    for i, t in enumerate(doc.get("intros") or []):
        tid = t.get("id", f"#{i}")
        if not isinstance(t.get("id"), str) or not ID_RE.match(t["id"]):
            E("hi-intro", f"{tid}: id küçük harf ve tireyle yazılmalı")
        if tid in ids:
            E("hi-intro", f"{tid}: aynı id iki kez")
        ids.add(tid)
        lines = t.get("linesTr")
        if not isinstance(lines, list) or not 2 <= len(lines) <= 3 or not all(str(x).strip() for x in lines):
            E("hi-intro", f"{tid}: 2–3 Türkçe satır gerekli")
        else:
            for x in lines:
                b = _blaming(x)
                if b:
                    E("hi-tone", f"{tid}: suçlayıcı dil ('{b}')")
                if len(x) > 140:
                    W("hi-intro", f"{tid}: satır uzun ({len(x)} karakter; kısa tutulmalı)")
        for f in ("titleEn", "exampleEn", "exampleTr"):
            if not str(t.get(f) or "").strip():
                E("hi-intro", f"{tid}: {f} boş")
        if len(str(t.get("exampleEn") or "").split()) > 8:
            W("hi-intro", f"{tid}: örnek cümle A1 sınırından (8 sözcük) uzun")
        cid = t.get("contentId")
        ep = find_episode(icerik_root, str(cid))
        if ep is None:
            E("hi-intro", f"{tid}: bölüm {cid} yok")
            continue
        content = json.loads((ep / "content.json").read_text(encoding="utf-8"))
        gt, tp = t.get("grammarTarget"), t.get("targetPhrase")
        if gt is None and tp is None:
            E("hi-intro", f"{tid}: grammarTarget ya da targetPhrase gerekli")
        if gt is not None and gt not in (content.get("grammarTargets") or []):
            E("hi-intro", f"{tid}: grammarTarget '{gt}' {cid} content.json'da yok")
        if tp is not None and tp not in (content.get("targetPhrases") or []):
            E("hi-intro", f"{tid}: targetPhrase '{tp}' {cid} content.json'da yok")
        trig = t.get("trigger") or {}
        key = (cid, trig.get("node"))
        if key in triggers:
            E("hi-intro", f"{tid}: aynı segmentte ikinci konu kartı ({cid}/{trig.get('node')})")
        triggers.add(key)
        pkg = _package(icerik_root, str(cid))
        if pkg is None:
            W("hi-intro", f"{tid}: {cid} paketi yok, tetik denetlenemedi")
            continue
        nodes = {n["id"]: n for n in pkg[1].get("nodes", [])}
        node = nodes.get(trig.get("node"))
        if node is None:
            E("hi-intro", f"{tid}: tetik düğümü '{trig.get('node')}' yok")
            continue
        if node.get("type") != "segment" or not node.get("video"):
            E("hi-intro", f"{tid}: tetik bir video segmenti olmalı (başlık/özet/karar değil)")
            continue
        text = _cue_text(pkg[0], node, str(trig.get("cue")))
        if text is None:
            E("hi-intro", f"{tid}: altyazı satırı '{trig.get('cue')}' yok")
        elif str(trig.get("match") or "") not in text:
            E("hi-intro", f"{tid}: satır '{text}' içinde '{trig.get('match')}' geçmiyor")
    return issues


def lint_bridge(doc: dict, icerik_root: Path) -> list[Issue]:
    issues: list[Issue] = []
    E = lambda c, m: issues.append(Issue("error", c, m))  # noqa: E731
    if doc.get("schemaVersion") != 1:
        E("hi-bridge", "kopru-gorevleri: schemaVersion 1 olmalı")
    if doc.get("status") not in ("DRAFT", "APPROVED"):
        E("hi-bridge", "kopru-gorevleri: status DRAFT ya da APPROVED olmalı")
    ids, episodes = set(), set()
    for i, t in enumerate(doc.get("tasks") or []):
        tid = t.get("id", f"#{i}")
        if not isinstance(t.get("id"), str) or not ID_RE.match(t["id"]):
            E("hi-bridge", f"{tid}: id küçük harf ve tireyle yazılmalı")
        if tid in ids:
            E("hi-bridge", f"{tid}: aynı id iki kez")
        ids.add(tid)
        cid = t.get("contentId")
        if cid in episodes:
            E("hi-bridge", f"{tid}: {cid} için ikinci görev (bölüm başına en fazla 1)")
        episodes.add(cid)
        if find_episode(icerik_root, str(cid)) is None:
            E("hi-bridge", f"{tid}: bölüm {cid} yok")
        for f in ("titleTr", "textTr"):
            if not str(t.get(f) or "").strip():
                E("hi-bridge", f"{tid}: {f} boş")
        low = str(t.get("textTr") or "").lower()
        for w in UNSAFE_TASK:
            if w in low:
                E("hi-bridge", f"{tid}: güvenlik: '{w}' istenmez (fotoğraf, yükleme, konum, paylaşım yok)")
        b = _blaming(str(t.get("textTr") or ""))
        if b:
            E("hi-tone", f"{tid}: suçlayıcı dil ('{b}')")
    return issues


def lint_hi(icerik_root: Path) -> list[tuple[str, list[Issue]]]:
    """Kaynak başına sorunlar: [(dosya adı, sorunlar)]. Olmayan kaynak atlanır."""
    out = []
    for name, fn in ((CATALOG_FILE, lint_catalog), (INTROS_FILE, lint_intros), (BRIDGE_FILE, lint_bridge)):
        p = hi_source(icerik_root, name)
        try:
            doc = _load(p)
        except ValueError as e:
            out.append((name, [Issue("error", "hi-schema", str(e))]))
            continue
        if doc is not None:
            out.append((name, fn(doc, icerik_root)))
    return out


# --- "Bu ne demek?" dizini -------------------------------------------------------------------

def _display(w: str) -> str:
    k = word_key(w)
    return "I" if k == "i" else k


def _norm(s: str) -> str:
    return re.sub(r"\s+", " ", (s or "").replace("’", "'")).strip()


class _Index:
    def __init__(self) -> None:
        self.entries: list[dict] = []
        self.by_key: dict[str, dict] = {}

    def add(self, en: str, tr: str | None, kind: str, content_id: str, example_en: str | None = None,
            example_tr: str | None = None, audio: dict | None = None, example_audio: dict | None = None) -> None:
        en, tr = _norm(en), _norm(tr or "")
        if not en or not tr:
            return
        key = en.lower().rstrip(".!?,")
        cur = self.by_key.get(key)
        if cur is not None:
            if tr != cur["tr"] and tr not in cur.setdefault("alt", []) and len(cur["alt"]) < 3:
                cur["alt"].append(tr)
            if "audio" not in cur and audio and cur["contentId"] == content_id:
                cur["audio"] = audio
            if not cur.get("exampleEn") and example_en:
                cur["exampleEn"], cur["exampleTr"] = example_en, example_tr
            return
        e = {"en": en, "tr": tr, "kind": kind, "contentId": content_id}
        if example_en and _norm(example_en).lower().rstrip(".!?,") != key:
            e["exampleEn"] = _norm(example_en)
            if example_tr:
                e["exampleTr"] = _norm(example_tr)
        if audio:
            e["audio"] = audio
        if example_audio and "exampleEn" in e:
            e["exampleAudio"] = example_audio
        self.by_key[key] = e
        self.entries.append(e)


def _clip(path: str, start: float | None, end: float | None) -> dict | None:
    if start is None or end is None or end <= start:
        return None
    return {"path": path, "start": round(max(0.0, start - 0.04), 3), "end": round(end + 0.1, 3)}


def _line(idx: _Index, cid: str, text: str, tr: str | None, words: list[dict], chunks: list[dict],
          video: str | None = None, cue: dict | None = None) -> None:
    timed = video is not None and cue is not None
    sentence_audio = _clip(video, cue.get("start"), cue.get("end")) if timed else None
    for w in words or []:
        g = w.get("gloss")
        if not g:
            continue
        a = _clip(video, w.get("start"), w.get("end")) if timed else None
        idx.add(_display(w.get("w", "")), g, "word", cid, text, tr, a, sentence_audio)
    for c in chunks or []:
        a = None
        if timed:
            s, e = c.get("startWord"), c.get("endWord")
            if isinstance(s, int) and isinstance(e, int) and 0 <= s <= e < len(words):
                a = _clip(video, words[s].get("start"), words[e].get("end"))
        idx.add(c.get("en", ""), c.get("tr"), "phrase", cid, text, tr, a, sentence_audio)


def build_lookup(icerik_root: Path) -> tuple[list[dict], list[str]]:
    """Onaylı çevirisi olan paketlerden dizin; (girdiler, kullanılan bölümler)."""
    idx = _Index()
    used = []
    for d in sorted(Path(icerik_root).glob("A[0-9]-[0-9][0-9][0-9]-*")):
        cj, tj, sj = d / "content.json", d / TRANSLATION_FILE, d / "_build" / "package" / "scenes.json"
        if not (cj.exists() and tj.exists() and sj.exists()):
            continue
        tdoc = json.loads(tj.read_text(encoding="utf-8"))
        if tdoc.get("status") != "APPROVED":
            continue
        doc = json.loads(sj.read_text(encoding="utf-8"))
        cid = doc["episode"]["id"]
        used.append(cid)
        pkg = sj.parent
        for g in doc["episode"].get("targetPhraseGloss") or []:
            idx.add(g.get("text", ""), g.get("tr"), "phrase", cid)
        for n in doc.get("nodes", []):
            if n.get("type") == "reaction":
                continue   # yanlış seçimin tepkisi: yanlış biçim örnek olmasın
            sub = n.get("subtitles")
            if sub and n.get("video") and (pkg / sub).exists():
                track = json.loads((pkg / sub).read_text(encoding="utf-8"))
                for c in track.get("cues", []):
                    _line(idx, cid, c.get("text", ""), c.get("tr"), c.get("words") or [], c.get("chunks") or [],
                          n["video"], c)
            if n.get("type") == "card":
                for ln in n.get("lines") or []:
                    if ln.get("lang", "en") == "en" and ln.get("words"):
                        _line(idx, cid, ln.get("text", ""), ln.get("tr"), ln["words"], ln.get("chunks") or [])
            cue = n.get("cue")
            if isinstance(cue, dict) and cue.get("words"):
                _line(idx, cid, cue.get("text", ""), cue.get("tr"), cue["words"], cue.get("chunks") or [])
            for it in n.get("items") or []:
                if it.get("stemWords"):
                    _line(idx, cid, it.get("stem", ""), it.get("stemTr"), it["stemWords"], it.get("stemChunks") or [])
        for g in doc["episode"].get("glossary") or []:
            idx.add(g.get("w", ""), g.get("tr"), "word", cid)
        for p in tdoc.get("phrases") or []:
            idx.add(p.get("en", ""), p.get("tr"), "phrase", cid)
    return idx.entries, used


# --- dışa aktarma ----------------------------------------------------------------------------

def export_hi(icerik_root: Path, season: int, out: Path) -> dict | None:
    """Sezon paketine `hi.json` yazar; season.json için özet döndürür. Kaynak yoksa None.
    Denetim hatası varsa ValueError (hatalı veri pakete girmez)."""
    root = Path(icerik_root)
    if not has_hi_sources(root):
        (Path(out) / HI_PACKAGE_FILE).unlink(missing_ok=True)
        return None
    errs = [f"{name}: {i}" for name, iss in lint_hi(root) for i in iss if i.level == "error"]
    if errs:
        raise ValueError("; ".join(errs[:5]))
    catalog = _load(hi_source(root, CATALOG_FILE)) or {}
    intros = _load(hi_source(root, INTROS_FILE)) or {}
    bridge = _load(hi_source(root, BRIDGE_FILE)) or {}
    lookup, used = build_lookup(root)
    doc = {
        "schemaVersion": 1, "season": season, "taxonomyVersion": TAXONOMY_VERSION,
        "status": {"errorCatalog": catalog.get("status"), "topicIntros": intros.get("status"),
                   "bridgeTasks": bridge.get("status")},
        "errorCatalog": catalog.get("entries") or [],
        "decisionErrors": catalog.get("decisionErrors") or [],
        "topicIntros": intros.get("intros") or [],
        "bridgeTasks": bridge.get("tasks") or [],
        "lookupEpisodes": used,
        "lookup": lookup,
    }
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    tmp = out / f".{HI_PACKAGE_FILE}.tmp"
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    tmp.replace(out / HI_PACKAGE_FILE)
    return {"path": HI_PACKAGE_FILE, "errorCatalog": len(doc["errorCatalog"]), "topicIntros": len(doc["topicIntros"]),
            "bridgeTasks": len(doc["bridgeTasks"]), "lookup": len(lookup),
            "bytes": (out / HI_PACKAGE_FILE).stat().st_size}
