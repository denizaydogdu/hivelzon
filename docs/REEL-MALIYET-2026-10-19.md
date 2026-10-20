# Keşfet reelleri — güncel maliyet tablosu (2026-10-19)

> **Amaç:** Gerçek üretimden **önce** 3 örnek ve 18 videoluk pilot için **güncel** fiyatı
> göstermek. **Bütçe onaylanmadı**; bu belge bir harcama izni değildir.
> **Kural:** Her ücretli çağrıdan **önce** `higgsfield generate cost` çalıştırılır ve ayrıca onay
> alınır; her prompt `PROMPTS.md`'ye yazılır (H-024). Web/CLI/API tarifesi aynı varsayılmaz.
> Plan: `docs/KESFET-GUNLUK-UC-VIDEO-PLAN-2026-10-18.md` §10.
> Ölçüm yöntemi: `higgsfield generate cost <model> …` (iş oluşturmaz, kredi harcamaz).

## 0. Ölçüm anındaki durum

| | Değer | Kaynak |
|---|---|---|
| Hesap | `info@velzon.tr`, **lite** plan | `higgsfield account status` |
| Kullanılabilir kredi | **298,06 kr** | `higgsfield account status` |
| Ölçüm tarihi | 2026-10-19 | bu belge |
| Aylık AI tavanı | 300 USD/ay — **diğer AI işleriyle ortak** (H-003) | `yapilacaklar/IS-SIRASI.md` |

Geçmiş ölçümler (0,5 kr/görsel ve 5 kr/5 sn) bu belgede **güncel fiyat sayılmaz**; aşağısı
2026-10-19'da ölçüldü. Aynı modelin kalite/çözünürlük basamağı fiyatı değiştiriyor
(bu yüzden tek bir "görsel fiyatı" yoktur).

## 1. Güncel birim fiyatlar (ölçüldü)

### 1.1 Görsel — `gpt_image_2_5` (9:16)

| Kalite | Çözünürlük | Kredi/görsel |
|---|---|---|
| low | 1k | 0,25 |
| low | 2k | 0,50 |
| medium | 1k | 0,50 |
| medium | 2k | 1,00 |
| high | 1k | 1,50 |
| high | 2k | 2,75 |

### 1.2 Hareket — `seedance_2_0_mini` (9:16)

| Çözünürlük | Süre | Kredi |
|---|---|---|
| 480p | 4 sn | 2,00 |
| 480p | 5 sn | 2,50 |
| 480p | 10 sn | 5,00 |
| 720p | 4 sn | 4,00 |
| 720p | 5 sn | 5,00 |
| 720p | 10 sn | 10,00 |

Karşılaştırma (pilotta **önerilmez**, pahalı):

| Model | 9:16 720p 5 sn |
|---|---|
| `gemini_omni` | 15,00 kr |
| `seedance_2_5` | 35,00 kr |
| `seedance_2_0_mini` | **5,00 kr** |

Diğer görsel modelleri (aynı kalite basamağında): `nano_banana_2_1` ve `nano_banana_flash`
9:16 2k = **2,00 kr/görsel** — `gpt_image_2_5`'in 1k medium (0,50) ve 2k high (2,75) basamakları
arasında kalıyor. Stil tutarlılığı için örnek üretimde 2–3 model yan yana denenebilir
(örnek bütçesine küçük ek).

### 1.3 Yerel, kredisiz kalemler

| Kalem | Kredi | Not |
|---|---|---|
| Ken Burns hareketi (ffmpeg/ImageMagick) | 0 | İşlem süresi ve depolama ücretsiz **sayılmaz**, ayrı izlenir |
| Poster/ilk kare, altyazı, paketleme | 0 | Yerel araçlarla |
| `reel-lint`, içerik ve mobil testler | 0 | Yerel |

### 1.4 Ses — ayrı defter (karakter)

