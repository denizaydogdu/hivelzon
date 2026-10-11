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
