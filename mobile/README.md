# hiVelzon mobil

Flutter uygulaması (iOS + Android). Paket kimliği: `tr.velzon.hivelzon`.

```bash
flutter pub get
flutter analyze
flutter test
flutter run            # bağlı cihaz ya da açık simülatör
```

Keşfet reelleri varsayılan olarak backend'in yayımlanmış kataloğunu okur:
`--dart-define=API_BASE_URL=http://127.0.0.1:8080` (varsayılan) ve
`--dart-define=REEL_CATALOG_URL=http://127.0.0.1:8080/api/v1/catalog/reels`.
Yalnız yerel demo için `REEL_CATALOG_URL=''` verilerek dosya kataloğu
(`/reels/index.json`) kullanılabilir; backend kapalıyken Keşfet hata verir
(sessizce dosya kataloğuna düşmez).

Klasör yapısı:
- `lib/app/`: uygulama kökü, tema, yönlendirme (go_router)
- `lib/features/<sekme>/`: her sekmenin ekranları
- `lib/shared/`: ortak bileşenler

Geliştirici kurulumu için kök `README.md` dosyasına bakın.
