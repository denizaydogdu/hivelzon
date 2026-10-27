# H-092 — Pilot kiti (gözlemli test + 7–14 günlük pilot)

> **Durum (2026-10-21):** Onam metni hukukçu tarafından uygun bulundu (tek metin, 90 gün yeterli, 13–17 ek veli onayı yok); veri sorumlusu bilgileri ayrı fazda. Bu belge
> H-092'nin "test senaryosu ve onay metni hazır" teslimini karşılar; saha çalışması (5 kişi + 15–20 kişi)
> henüz yapılmadı. **Pilot içeriği ve teknik kapı hazır:** 18 sesli reel (Sarah/Will/Chris) yayında,
> uygulama backend'in yayımlanmış kataloğunu okuyor, geri çekme uçtan uca doğrulandı.
> **Amaç:** hiVelzon'un ilk sürümünü **gerçek kullanıcıyla** sınamak. İstatistiksel kanıt iddiası
> yoktur; kararlar için **yön gösterici** bulgu toplanır.
> **İlgili:** `docs/KESFET-GUNLUK-UC-VIDEO-PLAN-2026-10-18.md` §12, `docs/REEL-PAKETI.md` §8,
> `bitenler/H-002-yas-politikasi.md`, `yapilacaklar/H-092-kullanici-pilotu.md`.

## 1. İki aşama

> **Zamanlama (kullanıcı kararı 2026-10-21):** A erken ve isteğe bağlı — 2–3 kişiyle de başlanabilir; uygulama kullanıcının iPhone'una Xcode ile kurulur, backend ve içerik sunucusu Mac'ten yerel ağda açılır (dışarı veri çıkmaz). B, katılımcılar evden bağlanacağı için internetten erişilebilir sunucu + TestFlight ister → H-044 ile **en sonda**.

| Aşama | Kim | Süre | Ne ölçülür |
|---|---|---|---|
| **A. Gözlemli kullanılabilirlik** | 5 kişi (A1/A2) | 45–60 dk, bire bir | İlk kullanımda takılma, yardım ihtiyacı, sekme düzeni |
| **B. Evde pilot** | 15–20 kişi (A1/A2) | 7–14 gün, günde ≤10 dk | Günlük üçlüyü bitirme, soru yanıtlama, D1/D7 dönüş, hatırlama |

A ve B **ayrı kişilerle** yapılır (öğrenme etkisi karışmasın). A'da bulunan ciddi engel
düzeltilmeden B başlamaz.

## 2. Katılımcılar

- **Dil seviyesi:** A1 veya A2 (kendi beyanı + uygulama yerleştirmesi). A2 ağırlıklı olabilir.
- **Cihaz:** gerçek iPhone (simülatör değil), iOS 17+, kulaklık. Android bu turda **yok**.
- **Yaş:** **13 yaş altı katılımcı yok** (H-002 kararı). 13–17 için ek veli onayı **gerekmez** (hukukçu, 2026-10-21).
- **Hariç:** proje ekibi, içerik üretiminde yer alanlar, aynı haneden ikinci kişi.
- **Teşvik:** yok (pilot); ulaşım/cihaz sağlanmaz.
- **Hedef çeşitlilik:** en az 2 katılımcı İngilizceyi iş için, 2'si seyahat için öğreniyor;
  en az 1'i "uygulama kullanmayı sevmeyen" profil.

## 3. Onam metni (hukukçu uygun buldu, 2026-10-21; iletişim yer tutucu)

> **hiVelzon kullanılabilirlik testi ve pilot — bilgilendirme ve onam**
>
> Bu çalışma, hiVelzon adlı İngilizce öğrenme uygulamasının ilk sürümünü anlamak için yapılıyor.
> Katılım **gönüllüdür**; istediğiniz an, gerekçe göstermeden ayrılabilirsiniz.
>
> **Ne yapacağız?** (A) Bir görüşmede uygulamada birkaç görevi yapmanızı isteyeceğiz ve
> yüksek sesle düşünmenizi dinleyeceğiz (45–60 dk). (B) Evde 7–14 gün boyunca günde 10 dakikayı
> geçmeyen üç kısa video ve bir soru akışını kullanacaksınız.
>
> **Ne kaydediyoruz?** Görüşmede **yazılı not** ve (izin verirseniz) **ekran görüntüsü** alırız.
> Uygulama içinde yalnızca **olay türü** (video bitti/bitmedi, soru doğru/yanlış/atlandı, ifade
> kaydedildi, tekrar tamamlandı, günlük dönüş), **süre** ve **yardım kullanımı** tutulur.
> **Ham ses, transkript ve yazdığınız metinler toplanmaz.** Konuşma pratiği kullanırsanız ses
> cihazda işlenir, bize gönderilmez.
>
> **Kim görür?** Notlar katılımcı koduyla (P01, P02…) saklanır; adınız rapora yazılmaz. Notlar
> rapor tamamlandıktan sonra en geç **90 gün** içinde silinir. Veriler reklam veya profilleme için
> kullanılmaz, üçüncü kişilerle paylaşılmaz.
>
> **Riskler:** Ekran başında geçen süre, anlaşılmama hissi. Ara vermek her zaman serbesttir.
>
> **Çekilme:** Çalışmadan ayrılırsanız o güne kadarki notlarınız silinir; bunun için
> [iletişim] adresine yazmanız yeterlidir.
>
>
> Onaylıyorum ☐  ·  Ekran görüntüsü alınmasına izin veriyorum ☐  ·  Tarih/İmza: ______

