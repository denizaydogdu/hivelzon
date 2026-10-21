# H-059: Profil, Hesap, "Hi benim hakkımda" ve hukuk metni tasarımı

- **Durum:** Bitti (2026-10-14; flutter test 463/463, CI yeşil, tasarım kullanıcı onaylı)
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

2026-10-14 (uygulama ve doğrulama; kullanıcı onayladı):
- **Profil:** dalga başlık (`profil-baslik.webp`), avatar (adın ilk harfi; ad yoksa Hi), "Merhaba Deniz" / "Merhaba!", haftadan tek satır durum; 3 `StatTile.count` (ifade · bölüm bitti · bu hafta tekrar; sayarak belirir, "Hareketi azalt"ta durağan); `SettingsGroup` "Öğrenme" (Defter, Günlük hedef → `AppSheet`, Söyle anahtarı / "Kapalı" + neden, Konu setleri) ve "Hesap ve gizlilik" (Hesap: "Açık değil" / maskeli e-posta, Hi benim hakkımda…, Adın → `AppSheet`). Ad doğrulama ve kayıt mantığı aynı.
- **Hesap:** oturum kapalıyken çapraz kesimli başlık (`hosgeldin.webp`), yuvarlak renkli ikonlu 3 fayda satırı, büyük sarı "E-postayla devam et"; 13 yaş altı `InfoCard`. Oturum açıkken durum kartı (eşitleme ikonu ve rengi, "Şimdi eşitle" ikincil), sessiz "Çıkış yap", ayrı **Tehlikeli bölge** (kırmızı satırlar; onaylar aynı, son düğme kırmızı). Giriş: tema girdileri, onaylar beyaz grupta, **hata ana düğmenin hemen üstünde** (H-057 bulgusu), form tembel liste yerine tek kaydırma.
- **Hi benim hakkımda ne biliyor?:** Hi + tek cümle, konum `InfoCard`'ı (hesapsız / hesaplı), SAYILARLA 3 `StatTile`, "Bu cihazda saklananlar" salt okunur satırlar, konu çipleri, Son 7 gün şeridi, kırmızı kenarlı silme düğmesi (onay aynı). "Sunucu" kelimesi kaldırıldı.
- **Hukuk metni:** `CapsLabel` sürüm, "Taslak metin" `InfoCard`, başlıklı bölümler (`termsSections` / `privacySections`), en fazla 600 px genişlik.
- Ortak: `ShapedHeader.title` isteğe bağlı; `StatTile.count`; `SettingsRow`, `StatTile`, `InfoCard` ayrı ekran okuyucu düğümü (önce sayfanın tamamı tek düğüme birleşiyordu); `showAppSheet` kök gezginde açılır (Hi balonu panelin üstünde kalıyordu). Illüstrasyonlar `pubspec.yaml`'a eklendi.
- Testler: `flutter analyze` temiz; `flutter test` **463/463** (önce 439). Yeni: `test/goldens/h059_screens_golden_test.dart` (6 golden: profil, profil_adsiz, hesap_kapali, hesap_acik, hi_gizlilik, hukuk; her biri için erişilebilirlik yönergeleri ve 1,3× yazı; Tehlikeli bölge, gizlilik kartları, hukuk genişliği, hata konumu), Profil testinde günlük hedef ve ad panelleri. Stil denetimi tabanı değişmedi (dokunulan dosyalar tabanda yoktu; yeni sabit renk/boyut yok).
- Simülatör: veri yedeği `.yerel/h059/yedek/app-data.tgz`; yalnızca gezinildi, veri değişmedi (Deniz, 15 ifade, 3 bölüm yerinde). Görüntüler `integration_test/h059_screens_test.dart` ile: `.yerel/h059/once-*.png`, `sonra-*.png` (profil, profil-alt, gunluk-hedef, ad, hesap, hi-gizlilik, hi-gizlilik-alt, hukuk), montaj `.yerel/h059/montaj.png`. Oturum açık Hesap yalnızca golden'da (backend açılmadı).
2026-10-14 (ana oturum): flutter test 463/463, analyze temiz yeniden doğrulandı; montaj `.yerel/h059/montaj.png`. Commit edildi; tasarım onaylandı.
2026-10-14: Kullanıcı yeni Profil, Hesap, Hi gizlilik ve hukuk metni tasarımını onayladı ("onayladım"). İş kapandı. Açık metin soruları ("Bu telefondaki verileri sil", haftalık sayılar) H-064 kalite turunda yeniden gözden geçirilebilir.
