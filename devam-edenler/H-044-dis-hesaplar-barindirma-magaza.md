# H-044: Dış hesaplar, barındırma ve mağaza (en son)

- **Durum:** Devam ediyor (2026-10-25). Hesap gerektirmeyen kod ve güvenlikler bitti; sunucu, Bunny, Apple/Google hesapları ve mağaza yüklemesi kullanıcıya bağlı.
- **Tür:** Uygulama + kullanıcı kararları
- **Faz:** 1.12 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-043
- **Hazırlık rehberi:** `docs/H-044-YAYIN-HAZIRLIK.md` (sunucu, CDN, mağaza adımları ve kontrol listesi)

## Kapsam
- **Sunucu yeri** (kullanıcıya sorulur): backend ve PostgreSQL kurulumu, yedekleme, TLS.
- **Bunny Stream:** hesap (kullanıcı açar), `VideoHostingPort` için Bunny adaptörü, B1–B4 yüklemesi.
- **Apple ve Google geliştirici hesapları** (kullanıcı açar): imzalama, TestFlight ve Google Play dahili test.
- **ElevenLabs:** H-006 kararı (2026-10-14) gereği ücretsiz hesapla üretilen sesler yayında kullanılabilir; yeniden üretim gerekmez. Ticari plan yalnız gelecekteki kotalar/koşullar değişirse değerlendirilir.
- KVKK: yurt dışı aktarım bildirimi (hukukçu teyidi).

## Durum (2026-10-25)
- **Bitti (hesap gerektirmeyen):** release HTTPS adres kapısı, Android debug-imza kaldırma + upload-key şablonu, iOS mağaza plist'i (`Info-Release.plist`), backend `prod` güvenlik kapısı, ters vekil istemci IP'si, reellerde sürümlü `v<N>` CDN yolu, mutlak HTTPS/HLS medya adresi desteği. Ayrıntı ve doğrulama: `docs/H-044-YAYIN-HAZIRLIK.md`.
- **Kullanıcıya bağlı:** Almanya sunucusu + DNS, Bunny hesabı, Apple App Store Connect kaydı, Google Play hesabı, veri sorumlusu bilgileri, muhasebe. Bunlar onaysız açılmaz.
- **Bilinen sınır:** Reel dışındaki paketler (bölüm/kitap/dilbilgisi) mobilde sabit `packages/<id>/` yolundan okunur; CDN'de bunlar sürümlenmez, sürümleme yalnız reellerde.

## Kabul kriterleri
- Uygulama sunucudaki backend ve Bunny medyasıyla uçtan uca çalışıyor.
- iOS ve Android dahili test sürümleri yüklendi.
- Sırlar repoda değil.

## Test
```bash
cd backend && mvn verify
cd mobile && flutter test && flutter build ipa
```

## Geri alma
Medya adaptörü yapılandırmayla yerel adaptöre döner; sunucu kurulumu repo dışı.

## Notlar
2026-10-11: Kullanıcı sunucu yerini, Bunny Stream hesabını ve Apple / Google geliştirici hesaplarını en sona bıraktı. O zamana kadar her şey yerelde çalışır.
2026-10-12: H-047'ye göre v1'deki AI sohbetinin (Hi-B) üretim sağlayıcısı da ölçümle bu aşamada seçilir (yerel Ollama mı, barındırılan model mi). Ticari ElevenLabs (H-006) yayından önce şart.
2026-10-12 (H-054'ten): Medya CDN'den (Bunny), uyarlanabilir akış (HLS); sunucu Türkiye'de (gecikme + KVKK).
2026-10-21: **Kullanıcı kararı:** kullanıcı verisi **Almanya'daki bir sunucuda** barındırılacak; hukukçuya göre KVKK md. 9 standart sözleşme/Kurul bildirimi gerekmez. Muhasebe soruları (yurt dışı hizmet KDV, fatura akışı) canlıya çıkarken bu işte ele alınacak. iOS `NSAllowsLocalNetworking` mağaza derlemesinde kapatılacak.
2026-10-21 (takip incelemesi #3): Yayına çıkmadan önce paketler **değişmez sürüm klasörlerinde** (`_reels/<id>/v<N>/` ya da içerik özeti) sunulmalı; katalog onaylanan pakete işaret etmeli, yeni sürüm yayındaki dosyaları ezmemeli; mobil paket sürümünü katalogla karşılaştırmalı.
2026-10-25: **Hesap gerektirmeyen dilim bitti.** Release derlemesi üç genel HTTPS adresi olmadan açılmıyor (`release_config.dart`); Android release debug anahtarıyla imzalanmıyor ve `key.properties` yoksa imzasız kalıyor; iOS release `Info-Release.plist` kullanıyor (yerel ağ izni yok, debug/profile'da var); backend `prod` profili yerel medya/CDN'siz/açık içe aktarmayla başlamıyor; ters vekil arkasında gerçek istemci IP'si için `forward-headers-strategy: framework`; reeller `content_version` ile `_reels/<id>/v<N>/` altında sunuluyor; paket içinde mutlak HTTPS/HLS adres destekleniyor. Doğrulama: mobil **1472** test + analyze temiz, backend **164** test (Testcontainers), Android debug/release APK (release imzasız), iOS release `--no-codesign` ve paket plist kontrolü. Rehber: `docs/H-044-YAYIN-HAZIRLIK.md`. Kalan: sunucu/DNS, Bunny, Apple/Google hesapları, mağaza yüklemesi, veri sorumlusu ve muhasebe — hepsi kullanıcı onayına bağlı.