ElevenLabs (Creator, ~22 USD/ay, ~100 bin karakter) kotasından düşer; **USD değil karakter**
olarak raporlanır. **Ölçüldü (2026-10-19, `tts_reel.py --dry-run`):** A1 örneklerinde reel başına
**71–77 karakter** (3 cue, hedef ifade + 1–2 kısa replik) → **3 örnek = 220 karakter**,
**18 video ≈ 1.300 karakter** (aylık kotanın ~%1,3'ü). Türkçe ses pilotta zorunlu değil.
Tek anlatıcı: uygulamadaki sesle aynı — **Sarah** (`EXAVITQu4vr4xnSDxMaL`, `eleven_v3`, hız 0.9).

## 2. Varsayımlar (üretim modeli)

- Reel ≈ **10 sn** dikey; **video başına 4 sabit kare** (plan §10.1) + Ken Burns.
- Hareket **zorunlu değil**: önce sabit kare; yalnız gerekli sahnede 1 klip.
- **Yeniden üretim/eleme payı %25** (plan: %20–30) ayrı satır olarak görünür.
- Paketleme, poster ve lint kredisiz (yerel).

## 3. Üç örnek sahne (kategori başına 1 video)

| Kalem | Adet | Kredi (senaryo A) | Kredi (senaryo B) |
|---|---|---|---|
| Görsel: 3 video × 4 kare | 12 | 1k medium → **6,00** | 2k high → **33,00** |
| Hareket: örnek başına 1 klip (mini) | 3 | 480p 5 sn → **7,50** | 720p 5 sn → **15,00** |
| Yerel (Ken Burns, poster, lint) | — | 0 | 0 |
| Ara toplam | | **13,50** | **48,00** |
| Yeniden üretim payı (%25) | | +3,38 | +12,00 |
| **Örnek toplamı** | | **≈ 17 kr** | **≈ 60 kr** |
| Ses (ayrı defter) | | 300–450 karakter | 300–450 karakter |

## 4. 18 videoluk pilot (3 kategori × 2 seviye × 3 video)

| Kalem | Adet | Senaryo A (1k medium + 3 klip 480p) | Senaryo B (2k high + 3 klip 720p) | Senaryo C (2k high + her video 1 klip) |
|---|---|---|---|---|
| Görsel (video başına 4 kare) | 72 | 72 × 0,50 = **36,00** | 72 × 2,75 = **198,00** | 72 × 2,75 = **198,00** |
| Hareket (mini, 5 sn) | 3 / 3 / 18 | 3 × 2,50 = **7,50** | 3 × 5,00 = **15,00** | 18 × 5,00 = **90,00** |
| Ken Burns + poster + paket | — | 0 | 0 | 0 |
| Ara toplam | | **43,50** | **213,00** | **288,00** |
| Yeniden üretim payı (%25) | | +10,88 | +53,25 | +72,00 |
| **Pilot toplamı** | | **≈ 55 kr** | **≈ 266 kr** | **≈ 360 kr** |
| Ses (ayrı defter) | | ≈ 1.300 karakter | ≈ 1.300 karakter | ≈ 1.300 karakter |

**Bakiye uyarısı:** mevcut kredi **298,06**. Senaryo A bakiyeye rahat sığar; **senaryo B
bakiyenin neredeyse tamamını** (≈266 kr), senaryo C ise **bakiyeyi aşar** (≈360 kr) → kredi
yüklemesi gerekir.

## 5. USD ve TL sütunu (varsayım — teyit gerekir)

Higgsfield kredisi **USD cinsinden tek bir sabit fiyata** sahip değil; plan/kredi paketine göre
değişiyor. Repo'da belgelenmiş aralık: **0,028–0,075 USD/kredi** (`docs/IS-PLANI.md` §281, 2026
kaynağı). Bu hesap için **lite plan kredi fiyatı ayrıca teyit edilmeli**; aşağısı o iki uçla
hesaplanmış **tahmin**tir. TL için kur: **1 USD = 49,527 TL** (ECB/Frankfurter, 2026-10-16).