**Not:** Hukukçu tek metni ve **90 gün** saklamayı uygun buldu (2026-10-21). Sorumlu kişi ve
[iletişim] adresi veri sorumlusu bilgileriyle birlikte ayrı fazda doldurulur.

## 4. Aşama A — gözlemli test senaryosu

### 4.1 Hazırlık (10 dk)
- Telefon **temiz kurulum** (uygulama verisi sıfır), Wi-Fi, ses açık, ekran parlaklığı %70.
- Katılımcıya: "Bu bir sınav değil; uygulamayı siz değerlendiriyorsunuz. Takılırsanız bu bizim
  hatamızdır. Lütfen ne düşündüğünüzü yüksek sesle söyleyin."
- **Müdahale kuralı:** Katılımcı 30 sn takılırsa yalnız "şimdi ne yapmak istiyorsunuz?" diye sorulur;
  yolu gösterilmez. Görev ancak 2 dk sonra moderatör tarafından bitirilir ve "yardım" işaretlenir.

### 4.2 Görevler

| # | Görev | Başarı ölçütü | Sınır |
|---|---|---|---|
| 0 | Uygulamayı ilk kez aç, 1 dk serbest keşif | açılış tamam | 2 dk |
| 1 | **Keşfet → Bugün**: ilk videoyu izle, sonundaki soruyu yanıtla | video sonu + soru cevabı | 3 dk |
| 2 | İzlediğin videodaki bir ifadeyi **Defter'e kaydet**, sonra kaydettiğin ifadeyi bul | kart göründü | 2 dk |
| 3 | Bugün kaydettiğin ifadeyi **tekrar et** | kart ilerledi | 3 dk |
| 4 | **Hikâye → Bölüm 1**: aç, altyazıya dokun, Türkçe anlamı gör | anlam paneli açıldı | 3 dk |
| 5 | **Kitaplık**'tan bir kitap aç · **Dilbilgisi**'nden bir konu aç · **Konuş**'ta yardımı bul | üçü de açıldı | 4 dk |
| 6 | Günlük üçlüyü tamamla, bitiş kartını gör | bitiş kartı | 5 dk |

**Sekme düzeni karşılaştırması (2 dk):** Mevcut düzen **Ana Sayfa · Keşfet · Hikâye · Konuş ·
Profil**. Kâğıt prototip: **Ana Sayfa · Öğren · Pratik · Profil** (K-30). Soru: "Hangisinde
aradığınızı daha kolay bulurdunuz? Neden?"

> **Moderatör notu (okunmaz):** Defter iki yoldan açılır: **Ana Sayfa → "İstersen kendin çalış" → Defter / Kelime tekrarı** (H-088, H-099) ve **Profil → Defter**; tekrar düğmesi Defter ekranında da var.
> Videonun sağ tarafındaki **"Kaydet"** düğmesi ifadeyi Defter'e ekler. Katılımcı bu yolları
> kendisi bulmalı; yalnız 30 sn sonra §4.1'deki tek soru sorulur.

### 4.3 Kapanış soruları (5 dk)
1. En kolay gelen / en çok zorlayan şey neydi?
2. Bir sonraki açılışta ilk ne yapmak istersiniz?
3. Bu uygulamayı 2 hafta kullanır mıydınız? Neden / neden değil?
4. Günlük üç video yeterli mi, az mı, çok mu?
5. Kafanızı karıştıran bir kelime/etiket var mıydı?

### 4.4 Gözlem föyü (her katılımcı için bir sayfa)

| Alan | Değer |
|---|---|
| Katılımcı kodu / tarih / cihaz | P__ / __.__.____ / iPhone __ |
| Seviye (beyan + yerleştirme) | A1 / A2 |
| Görev 0–6: başarı (E/H) | |
| Görev 0–6: süre (sn) | |
| Yardım sayısı (moderatör) | |
| İlk anlamlı cevaba süre (görev 1) | |
| Takıldığı yer (tek cümle) | |
| Sekme tercihi (mevcut / prototip) + neden | |
| Alıntı (birebir, kısa) | |

## 5. Aşama B — 7–14 günlük evde pilot

### 5.1 Akış
- **Gün 0 (15 dk, görüntülü/telefon):** kurulum, seviye seçimi, "Bugün"ün tanıtımı, soru sorma kanalı.
- **Gün 1–14:** günde **en fazla 10 dk**; üç kısa video + her videonun sonunda **atlanabilir tek soru**.
  Zorunlu süre, seri (streak) veya hatırlatma baskısı yok.
