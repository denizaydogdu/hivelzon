# Haklar ve inceleme: A2-K05 Good Morning, Wrong Number

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A2-K05; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok. Ada, plaj ve kafe adsızdır; telefon ve uygulama markasızdır.
- **Ad yazımı:** Katalogdaki *Inês*, metinde **Ines** olarak yazıldı. Kapsama ve özel ad denetimi (`hvpipeline/book.py`, `cefr.py`) `ê` harfini tanımıyor ve adı "In" + "s" diye bölüyordu; ayrıca TTS'te sade yazım daha güvenli. Kullanıcı isterse `ê` desteği araçlara ayrıca eklenir.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (5 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Kırık bacak bir bisiklet kazasıdır; acı ve tehlike anlatılmaz.
- **Çevrim içi güvenlik bilinçli işlendi:** 15 yaşındaki Mateo'ya tanımadığı bir numaradan mesaj geliyor. Mateo ilk gün annesine gösterir ("It was a family rule", p03). Anne kuralları açıkça söyler: kendi fotoğrafını gönderme, adres verme, önce bana göster. İlk cevap annesiyle birlikte, isimsiz yazılır (p05); sonraki mesajlar her sabah annesiyle okunur (p07). Yabancı hiç ad ya da adres sormaz.
- "Evimizi görebiliyor" anı (p08) korkuya dönüşmez: anne sakin bir açıklama yapar (plajdaki herkes sarı evi görebilir, p09).
- Buluşma tek başına değildir: Mateo plaja annesiyle gider ("That's the rule", p13), yer kalabalık, herkese açık bir plajdır ve gönderen Mateo'nun çocukluktan tanıdığı yüzme öğretmeni çıkar. Hikâye "yabancıyla buluşmak" fikrini özendirmez; aile kuralı her adımda geçerlidir.
- Utandırıcı dil yok: Mateo'nun *boring / bored* karışıklığı annesi tarafından gülerek düzeltilir.

## Dil denetimi
- `book-lint`: 1.512 kelime (hedef 1.200–1.800), 15 sayfa, 4 bölüm, 242 cümle; en uzun cümle 12 sözcük; kapsama %98,8 (sözlükle %100; CEFR-J ≤ A2, özel adlar hariç). Çeviri 246/246 satır, 1.468/1.468 kelime anlamlı. Commit anında 0 hata.
- Seviye üstü kelimeler (cast, sand, whistle, swimmers, dolphins, lifeguard, volunteers) ve kısa mesaj dili (nr, pls, dont) `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 5 görsel) | Kullanıcı | Üretildi: 5 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.
