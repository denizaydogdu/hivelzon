# H-006: Yapay zekâ sağlayıcıları ve yurt dışı aktarım

- **Durum:** Yapılacak (kullanıcı kararı)
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

