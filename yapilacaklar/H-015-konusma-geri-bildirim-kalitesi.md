# H-015: Konuşma geri bildirimi ve telaffuz puanının güvenilirliği

- **Durum:** Yapılacak (kullanıcı kararı)
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
