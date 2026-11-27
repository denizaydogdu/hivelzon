# H-082: Dilbilgisi dalgası 3: C1 + C2

- **Durum:** Devam ediyor (2026-10-30): C1 8 + C2 6 ders main'de, lint 0 hata ve Türkçe sesler hazır. 7.482 karakter İngilizce örnek çalışan ElevenLabs erişimi/ayrı onaylı ücretli plan bekliyor; kullanıcı ve öğretmen/editör incelemesi açık. **2026-10-30:** Çalışan ikinci ücretsiz anahtarın kotası A2/B1 seslerine gitti; sabahki ve üçüncü anahtar `401 detected_unusual_activity` verdi. C1–C2 İngilizce örnek sesi üretilmedi. **2026-11-03:** Octanove listesi depoya eklendi (`d2d81c0`), C1/C2 kapsaması denetleniyor, 14 ders 0 hata (G-C2-02/-03 sözlük eklemeleri editör incelemesinde); 14 dersin hepsinde "Hikâyede gör" kartı yok.
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
- **2026-11-20:** 14 C1/C2 dersinin hepsine "Hikâyede gör" kartı (`a907fba`); 13 dersin (C1-01…07, C2-01…06) kancası gerçek kitap cümlesiyle yeniden yazıldı ve Türkçe anlatımı Alania ile seslendirildi (`54bd9f1`). B1–C2 19 kancanın toplamı 3.254 karakter ≈ 2,44 TL (kullanıcı onaylı; defter 806.001 → 809.255). C1-04/C1-06'da ad kitapla aynı "Tomás" (söyleniş sözlüğü Tomás→Tomas). Kulakla kontrol: Priya, Kamala, Kofi, Bruno, Tomás, Lena, Amira.
- **2026-11-26:** ElevenLabs **Creator** planıyla C1/C2 İngilizce örnekleri de seslendirildi (bütün dilbilgisi turu 17.789 karakter; ayrıntı H-081). 71/71 ders İngilizce tam; `export_grammar` 71/71 TAMAM, grammar_lint 0 hata/7 uyarı. Kalan yalnız öğretmen/editör kontrolü ve yukarıdaki adların kulakla kontrolü.
