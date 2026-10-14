# Haklar ve inceleme: B1-K04 The Library of Lost Things

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B1-K04; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok; istasyon ve şehir adsız ve kurmacadır, kütüphane fantastiktir.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Büyü karanlık değil; kütüphane sakin, sıcak ve komik bir yer.
- "Gece yarısından sonra rafa konursun" kuralı Bay Orrin'in kuru şakası olarak verilir; tehdit edici değildir, kimse zarar görmez. "Isıran" kayıp sabır bulutları yalnızca bir şapkayı ısırır (mizah).
- Bay Pell'in kaybolması hafif ve sevimli anlatılır (gözlüğünü ararken yolunu şaşırır); hastalık ya da yaşlılıkla alay yok.
- Ines'in "I'm not good enough" cümlesi utandırmadan, sıcak bir dille işlenir: onu bir karta yazar ve kütüphanede bırakır; özgüven kaybı bir derse ya da cezaya dönüşmez.
- Ines yalnız bir yere giriyor ama zaman dışarıda neredeyse hiç geçmiyor (bir dakika); gece dışarıda kalma yok.

## Dil denetimi
- `book-lint`: kapsama ≥ %98 (CEFR-J ≤ B1, özel adlar hariç), kelime sayısı 2.400–3.600. Sonuç 2026-10-14: 3.265 kelime, 20 sayfa, 5 bölüm, 399 cümle; kapsama %99,4 (liste dışı: ceiling, shelves, scarves, staircase, hook, borrowers, chewed, frowned, straightened, lit, gently, shaky, nest, glue, goodbye, eleventh, twelfth; hepsi sözlükte, sözlükle %100); 0 hata.
- Seviye üstü kelimeler ve B1 dil notları (*used to*, past perfect, *for / since*, *might*, *-ed / -ing*, ilgi zamirleri, *borrow / lend*) `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel, ≈ 3 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
