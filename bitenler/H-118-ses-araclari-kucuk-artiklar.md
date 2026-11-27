# H-118: Ses araçlarında küçük artıklar (H-114 sonrası)

- **Durum:** ✅ Bitti 2026-11-27 (bkz. Sonuç)
- **Tür:** Araç iyileştirmesi (`tools/content-pipeline`)
- **Bağımlılık:** H-114

## Maddeler
1. **`_dp_align` hızı:** en uzun gerçek parça (C2-K02 p03, 2.346 karakter) 2,5 sn/+10 MB; 5.000 karakter sınırında
   13,7 sn/+80 MB. Öneri: `sim()`/`norm()` önbelleği (en ucuz kazanç), sonra bantlı DP ya da `SequenceMatcher` çapaları.
   Ölçüm betikleri H-114 kaydında anlatıldı.
2. **Segment denetimi:** `booktr.py`, `lesson.py`, `tts_episode_tr.py`'nin kurduğu parçalar `_check_segments`'ten geçmiyor;
   bozuk `pronunciations` `KeyError` verebilir ya da API'ye gidebilir (bugün 3.141 içerik JSON'unda bozuk kayıt yok).
3. **Built-in Kotlin göçü (mobil; H-115 ile Flutter 3.50.1 geldi):** `android.builtInKotlin=false` / `android.newDsl=false` AGP 10'da kalkar;
   uygulama ve 4 eklenti (flutter_tts, shared_preferences_android, speech_to_text, video_player_android) hâlâ KGP uygular.
4. **flutter_tts** Swift Package Manager desteklemiyor; tek CocoaPods bağımlılığı.

## Sonuç (2026-11-27)
- **Durum:** ✅ Bitti (madde 3–4'ün kalan parçası eklenti yazarına bağlı; aşağıda).
1. **`_dp_align` hızı:** `fold()` kelime başına bir kez; 1:1 benzerlikler katlanmış kelime çiftine göre önbellekte;
   2:1 ve 1:2 adımları `real_quick_ratio()`/`quick_ratio()` üst sınırıyla erkenden elenir (bu adımlar `FUZZY_OK` altında
   zaten seçilemez); geri izleme `bytearray` + `array('d')`, `best` yalnız canlı 3 satır. **Sonuç birebir aynı:**
   yerel 2.990 hizalama dosyasında 4.056 durum (gerçek + iki bozulmuş Duyu dizisi) eski/yeni karşılaştırıldı, **0 fark**;
   toplam süre 1.615 sn → 447 sn (≈ 3,6×), en uzun gerçek parça (C2-K02 p03) 2,67 → 0,72 sn. qa incelemesi ayrıca
   10.000 rastgele durumda 0 fark buldu. Testler: `tests/test_tts_h118.py` (eski algoritma başvuru olarak testte).
2. **Parça denetimi:** `tts_tr.pron_problem` / `check_pronunciations` / `check_segments`; kitap (`booktr.py`),
   ders (`lesson.py`, `grammarlint.py`, `grammarexport.py`) ve bölüm/Hi/Konuş (`tts_episode_tr.py`: ses haritası,
   görev sözlüğü, `plan_item`) parçaları ücretli çağrıdan önce aynı denetimden geçer. Bozuk sözlük açık hata verir;
   lint ve dışa aktarma çökmez (hata olarak raporlar). Mevcut içerikte hiçbir parça reddedilmedi; lint sayıları aynı
   (kitap 30/0/157, dilbilgisi 71/0/7, içerik 0 hata/30 uyarı).
3. **Built-in Kotlin:** uygulama modülünden `kotlin-android` kaldırıldı; `speech_to_text` 7.5.0 (built-in Kotlin);
   shared_preferences_android 2.4.25 ve video_player_android 2.9.7 kilitte güncellendi. KGP uygulayan tek eklenti
   **flutter_tts 4.2.5** (en güncel) kaldı; bu yüzden `android.builtInKotlin=false` / `newDsl=false` duruyor
   (`gradle.properties` notu; yerelde yamalı flutter_tts ile ikisi `true` derlendi). flutter_tts built-in Kotlin
   sürümü çıkınca iki bayrak `true` yapılır.
4. **flutter_tts SPM:** hâlâ desteklemiyor (tek CocoaPods bağımlılığı; derleme uyarısı). Yapacak iş eklenti
   sürümüne bağlı.
- **Doğrulama:** pytest 613, `fvm flutter analyze` temiz, `fvm flutter test` 1530 geçti, Android debug APK ve iOS
  simülatör derlemesi başarılı (simülatör açılmadı), qa-code-reviewer: 1 küçük bulgu (dışa aktarmada çökme) düzeltildi.