- **Gün 7 (5 dk):** kısa kontrol görüşmesi: "Bu hafta ne işe yaradı, ne yaramadı?"
- **Gün 14 (15 dk):** kapanış görüşmesi + 5 ifadelik **hatırlama kontrolü** (aşağıda).

### 5.2 Ölçümler
Uygulamadan (otomatik, cihazda): video tamamlama oranı, soru sonucu (doğru/yanlış/atlandı),
Defter'e kaydetme, tekrar tamamlama, **D1/D7 dönüş**, günlük seti bitirme.
Görüşmeden: hatırlama kontrolü, memnuniyet (1–5), "devam eder misiniz?" (evet/hayır).

**Hatırlama kontrolü (gün 14):** Pilot boyunca görülen ifadelerden **5 tanesi** seçilir; katılımcıya
Türkçesi verilir, İngilizcesini **kendi cümlesiyle** söylemesi istenir. Ses kaydı alınmaz; yalnız
"bağımsız söyledi / yardımla söyledi / söyleyemedi" not edilir. Bu, uygulamanın `ownUse`/`helped`
ayrımıyla karıştırılmaz; **pilot ölçümüdür**, Defter kanıtı değildir.

### 5.3 Günlük mikro günlük (opsiyonel, 1 cümle)
"WhatsApp/Telegram'dan tek satır: bugün ne öğrendin?" — metin toplanmaz, yalnız konu başlığı not edilir.

## 6. Hedef eşikler (yön gösterici)

| Ölçüm | Hedef | Altında kalırsa |
|---|---|---|
| Görev tamamlama (A, görev 1–5) | ≥ 4/5 katılımcı | Akış sadeleştirilir; engel raporlanır |
| İlk video bitirme (B, gün 1) | ≥ %70 | Video süresi/ilk kare/otomatik oynatma gözden geçirilir |
| Soru yanıtlama (B) | ≥ %50 (atlamayan) | Soru metni ve yerleşimi sadeleştirilir |
| D7 dönüş | ≥ %40 | Günlük hatırlatma/ilk açılış değeri yeniden bakılır |
| "Devam ederim" (A+B) | ≥ 3/5 ve ≥ %60 | Değer önerisi ve günlük süre yeniden değerlendirilir |
| Anlaşılmayan etiket (A) | 0 kritik | Etiket sözlüğü düzeltilir |

Eşikler **garanti değil**, karar için çıtadır; sonuçlar kullanıcıya tek sayfada sunulur.

## 7. Veri ve etik sınırlar
- İçerik metni, ham ses, transkript **toplanmaz**; ekran görüntüsü yalnız onam varsa.
- Notlar katılımcı koduyla; rapor sonrası en geç 90 gün içinde silinir.
- 13 yaş altı yok; 13–17 için ek veli onayı gerekmez; istediği an çekilme.
- Pilot verisi **Defter/FSRS kanıtı sayılmaz**; ürün kararı içindir.

## 8. Pilot öncesi kontrol listesi
- [ ] P4: 18 reel `reel-lint` **0 hata** + `_build/lint.json` güncel. (2026-10-21: 18/0/0; pilot günü yeniden bakılır.)
- [ ] Backend: 18 reel içe aktarıldı, **onaylandı ve yayınlandı** (2026-10-21: 18 PUBLISHED, veritabanı V16); geri çekme denendi (uygulama kataloğundan düşüyor, günlük seçki aynı kategoriden yedekliyor).
- [ ] Uygulama **backend kataloğunu** okuyor (`REEL_CATALOG_URL` varsayılan `:8080/api/v1/catalog/reels`); backend kapalıyken Keşfet hata verir (dosya kataloğuna düşmez).
- [ ] Uygulama sürümü sabit (build numarası kaydedildi). Aşama A: kullanıcının iPhone'una `tools/device-build.sh` ile kurulum (yerel ağ adresleri, `docs/BETA-KONTROL-LISTESI.md`). Aşama B: TestFlight, H-044.
- [ ] İçerik sunucusu/CDN erişimi; 18 paketin sesi açılıyor; **kadın/erkek karakter sesleri ayrı** (Sarah · Will · Chris).
- [ ] Onam formu çıktı; katılımcı takvimi.
- [ ] Moderator + not alan kişi belirlendi; görüşme yeri/sessizlik.
- [ ] Yedek cihaz + şarj + kulaklık; ağ kesilirse planı (video indirilebilir mi?).

## 9. Çıktılar
1. `docs/H-092-BULGULAR-<tarih>.md` — 5 kişilik test notları (görev tablosu + alıntılar).
2. Pilot özeti: ölçüm tablosu, eşik karşılaştırması, K-30 sekme kararı önerisi.
3. Açık hata listesi (öncelikli) ve bir sonraki sürüm önerisi.

## 10. Ekler
- **Ek A:** Onam formu (yukarıdaki metin, imzalı).
- **Ek B:** Gözlem föyü (§4.4 tablosu, katılımcı başına).
- **Ek C:** Günlük takip tablosu (gün, izlenen video sayısı, soru sonucu, not).
