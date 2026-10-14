# Haklar ve inceleme: C2-K04 The Word Meter

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C2-K04: kahraman, istek/engel, kanca, bölüm planı, son sürpriz, dil odağı; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Şehir (Halvern), semtler (Eastmere), sokak ve yapı adları (Copper Street, Lantern Street, Glass Arcade, Iron Bridge), Kelime Hizmeti, Borsa ve "Gürültü Yılları" uydurmadır. Kurgusal kurumlar gerçek bir devlete ya da kuruluşa göndermede bulunmaz.
- **Kelime listesi:** C2 kapsaması için gereken Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Konuşma kotası bir "kamu sessizliği önlemi" olarak anlatılır; yergi siyasete değil alışkanlığa yöneliktir (insanlar artık zorunlu olmayan bir kurala görgü kuralı gibi uymayı sürdürür). Hiçbir siyasi grup, seçim ya da yönetim figürü yoktur.
- Ceza en fazla bir ses (Çan) ve "konuşma borcu"dur; kimse cezalandırılmaz, tutuklanmaz ya da zarar görmez.
- Baba-kız küslüğü sakin bir dille işlenir: kimse bağırmaz, kimse kimseyi aşağılamaz; küslük bir yanlış anlamadan (altı kelime) doğar ve sevgiyle çözülür. Annenin sahile taşınması tek cümleyle, suçlamadan anlatılır.
- Petra gece yalnız yürür ama sahneler sakindir; sokakta karşılaştığı tek kişi yardım teklif eden kibar bir kadındır.
- Gerçek marka, gerçek yer ya da ünlü yok; görsellerde yazı yok (PROMPTS.md).

## Dil denetimi
- `book-lint` (2026-10-14): 10.184 kelime (C2 hedefi 8.000–12.000), 30 sayfa, 7 bölüm, 758 cümle; 0 hata. Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Çeviri 765/765 birim (7 bölüm başlığı + 758 cümle), 9.993/9.993 kelime anlamlı (DRAFT). Uyarılar yalnız: çeviri DRAFT, Octanove listesi yok, ses ve görsel henüz yok.
- Özel adlar (`properNouns`): Halvern, Petra, Lind, Anna, Osric, Pell, Hilde, Matthias, Eastmere, Joaquim, Varga, Fenwick, Copper Street, Lantern Street, Glass Arcade, Iron Bridge.
- C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma) ve C2 yapıları (öne alma, adlaştırma, temkinli dil, resmî dilek kipi ve if'siz şart, bağdaşıklık belirleyicileri, görünüş incelikleri) `glossary.md`'de Türkçesi, metinden örnek cümlesi ve Türk öğrenci notlarıyla (44 girdi).
- C2 dil odağı (katalog): teknokratik/resmî dil (duyuru, raporlar, Petra'nın konuşmasının başı) ile duygusal dilin çatışması; türetilmiş sözcükler (word-broker, talk-debt); serbest dolaylı anlatımla kendini kandıran anlatı ("There was a mistake.", "Many people had left the Service."); başta kısa, kelime sayan cümleler, sonda (p30) uzun, akan cümleler.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (colour, licence, realise, organisation, pavement, flat, queue, teatime; Mr / Mrs / Miss noktasız).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 8 görsel, ≈ 4 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |
