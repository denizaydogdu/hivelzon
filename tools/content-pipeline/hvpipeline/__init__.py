"""hiVelzon içerik boru hattı: bölüm paketi dışa aktarma ve content-lint (H-034).

Kaynak: oturum içi geçici kurgu araçları (kurgu.py v3, bolum_yardimci.py, cefr_check.py; H-024 pilotu).
"""

from pathlib import Path

__version__ = "0.1.0"

PIPELINE_ROOT = Path(__file__).resolve().parent.parent
REPO_ROOT = PIPELINE_ROOT.parent.parent
SCHEMA_DIR = PIPELINE_ROOT / "schema"
DATA_DIR = PIPELINE_ROOT / "data"
