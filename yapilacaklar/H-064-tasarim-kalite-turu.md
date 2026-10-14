# H-064: Tasarım kalite turu (erişilebilirlik, golden, temizlik)

- **Durum:** Yapılacak
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T7 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-059 … H-063, H-040

## Kapsam
- Bütün ekranlarda erişilebilirlik testleri (`meetsGuideline`: dokunma hedefi, kontrast, etiket).
- 1,3× metin büyütmede taşma testleri; golden kapsamının tamamlanması.
- Kalan sabit stil ve metinlerin temizliği; `docs/ARAYUZ-METINLERI.md` ve `tasarim/README.md` son hâli.

## Kabul kriterleri
- Sabit stil sayıları sıfıra yakın (rapor); bütün testler yeşil.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-064/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-064-tasarim-kalite-turu`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

## Kullanıcı kararları (2026-10-14, soru-cevap)
- Bütçe ~8 kr (Higgsfield, GPT Image 2.5 orta 1k: ~10 ekran taslağı + ~6 illüstrasyon); Hi ifadeleri kodla çizilir. Her üretimden önce maliyet gösterilir.
- Yazı tipi: başlıklar yuvarlak/sıcak (Nunito ya da Fredoka, OFL), metin Inter (OFL); uygulamaya gömülü.
- Yalnız açık tema (karanlık mod sonra ayrı iş; sistem hazır kurulur).
- Sıra: tasarım sistemi + Profil önce; H-039 ve H-040 yeni tasarımla.
- Hareket dili: yumuşak geçişler, dokunma tepkisi, sırayla belirme, dolan halka/çubuk, Hi ifadeleri, harita ışığı, sakin kutlama, hafif haptic; "Hareketi azalt" açıksa statik. K-32 yasakları korunur.
- Araçlar: Higgsfield; `frontend-design` skill'i ve AwesomeDesign standartları; 21st.dev Magic yalnız fikir panosu (web üretir, Flutter'a doğrudan girmez); `flutter_animate` (MIT).
- Plan: `/Users/felece/.claude/plans/ek-i-olarak-sayfalar-n-delightful-elephant.md` → özeti `docs/UYGULAMA-PLANI.md` "Tasarım yenilemesi".

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Sayfaların tasarımlarıyla ilgilenen bir iş aç; Profilim sayfasını hiç beğenmedim, her şey iç içe, düz yazı gibi. Daha animasyonlu, şekilli, kullanıcıyı çekecek tasarımlar."
2026-10-14 (H-061 kararı): Doğru cevaptaki hafif titreşim için Profil > Öğrenme'de "Titreşim" aç/kapa anahtarı (varsayılan açık); bütün haptic çağrıları bu ayara bağlanır.

