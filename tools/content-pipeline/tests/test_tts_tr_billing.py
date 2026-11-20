"""H-108: Türkçe ses araçlarında gerçek ücret durumu (PatientDesk GET /v1/usage). Ağ yok: sahte okuyucu."""

from __future__ import annotations

import json
import socket
from datetime import datetime, timezone

import pytest

from hvpipeline import tts_tr as tr

SECRET = "pd_test_DO_NOT_WRITE_0123456789"
USER_ID = "6f1c2d3e-0000-4abc-9def-112233445566"
SAMPLE = {"user_id": USER_ID, "used_seconds": 54399.07, "quota_seconds": 3600000.0,
          "remaining_seconds": 3545600.93, "free": False, "free_until": "2026-11-14T10:57:10.816679+00:00"}
NOW = datetime(2026, 11, 20, 12, 0, tzinfo=timezone.utc)
BEFORE = datetime(2026, 11, 1, 12, 0, tzinfo=timezone.utc)


class FakeFetch:
    """`fetch(url, headers, connect_timeout, read_timeout) -> (status, body)`; çağrıları kaydeder."""

    def __init__(self, status=200, body=None, exc=None):
        self.status, self.exc, self.calls = status, exc, []
        self.body = json.dumps(SAMPLE).encode() if body is None else body

    def __call__(self, url, headers, connect_timeout, read_timeout):
        self.calls.append((url, headers, connect_timeout, read_timeout))
        if self.exc:
            raise self.exc
        return self.status, self.body


@pytest.fixture
def online(monkeypatch, tmp_path):
    """Çevrimdışı anahtarı kaldırılır, anahtar ortamdan gelir (gerçek ağ yine kullanılmaz: sahte okuyucu)."""
    monkeypatch.delenv(tr.ENV_OFFLINE, raising=False)
    monkeypatch.setenv(tr.ENV_KEY, SECRET)
    monkeypatch.delenv(tr.ENV_URL, raising=False)
    return tmp_path / "yok.env"


def body(**over):
    d = dict(SAMPLE)
    d.update(over)
    return json.dumps(d).encode()


# --- okuma ---------------------------------------------------------------------------------------

def test_parses_sample_and_uses_timeouts(online):
    f = FakeFetch()
    s = tr.billing_status(fetch=f, key_file=online)
    assert s.known and s.fetched and s.free is False
    assert s.free_until == datetime(2026, 11, 14, 10, 57, 10, 816679, tzinfo=timezone.utc)
    assert s.remaining_seconds == pytest.approx(3545600.93) and s.quota_seconds == pytest.approx(3600000.0)
    (url, headers, ct, rt), = f.calls
    assert url == "https://voice.patientdesk.ai/v1/usage"
    assert headers["Authorization"] == f"Bearer {SECRET}"
    assert (ct, rt) == (2.0, 5.0)
    assert USER_ID not in repr(s) and SECRET not in repr(s)


def test_free_true_before_and_after_free_until(online):
    s = tr.billing_status(fetch=FakeFetch(body=body(free=True)), key_file=online)
    assert s.known and s.free is True
    assert s.is_free(BEFORE) is True
    assert s.is_free(NOW) is False          # süre dolmuş: sunucu "free" dese de ücretli varsayılır


def test_unknown_without_key(monkeypatch, tmp_path):
    monkeypatch.delenv(tr.ENV_OFFLINE, raising=False)
    monkeypatch.delenv(tr.ENV_KEY, raising=False)
    f = FakeFetch()
    s = tr.billing_status(fetch=f, key_file=tmp_path / "yok.env")
    assert not s.known and not s.fetched and "anahtar" in s.reason and f.calls == []


def test_unknown_on_http_url(online, monkeypatch):
    monkeypatch.setenv(tr.ENV_URL, "http://voice.patientdesk.ai")
    f = FakeFetch()
    s = tr.billing_status(fetch=f, key_file=online)
    assert not s.known and "https" in s.reason and f.calls == []


@pytest.mark.parametrize("exc,word", [(socket.timeout("timed out"), "zaman aşımı"),
                                      (TimeoutError(), "zaman aşımı"),
                                      (ConnectionRefusedError(f"bağlantı {SECRET}"), "ağ hatası"),
                                      (ValueError(f"tuhaf {SECRET}"), "beklenmeyen")])
def test_unknown_on_network_errors(online, exc, word):
    s = tr.billing_status(fetch=FakeFetch(exc=exc), key_file=online)
    assert not s.known and s.fetched and word in s.reason and SECRET not in s.reason


def test_unknown_on_http_401_and_500(online):
    s = tr.billing_status(fetch=FakeFetch(status=401, body=f'{{"detail": "bad key {SECRET}"}}'.encode()),
                          key_file=online)
    assert not s.known and "HTTP 401" in s.reason and SECRET not in s.reason
    s = tr.billing_status(fetch=FakeFetch(status=500, body=b"oops"), key_file=online)
    assert not s.known and "HTTP 500" in s.reason


@pytest.mark.parametrize("raw", [b"not json", b"[]", body(free="hayir"), body(free_until="dun"),
                                 json.dumps({"user_id": USER_ID}).encode(), body(remaining_seconds="x")])
def test_unknown_on_bad_json(online, raw):
    s = tr.billing_status(fetch=FakeFetch(body=raw), key_file=online)
    assert not s.known and "yanıt" in s.reason and USER_ID not in s.reason


