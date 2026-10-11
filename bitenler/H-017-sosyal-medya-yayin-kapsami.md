# H-017: Sosyal medya yayın kapsamı

- **Durum:** Bitti — karar verildi (2026-10-11)
- **Tür:** Karar
- **Öncelik:** Düşük
- **Bağımlılık:** —

## Soru
Bu ürün görevinde yalnızca uygulama içeriği mi hazırlanacak, yoksa sosyal medya yayını (Shorts/Reels/TikTok) ayrı ve onaylı bir faz mı olacak? hiVelzon hesapları açılacak mı?

## Plan önerisi
Sosyal medya yayını ayrı bir faz olsun. videoGenerator'da `channels/hivelzon-*.json` profili ve yayın işi, dışa dönük ve geri alınamaz olduğu için ayrıca onay gerektirir.

## Kaynak
CLAUDE.md "videoGenerator projesinden yararlanma" · `SARTNAME.md` §5.3, §18/14

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11 (`ICERIK-MIMARISI.md` §10): YouTube ve TikTok API'leri denetimden önce yalnızca private yayın yapabiliyor. YouTube'da `madeForKids` beyanı zorunlu. Öneri: önce elle yükleme. Universal Links için `hi.velzon.tr` erken açılmalı.
2026-10-11: **Yöntem kararı verildi** (K-14): önce elle yükleme; API otomasyonu platform denetiminden sonra; AI etiketi her zaman konur. **Hâlâ açık:** sosyal medya yayınının ayrı ve onaylı bir faz olup olmayacağı; hiVelzon hesaplarının açılıp açılmayacağı.

## Karar (2026-10-11)
**Sosyal medya ayrı ve onaylı bir faz** (kullanıcı, soru-cevap).
- hiVelzon hesapları MVP lansmanına yakın açılır.
- Klipler **elle** yüklenir; her yayın ayrıca onaylanır.
- AI etiketi her zaman konur.
- API otomasyonu (videoGenerator yayıncıları) platform denetiminden sonra kurulur (K-14).
