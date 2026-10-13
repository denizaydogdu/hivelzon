# Arayüz metinleri kılavuzu (H-053)

> **Durum:** Taslak 1 (2026-10-12). Uygulama bu kılavuza göre güncellendi.
> **Kod:** metinler `mobile/lib/l10n/tr_strings.dart` dosyasında ekran ekran durur. Oynatıcının değişmeyen metinleri kendi widget'larındadır (§4.5).
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
12. **Görsel düzen.** 8 px ızgara, köşe 12 px. Yazı ağırlığı en fazla 3 tanedir (400 / 500 / 700); `w600` kaldırıldı. Yazı en az 12 px, dokunma alanı en az 48 px.

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
| **Defter** | İfadeler ve İpucu panosu. | "Kelime listesi" |

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
"Sezon 1 jeneriği: The Missing Signal", "Geç" (ekran okuyucu: "Jeneriği geç"), "Jenerik açılamadı." ve "Geri dön" metinleri aynı kalır. Kısa süreli "Yapay zekâ ile üretilmiştir" notu da aynı kalır.

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

Sonraki adım: oynatıcı metinleri de `tr_strings.dart` dosyasına taşınabilir. Bu iş, bu kılavuzla davranış değiştirmeden yapılır.

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
| Boş | Defterin henüz boş. … "Deftere ekle" de diyebilirsin. | aynı | |
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
| Diğerleri | "Açık sorular", "Bulduğun ipuçları", "Şimdilik bildiğin: …", "Henüz ipucu yok. …", "İpucu panosu açılamadı." | aynı |

### 5.3 Kelime tekrarı oturumu
| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Başlık | Tekrar · 1 / 5 | Kelime tekrarı · 1 / 5 | Özellik adı. |
| Boş | Şu an tekrar edilecek kart yok · Kartlar zamanı gelince geri gelir. | Şu an tekrar edilecek ifade yok · İfadeler zamanı gelince yeniden gelir. | Terim. |
| Geri bildirim | Bu kart oturumun sonunda yeniden gelecek. / Bu kartı yakında yeniden göreceksin. | Bu ifade … / Bu ifadeyi … | Terim. |
| Düğme | Devam | **Devam et** | Fiil. |
| Özet | 4 kartı tekrar ettin. · 2 kart yarın yeniden gelecek. · n kart daha sonra gelecek. | 5 ifadeyi tekrar ettin. · 2 ifade yarın yeniden gelecek. · n ifade daha sonra gelecek. | Terim. |
| Görevler | "Resme ve anlama bak: doğru ifadeyi seç.", "Dinle ve duyduğun ifadeyi seç.", "Kelimeleri doğru sıraya diz.", "İngilizcesini yaz.", "İngilizcesini aklından söyle, sonra kartı aç." | aynı | |
| Düğmeler | "Dinle", "Kontrol et", "Kartı aç", "Bildim", "Bilmiyorum", "Tamam", "Geri dön" | aynı | |
| Yazma alanı | İngilizce yaz | İngilizcesini yaz | Görev cümlesiyle aynı. |
| Geri bildirim | "Doğru!", "Sorun değil, birlikte bakalım.", "Doğrusu bu.", "Seçtiğin: …" | aynı | Suçlamasız. |
| Kartın yüzü | "TÜRKÇE ANLAMI", "BÖLÜMDEKİ CÜMLE", "Cümleyi dinle", "İfadeyi dinle", "Görsel yok" | aynı | |

## 6. Profil

Düzen: başlık ve tek cümle, ardından **Sana nasıl seslenelim?**, **Defter** ve **Günlük hedef** bölümleri.

| Yer | Eski | Yeni | Neden |
|---|---|---|---|
| Başlık | Profil | Profil · "Adın, defterin ve günlük hedefin." | Sayfada ne olduğu. |
| Ad bölümü | — | **Sana nasıl seslenelim?** Alan: "Adın ya da takma adın". Yardım metni: "İsteğe bağlı. Yalnızca bu cihazda saklanır." Düğme: **Kaydet** | Kullanıcı kararı (H-053). KVKK gereği en az veri: yalnızca ilk ad ya da takma ad. |
| Ad hataları | — | "En fazla 20 karakter yazabilirsin.", "Yalnızca harf, boşluk, kesme işareti ve tire kullanabilirsin." | Nedeni söyler, suçlamaz. |
| Ad kaydı | — | "Adın kaydedildi." / Boş kaydedilince: "Adın silindi; Ana Sayfa "Merhaba!" der." | Sonucu görünür. |
| Defter bölümü | Defter · "Henüz ifade yok · ipucu panosu" / "12 ifade · 4 tekrar bekliyor" | **Defter** başlığı; satır: "Defterini aç" · "Defterinde 12 ifade var; 4 ifadenin tekrar zamanı geldi." / "Henüz ifade yok. Bölüm bitince ifadeler buraya eklenir." | Sayılar cümle içinde; düğme fiil. |
| Günlük hedef | Günlük hedef · 5 / 10 / 15 dk | Günlük hedef · "Günde ne kadar zaman ayırmak istersin?" · 5 / 10 / 15 dk | Seçimin ne olduğu. |
| Hedef notu | Tekrarda günde en fazla 10 yeni kart açılır. | Kelime tekrarında günde en fazla 10 yeni ifade açılır. | Terim. |

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
- `test/features/profile/profile_test.dart`: ad kuralı, kalıcılık (`app_meta`) ve Profil ekranı.
- `test/features/notebook/notebook_ui_test.dart`: Ana Sayfa'da adlı ve adsız selam; tekrar zamanı gelmiş ve gelmemiş durum; Defter açıklamaları.
- `test/features/home/home_screen_test.dart` ve `test/features/story/story_screen_test.dart`: sezon ilerleme cümlesi, harita başlığı ve açıklaması.
