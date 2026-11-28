# PROMPTS: A1-005-too-late (üretim, 2026-10-14, H-085)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low. Maliyet önce `higgsfield generate cost` ile ölçüldü: görsel başına 0,5 kr (tahmin = gerçek).
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; saatler ("6:40 pm", "7:20 pm"), otobüs tarifesi ve haritadaki "Maya" kurguda (`signs`) eklenir.
- **Kullanıcı onayı:** H-085 görevi (kullanıcı 500 kr yükledi ve bekleyen işleri onayladı; bu iş için tavan 20 kr).
- **Referanslar:** Alex `663ea0fe…` (R1), telsiz `74fb45e8…` (R3), **Jordan `185195f6…` (R5, yeni)**, **ses kaydedici `72e65920…` (R6, yeni)**; mekân için B1 odası (job `6d48f511…`, T1-oda) ve B3 limanı (job `acc2c480…`, B3-05-liman). Kayıt: `_evren/style/PROMPTS.md`.
- **Ders (B4-01) uygulandı:** Birden çok karakterli her sahnede kıyafetler açıkça yazıldı: Jordan turuncu kurye ceketi + gri kask ("NOT an olive jacket"), Alex zeytin yeşili ceket + krem kazak + kanvas çanta.
- **Kilit an (Seedance):** Yok. Sezon planında B5'te ★ işaretli an yok (`content.json` → `realClips: 0`); ücretli klip üretilmedi.
- **Kredi (hesap, `higgsfield account status`):** başlangıç 484,56 → bitiş 451,56. Bu işin harcaması **8 kr** (16 iş × 0,5). Aradaki fark aynı hesabı kullanan başka oturumların işleri (job listesinde görüldü).

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B5-01-oda-cuma | Alex, telsiz, T1-oda | 0,5 | 611c3105-5b09-483b-9d68-3314f3082cef | Use the reference images for Alex, the old radio and Alex's small rented room. Scene: early Friday evening in Alex's small room; warm orange light through the window; a paper wall calendar with blank squares and no numbers; a round wall clock without any numbers; Alex, in her olive jacket over a cream sweater and jeans, swings her canvas backpack onto her shoulder, the old radio clearly visible in the backpack's side pocket; determined, excited expression, heading for the door. Vertical composition. |
| B5-02-durak-bekleme | Alex, B3-05-liman | 0,5 | 05d6176e-c132-4f59-8563-ac4385f18b35 | Use the reference images for Alex and the small harbour. Scene: early evening at the small bus stop shelter in front of the harbour café; long golden-orange shadows; the road is empty, no bus; a blank timetable board on the shelter with no writing at all; Alex (olive jacket, cream sweater, jeans, canvas backpack) stands at the stop tapping one foot impatiently, looking down the empty road, worried. Vertical composition. |
| B5-03-otobus-geliyor | Alex | 0,5 | 5627ced4-2fc8-4fbe-9288-75e8a491e6ec | Use the reference image for Alex. Scene: dusk at a harbour-side bus stop; a small local bus finally arrives with its headlights on and its door open; Alex (olive jacket, cream sweater, jeans, canvas backpack) runs toward the open door in a hurry, hair moving. The bus has a blank destination display with no text and no numbers. Vertical composition. |
| B5-04-pier3-bos | Alex, Jordan | 0,5 | 681ad5ff-740b-433b-9afb-02f8fcf61526 | Use the reference images for Alex and Jordan. Scene: evening at a quiet harbour pier; harbour lamps already on, deep blue sky with a last orange glow; a small fish shop with lit windows still open in the background; boats on calm water; the pier is empty. Alex is seen from behind in the foreground (olive jacket, canvas backpack with the old radio in the side pocket), calling out softly. Further away beside a bench, Jordan the bicycle courier (bright orange courier jacket with grey reflective stripes, dark grey helmet, NOT an olive jacket) stands next to his bicycle holding a small parcel, half turned away. No text on any sign. Vertical composition. |
| B5-05-jordan-telsiz | Jordan, Alex, telsiz | 0,5 | 5a08aa19-2fb2-41e2-9651-391daf065aa5 | Use the reference images for Jordan, Alex and the old radio. Scene: evening on the harbour pier under a lamp; Jordan (bright orange courier jacket with grey reflective stripes, dark grey helmet, holding a parcel; NOT an olive jacket) turns toward Alex with a big curious smile and points at the old radio sticking out of the side pocket of Alex's canvas backpack; Alex (olive jacket, cream sweater, jeans) looks a little surprised and shy. Vertical composition. |
| B5-06-k1-pov | Jordan | 0,5 | 8dd79780-1d23-4d46-bf3a-8126e849c39b | Use the reference image for Jordan. Scene: first-person point of view from Alex: Jordan the bicycle courier (bright orange courier jacket with grey reflective stripes, dark grey helmet) stands on the evening harbour pier facing the viewer, eyebrows raised, a teasing but friendly grin, one hand open in a playful 'you are late' gesture; harbour lamps and boats softly blurred behind. Calm, slightly muted mood. Vertical composition. |
| B5-07-tanisma | Jordan, Alex | 0,5 | 9cd5ed34-668d-4ec3-95a6-4758fbe5439a | Use the reference images for Jordan and Alex. Scene: evening on the harbour pier under warm lamp light; Jordan and Alex shake hands and smile; Jordan laughs warmly, Alex smiles shyly; his bicycle leans on a bench nearby. Distinct outfits: Jordan wears a bright orange courier jacket with grey reflective stripes and a dark grey helmet; Alex wears an olive jacket over a cream sweater, jeans, and a canvas backpack. Vertical composition. |
| B5-08-jordan-bisiklet | Jordan | 0,5 | 5c248d79-7167-464f-af0b-85a9d0acb33d | Use the reference image for Jordan. Scene: Jordan the bicycle courier (bright orange courier jacket with grey reflective stripes, dark grey helmet) leans on his bicycle at the harbour in the evening, talking cheerfully and gesturing with one hand toward the town as if describing his busy day; a parcel in the front basket; harbour lamps and boats behind. Vertical composition. |
| B5-09-kirmizi-palto-ani | — | 0,5 | 7b5c0a8c-fbe4-472a-b6b2-eb6910e0008c | A memory-like image in faded, washed-out colours like an old pencil and watercolour drawing: at dusk at the end of a harbour pier, the lone silhouette of a woman in a long red coat with the hood up, seen from behind, standing still and looking out at the sea; her face and hair are not visible; only the red coat keeps its colour, everything else is soft sepia and pale blue. Quiet and a little mysterious, not sad, not scary. Vertical composition. |
| B5-10-jordan-tepe | Jordan | 0,5 | 1a8cb66f-ac9a-45b7-826d-59bf0f078d6b | Use the reference image for Jordan. Scene: Jordan the bicycle courier (bright orange courier jacket with grey reflective stripes) stands on the evening harbour pier, head tilted, unsure, one hand scratching his helmet and the other hand pointing up toward a green hill above the small town, where a tiny café with warm lit windows sits among trees, far away. No text on any sign. Vertical composition. |
| B5-11-kaydedici-uzatma | Jordan, Alex, kaydedici | 0,5 | eab6c860-f922-4751-9424-47d08400b058 | Use the reference images for Jordan, Alex and the small old red voice recorder. Scene: under a harbour lamp in the evening, Jordan (bright orange courier jacket with grey reflective stripes, NOT an olive jacket) holds out the small old red voice recorder on his open palm toward Alex; Alex (olive jacket, cream sweater, canvas backpack) reaches for it, surprised and curious. Vertical composition. |
| B5-12-kaydedici-yakin | kaydedici | 0,5 | 87814a94-2dca-4e30-9efc-8452e8adaf38 | Use the reference image for the small old red voice recorder. Close-up: a young woman's hands with olive jacket sleeves hold the small old red voice recorder and press its round button; the small indicator light stays dark and off; warm evening harbour lamp light; background softly blurred. Vertical composition. |
| B5-13-rutin-kartlar | Jordan | 0,5 | 8fac12f2-08ff-4de0-b97e-a16a24de263f | Use the reference image for Jordan. Top-down view of a wooden table with three illustrated picture cards in a vertical column, each a simple small drawing of Jordan's day: top card, Jordan waking up and stretching in bed at sunrise; middle card, Jordan riding his bicycle with a parcel through the town in daylight in his orange courier jacket; bottom card, Jordan opening the door of his home at night under the moon. No text and no numbers on the cards. Vertical composition. |
| B5-14-harita-maya | Jordan, Alex | 0,5 | e5cd6d5e-ffd7-4552-89a2-a244db1e38d6 | Use the reference images for Jordan and Alex. Scene: evening on the harbour pier under a lamp; Alex (olive jacket, cream sweater, canvas backpack) holds an unfolded paper map; Jordan (bright orange courier jacket with grey reflective stripes, NOT an olive jacket) leans in and points excitedly at a small hand-drawn scribble in the corner of the map with no readable letters; his face lights up with an idea, Alex looks hopeful. Vertical composition. |

