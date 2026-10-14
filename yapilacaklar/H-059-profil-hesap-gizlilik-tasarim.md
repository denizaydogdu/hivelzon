# H-059: Profil, Hesap, "Hi benim hakkımda" ve hukuk metni tasarımı

- **Durum:** Yapılacak
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T2 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057, H-058

## Kapsam
- **Profil:** şekilli illüstrasyonlu başlık (ad + selamlama), istatistik şeridi (`StatRow`: ifade, bölüm, haftalık tekrar), gruplanmış ayarlar (`SettingsGroup`: Defter, Günlük hedef, Söyle, Hesap, Gizlilik); açıklamalar satır altı ipucu. Kullanıcı şikâyeti: "her şey iç içe, düz yazı gibi".
- **Hesap:** durum kartı + birincil eylem + "Tehlikeli bölge" (silme kırmızı); giriş adımları yeni girdi ve düğme bileşenleriyle.
- **"Hi benim hakkımda ne biliyor?":** sayılar `StatTile`, gruplar, silme tehlike düğmesi.
- **Hukuk metni ekranı:** başlıklı bölümler, okunur satır genişliği.
- H-042'nin profil kısmı bu işe taşındı.

## Kabul kriterleri
- Simülatörde önce/sonra montajı; golden testler; kullanıcı onayı; testler yeşil.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-059/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-059-profil-hesap-gizlilik-tasarim`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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
