# Haklar ve inceleme: A1-K01 The Blue Door

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A1-K01; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-069). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Gizem korkutucu değil; tehlike yok, kimse cezalandırılmıyor.
- Lina'nın gece merdivene çıkması sakin anlatılır; macera bir komşuluk sırrıyla, dostlukla biter.

## Dil denetimi
- `book-lint`: cümle ≤ 8 kelime, kapsama ≥ %98 (CEFR-J A1, özel adlar hariç), kelime sayısı 560–840. Sonuç commit anında temiz (0 hata).
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
