# H-041: Editör onay ekranı ve içerik içe aktarma

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
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
