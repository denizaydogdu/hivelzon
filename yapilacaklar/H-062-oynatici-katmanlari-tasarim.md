# H-062: Oynatıcı katmanlarının tasarımı

- **Durum:** Yapılacak
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T5 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057

## Kapsam
- Oynatıcı paleti belirteçlere: karar, ipucu, kartlar (not, mesaj, satır), görevler, bölüm sonu, 🎯 görev paneli, anlam paneli (13 satır içi stil → tema).
- ~42 sabit Türkçe metin `tr_strings.dart`'a.
- Karar kartı ve Hi panelinde giriş animasyonları; bölüm sonu sakin kutlaması.

## Kabul kriterleri
- Oynatıcı testleri yeşil; H-031/H-054 ölçümleri bozulmaz (geçiş ≤ 150 ms, senkron ≤ 0,2 sn); önce/sonra.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-062/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-062-oynatici-katmanlari-tasarim`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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
