# H-054: Performans temeli (video, görsel, ölçüm)

- **Durum:** Bitti
- **Tür:** Boru hattı + uygulama
- **Bağımlılık:** H-053
- **Faz:** 1.4'' (H-051'den önce)

## Kaynak
Kullanıcının paylaştığı "20 things for speedmaxxing" listesi (2026-10-12). Mobil uygulamaya uyarlandı. Ölçülen sorun: bölüm paketleri 26–46 MB; segmentler 1080×1920, ~4,6 Mbps.

## Kapsam (kullanıcı kararı)
- **Video:** her segment için 720×1280, ~1,5–2 Mbps (H.264, faststart) sürüm; uygulama varsayılan olarak bunu oynatır; 1080p sürüm pakette kalır (ileride HLS/ABR, H-044 Bunny). Senkron ≤ 0,2 sn korunur.
- **Görsel:** stills, harita, poster WebP (kalite ~80); uygulama WebP okur.
- **Ölçüm:** uygulama açılış süresi (soğuk/sıcak), oynatıcı açılışı, harita ve defter ekranlarında kare hızı (Flutter DevTools / `--profile`, simülatör); sonuçlar bu dosyaya.
- **Temizlik:** kullanılmayan paketler (ör. `cupertino_icons`), gereksiz büyük dosyalar.
- **Görünür bekleme:** uzun yüklemelerde iskelet görünümü (harita, defter, Ana Sayfa kartları).

## Diğer işlere dağıtılanlar
- H-037: veritabanı indeksleri, N+1 sorgu denetimi, sayfalama, nadiren değişen API cevaplarına önbellek, açılış süresi.
- Hi-B (`docs/HI-ASISTAN-VE-KOC.md`): yapay zekâ cevabı akıtarak gösterilir.
- H-043: ucuz Android telefonda 4G testi, açılış ve kare hızı hedefleri.
- H-044: CDN, sunucu Türkiye'de.

## Kabul kriterleri
- Paket boyutu B1–B4'te en az %50 küçük (720p sürüm); senkron ≤ 0,2 sn; ses -16 LUFS.
- Ölçüm tablosu yazıldı.
- Testler yeşil.

## Notlar

### 2026-10-12: Uygulama ve doğrulama (gerçek ölçümler)

**Yapılan**
- **Boru hattı:** her segment, özet ve tepki videosu için `segments/<düğüm>.720p.mp4` (720×1280, H.264 High yuv420p, CRF 21 + maxrate 2M / bufsize 4M, `-preset slow -tune animation`, faststart). 1080p son çıktıdan yeniden kodlanır; **ses kopyalanır** (md5 aynı), Ken Burns yeniden çizilmez. Önbellek `_build/cache/r720/`. Sezon jeneriği de (`jenerik-*.720p.mp4`). `scenes.json` video düğümlerinde `renditions: {"720p", "1080p"}`, başlık düğümünde `seasonRenditions`; `video` alanı 1080p kalır (schemaVersion 2 içinde geriye uyumlu, şema güncellendi). `manifest.json` → `renditions`, `renditionBytes`.
- **Görseller:** stills, başlık afişi ve harita WebP (q80, ImageMagick `webp:method=6`); harita kayıpsız `map.png`'den. JPG yedeği gerekmedi (Flutter WebP'yi doğrudan açıyor). Defterde saklı eski `stills/*.jpg` yolları uygulamada `.webp` olarak denenir, olmazsa asıl yol (simülatörde eski kayıtlı kart görseli açıldı).
- **Uygulama:** varsayılan 720p (`video_rendition.dart`; yayında sabit; debug/profile'da `--dart-define=HV_RENDITION=1080p`). İskelet görünümleri: Ana Sayfa "Hikâyen" kartı, Hikâye haritası, Defter listesi ve İpucu panosu (tema renkleri, hafif nabız, "hareketi azalt"ta durağan, tek ekran okuyucu duyurusu). Hata durumları değişmedi. `PerfLog` (`lib/shared/perf/perf_log.dart`, yalnızca debug/profile): açılış, Ana Sayfa hazır, sıcak açılış, bölüm açılışı → ilk kare ve kaydırma kareleri (`FrameTiming`).
- **Temizlik:** `cupertino_icons` kaldırıldı (kullanımı yok). Diğer bağımlılıklar kullanılıyor (`sqlite3_flutter_libs` içe aktarılmıyor ama drift'in yerel SQLite kütüphanesi için gerekli). Uygulamada ölü görsel varlığı yok. Geliştirme sunucusu `.webp` türünü tanıyor.

**Paket boyutu (uygulamanın indirdiği; önce = H-054 öncesi paket, sonra = 720p video + WebP + ortak dosyalar)**

| Paket | Önce | Sonra (720p) | Fark | Sonra (1080p seçilirse) | Diskteki paket (iki sürüm) |
|---|---|---|---|---|---|
| B1 | 27,1 MB | 11,4 MB | **−57,9 %** | 26,0 MB | 36,1 MB |
| B2 | 46,3 MB | 18,4 MB | **−60,2 %** | 45,1 MB | 62,2 MB |
| B3 | 30,7 MB | 11,1 MB | **−63,7 %** | 29,4 MB | 39,0 MB |
| B4 | 47,9 MB | 19,4 MB | **−59,4 %** | 46,2 MB | 63,4 MB |
| **B1–B4** | **151,9 MB** | **60,4 MB** | **−60,3 %** | 146,6 MB | 200,7 MB |
| Sezon 1 paketi | 16,5 MB | 4,8 MB | −70,8 % | 16,1 MB | 19,9 MB |

- Görseller: B1–B4 stills 10,0 MB → 4,7 MB (−52,8 %); harita 1,26 MB → 0,91 MB (−28 %); başlık afişi 143 KB → 87 KB (−39 %).
- Ortalama video bit hızı (ses dahil): 1080p 4,1–5,6 Mbps → 720p 1,68–1,93 Mbps; dosya başına 0,94–2,04 Mbps (kısa, hareketli klipler tavana yakın).

**Kalite ve senkron**
- 720p kodlama kaybı (720p ↔ lanczos ile küçültülmüş 1080p, SSIM): B1 s02 0,986; B2 s04 0,981; B4 s05 0,979; B3 s03 0,976. Kare karşılaştırmasında (1080p ↔ 720p büyütülmüş) gökyüzü/su geçişlerinde bantlaşma görülmedi; örgü ve saç tellerinde hafif yumuşama var (telefon ekranında fark edilmesi zor).
- Senkron (ilk ipucu ↔ gerçek ses başlangıcı, 720p dosyalarda): B1 0,003 · B2 0,010 · B3 0,007 · B4 0,010 sn (41 ölçüm, ölçülemeyen 0; sınır 0,2). 1080p ile aynı.
- 720p süre farkı (1080p'ye göre): en çok 0,000 sn (sınır 1 kare). Ses: kopya, bölüm başına -16,01…-16,16 LUFS (değişmedi).
- content-lint: 13 bölüm, 0 hata, 16 uyarı (eskisiyle aynı; çeviri ve kapsama uyarıları). Biçim denetimi: bütün 720p dosyalar `h264 High 720x1280 yuv420p`, faststart.

**Ölçüm (simülatör "hiVelzon iPhone 17", DEBUG derleme)**
iOS simülatörü profile/release modunu desteklemiyor; bütün sayılar **debug (JIT, assert açık)** derlemedendir ve gerçek cihazdaki release değerlerinden belirgin biçimde kötüdür. Göreli karşılaştırma ve gerileme izleme için kullanılır; mutlak hedefler H-043'te gerçek cihazda ölçülecek.

| Ölçüm | Sonuç | Not |
|---|---|---|
| Soğuk açılış: `simctl launch` → ilk kare | 1990 / 2006 / 2030 ms (kurulumdan sonraki ilk açılış 3574 ms) | simctl gecikmesi dahil |
| `main()` → ilk kare | 798–869 ms (ilk açılış 1499 ms) | |
| Soğuk açılış → Ana Sayfa hazır (kart çizildi) | 2251 / 2282 / 2388 ms | `main()`'den 1074–1227 ms; sezon + paket listesi yerel sunucudan |
| Sıcak açılış: `simctl launch` → ilk kare | 637–1095 ms | ön plana dönüş → ilk kare 8–11 ms |
| Bölüm açılışı → başlık videosunun ilk karesi (B1, 720p) | 830 ms | oynatıcı ekranı açılışından; başlık `play()` → ilk kare 651 ms (ön ısıtmasız) |
| Segment geçişleri (B1 başlangıç → ilk karar, 720p) | başlık→s02 auto **44 ms** (önden başlatıldı); s02→k1-ok karar **141 ms**; k1-ok→s03 auto **33 ms** | H-031 sınırı 150 ms |
| Harita kaydırma (~185 kare) | derleme ort 1,3–1,7 ms, p90 ≤ 2,5, en çok 5,7 ms; çizim ort 0,8–1,1, en çok 2,6 ms; **16,7 ms üstü kare 0** | `FrameTiming` |
| Defter listesi kaydırma (~160 kare, 10 ifade) | derleme ort 1,7–2,8 ms, p90 2,4–9,8, en çok 15,4 ms; çizim ort ≤ 1,2, en çok 3,2 ms; **16,7 ms üstü kare 0** | |
| `flutter build ios --simulator --debug` | 33,9 sn; Runner.app 162 MB (debug) | uygulama boyutu release'te H-043/H-044 |

**Testler**
- Boru hattı: `pytest` **77 geçti** (yeni `tests/test_performance.py`: sürüm adları, şema, `renditionBytes`, sezon sürümleri + WebP harita ve eski jpg temizliği, gerçek ffmpeg ile 720p: biçim, süre ±1 kare, ses md5 aynı, faststart; WebP still).
- Uygulama: `flutter analyze` sorun yok; `flutter test` **205 geçti** (yeni: sürüm seçimi 7, iskelet 4, Ana Sayfa iskeleti 1; harita yükleniyor testi iskelete güncellendi; fixture'lar yeni paketten).
- Yeniden dışa aktarma: B1–B4 + Sezon 1 (ücretli çağrı yok), hepsi TAMAM.

**Ekran görüntüleri** (scratchpad): `h054-skeleton-home.png`, `h054-skeleton-map.png`, `h054-skeleton-defter.png` (iskeletler, 6 sn gecikmeli yerel vekil ile), `h054-map-webp.png`, `h054-defter.png`, `h054-card.png` (eski jpg kaydı WebP ile açıldı), `h054-b1-decision.png` (720p, ilk karar), `h054-quality-compare.png` (1080p ↔ 720p).

**Ortam:** Ölçüm için B1 yeniden oynandı; ardından simülatördeki veri ölçüm öncesi yedekten geri yüklendi ("Deniz", B1–B2 bitti, B3 s04'te). Geliştirme sunucusu yeniden başlatıldı; normal debug derleme (`flutter run`) çalışıyor.

**Açık / sonraya**
- Gerçek cihazda release ölçümü ve hedefler: H-043. HLS/ABR (720p/1080p otomatik): H-044 (Bunny).
- Diskteki paket iki sürümle büyüdü (B1–B4 200,7 MB); CDN'e yalnızca kullanılan sürümler konabilir (H-044).
2026-10-13 (ana oturum): flutter test 205/205, pytest 77/77, analyze temiz yeniden doğrulandı. Kullanıcı "devam" (commit onayı).
