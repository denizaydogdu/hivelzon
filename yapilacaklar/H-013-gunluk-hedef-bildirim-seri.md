# H-013: Günlük hedef, seri ve bildirim politikası

- **Durum:** Yapılacak (kullanıcı kararı)
- **Tür:** Karar
- **Öncelik:** Orta
- **Bağımlılık:** H-007

## Soru
Günlük hedef seçenekleri plan ile şartname arasında çelişiyor: plan 10/20/30 dk, şartname 5/10/15 dk. Seri (streak) dondurma ve kurtarma görevi olacak mı? Bildirim sıklığı ne olacak?

## Plan önerisi
Hedefler 5/10/15 dk olsun (A1 için düşük eşik). Seri kalsın ama dondurma ve yumuşak dil kullanılsın; kurtarma görevi ve suçlayıcı mesaj olmasın. Günde en fazla 1 bildirim gönderilsin, saati kullanıcı seçsin, bildirim izni sonradan istensin.

## Kaynak
`IS-PLANI.md` §4.7 · `SARTNAME.md` §4.2, §6.2, §14.3, §18/8

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11 (`ICERIK-MIMARISI.md` §6.2, K-16): Araştırma (Silverman & Barasch 2023) kırık seriyi vurgulamanın uygulamayı bırakmayı artırdığını gösteriyor. Öneri: kırık seri vurgulanmasın, dondurma ve onarma imkânı olsun. Seri yalnızca video izleyerek değil, "anlamlı etkinlik" ile korunsun.
