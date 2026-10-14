# Haklar ve inceleme: B2-K03 Please Don't Translate That

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B2-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Çeviri kulaklığı adsız, markasız, uydurma bir cihazdır. Eskişehir yalnızca genel hatlarıyla (nehir, renkli eski evler) anılır; gerçek bir dükkân, lokanta ya da işletme adı geçmez. Bruno'nun söylediği Brezilya şarkısının adı ve sözleri verilmez.
- **Deyimler:** Türkçe kalıplar (Eline sağlık, Ağzına sağlık, Kolay gelsin, Afiyet olsun, Hoş bulduk) ve Portekizce deyimler (pagar o pato, encher linguiça, chutar o balde, engolir sapos, quem não tem cão caça com gato, caiu a ficha) dilin ortak malıdır; metinde kelimesi kelimesine İngilizce karşılıklarıyla kullanıldı.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Tehlike yok; tek "kaza" yanan börek ve duman alarmıdır, kimse zarar görmez.
- Mizah iki kültürle de alay etmez: komedi çevirinin kelimesi kelimesine çalışmasından ve iyi niyetli yanlış anlamalardan doğar. Türk aile misafirperverliği (yemek, akrabalar, çay) sıcak ve saygılı anlatılır; Brezilyalı Bruno da gülünç değil, sevimli ve yetenekli bir karakterdir.
- Nişanlı çift arasında yalnızca el tutma gibi aile dostu bir yakınlık var; Bruno misafir odasında, Selin kendi odasında kalır.
- "Kick the bucket" İngilizcede "ölmek" anlamına gelir; metinde yalnızca kelime oyunu olarak, hafif bir dille geçer ("I thought you were dying at my table").
- Bruno'nun kırılan bardağın suçunu üstlenmesi (küçük, iyi niyetli bir yalan) Orhan Bey tarafından takdir edilir, ama hemen ardından "It is not a good lesson" denerek dengelenir.

## Dil denetimi
- `book-lint` (2026-10-14): 5.106 kelime (B2 hedefi 4.000–6.000; katalog ~4.800), 22 sayfa, 5 bölüm, 485 cümle; kapsama %99,3 (CEFR-J ≤ B2, özel adlar hariç; sözlükle %100). Liste dışı: earpiece(s), börek, teeth, app, socket, pastry, token; hepsi sözlükte. Özel adlar listesinde Türkçe kalıp kelimeleri (Eline, sağlık, Kolay, gelsin…) ve Bruno'nun yanlış telaffuzları (Saluk, Salik, Sauluk) da var. Çeviri 490/490 birim, 4.794/4.794 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, ses ve görsel henüz yok).
- B2 yapıları (`dilbilgisi/MUFREDAT.md` G-B2-01…12) doğal cümlelerle geçer; örnekler ve Türk öğrenci notları `glossary.md`'de: edilgen, present perfect edilgen, dolaylı anlatım (cümle, soru, rica), kibarlık kalıpları, 2. ve 3. tip koşul, wish / if only, must have / might have / couldn't have, present perfect continuous, virgüllü ilgi cümleleri, ettirgen have, future continuous / perfect, although / despite / however / whereas.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (practise fiil, colour, recognised; Ms/Mr noktasız). Orhan Bey'in son İngilizce cümlesi bilerek kelimesi kelimesine çeviridir ("Health to your hand, son.").

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel, ≈ 3 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |
