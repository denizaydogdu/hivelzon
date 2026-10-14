"""Bölümlerdeki ve Hi verisindeki Türkçe seslerin Alania ile üretimi (H-083).

Kullanıcı kararı (2026-10-14): "Uygulamadaki Türkçe konuşan her yer Alania ile."

Toplanan yerler (bölüm `kurgu.json`):
- Hi tepki balonu (`reaction.bubble`, lang tr), görev geri bildirimi (`task.feedback.wrong`),
- Hi kartı (`card` kind hi), Alex'in Türkçe repliği (`card` kind line, satırlar tr),
- Türkçe not kartı (`card` kind note, satırlar tr; ör. babaannenin notu, `voiceRole: nermin`),
- ipucu panosu (`card` kind clue) ve açık soru (`card` kind openQuestion) kartları: anlatıcı sesi.
Hi verisi (`icerik/_evren/`): hata notu (`explanationTr`), konu tanıtımı (`linesTr`), köprü görevi (`textTr`).

Söylenen metin: düğümde `speechTr` varsa o, yoksa ekrandaki metin. İngilizce ifadeler `{…}` ile işaretlenir.
Roller ve sesler `icerik/_evren/sesler.json`'dadır (hi, alex, nermin, narrator; İngilizce Sarah).

Kip:
- `tr`: işaret yok → tek Alania parçası (tts_tr; -16 LUFS mp3 + Duyu hizalaması).
- `b` (varsayılan, İngilizce ifade varsa): Türkçe parçalar Alania + Duyu, İngilizce ifadeler ElevenLabs Sarah
  (zaman damgalı). Parçaların baş/son sessizliği kırpılır, İngilizce parçalar Türkçe parçaların ses düzeyine
  getirilir, kısa boşlukla birleştirilir, bütün -16 LUFS'a getirilir; hizalama parçalardan birleştirilir.
- `a`: tümü Alania, İngilizce kelimeler söyleniş sözlüğüyle (`sesler.json` → pronunciations + düğümün kendi
  sözlüğü). Türkçe ek alan özel ad (ör. "Pier 3'te") için ve karşılaştırma örneklerinde kullanılır.

Kurallar (CLAUDE.md): varsayılan kuru çalışma; `execute` ile gerçek çağrı; iki tavan da tanımlı olmalı
(Türkçe `HIVELZON_TR_TTS_MONTHLY_CHAR_CAP`, İngilizce `sesler.json` english.monthlyCharCap ya da CLI); her
parçadan önce tavan denetlenir; ödenmiş ham çıktı `_raw/` önbelleğinde; güncel çıktı atlanır; her çağrı
`PROMPTS.md`'ye yazılır; anahtarlar yalnız gerçek çağrıda ortamdan ya da repo dışındaki dosyadan okunur.
Eski ElevenLabs Türkçe sesleri silinmez: `audio/_raw/elevenlabs/` altına taşınır (git dışı).
"""

from __future__ import annotations

import base64
import json
import os
import re
import shutil
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Callable

from . import REPO_ROOT, tts, tts_tr
from .align import Alignment, alignment_json, concat_alignments
from .book import text_sha256

VOICE_MAP_FILE = Path("_evren") / "sesler.json"
HI_AUDIO_DIR = Path("_evren") / "hi-ses"
RAW = "_raw"
TR_PARTS = "parca-tr"
EN_PARTS = "parca-en"
VARIANT_A = "varyant-a"
BACKUP = "elevenlabs"
ASSEMBLY_VERSION = 2
EDGE_REL = 0.04          # kırpma eşiği: zarfın en büyüğünün %4'ü
LEAD_PAD = 0.03          # sesten önce bırakılan pay (sn)
TAIL_PAD = 0.08          # sesten sonra bırakılan pay (sn)
VOICED_REL = 0.10        # ses düzeyi karşılaştırmasında "sesli" pencere eşiği
EN_PROMPTS_HEADING = "## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)"
EN_PROMPTS_TABLE = ("| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |\n"
                    "|---|---|---|---|---|---|---|")
_MARK = re.compile(r"\{([^{}]+)\}")
# Türkçe metinde işaretlenmemiş İngilizce ifade şüphesi (denetim uyarısı): yalnız sık İngilizce sözcükler.
_EN_HINT = re.compile(r"\b(the|is|are|am|you|can|please|what|where|it's|I'm|o'clock|excuse|friday|monday|"
                      r"hello|yes|sorry|again|between|behind|near|left|right|station|old)\b", re.I)


class EpisodeTtsError(RuntimeError):
    pass


# --- ses haritası --------------------------------------------------------------------------------

