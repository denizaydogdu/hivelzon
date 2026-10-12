# H-046: Altyazıya dokun → Türkçe anlam (kademeli panel)

- **Durum:** Devam ediyor
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
2026-10-11: Çeviri taslağı yazıldı (B1–B4). Kullanıcı kararları: hatalı cümlelerde doğru Türkçe + not; B4 "What time is it?" → "What time?" (yerel ElevenLabs ile yeniden seslendirme); onay uygulamada görerek.
2026-10-11 (uygulama ve doğrulama):
- **İçerik düzeltmesi (A1-004):** t-kanit repliği "I have Art on Friday. What time?" oldu (`story.en.md`, `kurgu.json`, `audio_manifest.json`, `ceviri.tr.json`). `b4_30_maya` yerel ElevenLabs ile yeniden seslendirildi: 1 çağrı, 32 karakter, ses Sarah (Maya), eleven_v3, speed 0.9; yeni süre 2,32 sn. Kayıt `PROMPTS.md`'de. Diğer "What time is it?" satırları değişmedi.
- **Boru hattı:** `hvpipeline/translation.py`; altyazıya `tr`, `words[].gloss`, `chunks[]` (startWord..endWord); kart satırı ve karar repliğine `tr/words/chunks`, görev köküne `stemTr/stemWords/stemChunks`. Seçenekler çevrilmez. Şemalar ve `docs/BOLUM-PAKETI.md` (§3, §3.1, lint tablosu) güncellendi.
- **content-lint `translation`:** B1 17/17 satır, 53/53 kelime; B2 37/37, 116/116; B3 16/16, 48/48; B4 34/34, 100/100 (özel adlar hariç). Hata 0; tek uyarı çevirinin DRAFT olması. A1-000 ve A1-005…012: "çeviri yok" uyarısı. Toplam: 13 bölüm, 0 hata, 20 uyarı.
- **pytest:** 53 geçti (7'si yeni çeviri testi + 4 gerçek bölüm).
- **Paketler yeniden üretildi (B1–B4):** senkron en büyük fark 0,003 / 0,01 / 0,007 / 0,01 sn (sınır 0,2); ölçülemeyen 0; ses-görüntü farkı ≤ 0,001 sn; ses -16,1 / -16,02 / -16,01 / -16,12 LUFS.
- **Uygulama:** `lib/shared/meaning/` (panel, denetleyici, defter ve öğrenme olayı arayüzleri; şimdilik shared_preferences). Altyazıya dokununca video durur, panel açılır; kelime anlamı + kalıp + kelime sesi (segmentten zaman damgasıyla), "Türkçesini göster", "Tekrar dinle" (0,75x), "Deftere ekle". Kapatınca video aynı yerden sürer. EN+TR altyazı modu açıldı. Not, mesaj, görev, ipucu kartlarındaki İngilizce satırlar, karar repliği ve görev kökü de paneli açar; karar seçenekleri açmaz.
- **flutter analyze:** sorun yok. **flutter test:** 63 geçti (12'si yeni).
- **Simülatör (hiVelzon iPhone 17):** `AUTOPLAY_TEST=meaning` ile B1 s02'de panel açıldı, "hear" → duymak + KALIP "Can you hear me? = Beni duyabiliyor musun?", Türkçesini göster, kapanınca video sürdü, EN+TR altyazı. Ekran görüntüleri oturum geçici klasöründe (`h046-*.png`). Uygulama normal debug derlemesi olarak kuruldu; içerik sunucusu 127.0.0.1:8787'de çalışıyor.
- **Bekleyen:** çevirinin kullanıcı onayı (status DRAFT → APPROVED, H-028).
