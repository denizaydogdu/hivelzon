# Haklar ve inceleme: B2-K01 Two Signatures

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B2-K01; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum, müze ya da telifli karakter yok. Şehir (Marell), Halat Sokağı (Rope Street), ressam Aina / Andreu Serra ve tablo (*The Harbour of Marell*) uydurmadır. Boya analizi bilgisi (kurşun beyazı, titanyum beyazının 1920'lerden sonra yaygınlaşması) genel bilgidir.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (7 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Suç yok: şüphelenilen "hile" bir yanlış anlamadır; kimse zarar görmez.
- Lucía'nın gece atölyeye kendi anahtarıyla dönmesi yalnız bakmak içindir; boya örneği patronunun izniyle ve onun gözü önünde alınır (p18). Kimya testi bir üniversite laboratuvarında bir doktora öğrencisince yapılır; tehlikeli madde kullanımı anlatılmaz.
- Bir kadın ressamın 1890'larda erkek adıyla satmak zorunda kalması tarihsel bir adaletsizlik olarak sakin bir dille işlenir; kimse aşağılanmaz. Ölüm yalnızca geçmişte ve doğal (evin sahibi, Aina, büyükanne), ayrıntısız anılır.
- Romantik çizgi yok.

## Dil denetimi
- `book-lint` (2026-10-14): 5.300 kelime (B2 hedefi 4.000–6.000), 24 sayfa, 6 bölüm, 511 cümle; kapsama %99,0 (CEFR-J ≤ B2, özel adlar hariç; sözlükle %100). Liste dışı: varnish(ed), archive, archivist, ultraviolet, bundle, restoration, intern, attic, loop, nineteenth, shelves, easel, doctorate, frowned, bookseller, titanium; hepsi sözlükte. Çeviri 517/517 birim (başlıklar dahil), 4.932/4.932 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, ses ve görsel henüz yok).
- B2 yapıları (edilgen, dolaylı anlatım, 2. ve 3. tip koşul, *wish / if only*, *must / can't / might have*, present perfect continuous, virgüllü ilgi cümlesi, *have something done*, future continuous / perfect, *although / despite / however*) metinde doğal örneklerle geçer; örnekler ve Türk öğrenci notları `glossary.md`'de.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (Mr / Ms noktasız; colour, realise, recognised, practising). Son sayfanın son paragrafı bilinçli olarak bugüne bağlanır (*Ms Vidal has been searching… By next summer, she says, she will have visited…*).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 7 görsel, ≈ 3,5 kr) | Kullanıcı | Üretildi: 7 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
