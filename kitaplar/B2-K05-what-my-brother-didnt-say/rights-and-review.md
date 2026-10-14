# Haklar ve inceleme: B2-K05 What My Brother Didn't Say

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B2-K05; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Kasaba (Kilbrannock) uydurmadır; İrlanda kıyısında adsız bir koyda geçer. Sigorta şirketi, üniversite ve postane adsızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Aile gerginliği sakin bir dille işlenir: baba kızgındır ama hiç bağırmaz, kimseyi aşağılamaz ve tehdit etmez; kapıyı bile çarpmaz. Gerginlik bir yanlış anlamadan doğar ve sevgiyle çözülür.
- Daniel'ın üniversiteyi bırakması övülmez ya da yerilmez; iki tarafın da gerekçesi gösterilir (babanın güvenli seçim kaygısı, Daniel'ın el emeğine duyduğu istek).
- Sophie'nin ağabeyini takip etmesi gündüz başlayan, tehlikesiz bir sabah koşusudur; kimseye zarar gelmez ve sonunda saklanmak yerine kendini gösterir.
- Tekne atölyesi: aletler ve küçük kesikler gerçekçi ama hafif anlatılır (yara bandı, iyileşen kesikler). Suya indirmede herkes can yeleği giyer; yaşlı usta babaya da can yeleği olmadan izin vermez. Tekne kalabalık önünde, yetişkin denetiminde ve sakin havada suya indirilir.
- Bay Doyle'un eşinin ölümü tek cümleyle, ayrıntısız anlatılır.

## Dil denetimi
- `book-lint` (2026-10-14): 5.006 kelime (B2 hedefi 4.000–6.000), 22 sayfa, 5 bölüm, 553 cümle; kapsama %99,3 (CEFR-J ≤ B2, özel adlar hariç; sözlükle %100). Liste dışı: boatyard, fishermen, apprentice, sawdust, gulls, scraping, hoover, plaster, flask; liste aracının tanımadığı düzensiz biçimler: became, halfway, lit, shone, feet; hepsi sözlükte. Çeviri 558/558 birim, 4.897/4.897 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, ses ve görsel henüz yok).
- Özel adlar (`properNouns`): Sophie, Soph, Daniel, Byrne, Doyle, Tommy, Kelly, Kilbrannock, Christmas.
- B2 yapıları ve Türk öğrenci notları (present perfect continuous + süre, geçmişe dair çıkarım modalları, 2. ve 3. tip koşul, should have, wish / if only, dolaylı anlatım, edilgen ve ettirgen yapı, future continuous / perfect, whereas / despite / however) `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (Mr / Mrs noktasız; jumper, hoover, petrol, half seven gibi İngiliz/İrlanda günlük kullanımları bilinçli).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel, ≈ 3 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
