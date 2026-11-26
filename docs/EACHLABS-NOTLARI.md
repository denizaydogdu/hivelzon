# Eachlabs — görsel/video üretimi için yedek sağlayıcı (başvuru notu)

> Durum (2026-11-26): **Kullanıma hazır ama planlı iş yok.** Higgsfield kredisi 0,37 (ortak hesap). Kullanıcı kararıyla
> Eachlabs hesabı **Kıraathane projesiyle ortak** (aynı bakiye). Bilgiler `gorsel` (Kıraathane) oturumunun 2026-11-26
> gerçek denemesinden; MiniMax koşulları ve panel indirimi henüz doğrulanmadı.

## Kurallar (hiVelzon)
1. **Her üretimden önce** maliyet kullanıcıya gösterilir ve onay alınır (CLAUDE.md, Higgsfield kuralı 1 ile aynı).
2. **Ortak bakiye:** partiye başlamadan planlanan toplam USD `gorsel` oturumuna yazılır; her işten önce bakiye okunur.
   Bakiye 0,50 USD'nin altındayken Eachlabs yeni işi reddeder. Kıraathane'nin kalan işi en kötü ≈ 12 USD (2026-11-26,
   bakiye 18,02 USD).
3. **Anahtar kopyalanmaz:** tek kaynak `~/Dev/kıraathane/infra/.env` (`EACHLABS_API_KEY`, git dışı). Kullanım yalnız komut
   süresince: `set -a; . ~/Dev/kıraathane/infra/.env; set +a`. Değer hiçbir dosyaya, günlüğe ya da commit'e yazılmaz.
   Anahtar 2026-11-26'da sohbete düştü; kullanıcı panelden yenileyecek (rotate).
4. **Kayıt:** her istem, model, parametre, tarih, prediction id ve gerçek ücret (`metrics.cost`) ilgili `PROMPTS.md`'ye
   yazılır (Higgsfield kuralı 2 ile aynı).
5. **Girdi görselleri herkese açık URL olmalı** (dosya yükleme/base64 yok, kenar ≥ 300 px). hiVelzon'da "H-044'e kadar
   dış barındırma yok" kuralı geçerli: yayımlanmamış görseller bu amaçla internete konmaz. Kullanılabilecek yol: eski
   Higgsfield çıktılarının zaten herkese açık `result_url`'leri (`higgsfield generate list --json`). Başka bir yol
   gerekirse kullanıcıya sorulur.
6. **Ticari kullanım:** Eachlabs ToS v2.1 (https://www.eachlabs.ai/terms-of-service) çıktıları "uygulanabilir hukuk ve
   sağlayıcı koşulları ölçüsünde" kullanıcıya bırakır; sağlayıcı kısıtı model sayfasında yazar. Seedance 2.5 sayfasında
   ticari kısıt yok (yalnız "gerçek insan yüzü değil"). **MiniMax koşulları kullanmadan önce model sayfasından
   doğrulanır** ve `rights-and-review.md`'ye yazılır (H-107'deki Higgsfield kaydı gibi).

## API (SDK yok, doğrudan HTTP)
- Taban `https://api.eachlabs.ai`, başlık `Authorization: Bearer $EACHLABS_API_KEY`.
- Oluştur: `POST /v1/prediction` →
  `{"model":"<slug>","version":"1.0.0","input":{...},"safety_identifier":"hivelzon-art-pipeline"}` → `{"predictionID":…}`.
  `version` ve `safety_identifier` zorunlu; `safety_identifier` sabit takma addır (e-posta/IP değil).
- Sorgu: `GET /v1/prediction/{id}` → `starting|processing|success|failed|cancelled`; başarıda `output` (CDN URL) ve
  `metrics.cost`. 2–3 sn'de bir sorgulanır (ya da `webhook_url`).
- Bakiye: `GET /v1/billing/balance` → `{"balance_usd": n}`.
- Model alanları (anahtarsız): `GET /v1/models?name=<ad>`; fiyat (anahtarla): `GET /v1/models/{slug}` → `cost`.
- Hazır betik (Python stdlib): `~/Dev/kıraathane/tools/art/eachlabs.py` (`balance`, `run --model … --input @girdi.json
  --out … [--dry-run]`). hiVelzon'a gerekirse **desen olarak** alınır, iki repo bağlanmaz.

## Modeller ve fiyatlar (API'den, 2026-11-26)
| İş | Slug | Önemli alanlar | Fiyat |
|---|---|---|---|
| Görselden video (ucuz) | `minimax-h3-max-image-to-video` | `image_url`, `end_image_url`, `duration` 5–15 (int), `resolution` 480P/768P/1080P, `prompt_expansion_mode: "disabled"`, `seed` | 768P 0,06 USD/sn (6 sn = 0,36 USD, ölçüldü) |
| Görselden video (kaliteli) | `bytedance-seedance-2-5-image-to-video` | `image_url`, `end_image_url` (aynı URL = döngü), `duration` "4".."30", `resolution`, `generate_audio: false` (varsayılan true) | 720p 0,267 USD/sn (6 sn = 1,62 USD, ölçüldü) |
| Görsel düzenleme / referansla görsel | `nano-banana-2-edit` | `image_urls` (1–10), `prompt`, `resolution` 1K/2K/4K, `aspect_ratio` | 1K 0,08 · 2K 0,12 USD/görsel |

Diğer: `minimax-h3-image-to-video` (768P 0,09 USD/sn), H3 Lite (480P 0,025 / 768P 0,04), H3 Highspeed (768P 0,06),
`nano-banana-2-1-edit` (1–14 referans, `seed`). Panelde görünen "MiniMax H3 %50'ye varan indirim" API fiyatlarında
doğrulanmadı. Başarısız/iptal iş ücretlenmez; ön ödemeli bakiye 12 ay geçerli.

## Deneme bulguları
- Tutarlılık için karakter yeniden üretilmez: onaylı kare ilk (ve gerekirse son) kare olarak verilir, eski istem aynen kullanılır.
- MiniMax H3 Max istemdeki, sahnede olmayan bir nesne adını ("table") uydurdu → istemde yalnız sahnede olan şeyler yazılır.
- hiVelzon karşılığı: "kilit an" (H-024, Seedance 2.0 Mini 5 sn) için en ucuz aday MiniMax H3 Max 768P, 5 sn ≈ 0,30 USD.
