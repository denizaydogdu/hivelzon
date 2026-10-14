# Haklar ve inceleme: A1-K03 The Red Kite

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A1-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok. Kasaba, pazar, tramvay ve feribot hayalîdir ve adsızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (kapak + bölüm başı) ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Tehlike yok: Ravi kimseyle çatışmaz, yabancılar (meyveci, feribottaki kadın) nazik ve yardımseverdir.
- Ravi şehirde tek başına koşar, ama trafikli bir an ya da düşme anlatılmaz; tramvaya durakta biner, nehri feribotla ve köprüden geçer. Sudan, yükseklikten ya da araçtan gelen bir risk vurgulanmaz.
- Ton sevinçli ve hareketlidir; son, evde, annesiyle ve öğle yemeğiyle sakin biter.

## Dil denetimi
- `book-lint` (2026-10-14): 773 kelime (hedef 560–840), 12 sayfa, 3 bölüm, 158 cümle; en uzun cümle 8 kelime; kapsama %98,2 (CEFR-J A1, özel adlar hariç), sözlükle %100. 0 hata.
- Liste dışı kelimeler (`balcony`, `tram`, `market`, `ferry`, `far`) `glossary.md`'de Türkçesi ve örnek cümlesiyle.
- Çeviri: 161/161 satır, 731/731 kelime anlamlı (DRAFT).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı (H-071) | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 4 görsel) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.
