# H-006: Yapay zekâ sağlayıcıları ve yurt dışı aktarım

- **Durum:** Bitti (2026-10-27)
- **Tür:** Karar
- **Öncelik:** Yüksek
- **Bağımlılık:** —

## Soru
Konuşma (LLM), ses tanıma (ASR), seslendirme (TTS) ve telaffuz için hangi sağlayıcılar kullanılacak? Yurt dışına veri aktarımı için hukukçu desteği var mı?

## Plan önerisi
Sağlayıcılar kalite, Türk aksanı başarımı, veri işleme koşulları ve gerçek maliyetle karşılaştırılsın. Plandaki aday: LLM için Claude; STT/TTS/telaffuz için Azure ya da Deepgram. Cihazda STT ile Türk aksanını küçük bir kodsuz testle deneyelim (plan Faz 0). Sağlayıcılar adaptör arkasında tutulur, anahtarlar yalnızca sunucuda durur.

## Kaynak
`IS-PLANI.md` §6, §13.2/5 · `SARTNAME.md` §9.2, §18/2

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11:
- **Bölüm seslendirmesi (TTS): ElevenLabs** (kullanıcı kararı).
- **Anahtar:** Kullanıcı ya kendi anahtarını verecek ya da videoGenerator'daki anahtarın kullanılmasını önerdi. **videoGenerator'daki hesap ücretsiz plan** (oradaki TODO.md, 2026-08-13). Ücretsiz plan ticari lisans içermiyor [güncel fiyat sayfasıyla doğrulanmalı]. Ayrıca iki repo arasında sır paylaşımı CLAUDE.md'deki "iki repo birbirine bağlanmaz" kuralına aykırı. Bu yüzden **hiVelzon için ticari lisanslı (ücretli plan) ayrı bir anahtar** gerekiyor.
- **Anahtarın saklanması:** Repoya ve sohbete yazılmaz. Repo dışında bir dosyada tutulur, örneğin `~/.config/hivelzon/secrets.env` (izin 600, `ELEVENLABS_API_KEY=…`).
- **Hâlâ açık:** AI sohbet sağlayıcısı (v1'de seçilecek).
2026-10-11 (`docs/VIDEOGENERATOR-AI-SERVISLERI.md`, `docs/VIDEOGENERATOR-GERCEK-MALIYET.md`):
- **videoGenerator yalnızca iki AI sağlayıcısı kullanıyor: OpenAI ve ElevenLabs.**
  - OpenAI: metin için `gpt-5.6-luna`, görsel için `gpt-image-2`.
  - ElevenLabs: `eleven_v3` (zaman damgalı), `multilingual_v2`; ücretsiz plan.
- **Yapılandırılmış çıktı yok.**
- **Maliyet kayıtları** tahmin, fatura değil. Ağustos toplamı 5,54 USD; maliyetin ~%70'i görsel.
- **OpenAI anahtarı** global bir ortam değişkeni; makinedeki her araç aynı faturayı paylaşıyor.
- **hiVelzon tahmini:** 6 görselli A1 bölümü için ~0,55–0,80 USD (videoGenerator yolu). hiVelzon görselleri Higgsfield'de: 0,5 kredi/görsel (low).
- **Öneri:** ElevenLabs zaman damgalı TTS deseni alınsın, ayrı ticari hesapla. Görsel için OpenAI değil Higgsfield (K-24). Programatik LLM gerekirse şemalı çıktıyla kullanılsın.
2026-10-11: **Kullanıcı kararı:** Yerel çalışma süresince **mevcut (videoGenerator) ElevenLabs hesabıyla** devam edilecek. Ücretsiz plan; aylık 10.000 karakter, videoGenerator ile ortak. Bu sesler iç kullanım içindir. **Yayından önce ticari plan şartı geçerli.** AI sohbet sağlayıcısı v1'de seçilecek.
2026-10-14 (kullanıcı kararı, hukukçu görüşü): Ücretsiz ElevenLabs hesabıyla üretilen sesler yayında kullanılabilir; Türkiye'de sorun görülmedi; yeniden üretim gerekmez.
2026-10-27: **Kullanıcı kararı (ajana devir):** v1 LLM'i yerel **Ollama + RAG (pgvector)** ile başlar; `AiTutorPort` arkasında kalır. Barındırılan sağlayıcı ancak ölçüm yetersizse ve H-044 sonrası ayrı onayla seçilir. STT yalnız cihazda (S1); bulut STT varsayılan değil. TTS İngilizce ElevenLabs, Türkçe PatientDesk Alania; anahtarlar yalnız sunucuda/repo dışında. Veri Almanya'daki sunucuda (H-044, hukukçu cevabı); bunun dışında yeni ülke/sağlayıcıya aktarım ayrı hukukçu onayı ister. **ElevenLabs:** Kullanıcının 2026-10-27'de verdiği ücretsiz anahtar API'de **401 `detected_unusual_activity`** döndürdü; ücretsiz katman erişimi kapalı, yeni ses üretilemedi. Ücretli plana geçiş ayrı onay ister. Ayrıntı: `docs/KARARLAR-2026-10-27.md`.
