# H-106: Açılışta "[H042] hatırlatma yeniden kurulamadı: ArgumentError" günlüğü

- **Durum:** ⏳ Başlanmadı (2026-11-04) — gözlem kaydedildi, neden incelenmedi
- **Tür:** Hata incelemesi (mobil, günlük hatırlatma)
- **Öncelik:** Düşük–Orta (uygulama açıldı, kullanıcıya hata gösterilmedi; ama hatırlatma kurulmamış olabilir)
- **Bağımlılık:** H-042 (günlük hatırlatma), H-013 (günde en fazla 1 hatırlatma)

## Gözlem

2026-11-04'te kullanıcının simülatördeki kısa denemesinde, uygulama açılırken şu günlük satırı görüldü:

```
[H042] hatırlatma yeniden kurulamadı: ArgumentError
```

Satır `mobile/lib/features/reminder/application/reminder_providers.dart` içindeki `sync()` yakalayıcısından gelir
(açılışta / öne gelince kayıtla işletim sistemini eşler). Günlüğe yalnız `e.runtimeType` yazıldığı için hatanın
mesajı ve yeri bilinmiyor. Simülatör ve sunucular deneme sonrası kapatıldı.

## İlk adım: gerçek nedeni bul (kod değiştirmeden önce)

- UNCONFIRMED: `ArgumentError` nereden geliyor? Adaylar `sync()` içindeki `store.read()`, `scheduler.permission()` ve
  `_schedule(s)` (`reminder_scheduler.dart`; saat dilimi/zamanlanmış tarih, bildirim eklentisi parametreleri).
  Tahminle düzeltme yapılmaz; önce birim testiyle ya da (kullanıcı izniyle) simülatörde hatanın mesajı ve yığını görülür.
- Günlüğe yalnız tür yazılması bilinçli (veri minimizasyonu); ayrıntı yalnız inceleme sırasında, kişisel veri içermeden
  okunur.

## Kabul kriterleri

- [ ] Hatanın gerçek nedeni (hangi çağrı, hangi argüman) bulunup bu dosyaya yazıldı.
- [ ] Neden bir kusursa düzeltildi ve onu yakalayan test eklendi; kusur değilse (ör. simülatör kısıtı) gerekçesi yazıldı.
- [ ] `cd mobile && flutter analyze && flutter test` yeşil.

## Test

```bash
cd mobile && flutter test test/features/reminder   # varsa ilgili testler; sonra tam takım
cd mobile && flutter analyze && flutter test
```

Simülatörde doğrulama yalnız kullanıcının o çalıştırma için açık izniyle yapılır.

## Geri alma

İnceleme işi; kod değişikliği yapılırsa tek commit olarak geri alınır.
