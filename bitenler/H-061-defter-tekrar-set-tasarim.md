# H-061: Defter, Kelime tekrarı, Konu seti ve Sahne avı tasarımı

- **Durum:** Bitti (2026-10-14; flutter test 581/581; tasarım kullanıcı onaylı)
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T4 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057, H-058

## Kapsam
- **Defter:** tek satır biçimi; sekme kontrolü temadan; boş durumlar illüstrasyonlu.
- **Kelime tekrarı:** görev kartları; doğru/yanlış geri bildirim animasyonu (hafif haptic); özet `StatRow` + sakin kutlama.
- **Konu seti ızgarası:** dokunma tepkisi; **Sahne avı:** alt çubuk ve özet yeni bileşenlerle.

## Kabul kriterleri
- Önce/sonra; golden; testler yeşil.
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-061/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-061-defter-tekrar-set-tasarim`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

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

## Uygulama notları (2026-10-14, dal `h-061-defter-tekrar-set-tasarim`)

**Yapılanlar**
- **Defter** (`mobile/lib/features/notebook/presentation/notebook_screen.dart`, taslak S04): sekme kontrolü temadan (`SegmentedButton`, özel stil yok; uzun etiket iki satıra iner). Üst "Kelime tekrarı" kartı `TappableCard` + `CapsLabel` + tam genişlik 56 px "Tekrara başla". **Tek satır biçimi** `widgets/notebook_row.dart` (`NotebookRow`): solda bölüm etiketi ("B1", fener sarısı) ya da tür rozeti (`KindBadge`), ortada İngilizce + Türkçe + isteğe bağlı **kaynak satırı**, sağda 🔊 / menü / ok. İfadeler ve ipuçları aynı satırla çizilir. Kaynak satırı `notebookSourceLine()` içinde eksiksiz `switch` ile üretilir (bugün yalnız "Konu setinden"); Kitaplık (H-067) yeni kaynak türünü eklediğinde derleyici burayı sorar, satırda "Kitap: başlık, s. N" için yer var. Kitap mantığı eklenmedi. Arama süzgeci aynı kaldı.
- **Boş durumlar** ortak `EmptyState` ile: boş Defter `bos-defter.webp`, boş İpucu panosu `bos-ipucu.webp`, eşleşme yok / hata ikonla. Boş defterde arama alanı gösterilmiyor. Kart ayrıntısı ve konu seti nesnesi `showAppSheet` / `AppSheet` ile.
- **Sırayla belirme:** yeni `StaggerOnce` (`shared/ui/motion.dart`): tembel liste ve ızgarada yalnız **ilk görünüşte** oynar (kaydırınca ya da aramada yeniden oynamaz), ilk 8 öğe gecikir.
- **Kelime tekrarı** (`review_screen.dart`, taslak S05): üstte ince sarı ilerleme çubuğu; görev kartı (görsel + görev cümlesi + anlam) her görevde yumuşakça belirir; seçenekler beyaz hap düğmeler (`PressScale`); "Bilmiyorum" tam genişlik. Geri bildirim: doğruda yeşil panel + onay ikonu sakin belirmeyle (`CalmPop`) ve **tek hafif titreşim** (`HapticFeedback.lightImpact`); yanlış / "Bilmiyorum" deniz mavisi panel + ampul, titreşim yok, kırmızı ve çarpı yok. Özet: `CalmCelebration` (iki yumuşak sarı halka, bir kez) + "5 ifadeyi tekrar ettin." + `StatRow` (ilk seferde bildin / ifade yarın gelecek / ifade sonra gelecek; sıfır olan kutu gösterilmez). Tekrar yoksa `tekrar-yok.webp`. Görev/geri bildirim/özet tembel `ListView` yerine `SingleChildScrollView` (alttaki düğme her zaman kurulur).
- **Konu seti** (`topic_set_screen.dart`, taslak S06): dalga kesimli sahne görselli "Sahne avı" kartı, 56 px "Sahne avına başla"; ızgara kartları `TappableCard` (basınca 0,97, dalga), defterdeyse yeşil işaret; kart yüksekliği yazı büyütmesine göre hesaplanır (1,3× yazıda kesilmez). Defter → Konu setleri satırları `TappableCard`; kilitli set kum zeminde, dokunulmaz. "Hepsini defterime ekle" tema ikincil düğmesi (sabit `fontSize` kalktı).
- **Sahne avı** (`scene_hunt_screen.dart`): alt çubuk beyaz, üst köşeleri yuvarlak, gölgeli yüzey; bulununca içerik yumuşakça değişir, yeşil onay ikonu + tek hafif titreşim (kaçırmada yok). İlerleme "Nesne 1 / 10" sarı hap. Özet: `CalmCelebration` + cümle + `StatRow` (nesneye baktın / kendin buldun / birlikte baktık; sıfır olan yok) + "Hepsini defterime ekle" `InfoCard` içinde.
- **"Bilmiyorum":** ekranlardaki `OutlinedButton.icon` + `AppButtonStyles.dontKnow()` kopyaları (tekrar, sahne avı, seviye sorusu, vitrin) ortak `DontKnowButton` bileşenine geçti (`shared/ui/dont_know_button.dart`); görünüm aynı (H-039 ve vitrin golden'ları değişmedi). Not: işte "5 kopya" yazıyordu; H-057 sonrası koddaki kopya sayısı 4'tü (biçim zaten ortaktı, yapı kopyasıydı).
- **Sabit stil temizliği:** dokunulan dosyalarda `AppColors` / `AppSpacing` / `AppTheme.radius` / `Colors.white` ve saydamlıklı renkler `AppPalette` / `AppSpace` / `AppRadius`'a; `FontWeight.w700` kopyaları kalktı. `fontSize:` taban çizgisi **36 → 33** (`topic_set_screen`, `scene_hunt_screen`, `card_face` 0; satırları silindi).
- **"Hareketi azalt":** bütün yeni animasyonlar (sırayla belirme, görev kartı, geri bildirim paneli, `CalmPop`, `CalmCelebration`, ilerleme çubuğu, alt çubuk geçişi, sayı kutuları, basma ölçeği) durağan; testle denetlendi.
- Bulunan ve düzeltilen eski hatalar: konu seti ızgara iskeleti 320 px'de 5,6 px taşıyordu (oran 0,78 → 0,7); sahne avı alt çubuğu 1,3× yazıda 16 px taşıyordu (yükseklik yazıyla ölçeklenir); sahne avında ekran okuyucu bölgeleri küçük nesnede 48 px'in altındaydı (ortası aynı kalacak biçimde en az 48 × 48, görsel içinde).
- Higgsfield / ücretli üretim yok; yalnız mevcut illüstrasyonlar. Yalnız açık tema.

**Testler (gerçek çıktı, 2026-10-14, macOS):** `cd mobile && dart format . && flutter analyze && flutter test` → analyze "No issues found!", **581 test geçti** (`All tests passed!`; önce 531).
- Yeni: `test/features/notebook/h061_design_test.dart` (11 test: tek satır biçimi + kaynak satırı + ipucu satırı, illüstrasyonlu boş durumlar, eşleşme yok, sırayla belirme ve "Hareketi azalt"ta durağanlık, doğruda tek hafif titreşim / "Bilmiyorum"da yok, özet `StatRow` + kutlama, tekrar yok ekranı, görev-geri bildirim-özet durağanlığı, ızgara basma tepkisi ve azaltılmış harekette ölçek 1, sahne avı titreşimi + alt çubuk + ortak "Bilmiyorum" + özet sayıları).
- Yeni: `test/goldens/h061_screens_golden_test.dart` (13 durum × golden + erişilebilirlik yönergeleri + 320 × 568 1,3× taşma = 39 test; kontrast denetimi yalnız macOS'ta, golden'lar `skipGoldensOffMac`).
- Golden'lar: `mobile/test/goldens/images/h061_{defter,defter_bos,ipucu_panosu,ipucu_bos,konu_setleri,tekrar_gorev,tekrar_dogru,tekrar_bilmiyorum,tekrar_ozet,tekrar_yok,konu_seti,sahne_avi,sahne_avi_ozet}.png`.
- Mevcut testlerde değişen (yapı değişti, davranış iddiası aynı): kelime tekrarı özetinde "2 ifade yarın yeniden gelecek." cümlesi yerine `summary-tomorrow` sayı kutusunun değeri 2 denetleniyor; sahne avında "Bilmiyorum" anahtarı artık `DontKnowButton`'da, 48 px yükseklik içindeki düğmeden okunuyor; stil taban çizgisinden üç dosya düşüldü.
- Simülatörde önce/sonra ekran görüntüleri (`.yerel/h-061/`) bu turda alınmadı (simülatör çalıştırılmadı).

**Taslaktan farklar**
- Defter: taslaktaki illüstrasyonlu dalga başlık yok; itilen sayfada üst çubukta "Defter" kaldı (ARAYUZ-METINLERI §1.4). Tekrar kartında "5" halkası yerine ikon (H-060 kararıyla aynı: halkanın anlamı belirsizdi) ve "Tekrara başla" sağda değil altta, tam genişlik (320 px ve 1,3× yazıda sığsın).
- Bölüm etiketleri taslaktaki gibi B1 sarı / B2 turuncu değişmiyor; hepsi fener sarısı (renk bölüm anlamı taşımasın).
- Kelime tekrarı: görev cümlesi ("Resme ve anlama bak: doğru ifadeyi seç.") korunup anlam büyük yazıldı; taslaktaki 'Hangisi "telsiz"?' biçimi yok. Hi balonu ve sekme çubuğu bu tam ekran oturumda yok (oturum tam ekran kalır).
- Konu seti: taslaktaki illüstrasyonlu "TOPIC SET" başlığı yerine üst çubukta setin adı (arayüzde İngilizce yok, §1.9); "Oyun" etiketi yok (terim tablosunda "Oyun" kullanılmıyor). Izgara kartları yatay (görsel solda) değil dikey (kare görsel üstte): 320 px'de iki sütunda görsel büyük kalsın.
- Konu setinden gelen ifade, kaynağı bir bölümün yeri olduğu için yine "B1" etiketiyle gelir; altına "Konu setinden" yazılır.

**Açık sorular (kullanıcıya)**
1. Kaynak satırı bugün yalnız konu setinden gelen ifadelerde. Altyazıdan "Deftere ekle" ile eklenenlere de "Sen ekledin" gibi bir satır istenir mi?
2. Kelime tekrarı özetinde "ilk seferde bildin" sayısı gösteriliyor (sıfırsa gizli). Puan gibi algılanabilir mi; kalsın mı?
3. Doğru cevapta tek hafif titreşim var; ayarlarda kapatma seçeneği istenir mi (şimdilik yok)?
4. Simülatör önce/sonra görüntüleri (`.yerel/h-061/`) alındı; tasarım onaylandı.
2026-10-14: `main`'e birleştirildi. Birleşmeden sonra `h061_tekrar_yok` golden'ı kararsız çıktı (illüstrasyon bazen çözülmeden görüntü alınıyordu); testte asset resimleri önceden yükleniyor, 5/5 geçti.
2026-10-14 (kullanıcı kararları): Tasarım onaylandı. Özetteki "ilk seferde bildin" kalır (sıfırsa gizli). Titreşim için Profil'de aç/kapa ayarı → H-064. Altyazıdan eklenenlerde "Bölüm N'den ekledin" kaynak satırı → H-067 ile (aynı kod). İş kapandı.

