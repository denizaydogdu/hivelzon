# H-072: Kitap dalgası 2: B1 + B2 (10 kitap)

- **Durum:** Devam ediyor (2026-11-27: B1 5/5 ve B2 5/5 sesli; kalan yalnız öğretmen/editör kontrolü). Önceki durum (2026-10-30): 5 B1 + 5 B2 kitabının metni/çevirisi onaylı, 10'u da tam resimli ve lint 0 hata. Kalan: çalışan ElevenLabs erişimi veya ayrı onaylı ücretli planla ses; operasyonel editör kontrolü. **2026-10-30:** Sabahki ve akşamki (üçüncü) ücretsiz anahtar `401 detected_unusual_activity` verdi; çalışan ikinci anahtarın kotası A1/A2 öncelikli seslere gitti. B1–B2 kitap sesi üretilmedi. Engelli ücretsiz anahtarla yeniden denenmez. Onay tabloları gerçek duruma getirildi (`e7e7712`).
- **Tür:** İçerik üretimi
- **Faz:** Kitaplık K7 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-071

## Kapsam
- Aynı akışla 10 kitap.

## Kabul kriterleri
- 10 B1–B2 kitabı onaylı ve uygulamada.

## Test
`book-lint` + `flutter test`

## Geri alma
Kitap başına `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
2026-10-14 (kullanıcı kararları, pilot sonrası): Kitaplık ve pilot onaylandı. Uzun basma: sesli modda kelime → Defter'e ekle, sessiz modda cümle → yalnız o cümleyi seslendir. Kalan 28 kitabın resim yoğunluğu: **kapak + bölüm başı** (~180 görsel ≈ 90 kr; Higgsfield kredi yüklemesi gerekir, her dalgadan önce maliyet onayı). Ses: **ElevenLabs Creator (~22 USD/ay, ~100 bin karakter, ticari)**; hesabı kullanıcı açar, anahtar repo dışında; A2-K03 sesi ve pilot A1 sesi bu hesapla (ticari) yeniden üretilir.
2026-10-14: B2 metinleri yazıldı ve birleştirildi (5.006–5.300 kelime, kapsama %99+, B2 yapıları doğal biçimde). Bilinen araç sınırları: aksanlı özel adlar (Lucía, Tomás) çeviri denetiminde özel ad sayılmıyor; "A. Serra" gibi baş harfler cümleyi bölüyor (C1/C2 öncesi düzeltilecek).
- **2026-11-26:** ElevenLabs **Creator** planıyla (eleven_v3, ses Sarah) B1'in beş kitabı seslendirildi: K01 17.106, K02 16.634, K03 16.105, K04 17.510, K05 16.182 karakter. **B1 5/5 sesli.** `export_book` 0 hatayla çıktı; book_lint 30 kitap 0 hata/166 uyarı. B2 kitapları (≈ 139.884 karakter) sesiz; ölçülen maliyetle (≈ 0,45 kredi/karakter) ≈ 63.000 kredi, bu ayın kalan ~70.900 kredisine sığar. B2 sesi için karar kullanıcıda (H-087 odağı A1–A2; önceki öneri: H-092 pilotundan sonra). Kalan: B2 sesi ve öğretmen/editör kontrolü.
- **2026-11-27:** Kullanıcı "kredimiz varken devam edelim" dedi; Creator planıyla (eleven_v3, Sarah) B2'nin beş kitabı seslendirildi: K01 28.382 (c1 4.626 dahil), K02 28.393, K03 27.799, K04 29.014, K05 26.194 karakter (toplam 139.782). **B2 5/5 sesli; B1 + B2 10/10.** B2-K01 c2'de 4 kesik ama ücretlenen yanıt oldu → H-119 (parça sınırı 1500 sonrası 110 çağrı, 0 kesik). Paket/lint doğrulaması ana oturumda yeniden koşuluyor. Kalan: öğretmen/editör kontrolü; kabul ölçütü bu yüzden açık, iş burada kalır. Commit yok, onay bekliyor.
