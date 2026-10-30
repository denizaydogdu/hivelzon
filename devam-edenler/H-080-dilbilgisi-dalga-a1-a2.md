# H-080: Dilbilgisi dalgası 1: A1 + A2

- **Durum:** Devam ediyor (2026-10-30): 31 ders main'de, lint 0 hata ve Türkçe sesler hazır. İngilizce örnek sesleri **A1 16/16 ve A2 15/15 tam** (`95b0b2d`). Kalan kullanıcı ve öğretmen/editör incelemesi (`docs/EDITOR-INCELEME-PAKETI.md`) ile bağ eksikleri: G-A2-07 hikâye bağı üretilmemiş prologa (A1-000) gidiyor, G-A2-11'de "Hikâyede gör" kartı yok.
- **2026-10-30 TTS kontrolü:** A2 İngilizce örneklerin kuru çalışması 2.991 karakter gösterdi. Yeni ücretsiz anahtarın abonelik sorgusu 10.000 kredi bildirdi, ancak A2 ders partisi, 105 karakterlik kart ve doğrudan 5 karakterlik deneme dahil üç üretim çağrısı `401 detected_unusual_activity` ile reddedildi; ses/kredi üretilmedi. Çalışan, uygun hesap/plan olmadan tekrar denenmez.
- **Tür:** İçerik üretimi
- **Faz:** Dilbilgisi D4 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-079

## Kapsam
- Kalan ~27 konu; Türkçe sesler ücretsiz ay içinde.

## Kabul kriterleri
- Onaylı; öğretmen kontrolü kayıtlı.

## Test
lint

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
2026-10-14: A1 (13) ve A2 (15) dersleri ayrı dallarda yazıldı ve birleştirildi. Öğretmen notları her dersin `rights-and-review.md`'sinde. Bölüm ve kitaplara `grammarTopics` (en fazla 3, yalnız aynı ya da alt seviye) ana oturumca eklendi.

2026-10-14: A2 İngilizce örnekleri hesap4 ile seslendirildi: G-A2-01…07 tam, G-A2-08 kısmen (6 örnek); 2.469 karakter, hesap4 doldu (9.993/10.000). Kalan A2 ≈ 2.990 karakter TTS erişimi bekliyor. G-A1-15 "Hikâyede gör" bağı A1-008 kartından (altyazıda yok) A1-006 "There is a radio on the desk." cümlesine alındı; grammar_lint 71 ders 0 hata.
2026-10-30: Yeni ücretsiz ElevenLabs anahtarı çalıştı (5 karakterlik test 200). A2 İngilizce örneklerinin kalanı seslendirildi: G-A2-08 (kalan) … G-A2-15, 2.991 karakter (defter). A2 15/15 İngilizce tam; `grammar_lint` 71/0 hata, `export_grammar --require-media` A2 15/15 TAMAM.
