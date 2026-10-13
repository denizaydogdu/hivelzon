# H-055: "Söyle" alıştırmaları (S1, cihazda konuşma tanıma)

- **Durum:** Yapılacak (sırada; H-048'den hemen sonra)
- **Tür:** Uygulama
- **Faz:** 1.4c (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-036, H-046, H-048
- **Tasarım:** `docs/KONUSMA-ALISTIRMASI.md`

## Kullanıcı kararları (2026-10-13)
S1 MVP'de; dört yer: kelime tekrarında "Dinle ve söyle", anlam panelinde "Sen de söyle", karar anında "Söyleyerek seç", bölüm sonunda hedef ifadeleri söyleme. Cihaz desteklemiyorsa özellik görünmez. Bütün yaşlar (cihazda, kayıt yok).

## Kapsam
- Cihazda konuşma tanıma eklentisi (Flutter); yalnız on-device mod; iOS Info.plist mikrofon + konuşma tanıma izin metinleri (Türkçe); Android karşılığı.
- Karşılaştırma motoru (saf Dart, testli): normalleştirme, kısaltmalar, kelime düzeyinde fark, seçenekler arasında en yakını bulma, kabul eşiği.
- Dört yerde arayüz; puan yok; 2 deneme + "Geç"; Hi notu (hata kataloğu).
- Öğrenme olayı: yalnız sonuç; ses/transkript saklanmaz.
- Profil'de "Söyle alıştırmaları" aç/kapat ve gizlilik açıklaması.

## Kabul kriterleri
- Karşılaştırma motoru birim testli (doğru, eksik kelime, kısaltma, yanlış seçenek).
- Simülatör/cihazda izin akışı ve dört yer çalışıyor; desteklenmeyen durumda özellik görünmüyor.
- Ses ve transkriptin saklanmadığı testle doğrulanmış.
