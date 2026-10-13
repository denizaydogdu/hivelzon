# H-055: "Söyle" alıştırmaları (S1, cihazda konuşma tanıma)

- **Durum:** Bitti (simülatör + sahte tanıyıcıyla; gerçek telefon H-043)
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

## Notlar
2026-10-13: Uygulandı ve doğrulandı (commit yok). Özet:
- **Eklenti:** `speech_to_text` **7.4.0** (BSD-3-Clause; 7.5.0 Flutter ≥ 3.44 istediği için sabitlendi). Bulut tanımaya düşmemek için destek uygulamanın kendi kanalıyla (`tr.velzon.hivelzon/speech`) sorulur: iOS `SFSpeechRecognizer(en-US|en-GB).supportsOnDeviceRecognition`, dinlemede `requiresOnDeviceRecognition`; Android API 31+ ve `isOnDeviceRecognitionAvailable`. Desteklenmiyorsa, izin reddedildiyse ya da Profil'den kapatıldıysa hiçbir "Söyle" düğmesi görünmez. Info.plist (Türkçe izin metinleri), Android `RECORD_AUDIO` + `RecognitionService` sorgusu.
- **Kod:** `mobile/lib/shared/speech/` (port, cihazda adaptör, sahte tanıyıcı, karşılaştırma motoru, `SpeakController`, ortak widget'lar, Drift deposu, sağlayıcılar), `features/speak/` (izin akışı, Profil bölümü). Drift şema 4: `speech_attempts` (yalnızca yer, içerik, beklenen ifade, düzey, duyulmayan kelime sayısı, hata kataloğu kimliği; transkript ve ses sütunu yok). Dört yer: kelime tekrarı `TaskType.speak` (reps ≥ 2, `reps % 3 == 2`, sesli kalıp/cümle), anlam paneli "Sen de söyle", karar anı "Söyleyerek seç" (yalnızca İngilizce seçenekler; belirsizse seçilmez), bölüm sonu "Hedef ifadeleri söyle" (tam söylemek `targetPhrase` kapı ölçütünü `speak#end` ile ekler; dokunarak yol aynı).
- **FSRS:** tam → Good (olgun kartta ilk denemede < 6 sn → Easy); yakın → Hard; 2 denemede olmadı / Bilmiyorum → Again; Geç → not ve kayıt yok.
- **H-048 düzeltmeleri:** balon görünürken sekme sayfalarının alt güvenli alanı balon kadar büyür (Ana Sayfa, Profil, Hikâye odak kartı balonun üstünde biter); haftalık özette "Hatırlama" ve "Diğer" konu sayılmaz.
- **Doğrulama:** flutter analyze temiz; flutter test **356 geçti** (önce 281; +75). pytest çalıştırılmadı (boru hattına dokunulmadı).
- **Simülatör (hiVelzon iPhone 17, iOS):** gerçek adaptörle destek **var** göründü (`needsPermission`); Türkçe açıklama → iOS konuşma tanıma ve mikrofon izinleri verildi; dinleme simülatörde `error_unknown (300)` ile bitti → "Seni duyamadım. Bir daha dene." (çökme yok). Dört yer `HV_FAKE_SPEECH=close,full` + `AUTOPLAY_TEST=h055` ile görüntülendi (scratchpad `h055-*.png`). Kullanıcı veritabanı yedeklenip geri yüklendi; simülatördeki mikrofon izni sıfırlandı (konuşma tanıma izni `simctl` ile sıfırlanamadı, verilmiş kaldı).
- **Gerçek cihaz doğrulaması H-043'te.**
- **Açık sorular:** iOS sistem izin penceresi Apple'ın sabit "ses Apple'a gönderilebilir" cümlesini gösteriyor (bizim tanıma cihazda zorunlu; hukuk/metin teyidi); Android'de dil paketi kontrolü (API 33 `checkRecognitionSupport`) yok; motor hatası bir deneme sayılıyor.
2026-10-13 (ana oturum): Kullanıcı kararı: ikinci denemede tam söyleme → Hard (uygulandı, test güncellendi). flutter test 356/356, analyze temiz. Commit onayı. Simülatörde gerçek tanıma çalışmadı (error_unknown 300) → gerçek cihaz doğrulaması H-043.
