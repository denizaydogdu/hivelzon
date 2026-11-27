# hiVelzon

Yapay zekâ videolarıyla İngilizce öğrenme uygulaması (iOS + Android). Tüm seviyeler (A1–C1), tamamen ücretsiz.

Velzon Bilişim Teknolojileri Ltd. Şti. (Eskişehir · info@velzon.tr) ürünüdür.

**Güncel durum (2026-11-27):** `main` `0dce295`, CI `45964721594` yeşil (mobil, içerik, backend). 2026-11-25 bakım turu (H-110…H-115, H-117; Flutter 3.50.1, komutlar `fvm flutter …`) bitti. ElevenLabs Creator planıyla dilbilgisi İngilizce örnekleri 71/71, sesli kitap 20/30 (A1–B2); H-119 (kesik yanıt ücreti deftere) bitti. Kalan İngilizce ses yalnız C1/C2 kitapları: **H-120** (Aralık dönemi C1, Ocak dönemi C2; kullanıcı "devam" deyince). Karar bekleyen: H-116, H-109. Gerçek iPhone (H-043/H-068), kullanıcı denemesi ve kulakla kontrol, editör incelemesi açık; H-044 en sonda, H-092 ondan sonra. Sıradaki boş numara **H-121**; güncel liste `yapilacaklar/IS-SIRASI.md`, devir `docs/HANDOFF-2026-11-27.md`. Aşağıdaki eski durum satırları tarihseldir.

**Önceki durum (2026-11-20):** H-107 hak ve ses hesabı kayıtları tamamlandı (`ce0bfb7`, düzeltme/takip `6e885b9`), `bitenler/`de. Bölüm hak dosyaları ve editör paketi güncel; 12 bölümün editör onayı hâlâ bekliyor. H-043/H-068 gerçek iPhone, H-085/H-086/H-102/H-103/H-104/H-105 kullanıcı denemesi ve kulakla kontrol, H-106 simülatör doğrulaması açık. İngilizce sesler çalışan ElevenLabs erişimi/ayrı ücret onayı bekliyor; 2026-11-09'daki dördüncü ücretsiz anahtar da 401 verdi. Alania ücretsiz kampanyası 14 Kasım'da bitti; yeni üretim öncesi maliyet/onay gerekir. H-044 dış hesap ve mağaza en sonda, H-092 pilotu ondan sonra. Sıradaki boş numara **H-108**; güncel liste `yapilacaklar/IS-SIRASI.md`. 2026-11-20'de içerik testleri ve dört lint tekrar geçti (0 hata); mobil/backend sonuçları aşağıdaki 2026-11-04 kod sürümüne aittir. Aşağıdaki eski durum satırı tarihsel özettir.

