# H-102: Ana Sayfa bilgi kartları Profil'e, kompakt düğmeler

- **Durum:** Devam ediyor — uygulandı, testler yeşil (1504/1504), simülatörde gösterildi (2026-11-01), kullanıcı geri bildirimi + commit bekliyor (kod yerelde)
- **Tür:** Mobil arayüz
- **Öncelik:** Orta
- **Bağımlılık:** H-038 (hesap kartı), H-095 (metin güncellendi kartı),
  H-057…H-064 (ortak bileşenler ve belirteçler)

## Kapsam

Kullanıcı isteği (2026-11-01, simülatör ekran görüntüsü):

- "Kullanım koşulları ve aydınlatma metni güncellendi" (`LegalUpdateCard`)
  ve "İlerlemen yalnızca bu telefonda" (`AccountNudgeCard`) kartları Ana
  Sayfa'da olmasın, **Profil**'e taşınsın. Ana Sayfa'nın tek eylem ilkesi
  ve günlük plan kartı korunur.
- Kart düğmeleri büyük olduğu için alt satıra kayıyordu; normal genişlikte
  tek satıra sığan, dar ekranda (320 pt, metin 1,3×) taşmayan kompakt
  düğmeler.

## Uygulama

- Profil: hesap kartı "Hesap ve gizlilik" grubunun, metin kartı "Hakkında"
  grubunun hemen üstünde. Kart gizliyken yer kaplamaz (`bottomGap`).
- Davranış aynı: metin kartı "Tamam" ya da metni açmakla kapanır
  (`app_meta` sürüm kaydı); hesap kartı "Şimdi değil" ile 30 gün gizlenir;
  hesap varken ya da 13 yaş altında görünmez.
- Mükerrerlik: Hesap satırının alt yazısı da "İlerlemen yalnızca bu
  telefonda…" diyordu. Kart görünürken satır "Hesap aç ya da giriş yap"
  der (mevcut `tileSignedOut` metni); kart yokken eski cümle kalır.
- Ortak kitaplık: `mobile/lib/shared/ui/buttons.dart` →
  `CompactButton.tonal` (birincil, açık mavi dolgu) / `CompactButton.quiet`
  (ikincil, yalnız yazı) ve `CompactActions` (Wrap, aralık `AppSpace.s8`).
  Belirteçler: `AppTouch.compact` (36), `AppTypography.buttonCompact`
  (14/20 kalın), `AppButtonStyles.compactTonal/compactQuiet`. Görünen
  yükseklik 36; dokunma alanı `MaterialTapTargetSize.padded` ile ≥ 48.
- Metin: düğmede **Koşullar** / **KVKK metni**; ekran okuyucu eski tam
  etiketi okur ("Koşulları aç" / "Aydınlatma metnini aç").
  `docs/ARAYUZ-METINLERI.md` §12 güncellendi.
- Anahtarlar `home-legal-update*` / `home-account-nudge*` →
  `profile-legal-update*` / `profile-account-nudge*`.

## Kabul

- Ana Sayfa'da iki kart yok; tek dolu ana eylem korunur.
- Profil'de iki kart ilgili grubun üstünde; hesap satırı kartı yinelemez.
- 390 pt genişlikte metin kartının üç düğmesi ve hesap kartının iki düğmesi
  tek satırda; 320 × 568, metin 1,3× taşma yok (kart ve tam Profil).
- Dokunma alanı ve etiket yönergeleri (Android/iOS/etiketli hedef, kontrast).
- `flutter analyze` temiz, `flutter test` tam takım yeşil.
- Kullanıcının simülatör kontrolü.

## Test komutu

```bash
cd mobile && flutter analyze && flutter test
# hedef: test/shared/ui/shared_ui_test.dart test/features/home/home_screen_test.dart \
#   test/features/profile/profile_test.dart test/features/account/account_ui_test.dart \
#   test/goldens/h059_screens_golden_test.dart
```

## Doğrulama (2026-11-01)

- `flutter analyze`: temiz.
- `flutter test`: **1493/1493** (önce 1483; 10 yeni test). H-103 ile birlikte son tam koşu **1504/1504**.
- Golden `h059_metin_guncellendi.png` güncellendi ve gözle kontrol edildi.

## Geri alma

Değişiklik yalnız mobil arayüzde; veri ve şema değişmez. Geri almak için
`home_screen.dart`'ta iki kartı `_Tools`'un altına geri koymak,
`profile_screen.dart`'taki iki `Column` sarmalını kaldırmak ve kartlarda
`CompactButton` yerine eski `OutlinedButton`/`TextButton`'a dönmek yeter
(ya da ilgili commit `git revert`). Ortak `CompactButton` başka yerde
kullanılmıyor; kalabilir.