@dataclass
class VoiceMap:
    roles: dict[str, dict]
    model: str
    en: dict
    default_mode: str
    gap: float
    pronunciations: list[dict]
    path: Path

    @classmethod
    def load(cls, icerik_root: Path) -> "VoiceMap":
        p = Path(icerik_root) / VOICE_MAP_FILE
        if not p.exists():
            raise EpisodeTtsError(f"ses haritası yok: {p}")
        d = json.loads(p.read_text(encoding="utf-8"))
        t = d["turkish"]
        for name, r in t["roles"].items():
            if not str(r.get("voice", "")).startswith("alania"):
                raise EpisodeTtsError(f"{name}: Türkçe ses Alania olmalı ({r.get('voice')})")
        m = d.get("mixed", {})
        return cls(t["roles"], t.get("model", tts_tr.TTS_MODEL), d["english"], m.get("default", "b"),
                   float(m.get("gap", 0.15)), list(d.get("pronunciations", [])), p)

    def role(self, name: str) -> dict:
        if name not in self.roles:
            raise EpisodeTtsError(f"ses haritasında rol yok: {name}")
        return self.roles[name]

    def pron_for(self, text: str, extra: list[dict] | None = None) -> list[dict] | None:
        out, seen = [], set()
        for p in (extra or []) + self.pronunciations:
            term = p["term"]
            if term in seen:
                continue
            if re.search(rf"(?<![\w']){re.escape(term)}(?![\w])", text, re.I):
                out.append({"term": term, "say_as": p["say_as"]})
                seen.add(term)
        return out or None


# --- metin ---------------------------------------------------------------------------------------

@dataclass
class Part:
    lang: str        # tr | en
    text: str        # seslendirilen metin
    tail: str = ""   # ardındaki yalnız noktalama (seslendirilmez; hizalamada sıfır süre)


def _add_tr(parts: list[Part], frag: str) -> None:
    if not frag:
        return
    if not any(c.isalnum() for c in frag):
        # "{at}: {at two o'clock.}" → ":" ayrı Alania çağrısı olmaz; önceki parçanın kuyruğu olur.
        if not parts:
            raise EpisodeTtsError(f"metin yalnız noktalamayla başlıyor: {frag!r}")
        parts[-1].tail += frag
        return
    parts.append(Part("tr", frag))


def split_marked(speech: str) -> list[Part]:
    """`Türkçe {English} Türkçe` → parçalar. Boş parça atlanır, kenar boşlukları kırpılır."""
    parts, pos = [], 0
    for m in _MARK.finditer(speech):
        _add_tr(parts, speech[pos:m.start()].strip())
        en = m.group(1).strip()
        if en:
            parts.append(Part("en", en))
        pos = m.end()
    _add_tr(parts, speech[pos:].strip())
    rest_marks = _MARK.sub("", speech)
    if "{" in rest_marks or "}" in rest_marks:
        raise EpisodeTtsError(f"işaret hatası (süslü parantez): {speech!r}")
    return parts


def plain(speech: str) -> str:
    """Söylenen metnin düz hâli (hizalama metni): parçalar tek boşlukla."""
    return " ".join(" ".join(p.text.split()) + p.tail for p in split_marked(speech))


# --- toplama -------------------------------------------------------------------------------------

@dataclass
class Item:
    stem: str
    where: str
    role: str
    speech: str
    mode: str                     # tr | a | b
    out_dir: Path
    prompts: Path
    target: tuple                 # ("kurgu", kurgu_path, json_path) | ("hi", file_path, list_key, entry_id)
    has_ref: bool
    pronunciations: list[dict] | None = None

    @property
    def parts(self) -> list[Part]:
        return split_marked(self.speech)

    @property
    def text(self) -> str:
        return plain(self.speech)

    def audio(self) -> Path:
        return self.out_dir / f"{self.stem}.mp3"

    def align(self) -> Path:
        return self.out_dir / f"{self.stem}.align.json"


def _lines_text(lines: list[dict]) -> str:
    return " ".join(str(ln.get("text", "")).strip() for ln in lines if str(ln.get("text", "")).strip())


def _ref_stem(ref) -> str | None:
    if ref is None:
        return None
    if isinstance(ref, str):
        return ref
    if "path" in ref:
        return Path(ref["path"]).name
    return ref.get("id")


def _role_for_card(node: dict) -> str | None:
    if node.get("voiceRole"):
        return node["voiceRole"]
    kind = node.get("kind")
    lines = node.get("lines") or []
    if kind == "hi":
        return "hi"
    if kind in ("clue", "openQuestion"):
        return "narrator"
    if kind in ("line", "note") and lines and all(ln.get("lang", "en") == "tr" for ln in lines):
        sp = str(lines[0].get("speaker", "")).upper()
        return {"ALEX": "alex", "HI": "hi"}.get(sp, "narrator")
    return None


