# H-035: Hikâye haritası, bölüm kapısı, yerel ilerleme

- **Durum:** Bitti
- **Tür:** Uygulama (kod)
- **Faz:** 1.3 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-031

## Kapsam
- Sezon haritası; kilitli bölümde kilit nedeni ve spoiler içermeyen ipucu.
- Bölüm kapısı (K-29): kavrama + hedef ifade + 1 etkin görev.
- Yerel ilerleme (Drift/SQLite): `user_story_progress`, kontrol noktası, bayraklar.
- Ana Sayfa'da "Hikâyeye devam".

## Kabul kriterleri
- Kapı kuralı birim testli.
- Uygulama kapatılıp açılınca kalınan yerden devam ediyor.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-035-hikaye-haritasi-ilerleme`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.

2026-10-12 — uygulama ve doğrulama (çalıştırılarak):
- **Depolama:** Drift 2.31.0 + sqlite3_flutter_libs 0.5.42 + path_provider 2.1.6 (geliştirme: drift_dev 2.31.0, build_runner 2.15.1; Dart 3.10 nedeniyle daha yenileri çözülmüyor). Tablolar: `user_story_progress` (status, lastCheckpointNodeId, checkpointSnapshot JSON, startedAt/completedAt/updatedAt UTC ISO-8601), `user_story_flags`, `gate_progress`, `season_state`, `app_meta`. Üretilen kod `mobile/lib/shared/storage/app_database.g.dart` depoda (`dart run build_runner build --force-jit`).
- **Taşıma:** `shared_preferences` → Drift bir kez (`app_meta` işareti, insertOrIgnore, eski anahtarlar silinmez). Eski kurulumda gerçek çalıştırma: "2 kontrol noktası, 4 biten bölüm, 1 sezon" taşındı; eski sürüm kapıyı kaydetmediği için biten bölümler `legacy` kapı satırıyla açık sayıldı (K-29).
- **Sezon kataloğu:** `icerik/_evren/harita/season-01.json` (12 bölüm, `mapPos`, spoiler'sız `teaserTr`, **DRAFT**) → `season.json` `episodes[]` + `map` (map.jpg 1520×2688). `export_package.py --season 1` yalnızca sezon paketini üretir. Konumlar map.jpg üzerinde ölçüldü, 12 nokta yolun üstünde (liman → kavşak → eski istasyon → tepe kafesi → fener).
- **Kilit kuralı:** N oynanabilir ⇔ paket var ve (N = 1 ya da N−1 kapısı tamam ya da bölüm daha önce başlatılmış/bitmiş). Paket yok → "Yakında" (tarih yok). Kilit nedeni: "Önce Bölüm N'i tamamla. Kalan adımlar: …" + "Acele yok; istediğin kadar tekrar deneyebilirsin."
- **Testler:** pytest 64 geçti (yeni 2). `flutter analyze` temiz. `flutter test` **129 geçti** (önce 86; yeni: kilit tablosu, harita modeli, Drift deposu + dosya ile yeniden açılış, taşıma, harita ekranı, Ana Sayfa kartı, oynatıcı başlangıç modları).
- **Simülatör (hiVelzon iPhone 17):** temiz kurulum → harita `0/12 1:next 2–4:locked 5–12:comingSoon`; B2 paneli kilit nedeniyle açıldı. `AUTOPLAY_TEST=h035` ile B1 sonuna dek: `completed=true gate=true`, errors=0. Dönüşte harita `1/12 1:completed 2:next 3–4:locked`. Uygulama kapatılıp açıldı (`h035view`): aynı durum. Normal açılışta Ana Sayfa kartı "SEZON 1 · BÖLÜM 2 · The New Neighbour · Başla". Ekran görüntüleri: scratchpad `h035-*.png`.
- **Bilinen:** Riverpod 3 duraklatılmış dinleyici + geçersiz kılma hatası nedeniyle oynatıcıdan dönüşte yenileme, ekran görünür olunca yapılır (`refreshWhenVisible`).
2026-10-12 (ana oturum): flutter test 129/129, pytest 64/64 yeniden doğrulandı. Kullanıcı kararları: merak cümleleri onaylandı (APPROVED); eski bitirmeler kapı tamam sayılır; commit onayı. Ana Sayfa kartına okunurluk için alt geçiş eklendi.
