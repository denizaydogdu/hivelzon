# Haklar ve inceleme: B2-K04 The Last Gardener on Mars

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B2-K04; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da diziden alıntı yok. Gerçek kişi, ünlü, marka, uzay ajansı, şirket ya da telifli karakter yok. Kestrel Kolonisi, konsey ve bütün karakterler uydurmadır. Bilimsel arka plan genel bilgidir: Mars yılı yaklaşık 687 Dünya günüdür ve mevsimleri Dünya'dakinden uzundur; birçok bitki gün uzunluğundaki değişimi algılayıp kışa hazırlanır (yaprak döker, uykuya geçer). Hikâyedeki "Mars yılına uyum" ve tohum seçimi kurgusaldır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (6 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Fiziksel tehlike yok; gerilim tamamen bilimsel bir bilmeceden ve bir oylamadan gelir.
- Konsey bir "kötü adam" olarak çizilmez: Kofi'nin annesi kararın korkudan ve sorumluluktan geldiğini açıklar; Meclis Üyesi Hale sonunda adil davranır. Yetişkinlerle anlaşmazlık saygılı biçimde, kanıtla çözülür (gizlice girme ya da kural çiğneme yok; Kofi stajyer olarak tohum deposunun anahtarına sahiptir).
- Dr Lindqvist'in geçmişte dışlanması kısa ve sakin bir dille anlatılır; kimse aşağılanmaz. Gençler arasında romantik bir çizgi yok.

## Dil denetimi
- `book-lint` (2026-10-14): 5.292 kelime (B2 hedefi 4.000–6.000), 24 sayfa, 5 bölüm, 485 cümle; kapsama %99,5 (CEFR-J ≤ B2, özel adlar hariç; sözlükle %100). Liste dışı: colony, councillor(s), chamber, (two-)hundredth, sensors; hepsi sözlükte. Çeviri 490/490 birim, 5.154/5.154 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, ses ve görsel henüz yok).
- B2 dilbilgisi odakları ve Türk öğrenci notları (edilgen, dolaylı anlatım, 2. ve 3. tip koşul, *wish*, *must / can't have*, present perfect continuous, virgüllü ilgi cümlesi, ettirgen *have*, future continuous / perfect, *despite / whereas / however*) `glossary.md`'de Türkçesi ve metinden örnek cümlesiyle.
- Anlatı dilbilgisi standart İngiliz İngilizcesidir (*organised, colour, humour, favour*; *Mr, Ms, Dr* noktasız): geçmişteki bir andan önceki olaylarda past perfect (*He had never seen a forest, a field or a river.*).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel, ≈ 3 kr) | Kullanıcı | Üretildi: 6 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