- **Toplam:** 14 sahne görseli + 2 referans (R5, R6) = 16 iş, **8 kr**. Yeniden üretim yok.
- **İşletim notu:** B5-01 ve B5-08'in çıktısı ilk çalıştırmada yerel klasör eksik olduğu için kaydedilemedi; işler tamamlanmıştı ve job listesinden prompt eşleşmesiyle indirildi (yeniden ücret yok).
- **Değerlendirme (Claude, temas sayfası `.yerel/h-085/kontak-B5.jpg`):** Yazı, rakam ya da logo yok (takvim, saat, tarife panosu, otobüs ekranı, harita boş). Alex ve Jordan bütün karelerde tutarlı; kıyafetler karışmadı. Kırmızı paltolu kadının yüzü ve saçı görünmüyor (B7 tarifini ve B12 adını ele vermez). Fener birçok karede ufukta (B1'den beri şehir siluetinin parçası; ipucu değil). B5-14'te Jordan kasksız (sorun değil). B5-10'daki tepe kafesi uzakta ve küçük (B9'a gönderme, spoiler değil). Editör değerlendirmesi bekliyor (H-028).

## Seslendirme

- **Türkçe (H-083):** `tts_episode_tr.py --tr-only --execute`, PatientDesk Alania (kampanya, ücretsiz) + Duyu hizalaması. 20 Alania çağrısı, **615 karakter**. Saf Türkçe 5 ses bitti (`tr_h-02`, `tr_c-alex`, `tr_t-gorev`, `tr_t-kanit`, `tr_c-oq`). İngilizce ifade içeren 5 sesin (`tr_r-k1-b`, `tr_h-k2`, `tr_h-lab1`, `tr_h-lab2`, `tr_c-clues`) Türkçe parçaları ödendi ve `audio/_raw/` önbelleğinde; Sarah parçaları (160 karakter) gelince yeniden Alania ücreti olmadan birleşir.
- **İngilizce replikler:** ElevenLabs kotası bittiği için üretilmedi. Kuru çalışma: `tts_episode_en.py` → 32 replik, **804 karakter** (Alex/Jessica 13 satır 230 kar.; Jordan 19 satır 574 kar.). **Jordan'ın sesi kullanıcı onayı bekliyor** (öneri: ElevenLabs hazır sesi Charlie; `sesler.json` → `episodeEnglish.voices.JORDAN`).

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T16:55:52Z | tr_h-02 | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.72 | 6fd52083c9c44894adbf528e0242f377 | 18575304ae49aa87 |
| 2026-10-14T16:55:53Z | tr_h-02 | duyu-1 | - | - | - | 2.72 | - | 18575304ae49aa87 |
| 2026-10-14T16:55:54Z | tr_t-gorev | alania-v2 | alania2-f1 | alania-v2.1 | 48 | 3.04 | 35a8a1d095304e6c8e88ebe3ab8b78ca | 916e60bf725661df |
| 2026-10-14T16:55:55Z | tr_t-gorev | duyu-1 | - | - | - | 3.04 | - | 916e60bf725661df |
| 2026-10-14T16:55:57Z | tr_t-kanit | alania-v2 | alania2-f1 | alania-v2.1 | 65 | 4.8 | aad253b1b877424ab146b945a295e68f | be7fdbb7b0241da6 |
| 2026-10-14T16:55:57Z | tr_t-kanit | duyu-1 | - | - | - | 4.8 | - | be7fdbb7b0241da6 |
| 2026-10-14T16:55:59Z | tr_r-k1-b.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.6 | 7df4822e15cf45bdb60aff062139f6b6 | e26f97cd14cb7587 |
| 2026-10-14T16:56:00Z | tr_r-k1-b.p1 | duyu-1 | - | - | - | 1.6 | - | e26f97cd14cb7587 |
| 2026-10-14T16:56:01Z | tr_r-k1-b.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 4 | 0.8 | 0c7395b8f21c48acb2aafe48e8e946ca | c9809cb125806a99 |
| 2026-10-14T16:56:02Z | tr_r-k1-b.p3 | duyu-1 | - | - | - | 0.8 | - | c9809cb125806a99 |
| 2026-10-14T16:56:02Z | tr_r-k1-b.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 1.12 | c7f51136ffa34ee5a7702b9c90ac48ce | 16de9fde6efa5f21 |
| 2026-10-14T16:56:03Z | tr_r-k1-b.p5 | duyu-1 | - | - | - | 1.12 | - | 16de9fde6efa5f21 |
| 2026-10-14T16:56:04Z | tr_h-k2.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.6 | d1e43888405d4b3c8388d3a38873f6e9 | f9251e983b9374c1 |
| 2026-10-14T16:56:05Z | tr_h-k2.p1 | duyu-1 | - | - | - | 1.6 | - | f9251e983b9374c1 |
| 2026-10-14T16:56:05Z | tr_h-k2.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 4 | 0.64 | 2dab754f19274474813e441efaba9b77 | b78e777438681a20 |
| 2026-10-14T16:56:06Z | tr_h-k2.p3 | duyu-1 | - | - | - | 0.64 | - | b78e777438681a20 |
| 2026-10-14T16:56:07Z | tr_h-k2.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 0.8 | cca1bb7bdae74900b8ffa6c037e4c852 | 7b6bc2bc8cd75a00 |
| 2026-10-14T16:56:07Z | tr_h-k2.p5 | duyu-1 | - | - | - | 0.8 | - | 7b6bc2bc8cd75a00 |
| 2026-10-14T16:56:08Z | tr_h-lab1.p2 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | c3844467b72a442d99cef0968ad3c901 | 26f214408652826a |
| 2026-10-14T16:56:09Z | tr_h-lab1.p2 | duyu-1 | - | - | - | 0.96 | - | 26f214408652826a |
| 2026-10-14T16:56:10Z | tr_h-lab1.p4 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.96 | 69ba13dfb30a4dffa6340241458be87a | dd9512328ea256ea |
| 2026-10-14T16:56:10Z | tr_h-lab1.p4 | duyu-1 | - | - | - | 0.96 | - | dd9512328ea256ea |
| 2026-10-14T16:56:11Z | tr_h-lab1.p6 | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 1.76 | 78962f0a3523402e9066e1a198611429 | 3a0749302468036e |
| 2026-10-14T16:56:12Z | tr_h-lab1.p6 | duyu-1 | - | - | - | 1.76 | - | 3a0749302468036e |
| 2026-10-14T16:56:13Z | tr_h-lab1.p8 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.8 | a9f36cbd831448b4b7a664ac78a21ec0 | 48542bd05e95cf41 |
| 2026-10-14T16:56:14Z | tr_h-lab1.p8 | duyu-1 | - | - | - | 0.8 | - | 48542bd05e95cf41 |
| 2026-10-14T16:56:14Z | tr_h-lab2.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 1.12 | e2e5858ec40b4e4a9af4414621ee0c5c | e8bfe1ed69351057 |
| 2026-10-14T16:56:15Z | tr_h-lab2.p1 | duyu-1 | - | - | - | 1.12 | - | e8bfe1ed69351057 |
| 2026-10-14T16:56:16Z | tr_h-lab2.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 5 | 0.64 | 51be42ab77424bdaa4f5570819d8626e | 41187314456e518e |
| 2026-10-14T16:56:16Z | tr_h-lab2.p3 | duyu-1 | - | - | - | 0.64 | - | 41187314456e518e |
| 2026-10-14T16:56:17Z | tr_h-lab2.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 42 | 3.84 | f0c1e96b4a344096ba8b353685181685 | f00a55e280184913 |
| 2026-10-14T16:56:18Z | tr_h-lab2.p5 | duyu-1 | - | - | - | 3.84 | - | f00a55e280184913 |
| 2026-10-14T16:56:19Z | tr_c-alex | alania-v2 | alania2-nisa | alania-v2.1 | 80 | 5.92 | cd2564f942fb46c995f037c790cb83e1 | 0007da29b45be241 |
| 2026-10-14T16:56:21Z | tr_c-alex | duyu-1 | - | - | - | 5.92 | - | 0007da29b45be241 |
| 2026-10-14T16:56:23Z | tr_c-clues.p1 | alania-v2 | alania2-m1 | alania-v2.1 | 52 | 5.76 | e9d473b6bd154af0bda42d8da5197059 | 186455f044595a74 |
| 2026-10-14T16:56:25Z | tr_c-clues.p1 | duyu-1 | - | - | - | 5.76 | - | 186455f044595a74 |
| 2026-10-14T16:56:28Z | tr_c-clues.p3 | alania-v2 | alania2-m1 | alania-v2.1 | 145 | 10.52 | 763a724334c6477785c5f86c106be151 | 50bf85ce0140a4bc |
| 2026-10-14T16:56:29Z | tr_c-clues.p3 | duyu-1 | - | - | - | 10.52 | - | 50bf85ce0140a4bc |
| 2026-10-14T16:56:31Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 26 | 2.4 | bc2dc07dc1bf4a2999b6be21aa5bb47e | 8528bfc018810700 |
| 2026-10-14T16:56:31Z | tr_c-oq | duyu-1 | - | - | - | 2.4 | - | 8528bfc018810700 |