| Toplam | @0,028 USD/kr | @0,075 USD/kr | TL (@0,028) | TL (@0,075) |
|---|---|---|---|---|
| 3 örnek — senaryo A (17 kr) | 0,48 USD | 1,28 USD | ≈ 24 TL | ≈ 63 TL |
| 3 örnek — senaryo B (60 kr) | 1,68 USD | 4,50 USD | ≈ 83 TL | ≈ 223 TL |
| Pilot — senaryo A (55 kr) | 1,54 USD | 4,13 USD | ≈ 76 TL | ≈ 204 TL |
| Pilot — senaryo B (266 kr) | 7,45 USD | 19,95 USD | ≈ 369 TL | ≈ 988 TL |
| Pilot — senaryo C (360 kr) | 10,08 USD | 27,00 USD | ≈ 499 TL | ≈ 1.337 TL |

300 USD/ay tavanına göre bu pilot **tek başına tavanı aşmaz**, ama tavan diğer AI işleriyle
**ortaktır** (H-003) ve bu tahminler kredi fiyatı teyidine bağlıdır.

## 6. Öneri ve onay kapıları

1. **Önerilen:** senaryo A ile **3 örnek** üret (≈17 kr + ~350 karakter), kaliteyi kullanıcı
   görsün; örnekte 2–3 görsel modeli yan yana dene (küçük ek, ≈1–3 kr). Örnek onaylanmadan
   18'e geçilmez.
2. Örnek onaylanınca **18 video**, onaylı alt bütçe içinde; hareket yalnız gerekli sahnelerde.
3. Her ücretli çağrıdan önce `higgsfield generate cost` + ayrı onay; her prompt `PROMPTS.md`.
4. Yeniden üretim payı görünür kalır; biten iş yeniden ücretlenmez.
5. Kredi yüklemesi (senaryo B/C seçilirse) ayrı bir karardır.

**Onay durumu:** ücretli üretim ve yayın için **onay yok** (2026-10-19). Bu belge yalnız güncel
fiyat sunar.

**Kullanıcı kararı (2026-10-19):** değerlendirme için **senaryo A** seçildi (1k medium görsel +
gerekli sahnelerde kısa hareket; 3 örnek ≈17 kr, 18 video ≈55 kr). Bu bir **senaryo tercihi**dir,
harcama onayı değildir: üretime başlamadan önce 3 örnek için **ayrı bütçe onayı** alınır.

## 7. Gerçekleşen — 3 örnek (2026-10-19)

Kullanıcı 3 örnek için bütçe onayı verdi (2026-10-19). Ölçülen birim fiyatlarla harcama:

| Kalem | Adet | Birim | Kr |
|---|---:|---:|---:|
| Görsel — `gpt_image_2_5` 9:16 2k `low` | 12 | 0,50 | 6,00 |
| Görsel — CIN k3 yeniden üretim (hatalı el) | 1 | 0,50 | 0,50 |
| Hareket — `seedance_2_0_mini` 9:16 720p 5 sn (sessiz) | 2 | 5,00 | 10,00 |
| Ses — ElevenLabs (Sarah, `eleven_v3`, hız 0.9) | 220 karakter | — | 0,00* |
| **Toplam** | | | **16,50** |

\* ElevenLabs karakter aboneliği içinde (aylık ortak defter 9.631 → **9.851 / 10.000**); Higgsfield kredisi harcanmadı.

