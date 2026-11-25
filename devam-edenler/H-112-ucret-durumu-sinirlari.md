# H-112: Ücret durumu okumasının iki bilinen sınırı (H-108 devamı)

- **Durum:** Devam ediyor (2026-11-25): uygulandı, qa-code-reviewer bulgusu düzeltildi, pytest 451; commit onayı bekliyor.
- **Tür:** Araç düzeltmesi (`tools/content-pipeline`)
- **Öncelik:** Düşük
- **Bağımlılık:** H-108

## Sorun (H-108 "Bilinen sınır")
1. 2 sn bağlantı / 5 sn okuma süreleri DNS çözümlemesini ve yanıtın tamamını kapsamıyordu; kuru çalışma 7 sn'den uzun bekleyebiliyordu.
2. Ücretli Türkçe iş yokken de (ör. `tts_lesson.py --lang en`) `GET /v1/usage` okunuyordu.

## Yapılan
- `hvpipeline/tts_tr.py`: `USAGE_TOTAL_TIMEOUT = 8.0`; okuma `_with_deadline` ile ayrı (daemon) iş parçacığında, süre
  aşılırsa durum "zaman aşımı" ve ücretli varsayılır. Hatalar eskisi gibi eşlenir; "hiç fırlatmaz" sözleşmesi korunur.
- `work_needed(chars, stt_seconds)`: Alania karakteri **ya da** Duyu hizalaması (ses saatiyle ücretli) varsa iş var.
  `billing_status(needed=False)` ağa çıkmaz; `cost_text` "0 TL (Türkçe üretim yok; ücret durumu okunmadı)" yazar.
- Dört araç (`tts_lesson.py`, `tts_tr.py`, `tts_book_tr.py`, `tts_episode_tr.py`) `needed=` ile çağırır.

## Doğrulama
- 6 yeni test (`tests/test_tts_tr_billing.py`): asılı okumada toplam süre, varsayılan sınır, ağ hatası eşlemesi,
  iş yokken okumama, `work_needed`, CLI'nin ağa dokunmaması. pytest **450** geçti.
- Gerçek kuru çalışma: `tts_lesson.py dilbilgisi/G-B1-02-… --lang en` → "Ücret: 0 TL (Türkçe üretim yok; ücret durumu
  okunmadı)", "hiçbir API çağrısı yapılmadı", ağ çağrısı 0.

## Kod incelemesi (qa-code-reviewer, 2026-11-25)
- **MAJOR (düzeltildi):** `tts_episode_tr.py` işi `totals().tr_chars` ile ölçüyordu; Alania WAV'ı önbellekte olup Duyu'su
  yarıda kalan parçalar görünmüyordu → kuru çalışma "Türkçe üretim yok" diyecekti, `--execute` ise ücretli Duyu çağıracaktı.
  Aynı yolda ikinci hata: yalnız Duyu işi kalınca istemci kurulmuyor, `--execute` `None.transcribe` ile çöküyordu.
  Düzeltme: `hvpipeline/tts_episode_tr.py` `tr_plans()` / `tr_work()` — `run_tr` ile aynı planlardan karakter + Duyu
  saniyesi; ücret satırı, ücret okuma, Türkçe tavan denetimi ve istemci kurulumu buna bağlı. Test:
  `test_duyu_only_work_is_priced_and_executed` (düzeltme geri alınınca kırmızı).
- Diğer çağıranlar (`tts_tr.py`, `tts_book_tr.py`, `tts_lesson.py`) zaten `Plan.est_stt_seconds` kullanıyor; temiz.

## Codex kancasının bulguları (önceden var olan kod; bu işte değiştirilmedi)
Kanca, değişen dosyalardaki eski kodu da taradı. Proje kuralı "ilgisiz refactor yapılmaz" gereği bu işe katılmadı;
kullanıcıya ayrı küçük iş olarak önerildi: (1) `_dp_align` O(n·m) — 5.000 karakter sınırıyla ≈ 800×800 hücre, sorun
değil; (2) aylık tavan denetimi + defter yazımı kilitsiz — eşzamanlı iki koşu tavanı aşabilir (tek kişi elle
çalıştırıyor; dosya kilidi önerilir); (3) JSON `instructions` metin değilse `TypeError`; (4) Duyu zamanları sonlu/
süre içinde mi denetlenmiyor; (5) `tts_episode_tr.py` yürütmede `OSError` yakalanmıyor (çıktı traceback).

## Geri alma
İlgili commit `git revert`.
