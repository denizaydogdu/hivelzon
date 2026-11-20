# H-108: Türkçe ses araçlarında gerçek ücret durumu

- **Durum:** 🔄 Uygulandı (2026-11-20), kullanıcı onayı ve commit bekliyor. Testler yeşil (pytest 417 → 443),
  gerçek kuru çalışmalar "ücretsiz dönem 14.11.2026 bitti" yazıyor. Commit/push yapılmadı.
- **Tür:** Araç düzeltmesi (içerik boru hattı, `tools/content-pipeline`)
- **Öncelik:** Orta (ücretli üretim kararı bayat "ücretsiz" metniyle verilmesin)
- **Bağımlılık:** H-075 (Alania + Duyu), H-083, H-104, H-105 · Alania kampanyasının 14 Kasım 2026'da bitmesi

## Sorun

Türkçe ses araçlarının (PatientDesk Alania + Duyu) kuru çalışması kampanya bittiği hâlde "Tahmini ≈ … TL
(kampanya döneminde ücretsiz)", "PatientDesk kampanyasında ücretsiz", "ilk ay ücretsiz" yazıyordu. Fiyat
sabitleri doğruydu (`TL_PER_1000_CHARS = 0.75`, `TL_PER_AUDIO_HOUR = 6.0`); metin bayattı. 2026-11-20 gecesi
19 kancanın üretiminde de araç çıktısı "ücretsiz" demişti (gerçek ≈ 2,44 TL).

## API bilgisi (kullanıcı 2026-11-20'de doğruladı)

`GET https://voice.patientdesk.ai/v1/usage`, başlık `Authorization: Bearer <PD_API_KEY>`. Yanıt alanları:
`user_id` (saklanmaz, yazılmaz), `used_seconds`, `quota_seconds`, `remaining_seconds`, `free`, `free_until`.
2026-11-20 örneği: `used_seconds` 54.399,07, `quota_seconds` 3.600.000, `remaining_seconds` 3.545.600,93,
`free: false`, `free_until: 2026-11-14T10:57:10.816679+00:00`. `used/remaining_seconds` Duyu saniyeleridir;
Alania karakter ücreti bu uçta görünmez (karakter sayısı yine yerel defterden).

## Kapsam

- `hvpipeline/tts_tr.py`:
  - `billing_status()` yalnız okuma yapan `GET /v1/usage` çağrısıdır. Mevcut anahtar okumasını kullanır
    (`PD_API_KEY`/`PD_API_URL`, `~/.config/hivelzon/patientdesk.env`, yalnız https). Bağlantı 2 sn, okuma
    5 sn (`http.client`), yönlendirme izlenmez, yanıt en çok 64 KB okunur.
  - Sonuç `BillingStatus` nesnesidir: `known`, `fetched`, `free`, `free_until`, `remaining_seconds`,
    `quota_seconds`, `reason`.
  - Hiç istisna fırlatmaz. Şu durumlarda `known=False` döner ve nedeni yazar: anahtar yok, https değil,
    zaman aşımı, ağ hatası, HTTP 401/403/5xx, geçersiz JSON, çevrimdışı.
  - `user_id` ve anahtar hiçbir çıktıya girmez. Hata nedeninde yalnız istisna sınıfı ya da HTTP kodu yazar,
    yanıt gövdesi yazılmaz.
- Ortak biçimleyici `cost_text()` ve `dry_run_note()` dört araçta kullanılır: `tts_tr.py`, `tts_lesson.py`,
  `tts_book_tr.py`, `tts_episode_tr.py`. `cost_text()` dört durumda şunları yazar:
  - ücretsiz ve süre dolmamış: "ücretsiz (PatientDesk: GG.AA.YYYY tarihine kadar; tarife ≈ X TL)";
  - ücretli ya da `free: true` ama süresi geçmiş: "≈ X TL ödenecek (ücretsiz dönem GG.AA.YYYY bitti)";
  - tarih yoksa: "≈ X TL ödenecek (ücretli dönem)";
  - bilinmiyor: "≈ X TL (ücret durumu doğrulanamadı: <neden>; ücretli varsayıldı)".

  Kalan kota biliniyorsa satıra "; kalan Duyu kotası ≈ N saat" eklenir. Tarih yerel saat dilimiyle yazılır.
- Kuru çalışma notu artık ne olduğunu söyler:
  - okuma başarılıysa "üretim çağrısı yapılmadı; yalnız ücret durumu okundu (GET /v1/usage)";
  - okuma başarısızsa "… ücret durumu okunamadı (GET /v1/usage)";
  - çevrimdışıysa ya da anahtar yoksa "hiçbir API çağrısı yapılmadı".
- Çevrimdışı anahtarı: dört araçta `--offline` ya da `HIVELZON_TR_TTS_OFFLINE=1`. `conftest.py` testlerde
  bunu her zaman açar; testler ve CI ağa çıkmaz.
