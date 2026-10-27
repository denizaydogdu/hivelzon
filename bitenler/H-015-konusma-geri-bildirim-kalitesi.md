# H-015: Konuşma geri bildirimi ve telaffuz puanının güvenilirliği

- **Durum:** Bitti (2026-10-27)
- **Tür:** Karar
- **Öncelik:** Orta
- **Bağımlılık:** H-006, H-007

## Soru
Konuşma ve telaffuz puanları nasıl doğrulanacak? Kullanıcıya hangi ölçütler gösterilecek? Plan v1'de telaffuz puanı öngörüyor; şartname ise yalnızca güvenilir biçimde ölçülebiliyorsa gösterilmesini istiyor.

## Plan önerisi
Doğrulama yapılana kadar sayısal puan gösterilmesin; geri bildirim nitel olsun (en fazla 1–3 gelişim noktası). Telaffuz puanı, Türk aksanlı küçük bir örnek setinde insan değerlendirmesiyle karşılaştırılıp uyum yeterliyse açılsın.

## Kaynak
`IS-PLANI.md` §11 · `SARTNAME.md` §3.3/6, §6.5, §18/11

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11 (`ICERIK-MIMARISI.md` §7.5): Azure telaffuz değerlendirmesinin insan puanlarıyla korelasyonu yalnızca ">0,5" olarak veriliyor. İnsan puanlayıcıların kendi aralarındaki tutarlılık 0,76–0,87. Puan, yalnızca kendi Türk L1 örneklemimizde doğrulandıktan sonra gösterilsin ve sayı yerine bant olarak verilsin.
2026-10-13: Konuşma alıştırması fazlandı (`docs/KONUSMA-ALISTIRMASI.md`): S1 (MVP, H-055) yalnızca 'beklenen ifade söylendi mi' kontrolü, puan yok. Telaffuz geri bildirimi S3 olarak bu işte; yalnız doğrulanırsa.
2026-10-27: **Kullanıcı kararı (ajana devir):** S1 ve S2'de sayısal telaffuz puanı yok. S3 yalnız Türk L1 örnekleminde insan değerlendirmesiyle doğrulandıktan sonra; doğrulanırsa yüzde değil, en fazla 1–3 nitel gelişim noktası. Doğrulanmazsa hiç gösterilmez. Azure/bulut telaffuz puanı şimdi açılmaz. Ayrıntı: `docs/KARARLAR-2026-10-27.md`.
