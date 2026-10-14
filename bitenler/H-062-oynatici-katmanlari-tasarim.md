# H-062: Oynatıcı katmanlarının tasarımı

- **Durum:** Bitti (2026-10-14; flutter 691/691; kullanıcı onayladı)
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

## Uygulama notları (2026-10-14, dal `h-062-oynatici-katmanlari-tasarim`)

**Yapılanlar**
- **Palet belirteçlere:** karar kartı, Hi ipucu paneli, kartlar (görev, ipucu, açık soru, not, mesaj, replik, başlık), görevler, 🎯 görev paneli, bölüm sonu, üst çubuk, altyazı, "Önceki bölümde" çubuğu, yükleme/hata/kaldığın yer panelleri ve **anlam paneli** (`mobile/lib/shared/meaning/meaning_sheet.dart`; 13 satır içi stil) artık yalnız `AppPalette` / `AppScrim` / `AppSpace` / `AppRadius` / `AppShadows` / `AppTouch` / tema yazı ölçeğini kullanıyor. Eski `AppColors` / `AppSpacing` / `AppTheme.radius` / `Colors.white|black` / `FontWeight.w…` oynatıcıda kalmadı.
- Yeni belirteçler: `AppScrim.dim` (%55 karartma), `dimLight` (%35; başlık kartı ve anlam paneli perdesi), `chip` (yapay zekâ notu); `AppTypography.lead` (18, seçenek / replik hapı / mesaj / anlam), `spoken` (20 italik replik), `subtitle` (20), `subtitleTr` (15). Değerler eskisiyle aynı; yalnız ad verildi.
- Okunurluk düzeltmesi: turuncu etiketler (`GÖREV`, `YENİ İPUCU`, bölüm sonu başlıkları, konuşmacı adı, görev bağlamı) `eveningOrange` yerine `orange700` (kum ve beyaz üstünde AA). Büyük harfli etiketler ortak `CapsLabel` ile.
- **Metinler:** oynatıcının ve anlam panelinin bütün sabit Türkçe metinleri (~45 yer; ekran okuyucu etiketleri dahil) `tr_strings.dart` → `PlayerTexts` ve yeni `MeaningTexts`'e taşındı; sözcükler aynı (ARAYUZ-METINLERI §4.5 ve başlığı güncellendi).
- **Giriş animasyonları:** karar kartı alttan yumuşakça gelir, seçenekler 50 ms arayla belirir; Hi paneli: Hi sakin büyüyerek (`CalmPop`), panel ve düğmeler sırayla. Kartlar ve "Devam et" de aynı biçimde. Seçeneklerde ve ana düğmelerde basma tepkisi (`PressScale`). Anlam panelinde Türkçe satır yumuşakça açılır, kelime anlamı yumuşak geçer.
- **Bölüm sonu:** ortak `CalmCelebration` (bayrak ikonu, iki yumuşak sarı halka, bir kez), başlık ve bölümler sırayla; bölümler beyaz kart. Puan, konfeti, ses, geri sayım yok (K-32).
- 🎯 paneli: zemin, köşe ve tutamaç temadan; hedef ifadeler beyaz grup içinde 56 px satırlar.
- Üst çubuk: ilerleme noktaları dar ekranda (320 px, 1,3× yazı) küçülerek sığar (`FittedBox`); hız ve altyazı hapları ortak `_Pill`.
- **"Hareketi azalt":** bütün girişler, kutlama ve hap geçişleri durağan; testle denetlendi.
- **Paylaşılan bileşen değişikliği:** `CalmPop` ve `CalmCelebration` `flutter_animate` yerine örtük animasyonla (`TweenAnimationBuilder`) çiziliyor ve yeni `SoftEntrance` eklendi (`shared/ui/motion.dart`). Neden: `flutter_animate` her `Animate` için sıfır süreli bir `Timer` bırakıyor; oynatıcıyı ve bölüm sonunu tek karede çizen mevcut testler (görev, "Söyle" yerleri) "Timer is still pending" ile düşüyordu. Görünüm ve süreler aynı; H-061 ve H-067 golden'ları değişmedi.
- **Oynatma ve zamanlama koduna dokunulmadı:** `features/player/application`, `domain`, `data` farksız (`git diff` boş). Karartma süresi 250 ms (`AppMotion.base`, aynı değer). Girişler yalnız görünüm; dokunma ilk karede de çalışır.
- Stil taban çizgisi: `fontSize:` **33 → 1** (oynatıcı dosyaları ve `meaning_sheet.dart` satırları silindi; kalan `speak_widgets.dart`). Yeni denetim: oynatıcı katmanları ve anlam paneli yalnız belirteç kullanır (`hi_avatar.dart` H-063'e kaldı; `Color(0x` tabanı 1).
- Higgsfield / ücretli çağrı yok. Yalnız açık tema. Simülatör çalıştırılmadı.

**Testler (gerçek çıktı, 2026-10-14, macOS):** `cd mobile && dart format . && flutter analyze && flutter test` → "No issues found!", **675 test geçti** (`All tests passed!`; önce 649).
- Yeni: `mobile/test/features/player/h062_design_test.dart` (10 test): karar kartının girişi ve ilk karede dokunma, en geç 250 + 2×50 ms'de tam görünür; "Hareketi azalt"ta karar kartı, Hi paneli, ipucu kartı ve bölüm sonu durağan; seçenek ≥ 56 px + basma tepkisi; Hi panelinde `CalmPop` + sıralı giriş; bölüm sonunda `CalmCelebration` ve bölüm başlıkları. **Zamanlama (hareket açıkken, sahte video):** karar kartının giriş animasyonu sürerken seçim → yanıt videosu ≤ 100 ms içinde oynuyor; `k1-ok → s03` geçişi ölçülen **0 ms** (sınır ≤ 150 ms; sıradaki video önden başlatılıyor); altyazı satırı oynatma başladıktan **10 ms** sonra ekranda (sınır ≤ 0,2 sn).
- Yeni: `mobile/test/goldens/h062_player_golden_test.dart` (5 durum × golden + erişilebilirlik yönergeleri [dokunma alanı, etiket; kontrast yalnız macOS'ta] + 320 × 568 1,3× taşma = 15 test). Karar, ipucu ve 🎯 paneli gerçek oynatıcı ekranında; anlam paneli ve bölüm sonu tek başına.
- Golden'lar: `mobile/test/goldens/images/h062_{karar,ipucu,gorev_paneli,anlam_paneli,bolum_sonu}.png`.
- Mevcut testlerde finder değişmedi; yalnız `style_literals_guard_test.dart` taban çizgisi düşürüldü ve yeni denetim eklendi. H-031/H-054 ölçümlerinin simülatördeki önce/sonra karşılaştırması ve `.yerel/h-062/` ekran görüntüleri bu turda alınmadı (simülatör çalıştırılmadı).

**Taslaktan / işten farklar**
- "Video yüklenemedi." metni `player_session.dart`'ta (uygulama katmanı) kaldı: oynatma koduna dokunmamak için.
- Hi'nin çizimindeki tek sabit renk (`hi_avatar.dart`, `_rim`) H-063'e bırakıldı (Hi'nin canlılığı işi); yalnız `Colors.white` → `AppPalette.white` ve ekran okuyucu etiketi taşındı.
- Bölüm sonunda Hi balonu yerine `CalmCelebration` (bayrak). Hi'nin bölüm sonunda görünmesi istenirse H-063'te ifade durumlarıyla eklenebilir.

**Açık sorular (kullanıcıya)**
1. Bölüm sonunda kutlama ikonu bayrak (görev tamam). Hi'nin kendisi (mutlu ifadeyle) mi olsun? H-063'e bağlanabilir.
2. Simülatör önce/sonra görüntüleri (`.yerel/h-062/`) ve H-031/H-054 cihaz ölçümü, birleştirmeden önce mi sonra mı alınsın?
2026-10-14: Kullanıcı tasarımı onayladı. Açık kalan: bölüm sonu kutlamasında bayrak yerine mutlu Hi ifadesi H-063'te değerlendirilecek; simülatörde H-031/H-054 ölçümleri H-064 kalite turunda.
