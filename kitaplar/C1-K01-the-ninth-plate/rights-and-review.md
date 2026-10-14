# Haklar ve inceleme: C1-K01 The Ninth Plate

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C1-K01; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok; kapalı mekân gizemi türünün genel kalıbı (karla kapanmış otel, bir araya getirilmiş yabancılar) kullanıldı, belirli bir eserin olay örgüsü ya da karakteri alınmadı. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Otel (Glasswater), göl (Fennick), küçük istasyon (Fennick Halt) ve şehir (Calderbury) uydurmadır; gazete, otobüs şirketi, hayvan hastanesi ve eczane adsızdır.
- **Bulmaca içeriği:** Kitaptaki anagramlar (Daryl Brie, Bridal Rye → Early Bird) ve takma ad (Night Owl) özgündür; gerçek bir gazetenin bulmacası ya da bulmaca yazarı ima edilmez.
- **Kelime listesi:** C1 seviye denetimi CEFR-J Wordlist v1.6 (atıf: Tono Laboratory, TUFS) ve Octanove C1/C2 ile yapılacaktır; Octanove C1/C2 listesi depoda yok, bu nedenle kapsama denetlenmedi. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Gizem bir suç değil, bir iyilik zinciridir: "şüpheli" yoktur, kimse zarar görmez; kaybolan tabak bile bir yanlış anlamadır.
- On dört yıl önceki gece: dokuz yaşındaki bir kız fırtınada istasyonda yalnız kalır. Tehlike vurgulanmaz; kız hep yetişkinlerin gözetimindedir (eczacı, öğretmen, kütüphane sığınağı, bütün gece yanında oturan Ruth), istasyon görevlileri durumdan haberdardır ve sabah teyzesine ulaştırılır. Kızın adını yabancılara söylememesi güvenli davranış olarak gösterilir.
- Elektrik kesintisi ve "hayalet" söylentisi korkutucu değil, mizahi tonda işlenir (hayalet hikâyesi dans eden bir hanım; Ambrose gerisini dinlemek istemez).
- Otel müdürünün sırrı (kardan kaçan anne kedi ve yavruları) sevecen bir yanıltıcı ipucudur; hayvanlara iyi bakılır, veteriner kontrol eder.
- Duygusal son ölçülüdür: gözyaşı ve minnet var, ağır yas ya da dram yok.

## Dil denetimi
- `book-lint` (2026-10-14): 8.396 kelime (C1 hedefi 6.400–9.600), 28 sayfa, 7 bölüm, 765 cümle. Çeviri 772/772 birim (7 bölüm başlığı dahil), 8.089/8.089 kelime anlamlı; 0 hata. Uyarılar: çeviri DRAFT; C1 için Octanove C1/C2 listesi depoda yok, kapsama denetlenmedi; ses ve görsel henüz yok.
- Özel adlar (`properNouns`): Ruth, Okafor, Calderbury, Glasswater, Fennick, Agnes, Thorne, Desmond, Pike, Ambrose, Hale, Felix, Arden, Bev, Hartley, Priya, Nair, Theo, Fallon, Crane, Maren, Daryl, Brie. "Crane" aynı zamanda "turna" anlamına gelir; metinde bu bilinçli bir kelime oyunudur (p22).
- C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma), deyimler ve Türk öğrenci notları `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle (45 girdi).
- Standart İngiliz İngilizcesi (colour, realise, theatre, practised, torch, jumper, telly; Mr noktasız). Resmî ve gündelik üslup farkı bilinçlidir: Ambrose resmî ve eski usul, Bev ve Desmond gündelik İngiliz ağzıyla konuşur.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 8 görsel, ≈ 4 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |
