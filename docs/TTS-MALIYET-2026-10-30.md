# Eksik İngilizce sesler — ElevenLabs maliyet seçenekleri (2026-10-30)

> Amaç: H-071…H-073 (kitap) ve H-080…H-082 (dilbilgisi) İngilizce seslerinin
> ücretsiz katman engeli (`401 detected_unusual_activity`) sonrası nasıl
> üretileceğine **tek kararla** karar vermek. Bu belge harcama değildir; plan
> açmak ve ödeme kullanıcıdadır.

## İhtiyaç (kuru çalışma, `docs/HANDOFF-2026-10-30.md` §2.2)

| Grup | Karakter | Kümülatif |
|---|---:|---:|
| Dilbilgisi İngilizce örnekleri (A2 kalanı 2.991 dahil) | 21.544 | 21.544 |
| Kitap A1 (A1-K01 düzeltmesi dahil) | 4.378 | 25.922 |
| Kitap A2 | 33.193 | 59.115 |
| Kitap B1 | 83.583 | 142.698 |
| Kitap B2 | 139.954 | 282.652 |
| Kitap C1 | 229.787 | 512.439 |
| Kitap C2 | 283.072 | **795.113** |

- Boru hattı `eleven_v3` kullanıyor. Fiyat sayfası v3'ü Multilingual v2 ile aynı
  fiyatlıyor ($0,08 / 1K karakter); **1 karakter ≈ 1 kredi** varsayıldı.
- Yeniden üretim payı için ~%10 eklenmeli (≈ 875.000).
- A1–A2 odak kararı (H-087): ilk 59.115 karakter odak seviyeyi tamamen kapatır.

## Seçenekler (fiyatlar elevenlabs.io/pricing ve /pricing/api, 2026-10-30)

| Seçenek | Aylık | Kredi/ay | Neyi kapatır | Tahmini toplam |
|---|---:|---:|---|---:|
| **Creator, 1 ay** | $22 | 121.000 | Dilbilgisi + A1 + A2 tamamı, B1'in ~%74'ü | **$22** (yalnız odak seviye) |
| **Pro, 1 ay** | $99 | 600.000 | Dilbilgisi + A1…C1 (512K) + ~%10 pay; C2 kalır | $99 |
| Pro, 2 ay | $99 | 600.000 | Hepsi | $198 (fazla aşım ücreti ≈ $33 ile ~$132) |
| Scale, 1 ay | $299 | 1.800.000 | Hepsi, tek ayda | $299 |
| Creator, 7 ay | $22 | 121.000 | Hepsi, yavaş | ~$154 |
| API kullandıkça öde | — | — | Hepsi | ≈ $64 (795K × $0,08/1K) |

Notlar:
- Fiyat sayfasında Starter/Creator için kart ($1/$11 ilk ay indirimi) ile SSS
  ($6/$22) arasında tutarsızlık var; liste fiyatı $22 alındı. Yıllık ödemede
  ~%17 indirim (10 ay öde).
- Ticari lisans Starter ve üstü planlarda var. **UNCONFIRMED:** Kullandıkça öde
  için ticari lisans ve ücretsiz katman engelinin kalkıp kalkmadığı sayfada
  yazmıyor.
- **UNCONFIRMED:** Pro'da aşım fiyatı "~$0,17/ek dakika" (≈1K kredi) olarak
  gösteriliyor; kullanım bazlı faturanın açık olması gerekir.
- Engel ücretsiz katmana özgü; ücretli plana geçiş sonrası ilk denemede 5
  karakterlik test yapılır, 401 sürerse ElevenLabs desteğine yazılır.

## Öneri

1. **Şimdi: Creator, 1 ay ($22).** Odak seviye (A1–A2) sesleri eksiksiz biter,
   H-065 kararındaki Creator planıyla da uyumlu. Kalan kredi B1 kitaplarına.
2. **Pilot (H-092) sonrası:** İleri seviye kitaplar gerçekten kullanılıyorsa
   Pro 1 ay ($99) ile B1 kalanı + B2 + C1, sonra C2. Kullanılmıyorsa harcama yok.

Plan değişince anahtar panelden yenilenmeli (eski anahtar sohbette paylaşıldı)
ve yalnız `~/.config/hivelzon/elevenlabs.env` içine konmalı.

Kaynaklar: https://elevenlabs.io/pricing · https://elevenlabs.io/pricing/api
