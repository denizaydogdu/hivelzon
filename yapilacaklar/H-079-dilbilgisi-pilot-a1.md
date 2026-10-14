# H-079: Dilbilgisi pilotu: 3 A1 konusu

- **Durum:** Yapılacak
- **Tür:** İçerik üretimi
- **Faz:** Dilbilgisi D3 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-076, H-077, H-078

## Kapsam
- 3 A1 konusu uçtan uca: metin → lint → kullanıcı onayı → Türkçe ses (Alania, ücretsiz ay) → İngilizce örnek sesi → paket → simülatör.
- Söyleniş yöntemi karşılaştırılır: İngilizce kelimeler ayrı ses parçası mı, söyleniş sözlüğü mü.

## Kabul kriterleri
- Kullanıcı dener ve onaylar.
- Öğretmen ya da editör kontrolü kaydedilir.

## Test
lint + `flutter test`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
