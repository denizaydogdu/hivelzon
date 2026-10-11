# PROMPTS: A1-001 *A Strange Message* (pilot, H-024)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1.
- **Model:** gpt_image_2_5.
- **Referanslar:** Alex (663ea0fe…), telsiz (74fb45e8…).
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok. Videoda "Yapay zekâ ile üretilmiştir" ibaresi olacak.

## Sahne testi (karakter tutarlılığı), 2026-10-11

| # | Sahne | Prompt (STYLE eklenir) | Parametre | Tahmin | Gerçek | Job ID | Dosya |
|---|---|---|---|---|---|---|---|
| T1 | Sahne 1: Cuma akşamı, oda ve telsiz | Use the reference images for the character Alex and for the old radio; keep the same face, hair, clothes and radio design. Scene: evening in a small, bright rented room in a coastal town. Through the window: a harbour and, far away, a lighthouse at dusk. Alex sits at a wooden desk and carefully places the old green-and-cream radio on the desk. A simple round wall clock with a blank face, no numbers. Calm, curious mood. Vertical composition. | 9:16, 2k (quality: low, varsayılan), refs: Alex + telsiz | 0,5 | 0,5 | 6d48f511-e6a9-4d23-b90a-1bb12b643b73 | images/T1-oda.png (1520×2688) |
| T2 | K1 karar anı (POV) | Use the reference image for the old radio and Alex's hands and jacket sleeve. Scene: first-person point of view looking down at the old radio on a wooden desk, its small green light glowing, Alex's hands near the radio, a phone lying next to it with a dark blank screen. Background softly blurred and simplified, warm dim evening light, focused and quiet decision moment. Vertical composition. | 9:16, 2k (quality: low), refs: Alex + telsiz | 0,5 | 0,5 | 79759833-7016-4e97-8f28-2af795a5cf49 | images/T2-pov.png (1520×2688) |

- **Toplam:** tahmin 1 / gerçek 1 kredi.
- **Kredi:** 118,75 → 117,75.
- **Kullanıcı onayı:** 2026-10-11, soru-cevap.

**Değerlendirme:**
- ✅ Alex'in yüzü, saçı ve kıyafeti referansla tutarlı; telsiz tasarımı aynı.
- ✅ Saat rakamsız; görselde yazı yok; 9:16.
- ⚠️ T1'de telsizin ışığı zaten açık (hikâyede 19:00'da yanıyor). Kurguda ışığın yandığı an T2 ve klipte gösterilir; T1 sahnenin başında kısa kullanılır ya da ileride ışık kapalı varyantı üretilir.
- **Not:** GPT Image 2.5'in varsayılan kalitesi `low`. 0,5 kredilik fiyat bu kaliteye ait ve düşük kalite pilot için yeterli görünüyor.
- **İndirme hatası ve düzeltmesi:** JSON'daki ilk `.png` adresi referans görseline aitti. Sonuç `result_url` alanından indirilmeli.

## Kilit klip maliyet karşılaştırması (★ telsiz ışığı, 5 sn, 9:16, start-image = T2)

