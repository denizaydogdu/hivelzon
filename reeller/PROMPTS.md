# Reel örnekleri — istem ve üretim kayıtları (H-094, 3 örnek)

> Kapsam: **3 örnek video** (kategori başına 1): `A1-R-CIN-01` (Sinema),
> `A1-R-SPO-01` (Spor), `A1-R-BOK-01` (Kitap). Metinleri ve lint'i hazır A1 paketlerinden.
> **Onay:** kullanıcı, 2026-10-19, senaryo A (≈17 kr) — 3 örnek için. Her ücretli çağrıdan
> önce `higgsfield generate cost` ile maliyet doğrulanır; her prompt buraya yazılır (H-024).

## Görsel dil

App'in kilitli story-stil öneki (`icerik/_evren/style/STYLE_PREFIX.md`, K-24 v1.1) ile **aynı dil**
kullanılır (uygulama içi tutarlılık). Reel sahneleri çağdaş ve "gündelik" olduğu için palet satırı
sahneye bırakılmıştır; geri kalan dil (graphic-novel illüstrasyon, temiz çizgi, yumuşak cel shading,
genç/Yetişkin tonu) aynen korunur.

**Önek (her prompt'un sonuna eklenir):**
`Warm animated-series illustration, graphic-novel style, clean ink lines, soft cel shading, warm everyday palette with soft natural light, mature tone suitable for teens and adults, not childish, no text, no letters, no numbers, no logos.`

**Format:** 9:16, **2k**, `gpt_image_2_5`, `quality low` = **0,5 kr/görsel**
(ölçüm 2026-10-19: 2k low = 0,50 kr; `quality low` pilot için yeterli bulunmuştu, H-024 pilot notu).
**Yazı yok:** tabela, bilet, kitap sırtı, afiş, şişe etiketi, forma numarası — hepsi **yazısız/rakamsız**
çizilir; gereken metin kurguda eklenir.

**Tutarlılık yöntemi:** her reelde önce **k1** üretilir; k2–k4 bu karenin `image_references`'ı ile
üretilir (kitap dalgalarındaki "kapak referansı" yöntemi). Ayrı karakter sayfası gerekmez.

## Karakterler ve mekânlar (özgün; gerçek marka/kişi yok)

### Sinema — `A1-R-CIN-01` "Gişede iki bilet"
- **Mia:** young woman, 20, dark curly hair in a low bun, mustard-yellow jacket over a white shirt, small canvas tote bag; friendly, slightly hesitant.
- **Clerk:** woman, early 30s, black hair in a low bun, navy uniform shirt with a plain round badge (blank, no letters), warm smile.
- **Mekân:** small independent cinema lobby, evening: warm brass wall lamps, a wooden box-office counter with a glass front, a red velvet rope, dark green walls, framed posters that are **completely blank** (abstract shapes only).

### Spor — `A1-R-SPO-01` "Antrenmandan sonra su"
- **Elif:** girl, 15, dark hair in a high ponytail, navy school sports kit with a **plain, number-free** back, running shoes; tired but cheerful.
- **Coach:** man, mid-40s, short grey-flecked hair, light grey polo, sweatpants, plain whistle on a cord (no letters), clipboard held at his hip, kind expression.
- **Mekân:** school athletics track, late afternoon: red running lane with white lines, low green fence, sports field and a few trees, warm low sun, distant school building with a plain blank wall.

### Kitap — `A1-R-BOK-01` "Kütüphanede kitap seçimi"
- **Lena:** young woman, 22, light brown curly hair tied back, olive-green cardigan, small round glasses; curious.
- **Librarian:** woman, mid-50s, short silver hair, brown cardigan with a plain round pin (blank), reading glasses on a cord, warm smile.
- **Mekân:** small neighbourhood library, soft daylight: tall wooden shelves with **blank-spined** books (no readable titles), a reading table with a green lamp, a window with day light, a wooden desk.

## Sahne planı (video başına 4 kare)

### Sinema (12 sn; replikler 0,6–3,0 · 3,6–6,4 · 7,2–10,4)
| Kare | Zaman | Sahne (prompt gövdesi; önek eklenir) |
|---|---|---|
| k1 (referans) | 0,0–3,0 | Wide shot of a small cinema lobby in the evening. Mia, in her mustard-yellow jacket, walks up to the wooden box-office counter, seen from the side; behind the counter the clerk in a navy uniform looks up with a friendly smile. Warm brass wall lamps glow; the framed posters on the green wall are completely blank. Vertical composition. |
| k2 | 3,0–6,4 | Medium shot across the counter: Mia leans slightly forward and speaks, one hand on the counter; the clerk listens, head tilted. Warm lamp light on their faces, blurred blank posters behind. Vertical composition. |
| k3 | 6,4–7,2 | Close-up of the counter top: the clerk's hand slides **two plain blank cinema tickets** across the wood toward Mia's open palm; a small brass bell and a blank ticket roll nearby. Shallow depth of field. Vertical composition. |
| k4 | 7,2–10,4 | The clerk smiles and gestures toward an open doorway with a red velvet rope; Mia holds the two tickets and turns to go, looking back with a happy nod. Warm lobby light, blank posters behind. Vertical composition. (**Hareketli kare**, 720p) |

### Spor (11 sn; replikler 0,6–3,2 · 4,0–6,6 · 7,2–9,6)
| Kare | Zaman | Sahne (prompt gövdesi; önek eklenir) |
|---|---|---|
| k1 (referans) | 0,0–3,2 | Wide shot on a school athletics track in warm late-afternoon light. Elif in a plain navy sports kit finishes a run in the red lane, breathing hard, while the coach with a clipboard watches from the side and nods. Low sun, long shadows, green fence and field behind. Vertical composition. (**Hareketli kare**, 720p) |
| k2 | 3,2–6,0 | Medium shot: Elif stands on the track, hands on her knees, catching her breath; she looks up toward the coach with a small tired smile. Warm backlight on the track. Vertical composition. |
| k3 | 6,0–7,2 | Medium close-up: Elif straightens up and asks, one hand raised slightly; the coach, slightly out of focus behind her, turns to listen. Soft warm light. Vertical composition. |
| k4 | 7,2–9,6 | The coach hands Elif a **plain, label-free** water bottle; she takes it with both hands, grateful and relieved. Track and green field blurred behind them in golden light. Vertical composition. |

### Kitap (10 sn; replikler 0,6–3,0 · 3,8–5,6 · 6,4–8,6)
| Kare | Zaman | Sahne (prompt gövdesi; önek eklenir) |
|---|---|---|
| k1 (referans) | 0,0–3,0 | Wide shot inside a small neighbourhood library in soft daylight. Lena in her olive-green cardigan and round glasses stands at the wooden desk, one hand on the counter; the librarian in a brown cardigan looks up from behind the desk. Tall shelves with completely blank book spines behind them; a green reading lamp on the desk. Vertical composition. |
| k2 | 3,0–6,0 | Medium shot across the desk: Lena asks, leaning in slightly, eyebrows raised in a hopeful question; the librarian listens with a patient smile. Soft window light, blurred blank spines behind. Vertical composition. |
| k3 | 6,0–7,0 | Close-up of the librarian's hands lifting a **plain, titleless hardcover book** from a low shelf and turning it so the blank cover faces Lena; another blank book lies open on the desk. Shallow depth of field, warm light. Vertical composition. |
| k4 | 7,0–9,0 | The librarian holds the book out with a warm smile; Lena takes it with both hands and opens it, already reading, pleased. Blank spines and the green lamp behind, soft daylight. Vertical composition. |

## Maliyet (ölçüldü 2026-10-19; **gerçekleşen**)

| Kalem | Adet | Birim | Plan | Gerçekleşen |
|---|---|---|---|---|
| Görsel `gpt_image_2_5` 9:16 2k low | 12 | 0,50 | 6,00 | **6,00** |
| Görsel yeniden üretim (CIN k3 — hatalı el) | 1 | 0,50 | — | **0,50** |
| Hareket `seedance_2_0_mini` 9:16 720p 5 sn (sessiz) | 2 | 5,00 | 10,00 | **10,00** |
| Ken Burns, poster, kurgu, paketleme, lint | — | yerel | 0 | 0 |
| **Kredi toplamı (3 örnek)** | | | ≈16 | **16,50** |
| Ses (ElevenLabs, tek anlatıcı Sarah) | 9 cue | — | ~350 karakter | **220 karakter** (ölçüldü, henüz üretilmedi) |

**Senaryo A'dan iki küçük sapma (üst sınır korundu):** (1) görseller **2k low** (0,50 kr — plan da
"quality low" varsayıyordu; Ken Burns için 1k'dan yüksek çözünürlük); (2) hareket klibi 480p yerine
**720p** (480p dikey kare 720×1280'e yukarı ölçeklenirdi) ve **2 klip** yeterli görüldü.
Ek: CIN k3 ilk üretiminde kadın görevli yerine **takım elbiseli bir erkek eli** çıktı → yeniden
üretildi (+0,50 kr). Toplam **16,50 kr ≤ 17 kr**; bakiye içinde.

## Üretim kaydı — görseller (13 çağrı · 6,50 kr)

Her kare `gpt_image_2_5`, 9:16, 2k, quality low, önek eklenmiş istemle; k2–k4 **k1 referansıyla**.

| Reel | Kare | Ref | Kredi | Job ID | sha256(16) |
|---|---|---|---|---|---|
| CIN | k1 | — | 0,50 | `575587d6-445e-409f-b38f-e4267526c7ef` | 53259d954981f7d1 |
| CIN | k2 | k1 | 0,50 | `5566835e-1e75-4890-9fa7-0516cc0661c0` | f4c6cb46148c88b5 |
| CIN | k3 *(elenen)* | k1 | 0,50 | `cb0f80f9-6c75-44bb-9c42-7fe3c8e215bc` | — (erkek el) |
| CIN | **k3** | k1 | 0,50 | `56aade24-8224-420e-b02b-98ef581c2b06` | 4e2b9d49d50f2700 |
| CIN | k4 | k1 | 0,50 | `adf29c9f-0dc9-41c9-9964-98f875e0cc7f` | b1ef9aae43e8695e |
| SPO | k1 | — | 0,50 | `264fabde-d7c6-4d64-b300-e61a05143d94` | a9c7ad9cdbee9a27 |
| SPO | k2 | k1 | 0,50 | `d531ab84-71b9-456c-8780-da3bd9afc3f3` | 9b2f83dd7f20ded2 |
| SPO | k3 | k1 | 0,50 | `f6031cb7-d065-494c-a765-801104ae9afc` | 844a9a64d88a78df |
| SPO | k4 | k1 | 0,50 | `1990b1f1-b6af-427a-a10d-930fc4a1a4fb` | 778da062a0623164 |
| BOK | k1 | — | 0,50 | `191c2ca9-7482-4142-a42f-da1e05c7ba6e` | 8beba0a6b95f0eda |
| BOK | k2 | k1 | 0,50 | `9768520f-5a20-470d-84d2-1e25b8720e5d` | 76b9687aec56161f |
| BOK | k3 | k1 | 0,50 | `a5c0c0b6-fdd4-469c-b9d8-c71b6c6dd52c` | 70628ac46d4170c5 |
| BOK | k4 | k1 | 0,50 | `ec12e00e-6013-4af7-81d9-5a4893877ffd` | 6f20f79512ac6a1a |

## Üretim kaydı — hareket (2 çağrı · 10,00 kr)

`seedance_2_0_mini`, 9:16, 720p, 5 sn, **ses yok** (`generate_audio: false`), başlangıç karesi verilerek.

| Reel | Klip | Başlangıç | Kredi | Job ID |
|---|---|---|---|---|
| CIN | `cin-k3` (bilet kayışı) | k3 | 5,00 | `12407561-f9a0-4d61-bd4f-e4455b2645ef` |
| SPO | `spo-k1` (koşu) | k1 | 5,00 | `45b29cf9-3e58-4d63-9b38-c5ead6baa21e` |

**Kredi:** 298,06 → **281,56** (16,50 kr kullanıldı; ölçüm `higgsfield account status` ile teyit edilir).
**Değerlendirme (kendi kontrolüm):** üç reelde karakter/renk/mekân tutarlı; **görselde yazı yok**
(bilet, kitap sırtı, afiş, rozet, şişe etiketi hepsi yazısız); CIN klibi yüzsüz bir kayış olduğu için
bozulma riski taşımıyor. **Öncelikli insan değerlendirmesi:** CIN: Mia'nın saçı (topuz) metinde
"shoulder-length" yazıyordu — sheet gerçek tasarıma göre güncellenmeli; BOK k3: kitap **kapak** rengi
koyu yeşil, "double" olmasın; SPO: forma rengi lacivert ✓.

## Montaj (yerel, 0 kr)

- `tools/content-pipeline/build_reel.py` → `_build/package/`: `<id>.mp4` (**720×1280**, H.264/AAC,
  faststart), `<id>.webp` (afiş), `stills/<sahne>.webp` (Defter kartı), `audio/<cue>.m4a` (varsa),
  `production.json` (job kimlikleri, kredi, sha, aiLabel).
- Kurgu `shots.json → timeline`'dan: 4 kare, 0,3 sn xfade, Ken Burns; klip varsa oynatılır.
- **Ses henüz yok:** mp4 sessiz (görüntülü önizleme). Ses gelince `build_reel.py <reel> --force`.

## Ses (ElevenLabs) — araç hazır, **anahtar bekliyor**

- Araç: `tools/content-pipeline/tts_reel.py` (kuru çalışma karakter sayısını verir; `--execute` ile üretir;
  aylık tavan + **ortak** defter `kitaplar/_maliyet/elevenlabs-karakter.json`; metin sha ile idempotent).
- Ses **Sarah** (`EXAVITQu4vr4xnSDxMaL`), model `eleven_v3`, hız 0.9 — uygulamadaki anlatıcıyla aynı
  (tek anlatıcı; konuşmacı başına ayrı ses pilot dışı).
- Ölçüm: CIN 72 · SPO 77 · BOK 71 = **220 karakter** (3 örnek); ortak defter **9.851 / 10.000**.
- Süreler (`_raw/tts/timing.json`): CIN 1,92 / 1,20 / 2,16 sn · SPO 2,00 / 1,68 / 1,52 sn · BOK 2,08 / 1,60 / 2,48 sn.
  Ses sığsın diye CIN son karesi 3,0 sn, BOK son karesi 3,3 sn (paketler **12,6 / 11,0 / 11,0 sn**);
  `build_reel.py` cue ve kelime zamanlarını bu sürelerle yeniden hizaladı.
- Reel sesi cue bazında kesilir: `audio/<cue>.m4a` (hedef ifadenin sesi Defter'e giden kayıt).

## Seslendirme kayıtları (tts_reel.py)

> 2026-10-20T13:38Z sonrası satırlar **ayrı ElevenLabs hesabıyla** üretildi (free plan, 10.000
> karakter); ana hesabın ortak defteri (9.851 / 10.000) değişmedi. Ses aynı: Sarah `eleven_v3` 0.9.

| Tarih (UTC) | Reel | Cue | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-20T09:45:19Z | A1-R-CIN-01 | s02-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | e43e5a36e61f0482 | _raw/tts/s02-01.mp3 |
| 2026-10-20T09:45:20Z | A1-R-CIN-01 | s02-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | edf9e9dd175b3d7b | _raw/tts/s02-02.mp3 |
| 2026-10-20T09:45:22Z | A1-R-CIN-01 | s02-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 60b07e029737a6c9 | _raw/tts/s02-03.mp3 |
| 2026-10-20T09:45:24Z | A1-R-SPO-01 | s01-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | eeae57bc52d11503 | _raw/tts/s01-01.mp3 |
| 2026-10-20T09:45:25Z | A1-R-SPO-01 | s01-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | e11a23aa1fc36c58 | _raw/tts/s01-02.mp3 |
| 2026-10-20T09:45:28Z | A1-R-SPO-01 | s01-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | 8e38acd7b1fc75a2 | _raw/tts/s01-03.mp3 |
| 2026-10-20T09:45:30Z | A1-R-BOK-01 | s02-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 58c6107274925909 | _raw/tts/s02-01.mp3 |
| 2026-10-20T09:45:31Z | A1-R-BOK-01 | s02-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 586dd5da51eb7cc8 | _raw/tts/s02-02.mp3 |
| 2026-10-20T09:45:33Z | A1-R-BOK-01 | s02-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | f6ebf1b3fd870cda | _raw/tts/s02-03.mp3 |

## Pilot 18 video — kalan 15'in sahne kaydı (2026-10-20)

Onay: kullanıcı, 2026-10-20, kalan 15 video ≈50 kr (60 görsel + 3 klip + yeniden üretim payı).
Aşağıdaki istemler `shots.json` içinde **aynen** durur; önek yukarıdakiyle aynıdır (görselde yazı yok).
Tutarlılık: **k1** referans, k2–k4 `ref: k1`.

### Sinema

**A1-R-CIN-02 "Salonda yer arıyor"** — *Mia + usher (25, siyah polo, el feneri); küçük sinema salonu, kırmızı koltuklar, yazısız perde.*
k1 koridorda Mia elinde yazısız bilet, usher yanında · k2 Mia "koltugum nerede?" diye sorar · k3 usher el feneriyle sırayı gösterir · k4 Mia sıraya geçip oturur, rahatlar.

**A1-R-CIN-03 "Atıştırmalık alıyor"** — *Mia + snack clerk (30, kırmızı önlük); sinema büfe, yazısız ürünler, mısır makinesi.*
k1 Mia büfede, clerk gülümser · **k2 (klip `cin-k2`)** mısır yazısız kutuya dolar · k3 Mia en küçük boyu işaret eder · k4 clerk kutuyu uzatır.

**A2-R-CIN-02 "Tür seçimi"** — *Selin (22, uzun koyu saç, zeytin yeşili palto) + Deniz (24, kısa saç, yuvarlak gözlük, kot ceket); sinema lobisi, yazısız afişler.*
k1 ikisi afişlerin önünde · k2 Selin sorar · k3 Deniz hevesle anlatır · k4 Selin bir afişi işaret eder, salona yürürler.

**A2-R-CIN-03 "Akşam planı"** — *Selin + Deniz; küçük mutfak ve oturma odası, sıcak akşam ışığı.*
k1 mutfakta çay/telefon · k2 Deniz "bu akşam boş musun?" · k3 Selin sevinçle kabul eder · k4 oturma odasında battaniye ve atıştırmalık hazırlığı.

### Spor

**A1-R-SPO-02 "Sahada arkadaş"** — *Elif (15, at kuyruğu, numarasız lacivert forma) + Mert (16, aynı forma); okul sahası, sıcak ikindi.*
k1 Elif topu ayağında, Mert sol kanatta el sallar · k2 Mert bekler, Elif ölçer · **k3 (klip `spo-k3`)** ayağın topla buluşması · k4 Mert topu kontrol eder, teşekkür eder.

**A1-R-SPO-03 "Tribünde"** — *Elif + spectator (30, pas rengi atkı); küçük okul stadyumu, tribün.*
k1 şut ve kaleci · k2 Elif sevinçle bağırır · k3 takım golcüye koşar · k4 Elif ve spectator birlikte alkışlar.

**A2-R-SPO-02 "Antrenman günü"** — *Coach (45) + Mert; antrenman sahası, koniler, alçak güneş.*
k1 koniler ve ikili sohbet · k2 coach sorar · k3 Mert parmaklarıyla sayarak anlatır · k4 coach not alır, Mert konilere koşar.

**A2-R-SPO-03 "Sonuç ve duygu"** — *Elif + Mert; maç sonrası saha kenarı, bank, akşam ışığı.*
k1 Mert bankta ayakkabı bağlar · k2 Elif skoru sorar · k3 Mert gülümseyerek "kaybettik ama eğlenceliydi" · k4 yumruk tokuşturup ayrılırlar.

### Kitap

**A1-R-BOK-02 "Beğeni"** — *Lena (22, gözlük, zeytin yeşili hırka) + Kerem (24, gri kapüşonlu, sırt çantası); mahalle kütüphanesi, yazısız sırtlar.*
k1 masada açık yazısız kitap · k2 Kerem sorar · **k3 (klip `bok-k3`)** kitap masada kayar · k4 Lena sayfaya dokunur, Kerem okumaya başlar.

**A1-R-BOK-03 "Sessizlik ricası"** — *Lena + Kerem; sessiz okuma odası, yeşil masa lambaları.*
k1 Kerem telefonu kaldırır (utanç) · k2 özür diler · k3 Lena kibarca "sessiz ol" der · k4 Kerem telefonu cebine koyar, okumaya döner.

**A2-R-BOK-02 "Konu anlatma"** — *Lena + Kerem; aynı kütüphane, öğleden sonra.*
k1 Kerem sandalyeyi çeker · k2 "kitabın ne hakkında?" · k3 Lena eliyle denizi işaret eder gibi anlatır · k4 kitabı çevirip Kerem'e uzatır.

**A2-R-BOK-03 "Öneri"** — *Lena + Kerem; iade bankosu, öğleden sonra.*
k1 Kerem kitabı iade eder · k2 "okuyacak bir şey arıyorum" · k3 Lena yazısız kapağı iki kez tıklar · k4 Kerem kitabı alır, teşekkür eder.

**Klip özeti (3 adet, 720p 5 sn, ses yok):** `cin-k2` (mısır), `spo-k3` (top), `bok-k3` (kitap).
| 2026-10-20T13:36:28Z | A1-R-BOK-03 | s02-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 8b4694d632895a5b | _raw/tts/s02-01.mp3 |
| 2026-10-20T13:36:29Z | A1-R-BOK-03 | s02-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 90b07aaa23f048fa | _raw/tts/s02-02.mp3 |
| 2026-10-20T13:36:31Z | A1-R-BOK-03 | s02-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 692b09ab2998cd6e | _raw/tts/s02-03.mp3 |
| 2026-10-20T13:37:35Z | A1-R-BOK-02 | s01-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 8dcdcb3b7f4b3d2f | _raw/tts/s01-01.mp3 |
| 2026-10-20T13:37:37Z | A1-R-BOK-02 | s01-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 736eaa02ed24fe5c | _raw/tts/s01-02.mp3 |
| 2026-10-20T13:37:38Z | A1-R-BOK-02 | s01-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 18 | 6ce581032e9d3f86 | _raw/tts/s01-03.mp3 |
| 2026-10-20T13:37:42Z | A1-R-CIN-02 | s01-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | c41338bbcb34e018 | _raw/tts/s01-01.mp3 |
| 2026-10-20T13:37:43Z | A1-R-CIN-02 | s01-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 8e0c8f94781c9637 | _raw/tts/s01-02.mp3 |
| 2026-10-20T13:37:45Z | A1-R-CIN-02 | s01-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | b085a6b76fcc7bb4 | _raw/tts/s01-03.mp3 |
| 2026-10-20T13:37:46Z | A1-R-CIN-03 | s02-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | c2c8f141d8d18e50 | _raw/tts/s02-01.mp3 |
| 2026-10-20T13:37:48Z | A1-R-CIN-03 | s02-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | a9d4abe5f154124c | _raw/tts/s02-02.mp3 |
| 2026-10-20T13:37:49Z | A1-R-CIN-03 | s02-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 84ba7c226f4fd084 | _raw/tts/s02-03.mp3 |
| 2026-10-20T13:37:51Z | A1-R-SPO-02 | s01-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 08a4181d21ca2bfb | _raw/tts/s01-01.mp3 |
| 2026-10-20T13:37:52Z | A1-R-SPO-02 | s01-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | c43a6ab104656330 | _raw/tts/s01-02.mp3 |
| 2026-10-20T13:37:54Z | A1-R-SPO-02 | s01-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 12 | 01ded3fbc9ba4b98 | _raw/tts/s01-03.mp3 |
| 2026-10-20T13:37:55Z | A1-R-SPO-03 | s02-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 10 | 962643e35935ccc6 | _raw/tts/s02-01.mp3 |
| 2026-10-20T13:37:57Z | A1-R-SPO-03 | s02-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 11 | 4d63084cb98e8774 | _raw/tts/s02-02.mp3 |
| 2026-10-20T13:37:58Z | A1-R-SPO-03 | s02-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | da0f6b19721ef1ec | _raw/tts/s02-03.mp3 |
| 2026-10-20T13:38:00Z | A2-R-BOK-01 | s04-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | f5956af5e0a691ac | _raw/tts/s04-01.mp3 |
| 2026-10-20T13:38:01Z | A2-R-BOK-01 | s04-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 32 | 320d37ddf3624d41 | _raw/tts/s04-02.mp3 |
| 2026-10-20T13:38:03Z | A2-R-BOK-01 | s04-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 42 | 63883c10a31dbcdc | _raw/tts/s04-03.mp3 |
| 2026-10-20T13:38:04Z | A2-R-BOK-02 | s03-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | d5cc06ca4315cad7 | _raw/tts/s03-01.mp3 |
| 2026-10-20T13:38:06Z | A2-R-BOK-02 | s03-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 35 | bae19478f229fee3 | _raw/tts/s03-02.mp3 |
| 2026-10-20T13:38:07Z | A2-R-BOK-02 | s03-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | fee1a39c8e1f584d | _raw/tts/s03-03.mp3 |
| 2026-10-20T13:38:09Z | A2-R-BOK-03 | s04-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 26b2d45685ff3d1c | _raw/tts/s04-01.mp3 |
| 2026-10-20T13:38:10Z | A2-R-BOK-03 | s04-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 26 | 8990bca8d8f473b6 | _raw/tts/s04-02.mp3 |
| 2026-10-20T13:38:11Z | A2-R-BOK-03 | s04-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 20 | 3ac23c49226e9004 | _raw/tts/s04-03.mp3 |
| 2026-10-20T13:38:13Z | A2-R-CIN-01 | s03-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 30 | 87aa3db0df63a131 | _raw/tts/s03-01.mp3 |
| 2026-10-20T13:38:14Z | A2-R-CIN-01 | s03-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 31 | fb1f9316f3bef291 | _raw/tts/s03-02.mp3 |
| 2026-10-20T13:38:16Z | A2-R-CIN-01 | s03-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 42 | 29d91578e51534d7 | _raw/tts/s03-03.mp3 |
| 2026-10-20T13:38:17Z | A2-R-CIN-02 | s03-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 31 | eacedaf248728301 | _raw/tts/s03-01.mp3 |
| 2026-10-20T13:38:19Z | A2-R-CIN-02 | s03-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 42e0f48a71cba569 | _raw/tts/s03-02.mp3 |
| 2026-10-20T13:38:20Z | A2-R-CIN-02 | s03-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 37 | d051c9f8380efdbc | _raw/tts/s03-03.mp3 |
| 2026-10-20T13:38:22Z | A2-R-CIN-03 | s04-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | 79779b14c1e7739f | _raw/tts/s04-01.mp3 |
| 2026-10-20T13:38:23Z | A2-R-CIN-03 | s04-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 32 | 720168f0535bb39d | _raw/tts/s04-02.mp3 |
| 2026-10-20T13:38:25Z | A2-R-CIN-03 | s04-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 772302b796938cfb | _raw/tts/s04-03.mp3 |
| 2026-10-20T13:38:27Z | A2-R-SPO-01 | s01-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 1ba2f13c0f540f99 | _raw/tts/s01-01.mp3 |
| 2026-10-20T13:38:28Z | A2-R-SPO-01 | s01-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 56c7041cb2d571a8 | _raw/tts/s01-02.mp3 |
| 2026-10-20T13:38:30Z | A2-R-SPO-01 | s01-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 27 | f6519d87be505908 | _raw/tts/s01-03.mp3 |
| 2026-10-20T13:38:31Z | A2-R-SPO-02 | s03-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 23 | 632315de6c7eb44b | _raw/tts/s03-01.mp3 |
| 2026-10-20T13:38:33Z | A2-R-SPO-02 | s03-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | 3609d305a413bd43 | _raw/tts/s03-02.mp3 |
| 2026-10-20T13:38:34Z | A2-R-SPO-02 | s03-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 22 | b4900e4ab6cdcaa2 | _raw/tts/s03-03.mp3 |
| 2026-10-20T13:38:36Z | A2-R-SPO-03 | s04-01 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | f4db0b1f1ac3572e | _raw/tts/s04-01.mp3 |
| 2026-10-20T13:38:37Z | A2-R-SPO-03 | s04-02 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | cb9463d126f29c09 | _raw/tts/s04-02.mp3 |
| 2026-10-20T13:38:39Z | A2-R-SPO-03 | s04-03 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 7f35f4af81d2248d | _raw/tts/s04-03.mp3 |
