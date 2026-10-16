# H-087: Konuşma eşleştirmesinde anlam hatası (P0)

- **Durum:** Devam ediyor (2026-10-16)
- **Tür:** Hata düzeltmesi (kod)
- **Faz:** F1 MVP — ürün incelemesi sonrası (2026-10-16)
- **Bağımlılık:** H-055

## Kapsam
- `mobile/lib/shared/speech/speech_match.dart` `compare`, eksik kelime yoksa fazladan kelimelere bakmadan `full` veriyor. Ürün incelemesinde (`docs/URUN-INCELEMESI-2026-10-15.md` §4 P0) yeniden üretildi:
  - "I can help you." ← "I can not help you." → `full` (yanlış);
  - "I agree." ← "I do not agree." → `full` (yanlış).
- Bu sonuç kelime tekrarında (FSRS) Good/Easy'ye gidebiliyor.
- Düzeltme: anlamı değiştiren fazladan kelimeler (olumsuzluk: not, n't, never, no, don't/doesn't/didn't…; modal değişimi; sayı; soru/olumsuz yapı değişimi) `full` sayılmaz. Doğal, anlamı korumayan ekler (hitap/ad: "I agree, Maya.", "yes", "please", "okay") cezalandırılmaz.
- Joker (`…`) kuralı korunur, ama joker de olumsuzluğu yutmaz.
- Belirsizlikte kullanıcı "yanlış" ilan edilmez: sonuç `close` olur ve mevcut "Bir daha dene / Geç" akışı çalışır (H-055: puan yok, utandırma yok).

## Kabul kriterleri
- Yukarıdaki iki örnek ve benzerleri (olumsuzluk, modal, sayı, kelime sırası) için yeni testler; ters anlamlı cevap `full` olmaz.
- İzinli doğal ekler `full` kalır; mevcut testler geçer.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.

## Notlar
- 2026-10-16: `SpeechMatcher.compare` artık fazla kelimelerden anlamı değiştirenleri (`changedWords`) ayırıyor: olumsuzluk (not/n't/cannot/never/no/nothing/nobody/none/nowhere/neither/nor), kip (can/could/may/might/must/shall/should/will/would; `'ll`, `'d` dahil), sayı (rakamlar kelimeye çevrilir; one/two/four/eight sesteş oldukları için hariç), başa eklenen do/does/did (soru). İfadede zaten geçen kelime sayılmaz. Beklenen her kelime duyulduysa ve böyle bir ek varsa sonuç `close` ("Neredeyse! İfadede olmayan bir kelime duydum: not"); kelime tekrarında Hard, Good/Easy değil. Jokerli ifadede yalnız olumsuzluk sayılır. Testler: `test/shared/speech/speech_match_test.dart` (H-087 grubu), `speak_review_test.dart`, `speak_places_test.dart`.
