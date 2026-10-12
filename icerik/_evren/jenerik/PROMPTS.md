# Sezon 1 jeneriği: senaryo ve üretim kaydı (H-049)

- **Durum:** Taslak, maliyet onayı bekliyor
- **Karar:** Kullanıcı 2026-10-12, soru-cevap: 4 katmanlı açılış, jenerik bir kez üretilir, önce senaryo ve kareler.
- **Hedef süre:** tam sürüm ~10 sn (ilk izleme), kısa sürüm 2 sn + "Atla" (sonraki bölümler).
- **Biçim:** 9:16, 1080×1920'ye yerelde ölçeklenir. Yazılar yerelde (ImageMagick PNG) eklenir (kural 7). Köşede "Yapay zekâ ile üretilmiştir" yazısı bulunur.

## Senaryo

| Zaman | Görüntü | Ses | Kaynak |
|---|---|---|---|
| 0–3,5 sn | Masada eski telsiz, eller, yeşil ışık yanar; pencerede gün batımında fener | Cızırtı + uzaktan "Hello? … Can you hear me?" (B1 telsiz sesi) | **Var olan** `A1-001/clips/K-isik-seedance-mini.mp4`, kredisiz |
| 3,5–4 sn | Pencereden dışarı geçiş (0,35 sn xfade) | Müzik başlar | Yerel kurgu |
| 4–9 sn | Kamera iskeleden yükselip tepedeki fenere süzülür. Alex arkadan, telsiz elinde; Hi omzunun yanında parlıyor. Fener ışığı yanar ve döner. | Müzik yükselir | **Yeni:** Seedance 2.0 Mini, başlangıç J1, bitiş J2 |
| 9–10,5 sn | Son kare donar; "hiVelzon" ve "The Missing Signal · Sezon 1" yazıları belirir | Müzik biter, son bir cızırtı | Yerel kurgu |

## Prompt'lar

### J1: başlangıç karesi (GPT Image 2.5, 9:16, 2k, low; referanslar Alex + Hi + telsiz)
> Dusk at a small coastal harbour town. Wide shot from behind: a 19-year-old young woman with shoulder-length wavy brown hair, olive field jacket, jeans and backpack (the attached Alex reference) stands at the end of a stone pier holding an old green handheld radio with a short antenna (the attached radio reference). A small round softly glowing speech-bubble character with two friendly eyes (the attached Hi reference) floats beside her shoulder. Far away on a green hill above the town stands a white lighthouse, its lamp still dark. Fishing boats, warm windows lighting up, first stars in a deep orange-to-blue sky. Calm, mysterious, hopeful. Generous empty sky in the upper third. Warm animated-series illustration, graphic-novel style, clean ink lines, soft cel shading, coastal palette of sea blue, sand, lighthouse yellow and evening orange, mature tone suitable for teens and adults, not childish, no text, no letters, no numbers, no logos.

### J2: bitiş karesi (aynı ayarlar; referanslar Alex + Hi)
> Blue hour. The white lighthouse on a green hill above a small coastal town, seen from slightly below and closer; its lamp is now lit and a soft beam sweeps across the sky. On the winding path below, two tiny figures: the young woman with the radio (attached Alex reference, seen from behind, very small) and the small glowing speech-bubble character (attached Hi reference) beside her. Sea and harbour lights below. Large calm empty sky in the upper half for a title. Warm animated-series illustration, graphic-novel style, clean ink lines, soft cel shading, coastal palette of sea blue, sand, lighthouse yellow and evening orange, mature tone suitable for teens and adults, not childish, no text, no letters, no numbers, no logos.

### V1: hareket (Seedance 2.0 Mini, 5 sn, 9:16, 720p, başlangıç J1, bitiş J2, ses kapalı)
> Smooth cinematic crane shot: the camera slowly rises from behind the young woman on the pier and glides up over the harbour toward the lighthouse on the hill; town windows twinkle, gentle waves, the glowing bubble companion bobs softly; at the end the lighthouse lamp switches on and its beam begins to sweep. Consistent illustrated graphic-novel style, no text, no new characters, no morphing.

### M1: müzik (Seed Audio 1.0, ~10 sn)
> Short warm cinematic opening theme for an animated mystery series, 10 seconds: soft plucked guitar and light strings, a subtle radio-static texture at the start, gentle build to a hopeful resolved chord at the end; no vocals.

## Maliyet (tahmin, `generate cost` ile, 2026-10-12)

| Öğe | Kredi |
|---|---|
| J1 + J2 (2 × 0,5) | 1,0 |
| V1 Seedance 2.0 Mini 5 sn | 5,0 |
| M1 Seed Audio | 0,4 |
| **Toplam** | **6,4** (kalan 92,25 → 85,85) |

İlk tahmin (2 klip) 10,4 krediydi. Var olan telsiz ışığı klibi yeniden kullanıldığı için 4 kredi daha az.

## Üretim kaydı
| Öğe | Tarih | Job | Kredi (tahmin/gerçek) | Dosya | Onay | Değerlendirme |
|---|---|---|---|---|---|---|
| J1 | 2026-10-12 | 13aa3116-2a15-4eed-9a50-dcfff660fa2d | 0,5 / 0,5 | `J1.png` (git dışı) | Kullanıcı "sana onay verdim" (önce kareler) | ✅ Alex arkadan, telsiz ve Hi tutarlı; fener ışığı hafif yanık görünüyor (istenen: sönük) |
| J2 | 2026-10-12 | 94964393-6b1a-477f-8403-576eb47dd063 | 0,5 / 0,5 | `J2.png` (git dışı) | aynı | ✅ Fener ışığı yanmış ve hüzme var; üstte başlık boşluğu; yolda Alex ve Hi |

| V1 | 2026-10-12 | 603ee7d8-a638-426f-89f7-928f9a2985d3 | 5 / 5 | `V1.mp4` 720×1280, 5,04 sn (git dışı) | Kullanıcı "onay" (5,4 kr) | ✅ Alex iskeleden yürüyüp fener yoluna çıkıyor, Hi yanında; sonda fener ışığı ve hüzme. Ortada (~2,8 sn) fener kısa süre kadraj dışında. |
| M1 | 2026-10-12 | 465f0245-2890-4283-b533-1d7f7ac80c8e | 0,4 / 0 | — | aynı | ❌ Seed Audio işi `failed`, kredi düşülmedi (konuşma odaklı model; müzik isteğini üretmedi). |

Kredi: 92,25 → 91,25 → 86,25.

**Kurgu:** `kurgu.py` (yerel). Müzik yokken geçici sentetik akor kullanılır. Çıktılar: `_build/jenerik-tam.mp4` (10,27 sn, -16,1 LUFS, tepe -1,5 dBFS), `_build/jenerik-kisa.mp4` (2,03 sn, -16,0 LUFS).
