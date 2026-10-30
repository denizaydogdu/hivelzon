# Haklar ve inceleme: C2-K05 The Other Half of the Sentence

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C2-K05; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden, şarkıdan ya da şiirden alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Kitabın içindeki roman (*Son Vapur / The Last Ferry*), yazar Hakan Aral, yayınevi Halyard ve bütün karakterler uydurmadır.
- **Yerler:** Manchester ve İstanbul gerçek şehirlerdir (katalogdaki Türkiye bağı); semt ve iskele adları uydurmadır: Kemerburnu, Çınaraltı iskelesi, Sakızlı Sokak. İstanbul'daki yayınevi, okul ve öğrenci yurdu adsızdır.
- **Kelime listesi:** C2 için CEFR-J Wordlist v1.6 (A1–B2; atıf: Tono Laboratory, TUFS) + Octanove C1/C2 (CC BY-SA 4.0, ayrı veri seti) öngörülür; Octanove listesi depoda henüz yok. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Dilbilgisi:** Yapılar `dilbilgisi/MUFREDAT.md` C1 (G-C1-01…08) ve C2 (G-C2-01…06) konularına göre seçildi; CEFR-J Grammar Profile yalnızca referanstır, ham veri kullanılmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (9 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Cenaze yalnızca "cenaze haftası" olarak anılır; hiçbir dinî tören ya da ritüel anlatılmaz.
- **Yas (katalog onay maddesi 4):** Babanın ölümü bir yıl öncesine aittir ve sakin, ölçülü bir dille anlatılır: "uykusunda öldü", tek cümle; hastalık, ölüm anı ya da beden betimlemesi yok. Yas, kırtasiye işi ve küçük nesneler (palto, defter, yağmurluk) üzerinden, kuru mizah ve sıcaklıkla işlenir. Ağlama sahneleri kısa ve hemen ardından teselliyle (bisküvi, çay, annenin omzu) gelir. Umutsuzluk ya da kendine zarar teması yok; son, barışma ve kabulle biter.
- Anne ile babanın ayrılığı "iki tarafın da büyük nezaketiyle" olarak anlatılır; suçlama ve kavga yok.
- Babanın kusurlu İngilizcesi alay konusu edilmez; saygıyla ve sevgiyle, bilinçli bir seçim olarak sunulur. Türk öğrencinin tipik hataları sözlükte yargılamadan açıklanır.
- Yayıncı Rosalind'in baskısı kibar ve mizahidir; tehdit yalnızca resmî üslubun alaya alınmasıdır.

## Dil denetimi
- `book-lint` (2026-10-14): 9.858 kelime (C2 hedefi 8.000–12.000), 30 sayfa, 8 bölüm, 746 cümle. Kapsama: **Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi.** Çeviri 754/754 birim (8 bölüm başlığı + 746 cümle), 9.674/9.674 kelime anlamlı; 0 hata (uyarılar: Octanove listesi yok, çeviri DRAFT, ses ve görsel henüz yok).
- Özel adlar (`properNouns`): Aylin, Marsh, Hakan, Aral, Judith, Rosalind, Pike, Halyard, Nevzat, Deniz, Selçuk, Bey, Dilek, Hanım, Ayım (takma ad), Istanbul, Manchester, Kemerburnu, Çınaraltı, Sakızlı, Christmas.
- Metindeki Türkçe kelimeler (hüzün, gönül, kıyamamak, sana kıyamam, simit, vapur, elma, martı, ay, seni seviyorum, katılıyorum, iki Türkçe cümle) bilinçli olarak korunur; Türkçe kelime anlamlarında "(Türkçe)" notu vardır.
- **Babanın İngilizcesi bilinçli olarak kusurludur** (kenar notları, Dilek Hanım'ın aktardıkları, kart, onuncu bölüm): I am agree, I am write / I am say / I am pay, many word / only few word / two half, Everybody already know, the eksikliği (Other half is yours, Other Half of Sentence), özne eksikliği (Is not possible, Is tired). Düzeltilmez; `glossary.md`'de **Dikkat** notlarıyla açıklanır, çeviride öbek notlarında doğru biçim parantez içinde verilir.
- C1/C2 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümlesi, needn't have / might well have / be supposed to / would rather, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma, öne alma, adlaştırma, temkinli dil, resmî dilek kipi ve if'siz şart, bağdaşıklık belirleyicileri, görünüş incelikleri) `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle.
- Anlatı standart İngiliz İngilizcesidir (colour, neighbourhood, realise, apologise, centimetres, pavement, queue, flat, pushchair, fortnight, jewellery; Mr noktasız).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, genel onay) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 9 görsel, ≈ 4,5 kr) | Kullanıcı | Üretildi: 9 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcının genel onayıyla ("tüm onayları verdim") metin ve çeviri onaylı işaretlendi (H-028); editör toplu okuması yine önerilir.
