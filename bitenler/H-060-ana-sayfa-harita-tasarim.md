# H-060: Ana Sayfa, Hikâye haritası, bölüm paneli ve jenerik tasarımı

- **Durum:** Bitti (2026-10-14; flutter test 531/531, CI yeşil, tasarım kullanıcı onaylı)
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T3 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057, H-058, H-039

## Kapsam
- **Ana Sayfa:** T1 dili; hedef halkası (`ProgressRing`), hero kartı, kelime tekrarı kartı, ara sıra hesap kartı; sırayla belirme.
- **Harita:** başlık kartı yeniden; düğüm renkleri belirteçlerden; bölüm açılınca ışık yanıp yol çizilir.
- **Bölüm paneli:** `AppSheet` ile; jenerik hata ekranı metinleri l10n'e.

## Kabul kriterleri
- Önce/sonra; golden; "hareketi azalt" testi; testler yeşil.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-060/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-060-ana-sayfa-harita-tasarim`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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

## Uygulama notları (2026-10-14, dal `h-060-ana-sayfa-harita-tasarim`)

**Yapılanlar**
- **Ana Sayfa** (`mobile/lib/features/home/presentation/home_screen.dart`, taslak S07): selam + sağda **günlük hedef halkası** (`ProgressRing`, "6/10 dk"); "Hikâyen" altında görselli bölüm kartı (dalga kesimli görsel `ShapedEdgeClipper`, `CapsLabel` "SEZON 1 · BÖLÜM 2", başlık, ipucu, sezon ilerlemesi cümle + sarı çubuk, tam genişlik 56 px "Başla / Devam et →"); "Kelime tekrarı" kartı (çerçeve düğmesi); ara sıra hesap kartı (H-038 mantığı aynı; görünümü ortak `InfoCard`). Bölümler sırayla belirir (`StaggeredList`). Özel `_InfoCard` kaldırıldı → ortak `InfoCard` (sezon bitti / bölüm hazırlanıyor / bağlantı hatası). Ekranda tek dolu (birincil) düğme var; testle denetlenir. Anahtarlar korundu: `home-continue`, `home-continue-play`, `home-season-progress`, `home-review`, `home-review-text`, `home-review-start`, `home-retry`.
- **Günlük hedef verisi:** "bugün kaç dakika" kaydı yoktu; **yeni kayıt tutulmadı.** `todayActivityProvider` (`features/home/application/home_providers.dart`) mevcut kayıtlardan **tahmin** eder: bugün biten bölümlerin `estimatedMinutes`'ı (yoksa 6 dk) + bugünkü `review_logs.durationMs` toplamı (cevap başına en çok 2 dk), yukarı yuvarlanır. Yarım bırakılan bölümde geçen süre sayılmaz. Halka hedefte dolar, aşınca dolu kalır; hedefin altı vurgulanmaz.
- **Harita** (`story_screen.dart`, `widgets/season_map_view.dart`, taslak S08): başlık kartı yeniden (deniz mavisi, 20 px köşe, fener küçük resmi, "Sezon 1 · The Missing Signal", sarı çubuk, çerçeveli "Jeneriği izle"; sığmazsa düğme alt satıra iner, dokunma alanı 48 px kalır). Odak kartı `TappableCard` + durum renginde numara. Düğüm ve yedek harita renkleri belirteçlerden (`AppMapColors`, `AppPalette`); dosyalarda `Color(0x` kalmadı (taban çizgisi 10 → 1).
- **Harita ışığı:** yeni açılan bölüm haritada ilk kez görününce bir kez (~1,6 sn) önceki bölümden ona sarı iz çizilir, düğüm kilitli griden kendi rengine geçip yanar, bir hale yayılır; iz sonra söner (harita görselindeki yolla çakışmasın). Görüldü işareti `app_meta` (`story.unlockSeen.<contentId>`, ilk görülme anı); `DriftUnlockSeenRepository.claimUnseen` işlem içinde ve `insertOrIgnore` ile idempotent. Harita görünmüyorken (başka sekme, üstte oynatıcı) işaretlenmez. Bölüm 1 baştan açık: oynamaz. Ekran okuyucuya bir kez "Bölüm N açıldı". "Hareketi azalt" açıksa animasyon yok, işaret yine yazılır. Geri sayım / zaman kilidi yok (K-32).
- **Bölüm paneli** (`widgets/episode_sheet.dart`): `showAppSheet` / `AppSheet` (tutamaç, "Kapat"); `CapsLabel`, kilit ve "yakında" notu ortak `InfoCard`; ana düğme 56 px.
- **Jenerik ekranı** (`season_intro_screen.dart`): sabit metinler `SeasonIntroTexts`'e taşındı ("Jenerik açılamadı.", "Geri dön", "Geç", "Jeneriği geç", sezon etiketi, AI notu); `fontSize:` ve sabit renkler kaldırıldı. Harita hata ekranı ortak `EmptyState` + `baglanti-yok.webp` (H-058 illüstrasyonu).
- Ortak bileşen: `ProgressRing` artık kendi ekran okuyucu düğümü (`container: true`; çevredeki metinle birleşip okunmuyordu). `ShapedHeader`'ın kesimi `ShapedEdgeClipper` olarak dışa açıldı.
- Higgsfield / ücretli üretim yok; yalnız mevcut illüstrasyon.

**Testler (gerçek çıktı, 2026-10-14, macOS):** `cd mobile && dart format . && flutter analyze && flutter test` → analyze "No issues found!", **530 test geçti** (`All tests passed!`).
- Yeni: `test/features/home/home_screen_test.dart` (sezon bitti, tek ana eylem, tekrar var / yok / defter boş, hedef halkası + ekran okuyucu, giriş animasyonu ve "Hareketi azalt"ta durağanlık, süre tahmini birim testleri), `test/features/home/today_activity_test.dart` (gerçek Drift: bugün biten bölüm + bugünkü tekrar süresi; dünkü sayılmaz), `test/features/story/story_screen_test.dart` (ışık bir kez oynar, ikinci açılışta yok; Bölüm 1'de yok; "Hareketi azalt"ta durağan ve işaret yazılır; `AppSheet` paneli; jenerik hata metinleri), `test/features/story/unlock_seen_repository_test.dart` (idempotent, eşzamanlı çağrı, boş liste), `test/goldens/h060_screens_golden_test.dart` (6 golden + her biri için erişilebilirlik yönergeleri ve 320 × 568, 1,3× taşma testi; kontrast denetimi yalnız macOS'ta).
- Golden'lar: `mobile/test/goldens/images/h060_{ana_sayfa,ana_sayfa_yeni,ana_sayfa_sezon_bitti,harita,bolum_paneli_kilitli,bolum_paneli_yarim}.png`.
- Mevcut testlerde değişen: Ana Sayfa test yardımcısı giriş animasyonu için 0,5 sn daha bekler (opaklığı 0 olan öğe ekran okuyucuda görünmez); harita testlerine bellek içi "görüldü" deposu eklendi; stil taban çizgisinden temizlenen üç dosya düşüldü. Davranış iddiaları değişmedi.

**Taslaktan farklar**
- "Hikâyen" bölüm başlığı ve "Bugün için önerimiz:" kaldı (ARAYUZ-METINLERI §3: sayfadaki bölümlerin başlığı olur); taslakta yok.
- Bölüm kartında ilerleme ve düğme yan yana değil alt alta (320 px ve 1,3× yazıda sığsın; tek ana eylem tam genişlik).
- Sezon başlığı "SEZON 1" büyük harf etiketi yerine "**Sezon 1** · The Missing Signal" (ARAYUZ-METINLERI §4.1); başlık kartında dalga kesimi yok (büyük yazıda içerik kesilmesin), yerine fener ışığı süsü.
- Kelime tekrarı kartında taslaktaki "5/5" halkası ve "new words" görseli yok (anlamı belirsizdi; ikon kullanıldı).
- Bölüm görseli (jenerik posteri) ağdan gelir; yoksa ya da açılamazsa akşam göğü + fener ikonu.

**Açık sorular (kullanıcıya)**
1. Günlük hedef halkası **tahmini** süre gösteriyor (biten bölüm + tekrar süresi). Yarım bırakılan bölümde ya da Keşfet'te geçen süre sayılmıyor. Böyle kalsın mı, yoksa oynatıcıda gerçek süre ölçümü ayrı bir iş olarak mı açılsın?
2. Uygulamayı güncelleyen mevcut kullanıcıda, haritayı ilk açışta sıradaki bölüm için ışık animasyonu bir kez oynar (işaret henüz yok). Kabul mü?
3. Halka hedefi aşınca "12/10" gösteriyor (dolu halka). "10/10 ✓" gibi bir gösterim mi istenir?
2026-10-14 (kullanıcı kararları): Tasarım onaylandı. Hedef aşılınca halka "10/10" + onay ikonu gösterir (✓ glifi yazı tipinde olmadığı için ikon). Güncelleyen kullanıcılar ışık animasyonunu bir kez görür. Gerçek süre ölçümü ayrı iş: H-074. İş kapandı.