def collect_episode(ep_dir: Path, vm: VoiceMap) -> list[Item]:
    ep_dir = Path(ep_dir)
    kp = ep_dir / "kurgu.json"
    if not kp.exists():
        return []
    k = json.loads(kp.read_text(encoding="utf-8"))
    cid = k.get("contentId", ep_dir.name[:6])
    out_dir, prompts = ep_dir / "audio", ep_dir / "PROMPTS.md"
    items: list[Item] = []

    def add(spec: dict, role: str, display: str, where: str, jpath: tuple, default_stem: str):
        ref = spec.get("audio")
        stem = _ref_stem(ref) or default_stem
        speech = spec.get("speechTr") or display
        mode = spec.get("speechMode") or ("tr" if not _MARK.search(speech) else vm.default_mode)
        if mode not in ("tr", "a", "b"):
            raise EpisodeTtsError(f"{cid} {where}: speechMode a ya da b olmalı")
        if mode == "tr" and _MARK.search(speech):
            mode = vm.default_mode
        if mode != "tr" and not _MARK.search(speech):
            mode = "tr"
        vm.role(role)
        items.append(Item(stem, f"{cid} {where}", role, speech, mode, out_dir, prompts,
                          ("kurgu", kp, jpath), ref is not None, spec.get("pronunciations")))

    for i, n in enumerate(k.get("nodes", [])):
        nid, t = n["id"], n["type"]
        if t == "reaction" and n.get("bubble") and n["bubble"].get("lang", "tr") == "tr":
            b = n["bubble"]
            add(b, b.get("voiceRole") or ("hi" if b.get("speaker", "HI").upper() == "HI" else "narrator"),
                b["text"], f"{nid} balon", ("nodes", i, "bubble"), f"tr_{nid}")
        elif t == "task" and (n.get("feedback") or {}).get("wrong", {}).get("lang", "tr") == "tr" \
                and (n.get("feedback") or {}).get("wrong"):
            b = n["feedback"]["wrong"]
            add(b, b.get("voiceRole") or "hi", b["text"], f"{nid} geri bildirim",
                ("nodes", i, "feedback", "wrong"), f"tr_{nid}")
        elif t == "card":
            role = _role_for_card(n)
            if role is None:
                continue
            add(n, role, _lines_text(n.get("lines") or []), f"{nid} kart ({n.get('kind')})", ("nodes", i),
                f"tr_{nid}")
    return items


HI_SOURCES = (
    ("hata-katalogu.json", "entries", "note", lambda e: e["explanationTr"]),
    ("konu-tanitimlari.json", "intros", "intro", lambda e: " ".join(e["linesTr"])),
    ("kopru-gorevleri.json", "tasks", "bridge", lambda e: e["textTr"]),
)


def collect_hi(icerik_root: Path, vm: VoiceMap) -> list[Item]:
    root = Path(icerik_root)
    out_dir = root / HI_AUDIO_DIR
    items = []
    for fname, key, prefix, display in HI_SOURCES:
        p = root / "_evren" / fname
        if not p.exists():
            continue
        d = json.loads(p.read_text(encoding="utf-8"))
        for e in d.get(key) or []:
            speech = e.get("speechTr") or display(e)
            mode = e.get("speechMode") or ("b" if _MARK.search(speech) else "tr")
            if not _MARK.search(speech):
                mode = "tr"
            items.append(Item(f"{prefix}-{e['id']}", f"Hi {fname} {e['id']}", "hi", speech, mode, out_dir,
                              out_dir / "PROMPTS.md", ("hi", p, key, e["id"]), bool(e.get("audio")),
                              e.get("pronunciations")))
    return items


# --- plan ----------------------------------------------------------------------------------------

@dataclass
class TrPiece:
    """Bir Alania çağrısı (tam satır, b kipinde Türkçe parça ya da a kipi satırı)."""
    seg: tts_tr.Segment
    voice: str
    out_dir: Path
    prompts: Path
    finalize: bool          # tam çıktı (mp3) mı, yalnız parça (ham WAV + hizalama) mı

    @property
    def key(self) -> str:
        return tts_tr.seg_key(self.seg, self.voice)

    def raw_wav(self) -> Path:
        return self.out_dir / RAW / f"{self.key}.wav"


@dataclass
class EnPiece:
    id: str
    text: str
    key: str
    out_dir: Path
    prompts: Path

    def raw_mp3(self) -> Path:
        return self.out_dir / RAW / EN_PARTS / f"{self.key}.mp3"

    def raw_json(self) -> Path:
        return self.out_dir / RAW / EN_PARTS / f"{self.key}.json"


@dataclass
class ItemPlan:
    item: Item
    action: str                      # skip | build
    reason: str
    tr: list[TrPiece] = field(default_factory=list)
    en: list[EnPiece] = field(default_factory=list)
    order: list[tuple[str, int]] = field(default_factory=list)   # (tr|en, indeks) parça sırası (b kipi)
    tails: list[str] = field(default_factory=list)               # parça başına seslendirilmeyen noktalama
    key: str = ""
    compare_a: TrPiece | None = None


def en_key(text: str, en: dict) -> str:
    return text_sha256(json.dumps([text, en["voiceId"], en["modelId"], float(en["speed"]), tts.STABILITY,
                                   tts.SIMILARITY, tts.OUTPUT_FORMAT]))[:24]


