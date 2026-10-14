# Haklar ve inceleme: C2-K03 A Strongly Worded Letter

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C2-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Köy (Nether Ambley), sokak (Larkspur Lane), evler (Fernleigh, Hollybank), kasabalar (Kingsmere, Wexcombe) ve okul (Hartwell Road School) uydurmadır. Posta hizmeti, hastane, arşiv ve ölçüm bürosu (Quayle and Daughter) gerçek bir kuruma işaret etmez; postacının üniforması ve kurum adı anılmaz. Kitap kulübünün okuduğu "balinayla ilgili uzun roman" adı verilmeden geçer.
- **Kelime listesi:** C2 için CEFR-J + Octanove C1/C2 (ayrı veri seti) öngörülür; Octanove C1/C2 listesi depoda henüz yok, bu yüzden kapsama denetlenmedi (aşağıda). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Anlaşmazlık baştan sona kibar bir mektuplaşmadır; kimse bağırmaz, tehdit etmez, kimsenin malına zarar vermez. Mizah ironiden ve kibarlık kalıplarından doğar, kimseyi aşağılamaz.
- **Kaza:** Desmond merdivenden düşüp bileğini kırar. Sahne gösterilmez, sonradan postacının ağzından birkaç cümleyle, kan ve acı ayrıntısı olmadan anlatılır; Desmond iyileşir. Metin merdiven güvenliğini olumlu örnekle işler: Constance yetmiş dört yaşında merdivene çıkmayı bilerek reddeder ve yalnız yerden budar; son mektubunda çitin bir uzman tarafından ve "ikimizin de yardımı olmadan" alçaltılmasını önerir.
- **Bahis:** Köy dükkânındaki tahta, elli penilik tahminlerle köy salonunun çatısına bağış toplayan hafif bir köy şakasıdır; para ödülü yoktur ve hikâyede kimse kazanmaz. Sonra tahta silinip "Geçmiş olsun" kartına dönüşür. "Wedding" sütunu tek kelimelik bir köy dedikodusu olarak kalır; romantik sahne yoktur.
- Yalnızlık teması (Desmond'ın emeklilikten sonra kimseyi tanımaması) ölçülü ve sıcak bir dille işlenir; son, dostluk ve komşuluk üzerinedir.
- Gizlilik: Constance komşusunun evine yalnız kediyi beslemek için, verilen anahtarla girer ve kâğıtlarını bilerek okumaz; masada açık duran klasörü görmesi tek cümleyle geçer.

## Dil denetimi
- `book-lint` (2026-10-14): 10.788 kelime (C2 hedefi 8.000–12.000), 28 sayfa, 7 bölüm, 708 cümle; 0 hata. Çeviri 715/715 birim (cümleler + bölüm başlıkları), 10.456/10.456 kelime anlamlı; durum DRAFT. Uyarılar yalnız: çeviri DRAFT, Octanove liste yok, ses ve görsel henüz yok.
- **Kapsama:** Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi (`coverage` uyarısı). Seviye üstü ve deyimsel öğeler `glossary.md`'de (45 girdi) Türkçesi ve metinden örnek cümlesiyle.
- Özel adlar (`properNouns`): Constance, Webb, Con, Desmond, Achterberg, Beatrice, Bea, Pike, Fernleigh, Hollybank, Larkspur, Nether, Ambley, Kingsmere, Wexcombe, Hartwell, Barry, Tuttle, Priya, Dhillon, Fairweather, Ogunleye, Quayle, Hollis, Josh, Audit (kedinin adı).
- C1/C2 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümlesi, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme, öne alma, adlaştırma, temkin dili, resmî dilek kipi ve if'siz şart, söylem belirleyicileri, görünüş incelikleri) ve Türk öğrenci notları (*I am agree*, *informations*, Miss / Mrs / Ms) `glossary.md`'de.
- Anlatı dili standart İngiliz İngilizcesidir (Mr / Mrs / Ms noktasız; neighbour, metre, centre, realise, learnt, smelt, aluminium; post box, letterbox, flat, estate agent, shepherd's pie, a quarter past three). Sayılar seslendirme için yazıyla; yıllar rakamla.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 8 görsel, ≈ 4 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcının genel onayıyla ("tüm onayları verdim") metin ve çeviri onaylı işaretlendi (H-028); editör toplu okuması yine önerilir.
