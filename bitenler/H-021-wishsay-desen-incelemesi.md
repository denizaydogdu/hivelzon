# H-021: WishSay desenlerinin incelemesi

- **Durum:** Bitti (2026-10-11)
- **Tür:** Araştırma (kodsuz)
- **Öncelik:** Yüksek
- **Bağımlılık:** —

## Amaç
Kimlik doğrulama, onay kayıtları, denetim kaydı ve 30 gün geri alınabilir hesap silme desenlerinin WishSay'de hangi dosyalarda olduğunu bulmak ve hiVelzon'a uyumunu değerlendirmek.

## Kapsam
- `~/Dev/wishsay` yalnızca okunur, değiştirilmez.
- İncelenecek desenler: auth, `user_consents`, `audit_log`, `PENDING_DELETION` akışı, yönetici rolü, hukuki metinlerin taşınması, sırların yönetimi.
- WishSay'deki `ogrenilenler/` dersleri taranır.

## Kabul kriterleri
- Her desen için dosya yolu, kısa özet ve "aynen / uyarlanır / alınmaz" kararı yazılmış.
- Şartname §10 veri modeli taslağıyla farklar listelenmiş.
- Sonuç `docs/` altında bir rapor olarak kaydedilmiş.
- Kod veya migration yazılmamış.

## Kaynak
`SARTNAME.md` §16 Faz 0, §17/6 · `IS-PLANI.md` §9.4

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.

## Sonuç (2026-10-11)
Rapor: `docs/WISHSAY-DESEN-RAPORU.md`. 13 desen için "aynen / uyarlanır / alınmaz" kararı, veri modeli karşılaştırması, R-01…R-17 riskleri.

**Kabul kriterleri karşılandı:** Kod yazılmadı; WishSay'de hiçbir şey değiştirilmedi.

**Kullanıcı kararı (aynı gün):** "WishSay'i unut, yalnızca hiVelzon'a odaklan." Rapor yalnızca arşiv referansıdır. Kimlik doğrulama, rıza, denetim ve silme hiVelzon'un kendi tasarımıyla yapılır.

**hiVelzon'a doğrudan yarayan genel bulgular:**
- Girişte hız sınırı ve brute-force koruması baştan tasarlanmalı.
- Denetim kaydı, öğrenme olaylarını kapsamamalı; o veri `learning_events`'e gider.
- Partition'lı tabloda UNIQUE kısıtı partition anahtarını içermeli (ICERIK-MIMARISI §7.7'ye not düşüldü).
- SARTNAME §10'daki ad tutarsızlığı (`DELETION_PENDING` / `PENDING_DELETION`) ve eksik `refresh_tokens` / roller H-023'te düzeltilecek.
