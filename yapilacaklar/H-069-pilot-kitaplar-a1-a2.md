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
