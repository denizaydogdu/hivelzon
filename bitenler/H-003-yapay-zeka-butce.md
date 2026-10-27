# H-003: Yapay zekâ aylık bütçe tavanı ve kotalar

- **Durum:** Bitti (2026-10-27)
- **Tür:** Karar
- **Öncelik:** Yüksek

## Soru
Konuşma pratiği için Velzon'un aylık harcama tavanı nedir? Günlük kota ne olsun?

## Plan önerisi
Başlangıç: 300 $/ay tavan; günlük 1 sesli + 3 yazılı oturum. Ölçüme göre ayarlanır (§8).

## Notlar
2026-10-11: `docs/IS-PLANI.md` §13'ten.
2026-10-11: Şartname §18/1 ve §18/12 ek olarak şunların netleşmesini istiyor: kotanın ölçü birimi (dakika, oturum ya da tur), uyarı eşikleri ve bütçe sorumlusu. Tavan tanımlanmadıkça ücretli üretim varsayılan olarak kapalı kalır (§8.3).
2026-10-11: **Aylık AI harcama tavanı: 300 USD** (kullanıcı kararı). Tavan dolunca ücretli üretim ve AI özellikleri durur; uygulamanın geri kalanı çalışır. **Açık kalan:** Günlük konuşma kotası. Konuşma pratiği MVP'de olmadığı için v1 öncesinde belirlenecek; plandaki öneri günde 1 sesli + 3 yazılı oturum.
2026-10-27: **Kullanıcı kararı (ajana devir):** Kota birimi oturum. Sesli oturum en fazla 5 dk / 10 tur; yazılı oturum en fazla 10 tur. 18+ günde 1 sesli + 3 yazılı; 13–17 günde 1 rehberli yazılı (serbest sesli yok); 13 altı AI yok. Tavanın %50/%80/%100'ünde uyarı; %80'de yalnız metin, %100'de AI kapanır. Bütçe sorumlusu ürün sahibi; günlük harcama defteri tutulur. Ayrıntı: `docs/KARARLAR-2026-10-27.md`.