## İngilizce replik seslendirme kayıtları (tts_episode_en.py)

| Tarih (UTC) | Kimlik | Konuşmacı | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|---|
| 2026-10-14T17:02:23Z | b5_01_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 32 | 79068667f965d88a |
| 2026-10-14T17:02:24Z | b5_02_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 23 | 944246478367b251 |
| 2026-10-14T17:02:26Z | b5_03_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 10 | 4e4f0b9b17086d5e |
| 2026-10-14T17:02:27Z | b5_04_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 23 | c2863684e4a5378d |
| 2026-10-14T17:02:28Z | b5_05_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 19 | 9bdf66dbdf217305 |
| 2026-10-14T17:02:30Z | b5_06_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 38 | 7583e05f31ae77ef |
| 2026-10-14T17:02:31Z | b5_07_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 16 | cf068eaeb9a2ce9c |
| 2026-10-14T17:02:32Z | b5_08_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 20 | 484a3c59e2c8e010 |
| 2026-10-14T17:02:34Z | b5_09_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 31 | 086f1c9370e51e6b |
| 2026-10-14T17:02:35Z | b5_10_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 23 | d8cc1c201063bbd4 |
| 2026-10-14T17:02:36Z | b5_11_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 27 | 2915a7b27f504507 |
| 2026-10-14T17:02:37Z | b5_12_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 23 | fce4849b66f8374f |
| 2026-10-14T17:02:39Z | b5_13_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 45 | b13d9882bf35b0aa |
| 2026-10-14T17:02:40Z | b5_14_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 28 | 8c6db19cedcba523 |
| 2026-10-14T17:02:42Z | b5_15_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 37 | 1fc785cd6c5d4b24 |
| 2026-10-14T17:02:43Z | b5_16_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 32 | a0ac56dfd12d5709 |
| 2026-10-14T17:02:44Z | b5_17_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 25 | 06de706b5dfd4250 |
| 2026-10-14T17:02:46Z | b5_18_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 11 | a98ac5d06264c719 |
| 2026-10-14T17:02:47Z | b5_19_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 17 | 20a12451833cc24f |
| 2026-10-14T17:02:48Z | b5_20_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 38 | 6815ccd8f3283085 |
| 2026-10-14T17:02:49Z | b5_21_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 37 | d1ded578def0d2f8 |
| 2026-10-14T17:02:50Z | b5_22_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 24 | 6aa9dc03eb6ffd0e |
| 2026-10-14T17:02:52Z | b5_23_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 33 | b36539187422e124 |
| 2026-10-14T17:02:53Z | b5_24_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 7 | e7af2ddbe0508e07 |
| 2026-10-14T17:02:54Z | b5_25_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 30 | 7dcefcaa30c711f6 |
| 2026-10-14T17:02:56Z | b5_26_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 19 | fd897b50dc1b721f |
| 2026-10-14T17:02:57Z | b5_27_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 18 | c82e0d50adab7d77 |
| 2026-10-14T17:02:58Z | b5_28_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 6 | 241a3380b7970c55 |
| 2026-10-14T17:02:59Z | b5_29_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 38 | 1f8744b8f658745d |
| 2026-10-14T17:03:01Z | b5_30_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 23 | e5c460691a31c3dd |
| 2026-10-14T17:03:02Z | b5_31_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 37 | c0085b6bb95452f4 |
| 2026-10-14T17:03:03Z | b5_32_jordan | JORDAN | Chris iP95p4xoKVk53GoZ742B | eleven_v3 | 0.9 | 14 | a015c030ac59fdd4 |

## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|
| 2026-10-14T17:03:37Z | tr_r-k1-b.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | cf068eaeb9a2ce9c |
| 2026-10-14T17:03:38Z | tr_r-k1-b.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 5 | e0025fd3a87fc910 |
| 2026-10-14T17:03:39Z | tr_r-k1-b.p6 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | cf86014e7296acf6 |
| 2026-10-14T17:03:40Z | tr_h-k2.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 3 | c17b94b8c9394d40 |
| 2026-10-14T17:03:41Z | tr_h-k2.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 5 | 1daaa38f33cd860e |
| 2026-10-14T17:03:42Z | tr_h-lab1.p1 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 11 | 3e16849af95a7c42 |
| 2026-10-14T17:03:43Z | tr_h-lab1.p3 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1 | 043a718774c572bd |
| 2026-10-14T17:03:44Z | tr_h-lab1.p5 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 87ddcd25c22ad11e |
| 2026-10-14T17:03:46Z | tr_h-lab1.p7 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 17 | 7e94db9be10e365d |
| 2026-10-14T17:03:47Z | tr_h-lab1.p9 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | fd897b50dc1b721f |
| 2026-10-14T17:03:48Z | tr_h-lab2.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | 03e90ca20add7c95 |
| 2026-10-14T17:03:49Z | tr_h-lab2.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 3 | b63b99f6383ba713 |
| 2026-10-14T17:03:50Z | tr_c-clues.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 31 | e7a334a64a7090c1 |
| 2026-11-27T19:51:49Z | l-e4effb18b0 | alania-v2 | alania2-f1 | alania-v2.1 | 5 | 0.96 | 7087c7d29dd8473d86739deb91c12cf4 | 99ccda9ac024c86f |
| 2026-11-27T19:51:50Z | l-e4effb18b0 | duyu-1 | - | - | - | 0.96 | - | 99ccda9ac024c86f |
| 2026-11-27T19:51:51Z | l-09a8f386b0 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.6 | 6725343fecc04763ac964cc7ff937c3c | b708eaecbf9eda25 |
| 2026-11-27T19:51:52Z | l-09a8f386b0 | duyu-1 | - | - | - | 1.6 | - | b708eaecbf9eda25 |
| 2026-11-27T19:51:54Z | l-4455be73df | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 0.96 | 9fb646563fd14ce89fb95165525788cd | eb84718b45ce170e |
| 2026-11-27T19:51:55Z | l-4455be73df | duyu-1 | - | - | - | 0.96 | - | eb84718b45ce170e |
| 2026-11-27T19:51:56Z | l-4e663db281 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | ce659703964548c489add8af7539fa65 | 4da66b9e2c5d2d09 |
| 2026-11-27T19:51:57Z | l-4e663db281 | duyu-1 | - | - | - | 1.28 | - | 4da66b9e2c5d2d09 |
| 2026-11-27T19:51:58Z | l-77e08850a1 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.28 | 29884bfa095945d48476284375ffa38b | 7d87c69d5b390c96 |
| 2026-11-27T19:51:59Z | l-77e08850a1 | duyu-1 | - | - | - | 1.28 | - | 7d87c69d5b390c96 |
| 2026-11-27T19:52:01Z | l-4e4f0b9b17 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.44 | fe2ad147d2934bac88ebeeae7bf64b96 | 1c9d5e11e32b079b |
| 2026-11-27T19:52:02Z | l-4e4f0b9b17 | duyu-1 | - | - | - | 1.44 | - | 1c9d5e11e32b079b |
| 2026-11-27T19:52:03Z | l-c2863684e4 | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 2.24 | d51c563a32da46a7931e7a840a4ac4ea | 08b45aea8285c845 |
| 2026-11-27T19:52:05Z | l-c2863684e4 | duyu-1 | - | - | - | 2.24 | - | 08b45aea8285c845 |
| 2026-11-27T19:52:06Z | l-9bdf66dbdf | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 1.92 | 65fcfdb7a4084682930102a4bc7c51e1 | 93f66f9d5727f1cd |
| 2026-11-27T19:52:07Z | l-9bdf66dbdf | duyu-1 | - | - | - | 1.92 | - | 93f66f9d5727f1cd |
| 2026-11-27T19:52:08Z | l-93d25a260d | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.24 | d099086e65c74c3ba1e28e73412f14be | b6b2a7bbaa504c20 |
| 2026-11-27T19:52:09Z | l-93d25a260d | duyu-1 | - | - | - | 2.24 | - | b6b2a7bbaa504c20 |
| 2026-11-27T19:52:11Z | l-de358fdad4 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.12 | cf9172f80ac4495fabe038b7407032a8 | 7e5e5e9f1fd0b2bb |
| 2026-11-27T19:52:12Z | l-de358fdad4 | duyu-1 | - | - | - | 1.12 | - | 7e5e5e9f1fd0b2bb |
| 2026-11-27T19:52:14Z | l-7583e05f31 | alania-v2 | alania2-f1 | alania-v2.1 | 39 | 3.04 | a369590e93c444a083b29b00b5e6c11e | 0926509cf993caa0 |
| 2026-11-27T19:52:15Z | l-7583e05f31 | duyu-1 | - | - | - | 3.04 | - | 0926509cf993caa0 |
| 2026-11-27T19:52:18Z | l-484a3c59e2 | alania-v2 | alania2-f1 | alania-v2.1 | 32 | 1.6 | 2a46f6ebe01a4733b7f633c6bebe4de0 | 0b2614f81b18a744 |
| 2026-11-27T19:52:18Z | l-484a3c59e2 | duyu-1 | - | - | - | 1.6 | - | 0b2614f81b18a744 |
| 2026-11-27T19:52:20Z | l-d966e58c95 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.44 | 985ccb7f2b6a49e9a361ff2c8618d58f | c56ce673ea4b6978 |
| 2026-11-27T19:52:21Z | l-d966e58c95 | duyu-1 | - | - | - | 1.44 | - | c56ce673ea4b6978 |
| 2026-11-27T19:52:23Z | l-40d51bcb70 | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | 308a57f53f2a4c08973476924e85a80e | 15f50946a8a001d4 |
| 2026-11-27T19:52:24Z | l-40d51bcb70 | duyu-1 | - | - | - | 2.24 | - | 15f50946a8a001d4 |
| 2026-11-27T19:52:25Z | l-cf068eaeb9 | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.92 | c8d50064d14f41b198f8a1cc10ec26c3 | 56cf53b45c994b2c |
| 2026-11-27T19:52:26Z | l-cf068eaeb9 | duyu-1 | - | - | - | 1.92 | - | 56cf53b45c994b2c |
| 2026-11-27T19:52:28Z | l-f001e3ed4d | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 0.8 | 9adf29a0bfd54372b74b5c74e3ad5614 | 592110a0b8ef90a7 |
| 2026-11-27T19:52:29Z | l-f001e3ed4d | duyu-1 | - | - | - | 0.8 | - | 592110a0b8ef90a7 |
| 2026-11-27T19:52:30Z | l-40fbb56cc3 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.28 | 5104a7d7664f4c1d96b25929ea0cbd05 | 7919d110378a37cc |
| 2026-11-27T19:52:31Z | l-40fbb56cc3 | duyu-1 | - | - | - | 1.28 | - | 7919d110378a37cc |
| 2026-11-27T19:52:33Z | l-39954823f7 | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.92 | c8dab2d6b33d46bc9244b97f872a4818 | 63ac259a8b4ba322 |
| 2026-11-27T19:52:33Z | l-39954823f7 | duyu-1 | - | - | - | 1.92 | - | 63ac259a8b4ba322 |
| 2026-11-27T19:52:35Z | l-85079ba188 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 36689e066b784eeea8c7653f8f7d8c00 | 68268f28e9b1bec6 |
| 2026-11-27T19:52:36Z | l-85079ba188 | duyu-1 | - | - | - | 0.96 | - | 68268f28e9b1bec6 |
| 2026-11-27T19:52:37Z | l-fce4849b66 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 2.24 | 841792f67c6b4ffa9903c5cb11df1592 | 7adc790088061b50 |
| 2026-11-27T19:52:38Z | l-fce4849b66 | duyu-1 | - | - | - | 2.24 | - | 7adc790088061b50 |
| 2026-11-27T19:52:40Z | l-96787c3291 | alania-v2 | alania2-f1 | alania-v2.1 | 25 | 1.76 | 95c2c73ff130429a8132c98911268c2b | a9f1ad9e4b5061ba |
| 2026-11-27T19:52:41Z | l-96787c3291 | duyu-1 | - | - | - | 1.76 | - | a9f1ad9e4b5061ba |
| 2026-11-27T19:52:43Z | l-be768cd243 | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | 286c25a6308f424e8ad806b1d245a37c | 7c786884e4daad91 |
| 2026-11-27T19:52:44Z | l-be768cd243 | duyu-1 | - | - | - | 2.08 | - | 7c786884e4daad91 |
| 2026-11-28T06:42:33Z | l-8c6db19ced | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 1.76 | 47f4ed0060ce4f0ea1b1774dc095fd64 | ec1c0b3562d6211b |
| 2026-11-28T06:42:34Z | l-8c6db19ced | duyu-1 | - | - | - | 1.76 | - | ec1c0b3562d6211b |
| 2026-11-28T06:42:36Z | l-2cab63f52a | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 97aa860333814bab9f6e9e56c4f145fc | 80f78abd7f18df5b |
| 2026-11-28T06:42:37Z | l-2cab63f52a | duyu-1 | - | - | - | 1.76 | - | 80f78abd7f18df5b |
| 2026-11-28T06:42:39Z | l-75c19212f0 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.12 | 81ab3b2265404960b33f0ed77770ba1a | 98e51db8e46cab02 |
| 2026-11-28T06:42:40Z | l-75c19212f0 | duyu-1 | - | - | - | 1.12 | - | 98e51db8e46cab02 |
| 2026-11-28T06:42:41Z | l-f088c1a0d2 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.6 | 3e1f736e8aaf442888e5a0a8ca494e50 | f208552156893b02 |
| 2026-11-28T06:42:42Z | l-f088c1a0d2 | duyu-1 | - | - | - | 1.6 | - | f208552156893b02 |
| 2026-11-28T06:42:44Z | l-0ca99ec504 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.12 | 265aa58f228c4faa9343f08fa5ca6c16 | f50b1bd527acb44f |
| 2026-11-28T06:42:45Z | l-0ca99ec504 | duyu-1 | - | - | - | 1.12 | - | f50b1bd527acb44f |
| 2026-11-28T06:42:47Z | l-569a8e0d11 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 0.96 | f53f9f2bfd004913b37a5a4ad75385cf | 1abaac4399489e19 |
| 2026-11-28T06:42:47Z | l-569a8e0d11 | duyu-1 | - | - | - | 0.96 | - | 1abaac4399489e19 |
| 2026-11-28T06:42:49Z | l-06de706b5d | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.44 | 96a58620322d4abe80acfd0d11f95438 | 52a4be5a9f0d98e0 |
| 2026-11-28T06:42:50Z | l-06de706b5d | duyu-1 | - | - | - | 1.44 | - | 52a4be5a9f0d98e0 |
| 2026-11-28T06:42:52Z | l-a98ac5d062 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.8 | b04d59a415474c0f95ced6ef038004b6 | 1ed7c9fc16224113 |
| 2026-11-28T06:42:53Z | l-a98ac5d062 | duyu-1 | - | - | - | 0.8 | - | 1ed7c9fc16224113 |
| 2026-11-28T06:42:54Z | l-c00730a4aa | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 0.8 | f25d68cde2ad4615b21277f866c9c5e1 | b1bfb4197aaca67d |
| 2026-11-28T06:42:55Z | l-c00730a4aa | duyu-1 | - | - | - | 0.8 | - | b1bfb4197aaca67d |
| 2026-11-28T06:42:57Z | l-832d2601cc | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | e987ff9555f64fef822bf64dc5887dfd | d54ec10ae3c25ff1 |
| 2026-11-28T06:42:58Z | l-832d2601cc | duyu-1 | - | - | - | 1.28 | - | d54ec10ae3c25ff1 |
| 2026-11-28T06:42:59Z | l-0de17746ce | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | cbe99bea377d4cc8b8ca7970c9d0ef22 | bdf86e8a6ae81768 |
| 2026-11-28T06:43:00Z | l-0de17746ce | duyu-1 | - | - | - | 1.28 | - | bdf86e8a6ae81768 |
| 2026-11-28T06:43:02Z | l-20a1245183 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.44 | 98e1ab4eacb54f8a8ad23d370c78d62a | a534e373309eb181 |
| 2026-11-28T06:43:03Z | l-20a1245183 | duyu-1 | - | - | - | 1.44 | - | a534e373309eb181 |
| 2026-11-28T06:43:05Z | l-810d7c3ca6 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 0.96 | 43fb7b9cc05846d38abf58cbd954a605 | ccf713d6a7979434 |
| 2026-11-28T06:43:06Z | l-810d7c3ca6 | duyu-1 | - | - | - | 0.96 | - | ccf713d6a7979434 |
| 2026-11-28T06:43:07Z | l-11145eeae7 | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.24 | fe0052a9e1044bd5b45524a1f220b61b | d8100fae10eef416 |
| 2026-11-28T06:43:09Z | l-11145eeae7 | duyu-1 | - | - | - | 2.24 | - | d8100fae10eef416 |
| 2026-11-28T06:43:10Z | l-6aa9dc03eb | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.76 | 73804d16d4074f52a0e0ed64ae08ceac | 14efc8e73c7125e4 |
| 2026-11-28T06:43:11Z | l-6aa9dc03eb | duyu-1 | - | - | - | 1.76 | - | 14efc8e73c7125e4 |
| 2026-11-28T06:43:13Z | l-b365391874 | alania-v2 | alania2-f1 | alania-v2.1 | 34 | 2.72 | 6ae290fd076e4ffd9284eddadeaaa6d2 | d7d90d3535c85efd |
| 2026-11-28T06:43:14Z | l-b365391874 | duyu-1 | - | - | - | 2.72 | - | d7d90d3535c85efd |
| 2026-11-28T06:43:16Z | l-e7af2ddbe0 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 0.96 | beb0e5c847c2435c8a39b5ba55296f1f | f4dce9a982398363 |
| 2026-11-28T06:43:17Z | l-e7af2ddbe0 | duyu-1 | - | - | - | 0.96 | - | f4dce9a982398363 |
| 2026-11-28T06:43:18Z | l-7dcefcaa30 | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 2.56 | cc7958a51701460ea71ca4a8cb21e359 | 6b4d767219785eac |
| 2026-11-28T06:43:20Z | l-7dcefcaa30 | duyu-1 | - | - | - | 2.56 | - | 6b4d767219785eac |
| 2026-11-28T06:43:21Z | l-fd897b50dc | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.44 | 1cd536328569449eb69e7751ed8e26a9 | e39a259f9e32c4aa |
| 2026-11-28T06:43:22Z | l-fd897b50dc | duyu-1 | - | - | - | 1.44 | - | e39a259f9e32c4aa |
| 2026-11-28T06:43:24Z | l-f94c4d6faf | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.28 | 45338ddf34964c63aca545f4475b085a | bde1926647a92cee |
| 2026-11-28T06:43:25Z | l-f94c4d6faf | duyu-1 | - | - | - | 1.28 | - | bde1926647a92cee |
| 2026-11-28T06:43:26Z | l-241a3380b7 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 1.92 | 03ba166958124b6484357e4cec50b141 | 20f596e3cf72a142 |
| 2026-11-28T06:43:27Z | l-241a3380b7 | duyu-1 | - | - | - | 1.92 | - | 20f596e3cf72a142 |
| 2026-11-28T06:43:29Z | l-9c8041541e | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 1.44 | 0cfe88cb1f2a47469a7077bd63972139 | 8b9983bb71a9aaa0 |
| 2026-11-28T06:43:30Z | l-9c8041541e | duyu-1 | - | - | - | 1.44 | - | 8b9983bb71a9aaa0 |
| 2026-11-28T06:43:32Z | l-871ba948d0 | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.92 | 09b3123e02bc40de9e1c1ab0b9e52fc9 | a6cdba4615171ffe |
| 2026-11-28T06:43:33Z | l-871ba948d0 | duyu-1 | - | - | - | 1.92 | - | a6cdba4615171ffe |
| 2026-11-28T06:43:34Z | l-e5c460691a | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 2.08 | 74cbba83d87343b1829b7a5cd39bd2ab | ae0beedec42e42d7 |
| 2026-11-28T06:43:35Z | l-e5c460691a | duyu-1 | - | - | - | 2.08 | - | ae0beedec42e42d7 |
| 2026-11-28T06:43:37Z | l-c0085b6bb9 | alania-v2 | alania2-f1 | alania-v2.1 | 40 | 3.2 | ad2889498ea34597918e22bb5a8b5a7d | e1de209edeacdada |
| 2026-11-28T06:43:38Z | l-c0085b6bb9 | duyu-1 | - | - | - | 3.2 | - | e1de209edeacdada |
| 2026-11-28T06:43:40Z | l-a015c030ac | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 3109782aabae4293aa676ceb1de3dc30 | c0ab29588dcc007d |
| 2026-11-28T06:43:42Z | l-a015c030ac | duyu-1 | - | - | - | 1.6 | - | c0ab29588dcc007d |
| 2026-11-28T06:43:43Z | p-2a165ba37c | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 0.96 | 741d9959c0fc48fc93c4f3c93168c45e | ebdb86c616625723 |
| 2026-11-28T06:43:44Z | p-2a165ba37c | duyu-1 | - | - | - | 0.96 | - | ebdb86c616625723 |
| 2026-11-28T06:53:28Z | l-484a3c59e2 | alania-v2 | alania2-f1 | alania-v2.1 | 31 | 3.2 | c62a647943cc45ad962d741a1ca20774 | 0b2614f81b18a744 |
| 2026-11-28T06:53:29Z | l-484a3c59e2 | duyu-1 | - | - | - | 3.2 | - | 0b2614f81b18a744 |
