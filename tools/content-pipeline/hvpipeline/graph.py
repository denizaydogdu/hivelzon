"""scenes.json şema ve grafik denetimleri (OYUN-TASARIMI §8.2, §12.4; K-27, K-28, K-29)."""

from __future__ import annotations

import json
from collections import Counter, deque
from dataclasses import dataclass
from functools import lru_cache

from . import SCHEMA_DIR
from .jsonschema_lite import Validator

MAX_FLAGS = 3
MAX_DECISIONS = {"A1": 4, "A2": 4}
MAX_OPTIONS = {"A1": 3, "A2": 3}
RETURN_HOPS = 4
MAX_RECAP_SECONDS = 15.0


@dataclass(frozen=True)
class Issue:
    level: str  # "error" | "warning"
    code: str
    message: str

    def __str__(self) -> str:
        tag = "HATA" if self.level == "error" else "UYARI"
        return f"{tag} [{self.code}] {self.message}"


@lru_cache(maxsize=4)
def load_schema(name: str = "scenes.schema.json") -> dict:
    return json.loads((SCHEMA_DIR / name).read_text(encoding="utf-8"))


def schema_errors(doc: dict, name: str = "scenes.schema.json") -> list[str]:
    return Validator(load_schema(name)).errors(doc)


def successors(node: dict) -> list[str]:
    out = []
    if node.get("type") == "decision":
        out += [o.get("next") for o in node.get("options", [])]
    else:
        out.append(node.get("next"))
    return [n for n in out if n]