def test_offline_env_skips_fetch(monkeypatch, tmp_path):
    monkeypatch.setenv(tr.ENV_OFFLINE, "1")
    monkeypatch.setenv(tr.ENV_KEY, SECRET)
    f = FakeFetch()
    s = tr.billing_status(fetch=f, key_file=tmp_path / "yok.env")
    assert not s.known and not s.fetched and s.reason == "çevrimdışı" and f.calls == []
    monkeypatch.delenv(tr.ENV_OFFLINE)
    s = tr.billing_status(fetch=f, key_file=tmp_path / "yok.env", offline=True)
    assert s.reason == "çevrimdışı" and f.calls == []


def test_default_fetch_errors_never_raise(online, monkeypatch):
    """Varsayılan okuyucu da hiçbir zaman yukarı istisna fırlatmaz (bağlantı kurulamazsa bilinmeyen)."""
    def boom(*a, **k):
        raise OSError("ağ yok")
    monkeypatch.setattr(tr, "_http_get", boom)
    s = tr.billing_status(key_file=online)
    assert not s.known and "ağ hatası" in s.reason


# --- biçim ---------------------------------------------------------------------------------------

def known(**over) -> tr.BillingStatus:
    d = dict(known=True, fetched=True, free=False,
             free_until=datetime(2026, 11, 14, 10, 57, tzinfo=timezone.utc),
             remaining_seconds=3545600.93, quota_seconds=3600000.0)
    d.update(over)
    return tr.BillingStatus(**d)


def test_cost_line_paid():
    line = tr.cost_text(173, 0, known(), now=NOW)
    assert line.startswith("≈ 0.13 TL ödenecek (ücretsiz dönem 14.11.2026 bitti)")
    assert "kalan Duyu kotası ≈ 985 saat" in line
    assert "ücretsiz)" not in line and "kampanya" not in line


def test_cost_line_free_and_expired_free():
    line = tr.cost_text(173, 0, known(free=True), now=BEFORE)
    assert line.startswith("ücretsiz (PatientDesk: 14.11.2026 tarihine kadar")
    line = tr.cost_text(173, 0, known(free=True), now=NOW)
    assert "≈ 0.13 TL ödenecek (ücretsiz dönem 14.11.2026 bitti)" in line


def test_cost_line_paid_without_date_and_without_quota():
    line = tr.cost_text(173, 0, known(free_until=None, remaining_seconds=None), now=NOW)
    assert line == "≈ 0.13 TL ödenecek (ücretli dönem)"


def test_cost_line_unknown():
    s = tr.BillingStatus(known=False, fetched=True, reason="zaman aşımı")
    assert tr.cost_text(173, 0, s, now=NOW) == \
        "≈ 0.13 TL (ücret durumu doğrulanamadı: zaman aşımı; ücretli varsayıldı)"


def test_dry_run_note_says_what_happened():
    assert tr.dry_run_note(known()) == "üretim çağrısı yapılmadı; yalnız ücret durumu okundu (GET /v1/usage)"
    assert tr.dry_run_note(tr.BillingStatus(known=False, fetched=True, reason="HTTP 401")) == \
        "üretim çağrısı yapılmadı; ücret durumu okunamadı (GET /v1/usage)"
    assert tr.dry_run_note(tr.BillingStatus(known=False, fetched=False, reason="çevrimdışı")) == \
        "hiçbir API çağrısı yapılmadı"


def test_end_to_end_line_never_leaks(online):
    s = tr.billing_status(fetch=FakeFetch(), key_file=online)
    out = tr.cost_text(1000, 3600, s, now=NOW) + tr.dry_run_note(s) + repr(s)
    assert USER_ID not in out and SECRET not in out


# --- CLI'ler: kuru çalışma yeni satırı yazar ------------------------------------------------------

PAID = known()


def test_cli_tts_tr_dry_run_prints_status(tmp_path, capsys, monkeypatch):
    import tts_tr
    monkeypatch.delenv(tr.ENV_CAP, raising=False)
    p = tmp_path / "d.json"
    p.write_text(json.dumps([{"id": "s01", "text": "Merhaba."}]), encoding="utf-8")
    assert tts_tr.main([str(p), "--ledger", str(tmp_path / "l.json")], billing=PAID) == 0
    out = capsys.readouterr().out
    assert "TL ödenecek (ücretsiz dönem 14.11.2026 bitti)" in out and "kalan Duyu kotası" in out
    assert "yalnız ücret durumu okundu" in out and "ilk ay" not in out and "API çağrılmadı" not in out


def test_cli_offline_flag(tmp_path, capsys, monkeypatch):
    import tts_tr
    monkeypatch.delenv(tr.ENV_OFFLINE, raising=False)
    monkeypatch.setattr(tr, "_http_get", lambda *a, **k: (_ for _ in ()).throw(AssertionError("ağ!")))
    p = tmp_path / "d.json"
    p.write_text(json.dumps([{"id": "s01", "text": "Merhaba."}]), encoding="utf-8")
    assert tts_tr.main([str(p), "--ledger", str(tmp_path / "l.json"), "--offline"]) == 0
    out = capsys.readouterr().out
    assert "ücret durumu doğrulanamadı: çevrimdışı; ücretli varsayıldı" in out
    assert "hiçbir API çağrısı yapılmadı" in out


def test_tests_run_offline_by_default():
    """conftest: testler ve CI ağa çıkmaz."""
    import os
    assert os.environ.get(tr.ENV_OFFLINE) == "1"


def test_review_findings_never_raise_and_reject_nonfinite():
    from hvpipeline import tts_tr as tr
    deep = tr._parse_usage(b"[" * 65536)
    assert deep.known is False
    inf = tr._parse_usage(b'{"free": false, "remaining_seconds": 1e400}')
    assert inf.known is False
    neg = tr._parse_usage(b'{"free": false, "quota_seconds": -5}')
    assert neg.known is False