def _align_key(path: Path) -> str | None:
    try:
        return json.loads(path.read_text(encoding="utf-8")).get("key")
    except (OSError, ValueError):
        return None


def plan_item(it: Item, vm: VoiceMap, force: bool = False, compare: bool = False) -> ItemPlan:
    r = vm.role(it.role)
    voice, ins = r["voice"], r.get("instructions")
    ip = ItemPlan(it, "build", "ses yok")
    if it.mode in ("tr", "a"):
        text = it.text
        pron = vm.pron_for(text, it.pronunciations) if it.mode == "a" else it.pronunciations
        seg = tts_tr.Segment(it.stem, text, ins, pron)
        ip.tr.append(TrPiece(seg, voice, it.out_dir, it.prompts, True))
        ip.key = ip.tr[0].key
    else:
        tr_dir = it.out_dir / RAW / TR_PARTS
        for k, p in enumerate(it.parts):
            if p.lang == "tr":
                seg = tts_tr.Segment(f"{it.stem}.p{k + 1}", p.text, ins, vm.pron_for(p.text, it.pronunciations))
                ip.tr.append(TrPiece(seg, voice, tr_dir, it.prompts, False))
                ip.order.append(("tr", len(ip.tr) - 1))
            else:
                ip.en.append(EnPiece(f"{it.stem}.p{k + 1}", p.text, en_key(p.text, vm.en), it.out_dir, it.prompts))
                ip.order.append(("en", len(ip.en) - 1))
            ip.tails.append(p.tail)
        ip.key = text_sha256(json.dumps([ASSEMBLY_VERSION, vm.gap, [
            (lang, ip.tr[n].key if lang == "tr" else ip.en[n].key) for lang, n in ip.order], ip.tails]))[:24]
        if compare:
            text = it.text
            seg = tts_tr.Segment(it.stem, text, ins, vm.pron_for(text, it.pronunciations))
            ip.compare_a = TrPiece(seg, voice, it.out_dir / RAW / VARIANT_A, it.prompts, True)
    if not force and it.audio().exists() and _align_key(it.align()) == ip.key:
        ip.action, ip.reason = "skip", "ses ve hizalama güncel (anahtar aynı)"
    elif it.align().exists():
        ip.reason = "metin, ses ya da ayar değişti" if _is_alania(it.align()) else "eski ElevenLabs sesi → Alania"
    return ip


