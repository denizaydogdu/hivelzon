# H-026: İçerik mimarisi kararları

- **Durum:** Bitti — karar verildi (2026-10-11)
- **Tür:** Karar
- **Öncelik:** Yüksek
- **Bağımlılık:** H-007 ile birlikte okunmalı

## Soru
`docs/ICERIK-MIMARISI.md` §14'teki kararlar onaylanıyor mu? Doğrudan bu işe bağlı olanlar:

- **K-01 İçerik kimliği ve klasörü:** `icerik/A1-001-…` mi, `content/A2/A2-TRAVEL-001-…` mi?
- **K-02 Sekme adları:** Ana Sayfa · Keşfet · Öğren · Konuş · Profil mi, Bugün · Öğren · Akış · Konuş · Ben mi?
- **K-03 Altyazı varsayılanı.**
- **K-04 Kelime tekrarı:** FSRS mi, sabit aralıklar mı?
- **K-05 Durum makinesi:** 6+1 durum mu, 10+5 durum mu?
- **K-07 Kapsama kuralı ve kelime havuzu:** Bu karar CLAUDE.md'deki CEFR tablosunu değiştirir.
- **K-08 Hacim ve vaat.**
- **K-09 Yayın ritmi.**
- **K-10 Hikâye evreni.**
- **K-11 Yazma görevi MVP'de olacak mı?**
- **K-20 MEB tema etiketi.**

## Plan önerisi
- **K-01:** `icerik/` düzeni korunur. Konu bilgisi `content.json`'a yazılır. `content.json` ve `rights-and-review.md` dosyaları eklenir.
- **K-02:** Ana Sayfa · Keşfet · Öğren · Konuş · Profil.
- **K-03:** Varsayılan İngilizce altyazı, hedef kelimede Türkçe karşılık. A1'de Türkçe satır da önerilir.
- **K-04:** FSRS, hedef hatırlama %90, hesaplama sunucuda.
- **K-05:** 6+1 durum. İnceleme adımları ayrı durum değil, kontrol listesi maddesi olur.
- **K-07:** Bütün seviyelerde %98 bilinen kelime hedef, %95 alt sınır. B2 kelime havuzu 2.500–2.800.
- **K-08:** Yaklaşık 160 hikâye. "Bu seviyeye ulaştırır" vaadi verilmez.
- **K-09:** Haftada 1 hikâye + 3–4 kısa video ile başlanır, ölçülerek artırılır.
- **K-10:** "Yeni gelen" ortak hikâye evreni; her seviye bir sezon.
- **K-11:** Yazma görevi MVP'de olmaz, P1'e kalır.
- **K-20:** A2–B1 içeriklerine MEB tema etiketi eklenir.

Onaylanırsa yapılacaklar:
- CLAUDE.md'deki CEFR tablosu ve dosya yapısı güncellenir.
- H-023 ile `IS-PLANI.md`'ye işlenir.

## Kaynak
`docs/ICERIK-MIMARISI.md` · `docs/ICERIK-STRATEJISI.md`

## Notlar
2026-10-11: Web araştırması (5 kol) ve kullanıcının içerik stratejisi belgesinden açıldı. Ayrıntı: `docs/ICERIK-MIMARISI.md`.

## Karar (2026-10-11)
Kullanıcı `docs/ICERIK-MIMARISI.md` §14'teki önerileri onayladı ("onayladım"). Onaylananlar: K-01…K-16 ve K-20. CLAUDE.md'ye "Onaylı içerik mimarisi kararları" bölümü olarak işlendi; CEFR tablosu ve dosya yapısı güncellendi.

**Bu işte kapanmayanlar:**
- K-17 Faz yapısı → H-007 / H-023.
- K-18 Onay ve kapasite → H-028.
- K-19 Lisans doğrulaması → H-027.

**Sonraki adım:** `IS-PLANI.md` ve `SARTNAME.md` H-023 kapsamında bu kararlara göre güncellenecek.
