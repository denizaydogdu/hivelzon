# Haklar ve inceleme: A2-K02 Into the Fog

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A2-K02; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok; dağ, göl ve köy adsızdır, fotoğraf makinesi ve telefon markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (5 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Kilise yalnız "burada kilise yok" cümlesinde, dinî içerik olmadan geçer (çan sesinin kaynağı sorusu).
- Gerilim var ama korku yok: sisteki karaltılar bir sayfa içinde keçi olarak açıklanır; kimse kaybolup zarar görmez. Tek yaralanma burkulmuş bir ayak bileğidir ("It isn't broken. You're going to be fine.").
- **Doğru güvenlik davranışı öne çıkar:** birlikte kalmak, tek yerde beklemek, sıcak kalmak (gümüş battaniye, rüzgârsız kaya arkası), yiyeceği paylaşmak. Paloma'nın hatası (yoldan ayrılmak, kuralı dinlememek) utandırmadan, kendi sözüyle düzeltilir ("next time, I'm going to listen first").
- Öğretmen gruptan sorumlu ve çocukları arıyor; çocuklar bir yetişkinin söylediği kuralla güvenle dönüyor.

## Dil denetimi
- `book-lint` (2026-10-14): 1.571 kelime (hedef 1.200–1.800), 15 sayfa, 4 bölüm, 280 cümle; en uzun cümle 12 kelime; kapsama %99,0 (CEFR-J ≤ A2, özel adlar hariç); 0 hata.
- Liste dışı kelimeler (goat/goats, shelter, ding) `glossary.md`'de Türkçesi ve örnek cümlesiyle.
- Çeviri: 284/284 satır, 1.481/1.481 kelime anlamlı (DRAFT).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 5 görsel) | Kullanıcı | Üretildi: 5 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; ses: Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.
