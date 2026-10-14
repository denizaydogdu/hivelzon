# H-086: Kitap okuyucuda "Sayfanın Türkçesi"

- **Durum:** Yapılacak
- **Tür:** Uygulama (mobil)
- **Faz:** Kitaplık (H-067 devamı)
- **Bağımlılık:** H-067

## Kapsam
Kullanıcı isteği (2026-10-14): "Kitap okurken sayfanın tamamının Türkçesini görmek isteyebilir."

- **"Sayfanın Türkçesi" düğmesi.** Okuyucunun üst çubuğunda ya da sayfa altında durur. Dokununca alttan panel açılır:
  - sayfanın onaylı Türkçesi cümle cümle görünür;
  - ses duraklar, panel kapanınca kaldığı yerden devam eder;
  - paneldeki bir cümleye dokununca İngilizce sayfada karşılığı vurgulanır ve oraya kaydırılır.
- **"Satır altı Türkçe" ayarı.** Okuma ayarlarındadır, varsayılan kapalı. Her İngilizce cümlenin altında küçük, soluk Türkçesi görünür.
- Veri `pages.json`'daki cümle `tr` alanıdır; yeni içerik gerekmez.
- Ekran okuyucu etiketleri. 1,3× yazıda taşma yok. "Hareketi azalt" desteklenir.

## Kabul kriterleri
- Panel doğru sayfanın Türkçesini sırasıyla gösterir.
- Ses duraklar ve devam eder.
- Cümle eşleşmesi vurgulanır.
- Satır altı ayarı kalıcıdır.
- Testler ve golden yeşil.

## Test
`cd mobile && flutter analyze && flutter test`

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı. Pedagojik not: çeviri yalnız okunup geçilmesin diye cümle eşleşmesi İngilizceye geri götürür; satır altı varsayılan kapalıdır (K-03 ile tutarlı).
