# Haklar ve inceleme: A2-K03 The Parrot Who Told Everything

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A2-K03; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-069). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Ninni ("Little boat, little boat…") bu kitap için yazılmış özgün iki dizedir; bilinen bir şarkıdan alınmadı. Gerçek kişi, ünlü, marka ya da telifli karakter yok; müzik dükkânı ve gitar markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (15 görsel, GPT Image 2.5, 2026-10-14) ve İngilizce anlatım sesi (ElevenLabs `eleven_v3`, anlatıcı Sarah; 2026-10-14) de yapay zekâ ile üretildi; kayıtlar `PROMPTS.md`'de. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

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
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim | Kullanıcı | Üretildi: 15 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| 2026-10-14 | Seslendirme (ElevenLabs, iç kullanım) | Kullanıcı | Üretildi: c1–c3 (3/3 bölüm), 7826 karakter, Sarah `eleven_v3`; hesap: c1–c2 videoGenerator ücretsiz kotası (`kitaplar/_maliyet/elevenlabs-hesap1-karakter.json`), c3 ayrı anahtar; c3 hesabının planı kayıtta yok; ücretsiz hesap sesleri için H-006 ek (hukukçu görüşü) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller üretildi (GPT Image 2.5, özgün istem; kayıt PROMPTS.md). Ses henüz üretilmedi. (2026-10-14 itibarıyla; ses sonradan üretildi, tabloya bakın.)
