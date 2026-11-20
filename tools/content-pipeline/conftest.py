import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import pytest  # noqa: E402


@pytest.fixture(autouse=True)
def _tr_tts_offline(monkeypatch):
    """H-108: Türkçe ses araçlarının kuru çalışması ücret durumunu PatientDesk'ten okur (GET /v1/usage).
    Testler ve CI ağa çıkmaz; gerçek okumayı sınayan testler sahte okuyucu verir."""
    monkeypatch.setenv("HIVELZON_TR_TTS_OFFLINE", "1")