**Durum (2026-11-04):** Faz 1 (MVP) uygulaması sürüyor (`docs/UYGULAMA-PLANI.md`). Son commit `954b0bd` (H-106 kök nedeni: yarım temizlikte `objective_c.framework` pakete girmiyor, cihazdaki kayıtlar okunamıyordu → "bağlantı kurulamadı"; temizlik kuralı `flutter clean && flutter pub get` oldu; teşhis günlüğü + 9 test; söyleniş düzeltmeleri), CI **`41815301690` yeşil** (mobil, backend, içerik); önceki `fd56543` (H-105 B2–C2 sesleri), CI `41798860052` yeşil; önceki `d2d81c0` (Octanove C1/C2 kapsaması, H-104, H-105 A1–B1) → **`41690063999` yeşil**. H-102 (Ana Sayfa kartları Profil'e) ve H-103 ("Hikâye" sekmesi → **Öğren**) commitli (`2988672`), kullanıcı denemesi bekliyor. H-104 (Konuş'ta Hi'nin Türkçe yönlendirmeleri Alania ile sesli, 32 ses) ve H-105 (kitapta "Sayfanın Türkçesi" sesli; üretim bitti: 30 kitap, 626 sayfa; Kasım defteri 764.686 karakter, 0 TL) commitli, kullanıcının kulakla kontrolü bekliyor. H-106 (açılıştaki hatırlatma `ArgumentError` günlüğü) `devam-edenler/`de: teşhis günlüğü eklendi, simülatör doğrulaması bekliyor. Octanove C1/C2 listesi depoda; C1/C2 kapsaması denetleniyor. Mobil **1526/1526**, backend **164/164**, pytest **417** ve bütün içerik lint'leri 0 hatayla geçiyor. **Uygulamanın görünen adı bütün ekranlarda Hi**; depo ve iç adlar `hiVelzon`. Bağımlılık sırasındaki kalan işler: (1) H-043/H-068 gerçek iPhone, (2) kullanıcı simülatör denemesi (H-085/H-086, H-102/H-103, H-104/H-105 kulakla kontrol), (3) öğretmen/editör incelemesi (paket: `docs/EDITOR-INCELEME-PAKETI.md`), (4) eksik İngilizce sesler, (4b) H-104/H-105 kulakla kontrol, (5) en sonda H-044 dış hesap/mağaza, (6) H-044 sonrasında H-092 pilotu. **TTS:** 2026-10-30'da ikinci ücretsiz ElevenLabs anahtarıyla 9.977 karakter üretildi (A2 dilbilgisi 15/15, A1 kitapları 5/5, sesli kitap 6/30); kota bitti, diğer iki anahtar `401 detected_unusual_activity` verdi. Kalan İngilizce ses için çalışan anahtar ya da ayrı onaylı ücretli plan gerekir (`docs/TTS-MALIYET-2026-10-30.md`). Ayrıntı: `yapilacaklar/IS-SIRASI.md`; denetim: `docs/SISTEM-DENETIMI-2026-10-28.md`; son devir: `docs/HANDOFF-2026-11-03.md`.

Ana deneyim oyunlaştırılmış, sürekli bir hikâye: *The Missing Signal*. Kahraman Aleyna "Alex" Yıldız, yol arkadaşı AI asistan Hi. Sezon 1 (A1) 12 bölüm + prolog; 12 bölümün hepsi üretildi ve uygulamada oynanıyor (B5–B12 editör onayı bekliyor). Bitenler: repo iskeleti, bölüm paketi + content-lint, etkileşimli oynatıcı, altyazıya dokununca Türkçe anlam, başlıkla açılış ve sezon jeneriği, hikâye haritası ve kalıcı yerel ilerleme (Drift), defter + ipucu panosu + FSRS tekrarı, kitaplık, dilbilgisi ve Keşfet reelleri. AI konuşma pratiği MVP'de yok, v1'de gelir.

## Belgeler

- [Proje rehberi](CLAUDE.md): bağlayıcı kararlar, kurallar, iş takibi (H-numaraları)
- [İş sırası](yapilacaklar/IS-SIRASI.md): nerede kaldık, sıradaki işler, günlük
- [3 Kasım oturum devri (tarihsel)](docs/HANDOFF-2026-11-03.md): o tarihteki durum; güncel sıra için [İş sırası](yapilacaklar/IS-SIRASI.md)
- [Sistem denetimi (2026-10-28)](docs/SISTEM-DENETIMI-2026-10-28.md): testler, CI bulgusu ve gerçek açık işler
- [Faz 1 uygulama planı](docs/UYGULAMA-PLANI.md): alt fazlar ve durumları
- [Editör inceleme paketi](docs/EDITOR-INCELEME-PAKETI.md): öğretmen/editör için tek giriş ve föy · [TTS maliyet seçenekleri](docs/TTS-MALIYET-2026-10-30.md)
- [Oyun ve hikâye tasarımı](docs/OYUN-TASARIMI.md) · [Bölüm paketi biçimi](docs/BOLUM-PAKETI.md) · [Hi asistanı ve koç](docs/HI-ASISTAN-VE-KOC.md)
- [İş ve ürün planı](docs/IS-PLANI.md) · [Şartname](docs/SARTNAME.md) · [İçerik mimarisi](docs/ICERIK-MIMARISI.md) · [Lisans raporu](docs/LISANS-RAPORU.md) · [Yayın hazırlığı](docs/H-044-YAYIN-HAZIRLIK.md) · [Tasarım yönü](tasarim/README.md)

## Dört ayak

1. Hazır hikâye bölümleri (yapay zekâ ile üretilen görseller ve seslerle; bölümler = video)
2. Yapay zekâ ile konuşma pratiği (v1; kotalı ve bütçe tavanlı)
3. Kişiselleştirme: tekrar (FSRS), defter, yan görevler
4. ~30 saniyelik kısa video akışı (Keşfet; bölüm klipleri)

Teknoloji: Flutter + Spring Boot 4 + PostgreSQL.

## Geliştirici kurulumu

Depo düzeni: `mobile/` (Flutter, iOS + Android, paket kimliği `tr.velzon.hivelzon`), `backend/` (Spring Boot 4, Java 17, Maven), `docker-compose.yml` (yerel PostgreSQL 17).

### Gerekenler
- **Flutter, FVM ile** (`brew install fvm`): hiVelzon Flutter sürümünü `mobile/.fvmrc` ile sabitler (şimdi 3.50.1); global Homebrew Flutter öteki projeler için olduğu gibi kalır. `cd mobile && fvm install && fvm flutter --version`, sonra `fvm flutter doctor`. Mobil komutların hepsi `fvm flutter …` / `fvm dart …` ile çalışır.
- **Xcode** ve iOS simülatörü (macOS).
- **Android SDK** (Android Studio ile). `adb` için platform-tools'u PATH'e ekleyin (`~/.zshrc`):
  ```bash
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
  ```
  Ardından `adb version` ve `fvm flutter doctor --android-licenses`.
- **Java 17** ve **Maven 3.6.3+**.
- **Docker**: macOS'ta Colima (`brew install colima docker docker-compose`, sonra `colima start`).

### Mobil
Bu çalışma alanında proje sahibinin güncel talimatı gereği simülatör her
çalıştırmadan önce açık izin alınarak açılır; genel “devam” talebi izin değildir.

```bash
cd mobile
fvm flutter pub get
fvm flutter analyze && fvm flutter test
xcrun simctl list devices available        # simülatör seç
xcrun simctl boot <cihaz-id> && open -a Simulator
fvm flutter run -d <cihaz-id>
```

### Backend
```bash
docker compose up -d --wait                # PostgreSQL 17 (localhost:5435) + Mailpit (SMTP 1027, arayüz 8027)
cd backend
mvn spring-boot:run
curl localhost:8080/actuator/health        # {"status":"UP"} beklenir
```
Ayarlar ortam değişkenlerinden okunur (`HIVELZON_DB_URL`, `HIVELZON_PORT`, `HIVELZON_JWT_SECRET`, `HIVELZON_OTP_PEPPER`, SMTP ve hız sınırları). Varsayılanlar yalnızca yerel geliştirme içindir; gerçek sırlar repoya girmez (`~/.config/hivelzon/`). `prod` profilinde `HIVELZON_JWT_SECRET` ve `HIVELZON_OTP_PEPPER` tanımlı değilse uygulama başlamaz. Port başka bir projede doluysa `HIVELZON_PG_PORT=<port>` ve `HIVELZON_DB_URL` ile değiştirilir.

Giriş parolasızdır: e-postaya 6 haneli kod (H-037). Yerelde kodlar projeye ait Mailpit'e düşer: <http://127.0.0.1:8027>. Bütün ayarlar, API listesi ve hata kodları: [`backend/README.md`](backend/README.md).

### Backend testleri (Testcontainers)
`mvn -B verify` testleri gerçek bir PostgreSQL konteynerinde çalıştırır. Colima kullanıyorsanız Testcontainers Docker soketini kendiliğinden bulamaz; şu değişkenleri tanımlayın:
```bash
export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
# Ryuk konteyneri başlamazsa: export TESTCONTAINERS_RYUK_DISABLED=true
cd backend && mvn -B verify
```

### İçerik (yerel)
```bash
python3 tools/dev-content-server/serve.py                  # bölüm paketleri, 127.0.0.1:8787
tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_package.py icerik/A1-*           # bölüm paketlerini üret
tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_package.py --season 1            # yalnızca sezon paketi
tools/content-pipeline/.venv/bin/python tools/content-pipeline/content_lint.py icerik/A1-0*             # content-lint
tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline                               # boru hattı testleri
```
Uygulama içeriği varsayılan olarak `http://127.0.0.1:8787` adresinden okur (`--dart-define=CONTENT_BASE_URL=...` ile değişir). Drift kodunu yeniden üretmek için: `cd mobile && fvm dart run build_runner build --force-jit`. Paket biçimi: `docs/BOLUM-PAKETI.md`.

### CI
`.github/workflows/ci.yml`: her push ve PR'da `flutter analyze` + `flutter test`, `mvn -B verify`, içerik pytest'i ve bölüm/kitap/dilbilgisi lint'leri çalışır. TTS testleri için runner'a `ffmpeg` kurulur.
