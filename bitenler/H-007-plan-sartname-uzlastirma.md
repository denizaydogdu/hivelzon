# H-007: Plan ile şartname arasındaki çelişkileri uzlaştır

- **Durum:** Bitti — karar verildi (2026-10-11)
- **Tür:** Karar
- **Öncelik:** Yüksek
- **Bağımlılık:** H-001 ile birlikte karara bağlanır

## Soru
`IS-PLANI.md` ile `SARTNAME.md` şu konularda çelişiyor; hangisi esas alınacak?
1. **Konuşma pratiği MVP'de mi?** Plan: v1'de (Faz 2). Şartname: P0/MVP (§5.1), ama yol haritasında Faz 4.
2. **Faz yapısı:** Plan Faz 0–3, şartname Faz 0–5.
3. **Seviye testi:** Plan zorunlu uyarlamalı 15–25 soru; şartname isteğe bağlı, kısa, atlanabilir.
4. **Günlük hedef ve seri:** ayrıntı H-013.
5. **Telaffuz puanı:** ayrıntı H-015.

## Plan önerisi
Konuşma pratiği MVP dışında kalsın (plan sırası): kota, bütçe tavanı ve ses rızası hazır olmadan ücretsiz AI çağrısı açılmasın. Faz yapısı için şartnamenin ayrıntılı teslimatları, planın 4 fazına eşlensin. Seviye testi isteğe bağlı ve atlanabilir olsun; sonuç "önerilen başlangıç seviyesi" diye adlandırılsın. Karar verilince H-023 ile plan güncellenir.

## Kaynak
CLAUDE.md "Plan ile şartname arasındaki açık çelişkiler" · `SARTNAME.md` §4.2, §5.1, §16 · `IS-PLANI.md` §4.5, §11

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11: **Madde 3 (seviye testi) çözüldü** (K-06): kademeli, en fazla ~20 soru, atlanabilir; sonuç "önerilen başlangıç seviyesi" olarak sunulur. **Madde 4 (seri)** H-013'te K-16 ile çözüldü. **Hâlâ açık:** konuşma pratiğinin MVP'deki yeri, faz yapısı (K-17; plan 4 / şartname 6 / strateji 8 faz) ve telaffuz puanı (H-015).
2026-10-11: Oyun çerçevesinde konuşma pratiği, karakterle **canlı sahne** ve "Hi ile pratik" olur (`OYUN-TASARIMI.md` §8.1). Bölüm görevlerinde konuşma **hiçbir zaman zorunlu değildir**; seçmeli ya da yazılı alternatifi vardır.
2026-10-11: **Konuşma pratiği MVP'de yok** (kullanıcı kararı). MVP: hikâye, görev, defter, kısa akış. Konuşma pratiği v1'de gelir; kota, bütçe ve ses rızası hazır olunca. Hikâyedeki "Söyle" adımı isteğe bağlıdır ve puan vermez. **Açık kalan:** faz yapısı (K-17).

## Karar (2026-10-11)
Plan ile şartname arasındaki çelişkiler kapandı:
- **Konuşma pratiği MVP'de yok,** v1'de gelir (kullanıcı, soru-cevap).
- **Faz yapısı (K-17): birleşik 4 faz** (kullanıcı, soru-cevap):

  | Faz | Kapsam |
  |---|---|
  | **F0** | Kararlar + pilot bölüm |
  | **F1 MVP** | Hikâye modu, Sezon 1 (A1), harita, defter, ipucu panosu, kısa akış, editör onayı |
  | **F2 v1** | AI konuşma pratiği, Sezon 2 (A2) |
  | **F3 v2** | Sezon 3 ve sonrası, çevrimdışı, gelişmiş seviye modeli (Elo, Rasch) |

- **Seviye testi:** K-06.
- **Seri:** K-16.
- **Günlük hedef:** H-013.
- **Telaffuz puanı:** H-015'te ayrıca.
