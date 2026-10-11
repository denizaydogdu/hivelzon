# H-011: İçerik yönetim ve editör onay paneli

- **Durum:** Yapılacak (kullanıcı kararı)
- **Tür:** Karar
- **Öncelik:** Orta
- **Bağımlılık:** H-021, H-022

## Soru
Editör onayı (insan kontrolü) için ayrı bir web paneli mi kurulacak, yoksa WishSay'deki gibi uygulama içi yönetici rolü mü kullanılacak?

## Plan önerisi
WishSay'deki uygulama içi yönetici rolü deseni kullanılsın (plan §9.4). Panel, durum akışını videoGenerator `BackofficeServer`'daki gibi `PENDING_REVIEW` → onay → yayın olarak izlesin. Yönetici işlemleri denetim kaydına yazılsın.

## Kaynak
`IS-PLANI.md` §9.4 · `SARTNAME.md` §5.1, §9.3 (`admin`), §18/6

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
