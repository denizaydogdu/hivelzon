# Haklar ve inceleme: A2-K01 The Lemon Cake Mystery

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, A2-K01; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-071). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, diziden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka ya da telifli karakter yok. Lokanta, Selim Bey'in pasta dükkânı ve kek yarışması adsız ve hayalîdir; Ayvalık yalnızca yer adı olarak geçer, gerçek bir işletmeye gönderme yok. Kekteki tarif de hayalîdir (kitaptaki "yanlış kart" bilerek tutarsız yazıldı).
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (5 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. "Suç" yalnızca kaybolan bir tarif kartıdır ve bir şakaya dönüşür; kimse suçlanmaz ya da cezalandırılmaz.
- Şüpheliler (Bora, Theo, Selim Bey) aşağılanmaz; Elif üçünü de sever ve şüphesini kibarca sorar. Theo'nun dil öğrenmesi olumlu gösterilir (Füsun Teyze ile dil değişimi).
- Gece yarısı mutfak sahnesi sakin ve aile içidir; tehlike yok. Yarışmada ikincilik utandırılmaz, birlikte gülünür (ürün ilkesi: utandırıcı dil yok).

## Dil denetimi
- `book-lint` (2026-10-14): 1.549 kelime (A2 hedefi 1.200–1.800), 16 sayfa, 4 bölüm, 253 cümle; en uzun cümle 12 kelime; kapsama CEFR-J ≤ A2 %98,6 (sözlükle %100; özel adlar hariç). 0 hata.
- Liste dışı kelimeler (recipe, suspects, detective, sour, mint) `glossary.md`'de Türkçesi ve örnek cümlesiyle; ayrıca make / do, karşılaştırma (drier, more sour), düzensiz geçmiş (hid) ve going to notları.
- Çeviri: 257 satırın hepsi (bölüm başlıkları dahil) Türkçe; özel ad dışındaki bütün kelimelerin anlamı var. Durum DRAFT.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 5 görsel) | Kullanıcı | Üretildi: 5 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı olarak üretilecek.
