# H-099: Ana Sayfa önerilerini kişiselleştir ve eylemi netleştir

- **Durum:** Bitti (2026-10-26)
- **Tür:** Mobil arayüz + ürün metni
- **Bağımlılık:** H-088 (tek günlük plan), H-047 (Hi koçu), H-060 (Ana Sayfa)

## Kapsam

Kullanıcı geri bildirimi: "Ana sayfadaki öneriler daha düzgün, kullanıcıya
özgün olsun; ne yapacağını anlasın."

Öneri motoru kural tabanlı kaldı (K-25: yapay zekâ yok, gerekçe görünür).
Değişiklik, aynı plandan gelen bilginin **kullanıcıya daha anlaşılır ve kişisel
biçimde** sunulmasıdır:

1. Sabit **"Bugün için önerimiz:"** satırı kaldırıldı. Yerine `DailyPlan` içinde
   hesaplanan **kişisel durum cümlesi** (`contextLine`) geldi:
   - yeni kullanıcı: "İlk bölüm seni bekliyor; birlikte başlayalım."
   - bugün yarım bırakılan bölüm: "Bugün burada bıraktın; kaldığın yerden
     sürdürelim."
   - dün yarım bırakılan bölüm: "Dün burada bıraktın; kaldığın yerden devam
     edelim."
   - birkaç gündür bekleyen bölüm: "3 gündür burada bekliyor; kaldığın yerden
     devam edelim."
   - uzun ara: "Bir süredir yoktun; kısa bir tekrarla başlayalım."
   - ana adım bugün bitti: "Bugünkü ana adımı bitirdin; şimdi küçük bir görev
     var." / tekrar borcu varsa "Bugünkü ana adımı bitirdin; yeni ifadeler kısa
     bir tekrar bekliyor." / Hi notu varsa "Bugünkü ana adımı bitirdin;
     Hi'nin notuna bakalım."
   - B1+ yerleştirme: "Seviyene uygun kısa bir kitapla devam edelim."
   - ilk hafta konuşma görevi: "İlk haftanın 3. günü; bugün sıra konuşmada."
   - bugünlük her şey bitti/geçildi: sakin kapanış cümlesi.
2. Kart üstüne **süre + günlük hedef** hap satırı eklendi: "~6 dk" ve
   "Hedefe uygun" / "Hedefi aşar". Gerekçe metinlerindeki "Yaklaşık 6 dk sürer;
   günlük hedefine (10 dk) sığar." kuyrukları kaldırıldı; "Neden?" artık tek
   cümle. Ekran okuyucu için tam cümle korunuyor.
3. Düğmeler yapılacak işi söylüyor: **Bölümü başlat**, **Devam et**,
   **5 ifadeyi tekrarla**, **Nesneleri bul**, **Kitaba devam et**,
   **Kitabı dinle**, **Konuşmaya başla**.
4. Adım çipindeki "Sahne" **"Bölüm"** oldu.
5. "Çalışma araçların" başlığı **"İstersen kendin çalış"** oldu ve altına
   "Bugünkü adımın yukarıda; bunlar isteğe bağlı." eklendi. Böylece Kelime
   tekrarı/Defter ile bugünkü tek adım karışmıyor.
6. Hi panelindeki öneri kartı da gerekçeden ayrı **~N dk** satırı gösteriyor.

## Ürün sınırları

- Yeni öneri türü, yeni içerik, LLM/AI sohbeti veya sunucu işi yok.
- Kullanıcıya ait veriler cihazdan çıkmıyor; cümleler yalnızca yerel ilerleme,
  seviye, son etkinlik ve tekrar borcundan üretiliyor.
- Tek öğrenme eylemi ilkesi korunuyor: plan yine tek birincil kart gösteriyor.
- Suçlayıcı/geri sayımlı dil yok (K-32).

## Doğrulama

- `flutter analyze`: temiz.
- `flutter test`: **1483/1483**.
- Yeni birim testleri: `daily_plan_test.dart` kişisel durum cümlesi
  (yeni kullanıcı, bugün/dün/birkaç gün yarım bölüm, uzun ara, ana adım bitti,
  B1+, hepsi geçildi).
- Güncellenen regresyon testleri: gerekçede süre olmaması, düğme etiketleri,
  Hi panelinde ayrı süre satırı, Ana Sayfa meta satırı.
- Golden'lar yenilendi: `h060_ana_sayfa*.png` (4) ve turun arkasındaki Ana
  Sayfa'yı gösteren `h039_tur.png`.
- 320×568, metin 1,3×: taşma yok. İlk denemede uzun "Hedefine sığar" hapı
  3,2 px taştı; metin "Hedefe uygun" olarak kısaltıldı ve tam cümle ekran
  okuyucuya taşındı.

## Geri alma

- Kişisel cümle: `DailyPlan.contextLine` ve `_contextLine` kaldırılır; Ana
  Sayfa `HomeTexts.subtitleLoading` yerine sabit metne döner.
- Süre satırı: `HomeScreen._PlanMeta` ve `HiSuggestionCard` içindeki
  `hi-suggestion-minutes` bloğu kaldırılır; süre cümleleri gerekçelere geri
  eklenir.
- Düğme/çip metinleri `mobile/lib/l10n/tr_strings.dart` içinde tek yerdedir.
