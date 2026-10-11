# H-031: Etkileşimli bölüm oynatıcısı prototipi

- **Durum:** Yapılacak (kod onayından sonra)
- **Tür:** Teknik prototip (kod)
- **Öncelik:** Yüksek (MVP'nin en riskli teknik parçası)
- **Faz:** 1.2 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-025 onayı, H-033, H-034

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
- zaman damgalı JSON altyazı (ElevenLabs hizalaması), dokun-çevir, bellek ve ısı ölçümü.
- **Ücretli üretim yok:** yer tutucu yerine üretilmiş B1–B4 paketleri (H-034) kullanılır.
- MVP kapsamı: Hi'nin kademeli ipucu, altyazı modu (EN, EN+TR, kapalı), 0,75 hız, cümle tekrarı, bölüm sonu ekranı.

## Kabul kriterleri
- Segment geçişinde siyah kare yok; geçiş ≤ 150 ms.
- Ses–yazı farkı ≤ 0,2 sn.
- B1–B4 telefonda baştan sona oynanıyor.
- Düşük uçlu bir Android cihazda bellek sınırı aşılmıyor.
- Uygulama kapatılıp açılınca son kontrol noktasından devam ediliyor.
- Ölçüm sonuçları rapor olarak yazılmış.

## Kaynak
`docs/OYUN-TASARIMI.md` §11.4, §14, §19.1 (teknik)

## Notlar
2026-10-11: Kullanıcı ana deneyimin oyunlaştırılmış, bölümleri birbirine bağlı bir hikâye olmasına karar verdi. Kaynak: `docs/OYUN-TASARIMI.md`, `docs/HIKAYE-EVRENI.md`.
2026-10-11: H-025 planında Faz 1.2 oldu; numara korundu. Hedefler plana göre kesinleşti.
