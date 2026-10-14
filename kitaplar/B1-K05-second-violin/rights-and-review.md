# Haklar ve inceleme: B1-K05 Second Violin

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B1-K05; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Orkestra ve şehir adsızdır; konserde çalınan *Evening Song* uydurma bir parçadır, gerçek bir besteciye ya da esere gönderme yoktur.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Tehlike yok; olaylar orkestra salonu, park ve ev arasında geçer.
- Sahne korkusu utandırmadan, nazik bir dille işlenir: Hana'nın geçmişteki donup kalması kısa anlatılır, kimse ona gülmez; iki genç birbirine destek olarak korkuyu adım adım yener. Noah'nın kıskançlığı dürüstçe gösterilir ama Hana'ya kötü davranmaz; kendi duygusundan utandığını fark eder.
- Rekabet bir kazanan-kaybeden hikâyesi olarak değil, işbirliği olarak kapanır ("Second doesn't mean less").
- Parkta küçük çocuklar (Ella, 7) ağabeyiyle birlikte ve gündüz vakti; yetişkin denetimi dışında riskli bir durum yok. Gençler arasında romantik bir çizgi kurulmadı.

## Dil denetimi
- `book-lint` (2026-10-14): 2.994 kelime (B1 hedefi 2.400–3.600), 18 sayfa, 4 bölüm, 355 cümle; kapsama %98,8 (CEFR-J ≤ B1, özel adlar hariç; sözlükle %100). Liste dışı: solo, soloist, audition, conductor, cellos, duet, pigeon(s), clapped; hepsi sözlükte. Çeviri 359/359 birim, 2.874/2.874 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, ses ve görsel henüz yok).
- Seviye üstü kelimeler ve dil notları (for / since, present perfect, past perfect, used to, -ed / -ing sıfatları, karşılaştırma ve üstünlük, might, look forward to) `glossary.md`'de Türkçesi ve örnek cümlesiyle.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir: geçmişteki bir andan önceki olaylarda past perfect (*Noah had never heard anything like it.*).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 5 görsel, ≈ 2,5 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
