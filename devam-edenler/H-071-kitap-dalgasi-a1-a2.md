# H-071: Kitap dalgası 1: A1 + A2 (kalan 8 kitap)

- **Durum:** Devam ediyor (2026-10-30): 10 A1–A2 kitabı onaylı ve tam resimli; **6/10 sesli** (A1-K01…K05, A2-K03; A1-K01 c3 "Her heart beats fast." düzeltmesiyle). Kalan A2-K01, A2-K02, A2-K04, A2-K05 sesi ve A1-K01 "floor four" → "the fourth floor" düzeltmesi (ses yeniden üretilirken birlikte; ~2.659 karakter) çalışan ElevenLabs erişimi/ayrı onaylı ücretli plan; operasyonel editör kontrolü. 401 veren ücretsiz anahtarlar tekrar kullanılmaz.
- **2026-10-30 TTS kontrolü:** Yeni anahtarın ücretsiz aboneliğinde 10.000 kredi görünse de A2 ders partisi, 105 karakterlik kart ve doğrudan 5 karakterlik deneme dahil üç üretim çağrısı `401 detected_unusual_activity` ile durdu. Kitap sesi üretilmedi ve kredi harcanmadı; çalışan, uygun hesap/plan olmadan tekrar deneme yapılmaz. A1-K01 kaynak metnindeki önceki düzeltme henüz sese yansıtılmadı.
- **Tür:** İçerik üretimi
- **Faz:** Kitaplık K6 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-069

## Kapsam
- Pilottaki akışla 8 kitap: yazım → lint → çeviri → onay → görsel (maliyet onayı) → ses → paket.

## Kabul kriterleri
- 10 A1–A2 kitabı onaylı ve uygulamada.

## Test
`book-lint` + `flutter test`

## Geri alma
Kitap başına `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
2026-10-14 (kullanıcı kararları, pilot sonrası): Kitaplık ve pilot onaylandı. Uzun basma: sesli modda kelime → Defter'e ekle, sessiz modda cümle → yalnız o cümleyi seslendir. Kalan 28 kitabın resim yoğunluğu: **kapak + bölüm başı** (~180 görsel ≈ 90 kr; Higgsfield kredi yüklemesi gerekir, her dalgadan önce maliyet onayı). Ses: **ElevenLabs Creator (~22 USD/ay, ~100 bin karakter, ticari)**; hesabı kullanıcı açar, anahtar repo dışında; A2-K03 sesi ve pilot A1 sesi bu hesapla (ticari) yeniden üretilir.
2026-10-14 (metinler, dal `h-071-kitap-dalgasi-1-metinler`): Kalan 8 kitabın metni, çevirisi (DRAFT), sözlüğü, haklar belgesi ve görsel planı yazıldı: A1-K02…K05, A2-K01, A2-K02, A2-K04, A2-K05. Görsel planı kullanıcı kararına göre **kapak + bölüm başı**: `book.json`'da yalnız bölümün ilk sayfasında `image`, diğer sayfalar `null` (şema ve dışa aktarma bunu zaten destekliyordu; değişiklik gerekmedi). İstemler `PROMPTS.md` → "Görsel planı (üretilmedi)"; her kitapta sürpriz kontrolü. Görsel ve ses üretilmedi (ücretli; maliyet onayı bekliyor). Sıradaki: kullanıcı metin/çeviri onayı (H-028) → görsel maliyet onayı → ses (ElevenLabs Creator).
2026-10-21 (dil incelemesi): A1-K01 'The Blue Door' — "Her heart is fast." → "Her heart beats fast."; "live on floor four" / "on floor four" → "on the fourth floor" (metin 2 cümle + anlama sorusu seçeneği). Kitap seslendirilmiş olduğu için düzeltme bir sonraki ElevenLabs anahtarıyla sesle birlikte yapılacak.
2026-10-30: Yeni ücretsiz ElevenLabs anahtarıyla A1-K01 "Her heart is fast." → "Her heart beats fast." metne (text.en.md, ceviri.tr.json, sözlüğe "beats") işlendi ve c3 sesi yeniden üretildi (1.224 karakter). A1-K02 sesi üretildi (c1–c3, 4.378 karakter). A1 5/5 kitap sesli, book_lint 30/0 hata. **"floor four" → "on the fourth floor" uygulanmadı:** p01 cümlesi "Lina and her mum live on the fourth floor." 9 sözcük olup A1 sınırını (≤ 8, `sentence-length` HATA) aşıyor; ayrıca "fourth" A1 listesi dışı (kapsama %97,9). Karar sahibi yeni biçimi seçmeli (ör. "Lina and Mum live on the fourth floor." ya da cümleyi bölmek); sonra c1+c2 (~2.659 karakter) yeniden seslendirilir. G-A1-11 "Hikâyede gör" ve MUFREDAT bu cümleyi alıntılıyor.
2026-10-30 (akşam): "fourth floor" düzeltmesi bilinçli olarak ertelendi: metin değişince c1/c2 sesinin hizası bozulup book_lint HATA veriyor; bu yüzden metin ve c1+c2 sesi birlikte yapılacak. Önerilen cümle "Lina and Mum live on the fourth floor." (8 sözcük); `fourth` sözlüğe eklenmeli. Kitap onay tabloları gerçek duruma getirildi (`e7e7712`). Üçüncü ElevenLabs anahtarı da 401 verdi; A2 kitap sesi üretilmedi.
