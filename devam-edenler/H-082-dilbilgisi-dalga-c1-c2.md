# H-082: Dilbilgisi dalgası 3: C1 + C2

- **Durum:** Devam ediyor (2026-10-30): C1 8 + C2 6 ders main'de, lint 0 hata ve Türkçe sesler hazır. 7.482 karakter İngilizce örnek çalışan ElevenLabs erişimi/ayrı onaylı ücretli plan bekliyor; kullanıcı ve öğretmen/editör incelemesi açık. **2026-10-30:** Yeni ücretsiz anahtar 10.000 kredi gösterse de üretim çağrıları `401 detected_unusual_activity` verdi; C1–C2 İngilizce örnek sesi üretilmedi, kredi harcanmadı.
- **Tür:** İçerik üretimi
- **Faz:** Dilbilgisi D6 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-081

## Kapsam
- ~14 konu; C1/C2 örneklerinin kapsaması Octanove listesiyle denetlenir.

## Kabul kriterleri
- Onaylı; öğretmen kontrolü kayıtlı.

## Test
lint

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
