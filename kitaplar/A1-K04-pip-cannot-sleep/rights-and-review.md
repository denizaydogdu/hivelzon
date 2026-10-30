# Haklar ve inceleme: A1-K04 Pip Cannot Sleep

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A1-K04; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** "Koyun saymak" genel bir halk deyişidir; başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok; Pip özgün, markasız bir ev robotudur.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (3 görsel, GPT Image 2.5, 2026-10-14) ve İngilizce anlatım sesi (ElevenLabs `eleven_v3`, anlatıcı Sarah; 2026-10-14) de yapay zekâ ile üretildi; kayıtlar `PROMPTS.md`'de. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Korku yok: gece, karanlık ve uykusuzluk sakin, ninni tonunda anlatılır.
- Zara gece kalktığında yalnız değildir; evde ailesi vardır, Pip ona yatağında hikâye okur. Kimse azarlanmaz (dökülen süt bile Pip'in kendi temizlediği küçük bir kazadır).
- Robotun "uyumak istemesi" duygusal ama kaygı verici değil; son huzurlu ve dinleyiciyi uykuya davet eder.

## Dil denetimi
- `book-lint`: cümle ≤ 8 kelime, kapsama %98,1 (CEFR-J A1, özel adlar hariç; sözlükle %100), 804 kelime (hedef 560–840), 10 sayfa, 2 bölüm. Sonuç commit anında temiz (0 hata).
- Seviye üstü kelimeler (robot, blanket, count, cannot) `glossary.md`'de Türkçesi ve örnek cümlesiyle.
- Anlatıcı birinci tekil kişidir ("I tell you a story tonight."); sonda anlatıcının Pip olduğu açıklanır. Zarf yerine sıfat kullanıldı (*He is slow and quiet.*) ki A1'de yanlış dilbilgisi öğretilmesin.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 3 görsel) | Kullanıcı | Üretildi: 3 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| 2026-10-14 | Seslendirme (ElevenLabs Creator, ticari, Sarah) | Kullanıcı | Üretildi: c1–c2 (2/2 bölüm), 4060 karakter, Sarah `eleven_v3`; hesap/plan kitap kaydında yok |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.
