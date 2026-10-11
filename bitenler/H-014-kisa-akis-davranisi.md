# H-014: Kısa video akışının davranışı

- **Durum:** Bitti — karar verildi (2026-10-11)
- **Tür:** Karar
- **Öncelik:** Orta
- **Bağımlılık:** —

## Soru
Akışta otomatik oynatma ve sessiz başlama varsayılan olacak mı? İçerik nasıl sıralanacak? Kullanıcı hangi tercihleri yapabilecek?

## Plan önerisi
Akış otomatik oynasın ama sessiz başlasın; mobil veride düşük kalite varsayılan olsun. Sıralama seviye ve ilgiye göre kural tabanlı yapılsın. "İlgilenmiyorum" ve "bu seviyeden daha fazla" eylemleri olsun. Sonsuz kaydırma yerine oturum sonu özeti gösterilsin.

## Kaynak
`IS-PLANI.md` §4.4 · `SARTNAME.md` §6.4, §14.3, §18/9

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11 (`ICERIK-MIMARISI.md` §6.5, K-15): Öneri: her 4–5 klipte bir quiz kartı, yaklaşık 10 klipte bir mola kartı. 13–17 yaş için günlük akış sınırı varsayılan 20 dk. Beğeni sayısı ve yorum gösterilmesin.

## Karar (2026-10-11)
K-15 onaylandı: 4–5 klipte bir quiz kartı, ~10 klipte bir mola kartı, 13–17 yaş için günlük 20 dk varsayılan sınır, beğeni sayısı ve yorum yok.

Keşfet'e kullanıcı kendisi girdiğinde video sesli başlar; Ana Sayfa kartından geçişte ilk klip sessiz başlar. Sıralama seviyeye göre filtreli ve kural tabanlıdır. "Bu içeriği önerme" eylemi vardır. Ayrıntı: `ICERIK-MIMARISI.md` §6.5.
