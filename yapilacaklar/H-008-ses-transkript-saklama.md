# H-008: Ham ses ve transkript saklama politikası

- **Durum:** Yapılacak (kullanıcı kararı)
- **Tür:** Karar
- **Öncelik:** Yüksek
- **Bağımlılık:** H-006 (sağlayıcının veri koşulları)

## Soru
Ham ses hiç saklanmayacak mı, yoksa yalnızca kullanıcı açıkça isterse mi saklanacak? Konuşma transkriptleri ne kadar süre tutulacak, kimler erişebilecek?

## Plan önerisi
Ham ses hiç saklanmasın: bellekte işlenip atılsın, diske yazılmasın. Transkript yalnızca oturum geri bildirimi için kısa süre tutulsun (ör. 30 gün) ve hesap silindiğinde silinsin. Ses işleme için ayrı bir açık rıza (`VOICE_PROCESSING`) alınsın.

## Kaynak
`IS-PLANI.md` §9.1 · `SARTNAME.md` §10.1 (`speaking_turns`), §12.1, §18/3

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