def check_scenes(doc: dict) -> list[Issue]:
    issues: list[Issue] = []
    E = lambda c, m: issues.append(Issue("error", c, m))  # noqa: E731
    W = lambda c, m: issues.append(Issue("warning", c, m))  # noqa: E731

    for msg in schema_errors(doc):
        E("schema", msg)

    nodes = doc.get("nodes") or []
    ids = [n.get("id") for n in nodes if isinstance(n, dict)]
    for nid, c in Counter(ids).items():
        if c > 1:
            E("duplicate-id", f"düğüm kimliği tekrar ediyor: {nid}")
    by_id = {n.get("id"): n for n in nodes if isinstance(n, dict)}
    start = doc.get("start")
    if start not in by_id:
        E("start", f"başlangıç düğümü yok: {start}")
        return issues

    # Kopuk bağlantılar
    for n in nodes:
        for s in successors(n):
            if s not in by_id:
                E("dangling", f"{n.get('id')}: var olmayan düğüme gidiyor: {s}")

    # Ulaşılabilirlik
    seen = {start}
    q = deque([start])
    while q:
        cur = by_id.get(q.popleft())
        if not cur:
            continue
        for s in successors(cur):
            if s in by_id and s not in seen:
                seen.add(s)
                q.append(s)
    for nid in ids:
        if nid not in seen:
            E("unreachable", f"ulaşılamayan düğüm: {nid}")

    # Her ulaşılabilir düğümden bölüm sonuna yol olmalı (çıkışsız döngü yok)
    ends = {nid for nid, n in by_id.items() if n.get("type") != "decision" and n.get("next") is None}
    if not ends:
        E("no-end", "bölüm sonu (next: null) olan düğüm yok")
    rev: dict[str, set[str]] = {nid: set() for nid in by_id}
    for nid, n in by_id.items():
        for s in successors(n):
            if s in rev:
                rev[s].add(nid)
    can_end = set(ends)
    q = deque(ends)
    while q:
        for p in rev.get(q.popleft(), ()):
            if p not in can_end:
                can_end.add(p)
                q.append(p)
    for nid in seen:
        if nid not in can_end:
            E("dead-end", f"{nid}: bu düğümden bölüm sonuna yol yok (çıkışsız döngü ya da çıkmaz)")

    # Açılış (H-050): her bölüm başlık ekranıyla açılır; başlıktan önce hiçbir şey yoktur.
    titles = [n.get("id") for n in nodes if n.get("type") == "title"]
    if by_id[start].get("type") != "title":
        E("title-start", f"başlangıç düğümü ({start}) başlık ekranı (type: title) değil; her bölüm başlıkla açılır")
    if len(titles) > 1:
        E("title-start", f"birden çok başlık düğümü: {', '.join(titles)}")
    for t in titles:
        preds = sorted(rev.get(t, ()))
        if preds:
            E("title-first", f"başlıktan ({t}) önce gelen düğüm var: {', '.join(preds)}")
    for n in nodes:
        if n.get("type") != "recap":
            continue
        rid, dur = n.get("id"), n.get("duration") or 0
        if dur > MAX_RECAP_SECONDS:
            W("recap-length", f"{rid}: \"Önceki bölümde\" {dur:.1f} sn (en çok {MAX_RECAP_SECONDS:.0f} sn önerilir)")
        preds = rev.get(rid, set())
        if not preds or any(by_id[p].get("type") != "title" for p in preds):
            W("recap-position", f"{rid}: özet doğrudan başlık ekranından sonra gelmiyor")
    if by_id[start].get("type") != "title" and by_id[start].get("checkpoint") is not True:
        W("checkpoint", f"başlangıç düğümü ({start}) kontrol noktası değil")

    # Bayraklar (K-28)
    flags = {f.get("id"): f for f in doc.get("flags") or []}
    ext = {(f.get("episode"), f.get("id")): f for f in doc.get("externalFlags") or []}
    if len(flags) > MAX_FLAGS:
        E("flags", f"bölüm başına en fazla {MAX_FLAGS} kalıcı bayrak (bulunan {len(flags)})")
    set_flags: set[str] = set()

    level = (doc.get("episode") or {}).get("level", "A1")
    decisions = [n for n in nodes if n.get("type") == "decision"]
    if level in MAX_DECISIONS and len(decisions) > MAX_DECISIONS[level]:
        E("decisions", f"{level} için bölüm başına en fazla {MAX_DECISIONS[level]} karar anı (bulunan {len(decisions)})")

    for d in decisions:
        did = d.get("id")
        opts = d.get("options") or []
        if not any(o.get("correct") for o in opts):
            E("no-correct", f"{did}: doğru seçenek yok")
        if level in MAX_OPTIONS and len(opts) > MAX_OPTIONS[level]:
            W("options", f"{did}: {level} için 2-3 seçenek önerilir (bulunan {len(opts)})")
        for o in opts:
            sf = o.get("setFlag")
            if sf:
                f = flags.get(sf.get("flag"))
                set_flags.add(sf.get("flag"))
                if f is None:
                    E("flag-undeclared", f"{did}/{o.get('id')}: tanımsız bayrak {sf.get('flag')}")
                elif sf.get("value") not in f.get("values", []):
                    E("flag-value", f"{did}/{o.get('id')}: {sf.get('flag')} için geçersiz değer {sf.get('value')}")
            nxt = o.get("next")
            if o.get("correct"):
                if nxt == did:
                    E("correct-loop", f"{did}/{o.get('id')}: doğru seçenek aynı karara dönüyor")
                continue
            # Yanlış seçenek: tepki → (kart/tepki) → aynı karar
            first = by_id.get(nxt)
            if not first or first.get("type") != "reaction":
                E("wrong-no-reaction", f"{did}/{o.get('id')}: yanlış seçenek bir tepki düğümüne gitmiyor")
            path_ok = False
            cur, hops = nxt, 0
            while cur and hops <= RETURN_HOPS:
                if cur == did:
                    path_ok = True
                    break
                n = by_id.get(cur)
                if not n or n.get("type") not in ("reaction", "card"):
                    break
                cur, hops = n.get("next"), hops + 1
            if not path_ok:
                E("wrong-no-return", f"{did}/{o.get('id')}: yanlış seçenekten aynı karara dönüş yolu yok")
    if len(set_flags) > MAX_FLAGS:
        E("flags", f"bölümde {len(set_flags)} farklı bayrak yazılıyor (en fazla {MAX_FLAGS})")
    for fid in flags:
        if fid not in set_flags:
            W("flag-unused", f"bayrak tanımlı ama hiçbir seçenek yazmıyor: {fid}")

    for n in nodes:
        if n.get("type") == "reaction":
            tgt = by_id.get(n.get("next"))
            if tgt and tgt.get("type") not in ("decision", "reaction", "card"):
                W("reaction-next", f"{n.get('id')}: tepki bir karara dönmüyor ({n.get('next')})")
        for v in n.get("variants") or []:
            w = v.get("when") or {}
            key_ok = w.get("flag") in flags if not w.get("episode") else (w.get("episode"), w.get("flag")) in ext
            if not key_ok:
                E("flag-undeclared", f"{n.get('id')}: varyant tanımsız bayrağa bakıyor: {w}")
        if n.get("type") == "task":
            _check_task(n, E)

    # Bölüm kapısı (K-29)
    gate = doc.get("gate") or {}
    for crit, allowed in (("comprehension", {"task", "decision"}), ("targetPhrase", {"task", "decision"}),
                          ("activeTask", {"task"})):
        for gid in gate.get(crit) or []:
            g = by_id.get(gid)
            if g is None:
                E("gate", f"kapı ölçütü {crit}: düğüm yok: {gid}")
            elif g.get("type") not in allowed:
                E("gate", f"kapı ölçütü {crit}: {gid} türü {g.get('type')} olamaz")
            elif gid not in seen:
                E("gate", f"kapı ölçütü {crit}: {gid} ulaşılamıyor")
    return issues


def _check_task(n: dict, E) -> None:
    tid, kind = n.get("id"), n.get("kind")
    for it in n.get("items") or []:
        where = f"{tid}/{it.get('id')}"
        opts = it.get("options") or []
        correct = sum(1 for o in opts if o.get("correct"))
        if kind == "choice" and correct != 1:
            E("task", f"{where}: tek seçimli soruda tam 1 doğru seçenek olmalı (bulunan {correct})")
        if kind == "multiSelect" and correct < 1:
            E("task", f"{where}: çok seçimli soruda en az 1 doğru seçenek olmalı")
        if kind == "order" and sorted(it.get("tokens") or []) != sorted(it.get("answer") or []):
            E("task", f"{where}: sıralama cevabı verilen parçalarla aynı değil")
