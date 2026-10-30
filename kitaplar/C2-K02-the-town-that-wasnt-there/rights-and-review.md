# Haklar ve inceleme: C2-K02 The Town That Wasn't There

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C2-K02; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok. Harita şirketi Gridwell, eski haritacılık firması Hollins and Vane, Callowford köyü, Corrin Tepeleri ve Merrow Cross uydurmadır; ülke ve bölge adı verilmez. Postane, belediye, su idaresi, acil yönlendirme sistemi ve Adres Hizmetleri adsız, genel kurumlardır. Gerçek yer adı olarak yalnız Amira'nın geçmişini anlatan Kanada, Lübnan ve Beyrut geçer.
- "Tuzak sokak" (trap street) haritacılıkta bilinen genel bir kavramdır; kitapta belirli bir gerçek haritaya, firmaya ya da olaya gönderme yapılmaz. On dokuzuncu yüzyıl gölü hikâyesi de anlatıcının doğruluğundan emin olmadığı uydurma bir anekdottur.
- **Kelime listesi:** CEFR-J Wordlist v1.6 (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Octanove C1/C2 listesi depoda yok; C2 kapsaması denetlenmedi. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (8 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Suç yoktur: "yalan" bir haritacılık hilesidir; kasabalıların çatıları yeşile boyaması kimseye zarar vermez ve sonunda dürüst bir raporla resmîleşir.
- Nehir geçişi: Amira sığ ve berrak suyu kuru bir haftanın ardından, akıntıyı kontrol ederek, sopasını akıntının aşağı yanına dayayarak ve basamak taşları üzerinden geçer; kendi şirketinin güvenlik kuralını çiğnediğini açıkça bilir ve bu, örnek gösterilmez, kuru bir mizahla anlatılır. Hava kararınca ikinci kez geçmez, kasabada kalır.
- Nell (11) çatı boyamaya ancak "bağlı olarak" (iple emniyete alınmış) ve yetişkinlerle katılacaktır; kimse risk almaz.
- Bayan Gale'in kocasının 1987'de ambulansla taşınması ve sonradan ölümü tek cümleyle, sakin ve ayrıntısız anlatılır ("He lived another twenty years."). Baraj gölü için çiftliklerin satın alınması adil bir satış olarak anlatılır; kimse boğulmaz, sular altında kalan köy efsanesi düzeltilir.
- Kibar ama kasabaya yabancı bir kadının fırının boş odasında kalması: Kit, kasabanın herkesçe bilinen fırıncısıdır; Nell ve Bayan Gale de oradadır; ilişki dostça ve mesafelidir, romantik ima yoktur.

## Dil denetimi
- `book-lint` (2026-10-14): 10.800 kelime (C2 hedefi 8.000–12.000), 29 sayfa, 7 bölüm, 863 cümle; 0 hata. Kapsama: Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Çeviri 870/870 birim (7 bölüm başlığı + 863 cümle), 10.511/10.511 kelime anlamlı; uyarılar yalnız çeviri DRAFT, Octanove listesi yok, ses ve görsel henüz yok.
- Özel adlar (`properNouns`): Amira, Haddad, Merrow, Corrin, Gridwell, Gavin, Pell, Theo, Marsh, Hollins, Vane, Canada, Lebanon, Beirut, Callowford, Bryony, Kit, Rowley, Nell, Hester, Gale, Arthur, Lisle.
- C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümlesi, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme) ve C2 yapıları (öne alma, adlaştırma, temkin ve tutum, resmî dilek kipi ve if'siz şart, söylem belirleyicileri, görünüş incelikleri) metinde doğal biçimde, her biri en az iki kez geçer; her biri için `glossary.md`'de metinden örnek cümle ve Türk öğrenci notu vardır.
- Katalogdaki C2 dil odağı: rapor dili ile iç ses arasındaki üslup kaymaları (Gridwell rapor taslakları, güvenlik politikası alıntıları, Amira'nın kuru yorumları); temkin dili (allegedly, purportedly, so to speak, arguably, it would appear that); deyimler (off the beaten track, put us on the map, wild goose chase, with a pinch of salt, go native); uzun dönemli cümleler ile tek kelimelik cümlelerin karşıtlığı ("Trees.", "Chimney smoke.", "Exists. Verified.").
- Anlatı dili standart İngiliz İngilizcesidir (colour, realise, metre, licence, petrol, boot, flat, crisps, jumper, fortnight; Mr / Mrs noktasız). Sayılar ve yıllar diyalogda yazıyla, rapor dilinde rakamla verilir.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, genel onay) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 8 görsel, ≈ 4 kr) | Kullanıcı | Üretildi: 8 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcının genel onayıyla ("tüm onayları verdim") metin ve çeviri onaylı işaretlendi (H-028); editör toplu okuması yine önerilir.
