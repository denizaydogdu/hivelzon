# Test sunucusu — hivelzonapi.velzon.tr

> Kurulum: 2026-11-28. Kullanıcı kararıyla "her şey yerelde" kuralının istisnası olarak kuruldu. Gerçek kullanıcı, mağaza ve yayın yine en sonda, H-044'te.
> Sunucuyu `hostinger` Claude oturumu kurdu ve o yönetiyor. Bu belgede sır yok.

## Ne var
- **Adres:** `https://hivelzonapi.velzon.tr`.
  - Sertifika Let's Encrypt'ten. HTTP istekleri HTTPS'e yönlendirilir (308).
  - Cloudflare'de A kaydı var ve yalnız DNS olarak çalışır (gri bulut). AAAA kaydı yok.
- **Sunucu:** Hostinger VPS `179.67.206.101`, **Almanya** (Hostinger veri merkezi 25; H-006'ya uygun). Dokploy dışında ayrı bir docker compose projesi: `/opt/hivelzon/docker-compose.yml`.
  - Kod `/opt/hivelzon/src` altında. GitHub `main` klonu.
  - Backend Dockerfile'ı repo dışında durur: `/opt/hivelzon/docker/backend.Dockerfile` (maven → temurin 17 jre, uid 10001).
- **Servisler:**

  | Servis | Not |
  |---|---|
  | `postgres:17-alpine` | Yalnız iç ağda |
  | backend | Varsayılan (geliştirme) profil, geliştirme içe aktarması açık, 1 GB bellek; Traefik arkasında gerçek istemci IP'si |
  | içerik | `python:3.13-alpine` + `tools/dev-content-server/serve.py`, `nobody` kullanıcısıyla; içerik `/opt/hivelzon/content` (≈ 2,1 GB) |
  | Mailpit | Giriş kodu e-postaları; arayüzü yalnız sunucunun kendisinden (127.0.0.1:8027) açılır |

- **Dışarıya açık yollar:**
  - `/api/**` ve `/actuator/health`.
  - İçerik yolları: `/packages`, `/books`, `/grammar`, `/reels`.
  - `/`, `/admin` ve geri kalan `/actuator` yolları 404 döner.
- **Sırlar:** veritabanı parolası, `HIVELZON_JWT_SECRET` ve `HIVELZON_OTP_PEPPER`.
  - Sunucuda `/opt/hivelzon/secrets/hivelzon.env` dosyasında (izin 600).
  - Kopyası Obsidian'da `Hostinger/hiVelzon/Şifreler.md`.
  - Repoya hiçbir zaman yazılmaz.
- **Mailpit'e erişim:** önce tünel açılır: `ssh -L 8027:127.0.0.1:8027 root@179.67.206.101`. Sonra tarayıcıda `http://127.0.0.1:8027`.
- **Test editörü:** `editor@hivelzon.test`, rolü EDITOR. Giriş kodu Mailpit'e düşer.

## Katalog durumu (2026-11-28)

| Tür | Yayında |
|---|---|
| Bölümler | 12 |
| Kitaplar | 30 |
| Keşfet reelleri | 18 |

- Hepsi yayından önce lint'ten 0 hatayla geçti.
- Kullanıcı kararıyla ("yayınlasın onay", "onay herşey ok olsun") test editörü üç adımı uyguladı: SUBMIT → APPROVE → PUBLISH.
- A1-005…A1-012'nin `ceviri.tr.json` dosyaları aynı gün kullanıcı onayıyla APPROVED yapıldı.
- Öğretmen/editör incelemesi (H-028) bundan bağımsız olarak hâlâ açık.

## İçeriği güncelleme
1. Yerelde paketleri üret.
2. Lint raporlarını yaz:
   - `content_lint.py --write-reports icerik/A1-0*`
   - `book_lint.py --write-reports kitaplar/[ABC]*`
   - `reel_lint.py --write-reports reeller/[AB]*`
3. `hostinger` oturumundan iki şey iste:
   - rsync. Kapsam: `*/_build/package/**`, `*/_build/lint.json`, `content.json`, `ceviri.tr.json`, `icerik/_evren/_build/season/**`, `reeller/*/reel.json`.
   - Ardından içe aktarma: `POST /api/v1/admin/catalog/import`.
4. APPROVED olmuş bir sürüm donmuştur. Paketi değiştiyse `contentVersion` artırılmalıdır.
5. Yeni sürüm için kullanıcı onayıyla APPROVE ve PUBLISH yapılır.

## Uygulamayı bağlamak (simülatör)
```bash
B=https://hivelzonapi.velzon.tr
cd mobile && fvm flutter run -d <simülatör> \
  --dart-define=CONTENT_BASE_URL=$B --dart-define=API_BASE_URL=$B \
  --dart-define=REEL_CATALOG_URL=$B/api/v1/catalog/reels
```
Bu `--dart-define` değerleri verilmezse uygulama yerel sunuculara bağlanır (`127.0.0.1:8787` / `:8080`).
