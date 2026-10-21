# H-044: Dış hesaplar, barındırma ve mağaza (en son)

- **Durum:** Yapılacak (en son; kullanıcı kararı 2026-10-11)
- **Tür:** Uygulama + kullanıcı kararları
- **Faz:** 1.12 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-043

## Kapsam
- **Sunucu yeri** (kullanıcıya sorulur): backend ve PostgreSQL kurulumu, yedekleme, TLS.
- **Bunny Stream:** hesap (kullanıcı açar), `VideoHostingPort` için Bunny adaptörü, B1–B4 yüklemesi.
- **Apple ve Google geliştirici hesapları** (kullanıcı açar): imzalama, TestFlight ve Google Play dahili test.
- **ElevenLabs:** H-006 kararı (2026-10-14) gereği ücretsiz hesapla üretilen sesler yayında kullanılabilir; yeniden üretim gerekmez. Ticari plan yalnız gelecekteki kotalar/koşullar değişirse değerlendirilir.
- KVKK: yurt dışı aktarım bildirimi (hukukçu teyidi).

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