- Tahmin 17 kr idi; **16,50 kr** harcandı. Bakiye **298,06 → 281,56** (`higgsfield account status`).
- Plandan iki küçük sapma (toplam üst sınır korunarak): görseller **2k low** (0,50 kr; 1k medium ile
  aynı fiyat, daha yüksek çözünürlük), hareket **2 klip × 720p** (480p 720×1280'e yukarı ölçeklenirdi).
  Kitap reeli yalnız Ken Burns (hareket zorunlu değil kararı).
- **Ses** (2026-10-20): 9 satır, **220 karakter** (CIN 72 · SPO 77 · BOK 71), tek anlatıcı **Sarah**
  (`EXAVITQu4vr4xnSDxMaL`, `eleven_v3`, hız 0.9). Ortak defter 9.631 → **9.851 / 10.000**.
- **Süreler:** ses sığsın diye CIN son karesi 2,4 → 3,0 sn, BOK 2,3 → 3,3 sn (kesilen ses yok);
  paket süreleri **12,6 / 11,0 / 11,0 sn**, yükseklik ≈ −15,8 LUFS, tepe −5…−6 dBFS.
- 18 video için **harcama onayı yok**; güncel tahmin senaryo A ile ≈55 kr.

## 8. Gerçekleşen — kalan 15 video (2026-10-20)

Kullanıcı kalan **15 video** için bütçe onayı verdi (2026-10-20, ≈50 kr üst sınır).
Ölçülen birim fiyatlarla harcama:

| Kalem | Adet | Birim | Kr |
|---|---:|---:|---:|
| Görsel — `gpt_image_2_5` 9:16 2k `low` | 60 | 0,50 | 30,00 |
| Hareket — `seedance_2_0_mini` 9:16 720p 5 sn (sessiz) | 3 | 5,00 | 15,00 |
| Yeniden üretim | 0 | — | 0,00 |
| Ses — ElevenLabs | — | — | henüz yok (kota) |
| **Toplam** | | | **45,00** |

- Bakiye **281,56 → 236,56** (`higgsfield account status`, 2026-10-20).
- Tahmin ≈50 kr idi; **45,00 kr** harcandı (yeniden üretim gerekmedi). Onaylanan üst sınır korundu.
- Plandan sapma (üst sınır içinde): görseller **2k low** (0,50 kr; 1k medium ile aynı fiyat),
  hareket **720p 5 sn** (480p yerine; doğrudan 720×1280), Kitap reellerinde yalnız Ken Burns.
- **Klipler:** `A1-R-CIN-03` k2 (`cin-k2`), `A1-R-SPO-02` k3 (`spo-k3`), `A1-R-BOK-02` k3 (`bok-k3`).
- **Ses (engel):** 15 reelin metni **1.065 karakter** (18 video toplamı **1.285**). Aylık ortak
  defterde **9.851 / 10.000** dolu → kalan **149 karakter** yetmiyor. Ses, ay başında (veya ayrı
  hesapla) toplu üretilecek; paketler o zamana kadar **sessiz** kuruldu (süreler 11,9–13,4 sn).
  Önceki "≈3.300 karakter" tahmini yanlıştı; gerçek ölçüm 1.065.
- **Maliyet sonrası durum:** 3 örnek 16,50 + kalan 15 video 45,00 = **61,50 kr**; proje kredisi
  **236,56 kr**. Seslendirme Higgsfield kredisi harcamıyor (ElevenLabs karakter defteri).

## 9. Seslendirme — 15 video, ayrı hesap (2026-10-20)

Kullanıcı kararı: ana ElevenLabs kotası dolduğu için (9.851 / 10.000; kalan 149) ses **ayrı bir
hesapla** üretildi. Ana hesabın anahtarı ve defteri **değiştirilmedi**.

| | Değer |
|---|---|
| Hesap planı | **free**, 10.000 karakter/ay, 0 kullanılmış |
| Üretilen | **1.065 karakter / 45 cue** (15 video) |
| Defter | `kitaplar/_maliyet/elevenlabs-karakter-alt.json` → `{2026-10: 1065, 45}` |
| Ana defter | `kitaplar/_maliyet/elevenlabs-karakter.json` → **9.851 / 10.000 (değişmedi)** |
| Higgsfield kredisi | **harcanmadı** (236,56 kr) |
| Ses | Sarah `EXAVITQu4vr4xnSDxMaL`, `eleven_v3`, hız 0.9 (örneklerle aynı) |

- 18 video metni toplamı **1.285 karakter** (3 örnek 220 + kalan 15 video 1.065).
- **Kota ayrımı:** ayrı hesap kullanıldığı için `HIVELZON_TTS_LEDGER` ayrı dosyaya yönlendirildi;
  `tts_reel.py` ana defteri okumaz/yazmaz. Ayrıntı: `docs/REEL-PAKETI.md` §8.
- **Not (free plan):** ElevenLabs free planı ticari kullanımda atıf ister. Bu üretim **pilot/deneme**
  içindir; yayın öncesi ticari plana geçiş H-006 kapsamında değerlendirilir.
- **Sonuç:** 15 paket yeniden kuruldu (`ses=var`), `reel-lint` **18 reel · 0 hata · 0 uyarı**;
  `reel.audio.fit` hiçbir videoda tetiklenmedi (son kare uzatması gerekmedi).
