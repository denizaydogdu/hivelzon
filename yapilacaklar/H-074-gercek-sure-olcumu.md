# H-074: Günlük hedef için gerçek süre ölçümü

- **Durum:** Yapılacak
- **Tür:** Uygulama (kod)
- **Faz:** Tasarım yenilemesinin devamı (H-060'tan doğdu)
- **Bağımlılık:** H-060

## Kapsam
- Ana Sayfa'daki günlük hedef halkası bugün **tahmin** gösteriyor: biten bölümlerin tahmini süresi + kelime tekrarı süresi. Yarım kalan bölüm ve Keşfet sayılmıyor.
- Gerçek öğrenme süresi cihazda ölçülür:
  - oynatıcıda ön planda geçen süre;
  - kelime tekrarı;
  - konu seti ve sahne avı;
  - ileride Keşfet (H-040) ve Kitaplık (H-067).
- Boşta kalma (uygulama arka planda, uzun süre dokunulmadı) sayılmaz.
- Yalnızca günlük toplam dakika saklanır (veri minimizasyonu). Hesap varsa eşitlenir.
- `todayActivityProvider` bu ölçümü kullanır; eski tahmin yalnız geçiş için kalır.

## Kabul kriterleri
- Yarım oynanan bölüm ve tekrar dakikaları halkaya yansır.
- Arka planda geçen süre sayılmaz.
- Testler yeşil.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: H-060 açık sorusu üzerine kullanıcı kararıyla açıldı: "Gerçek ölçüm ayrı iş olsun."

2026-10-14 (uygulama, kendi dalında): Ölçüm `mobile/lib/shared/activity/`. Tek saat (`StudyClock`); öğrenme ekranları (oynatıcı, kelime tekrarı, konu seti, sahne avı, kitap okuyucu, dilbilgisi dersi) yönlendiricide `StudyTimeScope` ile sarılır. Süre yalnız ekran açık **ve** uygulama ön plandayken sayılır; dokunma, oynayan video ve sesli okuma etkinlik işaretidir; iki işaret arasında en çok 2 dk sayılır (boşta kalma). Yalnız günlük toplam saklanır: Drift şema 8 `daily_activity` (yerel gün, kaynak, saniye); kaynak kurulumun rastgele kimliği (eşitleme `deviceId`'si değil). Hesap varsa eşitlenir (backend V10, düz LWW; eski istemciler etkilenmez). Halka: ölçülen süre + ölçüm başlamadan önceki etkinlik için eski tahmin (aynı süre iki kez sayılmaz). Keşfet (H-040) sekme içinde durduğu için şimdilik ölçülmez.
