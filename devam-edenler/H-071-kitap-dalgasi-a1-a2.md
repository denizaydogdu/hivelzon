# H-071: Kitap dalgası 1: A1 + A2 (kalan 8 kitap)

- **Durum:** Devam ediyor (2026-10-28): 10 A1–A2 kitabı onaylı ve tam resimli; 5/10 sesli. Kalan A1-K02, A2-K01, A2-K02, A2-K04, A2-K05 ve A1-K01 düzeltme sesi çalışan ElevenLabs erişimi/ayrı onaylı ücretli plan; operasyonel editör kontrolü. 2026-10-27'de 401 veren ücretsiz anahtar tekrar kullanılmaz.
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
