# Haklar ve inceleme: C1-K05 Held in Trust

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C1-K05; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Köy (Sarnıçlı) uydurmadır; katalogdaki gibi Kaş yakınlarında adsız bir kıyıda geçer. Ajans, otel, kafe, kahvehane, okul ve havalimanı adsızdır. Londra, İstanbul, Kaş, Alpler, İspanya ve Manchester yalnızca coğrafi arka plan olarak anılır.
- **Sözlük girdisi:** Margaret'in 1967 tarihli cep sözlüğündeki "Emanet: a deposit; a thing lent; a trust." maddesi uydurmadır; gerçek bir sözlükten alıntı değildir.
- **Kelime listesi:** C1 için CEFR-J + Octanove C1/C2 öngörülür; Octanove dosyası depoda olmadığından kapsama denetlenmedi. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı. Dilbilgisi konuları `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…08) listesinden.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Suç yok: Margaret'in kendini "bir çeşit hırsız" sanması bir yanlış çeviriden doğan suçluluk duygusudur ve sevgiyle çözülür.
- Ağır duygular ölçülüdür: Margaret'in babasının ölümü ve kocasının yokluğu birer cümleyle, ayrıntısız anlatılır; Hatice'nin eşinin ölümü tek cümledir. Yaşlılık ve ölüm korkusu Priya'nın "before it's too late" sözü ve Margaret'in kuru şakasıyla (şubata kadar yaşamak) hafifçe anılır.
- Anne-kız gerginliği (Nur ve annesi) sakin bir dille işlenir; kimse bağırmaz, aşağılamaz; sonunda yakınlaşma vardır.
- "Doğum sancıları" (going into labour) tek bir esprili anı olarak geçer, ayrıntı yoktur.
- Türkiye ve köy hayatı saygılı ve sıcak bir dille anlatılır; turistleşme hafif bir ironiyle eleştirilir, yerli insanlar alay konusu edilmez. Başörtüsü ve yazma yalnızca kıyafet ayrıntısıdır.
- Emre'nin hatalı İngilizcesi küçümsenmez; Nur ve Margaret ona nazik davranır.

## Dil denetimi
- `book-lint` (2026-10-14): 8.598 kelime (C1 hedefi 6.400–9.600), 27 sayfa, 6 bölüm, 802 cümle; kapsama: Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Çeviri 808/808 birim (802 cümle + 6 bölüm başlığı), 8.396/8.396 kelime anlamlı; 0 hata (uyarılar: kapsama listesi yok, çeviri DRAFT, ses ve görsel henüz yok).
- Özel adlar (`properNouns`): Margaret, Ellis, Nur, Demir, Priya, Mina, Ollie, Hatice, Kaya, Osman, Emre, Peter, Sarnıçlı, Kaş, London, Istanbul, Turkey, Alps, Manchester, Spain, Hanım, Amca.
- Metindeki Türkçe sözler (Bu sana emanet; Oralar akşam serin olur. Üşütme; Babaannem kimseyi görmek istemiyor; Ödünç; Ben geldim; Senin emanetin; Söyle ona; Sen de üşütme; anne) bilinçlidir ve çoğu metnin içinde İngilizceye çevrilir; kelime anlamlarında "(Türkçe)" notu vardır.
- C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma, temkinli dil) ve Türk öğrenci notları (I am agree, tanımlık eksikliği) `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle (45 girdi).
- Üslup farkı bilinçlidir: Margaret resmî ve eski usul İngilizce konuşur (I shall, I should be grateful, one came by boat, kindly inform); Nur'un iç sesi gündelik ve ironiktir. Anlatı dilbilgisi standart İngiliz İngilizcesidir (Mr / Mrs noktasız; jumper, pavement, half six, parents' evenings, orange squash).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 7 görsel, ≈ 3,5 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |
