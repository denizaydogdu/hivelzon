# Arayüz metinleri kılavuzu (H-053)

> **Durum:** Taslak 1 (2026-10-12). Uygulama bu kılavuza göre güncellendi.
> **Kod:** metinler `mobile/lib/l10n/tr_strings.dart` dosyasında ekran ekran durur. Oynatıcının ve anlam panelinin metinleri de H-062'den beri burada (`PlayerTexts`, `MeaningTexts`; §4.5).
> **Türkçe yardımcılar:** `mobile/lib/shared/text/turkish.dart` (`upperTr`, `lowerTr`, `possessiveNumber`).

## 1. İlkeler

1. **Sade Türkçe.** Kısa cümle, günlük kelime. Teknik terim yok: "sunucu", "senkron", "FSRS" gibi kelimeler arayüzde geçmez.
2. **"Sen" dili.** "Defterin", "Bitirdin", "İstediğin zaman" gibi. Resmî "siz" kullanılmaz.
3. **Suçlamasız ve sakin.** "Yanlış", "başarısız", "kaçırdın", "serini kaybettin" gibi ifadeler yok. Hata durumunda "Bir daha bakalım.", "Sorun değil, birlikte bakalım." denir. Geri sayım ve aciliyet de yok (K-32).
4. **Her ekranda başlık.** Sekme sayfasında büyük başlık, gerekiyorsa altında **tek cümle** açıklama olur. İtilen sayfada (Defter, Kelime tekrarı) üst çubukta başlık durur. Sayfadaki bölümlerin de başlığı vardır.
5. **Sayılar cümle içinde.** "4" tek başına durmaz. Doğrusu: "4 ifadenin tekrar zamanı geldi · yaklaşık 2 dk". Bağlamı belli olan ilerleme göstergeleri ("Soru 2 / 3", "0 / 12") istisnadır. Bunların yanında da ne sayıldığı yazar.
6. **Düğmeler fiille.** "Başla", "Devam et", "Tekrara başla", "Tekrar oyna", "Haritaya dön", "Kaydet". Tek başına "Devam" ya da "Tamam" yerine fiil kullanılır. Oturum özetini kapatan "Tamam" istisnadır.
7. **Türkçe büyük harf doğru yazılır.** Büyük harfli etiketler (ör. "SEZON 1 · BÖLÜM 2", "KİLİTLİ") kodda normal yazılır ve `upperTr` ile büyütülür. Dart'ın `toUpperCase` işlevi "kilitli" sözcüğünü "KILITLI" yapar. Aramada da `lowerTr` kullanılır: "İSTASYON" → "istasyon".
8. **Sayı ekleri kesme işaretiyle ve ünlü uyumuyla yazılır.** "Bölüm 1'i tamamla", "12 bölümden 6'sı bitti". Bunun için `accusativeNumber` ve `possessiveNumber` kullanılır.
9. **Arayüz çerçevesinde İngilizce yok.** İngilizce yalnızca öğrenilen içerikte olur: hikâye metni, ifade, bölüm adı. "EN / EN+TR" altyazı kısaltması menüde açılır ("EN (İngilizce)"). Ekran okuyucu bu kısaltmayı tam okur. Uygulama dili `tr` olarak sabittir (`flutter_localizations`). Böylece Material'ın kendi metinleri de Türkçedir: "Geri", "Kapat", "Sekme 1 / 5". Önceden bunlar İngilizceydi: "Back", "Dismiss", "Scrim", "Tab 1 of 5", "20 characters remaining".
10. **Yapay zekâ açıkça söylenir.** Oynatıcıda ve jenerikte kısa süreli "Yapay zekâ ile üretilmiştir" notu olduğu gibi kalır. Hi kendini yapay zekâ yardımcısı olarak tanıtır. Konuş sekmesi de bunu önceden söyler.
11. **Erişilebilirlik etiketleri metinle aynıdır.** Bir metin değişince aynı anlamdaki `Semantics` ya da `tooltip` metni de değişir.
12. **Görsel düzen** (H-057; belirteçler `tasarim/README.md` "Tasarım sistemi v2").
    - **Izgara ve köşe:** 8 px ızgara (4 / 8 / 12 / 16 / 24 / 32 / 48 / 64). Köşe 8 / 12 / 20 / tam: kart ve giriş alanı 12, alt panel ve pencere 20, düğme hap biçimi (tam).
    - **Yazı:** Başlıklar **Nunito** 700 (display / headline / title), metin ve etiketler **Inter** 400 / 500 (vurgu 700). Yazı ağırlığı en fazla 3 tanedir (400 / 500 / 700); `w600` yok. İkisi de uygulamaya gömülüdür (OFL). Yazı en az 12 px; boyut `Theme.of(context).textTheme` ya da `AppTypography` ile verilir, ekranda `fontSize:` yazılmaz.
    - **Renk:** yalnızca `AppPalette` / `AppScrim` belirteçleri; ekranda `Color(0x…)` yazılmaz (test denetler). Metin kontrastı WCAG AA (≥ 4,5:1). Turuncu metin `orange700`, ikincil metin `ink500`.
    - **Dokunma alanı** en az 48 px; ana eylem 56 px.
    - **Hareket:** sakin ve amaçlı. Dokunma tepkisi (0,97 ölçek, 150 ms), sayfa geçişi (solarak + hafif kayma, 250 ms), listede sırayla belirme (öğe başına 50 ms, en fazla 8 öğe), dolan halka (400 ms). Sekmeler arası geçiş anlıktır. "Hareketi azalt" açıksa hepsi durağandır. Geri sayım, titreşen uyarı, baskı kuran animasyon yok (K-32).

## 2. Terimler (tek anlam, tek kelime)

| Terim | Anlamı | Kullanılmayan |
|---|---|---|
| **ifade** | Defterdeki öğrenme birimi: kelime, kalıp ya da cümle. **Sayımda her zaman "ifade"** denir: "5 ifade", "5 ifadeyi tekrar ettin". | Sayımda "kart" ya da "kelime" |
| **kart** | İfadenin ekrandaki görünümü (görsel, ses, örnek cümle). Yalnızca nesne anlamında kullanılır: "kartı aç". | "4 kart seni bekliyor" |
| **kelime** | Tek sözcük: altyazıda dokunulan kelime, "Kelimeleri doğru sıraya diz". | İfadenin yerine |
| **Kelime tekrarı** | Aralıklı tekrar özelliğinin adı (Ana Sayfa bölümü, Defter kartı, oturum başlığı). | "Tekrar (4)", "TEKRAR" |
| **tekrar et / Tekrara başla** | Kelime tekrarı oturumu. | |
| **Tekrar oyna** | Bitmiş bölümü yeniden oynamak. | "Yeniden oyna" |
| **Tekrar dene** | Hata ya da yanlış seçimden sonra yeniden denemek. | |
| **Bölüm / Sezon** | Hikâyenin birimleri. | "Ders", "Episode" |
| **Görev** | Bölümün görevi (🎯). | "Misyon" |
| **Hedef ifade** | Bölümde öğretilen ifade. | |
| **İpucu panosu / ipucu** | Hikâyede bulunan gizem ipuçları ve açık sorular. | |
| **Hi'nin ipucu** | Karar anında Hi'nin verdiği dil yardımı. Bağlamdan ayrılır ("Hi'den ipucu al"). | |
| **Defter** | İfadeler, İpucu panosu ve Konu setleri. | "Kelime listesi" |
| **Konu seti** | Hikâyedeki bir yerin nesneleri (H-051): "Alex'in odası". | "Kelime paketi", "Tema" |
| **nesne** | Konu setindeki ve sahnedeki öğe. Sette sayarken "nesne" denir ("10 nesne"); deftere girince "ifade" olarak sayılır. | Sette "kelime" ya da "kart" saymak |
| **Sahne avı** | Sahne görselinde nesneyi bulma oyunu. Süre ve puan yok. | "Oyun", "Test" |

## 3. Ana Sayfa

Düzen: selam ve tek cümle, ardından **Hikâyen** (birincil, sarı düğme), ardından **Kelime tekrarı** (ikincil, çerçeveli, çerçeve düğmesi). Tek öğrenme eylemi ilkesi korunur: öne çıkan eylem hikâyedir.

| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Başlık | Merhaba | **Merhaba Deniz!** (ad varsa) / **Merhaba!** | Kişisel selam (kullanıcı isteği). Ad Profil'den gelir, yalnızca cihazda saklanır. |
| Alt cümle | — | Bugün için önerimiz: | Sayfanın ne önerdiği hemen anlaşılır. |
| Bölüm başlığı | — | **Hikâyen** | Kartın ne olduğu belli olur. |
| Kart etiketi | HİKÂYEYE DEVAM | (kaldırıldı) | Bölüm başlığı aynı işi görüyor. Görseldeki "SEZON 1 · BÖLÜM 2" ve düğme ("Başla" / "Devam et") yeterli. |
| Görsel üstü | SEZON 1 · BÖLÜM 2 (görsel 16:9) | SEZON 1 · BÖLÜM 2 (`upperTr`), görsel 2:1 | Metin aynı kalır, büyük harfi yardımcı üretir. Görsel kısaldı; "Kelime tekrarı" bölümü ilk ekranda görünür. |
| İlerleme | — | "Bu sezonda 12 bölüm var." / "Bu sezonda 12 bölümden 1'i bitti." | Sezonda nerede olduğu, sayı cümle içinde. |
| Düğme | Başla / Devam et | Başla / Devam et | Aynı kalır. |
| Bölüm yok | Bölüm 5 hazırlanıyor · Haritaya git | aynı | Tarih ve geri sayım yok. |
| Sezon bitti | Sezonu bitirdin · "Bölümleri haritadan yeniden oynayabilirsin." | aynı | |
| Yükleniyor | Hikâye yükleniyor… | Hikâyen yükleniyor… | Bölüm adıyla uyumlu. H-054: ekranda spinner yerine kartın iskeleti; metin ekran okuyucuya duyurulur. |
| Hata | Sunucu çalışmıyor · Hikâye yüklenemedi. | **Bağlantı kurulamadı** · Hikâye yüklenemedi. · Tekrar dene | "Sunucu" teknik terim. |
| Bölüm başlığı | — | **Kelime tekrarı** | "Tekrar (4)" kutusunun ne olduğu anlaşılmıyordu (kullanıcı geri bildirimi). |
| Tekrar var | Tekrar (4) · Defterindeki ifadeler | "4 ifadenin tekrar zamanı geldi · yaklaşık 2 dk" + **Tekrara başla** | Sayı cümle içinde. Süre tahmini: ifade başına ~20 sn, yukarı yuvarlanır, en az 1 dk. |
| Tekrar yok, defter dolu | (kutu gizliydi) | Şu an tekrar edilecek ifade yok. Yeni ifadeler bölüm bitince defterine eklenir. | Sakin durum cümlesi; düğme yok. |
| Defter boş | (kutu gizliydi) | Bir bölümü bitirince ifadeler defterine eklenir; tekrar zamanları burada görünür. | Yeni kullanıcıya özelliği tanıtır. |
| Defter yükleniyor | — | Defterin hazırlanıyor… | Boş durumla karışmaz. |
| Günlük hedef halkası (H-060) | — | Selamın sağında halka: "6/10" + "dk"; ekran okuyucu: "Günlük hedef: bugün yaklaşık 6 dakika, hedefin 10 dakika" | Bugünkü süre mevcut kayıtlardan **tahmindir** (bugün biten bölümlerin süresi + tekrarda geçen süre). Hedefin altında kalmak vurgulanmaz; utandırıcı metin yok. |

## 4. Hikâye sekmesi

### 4.1 Harita
| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Sayfa başlığı | — | **Hikâye** | Her sekmede başlık. |
| Açıklama | — | Bölümleri sırayla aç; bitirdiğin bölümü istediğin zaman yeniden oynayabilirsin. | Haritanın nasıl çalıştığını tek cümlede söyler. |
| Sezon başlığı | SEZON 1 · The Missing Signal | **Sezon 1** · The Missing Signal | Sayfa başlığının altında ikinci düzey; büyük harf gerekmez. |
| İlerleme | 0 / 12 (erişilebilirlik: "12 bölümden 0 tamamlandı") | 0 / 12 (erişilebilirlik: "12 bölümden 0'ı tamamlandı") | Ek doğru. |
| Jenerik | Jeneriği izle | aynı | |
| Odak kartı | Bölüm 1 · sıradaki | aynı | |
| Yükleniyor | Harita yükleniyor… | aynı | H-054: ekranda harita iskeleti (bölüm yerleri); metin ekran okuyucuya duyurulur. |
| Boş | Henüz bölüm yok · Yeni bölümler hazır olunca burada görünecek. | … burada görünür. | Kısa, şimdiki zaman. |
| Hata | Sunucu çalışmıyor · "Bölümler yüklenemedi. Yerel içerik sunucusunu başlatıp tekrar dene: python3 …" | **Bağlantı kurulamadı** · Bölümler yüklenemedi. İnternet bağlantını kontrol edip tekrar dene. | Komut satırı kullanıcıya gösterilmez. Yalnızca debug derlemede altına "Geliştirici notu: …" eklenir. |

### 4.2 Bölüm paneli
| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Etiket | BÖLÜM 2 · KİLİTLİ | aynı (`upperTr` artık ortak yardımcıda) | KILITLI hatası olmasın. |
| Oynanabilir | Oyna | **Başla** | Ana Sayfa'yla aynı fiil. |
| Yarım | Devam et · Baştan başla | aynı | |
| Bitmiş | Tekrar oyna | aynı | |
| Kilit nedeni | Önce Bölüm 1'i tamamla. Kalan adımlar: hedef ifade. | aynı | Nazik ve açık. |
| Kilit notu | Acele yok; istediğin kadar tekrar deneyebilirsin. | Acele yok; önceki bölümü istediğin kadar tekrar oynayabilirsin. | Neyin tekrar edileceği belli olur. |
| Yakında | Yakında · Bu bölüm hazırlanıyor. | aynı | Tarih yok. |

### 4.3 Sezon jeneriği
"Sezon 1 jeneriği: The Missing Signal", "Geç" (ekran okuyucu: "Jeneriği geç"), "Jenerik açılamadı." ve "Geri dön" metinleri aynı kalır. (H-060: bu metinler artık `tr_strings.dart` → `SeasonIntroTexts`'te.) Yeni açılan bölüm haritada ilk kez görününce ekran okuyucu bir kez "Bölüm 3 açıldı" der. Kısa süreli "Yapay zekâ ile üretilmiştir" notu da aynı kalır.

### 4.4 Oynatıcı: değişenler
| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Görev öğesi sayacı | 2 / 2 | Soru 2 / 2 | Ne sayıldığı yazar. |
| Görev düğmesi, kart düğmesi | Devam | **Devam et** | Fiil. |
| Bölüm sonu notu | Bu ifadeler defterine eklendi; tekrar kartı olarak gelecek (Profil → Defter). | Bu ifadeler defterine eklendi. Tekrar zamanı gelince Ana Sayfa'daki "Kelime tekrarı" bölümünde karşına çıkar. | Ok işaretli yol tarifi yerine nerede göreceği. "Kart" yerine "ifade". |
| Bölüm sonu düğmesi | Hikâye'ye dön | **Haritaya dön** | Gidilen yer harita. Sekme adına ek getirilmez. |
| Altyazı düğmesi (ekran okuyucu) | Altyazı: EN | Altyazı: İngilizce / İngilizce ve Türkçe / kapalı | Kısaltma sesli okunmaz. |

### 4.5 Oynatıcı: aynı kalanlar (denetlendi)
- **Başlık ekranı:** "Sezon 1, Bölüm 2: The New Neighbour".
- **Önceki bölümde:** "Önceki bölümde", "Atla" (ekran okuyucu: "Önceki bölüm özetini atla").
- **Üst çubuk:** "Bölümden çık", "Sahne 2 / 6", "Görev ve hedef ifadeler", "1x / 0,75x" (ekran okuyucu: "Hız normal. Yavaşlatmak için dokun.").
- **Çıkış sorusu:** "Bölümden çıkılsın mı?", "Kaldığın sahne kaydedilecek. Sonra oradan devam edebilirsin.", "Kal" ve "Çık".
- **Kaldığın yerden devam:** "Bu bölümü yarıda bırakmıştın: …", "Kaldığın yerden devam", "Baştan başla".
- **Karar:** "Ne dersin?", "Hi'den ipucu al".
- **Hi'nin ipucu:** "İpucu 1 / 3", "Bir ipucu daha", "Tüm ipuçları açık", "Tekrar dene". Yanlış seçimde: "Bir daha bakalım.", "Neredeyse! Bir kez daha dene.", "Acele yok, tekrar dene."
- **Kartlar:** "GÖREV", "YENİ İPUCU", "Bölümü bitir".
- **Görevler:** "Harika, buldun!", "Önce soldan bir parça, sonra sağdan eşini seç.", "Kontrol et", "Senin cümlen", "Kaydı dinle".
- **🎯 paneli:** "GÖREV", "HEDEF İFADELER", "Devam et". H-052 ile "Listen." da dokunulabilir oldu.
- **Anlam paneli:** "Türkçesini göster", "TÜRKÇESİ", "KALIP", "Tekrar dinle", "0,75x", "Deftere ekle", "Şu an deftere eklenemedi. Biraz sonra tekrar dene."
- **Konuşmacı adları:** "Telsizdeki ses", "Not". Kart, görev ve başlık satırları için "Anlam".
- **Bölüm sonu:** "Görev tamam!", "TOPLANAN İPUÇLARI", "AÇIK SORU", "Sıradaki: …", "BU BÖLÜMÜN İFADELERİ".
- **Hata:** "Bölüm yükleniyor…", "Bağlantını ya da içerik sunucusunu kontrol edip tekrar deneyebilirsin.", "Tekrar dene" ve "Geri dön".
- **Hi:** "Hi, yapay zekâ yardımcın" (ekran okuyucu).

**H-062 (2026-10-14):** Bu bölümdeki metinler sözcüğü sözcüğüne aynı kalarak `tr_strings.dart` → `PlayerTexts` (oynatıcı) ve `MeaningTexts` (anlam paneli; oynatıcı, Keşfet ve kitap okuyucu ortak) altına taşındı. Büyük harfli etiketler ("GÖREV", "YENİ İPUCU", "HEDEF İFADELER", "TOPLANAN İPUÇLARI", "AÇIK SORU", "BU BÖLÜMÜN İFADELERİ", "KALIP", "TÜRKÇESİ") normal yazılır, ekranda `CapsLabel` büyütür; ekran okuyucu normal yazımla okur. Yalnız "Video yüklenemedi." oynatma katmanında (`player_session.dart`) kaldı: oynatma kodu bu işte değiştirilmedi.

### 4.6 Kitaplık (H-067)
Hikâye sekmesinin üstünde **Macera · Kitaplık** seçici (sekme sayısı değişmez, K-30). Açıklama satırı seçime göre değişir.

| Yer | Metin | Not |
|---|---|---|
| Seçici | **Macera** (harita ikonu) · **Kitaplık** (kitap ikonu) | Ekran okuyucu grubu: "Hikâye bölümü". |
| Açıklama (Kitaplık) | Seviyene göre kısa, resimli kitaplar. İstersen dinle, istersen kendin oku. | Tek cümle. |
| Dinleme kartı | "Seviyeni seç; okumadığın bir kitabı senin için sesli açalım." + **Bana bir kitap oku** | Sarı ana düğme. |
| Seviye seçici | **Hangi seviyede olsun?** · "Önerilen seviye: A2" · seviye çipleri · **Kitabı aç** | Önerilen seviye yerleştirme sonucundan, yoksa A1. |
| Okunmamış kalmadı | **Bu seviyede açmadığın kitap kalmadı** · "Başka bir seviye seçebilir ya da sevdiğin bir kitabı yeniden dinleyebilirsin." | Suçlamasız. |
| Raflar | **Okumaya devam et** · **Senin seviyen · A2** · **A1 kitapları** · **Okuduklarım** | Yarım kitapta halka içinde "%33"; biten kitapta onay işareti. |
| Kitap kartı | Kapak, seviye rozeti, başlık, "Gizem · ~7 dk" | Türler: Gizem · Macera · Mizah · Bilimkurgu · Günlük hayat. Ekran okuyucu: "The Blue Door, A1 seviyesi, Gizem, yaklaşık 7 dakika, yüzde 33 okundu". |
| Yükleniyor / boş / hata | "Kitaplık hazırlanıyor…" (iskelet) · **Kitaplar hazırlanıyor** "İlk kitaplar hazır olunca burada görünür. O zamana kadar maceraya devam edebilirsin." · **Bağlantı kurulamadı** "Kitaplar yüklenemedi. …" + **Tekrar dene** | |

### 4.7 Kitap okuyucu (H-067)
| Yer | Metin | Not |
|---|---|---|
| Üst çubuk | Kitap adı · "Bölüm 1 · A Small Box"; düğmeler "Kitabı kapat", "Bölümler", "Okuma ayarları" | Bölüm adı kitabın kendi (İngilizce) adıdır. |
| Biçim | **Sesli** · **Sessiz** (grup: "Okuma biçimi") · "s. 2 / 12" (ekran okuyucu: "12 sayfadan 2. sayfa") | Ses açılamazsa: "Bu kitabın sesi şu an açılamıyor. Sessiz okuyabilirsin." Kitap bölüm bölüm seslendirilir: sesi olmayan bölüme gelince (ya da orada **Sesli** seçilince) ses durur, sessiz moda geçilir ve bir kez "Bu bölümün sesi henüz hazır değil; kendin okuyabilirsin." |
| Ses denetimleri | "Dinle" / "Duraklat", "10 saniye geri", "1x / 1,25x / 0,75x" (ekran okuyucu: "Hız normal. Değiştirmek için dokun."), "Uyku zamanlayıcısı" | |
| Uyku zamanlayıcısı | Kapalı · Bölüm sonunda · 10 / 20 / 30 dakika sonra; seçince "Uyku zamanlayıcısı: 20 dakika sonra"; dolunca "Uyku zamanlayıcısı sesi durdurdu. İyi uykular!" | **Geri sayım gösterilmez** (K-32). |
| Sessiz mod | "Önceki sayfa", "Sonraki sayfa", son sayfada **Kitabı bitir** | |
| Okunan yeri izleme | Sesli modda sayfa okunan cümleyi kendiliğinden izler. Kullanıcı kaydırınca izleme durur, küçük çip: **Okunan yere dön** (dokununca ya da ~4 sn sonra izleme sürer). | Uyarı ya da açılır pencere yok. |
| Ayarlar | **Yazı boyutu**: Küçük · Orta · Büyük; **Okunan kelimeyi de vurgula** "Kapalıyken yalnız okunan cümle vurgulanır." | Yalnız bu cihazda. |
| Uzun basma | Sesli modda kelimeye uzun basınca **Deftere eklendi** (ikinci kez: ""box" zaten defterinde.") | Sessiz modda uzun basma o cümleyi seslendirir. |
| Ekran okuyucu | Cümle düğmesi ipucu: "Anlamını göstermek için dokun" | |
| Kitap sonu | **Kitabı bitirdin** · ""The Blue Door" bitti. Dinlediğin ve okuduğun her sayfa kulağını güçlendirir." · **Bu kitapta kaydettiklerin** (yoksa: "Bu kitaptan defterine ifade eklemedin. Bir dahakine bilmediğin kelimeye dokunup "Deftere ekle" diyebilirsin.") · "Bu ifadeler Kelime tekrarında karşına çıkar." · **Sıradaki kitabı aç** (aynı seviyede açılmamış kitap varsa) · **Kitaplığa dön** · **Baştan oku** | Puan, lig, geri sayım yok (K-32). |
| Hata | **Bağlantı kurulamadı** · "Kitap açılamadı. …" · **Tekrar dene** | |

### 4.8 Dilbilgisi (H-078)
Hikâye sekmesinin seçicisi **Macera · Kitaplık · Dilbilgisi** olur (sekme sayısı değişmez, K-30). Dar ekranda ya da büyük yazıda ikonlar kalkar; etiket yine sığmazsa küçülür, kesilmez. Kod: `GrammarTexts`.

| Yer | Metin | Not |
|---|---|---|
| Seçici | **Dilbilgisi** (kep ikonu) | Ekran okuyucu grubu "Hikâye bölümü" (aynı). |
| Açıklama | Hi, İngilizcenin nasıl işlediğini Türkçe ve kısaca anlatır. | Tek cümle. |
| Raflar | **Hikâyende geçenler** (oynadığın bölümde ya da açtığın kitapta geçen, bitmemiş konular) · **Senin seviyen · A1** · **A2 konuları** · **Tamamladıkların** | Her ders tek rafta; kilit yok. |
| Ders kartı | Seviye rozeti (bitince onay işareti), Türkçe başlık, tek cümle hedef, "A1 · ~3 dk" (bitince "· Tamamlandı") | Ekran okuyucu: "Üçüncü tekil -s, A1 seviyesi, yaklaşık 3 dakika, tamamlandı". |
| Yükleniyor / boş / hata | "Dersler hazırlanıyor…" (iskelet) · **Dersler hazırlanıyor** "İlk dilbilgisi dersleri hazır olunca burada görünür. O zamana kadar maceraya devam edebilirsin." · **Bağlantı kurulamadı** "Dersler yüklenemedi. …" + **Tekrar dene** | |
| Bölüm paneli | Ana düğmenin altında ikincil **Bu bölümdeki dilbilgisi (~5 dk)** ve altında konuların adları ("Üçüncü tekil -s · There is / there are") | Yalnız oynanabilir bölümde ve bölümün `grammarTopics`'inde dersi olan konu varsa. Dersler sırayla gelir; son dersten sonra **Bölümü başlat** bölümü bugünkü gibi açar (H-050: başlıkla). Vazgeçilirse bölüm açılmaz. |
| Kitap açma paneli | Kitapta ders varsa kapağa dokununca: seviye · tür, başlık, **Kitabı aç** ve ikincil **Bu kitaptaki dilbilgisi (~3 dk)**; derslerden sonra **Kitabı aç** | Dersi olmayan kitap eskisi gibi doğrudan açılır. |
| Anlam paneli | **BU YAPI NE?** + konu çipleri | Bölümün ya da kitabın konusu varsa; çipe dokununca panel kapanır, ders açılır (oynatıcıda video durur). |
| Hi | **"Kısa bir konu: Üçüncü tekil -s"** · ""The New Neighbour" bölümünde bu yapı geçti. İstersen Türkçe ve kısaca anlatayım. Yaklaşık 3 dk sürer; …" · **Konuyu aç** | Düşük öncelik: kitap önerisinden sonra, "Bugünlük bu kadar"dan önce. Kaynak kitapsa "… kitabında". |

### 4.9 Ders ekranı (H-078)
| Yer | Metin | Not |
|---|---|---|
| Üst çubuk | "Dersi kapat" · ders adı · "Kart 2 / 7" (ekran okuyucu: "7 karttan 2'si") · ses düğmesi "Sesi kapat" / "Sesi aç" | Altında sarı ilerleme çizgisi. |
| Kart etiketleri | BU CÜMLEDE · ANLATIM · ÖRNEKLER · TÜRKÇEDE NASIL? · ALIŞTIRMA · HİKÂYEDE GÖR · KURAL | `CapsLabel`; solda küçük Hi (anlatırken parlar; ekran okuyucu "Hi anlatıyor"). |
| Anlatım | Hi'nin Türkçe metni; kart açılınca kendiliğinden okunur, okunan cümle ve kelime vurgulanır · **Dinle** / **Durdur** | Sessiz modda ya da ses yoksa okunmaz, düğme görünmez; metin tam. Ses açılamazsa bir kez: "Bu dersin sesi şu an açılamıyor. Okuyarak devam edebilirsin." |
| Şema | Kodla çizilir: zaman çizgisi (geçmiş · şimdi · gelecek), kutu–ok ("özne", "fiil ve ek"), renkli ek (go + es) | Ekran okuyucu: "Şema: open + s = opens, …". |
| Örnekler | İngilizce cümle (hedef yapı turuncu, kalın, altı çizili) + Türkçesi · "Anlamı için kelimeye dokun." · çal düğmesi "Örneği dinle: She plays football." | İngilizce ses yoksa çal düğmesi gizli. Kelimeye dokununca anlam paneli; "Deftere ekle" kaynağı "Dilbilgisi: <ders adı>". |
| Türkçede nasıl? | **SIK YAPILAN HATA** + yanlış biçim + kısa Türkçe açıklama ("Ek eksik.") · **DOĞRUSU** + sesli örnek | Üstü çizili ya da kırmızı yok; utandırmaz. |
| Alıştırma | "Soru 1 / 4" · "Boşluğa uyan kelimeyi seç." · "Boşluğa uyan kelimeyi yaz." (alan "Cevabın") · "Kelimeleri doğru sıraya diz." · **Baştan diz** · **Kontrol et** · Söyle: "Cümleyi dinle, sonra sen de söyle." (tanıma yoksa "… sesli tekrar et.") | Puan, süre, can yok (K-32). |
| Alıştırma geri bildirimi | Doğruda **Doğru!** + çözülmüş cümle · **Sonraki soru**; yanlışta **Bir daha bakalım.** + kısa Türkçe açıklama · **Tekrar dene** / **Geç**; geçilince "Doğrusu: He plays football." · bitince "Alıştırma tamam. Puan yok; denemek yeter." | "Geç" her zaman var; alıştırma kartı ilerlemeyi kilitlemez. |
| Hikâyede gör | "Bölüm: The New Neighbour" / "Kitap: The Test Box, s. 3" + gerçek cümle + **Bölümü aç** / **Kitapta aç** | Kitap o sayfada sessiz açılır. Bölüm, haritada açıksa başından açılır (düğümden açma oynatıcıda yok); değilse "Bu bölüm henüz açık değil. Önceki bölümleri bitirince buradan da açabilirsin." |
| Kural kartı | Kural (büyük) + örnek · **Deftere kural kartı ekle** → "Kural kartı defterine eklendi." / "Bu kural kartı zaten defterinde." + "Kelime tekrarında karşına çıkar." | Defter satırı: kaynak "Dilbilgisi: Üçüncü tekil -s", kartta **KURAL**. |
| Alt çubuk | "Önceki kart" (ok) · **Devam et** · son kartta **Dersi bitir** | |
| Dersin sonu | Sakin kutlama · **Dersi bitirdin** · ""Üçüncü tekil -s" tamam. Bu yapıyı hikâyede gördükçe daha kolay tanırsın." · sırada ders varsa **Sıradaki konu: …**; bölüm panelinden gelindiyse **Bölümü başlat** (kitaptan **Kitabı aç**) · **Dilbilgisine dön** (bölüm/kitap akışında **Kapat**) | Puan, lig, geri sayım yok. |
| Hata | **Bağlantı kurulamadı** · "Ders açılamadı. …" · **Tekrar dene** | |

## 5. Defter, İpucu panosu ve kelime tekrarı

### 5.1 Defter
| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Başlık | PROFİL (üst satır) + Defter | Üst çubukta **Defter** ve geri oku | Standart başlık. "PROFİL" etiketi gereksizdi. |
| Sekmeler | İfadeler · İpucu panosu | aynı | |
| Açıklama (İfadeler) | — | Bölümlerde öğrendiğin ifadeler burada. Birine dokununca kartı açılır. | Her sekmeye tek cümle. |
| Açıklama (İpucu panosu) | — | Hikâyede bulduğun ipuçları ve henüz cevabı olmayan sorular. | |
| Tekrar kartı etiketi | TEKRAR | KELİME TEKRARI | Ana Sayfa'yla aynı ad. |
| Tekrar var | 4 kart seni bekliyor. | 4 ifadenin tekrar zamanı geldi · yaklaşık 2 dk | Terim ve süre. |
| Tekrar yok | Bugünlük tekrar bitti. Kartlar zamanı gelince geri gelir. | Bugünlük tekrar bitti. İfadeler zamanı gelince yeniden gelir. | Terim. |
| Defter boş | Bölüm bitirdikçe kartların burada birikir. | Bölüm bitirdikçe ifadelerin burada birikir. | Terim. |
| Hazırlanıyor | Kartlar hazırlanıyor… | İfadelerin hazırlanıyor… | Terim. |
| Liste yükleniyor | (spinner) | İskelet satırlar; ekran okuyucu: "Defterin hazırlanıyor…" | H-054. Ana Sayfa'daki metinle aynı. |
| İpucu panosu yükleniyor | (spinner) | İskelet satırlar; ekran okuyucu: "İpucu panosu hazırlanıyor…" | H-054. |
| Nasıl | Resme bak, dinle, seç. Bilmediğin kart sorun değil: … | Bilmediğin ifade sorun değil: … | Terim. |
| Liste başlığı | Topladığım ifadeler | Topladığın ifadeler (5) | "Sen" dili; kaç ifade olduğu yazar. |
| Arama | İfade ya da Türkçesi ara | İngilizce ya da Türkçe ara | Neyle arandığı açık. Arama `lowerTr` ile yapılır ("İ" doğru eşleşir). |
| Boş | Defterin henüz boş. … "Deftere ekle" de diyebilirsin. | Başlık **Defterin henüz boş** + "Bir bölümü bitirince hedef ifadeler buraya gelir. Altyazıda bir kelimeye dokunup "Deftere ekle" de diyebilirsin." (illüstrasyonlu; boşken arama alanı yok) | H-061: `EmptyState` başlık + açıklama. |
| Kaynak satırı | — | Satırın altında küçük turuncu satır: konu setinden gelende **"Konu setinden"**; kullanıcının bölümde kendi eklediğinde (altyazı, anlam paneli) **"Bölüm 3'ten ekledin"** (`ablativeNumber`: 1'den, 3'ten, 6'dan, 10'dan); kitaptan eklenende **"Kitap: The Blue Door, s. 4"** (başlık yoksa "Kitaptan"). Bölümün kendi eklediklerinde (hedef ifade, bakılan kelime) satır yok; kaynak soldaki "B1" etiketidir. | H-061 tek satır biçimi; H-067 (kullanıcı kararı 2026-10-14). Kitaptan gelenin sol rozeti kitap ikonudur. |
| Kaynak satırı (H-078) | — | Dilbilgisi dersinden eklenende **"Dilbilgisi: Üçüncü tekil -s"** (kural kartı ve anlam panelinden eklenen); sol rozet kural ikonu. Kural kartının yüzünde **KURAL** başlığıyla kuralın kendisi. | "Hikâyeden" süzgecine girmez. |
| Kaynağa göre süz | — | Kitaptan eklenen ifade varsa arama alanının altında çipler: **Hepsi · Hikâyeden · <kitap başlığı>** | H-067: "Defter'de kitaba göre süzme". Ekran okuyucu grubu "Kaynağa göre süz" diye okur. |
| Eşleşme yok | Eşleşen ifade yok. | Aradığın ifade defterinde yok. | Sade. |
| Hata | Defter açılamadı. Uygulamayı yeniden başlatmayı dene. | Defter açılamadı. Uygulamayı yeniden başlatıp dene. | Kısa. |
| Çıkarıldı | "…" defterden çıkarıldı. | "…" defterinden çıkarıldı. | "Sen" dili. |
| Kart durumu | Yeni kart: ilk tekrarını bekliyor. | Yeni ifade: ilk tekrarını bekliyor. | Terim. |
| Kart durumu | Tekrar zamanı geldi. / Bugün, yarın ya da n gün sonra yeniden gelecek. | aynı | |

### 5.2 İpucu panosu
| Yer | Eski | Yeni |
|---|---|---|
| Açık soru etiketi | AÇIK SORU · BÖLÜM 1 | aynı (`upperTr`) |
| Bölüm etiketi | BÖLÜM 1 | aynı (`upperTr`) |
| Diğerleri | "Açık sorular", "Bulduğun ipuçları", "Şimdilik bildiğin: …", "İpucu panosu açılamadı." | aynı |
| Boş | Henüz ipucu yok. Bölüm sonunda … toplanır. | Başlık **Henüz ipucu yok** + "Bölüm sonunda bulduğun ipuçları ve açık sorular burada toplanır." (illüstrasyonlu, H-061) |

### 5.3 Kelime tekrarı oturumu
| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Başlık | Tekrar · 1 / 5 | Kelime tekrarı · 1 / 5 | Özellik adı. |
| Boş | Şu an tekrar edilecek kart yok · Kartlar zamanı gelince geri gelir. | Şu an tekrar edilecek ifade yok · İfadeler zamanı gelince yeniden gelir. | Terim. |
| Geri bildirim | Bu kart oturumun sonunda yeniden gelecek. / Bu kartı yakında yeniden göreceksin. | Bu ifade … / Bu ifadeyi … | Terim. |
| Düğme | Devam | **Devam et** | Fiil. |
| Özet | 4 kartı tekrar ettin. · 2 kart yarın yeniden gelecek. · n kart daha sonra gelecek. | 5 ifadeyi tekrar ettin. + sayı kutuları (`StatRow`, H-061): "4 · ilk seferde bildin", "2 · ifade yarın gelecek", "3 · ifade sonra gelecek". Sıfır olan kutu gösterilmez. | Terim; sayı kutusunda ne sayıldığı yazar. |
| Görevler | "Resme ve anlama bak: doğru ifadeyi seç.", "Dinle ve duyduğun ifadeyi seç.", "Kelimeleri doğru sıraya diz.", "İngilizcesini yaz.", "İngilizcesini aklından söyle, sonra kartı aç." | aynı | |
| Düğmeler | "Dinle", "Kontrol et", "Kartı aç", "Bildim", "Bilmiyorum", "Tamam", "Geri dön" | aynı | |
| Yazma alanı | İngilizce yaz | İngilizcesini yaz | Görev cümlesiyle aynı. |
| Geri bildirim | "Doğru!", "Sorun değil, birlikte bakalım.", "Doğrusu bu.", "Seçtiğin: …" | aynı | Suçlamasız. |
| Kartın yüzü | "TÜRKÇE ANLAMI", "BÖLÜMDEKİ CÜMLE", "Cümleyi dinle", "İfadeyi dinle", "Görsel yok" | aynı | |

### 5.4 Konu setleri ve sahne avı (H-051)

| Yer | Metin | Not |
|---|---|---|
| Defter sekmesi | **Konu setleri** | Üçüncü sekme. |
| Açıklama | Hikâyedeki yerlerin nesneleri. Bir bölümü bitirince o bölümün yeri açılır. | Tek cümle. |
| Set satırı | "Alex'in odası" · "10 nesne" | Sayı cümle içinde değil ama ne sayıldığı yazar. |
| Kilitli set | "Liman" · "Bölüm 3'ü bitirince açılır." | `accusativeNumber`; zaman ya da geri sayım yok. Ekran okuyucu: "Liman. Bölüm 3'ü bitirince açılır." |
| Yükleniyor / hata / boş | "Konu setleri hazırlanıyor…" (iskelet) · "Konu setleri açılamadı. Bağlantını kontrol edip tekrar dene." + **Tekrar dene** · "Henüz konu seti yok. Yeni setler bölümlerle birlikte gelir." | |
| Set sayfası | Üst çubukta setin adı. **Sahne avı** · "Nesnenin İngilizce adını oku, sonra resimde ona dokun. Süre yok." · **Sahne avına başla** | |
| Izgara | **Nesneler** · "Bu sette 10 nesne var. Birine dokununca kartı açılır." / "Bu sette 10 nesne var; 3'ü defterinde." | `possessiveNumber`. |
| Ekleme | **Hepsini defterime ekle** → **Hepsi defterinde** · kartta **Defterime ekle** → **Defterinde** | Fiil; ekledikten sonra durum. |
| Bildirim | "10 ifade defterine eklendi. Tekrar zamanı gelince "Kelime tekrarı" bölümünde karşına çıkar." / ""radio" defterine eklendi." / "Bu setteki ifadeler zaten defterindeydi." / "Şu an deftere eklenemedi. Biraz sonra tekrar dene." | Deftere girince "ifade". |
| Kart | "ÖRNEK CÜMLE" | Set örneği bölüm cümlesi olmayabilir; bölüm kartında "BÖLÜMDEKİ CÜMLE" kalır. |
| Ekran okuyucu (ızgara) | "radio, telsiz, defterinde. Kartı aç." | |
| Sahne avı üst çubuk | "Sahne avı · Alex'in odası" · "Nesne 2 / 10" · kapat: "Sahne avından çık" | |
| Soru | **Find the radio!** (+ kelimenin sesi, varsa; 🔊 "Dinle") | Başta yalnızca İngilizce (kullanıcı kararı 2026-10-13). |
| Yanlış dokunuş | "Bir daha bakalım." + Türkçe yardım satırı ("Telsizi bul") | İlk yanlıştan sonra gelir; yeri baştan ayrılmıştır (resim kaymaz). Kırmızı ya da çarpı yok; dokunulan yerde nötr halka. Ekran okuyucu açıkken yardım satırı ipucuna kadar gizli. |
| Büyütme | İki parmakla büyütme ve kaydırma; alt çubukta **Yakınlaştır** (2 kat, en çok 4) ve **Resmin tamamını göster** | Dokunma denetimi büyütmede de doğru. |
| İki kaçırmadan sonra | "İpucu: parlayan yere bak." | Bölge nazikçe parlar ("Hareketi azalt" açıkken durağan). |
| Buldu | "Buldun!" · kelime · Türkçesi · ses (varsa) · **Devam et** / sonda **Sonucu gör** | |
| Bilmiyorum | **Bilmiyorum** (Kelime tekrarındaki biçim) → "Burada. Sorun değil, birlikte bakalım." | |
| Ekran okuyucu seçenekleri | "Doğru nesneyi seç:" + Türkçe adlar | Bölgeler de Türkçe adıyla düğmedir. |
| Özet | **Sahne avı tamam** · "10 nesnenin hepsini kendin buldun." / "10 nesneden 8 tanesini kendin buldun." / "Bu sefer nesnelere birlikte baktık." · sayı kutuları (H-061): "10 · nesneye baktın", "8 · kendin buldun", "2 · birlikte baktık" (sıfır olan gösterilmez) · "Defterindeki 10 ifadenin tekrar zamanı güncellendi." · "Bu nesneleri defterine eklersen kelime tekrarında da karşına çıkar." · **Tekrar oyna** · **Sete dön** | Puan, yüzde ya da "yanlış" sayısı yok. |
| Defterden çıkarma | Konu setinden gelen ifade, "Deftere ekle" ile eklenen gibi "Defterden çıkar" menüsüyle çıkarılır. Set etkilenmez; "Hepsini defterime ekle" yeniden ekler. | |
| Bölüm sonu | **YENİ KONU SETİ** · "Yeni konu seti açıldı: Alex'in odası" · **Konu setini aç**. Tekrar oynayışta **KONU SETİ** · "Bu bölümün yerindeki nesneler: Alex'in odası". | |

## 6. Profil

**Düzen (H-059, 2026-10-14):** illüstrasyonlu dalga başlık → avatar (adın ilk harfi; ad yoksa Hi) + **Merhaba Deniz** / **Merhaba!** + tek satır durum → üç istatistik kutusu → iki ayar grubu. Açıklamalar ayrı paragraf değil, satırın altında ipucudur. Ad ve günlük hedef alt panelde değişir. Sayılar sıfırdan sayarak belirir; "Hareketi azalt" açıksa durağan.

| Yer | Metin | Not |
|---|---|---|
| Selam | "Merhaba Deniz" / ad yoksa "Merhaba!" | Ekran okuyucuda başlık. Avatarın etiketi ad ya da "Hi". |
| Durum satırı | "Bu hafta 6 ifadeyi tekrar ettin." → yoksa "Bu hafta 4 yeni ifade topladın." → "Bu hafta 1 bölüm bitirdin." → hiçbiri yoksa "Bugün küçük bir adım yeter." | Yapılmayan söylenmez, kıyas yok (K-16). |
| İstatistikler | **15** ifade · **3** bölüm bitti · **6** bu hafta tekrar | Sayı + ne sayıldığı; ekran okuyucu "15 ifade" diye tek parça okur. |
| Grup **Öğrenme** | **Defter** · "15 ifade · 5 ifadenin tekrar zamanı geldi" / "Bölüm bitince ifadeler buraya eklenir." | |
| | **Günlük hedef** · "Kelime tekrarında günde en fazla 10 yeni ifade açılır." · sağda "10 dk" | Panel: "Günde ne kadar zaman ayırmak istersin?" · 5 / 10 / 15 dk · bilgi kartı (aynı cümle + "İstediğin zaman değiştirebilirsin. Hedefin altında kalmak sorun değil.") |
| | **Söyle alıştırmaları** (anahtar) · "Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere gönderilmez." | Destek / izin yoksa sağda "Kapalı" ve nedeni (§11). |
| | **Konu setleri** · "Hikâyedeki yerlerin nesneleri." | Defter → Konu setleri. |
| Grup **Hesap ve gizlilik** | **Hesap** · sağda "Açık değil" / maskeli e-posta / 13 yaş altında "13+" (satır kapalı) | İpucu §12'deki satır metni. |
| | **Hi benim hakkımda ne biliyor?** · "Bu cihazda saklananları gör, istersen sil." | |
| | **Adın** · "Ana Sayfa seni bu adla selamlar." · sağda ad ya da "Eklenmedi" | Panel: **Sana nasıl seslenelim?** · alan "Adın ya da takma adın" · "İsteğe bağlı. Yalnızca bu cihazda saklanır." · **Kaydet** (kaydedince panel kapanır). |
| Ad hataları | "En fazla 20 karakter yazabilirsin.", "Yalnızca harf, boşluk, kesme işareti ve tire kullanabilirsin." | Nedeni söyler, suçlamaz. |
| Ad kaydı | "Adın kaydedildi." / Boş kaydedilince: "Adın silindi; Ana Sayfa "Merhaba!" der." | Sonucu görünür. |

Ad kuralları: Baştaki ve sondaki boşluk atılır, aradaki boşluklar teke iner. Boş ad, kaydı siler. İzin verilen karakterler harf, boşluk, kesme işareti, tire ve noktadır. En fazla 20 karakter yazılabilir. Ad `app_meta` tablosunda `profile.displayName` anahtarıyla tutulur; şema değişmez. Onboarding'de (H-039) de sorulur. Hesap açılınca (H-038) hesaba taşınır.

## 7. Keşfet ve Konuş (yer tutucular)

| Sekme | Eski | Yeni |
|---|---|---|
| Keşfet | Üst çubuk "Keşfet" · "Kısa klipler burada akacak." | Başlık **Keşfet** · **Kısa klipler yakında** · "Bölümlerden 30 saniyelik klipler burada akacak. Her klipten sonra kısa bir soru ya da kelime kaydetme seçeneği olacak." |
| Konuş | Üst çubuk "Konuş" · "Yakında / Karakterlerle konuşma pratiği sonraki sürümde geliyor." | Başlık **Konuş** · **Konuşma pratiği yakında** · "Hikâyedeki karakterlerle İngilizce konuşma pratiği sonraki sürümde geliyor. Karşındakinin yapay zekâ olduğu her zaman söylenecek." |

Neden: Sekmelerin başlık düzeni öteki sekmelerle aynı olur. Ne geleceği ve neden işe yarayacağı tek paragrafta söylenir. Yapay zekâ açıklaması önceden yapılır.

## 8. Sekme çubuğu
"Ana Sayfa · Keşfet · Hikâye · Konuş · Profil" (K-30) aynı kalır.

## 9. Testler
- `test/shared/text/turkish_test.dart`: `upperTr`, `lowerTr`, `possessiveNumber`; Ana Sayfa metin işlevleri.
- `test/features/profile/profile_test.dart`: ad kuralı, kalıcılık (`app_meta`), Profil ekranı (başlık, istatistikler, gruplar, günlük hedef ve ad panelleri).
- `test/features/notebook/notebook_ui_test.dart`: Ana Sayfa'da adlı ve adsız selam; tekrar zamanı gelmiş ve gelmemiş durum; Defter açıklamaları.
- `test/features/home/home_screen_test.dart` ve `test/features/story/story_screen_test.dart`: sezon ilerleme cümlesi, harita başlığı ve açıklaması.
- `test/features/topic_sets/`: konu seti listesi ve kilit nedeni, ızgara ve ekleme metinleri, sahne avı geri bildirimleri ve özeti, bölüm sonu satırı (H-051).

## 10. Hi-A: balon, panel ve koç (H-048)

Kod: `HiTexts` (`mobile/lib/l10n/tr_strings.dart`). Hi kendini yapay zekâ asistanı olarak tanıtır (K-23); suçlamaz, acele ettirmez, romantik ya da bağımlılık yaratan dil kullanmaz (K-32). "Yanlış" sözcüğü kullanılmaz.

| Yer | Metin | Not |
|---|---|---|
| Balon (ekran okuyucu) | "Hi'yi aç" / "Hi'yi aç. Bugün için yeni bir önerisi var." | Yalnızca beş sekmenin kök sayfasında; 64 px. Yeni öneri varsa küçük turuncu nokta (sayı yok); panel o gün açılınca kalkar. Nabız iki kez atar, sonra durur; "Hareketi azalt" açıksa hiç atmaz. |
| Panel başı | **Ben Hi, yapay zekâ asistanınım.** · "Önerilerimi bu cihazdaki ilerlemene bakarak, kurallarla seçiyorum." | Açıklama her açılışta görünür. |
| Bugünkü öneri | Başlık + **Neden?** + gerekçe + fiil düğmesi | Tek öneri. Örnekler: "Hikâyeye devam: Find the Station" · "Bölüm 3'ü yarıda bırakmıştın; kaldığın sahneden devam edersin. Yaklaşık 7 dk sürer; günlük hedefine (15 dk) sığar." · "Kelime tekrarı" · "6 ifadenin tekrar zamanı geldi. Zamanında tekrar edilen ifade daha kolay hatırlanır. …" · "Hi'nin notu: Soru sözcüğü başa gelir" · "Son 7 günde "Kelime sırası" konusunda 2 kez takıldın. Bu çok olağan; Türkçeyle karşılaştıran kısa bir not var, 1 dk sürer." · "Sıradaki bölüm: …" · "Sahne avı: Liman" · **Bugünlük bu kadar yeter**. Süre günlük hedefi aşarsa: "… istediğin yerde bırakıp sonra devam edebilirsin." |
| Düğmeler | Devam et · Tekrara başla · Notu aç · Defteri aç · Başla · Sahne avına başla | Fiil. |
| Hızlı eylemler | Hikâyeye devam · Kelime tekrarı · Defter · Konu setleri | |
| Bu ne demek? | "Bölümlerde geçen kelime ve kalıpların anlamını bulurum." · alan: "İngilizce ya da Türkçe yaz" · sonuç: ifade, anlam, **ÖRNEK**, "Geçtiği yer: B1" / "Defterinde" / "Konu setinde" · eşleşme yoksa: "Bunu henüz bilmiyorum; bölümlerde geçen kelimeleri arayabilirim." | Arama `foldForSearch`: Türkçe İ/ı, ç/ş/ğ/ö/ü katlanır ("İSTASYON", "statıon", "isik" bulunur). Yalnızca açılmış bölümler, defter ve açılmış konu setleri. |
| Haftalık özet | "Son 7 gün, yalnızca bu cihazda." · "10 yeni ifade topladın." · "4 ifadeyi tekrar ettin." · "2 bölüm bitirdin." · "En çok üzerinde çalıştığın konu: Edat." · boşsa: "Bu hafta henüz kayıt yok. İlk adım için bugünkü öneriye bakabilirsin." | Yapılmayan söylenmez; seri ve kıyas yok. |
| Hi'nin notu | "Hi'nin notu" · başlık · Türkçe açıklama · "Türkçeden aklına gelen" → "İngilizcede" | Kırmızı ya da çarpı yok. Kelime tekrarında yanlış cevaptan sonra ilgili not varsa: **Neden böyle?** |
| Konu kartı (oynatıcı) | "Yeni konu" · İngilizce başlık · 2–3 Türkçe satır · örnek · **Devam et** / **Geç** | Konunun ilk satırı geçtiği segment bitince, konu başına bir kez; sıradaki kararın cevabını vermez. Geri sayım yok. |
| Defter | **Hi'nin konu notları** · "Hikâyede tanıştığın 2 konu. Birine dokununca kartı açılır." / boşsa: "Bölümlerde yeni bir konu geçince Hi kısa bir not bırakır; notlar burada toplanır." | Yalnızca görülen kartlar (spoiler yok). |
| Yan görev | **YAN GÖREV** · başlık · metin · "İsteğe bağlı. Yalnızca sen bilirsin." · **Yaptım** / **Şimdi değil** · "Harika! Hikâyedeki ifade gerçek hayatta da işe yaradı." | Fotoğraf, yükleme ve konum istenmez. |
| Profil satırı | **Hi benim hakkımda ne biliyor?** · "Bu cihazda saklananları gör, istersen sil." | |
| Gizlilik ekranı (tasarım H-059) | Hi + "Hi önerilerini bu cihazdaki kayıtlara bakarak seçer. Reklam için kullanılmaz." · bilgi kartı: hesapsız **Yalnızca bu telefonda** · "Bu bilgiler telefonundan dışarı gönderilmez." / hesapla **Hesabına da eşitlenir** · "Hesabın açık olduğu için bu kayıtlar yedek olarak hesabına da eşitlenir. Silersen hesabına bağlı öteki cihazlardan da silinir." · **SAYILARLA**: 12 kez anlamına baktın · 4 kez yeniden denedin · 7 kez söyledin · **Bu cihazda saklananlar**: Adın · Hikâye ilerlemen · Defterin · Hi'nin öğrenme kayıtları ("6 kez bir kelimenin anlamına baktın; 4 kez bir seçimi yeniden denedin.") · Söyle alıştırmaları · Yan görevler · **Konulara göre yeniden denemeler**: çipler "Fiil yapısı · 3" (yoksa "Kayıt yok.") · **Son 7 gün**: yeni ifade · ifade tekrar · bölüm bitti (+ "En çok üzerinde çalıştığın konu: …") · **Hi'nin kayıtlarını sil** (kırmızı kenarlı) | "Sunucu" kelimesi kaldırıldı (§1.1). Onay: "Hi'nin kayıtları silinsin mi?" · **Vazgeç** / **Sil** · sonra "Hi'nin kayıtları silindi. İlerlemen ve defterin yerinde." Silinen: öğrenme olayları, yan görev durumları, açılan notlar. Kalan: ilerleme, defter, tekrar geçmişi, ad, görülen konu kartları. |

Testler: `test/features/hi/` (öneri öncelik tablosu ve gerekçeler, metin denetim listesi, arama, haftalık özet, Drift kayıtları ve silme kapsamı, balon görünürlüğü, panel, konu kartı).

Kitaplık önerileri (H-067): yarım bölüm, tekrar (≥ 5) ve Hi'nin notundan sonra **"Kitaba devam: The Blue Door"** · ""The Blue Door" kitabının %40 kadarını okudun; kaldığın cümleden devam edersin. …" · **Kitaba devam et**; bütün öteki önerilerden sonra (dinlenmeden önce) **"Bir kitap dinle: …"** · "Bugünkü işlerin bitti. İstersen A1 seviyesinde kısa bir kitabı dinleyerek kulağını çalıştır. …" · **Dinlemeye başla**.

Dilbilgisi önerisi (H-078): kitap önerisinden sonra, dinlenmeden önce **"Kısa bir konu: …"** · ""…" bölümünde bu yapı geçti. İstersen Türkçe ve kısaca anlatayım. …" · **Konuyu aç** (§4.8).

## 11. "Söyle" alıştırmaları (H-055)

Kod: `SpeakTexts` (`mobile/lib/l10n/tr_strings.dart`). Puan, yüzde, dalga biçimi ve "yanlış" yok; en çok 2 deneme, sonra metin gösterilir; "Geç" hep var. Cihazda tanıma yoksa ya da izin kapalıysa hiçbir "Söyle" düğmesi görünmez.

| Yer | Metin | Not |
|---|---|---|
| Düğmeler | **Söyle** → **Bir daha söyle**; dinlerken **Bitirdim** + "Dinliyorum… Söyleyince biraz bekle." | Fiil. |
| Geri bildirim | "Söyledin!" · "Neredeyse! Şu kelimeyi duyamadım: hear" · "Şu kelimeleri duyamadım: excuse, me. Bir daha dene." · "Seni duyamadım. Bir daha dene." · 2 denemeden sonra "Sorun değil. İfade şöyle:" + ifade · tipik hata tanınırsa **Neden böyle?** (Hi'nin notu) | Duyulmayan kelime asıl yazımıyla. |
| Kelime tekrarı | Görev: "Dinle ve söyle." · "Dinle, sonra mikrofona dokunup İngilizcesini söyle." · yakın sonuçta **Devam et** · **Bilmiyorum** · **Geç** · başlık "Söyledin!" / "Neredeyse!" | İngilizce metin önce gizli. |
| Anlam paneli | **Sen de söyle** | "Tekrar dinle"nin altında. |
| Karar anı | **Söyleyerek seç** · "Seni tam duyamadım. İstersen dokunarak seç." · iki denemeden sonra "Dokunarak seçebilirsin." | Yalnızca seçenekler İngilizceyse. |
| Dilbilgisi alıştırması (H-078) | "Cümleyi dinle, sonra sen de söyle." + **Söyle** | Sonuç `place = grammar` olarak kaydedilir. |
| Bölüm sonu | **HEDEF İFADELERİ SÖYLE** · "İstersen bu bölümün ifadelerini bir kez de sen söyle. İsteğe bağlı." | |
| İzin öncesi | **Söyle alıştırmaları** · "Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere gönderilmez. Söylediğinin yazısı da saklanmaz; yalnızca "söyledin" ya da "bir daha dene" sonucu bu cihazda kalır." · "Şimdi telefonun mikrofon ve konuşma tanıma iznini soracak." · **Devam et** / **Şimdi değil** · reddedilirse "İzin verilmedi. Her şey dokunarak çalışmaya devam eder." | |
| Profil (H-059) | Anahtarlı satır **Söyle alıştırmaları** · ipucu "Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere gönderilmez." · desteklenmiyorsa sağda "Kapalı" + "Bu telefon İngilizceyi kendi içinde yazıya çeviremiyor; sesin dışarı gönderilmesin diye kapalı. Her şey dokunarak çalışır." · izin kapalıysa "Mikrofon izni kapalı. Telefonun Ayarlar bölümünden açabilirsin; her şey dokunarak da çalışır." | |
| Hi benim hakkımda ne biliyor? | "3 kez söyledin; 2 tanesinde ifadenin tamamı duyuldu. Yalnızca bu sonuç saklanır; sesin ve söylediklerinin yazısı saklanmaz." | "Hi'nin kayıtlarını sil" bunları da siler. |
| iOS izin metinleri (Info.plist) | Mikrofon: "Söyle alıştırmalarında İngilizceyi sesli söylediğinde mikrofon kullanılır. …" · Konuşma tanıma: "Söylediğin İngilizce yalnızca bu telefonda yazıya çevrilir …" | |

## 12. Hesap ve eşitleme (H-038)

Kod: `AccountTexts` (`mobile/lib/l10n/tr_strings.dart`). Hesap isteğe bağlıdır; hesapsız her şey çalışır. Metin sıkıştırmaz, korkutmaz, engellemez. "Sunucu", "senkron", "token" gibi teknik kelimeler geçmez; özelliğin adı **Eşitleme**'dir.

| Yer | Metin | Not |
|---|---|---|
| Profil → **Hesap** (hesap yok) | **Hesap** · sağda "Açık değil" · "İlerlemen yalnızca bu telefonda. Kaybolmasın istersen hesap aç." | Kullanıcı kararı; satır biçimi H-059. |
| Profil → Hesap (hesap var) | **Hesap** · sağda "d•••@example.com" · "Eşitleme: son 2 dk önce" / "Eşitleme: az önce" / "Eşitleme: henüz yapılmadı" | E-posta cihazda yalnızca maskeli durur. |
| Ana Sayfa kartı | **İlerlemen yalnızca bu telefonda** · "Kaybolmasın istersen hesap aç. İstemezsen hesapsız devam edebilirsin." · **Hesap aç** / **Şimdi değil** | Yalnızca hesap yokken ve biraz ilerleme varken (1 bölüm ya da 3 ifade). Kapatılınca 30 gün görünmez, en fazla 3 kez. |
| Hesap ekranı (hesap yok; tasarım H-059) | Çapraz kesimli illüstrasyonlu başlık · "Hesap isteğe bağlı. Hesapsız da her şey çalışır." · üç fayda satırı (yuvarlak renkli ikon + başlık + açıklama): **İlerlemen yedeklenir** · **Başka telefonda devam et** · **Hesapsız da her şey çalışır** ("Hesap açmazsan hiçbir bilgin bu telefondan çıkmaz.") · büyük sarı **E-postayla devam et** · küçük "Şifre yok: e-postana tek kullanımlık bir kod göndeririz." · 13 yaş altında bilgi kartı | Apple ve Google (H-044) aynı yere eklenir. |
| E-posta | **E-posta adresin** · "Hesabın varsa giriş yaparsın, yoksa yeni hesap açılır." · **Kod gönder** · hata: "Geçerli bir e-posta adresi yaz." | |
| Kod | **Kodu yaz** · "… adresine 6 haneli bir kod gönderdik. Kod 10 dakika geçerli." · **Doğrula** · "Yeni kodu 42 sn sonra isteyebilirsin." → **Yeni kod gönder** · **E-postayı değiştir** | Otomatik doldurma (tek kullanımlık kod); 6 rakam girilince kendiliğinden doğrular. |
| Kod hataları | "Bu kod eşleşmedi. E-postandaki kodu bir daha kontrol et." · "Bu kodun süresi doldu. Yeni bir kod isteyebilirsin." · "Bu kod için deneme hakkın bitti. Yeni bir kod isteyebilirsin." · "Kısa sürede çok istek geldi. Biraz sonra tekrar dene." | "Yanlış" denmez. |
| Yeni hesap | **Hesabını aç** · "Son birkaç bilgi kaldı." · Doğum yılın ("Yalnızca yılı soruyoruz.") · "Sana nasıl seslenelim? (isteğe bağlı)" · ☐ "Kullanım koşullarını okudum, kabul ediyorum." · ☐ "KVKK aydınlatma metnini okudum." · **Metni aç** · anahtar "hiVelzon'daki yenilikleri e-postayla almak istiyorum." (varsayılan kapalı) · **Hesabımı aç** | Hukuk metinleri yer tutucu (H-042); sürüm `TERMS_VERSION` / `PRIVACY_NOTICE_VERSION`. |
| 13 yaş altı | **Hesap için en az 13 yaş** · "Hesap açmak için en az 13 yaşında olmalısın; uygulamanın tamamını hesapsız kullanabilirsin." · "Yazdığın bilgiler kaydedilmedi." · **Uygulamaya dön** | Doğum yılı gönderilmez ve saklanmaz; cihaz yalnızca hesabın açılabileceği yılı hatırlar, Profil satırı o yıla kadar kapalı kalır. |
| İlk eşitleme | "Verilerin eşitleniyor…" → **Verilerin eşitlendi** · "Bu telefondaki ilerlemen artık hesabında da." / bağlantı yoksa "Şu an eşitlenemedi. Verilerin bu telefonda duruyor; bağlantı gelince kendiliğinden eşitlenir." | |
| Hesap ekranı (hesap var; tasarım H-059) | Durum kartı: **GİRİŞ YAPTIĞIN HESAP** · maskeli e-posta · eşitleme satırı (ikon ve renk: eşitlendi yeşil, bağlantı bekliyor turuncu) · **Şimdi eşitle** (ikincil; "Eşitlendi.") · sessiz **Çıkış yap** ("Verilerin bu telefonda kalır; eşitleme durur…") · ayrı grup **Tehlikeli bölge** (kırmızı satırlar): **Bu telefondaki verileri sil** · "Çıkış yapılır. Hesabındaki kopya durur; yeniden giriş yapınca geri gelir." (ayrı onay, son düğme kırmızı) · **Hesabımı sil** · "30 gün içinde aynı e-postayla giriş yapıp geri alabilirsin." | Mantık değişmedi; yalnızca görünüm. |
| Silinmek üzere hesap | **Hesabın silinmek üzere** · "… tarihine kadar geri alabilirsin; o gün hesabın ve hesabındaki veriler kalıcı olarak silinir." · **Hesabımı geri al** / **Geri alma, çıkış yap** | |
| Oturum kapandıysa | "Güvenliğin için bu telefondaki oturumu kapattık. Verilerin bu telefonda duruyor; istersen yeniden giriş yapabilirsin." | Kullanılmış yenileme belirteci (`TOKEN_REUSED`). |
| Hi benim hakkımda ne biliyor? (hesap var) | "… Hesabın açık olduğu için bu kayıtlar yedek olarak hesabına da eşitlenir. Reklam için kullanılmaz." · silme onayı: "… Hesabına bağlı öteki cihazlardan da silinir. …" | Hesap yokken eski metin ("sunucuya gönderilmez") kalır. |

Giriş adımlarında hata metni ana düğmenin **hemen üstünde**, kırmızı bilgi kartıyla gösterilir (H-059; önceden düğmenin altında kalıp klavye açıkken görünmeyebiliyordu). Onay kutuları beyaz bir grup içindedir.

**Hukuk metni ekranı (H-059):** sürüm etiketi (**SÜRÜM: …**), **Taslak metin** bilgi kartı, başlıklı bölümler (Koşullar: Uygulama · Hesap · Hesabını silmek; Aydınlatma: Hesap açarsan · Sesin · Hesap açmazsan), satır genişliği en fazla 600 px. Kesin metinler H-042.

Testler: `test/features/account/account_ui_test.dart`, `test/shared/api/api_client_test.dart` (hata metinleri suçlamasız), `test/goldens/h059_screens_golden_test.dart` (H-059 golden'ları, erişilebilirlik, 1,3× yazı).

## 13. Açılış ve yerleştirme (H-039)

Kod: `OnboardingTexts` (`mobile/lib/l10n/tr_strings.dart`); ekran `mobile/lib/features/onboarding/`. Taslak: `tasarim/v2/onizleme/S09-acilis.jpg`. Açılış bir kez gösterilir; sekme çubuğu ve Hi balonu yoktur. Hesap istenmez (H-009); geri sayım, süre ve puan yoktur (K-32).

| Adım | Metin | Not |
|---|---|---|
| Karşılama | İllüstrasyonlu dalga başlık · **hiVelzon'a hoş geldin!** · "Bir hikâye oyna, İngilizceyi oynarken öğren." · bilgi kartı "Hesap gerekmez. Her şey bu telefonda kalır." · **Başla** | Taslaktaki "kendiliğinden öğren" vaat gibi okunduğu için yumuşatıldı (K-08). |
| Seni tanıyalım | **Seni biraz tanıyalım** · "İki kısa soru. Cevapların yalnızca bu telefonda kalır." · Doğum yılın ("Yalnızca yılı soruyoruz. Bazı özellikler yaşa göre açılır.") · **Sana nasıl seslenelim?** · Adın ya da takma adın ("İsteğe bağlı. Yalnızca bu cihazda saklanır.") · **Devam et** | Doğum yılı zorunlu ve **saklanmaz** (2026-10-14): 13 altı için yalnız hesap kapısının yılı, 13–17 için yalnız 18'e girilen yıl, 18+ için hiçbir yaş kaydı tutulmaz. Hesap açarken yıl yeniden sorulur. Hatalar: "Doğum yılını yaz (ör. 2008)." · "Doğum yılını dört haneli yaz (ör. 2008)." · "Bu yılı bir daha kontrol eder misin?" |
| Bilmen gerekenler | Dört kart: **Her şey bu telefonda** · **Sesin kaydedilmez** · **Reklam yok** · **Yapay zekâ** ("Hikâye videoları yapay zekâ ile üretilir. Hi de bir yapay zekâ yardımcısıdır.") · 13 yaş altında: "13 yaşından küçüksen bu sayfayı bir büyüğünle birlikte oku." · **Taslak metin** kartı + **Kullanım koşulları** / **KVKK aydınlatma metni** bağlantıları · **Anladım, devam et** | Onay kutusu yok: hesapsız kullanımda veri telefondan çıkmaz. Hesap açılırken mevcut onaylar (§12) aynen istenir. Hukuk metinleri taslak (H-042). |
| Sana uygun ayarlar | "İkisini de sonra değiştirebilirsin." · **Günlük hedef** 5 / 10 / 15 dk · **Altyazıda Türkçe satır** (varsayılan açık) "… 1. Sezon (A1) için önerimiz: açık. Oynatıcıdan da değiştirebilirsin." | K-03. Tercih oynatıcıda uygulanır; oynatıcı menüsü de aynı tercihi kaydeder. |
| Seviye | **Seviyeni merak ediyor musun?** · "Kısa bir test sana bir başlangıç seviyesi önerir. Süre yok, en fazla 20 soru. İstediğin an bırakabilirsin." · **Kendi tahminin**: Bilmiyorum · A1 … C1 · **Teste başla** / **Testi atla** | K-06. |
| Soru | **SORU 3 · EN FAZLA 20** · Türkçe yönerge ("Boşluğa uygun kelimeyi seç." · "Boşluğa uygun olanı seç." · "Metni oku, soruyu cevapla.") · İngilizce madde · seçenekler · **Bilmiyorum** · üstte **Testi bırak** | Doğru/yanlış gösterilmez; "Bilmiyorum" utandırmaz. |
| Sonuç | **ÖNERİLEN BAŞLANGIÇ SEVİYESİ** · büyük seviye kodu · A1: "Hikâyenin 1. Sezonu A1 seviyesinde; tam senin için." · üstü: "Şimdilik hikâyenin yalnızca 1. Sezonu (A1) hazır. Bölümler sana kolay gelebilir; hikâyenin ve ifadelerin tadını çıkar." · **Bu yalnızca bir öneri** "Kısa bir tahmin; sınav ya da sertifika sonucu değil." | Vaat yok (K-08). |
| Hazır | İllüstrasyon · **Her şey hazır** · "Alex şehre yeni geldi. Hikâyesine birlikte başlayalım." · **İlerlemen bu telefonda**: 13+ "İstersen sonra Profil'den hesap açıp ilerlemeni yedekleyebilirsin." / 13 altı "Hesap gerekmez; her şey bu telefonda kalır." · **Hikâyeye başla** → Ana Sayfa | 13 altına hesaptan söz edilmez (H-002). Bildirim izni burada istenmez. |

Testler: `test/features/onboarding/` (13 altı yolu, atlanabilir test, kalıcı bitiş, eski kullanıcı, 1,3× yazı, erişilebilirlik), `test/goldens/h039_onboarding_golden_test.dart`.
