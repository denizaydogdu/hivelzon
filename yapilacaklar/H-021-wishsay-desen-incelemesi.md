# H-021: WishSay desenlerinin incelemesi

- **Durum:** Yapılacak
- **Tür:** Araştırma (kodsuz)
- **Öncelik:** Yüksek
- **Bağımlılık:** —

## Amaç
Kimlik doğrulama, onay kayıtları, denetim kaydı ve 30 gün geri alınabilir hesap silme desenlerinin WishSay'de hangi dosyalarda olduğunu bulmak ve HiVelzon'a uyumunu değerlendirmek.

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
