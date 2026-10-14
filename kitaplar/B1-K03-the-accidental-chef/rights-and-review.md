# Haklar ve inceleme: B1-K03 The Accidental Chef

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B1-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Seagull Hotel (Martı Oteli), "the Silent Fork" (Sessiz Çatal) takma adlı yemek yazarı, gazete ve şehirdeki restoran kurmaca ve adsız/markasızdır.
- **Yemek:** Dal, Hint mutfağından genel bir yemek adıdır; tarif ayrıntısı (mercimek, soğan, sarımsak, baharat) genel bilgidir.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Alkol yok (menüde şarap ya da içki geçmez).
- Özgeçmişteki "deneyimli şef" satırı bilerek yapılmış bir sahtecilik değil, kuzenin şablonundan kalan bir dikkatsizliktir. Priya'nın işi bir hafta sürdürmesi mizahla anlatılır ama ödüllendirilmez: Gus'a itiraf eder, Bruno'ya gerçeği söyler, özgeçmişini düzeltir. Ödül, dürüst seçimine (annesinin dal'ı) ve yeniden başlamaya razı olmasına gelir.
- Sakatlık hafiftir (Bruno'nun bileği burkulur, bir iki hafta). Mutfak kazaları (yanık balık, tuzlu kek) komiktir, kimse incinmez. Bıçak yalnızca güvenli kullanım öğretilirken geçer.
- Kimse aşağılanmaz; Gus'un sert ama kibar notları ve Kamala'nın "biraz fazla tuz" yorumu sıcak bir dille verilir.

## Dil denetimi
- `book-lint` (2026-10-14): 2.974 kelime (hedef 2.400–3.600), 20 sayfa, 5 bölüm, 372 cümle; kapsama %98,9 (CEFR-J ≤ B1, özel adlar hariç; sözlükle %100); liste dışı: dal, lentils, recipe, chop, burnt, French, farmhouse, dining, feet, chips, patiently, hook (hepsi sözlükte); çeviri 377/377 satır, bütün kelimeler anlamlı; 0 hata.
- Seviye üstü kelimeler ve dil notları (cook / cooker, past perfect, used to, for / since, should / have to) `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |
