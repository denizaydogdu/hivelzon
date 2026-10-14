# H-078: Dilbilgisi ekranı (mobil)

- **Durum:** Yapılacak
- **Tür:** Uygulama (kod)
- **Faz:** Dilbilgisi D2 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-077

## Kapsam
- Hikâye sekmesinde "Macera · Kitaplık · Dilbilgisi".
- Konu rafları.
- Ders kartları: vurgulu Türkçe anlatım, İngilizce örnek sesleri, kodla çizilen şemalar, alıştırma (puansız), Hikâyede gör.
- Kural kartı → Defter ve FSRS.
- Giriş noktaları:
  - bölüm panelinde ve kitap açma ekranında "Bu bölümdeki dilbilgisi";
  - anlam panelinde "Bu yapı ne?";
  - Hi'nin hata notu.
- `user_grammar_progress` tablosu ve eşitlemesi; Hi önerisi.

## Kabul kriterleri
- Testler yeşil; golden; erişilebilirlik; hareketi azalt.

## Test
`cd mobile && flutter analyze && flutter test`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
