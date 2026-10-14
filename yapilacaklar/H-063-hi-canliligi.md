# H-063: Hi'nin canlılığı (ifadeler ve animasyonlar)

- **Durum:** Yapılacak
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T6 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057

## Kapsam
- Kodla çizilen Hi'ye ifade durumları: mutlu, düşünen, el sallayan, uykulu, şaşkın; geçiş animasyonları.
- Hi balonunda hafif "nefes alma"; panelde ifade durumla eşleşir.
- Hi paneli bileşenlere bölünür (700 satır).

## Kabul kriterleri
- İfade vitrini; "hareketi azalt" testi; K-32 ve ürün ilkelerine uygunluk (bağımlılık yaratan efekt yok).
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-063/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-063-hi-canliligi`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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
