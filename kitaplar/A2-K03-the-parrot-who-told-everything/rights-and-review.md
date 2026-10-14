# Haklar ve inceleme: A2-K03 The Parrot Who Told Everything

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A2-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-069). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Ninni ("Little boat, little boat…") bu kitap için yazılmış özgün iki dizedir; bilinen bir şarkıdan alınmadı. Gerçek kişi, ünlü, marka ya da telifli karakter yok; müzik dükkânı ve gitar markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Kimse zarar görmüyor: kedi kaçar ama hemen geri gelir; un ve köpük dağınıklığı zararsız bir kargaşadır.
- Mizah kimseyi aşağılamaz. Max'in söylediği en sert söz "silly cat"tir. Çocuklar bir an tek başına kalmaz; Max hep evdedir.
- Para konusu sakin işlenir: Max işini kusurlu yapsa da emeği görülür; son, utandırmak yerine takdirle biter (ürün ilkesi: utandırıcı dil yok).

## Dil denetimi
- `book-lint`: cümle ≤ 12 kelime, kapsama ≥ %98 (CEFR-J ≤ A2, özel adlar hariç), kelime sayısı 1.200–1.800. Sonuç commit anında temiz (0 hata).
- Seviye üstü kelimeler `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs, iç kullanım) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller üretildi (GPT Image 2.5, özgün istem; kayıt PROMPTS.md). Ses henüz üretilmedi.
