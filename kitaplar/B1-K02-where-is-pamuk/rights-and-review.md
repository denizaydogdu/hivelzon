# Haklar ve inceleme: B1-K02 Where Is Pamuk?

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B1-K02; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Kurtarma merkezi, Kumlu kasabası, Hasan Amca'nın teknesi (Martı) ve adsız koy kurmacadır; Türkiye'nin güneybatı kıyısındaki gerçek bir merkezi ya da kumsalı temsil etmez.
- **Doğa bilgisi:** İribaş deniz kaplumbağasının (caretta) gece kumsala çıkıp yumurta bırakması, doğduğu kumsala dönmesi, erkeklerde kuyruğun uzun olması ve yuvalama sırasında ışıktan rahatsız olması genel ve sade biçimde anlatıldı. Kesin sayılar (yaklaşık yüz yumurta, "yirmi yaşında genç") yuvarlak ve temkinli verildi; editör kontrolünde doğrulanmalı.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (5 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Yumurtlama doğa olayı olarak, sade ve sevimli bir dille anlatılır.
- **Deniz ve fırtına:** Kararları her zaman yetişkinler verir. Hasan Amca deneyimli bir balıkçıdır; Kerem'e can yeleği giydirir, fırtınada açık denize çıkmak yerine korunaklı koya sığınır ve limanı arayıp nerede olduklarını bildirir. Kerem tek başına bir şey yapmaz; gece kumsala teyzesiyle çıkar, Hasan Amca yakındadır.
- **Hayvana saygı:** Yuvalayan kaplumbağaya yaklaşılmaz, ışık yakılmaz; Sevgi Teyze yuvayı bozmamak için vericiyi yuvanın ortasından değil kenarından arar. Gönüllüler yuvaları çitle korur. Okura doğru davranış örneği verilir.
- Motor arızası ve fırtına gerilim yaratır ama kimse yaralanmaz; korku sahneleri kısa ve sakin bir yetişkin sesiyle dengelenir.

## Dil denetimi
- `book-lint` (2026-10-14): 3.196 kelime (hedef 2.400–3.600), 18 sayfa, 4 bölüm, 332 cümle; kapsama %98,9 (CEFR-J ≤ B1, özel adlar hariç; sözlükle %100). Liste dışı ve sözlükte açıklanan: loggerhead, tracker, flipper, tail, glue, beep, nest, tractor, anchor, deck, pine, rocky, dug, feet. Çeviri 336/336 birim, 3.110/3.110 kelime anlamlı. 0 hata.
- Seviye üstü kelimeler ve B1 dil notları (for / since, present perfect deneyim, used to, past continuous + while, past perfect, 1. tip koşul, he / she ile hayvanlar, -ed / -ing sıfatları) `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı (H-072) | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 5 görsel ≈ 2,5 kr) | Kullanıcı | Üretildi: 5 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü (doğa bilgisi dahil) | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
