# H-067: Kitaplık ve okuyucu (mobil)

- **Durum:** Devam ediyor (kod `main`'de: flutter 649/649, mvn 126/126; pilot kitaplarla simülatör denemesi ve kullanıcı onayı bekleniyor)
- **Tür:** Uygulama (kod)
- **Faz:** Kitaplık K2 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-066

## Kapsam
- **Kitaplık ekranı:** raflar (Okumaya devam et, Senin seviyen, diğer seviyeler, Okuduklarım), kitap kartı ve ilerleme halkası, "Bana bir kitap oku" (seviye seç → okunmamış kitap).
- **Okuyucu:**
  - renkli, resimli sayfa;
  - sesli ve sessiz mod;
  - okunan cümle vurgusu, kelime vurgusu ayarı;
  - otomatik sayfa çevirme;
  - oynat/duraklat, 10 sn geri, hız 0,75 / 1 / 1,25;
  - uyku zamanlayıcısı;
  - okuma yazı boyutu.
- **Dokun → anlam paneli** (`shared/meaning/`), "Sen de söyle".
- **Defter'e ekle:** dokunarak ya da uzun basarak. Kayıtta kaynak "Kitap: başlık, s. N", örnek cümle ve kitap sesinden kesilmiş telaffuz. Defter'de kitaba göre süzme; Kelime tekrarına (FSRS) girer; kitap sonunda "Bu kitapta kaydettiklerin".
- **İlerleme:** `user_book_progress` (Drift v6 + eşitleme, "bitti kazanır").
- **Hi önerisi:** `continueBook` / `startBook`.
- "Hareketi azalt" desteği. K-32 yasakları geçerli.

## Kabul kriterleri
- Kitaptan eklenen kelime Defter'de kaynağıyla görünür ve tekrara girer; aynı kelime iki kez eklenmez.
- Vurgu kayması ≤ 0,2 sn.
- Yarıda kalan kitap kaldığı cümleden açılır.
- Golden testler, erişilebilirlik testi, 1,3× metin; testler yeşil.

## Test
`cd mobile && flutter analyze && flutter test`

## Geri alma
Kendi dalında (`h-067-kitaplik-okuyucu`); `git revert`.

## Notlar
2026-10-14 (uygulama, dal `h-067-kitaplik-okuyucu`; kullanıcı denemesi ve pilot kitaplar H-069 bekliyor, bu yüzden iş henüz `bitenler/`e taşınmadı):
- **Yer:** Hikâye sekmesinde "Macera · Kitaplık" seçici (harita aynı). Kısa ekranda başlık haritayla kayar.
- **Kod:** `mobile/lib/features/library/` — `domain/book.dart` (paket modeli, `ChapterTrack.indexAt` zaman araması), `domain/book_progress.dart` (raflar, "Bana bir kitap oku" seçimi, birleştirme), `domain/book_notebook.dart` (Defter kaydı), `application/reader_controller.dart` (ses eşlemesi, uyku zamanlayıcısı, panel), `application/book_audio.dart` (`BookAudio` arayüzü; bugün `video_player`, H-068'de `just_audio` + `audio_service` buraya gelir), `presentation/` (Kitaplık, okuyucu, kitap sonu). İçerik: `ContentSource.listBooks/loadBook/bookMediaUri`; defter yolu `_books/<kitap>/…`.
- **Veri:** Drift şema 6 (`user_book_progress`, `notebook_items.source_title`), eşitleme tablosu `user_book_progress` (sıra 70); backend Flyway `V8__book_progress.sql`, `ProgressSyncTables` + `ProgressMerger.forBooks()`, defter kaynağı `book` ve `sourceTitle`. "Bitti" kazanır.
- **Hi:** `continueBook` (yarım bölüm, tekrar ≥ 5 ve Hi'nin notundan sonra), `startBook` (en son, dinlenmeden önce).
- **Ek (kullanıcı kararı 2026-10-14):** Defter satırında kullanıcının bölümde eklediği ifadeye "Bölüm N'den ekledin" (`ablativeNumber`), kitaptan eklenene "Kitap: <başlık>, s. N"; kitaba göre süzme çipleri.
- **Karar (uzun basma çakışması):** iki istek aynı hareketi istiyordu. Sesli modda kelimeye uzun basma = tek dokunuşla Defter'e ekle (ses durmaz); sessiz modda uzun basma = yalnız o cümleyi seslendir. Sessiz modda ekleme anlam panelinden. Kullanıcıya sorulacak (açık soru).
- **Vurgu kayması:** tahmin (50 ms adım) + taze örnek (200 ms); testte ≤ 0,05 sn ölçüldü, kabul ≤ 0,2 sn (`reader_controller_test.dart`, hız 0,75 / 1 / 1,25).
- **Yapılmayanlar:** Ana Sayfa'da ikincil "yarım kitap" kartı (yalnız Hi önerisi var); "bu kitaptan 5 ifade" kartı; arka planda / kilit ekranında dinleme (H-068). Kitap içeriği yazılmadı (H-069); testler H-066 deneme kitabı `A1-K99` kopyasıyla (`mobile/test/fixtures/books/A1-K99/`; testte ses ve görsel varmış gibi bölüm süreleri ve yollar eklendi).
- **Testler:** `cd mobile && flutter analyze && flutter test` (yeni: `test/features/library/*`, `test/features/hi/coach_books*_test.dart`, `test/shared/storage/schema6_migration_test.dart`, `test/shared/content/http_books_test.dart`, golden `test/goldens/h067_screens_golden_test.dart`); backend `cd backend && mvn -B verify` (`BookProgressSyncTest`). H-060 harita golden'ları seçici eklendiği için yenilendi.

2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
