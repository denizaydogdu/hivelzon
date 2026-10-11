# H-007: Plan ile şartname arasındaki çelişkileri uzlaştır

- **Durum:** Yapılacak (kullanıcı kararı)
- **Tür:** Karar
- **Öncelik:** Yüksek
- **Bağımlılık:** H-001 ile birlikte karara bağlanır

## Soru
`IS-PLANI.md` ile `SARTNAME.md` şu konularda çelişiyor; hangisi esas alınacak?
1. **Konuşma pratiği MVP'de mi?** Plan: v1'de (Faz 2). Şartname: P0/MVP (§5.1), ama yol haritasında Faz 4.
2. **Faz yapısı:** Plan Faz 0–3, şartname Faz 0–5.
3. **Seviye testi:** Plan zorunlu uyarlamalı 15–25 soru; şartname isteğe bağlı, kısa, atlanabilir.
4. **Günlük hedef ve seri:** ayrıntı H-013.
5. **Telaffuz puanı:** ayrıntı H-015.

## Plan önerisi
Konuşma pratiği MVP dışında kalsın (plan sırası): kota, bütçe tavanı ve ses rızası hazır olmadan ücretsiz AI çağrısı açılmasın. Faz yapısı için şartnamenin ayrıntılı teslimatları, planın 4 fazına eşlensin. Seviye testi isteğe bağlı ve atlanabilir olsun; sonuç "önerilen başlangıç seviyesi" diye adlandırılsın. Karar verilince H-023 ile plan güncellenir.

## Kaynak
CLAUDE.md "Plan ile şartname arasındaki açık çelişkiler" · `SARTNAME.md` §4.2, §5.1, §16 · `IS-PLANI.md` §4.5, §11

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
