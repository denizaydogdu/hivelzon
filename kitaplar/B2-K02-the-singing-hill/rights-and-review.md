# Haklar ve inceleme: B2-K02 The Singing Hill

## Kaynak ve haklar
- **Özgün eser.** Metin, katalogdaki özet (`kitaplar/KATALOG.md`, B2-K02; kullanıcı onayı 2026-10-14, H-065) temel alınarak Claude tarafından yazıldı (2026-10-14, H-072). Uyarlama değildir.
- **Üçüncü taraf kaynak yok.** Başka bir kitaptan, filmden ya da şarkıdan alıntı yok. Gerçek kişi, ünlü, marka, kurum ya da telifli karakter yok. Kapadokya yalnızca bölge olarak geçer; köy, tepe ve yeraltı şehri adsız ve uydurmadır. 1964 kazı raporu, hava borusu "çalgısı" ve 300 yıl önceki deprem kurgudur; gerçek bir yeraltı şehrinin ya da kazının tarihi anlatılmaz. Balonlar markasızdır.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile yapıldı (atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`). Yasak kaynaklar (Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC) kullanılmadı ve isteme konmadı.
- **Yapay zekâ açıklaması:** Metin ve Türkçe çeviri taslağı yapay zekâ (Claude) ile üretildi; `book.json → aiGenerated: true`. Görseller ve ses de yapay zekâ ile üretilecek (henüz üretilmedi). Uygulama içinde AI notu bölümlerdeki kuralla gösterilir; uygulama dışına çıkan her kesitte AI etiketi gömülür (K-14).

## Güvenlik (13+, şartname §5.5)
- Şiddet, cinsellik, siyaset ve din yok. Kimse yaralanmaz; en büyük "acı" taş taşımaktan ağrıyan kollardır.
- **Tünel ve kazı güvenliği bilinçli işlenir:** Gizlice girme fikri açıkça reddedilir ("Some doors are closed for a reason."; Defne: "We do it properly."). Gençler izinsiz girmek yerine yazılı bir öneri hazırlar; iniş resmî izinle, mühendis kontrolünden sonra, ahşap destekler takılarak, baret, lamba, telsiz ve iple, iki saatlik sınırla ve kapıda bekleyen bir görevliyle yapılır. Taş yığını mühendislerin onayıyla, elle ve kayıt altında kaldırılır. Okura taklit edilecek riskli bir davranış gösterilmez.
- Kültürel temsil saygılıdır: köylüler bilgili ve yardımseverdir; yaşlı Kemal Bey'in aktardığı halk bilgisi hikâyenin çözümünde doğru çıkar. Türkçe adlar doğru yazılır (Aydın, Hakan).
- Gençler arasında romantik bir çizgi kurulmadı.

## Dil denetimi
- `book-lint` (2026-10-14): 5.287 kelime (B2 hedefi 4.000–6.000), 23 sayfa, 5 bölüm, 479 cümle; kapsama %99,8 (CEFR-J ≤ B2, özel adlar hariç; sözlükle %100). Liste dışı: archaeology, ministry, fourth, sixth, seventh, hava bacası; hepsi sözlükte. Çeviri 484/484 birim (başlıklar dahil), 5.134/5.134 kelime anlamlı; 0 hata (uyarılar: çeviri DRAFT, ses ve görsel henüz yok).
- B2 dilbilgisi metne doğal olarak yerleştirildi ve `glossary.md`'de Türkçe notlarıyla örneklendi: edilgen (*had been cut, were carved by hand, has been tested*), dolaylı anlatım (*asked whether you had brought*, *told him to bring*), 2. ve 3. tip koşul, *wish / if only*, *must have / can't have / might have*, present perfect continuous, virgüllü ilgi cümleleri, ettirgen *have something done*, future continuous / perfect, *although / despite / however / whereas*.
- Anlatı dilbilgisi ve yazım standart İngiliz İngilizcesidir (*kilometres, grey, torch*; *Mr, Dr* noktasız).

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-14 | Metin, çeviri ve sözlük taslağı | Claude | DRAFT |
| — | Metin ve çeviri onayı (H-028) | Kullanıcı | **Bekliyor** |
| — | Görsel maliyet onayı ve üretim (kapak + bölüm başı, 6 görsel, ≈ 3 kr) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Seslendirme (ElevenLabs Creator, ticari; anlatıcı Sarah) | Kullanıcı | Bekliyor (henüz üretilmedi) |
| — | Editör toplu kontrolü | Editör | Bekliyor |

- 2026-10-14: Kullanıcı metni ve Türkçe çeviriyi onayladı (H-028). Görseller kapak + bölüm başı.
