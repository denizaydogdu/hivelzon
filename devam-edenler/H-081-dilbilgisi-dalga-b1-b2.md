# H-081: Dilbilgisi dalgası 2: B1 + B2

- **Durum:** Devam ediyor (2026-10-30): B1 14 + B2 12 ders main'de, lint 0 hata ve Türkçe sesler hazır. İngilizce örnekler: **G-B1-03, -10, -12, -14 tam; G-B1-01 kısmen** (yalnız c01-ex1; 2026-10-30, ikinci ücretsiz anahtar). Kalan G-B1-01 (~350), G-B1-02, -04…-09, -11, -13 (~4.140) ve B2'nin tamamı çalışan ElevenLabs erişimi/ayrı onaylı ücretli plan bekliyor; üçüncü anahtar da `401 detected_unusual_activity` verdi. Kullanıcı ve öğretmen/editör incelemesi açık; editör paketine göre birçok B1/B2 dersinde "Hikâyede gör" kartı yok ya da kanca gerçek cümle değil.
- **Tür:** İçerik üretimi
- **Faz:** Dilbilgisi D5 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-080

## Kapsam
- ~26 konu.

## Kabul kriterleri
- Onaylı; öğretmen kontrolü kayıtlı.

## Test
lint

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
2026-10-14: B1 ve B2 ayrı dallarda yazıldı ve birleştirildi. `cefr.py`'ye düzensiz üçüncü hâller eklendi (iki dalın birleşimi). Öğretmen notları her dersin `rights-and-review.md`'sinde. Bazı B1/B2 derslerinde giriş cümlesi "köprü" (gerçek hikâye cümlesi, yapı Hi'nin yeniden söylemesiyle) ya da kendi cümlemiz; hikâyelerde o yapı henüz yok.
2026-10-30: Ücretsiz ElevenLabs kotasının kalanıyla B1 İngilizce örnekleri tam ders bazında seslendirildi: G-B1-03, G-B1-10, G-B1-12, G-B1-14 (1.363 karakter; `export_grammar --require-media` TAMAM). G-B1-01 yarım kaldı (yalnız c01-ex1, 21 karakter): abonelik sorgusu gecikmeli sayaç gösterdiği için kota tahmini yüksek çıktı, API `quota_exceeded` ile durdu (18 kredi kaldı). Kalan B1 (G-B1-01 kalanı, -02, -04…-09, -11, -13) ve B2 yeni kota/plan bekliyor.
