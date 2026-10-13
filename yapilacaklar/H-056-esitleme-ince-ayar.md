# H-056: Eşitleme ince ayarı (H-038 sonrası)

- **Durum:** Yapılacak (sırada)
- **Tür:** Uygulama + backend
- **Bağımlılık:** H-038

## Kullanıcı kararları (2026-10-13)
- **"Bitti" her zaman kazanır:** bitmiş bölüm hiçbir eşitlemeyle "devam ediyor"a dönmez (sunucu ve telefon; kapı öğeleri de yalnızca eklenir).
- **Yenileme anahtarına 30 sn hoşgörü:** aynı eski yenileme anahtarı 30 sn içinde tekrar gelirse aynı yeni anahtar döner; çalıntı koruması 30 sn sonrası için aynen.
- **Çıkışlıyken "Hi'nin kayıtlarını sil":** silme isteği telefonda bekler; aynı hesapla yeniden girişte sunucuya ve diğer cihazlara işlenir.
- **Sekme yenileme hatası:** başka cihazdan veri gelince bütün sekmeler güvenle yenilenir (Riverpod 3 "setState during build" sorunu; oynatıcıdan dönüşteki yenileme de denetlenir).

## Kabul kriterleri
- Her karar için test (mobil + backend); flutter test ve mvn verify yeşil.
