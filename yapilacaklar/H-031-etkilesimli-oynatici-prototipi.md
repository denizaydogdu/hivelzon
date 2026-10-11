# H-031: Etkileşimli bölüm oynatıcısı prototipi

- **Durum:** Yapılacak (kod onayından sonra)
- **Tür:** Teknik prototip (kod)
- **Öncelik:** Yüksek (MVP'nin en riskli teknik parçası)
- **Bağımlılık:** H-025 (Faz 1 uygulama planı onayı)

## Amaç
Flutter'da dallanan videonun hazır bir paketi yok. Bu yüzden şunları erken ve düşük uçlu Android cihazda ölçmek:
- segment sıralama;
- karar katmanı (yerel arayüz);
- iki-üç denetleyiciyle ön ısıtma;
- kontrol noktasında durum saklama.

## Kapsam
- `scenes.json` grafiğinden bir bölümü oynatan prototip:
  - 3–4 segment;
  - 2 karar anı;
  - 1 tepki dalı.
- WebVTT altyazı, dokun-çevir, bellek ve ısı ölçümü.
- **Ücretli üretim yok:** yer tutucu medya kullanılır.

## Kabul kriterleri
- Segment geçişlerinde kesinti hedefin altında. Hedef değer H-025'te belirlenir.
- Düşük uçlu bir Android cihazda bellek sınırı aşılmıyor.
- Uygulama kapatılıp açılınca son kontrol noktasından devam ediliyor.
- Ölçüm sonuçları rapor olarak yazılmış.

## Kaynak
`docs/OYUN-TASARIMI.md` §11.4, §14, §19.1 (teknik)

## Notlar
2026-10-11: Kullanıcı ana deneyimin oyunlaştırılmış, bölümleri birbirine bağlı bir hikâye olmasına karar verdi. Kaynak: `docs/OYUN-TASARIMI.md`, `docs/HIKAYE-EVRENI.md`.
