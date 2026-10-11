# H-022: videoGenerator sınıflarının incelemesi

- **Durum:** Bitti (2026-10-11)
- **Tür:** Araştırma (kodsuz)
- **Öncelik:** Yüksek
- **Bağımlılık:** —

## Amaç
Hikâye video hattında yeniden kullanılacak sınıfları okuyup hiVelzon'a (Spring Boot 4) nasıl taşınacaklarını belirlemek.

## Kapsam
- `~/Dev/videoGenerator` yalnızca okunur. **Değişiklik yapılmaz, `mvn package` çalıştırılmaz.**
- Okunacaklar: `CLAUDE.md`, `README.md`, `thoughts/` ve CLAUDE.md tablosundaki sınıflar (StoryWriter, SceneImageService, TranslationService, ElevenLabsClient, SceneTimer, SubtitleRenderer, KenBurnsRenderer, AudioProcessor, FFmpegWrapper, JobPipeline/Job/JobStore, BudgetGuard/CostTracker, ChannelProfile, BackofficeServer).

## Kabul kriterleri
- Her sınıf için ne yaptığı, bağımlılıkları ve taşıma notu (Spring'e uyarlama, kaynak belirtme) yazılmış.
- CEFR kısıtlarının StoryWriter prompt'una nasıl ekleneceği önerilmiş.
- Sonuç `docs/` altında bir rapor olarak kaydedilmiş.

## Kaynak
CLAUDE.md "videoGenerator projesinden yararlanma" · `SARTNAME.md` §8.2

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.

## Sonuç (2026-10-11)
Rapor: `docs/VIDEOGENERATOR-RAPORU.md`. 18 sınıf için taşıma notu, CEFR prompt taslağı (§4a), WebVTT ve kelime zamanlaması üretimi (§4c), 17 adımlık taşıma planı.

**Kabul kriterleri karşılandı:** videoGenerator'da `git status` temiz; build ve ücretli çağrı yapılmadı.

**CLAUDE.md'ye işlenen düzeltmeler:**
- `SceneImageService` OpenAI gpt-image-2 kullanıyor.
- `loudnorm` parametresiz (~-24 LUFS).
- `BudgetGuard` tavan yoksa 100 USD varsayıyor.

**Kullanıcıya iletilen risk:** videoGenerator'da git'e işlenmiş `TODO.md` dosyasının ~277. satırında bir API anahtarının parçası açık duruyor. Anahtar değiştirilmeli. O repo bu oturumdan değiştirilmez.

**Not:** videoGenerator'ın ElevenLabs hesabı ücretsiz plan. hiVelzon ayrı ve ticari kullanıma uygun bir hesap kullanmalı (H-027 / H-006).
