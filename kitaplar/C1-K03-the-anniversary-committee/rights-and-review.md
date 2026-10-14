# Haklar ve inceleme: C1-K03 The Anniversary Committee

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, C1-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-073). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Şirket (Brindle Umbrellas), kasaba (Wexley Bridge), deniz kasabası (Seaborough) ve bando (Wexley Bridge Silver Band) uydurmadır. Matbaa, banka, sigorta şirketi ve dış muhasebeci adsızdır.
- **Kelime listesi:** C1 için CEFR-J Wordlist v1.6 + Octanove C1/C2 öngörülür (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi. Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Mizah kurumsal hayatın küçük absürtlüklerinden doğar; kimse aşağılanmaz, alay hedefi kişiler değil alışkanlıklardır (logo tartışması, alt komiteler, kurumsal klişeler).
- **Havai fişek:** Jasper'ın "kapalı alanda havai fişek" ve "soğuk kıvılcım" önerileri her seferinde reddedilir (Gwen ve fabrikanın iş güvenliği sorumlusu); yerine köpük makinesi konur. Metin, kapalı alanda ateşle oynamayı özendirmez, tersine bunun neden tehlikeli olduğunu söyler.
- Kurucu Albert Brindle'ın ölümü tek bir yumuşak ifadeyle (passed away) geçer; ayrıntı yok. Yaşlı karakterler (Bay Penrose 81, Dorothy 68) saygıyla ve yetenekli insanlar olarak anlatılır.
- Ofis kültürü: aşırı mesai (yedi buçuk – yedi) ve terfi kaygısı hafif ve ironik bir dille işlenir; övülmez. Son, dürüstlüğün ödüllendirildiği sıcak bir sahnedir.
- Alkol yok (kutlamada bardak yalnız tıklatılır; Albert'in "years are for wine" sözü tek bir espri olarak kalır). Doğum sahnesi yalnız günlükteki iki satırdır (Seven pounds and very loud).

## Dil denetimi
- `book-lint` (2026-10-14): 8.585 kelime (C1 hedefi 6.400–9.600), 27 sayfa, 6 bölüm, 770 cümle; 0 hata. Kapsama: C1 için Octanove C1/C2 listesi depoda yok; kapsama denetlenmedi (uyarı). Çeviri 776/776 birim (bölüm başlıkları dahil), 8.240/8.240 kelime anlamlı; uyarılar: çeviri DRAFT, ses ve görsel henüz yok.
- Özel adlar (`properNouns`): Gwen, Holloway, Howard, Brindle, Albert, Clive, Marsh, Jasper, Nell, Okafor, Derek, Pole, Ambrose, Penrose, Dorothy, Fairweather, Margaret, Wexley, Seaborough, Grandad.
- C1 yapıları (devrik yapı, cleft, karma koşul, ortaç yan cümleleri, modal incelikleri, kişisiz edilgen, gerçek dışı geçmiş, eksiltme ve yerine koyma), kaçamak edilgen, temkinli dil, kurumsal klişeler, deyimler ve Türk öğrenci notları `glossary.md`'de (44 girdi) Türkçesi ve metinden birebir örnek cümlesiyle.
- Anlatı standart İngiliz İngilizcesidir (realise, colour, centre, programme, metre, maths; Mr / Ms / Mrs noktasız; flat, lift, car park, torch, trainers, biscuit tin gibi İngiliz kullanımları bilinçli). Jasper'ın argosu (huge, a vibe, massively) ve kurumsal dil (going forward, circle back, take this offline, revert in due course) üslup karşıtlığı için bilinçli.
- Tarihler tutarlı: 10 Haziran 1977 cuma, 7 Haziran 1977 salı (Howard'ın doğumu); kutlama 12 Haziran cuma; 10 Haziran 1976 perşembe (p24'teki ipucu).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 7 görsel, ≈ 3,5 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcının genel onayıyla ("tüm onayları verdim") metin ve çeviri onaylı işaretlendi (H-028); editör toplu okuması yine önerilir.
