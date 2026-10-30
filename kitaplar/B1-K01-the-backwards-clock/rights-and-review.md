# Haklar ve inceleme: B1-K01 The Backwards Clock

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B1-K01; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok; dağ kasabası Haldenberg, saatçi dükkânı, kafe ve kütüphane kurmaca ve markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller (6 görsel, GPT Image 2.5, 2026-10-14) de yapay zekâ ile üretildi (kayıt `PROMPTS.md`); ses de yapay zekâ ile üretilecek, henüz üretilmedi. Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. "Hayalet" korkutucu değil, kasabanın meraklı dedikodusudur; gece sahneleri gerilimli ama tehlikesizdir ve sonunda gülerek çözülür.
- Suç yok: saati geri çeviren yaşlılar kimseye zarar vermez; saat ertesi hafta Aziz tarafından onarılır. Aziz'in haksız yere şüphelenilmesi açıkça kabul edilir ve Bayan Brandt özür diler.
- Aziz'in gece kuleye çıkması kendi anahtarıyla, kasaba meydanı insanlarla doluyken olur; yetişkinler yakındadır. Yaşlılık (dizler, yorgunluk) saygıyla ve sıcak bir mizahla anlatılır.

## Dil denetimi
- `book-lint` (2026-10-14): 5 bölüm, 20 sayfa, 351 cümle, 3.151 kelime (hedef 2.400–3.600); kapsama %98,7 (CEFR-J ≤ B1, özel adlar hariç), sözlükle %100. Liste dışı: backwards, apprentice, clockmaker, storeroom, hum, feet, footprints, torch, clap, accordion, spin, countdown, footsteps, screwdriver, lever; hepsi sözlükte. Çeviri 356/356 birim, her kelimenin anlamı var. 0 hata.
- B1 dilbilgisi yapıları (ileride dilbilgisi derslerine bağlanmak üzere): *used to*, past perfect, present perfect (*ever / never, for / since, yet*), past continuous (*while*), 1. tip koşul, ilgi cümleleri, *might*, *-ed / -ing* sıfatları. Notlar `glossary.md`'de.
- Seviye üstü kelimeler ve dil notları `glossary.md`'de Türkçesi ve örnek cümlesiyle.

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| 2026-10-14 | Metin ve çeviri onayı (H-028) | Kullanıcı | Onaylandı (`ceviri.tr.json` → `APPROVED`; onaylayan: kullanıcı, ürün sahibi) |
| 2026-10-14 | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel) | Kullanıcı | Üretildi: 6 görsel, GPT Image 2.5 (iş kimlikleri `PROMPTS.md`) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi; 2026-10-30 itibarıyla çalışan ElevenLabs erişimi yok) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
