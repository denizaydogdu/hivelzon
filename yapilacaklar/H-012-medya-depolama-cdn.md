# H-012: Medya depolama ve CDN

- **Durum:** Yapılacak (kullanıcı kararı)
- **Tür:** Karar
- **Öncelik:** Orta
- **Bağımlılık:** H-021

## Soru
Video, ses ve görseller nerede saklanacak? Velzon'un mevcut altyapısı kullanılabilir mi? Maliyet, erişim (süreli imzalı URL) ve saklama süresi şartları ne olacak?

## Plan önerisi
Medya nesne depolamada tutulsun ve CDN üzerinden sunulsun; PostgreSQL'de blob tutulmasın. Önce Velzon'un mevcut altyapısı ve WishSay'in kullandığı çözüm incelensin, aylık maliyet 1k/10k MAU için hesaplansın.

## Kaynak
`IS-PLANI.md` §8.1 · `SARTNAME.md` §9.2, §11.1, §18/7

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11 (`ICERIK-MIMARISI.md` §9.5): Araştırmanın önerisi Bunny Stream; kaba maliyet 10 bin MAU'da ayda yaklaşık 17–35 USD. `VideoHostingPort` adaptörüyle kullanılır, böylece R2'ye geçiş kolay olur. CDN kullanıcı IP'lerini işlediği için KVKK yurt dışı aktarım bildirimi gerekir.
