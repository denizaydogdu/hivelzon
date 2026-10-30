# H-081: Dilbilgisi dalgası 2: B1 + B2

- **Durum:** Devam ediyor (2026-10-30): B1 14 + B2 12 ders main'de, lint 0 hata ve Türkçe sesler hazır. Yaklaşık 11.070 karakter İngilizce örnek çalışan ElevenLabs erişimi/ayrı onaylı ücretli plan bekliyor; kullanıcı ve öğretmen/editör incelemesi açık. **2026-10-30:** Yeni ücretsiz anahtar 10.000 kredi gösterse de üretim çağrıları `401 detected_unusual_activity` verdi; B1–B2 İngilizce örnek sesi üretilmedi, kredi harcanmadı.
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