| Model | 480p | 720p |
|---|---|---|
| seedance_2_5 | 15 | 35 |
| kling3_0_turbo | — | 7,5 |
| seedance_2_0_mini | — | 5 |
| grok_video_v15_lite | — | 5 |
| Yerel geçiş (T2'nin ışık kapalı ve açık hâlleri + parlama, ffmpeg) | 0 | 0 |

## B1 görselleri (2026-10-11)

- **Model:** gpt_image_2_5, 9:16, 2k, quality low.
- **Stil:** STYLE_PREFIX v1.1.
- **Kullanıcı onayı:** soru-cevap, "~2,5 kredi".

| # | Sahne | Referanslar | Tahmin | Gerçek | Job ID | Dosya | Değerlendirme |
|---|---|---|---|---|---|---|---|
| I1 | Soğuk açılış: not ve telsiz | telsiz | 0,5 | 0,5 | 8863e17c-17e5-47be-8dc2-9e3e6f995a10 | images/I1-not.png | ✅ Notta okunur yazı yok. Telsiz ışığı açık. |
| I2 | Telefonda kayıt ve Hi | Alex, Hi, telsiz | 0,5 | 0,5 | fae1ad51-b5dd-416b-b5a1-7c4c3d68979a | images/I2-telefon-hi.png | ✅ Hi referansla aynı. |
| I3 | K1 yanlış cevap tepkisi | Alex, telsiz | 0,5 | 0,5 | c378602b-80a8-4805-9bf1-0ef717358f80 | images/I3-tepki.png | ✅ Şaşkın, üzgün değil. |
| I4 | Pencereden komşu dükkân | Alex | 0,5 | 0,5 | 395bc1aa-3892-4a86-b978-dd9acdbd67a8 | images/I4-pencere.png | ✅ Kitap ve çay fincanları görünüyor. |
| I5 | Harita anı | Alex | 0,5 | 0,5 | 95afb6c5-1744-46eb-b64f-24d3bcbe5e8a | images/I5-harita.png | ✅ Etiket yok. ⚠️ Defterde bir fener çizimi var (hafif ön işaret, kabul edilebilir). Alex'in yüzü biraz daha olgun. |

**Prompt'lar:** `/tmp/b1_specs.txt` (oturum dosyası). Metinler aşağıda.
- **I1:** "Use the reference image for the old radio. Close-up on a wooden desk: an old folded, yellowed paper note lying next to the radio's round channel dial; the paper shows only faint, illegible pencil marks, no readable letters. Soft evening light, quiet mystery. Vertical composition."
- **I2:** "Use the reference images for Alex, for the AI assistant Hi and for the old radio; keep their designs. Scene: evening, Alex holds her phone and looks at it with curiosity; on the phone screen the small glowing speech-bubble character Hi smiles at her; the old radio sits on the desk behind, its green light on. No text on the screen. Vertical composition."
- **I3:** "Use the reference images for Alex and the old radio; keep the same face, hair and clothes. Scene: Alex leans toward the old radio on the desk, puzzled and frowning slightly, one hand near her ear as if listening hard; the radio's green light is on; a gentle, slightly humorous confused moment, not sad. Vertical composition."
- **I4:** "Use the reference image for Alex; keep the same face, hair and clothes. Scene: night, Alex stands at her window and looks down at the small shop next door; its window glows warmly, with books and tea cups visible inside; a quiet harbour street, a lamp post. Hopeful, curious mood. Vertical composition."
- **I5:** "Use the reference image for Alex; keep the same face, hair and clothes. Scene: Alex sits at the desk in the evening, looking at her phone with a slightly confused face; the phone shows a simple map with no labels and no text; an open notebook with small hand-drawn map lines and no writing. Vertical composition."

(Hepsinin sonuna STYLE eklenir.)

## ★ Kilit klip: telsiz ışığı yanıyor (2026-10-11)

**Kullanıcı onayı:** soru-cevap, "ikisini de dene".

| Yol | Nasıl | Çözünürlük | Kredi | Dosya | Değerlendirme |
|---|---|---|---|---|---|
| Yerel | T2'den ffmpeg ile ışık kapalı kare üretildi (LED karartıldı); 1,5 sn'de 0,5 sn'lik geçiş, %5 yakınlaşma | 1080×1920, 5 sn | 0 | clips/K-isik-yerel.mp4 | ✅ Temiz ve ucuz. Hareket yalnızca yakınlaşma. |
| Seedance 2.0 Mini | Başlangıç: ışık kapalı kare (upload 48f7fc69…). Bitiş: T2 (upload 75381b1d…). Prompt: "The small green indicator light on the old radio turns on and begins to glow softly with a faint flicker; very slow camera push-in; the hands stay still; nothing else changes." Ses kapalı. | 720×1280, 5 sn | 5 (tahmin 5) | clips/K-isik-seedance-mini.mp4 (job 30078f0c-7700-4017-897e-1db9553fcea0) | ✅ Doğal hareket ve parlama; tutarlılık iyi. ⚠️ 720p. |

**Kredi:** 117,75 → 115,25 (görseller) → 110,25 (klip).

## Seslendirme (TTS), 2026-10-11

- **Sağlayıcı:** ElevenLabs `POST /v1/text-to-speech/{voice}/with-timestamps`, model `eleven_v3`.
- **Ayarlar:** `voice_settings` stability 0.5, similarity 0.75, **speed 0.9**; `language_code` en/tr; `mp3_44100_128`. Hız ve dil kodu kabul edildi.
- **Hesap:** videoGenerator'ın ElevenLabs hesabı, **ücretsiz plan.** Kullanıcı soru-cevapla onayladı.
  - ⚠️ Ücretsiz plan ticari lisans içermez. **Bu sesler yalnızca iç pilot içindir, yayınlanmaz.** Yayından önce hiVelzon'un ticari hesabıyla yeniden üretilir (H-006).
  - Anahtar hiVelzon'a kopyalanmadı; çağrı anında videoGenerator config'inden okundu.
- **Sesler** (hazır sesler, kullanıcı onayı):
  - Alex = Jessica (`cgSgspJ2msm6clMCkdW9`);
  - Ellen / telsiz = Lily (`pFZP5JQG7iQjIQuC4Bku`);
  - Hi = River (`SAz9YHcvj6GT2YYXdXww`).
- **Tüketim:** 13 satır, **447 karakter** (aylık kota 10.000). Abonelik sayacı üretim sonrası hemen güncellenmedi; tekrar kontrol edilecek.
- **Çıktılar:** `audio/*.mp3` (git dışı) ve `audio/*.align.json` (karakter düzeyinde zaman damgası; altyazı ve WebVTT için).
- **Telsiz efekti** (ffmpeg, yerel): highpass 350 Hz, lowpass 3200 Hz, kompresör, pembe gürültü → `voice_0x_telsiz.mp3`.

**Konuşma hızı (kelime/dk):**

| Satır | Hız | Değerlendirme |
|---|---|---|
| voice_02 (ana mesaj) | 107 | ✅ A1 hedefi 100–110 |
| voice_01 | 92 | ✅ |
| alex_03 "Where is the old station?" | 221 | ⚠️ Kısa satırlarda hız yüksek. Hedef ifade olduğu için kurguda `atempo` ile yavaşlatılır. |
| alex_k1_a | 250 | ⚠️ Aynı şekilde kurguda yavaşlatılır. |

## Doğrusal önizleme (iç pilot), 2026-10-11

- **Dosya:** `final/A1-001-onizleme-ic-pilot.mp4` (git dışı). 65,7 sn, 1080×1920, 30 fps.
- **Ses:** **-16,0 LUFS**, tepe -2 dBFS. İki geçişli loudnorm (uygulama hedefi).
- **Yöntem:** Yerel kurgu, **0 kredi**.
  - Ken Burns (%6 yakınlaşma ya da uzaklaşma) + Seedance Mini kilit klip + TTS.
  - İngilizce altyazı, Hi'nin Türkçe balonu, karar kartları (doğru seçim yeşile döner), görev kartı ve açık soru kartı: ImageMagick PNG + ffmpeg overlay.
  - Bu ffmpeg derlemesinde `drawtext` ve `subtitles` filtreleri yok, bu yüzden PNG yöntemi kullanıldı.
- **İbare:** "Yapay zekâ ile üretilmiştir · İÇ PİLOT — yayınlanmaz" (ücretsiz plan sesleri).
- **Yavaşlatma:** Hızlı Alex replikleri `atempo` 0.82–0.85 ile yavaşlatıldı.
- **Kurgu betiği:** Oturuma özgü (`scratchpad/tools/b1_preview.py`). Kalıcı araç kod onayından sonra yazılacak (`content-pipeline`).
- **Bilinen eksikler:**
  - kelime düzeyinde karaoke vurgusu yok (hizalama verisi hazır);
  - etkileşim gerçek değil (doğrusal önizleme; etkileşimli oynatıcı H-031);
  - seçenek kutularında ince bir kenar çizgisi kusuru;
  - Alex'in sesi Türk aksanlı değil.

### Önizleme v2 (kullanıcı geri bildirimi: "bazı sahneler akıcı değil, donmuş gibi")

**Kök nedenler:**
1. Ken Burns, `scale` ile çift piksele yuvarlanarak yapılıyordu; kare kare takılma oluyordu.
2. Aynı POV karesi art arda 4 bölümde kullanılıyordu.
3. Bölümler sert kesimle bağlanıyordu; hareket her kesimde sıfırlanıyordu.

**Düzeltmeler:**
- Görsel tam 9:16'ya kırpılıp 3 kat büyütüldü (3240×5760). Yakınlaşma ve kaydırma `zoompan` ile o çözünürlükte hesaplanıyor; çıktı 1080×1920.
- Sahne sırası çeşitlendirildi. Ana mesaj I1'de; tekrar dinleme T2'nin yakın planında.
- Aynı görsel art arda gelince hareket kaldığı yerden devam ediyor.
- 0,35 sn'lik `xfade` ve `acrossfade` geçişleri.

**Ölçüm** (T1 sahnesi, 44 kare arası fark):

| Sürüm | Hareketsiz kare | Std |
|---|---|---|
| v1 | 12/44 | 1,58 |
| v2 | **0/44** | **0,37** |

- **Dosya:** `final/A1-001-onizleme-ic-pilot-v2.mp4`. 64,5 sn; -16,1 LUFS; tepe -1,5 dBFS.

## Video-explainer karşılaştırması (CLAUDE.md kural 4), 2026-10-11

**Maliyet tahmini:**

| Kalem | Kredi |
|---|---|
| gemini_omni, 10 sn, 720p, 9:16 | 30 / blok |
| seed_audio | 0,8 / blok |
| nano_banana_2 stil anahtarı | 2 |
| **B1 (6 blok) toplam** | **~187** |

Kalan kredi 110,25 olduğu için tutar karşılanamıyor. Biçim de uymuyor: tek anlatıcı var; karakter sesleri, telsiz mesajı ve karar anları yapılamıyor.

**Kullanıcı kararı:** Karşılaştırma kapatıldı. Varsayılan yol: görsel + yerel Ken Burns + kilit an için Seedance Mini. Önizleme v2 kullanıcı tarafından "akıcı" onaylandı.

### Önizleme v3 ve kısa klipler (kullanıcı geri bildirimi: "yazılar ile ses uyumlu değil; ses bazen önden, bazen arkadan gidiyor")

**Kök nedenler (ölçümle bulundu):**
1. **Yavaşlatılan bölümlerde ses kısa kalıyordu.** `atempo` ile `apad` birlikte çalışmadı: s04'te görüntü 5,0 sn iken ses 2,06 sn. Birleştirmede (`acrossfade`) her kısa ses sonraki bütün sesleri öne çekti. Ölçülen kayma -0,6 sn ve üstüydü; bazı yerlerde beklenen anda hiç ses yoktu.
2. **Altyazı cümlenin tamamını bir anda gösteriyordu** ve bölüm sonuna kadar ekranda kalıyordu.
3. **Geçiş sırasında** yeni sesin başlangıcı ile eski yazı çakışıyordu.

**Düzeltmeler** (kurgu aracı v3, `scratchpad/tools/kurgu.py`):
- Yavaşlatma önceden ayrı bir WAV dosyası olarak üretiliyor. Ses `apad=whole_dur=L, atrim=end=L` ile tam bölüm süresine dolduruluyor. Bölüm süreleri kare sayısına yuvarlanıyor.
- **Altyazılar, ElevenLabs'in karakter düzeyindeki zaman damgalarıyla** cümle parçası düzeyinde zamanlanıyor. Bir parça, söylendiği an görünüyor ve söylenince kayboluyor. Ses ve yazı, 0,3 sn'lik geçişten sonra (0,5 sn) başlıyor.
- **Otomatik doğrulama:** Her sesli bölümde beklenen yazı başlangıcı, çıktıdaki gerçek ses başlangıcıyla karşılaştırılıyor.

**Sonuç:**

| Dosya | En büyük fark | Not |
|---|---|---|
| Önizleme v3 | 0,16 sn | Yazı sesten 0,06–0,16 sn önce; altyazıda istenen küçük öncelik |
| Kısa 1 | 0,15 sn | |
| Kısa 2 | 0,09 sn | |
| Kısa 3 | 0,13 sn | |

- Bölüm başına ses ve görüntü süreleri eşit (fark < 0,02 sn).
- **Ses yüksekliği:** v3 -15,8 LUFS; kısa klipler -16,1 / -16,1 / -16,4 LUFS.

**Dosyalar:**
- `final/A1-001-onizleme-ic-pilot-v3.mp4` (66,0 sn)
- `final/A1-001-kisa-1-can-you-hear-me.mp4` (25,5 sn)
- `final/A1-001-kisa-2-again-please.mp4` (28,3 sn)
- `final/A1-001-kisa-3-telsiz-mesaji.mp4` (27,5 sn)
- Eski v1 ve v2 dosyaları yerelde duruyor; geçersiz.

**Kısa klip şablonu** (ICERIK-MIMARISI §4.5): kanca → söz → öğretim (Hi) → tekrar (yavaş) → test kartı → çağrı. Sosyal medya için -14 LUFS'lik ayrı bir çıktı gerekecek (K-14; yayın ayrıca onaylı).

**Görüntü ve yazı uyumu düzeltmesi:** Kısa 1'de "Yes, I can hear you." yazısı Alex'in şaşkın olduğu karedeydi (I3); telsiz yakın planına (T2) taşındı.
