# H-077: Ders paketi ve grammar-lint

- **Durum:** Yapılacak
- **Tür:** Uygulama (araç)
- **Faz:** Dilbilgisi D1 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-075, H-076

## Kapsam
- `lesson.json` şeması: kartlar, Türkçe anlatım, örnekler, şema tanımı, alıştırma, "Hikâyede gör" bağları.
- `grammar-lint`: örneklerin seviye kapsaması, cevap anahtarı, bağların çözülmesi, ses ve hizalama uyumu.
- Dışa aktarma ve dev içerik sunucusunda `/grammar/`.
- Bölüm ve kitap paketlerine `grammarTopics` etiketleri.

## Kabul kriterleri
- Örnek bir dersle paket uçtan uca üretilir; pytest yeşil.

## Test
`tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
