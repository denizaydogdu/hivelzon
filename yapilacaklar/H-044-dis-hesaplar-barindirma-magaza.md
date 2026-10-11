# H-044: Dış hesaplar, barındırma ve mağaza (en son)

- **Durum:** Yapılacak (en son; kullanıcı kararı 2026-10-11)
- **Tür:** Uygulama + kullanıcı kararları
- **Faz:** 1.12 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-043

## Kapsam
- **Sunucu yeri** (kullanıcıya sorulur): backend ve PostgreSQL kurulumu, yedekleme, TLS.
- **Bunny Stream:** hesap (kullanıcı açar), `VideoHostingPort` için Bunny adaptörü, B1–B4 yüklemesi.
- **Apple ve Google geliştirici hesapları** (kullanıcı açar): imzalama, TestFlight ve Google Play dahili test.
- Ticari ElevenLabs (H-006) çözülmeden mağazaya çıkılmaz; free plan seslerle yayın yok.
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