def _is_alania(align: Path) -> bool:
    try:
        d = json.loads(align.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return False
    return str(d.get("voice_id", "")).startswith("alania") and str(d.get("timing", "")).startswith("duyu")


@dataclass
class Totals:
    tr_chars: int = 0          # ödenecek Alania karakteri (önbellekte olmayan)
    en_chars: int = 0          # ödenecek ElevenLabs karakteri (önbellekte olmayan, tekil)
    tr_all: int = 0            # bütün Türkçe karakter (bilgi)
    en_all: int = 0


def totals(plans: list[ItemPlan]) -> Totals:
    t = Totals()
    seen_tr, seen_en = set(), set()
    for p in plans:
        pieces = p.tr + ([p.compare_a] if p.compare_a else [])
        for tp in pieces:
            t.tr_all += len(tp.seg.text)
            if p.action != "skip" or tp is p.compare_a:
                if not tp.raw_wav().exists() and (tp.out_dir, tp.key) not in seen_tr:
                    t.tr_chars += len(tp.seg.text)
                    seen_tr.add((tp.out_dir, tp.key))
        for ep in p.en:
            t.en_all += len(ep.text)
            if p.action != "skip" and not ep.raw_mp3().exists() and (ep.out_dir, ep.key) not in seen_en:
                t.en_chars += len(ep.text)
                seen_en.add((ep.out_dir, ep.key))
    return t


def describe(plans: list[ItemPlan], vm: VoiceMap) -> list[str]:
    out = []
    for p in plans:
        it = p.item
        voice = vm.role(it.role)["voice"]
        en = f" + {len(p.en)} İngilizce ifade (Sarah)" if p.en else ""
        out.append(f"  {it.where}: {it.stem} · {it.role} ({voice}) · kip {it.mode} · {len(it.text)} karakter{en} · "
                   f"{'ATLA' if p.action == 'skip' else 'KUR'} — {p.reason}")
    return out


# --- yürütme -------------------------------------------------------------------------------------

def _noop_finalize(wav: Path, out: Path) -> None:
    return None


def run_tr(pieces: list[TrPiece], client, cap: int | None, ledger: Path, log=print,
           finalize: Callable | None = None, sleep: Callable | None = None) -> tuple[int, int, list[str]]:
    """Alania + Duyu (tts_tr.execute). Aynı (klasör, ses, kayıt) grubundaki parçalar tek planda.
    Dönüş: (karakter, çağrı, uyarılar)."""
    groups: dict[tuple, list[TrPiece]] = {}
    for p in pieces:
        groups.setdefault((p.out_dir, p.voice, p.prompts, p.finalize), []).append(p)
    chars = calls = 0
    warns: list[str] = []
    for (out_dir, voice, prompts, fin), ps in groups.items():
        segs, seen = [], set()
        for p in ps:
            if p.seg.id not in seen:
                segs.append(p.seg)
                seen.add(p.seg.id)
        plan = tts_tr.plan_segments(segs, out_dir, voice)
        if all(j.action == "skip" for j in plan.jobs):
            continue
        kw = {"log": log}
        if sleep is not None:
            kw["sleep"] = sleep
        kw["finalize"] = (finalize or tts_tr.finalize_audio) if fin else _noop_finalize
        res = tts_tr.execute(plan, client, cap, ledger, prompts, **kw)
        chars += res.chars
        calls += res.tts_calls
        warns += res.warnings
        if res.stopped:
            raise EpisodeTtsError(res.stopped)
    return chars, calls, warns


def append_en_prompts(path: Path, row: dict) -> None:
    text = path.read_text(encoding="utf-8") if path.exists() else "# PROMPTS\n"
    if EN_PROMPTS_HEADING not in text:
        text = text.rstrip("\n") + f"\n\n{EN_PROMPTS_HEADING}\n\n{EN_PROMPTS_TABLE}\n"
    text = text if text.endswith("\n") else text + "\n"
    line = (f"| {row['date']} | {row['segment']} | {row['voice']} | {row['model']} | {row['speed']} | "
            f"{row['chars']} | {row['sha'][:16]} |\n")
    tts_tr._atomic_bytes(path, (text + line).encode("utf-8"))


def run_en(pieces: list[EnPiece], en: dict, client: Callable[[str, dict], dict] | None, cap: int | None,
           ledger: Path, now: Callable[[], datetime] | None = None, log=print) -> tuple[int, int]:
    """ElevenLabs (Sarah) zaman damgalı; ödenmiş ham çıktı `_raw/parca-en/`. Aynı ifade bir kez ücretlenir."""
    now = now or (lambda: datetime.now(timezone.utc))
    chars = calls = 0
    for p in pieces:
        if p.raw_mp3().exists() and p.raw_json().exists():
            continue
        if cap is None:
            raise EpisodeTtsError("İngilizce aylık karakter tavanı tanımlı değil; ücretli üretim kapalı")
        month = tts.month_key(now())
        used = tts.ledger_used(ledger, month)
        if used + len(p.text) > cap:
            raise EpisodeTtsError(f"İngilizce aylık tavan aşılır: {used} + {len(p.text)} > {cap}; {p.id} üretilmedi")
        resp = client(en["voiceId"], tts.payload(p.text, en["modelId"], float(en["speed"])))
        if "audio_base64" not in resp or "alignment" not in resp:
            raise EpisodeTtsError(f"{p.id}: ElevenLabs yanıtında audio_base64/alignment yok")
        # Ödeme yapıldı: önce defter ve kayıt, sonra önbellek (çift ücret olmasın).
        tts.ledger_add(ledger, month, len(p.text))
        append_en_prompts(p.prompts, {"date": now().strftime("%Y-%m-%dT%H:%M:%SZ"), "segment": p.id,
                                      "voice": f"{en['name']} {en['voiceId']}", "model": en["modelId"],
                                      "speed": en["speed"], "chars": len(p.text), "sha": text_sha256(p.text)})
        tts_tr._atomic_bytes(p.raw_mp3(), base64.b64decode(resp["audio_base64"]))
        tts_tr._atomic_bytes(p.raw_json(), (json.dumps({"text": p.text, "alignment": resp["alignment"]},
                                                       ensure_ascii=False) + "\n").encode("utf-8"))
        chars += len(p.text)
        calls += 1
        log(f"  {p.id}: ElevenLabs {len(p.text)} karakter ({p.text!r})")
    return chars, calls


# --- birleştirme (b kipi) -------------------------------------------------------------------------

@dataclass
class PartAudio:
    lang: str
    text: str
    src: Path
    al: Alignment
    duration: float
    key: str
    quality: dict | None = None


def _edges(env: list[float], duration: float) -> tuple[float, float]:
    if not env or max(env) <= 0:
        return 0.0, duration
    thr = EDGE_REL * max(env)
    first = next(i for i, v in enumerate(env) if v >= thr)
    last = len(env) - 1 - next(i for i, v in enumerate(reversed(env)) if v >= thr)
    return max(0.0, first * 0.01 - LEAD_PAD), min(duration, (last + 1) * 0.01 + TAIL_PAD)


def _voiced_db(env: list[float]) -> float | None:
    import math
    if not env or max(env) <= 0:
        return None
    thr = VOICED_REL * max(env)
    v = [x for x in env if x >= thr]
    ms = sum(x * x for x in v) / len(v)
    return 10 * math.log10(ms) if ms > 0 else None


def trim_alignment(al: Alignment, start: float, end: float) -> Alignment:
    span = max(0.0, end - start)
    clamp = lambda t: min(max(t - start, 0.0), span)  # noqa: E731
    return Alignment(list(al.chars), [clamp(s) for s in al.starts], [clamp(e) for e in al.ends])


def assemble(parts: list[PartAudio], gap: float, out_mp3: Path, work: Path,
             finalize: Callable[[Path, Path], float | None] | None = None) -> tuple[Alignment, list[dict], float | None]:
    """Parçaları kırpar, İngilizceyi Türkçenin ses düzeyine getirir, `gap` boşlukla birleştirir, -16 LUFS mp3."""
    from . import media
    rows, gains = [], []
    envs = [media.envelope(p.src) for p in parts]
    tr_db = [d for p, e in zip(parts, envs) if p.lang == "tr" and (d := _voiced_db(e)) is not None]
    en_db = [d for p, e in zip(parts, envs) if p.lang == "en" and (d := _voiced_db(e)) is not None]
    en_gain = (sum(tr_db) / len(tr_db) - sum(en_db) / len(en_db)) if tr_db and en_db else 0.0
    trimmed = []
    for p, env in zip(parts, envs):
        s, e = _edges(env, p.duration)
        g = en_gain if p.lang == "en" else 0.0
        gains.append(g)
        trimmed.append((trim_alignment(p.al, s, e), e - s))
        rows.append({"lang": p.lang, "text": p.text, "key": p.key, "trim": [round(s, 3), round(e, 3)],
                     "gainDb": round(g, 2), **({"quality": p.quality} if p.quality else {})})
    work.mkdir(parents=True, exist_ok=True)
    wav = work / f"{out_mp3.stem}.birlesik.wav"
    cmd = ["ffmpeg", "-y", "-loglevel", "error"]
    for p in parts:
        cmd += ["-i", str(p.src)]
    flt = ""
    for k, (p, r) in enumerate(zip(parts, rows)):
        s, e = r["trim"]
        pad = f",apad=pad_dur={gap}" if k < len(parts) - 1 else ""
        flt += (f"[{k}:a]atrim=start={s}:end={e},asetpts=PTS-STARTPTS,aresample=44100,"
                f"aformat=channel_layouts=mono,volume={gains[k]:.2f}dB{pad}[p{k}];")
    flt += "".join(f"[p{k}]" for k in range(len(parts))) + f"concat=n={len(parts)}:v=0:a=1[a]"
    media.run(cmd + ["-filter_complex", flt, "-map", "[a]", "-c:a", "pcm_s16le", str(wav)])
    al = concat_alignments(trimmed, gap, " ")
    lufs = (finalize or tts_tr.finalize_audio)(wav, out_mp3)
    wav.unlink(missing_ok=True)
    return al, rows, lufs


def _merge_quality(rows: list[dict]) -> dict:
    qs = [r["quality"] for r in rows if r.get("quality")]
    keys = ("words", "exact", "fuzzy", "weak", "missing", "extraHeard")
    q = {k: sum(int(x.get(k, 0)) for x in qs) for k in keys}
    q["worstRun"] = max((int(x.get("worstRun", 0)) for x in qs), default=0)
    q["score"] = round((q["exact"] + q["fuzzy"]) / q["words"], 3) if q["words"] else 1.0
    q["warnings"] = [w for x in qs for w in x.get("warnings", [])]
    q["ok"] = all(x.get("ok", True) for x in qs)
    q["englishWords"] = sum(len(r["text"].split()) for r in rows if r["lang"] == "en")
    return q


def backup_old(it: Item, log=print) -> None:
    """Eski (ElevenLabs) Türkçe sesi silmeden `_raw/elevenlabs/`e taşır. İdempotent."""
    mp3, al = it.audio(), it.align()
    if not al.exists() or _is_alania(al):
        return
    dst = it.out_dir / RAW / BACKUP
    dst.mkdir(parents=True, exist_ok=True)
    for f in (mp3, al):
        if f.exists() and not (dst / f.name).exists():
            shutil.copy2(f, dst / f.name)
            log(f"  yedek: {f.name} → {dst.relative_to(it.out_dir.parent) if it.out_dir.parent in dst.parents else dst}")


def write_item_tr(ip: ItemPlan, vm: VoiceMap) -> None:
    """tr/a kipi: tts_tr çıktısına rol ve kip bilgisi eklenir (hizalama metni = düz metin)."""
    it = ip.item
    d = json.loads(it.align().read_text(encoding="utf-8"))
    d.update({"role": it.role, "speaker": vm.role(it.role)["speaker"], "variant": it.mode,
              "speech": it.speech})
    tts_tr._atomic_bytes(it.align(), (json.dumps(d, ensure_ascii=False) + "\n").encode("utf-8"))


def build_mixed(ip: ItemPlan, vm: VoiceMap, out_mp3: Path | None = None, out_align: Path | None = None,
                finalize=None) -> dict:
    """b kipi: parçalar önbellekte hazır olmalı (run_tr + run_en)."""
    from . import media
    it = ip.item
    parts: list[PartAudio] = []
    for lang, n in ip.order:
        if lang == "tr":
            tp = ip.tr[n]
            aj = json.loads((tp.out_dir / f"{tp.seg.id}.align.json").read_text(encoding="utf-8"))
            if aj.get("key") != tp.key:
                raise EpisodeTtsError(f"{tp.seg.id}: parça hizalaması eski")
            parts.append(PartAudio("tr", tp.seg.text, tp.raw_wav(), _al(aj), tts_tr.wav_duration(tp.raw_wav().read_bytes()),
                                   tp.key, aj.get("quality")))
        else:
            ep = ip.en[n]
            aj = json.loads(ep.raw_json().read_text(encoding="utf-8"))
            parts.append(PartAudio("en", ep.text, ep.raw_mp3(), _al(aj), media.probe_duration(ep.raw_mp3()), ep.key))
    for p, tail in zip(parts, ip.tails):
        if tail:   # seslendirilmeyen noktalama: parçanın sonunda sıfır süre
            p.text += tail
            p.al = Alignment(p.al.chars + list(tail), p.al.starts + [p.al.end] * len(tail),
                             p.al.ends + [p.al.end] * len(tail))
    out_mp3 = out_mp3 or it.audio()
    out_align = out_align or it.align()
    al, rows, lufs = assemble(parts, vm.gap, out_mp3, it.out_dir / RAW / "birlestirme", finalize)
    text = it.text
    if "".join(al.chars) != text:
        raise EpisodeTtsError(f"{it.stem}: birleşik hizalama metni düz metinle uyuşmuyor")
    role = vm.role(it.role)
    doc = {"text": text, "textSha256": text_sha256(text), "key": ip.key, "lang": "tr", "variant": "b",
           "role": it.role, "speaker": role["speaker"], "speech": it.speech,
           "model_id": vm.model, "voice_id": role["voice"], "timing": "duyu-1+elevenlabs",
           "en": {"voiceId": vm.en["voiceId"], "name": vm.en["name"], "modelId": vm.en["modelId"],
                  "speed": vm.en["speed"]},
           "gap": vm.gap, "duration": round(al.end, 3), "loudnessLufs": lufs,
           "quality": _merge_quality(rows), "parts": rows, "alignment": alignment_json(al)}
    tts_tr._atomic_bytes(out_align, (json.dumps(doc, ensure_ascii=False) + "\n").encode("utf-8"))
    return doc


def _al(aj: dict) -> Alignment:
    a = aj["alignment"]
    return Alignment(list(a["characters"]), list(a["character_start_times_seconds"]),
                     list(a["character_end_times_seconds"]))


# --- kaynak güncelleme ---------------------------------------------------------------------------

def _scan(text: str, i: int, path: tuple, spans: dict) -> int:
    """JSON değerini tarar; nesnelerin (başlangıç, bitiş) konumlarını yol → konum olarak yazar."""
    ws = " \t\r\n"
    while text[i] in ws:
        i += 1
    c = text[i]
    if c == "{":
        start = i
        i += 1
        while True:
            while text[i] in ws:
                i += 1
            if text[i] == "}":
                spans[path] = (start, i)
                return i + 1
            if text[i] == ",":
                i += 1
                continue
            j = _scan_string(text, i)
            key = json.loads(text[i:j])
            i = j
            while text[i] in ws + ":":
                i += 1
            i = _scan(text, i, path + (key,), spans)
    if c == "[":
        i += 1
        n = 0
        while True:
            while text[i] in ws:
                i += 1
            if text[i] == "]":
                return i + 1
            if text[i] == ",":
                i += 1
                continue
            i = _scan(text, i, path + (n,), spans)
            n += 1
    if c == '"':
        return _scan_string(text, i)
    j = i
    while j < len(text) and text[j] not in ",]}" + ws:
        j += 1
    return j


def _scan_string(text: str, i: int) -> int:
    j = i + 1
    while text[j] != '"':
        j += 2 if text[j] == "\\" else 1
    return j + 1


def insert_key(text: str, path: tuple, key: str, value) -> str:
    """El biçimli JSON'da (kurgu.json) `path` nesnesinin sonuna `"key": value` ekler; biçim korunur.
    Sonuç yeniden okunup doğrulanır."""
    spans: dict = {}
    _scan(text, 0, (), spans)
    if path not in spans:
        raise EpisodeTtsError(f"JSON yolu yok: {path}")
    start, end = spans[path]
    body = text[start + 1:end]
    k = len(body.rstrip())
    sep = ", " if body.strip() else ""
    frag = f'{sep}"{key}": {json.dumps(value, ensure_ascii=False)}'
    if "\n" in body[k:]:   # çok satırlı nesne: son üyenin ardına
        new = text[:start + 1] + body[:k] + frag + body[k:] + text[end:]
    else:
        new = text[:start + 1] + body[:k] + frag + text[end:]
    before = json.loads(text)
    after = json.loads(new)
    obj = before
    for p in path:
        obj = obj[p]
    obj[key] = value
    if after != before:
        raise EpisodeTtsError(f"JSON güncellemesi doğrulanamadı: {path}")
    return new


def update_sources(items: list[Item], vm: VoiceMap, log=print) -> list[str]:
    """Sesi hazır olup kaynağında başvurusu olmayan yerlere `audio` ekler (kurgu.json: el biçimi korunur;
    Hi verisi: `audio` = `hi-ses/<ad>.mp3`). Dönüş: değişen dosyalar."""
    changed: dict[Path, str] = {}
    hi_docs: dict[Path, dict] = {}
    for it in items:
        if not (it.audio().exists() and it.align().exists()):
            continue
        kind = it.target[0]
        if kind == "kurgu" and not it.has_ref:
            _, kp, jpath = it.target
            text = changed.get(kp) or kp.read_text(encoding="utf-8")
            ref = {"id": it.stem, "speaker": vm.role(it.role)["speaker"]}
            changed[kp] = insert_key(text, jpath, "audio", ref)
            log(f"  {it.where}: kurgu.json audio → {it.stem}")
        elif kind == "hi":
            _, p, key, eid = it.target
            d = hi_docs.setdefault(p, json.loads(p.read_text(encoding="utf-8")))
            want = f"{HI_AUDIO_DIR.name}/{it.stem}.mp3"
            for e in d.get(key) or []:
                if e["id"] == eid and e.get("audio") != want:
                    e["audio"] = want
                    changed[p] = ""
                    log(f"  {it.where}: audio → {want}")
    for p, text in changed.items():
        if p in hi_docs:
            text = json.dumps(hi_docs[p], ensure_ascii=False, indent=2) + "\n"
        tts_tr._atomic_bytes(p, text.encode("utf-8"))
    return [str(p) for p in changed]


# --- denetim (content-lint) ----------------------------------------------------------------------

def check_items(items: list[Item]) -> list[tuple[str, str, str]]:
    """(düzey, kod, mesaj). Ses yok → uyarı; Alania dışı ses → uyarı; metin değişti → hata;
    işaretlenmemiş İngilizce şüphesi → uyarı; işaret hatası → hata."""
    out = []
    for it in items:
        try:
            text = it.text
        except EpisodeTtsError as e:
            out.append(("error", "tr-voice", f"{it.where}: {e}"))
            continue
        if it.mode == "tr" and _EN_HINT.search(it.speech) and not it.speech.startswith("Açık soru"):
            m = _EN_HINT.search(it.speech)
            out.append(("warning", "tr-voice", f"{it.where}: Türkçe seste işaretlenmemiş İngilizce olabilir "
                                               f"(\"{m.group(0)}\"); speechTr içinde {{…}} ile işaretleyin"))
        if not it.align().exists():
            out.append(("warning", "tr-voice", f"{it.where}: Türkçe ses yok ({it.stem}; tts_episode_tr.py)"))
            continue
        try:
            d = json.loads(it.align().read_text(encoding="utf-8"))
        except ValueError:
            out.append(("error", "tr-voice", f"{it.where}: {it.align().name} okunamadı"))
            continue
        if not _is_alania(it.align()):
            out.append(("warning", "tr-voice", f"{it.where}: ses Alania değil ({d.get('voice_id')}; H-083)"))
        elif d.get("text") != text:
            out.append(("error", "tr-voice", f"{it.where}: ses metni güncel değil (\"{d.get('text')}\" ≠ \"{text}\"); "
                                             "tts_episode_tr.py --execute"))
        elif not (d.get("quality") or {}).get("ok", True):
            out.append(("warning", "tr-voice", f"{it.where}: Duyu hizalaması zayıf ({d['quality'].get('score')})"))
        if it.target[0] == "kurgu" and not it.has_ref:
            out.append(("warning", "tr-voice", f"{it.where}: ses var ama kurgu.json'da audio yok "
                                               "(tts_episode_tr.py --execute ekler)"))
    return out


def load_en_key(key_file: Path) -> None:
    """ElevenLabs anahtarını (repo dışı dosya) ortama koyar; hiçbir yere yazmaz."""
    if os.environ.get(tts.ENV_KEY):
        return
    f = tts_tr._read_env_file(Path(key_file).expanduser())
    if f.get(tts.ENV_KEY):
        os.environ[tts.ENV_KEY] = f[tts.ENV_KEY]


def en_ledger(vm: VoiceMap) -> Path:
    return REPO_ROOT / vm.en["ledger"]
