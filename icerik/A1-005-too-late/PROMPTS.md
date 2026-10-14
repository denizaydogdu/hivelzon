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
