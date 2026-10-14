# H-069: Pilot kitaplar (A1 + A2)

- **Durum:** Yapılacak
- **Tür:** İçerik üretimi
- **Faz:** Kitaplık K4 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-065, H-066, H-067

## Kapsam
- 2 kitap (kullanıcı seçimi 2026-10-14): **A1-K01 The Blue Door** ve **A2-K03 The Parrot Who Told Everything**. Metin → `book-lint` → Türkçe çeviri → kullanıcı onayı (H-028).
- Görseller: her sayfa resimli, yaklaşık 30 görsel ≈ 15 kr. **Önce `generate cost` ile maliyet gösterilir ve onay alınır.** Her istem `kitaplar/<id>/PROMPTS.md`'ye yazılır.
- Ses: ElevenLabs ücretsiz kota, yalnız iç kullanım. Yayından önce ticari planla yeniden üretilir (H-006).
- Paket üretilir ve simülatörde denenir.

## Kabul kriterleri
- Kullanıcı pilotu uygulamada dener.
- Kalan 28 kitabın resim yoğunluğuna ve ses planına karar verilir.

## Test
`content-lint` / `book-lint` + `flutter test`

## Geri alma
Kitap klasörleri ve paketler `git revert`; Higgsfield harcaması geri alınamaz (maliyet onayı bu yüzden önce).

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
2026-10-14: Metin taslakları yazıldı (dal `h-069-pilot-kitap-metinleri`): `kitaplar/A1-K01-the-blue-door/` (11 sayfa, 766 kelime, kapsama %98,3) ve `kitaplar/A2-K03-the-parrot-who-told-everything/` (14 sayfa, 1.440 kelime, kapsama %98,6). Çeviri DRAFT; book-lint 0 hata. Görsel planı (istemler) `PROMPTS.md`'de, **üretilmedi**; ses üretilmedi. Sıradaki adım: kullanıcı metin onayı (H-028), sonra görsel maliyet onayı. Araç düzeltmesi: `cefr.py` düzensiz geçmiş zaman ve karşılaştırma biçimlerini başsözcüğe indiriyor; sözlükteki öğretim notu listedeki sözcüğü liste dışına itmiyor (testli).
2026-10-14: **Anlatım temposu (dal `h-069-anlatim-temposu`).** A1-K01 sesi ElevenLabs 0.9 hızıyla 144–168 k/dk çıktı (hedef 100–110); yeniden üretim ücretli olduğu için çözüm dışa aktarmada, ücretsiz. `book.json → narration.pacing` (`auto`/`manual`/`off`; yoksa A1–B1 `auto`, B2+ `off`). Bölüm sesi cümle sınırlarından (en sessiz noktadan) kesilir, araya sessizlik eklenir (paragrafta ×1,25, sayfada ×1,5), gerekirse `atempo` (≥ 0,85); `pages.json` zamanları örnek düzeyinde yeniden hesaplanır; -16 LUFS son adım. book-lint `book-speed` tempo sonrası hızı denetler, ham hızı da yazar. Sonuç (auto, yalnız duraklama): c1 168 → 105,0 k/dk (1,17 sn), c2 144 → 105,1 (0,93 sn), c3 154 → 104,9 (1,01 sn); süreler 174,2 / 126,7 / 136,7 sn; -16,04 LUFS, gerçek tepe -5,38 dBTP, kırpılma yok; ikinci dışa aktarma bayt bayt aynı. Ayrıntı `docs/KITAPLIK.md` §6.5. Sıradaki: kullanıcı dinleyip duraklamayı ve cümle içi hızı değerlendirir (gerekirse `manual` tempo 0,9).
