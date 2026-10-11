# H-031: Etkileşimli bölüm oynatıcısı prototipi

- **Durum:** Bitti (simülatör kriterleriyle)
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
2026-10-11 (doğrulama): Oynatıcı prototipi yazıldı ve iOS simülatörde ("hiVelzon iPhone 17", debug/JIT derleme) ölçüldü.
- **Yapı:**
  - `mobile/lib/features/player/domain/`: saf Dart motor, `scenes.json` ve altyazı modeli, görev denetimi.
  - `application/`: en fazla 3 denetleyicili havuz, ön ısıtma ve önden başlatma, oturum, `AUTOPLAY_TEST` sürücüsü.
  - `presentation/`: oynatıcı ekranı, karar kartı, Hi ipucu, kartlar, görevler, bitiş ekranı.
  - `lib/shared/content/`: `ContentSource` + HTTP uygulaması (`--dart-define=CONTENT_BASE_URL`, varsayılan `http://127.0.0.1:8787`).
  - `tools/dev-content-server/serve.py`: yalnızca 127.0.0.1'e bağlanır, Range destekler.
  - Kontrol noktası şimdilik `shared_preferences` ile `ProgressRepository` arayüzünün arkasında tutuluyor; H-035'te Drift'e geçecek.
- **Testler:** `flutter analyze` temiz, `flutter test` 51/51 geçti.
  - Motor testleri gerçek B1–B4 `scenes.json` kopyalarıyla ve sentetik grafikle yapıldı.
  - B1 baştan sona widget testi sahte video platformuyla yapıldı.
  - Havuz, görev ve Hikâye listesi testleri de bu sayıya dahil.
- **Simülatörde otomatik oynatma** (`AUTOPLAY_TEST=true`):
  - B1–B4 baştan sona oynandı; dördünde de `completed=true` ve kapı açık.
  - Her kararda önce yanlış seçenek denendi, tepki dalı oynadı ve aynı karara dönüldü. Her bölümde 1. kararda ipucu 1 → 2 açıldı.
- **Segment → segment geçişi (`auto`)**, segment bitişinden yeni segmentin oynatma başı ilerleyene dek ölçüldü:
  - **Ön ısıtma tek başına:** B1 181,6/195,6 ms, B2 179,1/183,2 ms, B4 180,1/181,1 ms (medyan/en çok). Hedef olan 150 ms aşıldı; AVPlayer başlangıcı ≈ 140–150 ms sürüyor.
  - **Önden başlatma ile** (sıradaki segment, bu segment bitmeden 220 ms önce altta başlatılır):
    - 1. koşu: B1 34,7/34,9 · B2 39,8/40,5 · B4 86,3/131,1 ms.
    - 2. koşu: B1 35,2/37,2 · B2 40,0/41,0 · B4 36,4/40,5 ms.
    - B3'te otomatik geçiş yok; bütün geçişleri karar sonrası.
  - Hedef (≤ 150 ms) karşılandı.
- **Diğer geçişler:**
  - Karar dokunuşundan ilk kareye: medyan 143–156 ms, en çok 218 ms.
  - Kart veya görevden videoya: medyan 148–159 ms, en çok 263 ms.
  - Bölüm açılışı (ön ısıtma yok): 279–821 ms; bu sürede dönen gösterge görünür.
  - Bu geçişlerde eski son kare ya da karar görseli ekranda kalır.
- **Siyah kare yok.**
  - Yöntem: Yeni video altta çizilir, eski videonun son karesi yenisinin ilk karesine dek üstte kalır.
  - Ölçüm: 2. koşunun ekran kaydı (20.097 kare, 6 dk) ffmpeg `signalstats` ile tarandı. Geçişlerde en karanlık kare bile siyah değil.
  - En karanlık kareler yalnızca bölüm açılışındaki yükleniyor ekranı (597 ms ve 73 ms) ile koyu arka planlı bir kart.
  - `blackdetect` hiç siyah aralık bulmadı.
- **Altyazı:**
  - Uygulama çiziyor; hedef ifade vurgulanıyor; satıra dokununca satır yeniden oynuyor.
  - Konum tahmin saatinin bildirilen konumdan sapması bölüm başına en çok 1–111 ms. Tek aykırı değer B3'te 725 ms (tek örnek; nedeni bulunmadı).
  - Ses–yazı farkının (≤ 0,2 sn) cihazda ayrıca ölçülmesi gerekiyor.
- **Kontrol noktası, süreç öldürülerek doğrulandı:**
  - `resume1`: B1 `s05`'e kadar oynatıldı, ardından `simctl terminate` ile süreç öldürüldü.
  - `resume2`: "Kaldığın yerden devam" soruldu; `s05`'ten devam edildi; bölüm bitti, kapı açık.
- **Bellek:** Simülatörde Runner RSS'i 4 bölüm boyunca 321–813 MB arasında, ortalama 553–603 MB (3 koşu). Sürekli artış yok.
  - Debug/JIT derlemede ve Mac üzerinde ölçüldü; telefon değerini temsil etmez.
- **Yapılmadı:**
  - Düşük uçlu Android cihazda bellek ve ısı ölçümü (cihaz yok).
  - Gerçek iPhone'da profile/release ölçümü.
  - EN+TR altyazı modu: `tr` alanları boş; seçenek "Türkçe satır yakında" notuyla pasif.
  - Kabul kriterlerinden "Düşük uçlu Android" ve "telefonda" maddeleri açık. İş bu yüzden `bitenler/`e taşınmadı.
2026-10-11 (ana oturum): `flutter analyze` temiz, `flutter test` 51/51 yeniden doğrulandı. Kullanıcı kararı: düşük uçlu Android ölçümü ve gerçek telefonda ses–yazı kontrolü H-043'e taşındı; iş simülatör kriterleriyle bitti.
