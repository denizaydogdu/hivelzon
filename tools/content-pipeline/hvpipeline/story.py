"""story.en.md ayrıştırıcı: CEFR denetimine giren İngilizce satırları çıkarır.

İşaretler (A1-000-arrival/story.en.md başlığı):
- `**AD:**` İngilizce replik (denetime girer); `**AD (TR):**` Türkçe (girmez).
- `✓ "..."` / `✗ "..."` seçenekler (tırnak içi İngilizce denetime girer).
- `[TEPKİ] **AD:** ...` tepki replikleri (girer).
- `[YAZI] "..."` ekrandaki İngilizce metin (girer); `[YAZI-TR]` girmez.
- `>` ile başlayan satırlar (başlık, notlar) denetime girmez.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

SPEAKER_RE = re.compile(
    r"^\s*(?:-\s*)?(?:\[TEPKİ\]\s*)?\*\*([A-ZÇĞİÖŞÜ .()]+):\*\*\s*(.+)$"
)
OPTION_RE = re.compile(r'[✓✗]\s*\*?"([^"]+)"')
YAZI_RE = re.compile(r"^\s*(?:-\s*)?\[YAZI\]")
QUOTED_RE = re.compile(r'"([^"]+)"')


@dataclass(frozen=True)
class StoryLine:
    line_no: int
    kind: str  # speech | option | sign
    speaker: str | None
    text: str


def english_lines(text: str) -> list[StoryLine]:
    out: list[StoryLine] = []
    for no, raw in enumerate(text.splitlines(), start=1):
        if raw.lstrip().startswith(">"):
            continue
        m = SPEAKER_RE.match(raw)
        if m:
            speaker = m.group(1).strip()
            if "(TR)" in speaker:
                continue
            out.append(StoryLine(no, "speech", speaker, m.group(2).strip()))
            continue
        opts = OPTION_RE.findall(raw)
        if opts:
            out.extend(StoryLine(no, "option", None, q.strip()) for q in opts)
            continue
        if YAZI_RE.match(raw):
            out.extend(StoryLine(no, "sign", None, q.strip()) for q in QUOTED_RE.findall(raw))
    return out


def read_story(path: Path) -> list[StoryLine]:
    return english_lines(Path(path).read_text(encoding="utf-8"))


def header_field(text: str, label: str) -> str | None:
    """`> **Görev kartı:** ...` gibi başlık alanını düz metin olarak döndürür."""
    m = re.search(r"^>\s*\*\*" + re.escape(label) + r":\*\*\s*(.+)$", text, re.M)
    if not m:
        return None
    return re.sub(r"[*_]", "", m.group(1)).strip()
