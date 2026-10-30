# Haklar ve inceleme: A1-K05 The Window Across

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A1-K05; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok; şehir adsızdır, fırın markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (3 görsel, GPT Image 2.5, 2026-10-14) ve İngilizce anlatım sesi (ElevenLabs `eleven_v3`, anlatıcı Sarah; 2026-10-14) de yapay zekâ ile üretildi; kayıtlar `PROMPTS.md`'de. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Tehlike yok; kar fırtınası yalnızca kedinin sıcak fırına sığınma nedenidir, kedi sağ salim bulunur.
- Omar'ın Faslı oluşu saygıyla ve kalıp yargı olmadan anlatılır: annesinin ekmeği ve yeşil çayı sıcak bir memleket bağıdır. Din, siyaset ve göç tartışması yok.
- Yetişkin–çocuk ilişkisi güvenli kurulur: Omar kızın kapısına gider, kapıyı annesi açar; bütün sahneler annenin yanında geçer.
- Dil bilmemek utandırılmaz: Omar'ın "yavaş kelimeleri" sonda "That is OK." ile kabul edilir (ürün ilkesi: utandırıcı dil yok).

## Dil denetimi
- `book-lint`: cümle ≤ 8 kelime, kapsama %98,6 (CEFR-J A1, özel adlar hariç; sözlükle %100), kelime sayısı 791 (hedef 560–840), 10 sayfa, 2 bölüm. Sonuç: 0 hata.
- Seviye üstü kelimeler (wave, across, flour, fridge) `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 3 görsel) | Kullanıcı | Üretildi: 3 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| 2026-10-14 | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Üretildi: c1–c2 (2/2 bölüm), 3968 karakter, Sarah `eleven_v3`; hesap/plan kitap kaydında yok |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.
