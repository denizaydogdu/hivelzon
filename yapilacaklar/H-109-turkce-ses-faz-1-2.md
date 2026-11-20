# H-109: Yeni Türkçe ses yerleri — Faz 1 ve Faz 2 (öneri)

- **Durum:** ⛔ Kullanıcı kararı bekliyor (2026-11-20 önerisi). Planda olmayan yeni kapsam; onaysız başlanmaz.
- **Tür:** İçerik hattı (Alania + Duyu) + mobil arayüz
- **Öncelik:** Düşük–Orta
- **Bağımlılık:** H-083, H-104, H-105, H-108 (gerçek ücret durumu) · editör incelemesi (metin değişirse yeniden seslendirme)

## Arka plan
Tasarımda Türkçe konuşulan her yer zaten sesli; 2026-11-20 kuru çalışmalarında eksik 0: 13 bölüm (Hi, Alex, babaanne,
anlatıcı), Hi paneli + Konuş (56 ses), 30 kitap "Sayfanın Türkçesi" (626 sayfa), 71 dilbilgisi anlatımı.
PatientDesk `GET /v1/usage`: `free: false`, `free_until` 2026-11-14 10:57 UTC; kalan Duyu kotası ≈ 985 saat.
Tarife 0,75 TL/1.000 karakter (Alania) + 6 TL/ses saati (Duyu) ≈ 0,87 TL/1.000 karakter.

## Öneri (sesi olmayan Türkçe metinler)
| Faz | Kapsam | Karakter | ≈ TL | Not |
|---|---|---|---|---|
| 1 | Dilbilgisi yanlış cevap açıklamaları (`!`) A1–C2 + Keşfet reel alıştırma metinleri (A1–A2) | 13.270 (11.642 + 1.628) | 12 | Önerilen; "hatanın nedeni Türkçe açıklanır" ilkesi; önce A1–A2 |
| 2 | Kitap sonu soruların Türkçesi + kitap tanıtımı (`blurbTr`) | 12.014 (2.855 + 9.159) | 10,5 | İsteğe bağlı |
| 3 | Çeviri sesleri (dilbilgisi örnek Türkçesi, bölüm hikâye Türkçesi, reel altyazı) | ≈ 80.000 | ≈ 70 | Önerilmez (K-03, K-23; İngilizce dinlemenin yerini alır) |
| 4 | Dinamik uygulama metinleri (Hi önerileri, açılış) | — | — | H-044 sonrası, sunucuda TTS; ayrı karar |

Her fazda: araç parçası (kart kimliği kaymaz) + mobilde "dinle" düğmesi (otomatik çalma yok, ses yoksa görünmez, H-104 deseni)
+ lint/test → kuru çalışma maliyeti → kullanıcı onayı → tavanla üretim → simülatör (izinle) → kulakla kontrol → editör.

## Kabul kriterleri (onaylanırsa)
- Seçilen fazın bütün metinleri sesli; kuru çalışma eksik 0; harcama `PROMPTS.md` ve defterde.
- Lint 0 hata; pytest, `flutter analyze`, `flutter test` yeşil; uygulamada düğme yalnız ses varken görünür.

## Not
Asıl ses açığı İngilizce: 24 kitap, B1–C2 dilbilgisi örnekleri, 19 yeni kanca (çalışan ElevenLabs erişimi/onaylı plan).
