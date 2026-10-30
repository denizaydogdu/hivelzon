# H-072: Kitap dalgası 2: B1 + B2 (10 kitap)

- **Durum:** Devam ediyor (2026-10-30): 5 B1 + 5 B2 kitabının metni/çevirisi onaylı, 10'u da tam resimli ve lint 0 hata. Kalan: çalışan ElevenLabs erişimi veya ayrı onaylı ücretli planla ses; operasyonel editör kontrolü. **2026-10-30:** Sabahki ve akşamki (üçüncü) ücretsiz anahtar `401 detected_unusual_activity` verdi; çalışan ikinci anahtarın kotası A1/A2 öncelikli seslere gitti. B1–B2 kitap sesi üretilmedi. Engelli ücretsiz anahtarla yeniden denenmez. Onay tabloları gerçek duruma getirildi (`e7e7712`).
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
