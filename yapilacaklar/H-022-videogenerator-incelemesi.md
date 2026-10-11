# H-022: videoGenerator sınıflarının incelemesi

- **Durum:** Yapılacak
- **Tür:** Araştırma (kodsuz)
- **Öncelik:** Yüksek
- **Bağımlılık:** —

## Amaç
Hikâye video hattında yeniden kullanılacak sınıfları okuyup HiVelzon'a (Spring Boot 4) nasıl taşınacaklarını belirlemek.

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
