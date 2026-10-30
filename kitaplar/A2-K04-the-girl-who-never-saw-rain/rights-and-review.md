# Haklar ve inceleme: A2-K04 The Girl Who Never Saw Rain

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A2-K04; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok; Ay kasabası (Lunaria) ve uzay gemisi kurmaca ve markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (5 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Tehlike yok: uzay yolculuğu ve Dünya'ya alışma sakin anlatılır; açık gökyüzü korkusu yumuşak bir dille işlenir ve Nia onu adım adım yener.
- Kuraklık bir felaket gibi değil, bir çiftliğin sabırlı bekleyişi olarak anlatılır. Ağlama sahnesi kısa ve utandırmadan yazıldı.
- Leo'nun "sahte yağmuru" bir yalan olarak cezalandırılmaz; iyi niyetli bir jest olarak görülür ve itirafla, gülerek kapanır. Gece dışarı çıkma evin bahçesiyle sınırlıdır; yetişkinler yakındadır.

## Dil denetimi
- `book-lint`: cümle ≤ 12 kelime, kapsama ≥ %98 (CEFR-J ≤ A2, özel adlar hariç), kelime sayısı 1.200–1.800. Sonuç 2026-10-14: 1.548 kelime, 16 sayfa, 4 bölüm, 249 cümle; kapsama %99,7 (liste dışı: born, pipes, pyjamas, hepsi sözlükte); 0 hata.
- Seviye üstü kelimeler ve dil notları `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 5 görsel) | Kullanıcı | Üretildi: 5 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.

- 2026-10-14: p09'daki "the biggest clouds Nia ever saw" cümlesi (A2'de past perfect gerektiren yapı) karşılaştırmayla yeniden yazıldı (H-076 müfredat incelemesi).