- Eski yorum `# Alania (ilk ay ücretsiz; 2026-10-14)` ve CLI metni "ilk ay ücretsiz" kaldırıldı. Araç
  belgelerinde "API çağrılmaz" yerine "üretim çağrısı yapılmaz" yazıyor, anahtarın kuru çalışmada ücret
  durumu için okunduğu belirtildi.
- **Değişmeyenler:** `--execute` akışı, aylık tavan denetimi (tavan yoksa üretim reddedilir), fiyatlar ve
  defter biçimi. Ücret satırı her iki kipte basıldığı için durum `--execute`'ta da bir kez okunur; üretim
  kararını etkilemez. Yalnız İngilizce (ElevenLabs) araçlarına (`tts_book.py`, `tts_episode_en.py`,
  `tts_reel.py`) dokunulmadı; oradaki "API çağrılmadı" doğru.

## Kabul kriterleri

- [x] Örnek JSON doğru okunur. `free` true/false ve süresi geçmiş true doğru yorumlanır.
- [x] Zaman aşımı, HTTP 401, bozuk JSON ve anahtar yokluğunda sonuç `known=False` olur, istisna fırlamaz.
- [x] Her durumun satırı biçimlenir. `user_id` ve anahtar hiçbir çıktıda görünmez.
- [x] Dört aracın kuru çalışması yeni satırı yazar. Üretim çağrısı yapılmaz.
- [x] `--offline` / `HIVELZON_TR_TTS_OFFLINE=1` okumayı atlar.
- [x] Araç kodunda "kampanya döneminde ücretsiz", "kampanyasında ücretsiz", "ilk ay ücretsiz" kalmadı.
- [ ] Kullanıcı onayı ve commit.

## Test

```bash
tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline -q        # 443 passed (önce 417)
P=tools/content-pipeline/.venv/bin/python
$P tools/content-pipeline/tts_lesson.py dilbilgisi/G-C1-04-participle-clauses     # kuru, canlı GET
$P tools/content-pipeline/tts_book_tr.py kitaplar/A1-K01-the-blue-door
$P tools/content-pipeline/tts_episode_tr.py icerik/A1-001-a-strange-message
$P tools/content-pipeline/tts_lesson.py dilbilgisi/G-C1-04-participle-clauses --offline
```

Yeni testler `tests/test_tts_tr_billing.py` dosyasında (26 test, sahte okuyucu, ağ yok). Mevcut kuru çalışma
testlerine yeni satır denetimi eklendi: `test_tts_tr.py`, `test_grammar.py`, `test_book_tr.py`,
`test_tts_episode_tr.py`.

2026-11-20 gerçek kuru çalışma çıktısı (canlı GET):

- **Ders:** `Ücret: ≈ 0.00 TL ödenecek (ücretsiz dönem 14.11.2026 bitti); kalan Duyu kotası ≈ 985 saat`.
  Yapılacak Türkçe iş yok, o yüzden 0 TL.
- **171 karakterlik deneme:** `≈ 0.15 TL ödenecek (ücretsiz dönem 14.11.2026 bitti); …`.

## Geri alma

Değişiklik yalnız `tools/content-pipeline` araç kodunda ve testlerdedir. Geri almak için ilgili commit'i
`git revert` etmek yeter. Veri, defter ve içerik değişmedi.

## Notlar

- `free_until` geçmişteyse sunucu `free: true` dese bile araç ücretli varsayar (güvenli taraf).
- Okunamazsa araç ücretli varsayar. Ücretli üretimden önce maliyet gösterme ve onay kuralı değişmez.

## Kod incelemesi (qa-code-reviewer, 2026-11-20)
Engelleyici bulgu yok; `--execute`, tavan denetimi, fiyat ve defter değişmedi. Küçük bulgular:
- Aşırı iç içe JSON `_parse_usage`'da `RecursionError` fırlatıyordu → düzeltildi (her istisna "geçersiz yanıt").
- Sonsuz/NaN/negatif sayılar kabul ediliyordu → düzeltildi (`_num` reddeder). İkisi için test eklendi; pytest 444.
- Bilinen sınır: 2 sn/5 sn süreleri DNS çözümlemesini ve yanıtın tamamını kapsamaz; bozuk DNS ya da yavaş
  sunucuda kuru çalışma 7 sn'den uzun bekleyebilir (sonuç yanlış olmaz). Gerekirse genel bir süre sınırı eklenir.
- Bilinen sınır: Türkçe iş yokken de (ör. `--lang en`) durum bir kez okunuyor; zararsız, gerekirse yalnız
  Türkçe karakter > 0 iken okunacak biçimde daraltılır. `--execute`'ta da satır için bir kez okunur.
