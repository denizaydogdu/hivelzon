# Haklar ve inceleme: C1-K02 Eleven Bridges

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C1-K02; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Ostrel Nehri ve bütün yer adları (Brenning, Odderby, Kerrow, Tamsby, Lindhaven, Pellow's Ford, Harl, Ambrey, Mardle, Saltings, Wrenmouth, Holm) uydurmadır; ülke adı verilmez. Teknik kolej, ilçe yönetimi, belediye ve firmalar adsızdır.
- **Teknik içerik:** Köprü terimleri (span, pier, abutment, bearing, chord, expansion joint, general arrangement drawing) genel mühendislik sözcükleridir; metindeki hesaplar ve ölçüler sayı olarak verilmez, hiçbir gerçek projeye dayanmaz.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapılır (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`); C1 için Octanove C1/C2 ayrı veri seti olarak öngörülür. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (8 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Olay örgüsünde suç ya da kötü karakter yoktur; engel doğa, mesafe ve geçmişteki bir haksızlıktır.
- Bisiklet kazası hafif ve gerçekçi anlatılır: diz bağı zorlanır, doktor dinlenmeyi önerir, Lena önerilen süre kadar dinlenir; kan ve yara ayrıntısı yok. Anlatıcı yağmurda devam etme kararını açıkça hata olarak görür (I should have stopped).
- 1962'deki ayrımcılık (sınıftaki tek kadın öğrenci, reddedilen proje) ölçülü ve suçlayıcı olmayan bir dille, olgu olarak verilir; kimse kötülenmez, mektup yalnızca özetlenir. Hedda acınmak istemez.
- Selde yıkılan köprü ve kayıplar yalnızca eşya ve hayvanla sınırlıdır (bir ahır, koyunlar, bir piyano); insan kaybı yok.
- Hedda'nın yaşı ve sağlığı (tansiyon şakası) sakin ve sevecen anlatılır. Son, gerçekçi bir umut verir: meclis projeyi incelemeye karar verir, köprünün yapılacağı vaat edilmez.
- Çocuklarla ilgili kış otobüsü sorunu kaygı yaratmadan, toplumsal bir ihtiyaç olarak anlatılır.

## Dil denetimi
- `book-lint` (2026-10-14): 8.585 kelime (C1 hedefi 6.400–9.600), 28 sayfa, 7 bölüm, 704 cümle; 0 hata. Çeviri 711/711 birim (bölüm başlıkları dahil), 8.457/8.457 kelime anlamlı. C1 kapsaması: Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Uyarılar: çeviri DRAFT, Octanove liste yok, ses ve görsel henüz yok.
- Özel adlar (`properNouns`): Lena, Hedda, Vogt, Mortimer, Ostrel, Brenning, Odderby, Kerrow, Priya, Tamsby, Lindhaven, Pellow, Ilan, Harl, Ambrey, Margit, Tomasz, Mardle, Saltings, Wrenmouth, Holm, Dunmore.
- C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma, past perfect continuous, could / should have) ve Türk öğrenci notları `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle (42 girdi).
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (Mr / Ms noktasız; flat, pavement, kerb, lorries, crisps, doctor's surgery, half six, bed and breakfast gibi İngiliz kullanımları bilinçli). Teknik dil ile gündelik dil karşıtlığı (p07, p27) bilinçlidir.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, genel onay) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 8 görsel, ≈ 4 kr) | Kullanıcı | Üretildi: 8 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcının genel onayıyla ("tüm onayları verdim") metin ve çeviri onaylı işaretlendi (H-028); editör toplu okuması yine önerilir.
