# H-046: Altyazıya dokun → Türkçe anlam (kademeli panel)

- **Durum:** Yapılacak (H-031'den hemen sonra; kullanıcı kararı 2026-10-11)
- **Tür:** Uygulama + içerik (çeviri)
- **Faz:** 1.2b (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-031

## Kullanıcı kararları (2026-10-11, soru-cevap)
- **Etkileşim: kademeli panel.** Altyazı satırına dokununca video durur, alttan panel açılır:
  - kelimeler büyük, dokunulabilir kutucuklar; dokununca bağlama uygun Türkçe anlam + kelimenin sesi (zaman damgasıyla videodan kesilir, ek üretim yok);
  - kalıp ifadeler tek parça açıklanır (*How much is it?* = "Ne kadar?");
  - "Türkçesini göster" ikinci adım: cümlenin tamamı;
  - "Tekrar dinle" (0,75x seçeneğiyle) ve "Deftere ekle" (FSRS adayı).
  - Panel kapanınca video kaldığı yerden sürer. Satıra dokununca tekrar dinleme (H-031) bu panele taşınır.
- **Karar kartı seçenekleri çevrilmez;** destek Hi ipuçlarıyla verilir. Karşı karakterin altyazısı yine dokunulabilir.
- **Çeviriyi Claude taslak olarak yazar, kullanıcı onaylar** (H-028). Kredisiz.

## Kapsam
- Veri: bölüm başına `icerik/<id>/ceviri.tr.json` (satır → `tr`, kalıplar `chunks`, bağlama göre kelime anlamları `words`) ve `story.tr.md`.
- Boru hattı: `subs/*.en.json` içindeki `tr` ve kelime/kalıp anlamları doldurulur; şema güncellenir.
- content-lint: her satırın `tr`'si ve her kelimenin (özel isim hariç) anlamı var mı; eşleşmeyen satır hatası.
- Uygulama: panel bileşeni (Keşfet'teki "Anlam" düğmesi de aynı bileşeni kullanır); EN+TR altyazı modu açılır.
- Olay kaydı: hangi kelime/satıra bakıldı (`learning_events`); bakmak puan düşürmez, uyarı yok (K-32).

## Kabul kriterleri
- B1–B4'ün tüm altyazı satırlarında onaylı Türkçe ve kelime anlamı var; content-lint temiz.
- Simülatörde: dokun → video durur → kelime anlamı ve sesi → Türkçesini göster → kapat → video kaldığı yerden sürer.
- Widget testleri yeşil.

## Notlar
2026-10-11: Kullanıcı önerdi: "hikâyelerdeki yazıların üstüne basınca Türkçe anlamları çıkabilir." Soru-cevapla yukarıdaki kararlar alındı.
