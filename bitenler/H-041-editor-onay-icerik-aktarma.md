# H-041: Editör onay ekranı ve içerik içe aktarma

- **Durum:** Bitti (2026-10-14; `main`'de; daha sonra H-094 reelleri de aynı onay akışına eklendi)
- **Tür:** Uygulama (kod)
- **Faz:** 1.9 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- `content-lint` → içe aktarma → Onayla / Zamanla / Kaldır.
- İçerik sürümleri, `publish_at` (K-05, K-12).
- Medya: `VideoHostingPort` arkasında **yerel adaptör**. Bunny Stream adaptörü H-044'te (kullanıcı kararı: dış hesaplar en sona).

## Kabul kriterleri
- Onaysız içerik katalogda görünmüyor (backend testi).
- Zamanlanmış içerik zamanı gelince görünüyor (test).

## Test
```bash
cd backend && mvn verify
```

## Geri alma
Kendi dalında (`h-041-editor-onay-icerik-aktarma`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Yerel adaptörün bugünkü karşılığı `tools/dev-content-server/serve.py` (127.0.0.1:8787; bölüm paketleri ve `/packages/_season/S1/`). Bu işte backend'deki `VideoHostingPort` için yerel dosya sistemi adaptörü yazılır; mobil `CONTENT_BASE_URL` ile ona yönelir. Bunny Stream adaptörü H-044'te. İçe aktarılan paket biçimi: `docs/BOLUM-PAKETI.md` (schemaVersion 2).
2026-10-13 (H-037'den): Kullanıcı kararı: onay durumu **veritabanında** tutulur; yeniden içe aktarma onaylanmış durumu bozmaz; onay geçmişi denetim kaydında. İçe aktarma şu an `humanReviewed` + çeviri APPROVED değilse DRAFT yazıyor.

2026-10-14 — **Bitti, doğrulandı.** Ayrıntı `backend/README.md` ("Editör onayı").
- **Durum veritabanında:** içe aktarma `status`/`publish_at`'e dokunmaz, `content.json` durumu yok sayılır. Yeni sürüm lint 0 hata → `IN_REVIEW`, değilse `DRAFT`. Onaylanmış sürüm donmuş: paket değişirse `SKIPPED` ("contentVersion artırılmalı"); onaylanan manifest özeti veritabanı kısıtıyla korunur. V7 (`V7__editorial_status.sql`): lint özeti, çeviri durumu, onay kaydı (kim/ne zaman/kontrol listesi + SHA-256/manifest), kaldırma gerekçe kodu, `lock_version`, kısıtlar, denetim geçmişi indeksi. H-037'nin kanıtla yazdığı onaylı satırlar `IN_REVIEW`'e döner (yerel geliştirme veritabanının kopyasında denendi: A1-001/A1-002 `PUBLISHED` → `IN_REVIEW`).
- **Lint:** `content_lint.py --write-reports` → `<bölüm>/_build/lint.json` (yeni; pytest 112 geçti, 9 atlandı). Sunucu Python çalıştırmaz; paketten eski rapor yok sayılır.
- **Geçişler:** SUBMIT, APPROVE (lint 0 + çeviri onaylı + 5 maddelik kontrol listesi: kanon, seviye, çeviri, medya, haklar/AI), SCHEDULE (Türkiye saatiyle girilir, UTC saklanır), PUBLISH, ARCHIVE, WITHDRAW (gerekçe kodu). Geçersiz → `409 INVALID_TRANSITION`; eksik koşul → `422 APPROVAL_REQUIREMENTS_NOT_MET` + `missing`; iyimser kilit → `409 CONCURRENT_MODIFICATION`. Her geçiş `audit_log`'a `CONTENT_*` (kişisel veri yok).
- **Ekran:** `/admin` (Türkçe, statik HTML+JS, e-posta koduyla giriş, yalnız EDITOR/ADMIN; CSP, `textContent`, çerez yok). Liste (sezon, durum etiketi, görünürlük, lint, yayın zamanı), ayrıntı (kontrol listesi + Onayla / İncelemeye gönder / Zamanla / Yayınla / Arşivle / Kaldır, geçmiş).
- **Testler:** `mvn -B verify` **121/121** (önce 110; yeni `EditorialTest` 11, `CatalogTest` 7 yeni kurala uyarlandı). Kabul kriterleri: onaysız içerik katalogda görünmüyor; zamanlanmış içerik 08:59:59'da yok, 09:00:00'da var (kontrollü saat); kaldırılan kayboluyor; yeniden içe aktarma durumu değiştirmiyor; yeni sürüm DRAFT iken yayımlanmış eski sürüm görünür kalıyor.
- **Gerçek deneme** (ayrı `hivelzon_h041` veritabanı, gerçek B1–B4 paketleri salt okunur, Mailpit kodu): 4 bölüm `IN_REVIEW` (lint 0 hata; B3/B4 1'er uyarı); eksik liste 422; B1 onay+yayın; B2 2026-10-20 10:00 Türkiye → `07:00:00Z` zamanlandı; B3 yayın denemesi 409; eski kilit 409; B4 onay+yayın+kaldır; yeniden içe aktarma 4 × UNCHANGED, durumlar korundu; katalogda yalnız A1-001; `/admin` 200 + CSP, `/admin` → 302, kimliksiz admin API 401. Çıktılar `.yerel/h041/`. Deneme veritabanı silindi.
- **Kapsam dışı / açık:** VideoHostingPort yerel adaptörü H-037'de vardı (değişmedi); içe aktarma prod'da hâlâ yok (prod içe aktarma yolu H-044 ile); öğretmen/editör toplu kontrolü (H-028) için ayrı rol yok.
