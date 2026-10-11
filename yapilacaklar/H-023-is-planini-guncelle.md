# H-023: İş planını şartnameyle güncelle

- **Durum:** Yapılacak
- **Tür:** Belge
- **Öncelik:** Yüksek
- **Bağımlılık:** H-007, H-021, H-022

## Amaç
H-007 kararlarına göre `docs/IS-PLANI.md`'yi şartnameyle uyumlu hâle getirmek ve risk listesini genişletmek.

## Kapsam
- Çelişkili bölümler karara göre düzeltilir (faz yapısı, MVP kapsamı, seviye testi, hedef/seri).
- Risk listesi (§13.1) şu başlıklarla genişletilir: güvenlik, KVKK, çocuk kullanıcılar, AI maliyeti, içerik moderasyonu, medya saklama.
- Şartname §18 açık kararları H işlerine bağlanır.

## Kabul kriterleri
- Plan ile şartname arasında çözülmemiş çelişki kalmamış.
- CLAUDE.md'deki çelişki tablosu kaldırılmış ya da "çözüldü" olarak güncellenmiş.
- Kullanıcı güncel planı onaylamış (H-001).

## Kaynak
`SARTNAME.md` §16 Faz 0, §17/8–10

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11: İş planı ve şartname şunlara göre güncellenecek: oyunlaştırılmış hikâye yönü (`OYUN-TASARIMI.md`) ve SARTNAME §10 tutarsızlıkları (`DELETION_PENDING` / `PENDING_DELETION` ad uyumsuzluğu, eksik `refresh_tokens` ve roller).
