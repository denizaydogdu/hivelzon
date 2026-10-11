# H-024: Pilot içerik: A1-001 hikâyesi ve 3 kısa klip

- **Durum:** Bitti (2026-10-11); kullanıcı onayladı
- **Tür:** İçerik üretimi (kredi harcar, onaylı)
- **Öncelik:** Yüksek
- **Bağımlılık:** H-004, H-005

## Amaç
Gerçek kredi ve emek maliyetini ölçmek; ucuz yol (görsel + Ken Burns + TTS + altyazı) ile `higgsfield-video-explainer`'ı aynı hikâyede karşılaştırmak.

## Kapsam
- `icerik/A1-001-<kisa-baslik>/` CLAUDE.md'deki dosya düzeniyle kurulur.
- Hikâye, çeviri, sözlük ve quiz yazılır; editör kontrolünden geçer.
- Her Higgsfield üretiminden önce `generate cost` sonucu gösterilir ve **onay alınır**; her şey `PROMPTS.md`'ye kaydedilir.
- 3 kısa klip uzun hikâyeden türetilir.

## Kabul kriterleri
- §5.5 ve şartname §7.2 kontrol listeleri tamamlanmış.
- Harcanan kredi ve emek (saat) kaydedilmiş.
- İki üretim yolunun karşılaştırması yazılmış ve kullanıcı birini seçmiş.
- Sosyal medyada yayın yapılmamış (H-017).

## Kaynak
`IS-PLANI.md` §11 Faz 0 · `SARTNAME.md` §7, §8

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11: Pilot artık **S1·B1 "A Strange Message"** etkileşimli bölümü + 3 klip olacak. İçinde 2 karar anı, 1 tepki dalı, Hi'nin dil laboratuvarı ve ipucu açılışı var. Ken Burns ile video-explainer karşılaştırması korunur. Bağımlılık: H-029, H-030.

## İlerleme (2026-10-11)

**1. Referans sayfaları** (Alex, Hi, telsiz × Nano Banana 2 ve GPT Image 2.5): 7,5 kredi.
- Kullanıcının seçimi: **GPT Image 2.5** (K-24).
- Nano telsiz görseli yazı kuralını çiğnedi.
- Kayıt: `icerik/_evren/style/PROMPTS.md`, `STYLE_PREFIX.md` v1.1.

**2. B1 sahne testi** (T1 oda, T2 POV; 9:16): 1 kredi.
- Karakter tutarlılığı iyi.
- Kayıt: `icerik/A1-001-a-strange-message/PROMPTS.md`.

**3. Kilit klip maliyetleri:** Seedance 2.5 15–35 kredi; Mini ve Grok Lite 5 kredi; yerel geçiş 0.

**Kredi:** 126,25 → 117,75.

**Bekleyenler:**
- B1'in kalan görselleri;
- klip yöntemi;
- ElevenLabs ticari anahtarı (TTS);
- Ken Burns ile video-explainer karşılaştırması.
- **B1 görselleri** (I1–I5): 2,5 kredi. Hepsi stile ve referanslara uygun.
- **Kilit klip:**
  - yerel geçiş (0 kredi, 1080p);
  - Seedance 2.0 Mini başlangıç ve bitiş karesiyle (5 kredi, 720p).
  - Karşılaştırma kullanıcıda.
- **Seslendirme:** ElevenLabs `eleven_v3` zaman damgalı, speed 0.9. videoGenerator hesabı, ücretsiz plan, **yalnızca iç pilot** (kullanıcı onayı). 13 satır, 447 karakter. Ana mesaj 107 kelime/dk (A1 hedefi).
- **Kredi:** 110,25.
- **Sırada:**
  - B1 doğrusal önizleme videosu (yerel kurgu: Ken Burns + ses + altyazı + karar kartları);
  - 3 kısa klip;
  - video-explainer karşılaştırması.
- **Doğrusal önizleme:** `final/A1-001-onizleme-ic-pilot.mp4`. 65,7 sn; -16 LUFS; yerel kurgu, 0 kredi. Kilit klip olarak Seedance Mini seçildi (kullanıcı). Kullanıcı geri bildirimi bekleniyor.
- **Sırada:** 3 kısa klip (yerel), video-explainer karşılaştırması (maliyet onayıyla).
- **Kullanıcı geri bildirimleri ve düzeltmeler:**
  - "Donmuş gibi" → v2: akıcı hareket; ölçümde 0/44 hareketsiz kare.
  - "Yazı ile ses uyumsuz" → v3: zaman damgalı altyazı + ses dolgusu düzeltmesi; en büyük fark 0,16 sn.
  - Dersler: `ogrenilenler/D-001-pilot-kurgu-tuzaklari.md`.
- **Video-explainer karşılaştırması kapandı:** ~187 kr; biçim uymuyor (kullanıcı kararı).
- **3 kısa klip** (v3, senkron doğrulandı): 25,5 / 28,3 / 27,5 sn.
- **Kalan:** kullanıcının v3 ve kısa klip değerlendirmesi; pilotun maliyet ve emek özeti.

## Sonuç (2026-10-11)

**Pilot S1·B1 "A Strange Message" tamamlandı.** Kullanıcı önizleme v3'ü ve 3 kısa klibi onayladı ("akıcı", "yazı ile ses uyumlu").

**Maliyet:**

| Kalem | Kredi | Not |
|---|---|---|
| Referans sayfaları (2 model × 3) | 7,5 | Tek seferlik; model seçimi |
| Sahne testi | 1 | |
| B1 görselleri (7 adet: T1, T2, I1–I5) | 3,5 | 0,5 kr/görsel |
| Kilit klip (Seedance 2.0 Mini, 5 sn) | 5 | |
| **Toplam** | **17** | 126,25 → 110,25 |
| **Bir bölümün tekrarlanan maliyeti** | **~8,5** | 7 görsel + 1 kilit klip; referanslar ve testler hariç |

- **TTS:** 447 karakter. Ücretli planda yaklaşık birkaç sent [fiyat doğrulanmadı].
- **Video-explainer:** ~187 kr tutardı; kullanılmadı.

**Sezon 1 tahmini:** 12 bölüm × ~8,5 kr ≈ **~100 kr** (+ prolog).
- Bölüm başına bir kilit klip varsayıldı. Seedance Mini yalnızca kilit anlarda kullanılır (sezonda 3–4) ve diğer bölümler yerel geçişle yapılırsa ≈ **~60–70 kr**.
- Kalan 110 kr, Sezon 1 için sınırda. Plan kararı H-004'te.

**Süre:** Bir bölümün kurgusu yerelde ~1 dk sürüyor. Görsel üretimi paralel ~2–3 dk. Asıl emek yazım, onay ve kalite kontrolde.

**Standart üretim yolu:** CLAUDE.md "Onaylı oyun tasarımı kararları" → H-024 satırı.

**Dersler:** `ogrenilenler/D-001-pilot-kurgu-tuzaklari.md`.

**Açık kalanlar:**
- **Ticari ElevenLabs hesabı** (H-006). Pilot sesleri yayınlanamaz.
- **Etkileşimli oynatıcı** (H-031). Önizleme doğrusal, gerçek etkileşim yok.
- **Kurgu aracının kalıcı hâli** (`content-pipeline`). Kod onayından sonra yazılacak; şu an oturuma özgü betik.
- **Karaoke kelime vurgusu.** Hizalama verisi hazır.

