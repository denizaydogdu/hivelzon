# H-019: WishSay ile kod paylaşım yöntemi

- **Durum:** Bitti (2026-10-11)
- **Tür:** Karar
- **Öncelik:** Orta
- **Bağımlılık:** H-021

## Soru
WishSay'deki desenler kopyalanıp uyarlanacak mı, yoksa ortak bir kütüphane mi çıkarılacak?

## Plan önerisi
Kopyala-uyarla: kaynak dosya belirtilerek taşınsın, iki repo arasında çalışma zamanı bağımlılığı kurulmasın (videoGenerator kuralıyla aynı).

## Kaynak
`IS-PLANI.md` §13.2/7 · `SARTNAME.md` §17/6

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.

## Sonuç (2026-10-11)
**Kullanıcı kararı:** "WishSay'i unut, yalnızca HiVelzon'a odaklan." WishSay'den ne kopyalama ne ortak kütüphane yapılacak. HiVelzon kendi tasarımıyla ilerler.
