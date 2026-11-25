# H-118: Ses araçlarında küçük artıklar (H-114 sonrası)

- **Durum:** ⏳ Sırada (düşük öncelik; ücretli harcama riski yok)
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
