# H-011: İçerik yönetim ve editör onay paneli

- **Durum:** Bitti — karar verildi (2026-10-11)
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
2026-10-11 (`ICERIK-MIMARISI.md` §9.1): Araştırmanın önerisi: içerik git'te tutulur (`icerik/`), `content-lint` ile doğrulanır, içe aktarılır ve ince bir Spring ekranında onaylanır, zamanlanır ya da kaldırılır. Headless CMS MVP için gereksiz. İleride dışarıdan editör gelirse Directus değerlendirilebilir.

## Karar (2026-10-11)
K-12 onaylandı: içerik kod olarak yönetilir (git `icerik/` → `content-lint` → içe aktarma). Onay için ince bir Spring ekranı kullanılır: önizleme, kontrol listesi, Onayla / Zamanla / Kaldır, onay geçmişi. Headless CMS kullanılmaz. Ayrıntı: `ICERIK-MIMARISI.md` §6.10, §9.
