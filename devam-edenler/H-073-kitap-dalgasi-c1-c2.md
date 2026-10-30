# H-073: Kitap dalgası 3: C1 + C2 (10 kitap)

- **Durum:** Devam ediyor (2026-10-30): 10 kitap metni/çevirisi onaylı, 80 görsel üretildi (40 kr), hepsi tam resimli ve lint 0 hata. Kalan: çalışan ElevenLabs erişimi veya ayrı onaylı ücretli planla ses; operasyonel editör kontrolü. **2026-10-30:** Sabahki ve üçüncü ücretsiz anahtar `401 detected_unusual_activity` verdi; çalışan ikinci anahtarın kotası A1/A2 öncelikli seslere gitti. C1–C2 sesi üretilmedi. Engelli ücretsiz anahtarla yeniden denenmez. Onay tabloları güncellendi (`e7e7712`). C1/C2 kapsama kodu hazır; Octanove listesi (`tools/content-pipeline/data/lexicon_ccbysa/`) depoda yok, eklemek kullanıcı onayı bekliyor.
- **Tür:** İçerik üretimi
- **Faz:** Kitaplık K8 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-072

## Kapsam
- Aynı akışla 10 kitap.
- C1/C2 kelime listesi Octanove'dan (ayrı veri seti).

## Kabul kriterleri
- 10 C1–C2 kitabı onaylı ve uygulamada.

## Test
`book-lint` + `flutter test`

## Geri alma
Kitap başına `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
2026-10-14 (kullanıcı kararları, pilot sonrası): Kitaplık ve pilot onaylandı. Uzun basma: sesli modda kelime → Defter'e ekle, sessiz modda cümle → yalnız o cümleyi seslendir. Kalan 28 kitabın resim yoğunluğu: **kapak + bölüm başı** (~180 görsel ≈ 90 kr; Higgsfield kredi yüklemesi gerekir, her dalgadan önce maliyet onayı). Ses: **ElevenLabs Creator (~22 USD/ay, ~100 bin karakter, ticari)**; hesabı kullanıcı açar, anahtar repo dışında; A2-K03 sesi ve pilot A1 sesi bu hesapla (ticari) yeniden üretilir.
2026-10-14: Boru hattı düzeltildi (`hvpipeline/sentsplit.py`): aksanlı özel adlar (Lucía, Tomás, Zoë, Şebnem, Çağrı, Ömer, Ayşe) tek ad sayılıyor; Mr./Dr./St./e.g./i.e., No. 3, ondalık sayı ve baş harf (*A. Serra*: ad `properNouns`'ta ise, unvandan sonra ya da J. R. gibi) cümleyi bölmüyor. B2-K01'de "a" anlamları eklendi (eskiden Lucía → "luc" + "a" yüzünden "a" özel ad sayılıyordu). 10 C1/C2 kitabının metni, Türkçe çeviri taslağı (DRAFT), sözlüğü ve görsel planı yazıldı; book-lint 0 hata (Octanove C1/C2 listesi depoda yok: kapsama denetlenmedi). Kullanıcı onayı, görseller (C1 38 + C2 42 = 80 ≈ 40 kr; maliyet onayı) ve ses bekleniyor.
