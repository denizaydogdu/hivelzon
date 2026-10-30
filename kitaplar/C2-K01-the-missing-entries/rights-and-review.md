# Haklar ve inceleme: C2-K01 The Missing Entries

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C2-K01; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Köy (Quillham), sokaklar (Mill Lane, Mill Row), komşu kasaba (Marsh End), ev (Lark Cottage) ve sözlük (The Thornwick Dictionary of the English Language) uydurmadır. Belediye, okul, bakımevi ve yayınevi adsızdır; Bay Dunmore'un unvanı uydurma bir kurum unvanıdır.
- **Sözlük tanımları:** Metindeki tanımlar (lonely, me, you, teach, lollop) bu kitap için yazılmış özgün tanımlardır; hiçbir gerçek sözlükten alınmadı.
- **Kelime listesi:** CEFR-J Wordlist v1.6 (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Octanove C1/C2 listesi depoda yok; C2 kapsaması denetlenmedi. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (9 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. "Suç" yalnızca bir kütüphane sözlüğünden altı maddenin kesilmesidir ve sonunda sayfalar onarılır.
- Yaşlı bir adam ile on yaşında bir çocuk arasındaki ilişki özenle kuruldu: Edmund çocuğu kendisi aramaz, kapısına gitmez; kütüphaneci annesine resmî bir mektup yazar, Edmund'un notu "Please bring your mum" der ve karşılaşma cumartesi sabahı, kütüphanede, annesi ve kütüphaneci yanındayken olur. Kulüp herkese açık bir kütüphane etkinliğidir.
- Zofia'nın bisikletle Edmund'un kapısına kart bırakması ve onun evini bilmesi gizemin gereğidir; tehlike ya da takip olarak işlenmez, sabah erken, gazete dağıtan Callum'un gözü önündedir. Akşamları çocuk evde büyükannesiyle kalır (yalnız bırakılmaz).
- Yalnızlık sakin ve ölçülü işlenir; yas ya da hastalık yok. Göç konusu siyasetsiz: Zofia'nın ailesi yalnız "büyük bir şehir, tramvaylı" diye anılır, ülke adı verilmez.
- Callum'a yöneltilen suçlama haksız çıkar ve Edmund onu savunur; kimse aşağılanmaz. Zofia'nın İngilizce hataları alay konusu yapılmaz; Edmund nazikçe düzeltir.

## Dil denetimi
- `book-lint` (2026-10-14): 10.760 kelime (C2 aralığı 8.000–12.000), 30 sayfa, 8 bölüm, 887 cümle. Kapsama: Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Çeviri 895/895 birim (8 bölüm başlığı + 887 cümle), 10.438/10.438 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, Octanove listesi yok, ses ve görsel henüz yok).
- Özel adlar (`properNouns`): Edmund, Pryce, Quillham, Thornwick, Janet, Moss, Keith, Dunmore, Callum, Reid, Alf, Tidy, Gordon, Speake, Quizzly, Marjorie, Fenn, Nigel, Brimble, Zofia, Lenart.
- C1/C2 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümlesi, needn't have / be supposed to / would rather, kişisiz edilgen, It's high time / would rather you didn't, eksiltme ve yerine koyma; öne alma, adlaştırma, temkinli dil, Should / Had / Were it not for, Granted / Even so, görünüş incelikleri) ve Türk öğrenci notları (I am agree, the eksikliği, -s takısı) `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle.
- Zofia'nın kusurlu İngilizcesi bilinçlidir (I don't understand nothing, my mum sleep, Floor is dirty, I find it, I am agree); çeviride doğru Türkçeyle verilir, açıklaması öbeklerde ve sözlükte.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (Mr / Mrs / Dr noktasız; colour, civilisation, apologise, recognise, centre, pavement, flat, jumper, trainers, fortnight, half seven, smelt).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, genel onay) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 9 görsel, ≈ 4,5 kr) | Kullanıcı | Üretildi: 9 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcının genel onayıyla ("tüm onayları verdim") metin ve çeviri onaylı işaretlendi (H-028); editör toplu okuması yine önerilir.
