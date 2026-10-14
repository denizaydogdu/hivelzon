# H-058: Ekran taslakları v2 ve illüstrasyonlar (Higgsfield, ~8 kr)

- **Durum:** Devam ediyor (taslaklar üretildi; kullanıcı onayı bekliyor)
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T1 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057

## Kapsam
- ~10 ekran taslağı: Profil, Hesap, Hi paneli, Defter, Kelime tekrarı, Konu seti, Ana Sayfa, Harita, Açılış (H-039), Keşfet (H-040). GPT Image 2.5, 9:16, orta, 1k (~0,5 kr).
- ~6 illüstrasyon: profil başlığı, boş durumlar (defter, ipucu panosu, konu seti, tekrar yok, bağlantı yok).
- Ortak prompt: T1–T6 dili + H-057 belirteçleri. Görselde yazı yok; metin uygulamada (kural 7).
- Maliyet önce gösterilir; kayıtlar `tasarim/PROMPTS.md` v2; belirteçler ve ekran notları `tasarim/README.md` v2.
- Kullanıcıya montaj (tasarım panosu) gösterilir; onaylanan taslaklar sonraki fazların görsel ölçüsü olur.

## Kabul kriterleri
- Maliyet onaylı; taslaklar kullanıcı onaylı; illüstrasyonlar WebP olarak uygulamada.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-058/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-058-ekran-taslaklari-v2`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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
2026-10-14: 10 ekran taslağı + 6 illüstrasyon üretildi (8 kr; 68,06 → 60,06). Kayıt `tasarim/v2/PROMPTS.md`, önizlemeler `tasarim/v2/onizleme/`, illüstrasyonlar `mobile/assets/illustrations/*.webp`. Kullanıcı onayı bekleniyor.
