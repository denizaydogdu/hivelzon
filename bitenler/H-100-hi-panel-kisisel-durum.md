# H-100: Hi panelinde kişisel durum cümlesi

- **Durum:** Bitti (2026-10-27)
- **Tür:** Mobil arayüz + ürün metni
- **Bağımlılık:** H-099 (kişisel durum cümlesi), H-088 (tek günlük plan), H-047 (Hi koçu)

## Kapsam

H-099'da Ana Sayfa selamının altına gelen kişisel durum cümlesi yalnız Ana
Sayfa'da görünüyordu. Hi panelini açan kullanıcı aynı bağlamı kaybediyor,
doğrudan öneri kartıyla karşılaşıyordu.

Bu işte Hi panelindeki **Bugünkü öneri** bölümünün üstüne aynı
`DailyPlan.contextLine` cümlesi eklendi:

- "İlk bölüm seni bekliyor; birlikte başlayalım."
- "Dün burada bıraktın; kaldığın yerden devam edelim."
- "Bugün kısa bir tekrarla başlayalım."
- "Bugünkü ana adımı bitirdin; yeni ifadeler kısa bir tekrar bekliyor."
- "Seviyene uygun kısa bir kitapla devam edelim."

Cümle Ana Sayfa ile **aynı** plandan gelir; Hi için ayrı bir kişiselleştirme
kuralı yazılmadı. Panel artık `dailyPlanProvider`ı doğrudan izliyor; böylece
öneri, durum cümlesi ve "Başka bir öneri" sonrası yeniden hesaplanan plan aynı
kaynaktan okunuyor.

## Ürün sınırları

- Yeni öneri türü, LLM/AI sohbeti, sunucu ya da yeni veri yok.
- Tek eylem ilkesi korunuyor: panelde yine tek birincil düğme var.
- Kişisel cümle kartın eylemini yinelemiyor; yalnızca "bugün bende ne var?"
  sorusunu yanıtlıyor.
- Suçlayıcı, geri sayımlı ya da kıyaslayan dil yok (K-32).

## Doğrulama

- `flutter analyze`: temiz.
- `flutter test`: **1483/1483**.
- `test/features/hi/hi_ui_test.dart`: Hi panelinde `hi-suggestion-context`
  anahtarı ve Ana Sayfa ile aynı `HomeTexts.contextFirstEpisode` cümlesi
  doğrulanıyor.
- `test/goldens/h064_quality_test.dart`: Hi paneli 320 × 568, metin 1,3× ile
  taşmıyor; erişilebilirlik yönergeleri geçiyor.
- Golden değişmedi; yeni bir görsel katman eklenmedi, metin kartın üstünde
  akıyor.

## Geri alma

- `mobile/lib/features/hi/presentation/hi_panel.dart` içinde
  `dailyPlanProvider` yerine yeniden `hiSuggestionProvider` izlenir ve
  `hi-suggestion-context` metni kaldırılır.
- Metin `DailyPlan.contextLine`dan geldiği için `tr_strings.dart` içinde ayrı
  bir kopya yoktur; geri alma tek dosyada kalır.
