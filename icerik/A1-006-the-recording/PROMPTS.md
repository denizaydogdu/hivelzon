# PROMPTS: A1-006-the-recording (üretim, 2026-10-14, H-085)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low. Maliyet önce `higgsfield generate cost` ile ölçüldü: görsel başına 0,5 kr (tahmin = gerçek).
- **Kullanıcı onayı:** H-085 görevi (kullanıcı 500 kr yükledi ve bekleyen işleri onayladı; B6–B8 için tavan 45 kr).
- **Ders (B4-01) uygulandı:** Birden çok karakterli her sahnede kıyafetler açıkça yazıldı: Alex zeytin yeşili ceket + krem kazak + kanvas çanta; Maya sarı yağmurluk + mavi-beyaz çizgili kazak; Sam lacivert kapüşonlu + yuvarlak gözlük + boynunda kulaklık; Jordan turuncu kurye ceketi + gri kask ("NOT an olive jacket"); Mrs Brooks krem örgü kazak + lacivert kot önlük.
- **Kredi (hesap, `higgsfield account status`):** B6–B8 başında 451,56 → sonunda 399,56. Fark aynı hesabı kullanan başka oturumun (B9–B12) işlerini de içerir; B6–B8'in toplam harcaması **26 kr** (B6 7 · B7 7,5 · B8 11,5).
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; "Saturday", defterdeki notlar ("red coat", "Helen?", "the hill café?"), telsiz etiketi "PLRC 1979", Sam'in notu "old club radio?" ve haritadaki "Lumen Point" kurguda (`signs`) eklenir.
- **Referanslar:** Alex `663ea0fe…` (R1), telsiz `74fb45e8…` (R3), Maya `6db4fa91…` (R4), kaydedici `72e65920…` (R6), **Sam `d83596f7…` (R7, yeni; B2-04'teki aile fotoğrafındaki gençten türetildi)**; mekân için B2-01 dükkân dış cephesi (job `b8d39d0b…`). Kayıt: `_evren/style/PROMPTS.md`.
- **Kilit an (Seedance):** Yok. Sezon planında B6'da ★ yok (`content.json` → `realClips: 0`).
- **Yeniden kullanılan görseller (ücretsiz):** özet B5-12; kayıt çalarken B5-09 (kırmızı paltolu kadın anısı, yüz yok).
- **Bu bölümün harcaması: 7 kr** (13 sahne görseli + R7 = 14 iş × 0,5). Yeniden üretim yok.

## Referans (yeni)

| Ad | Referans | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| R7-sam-gpt (3:2) | B2-04-anne-foto | 0,5 | d83596f7-7f31-4914-ae9e-5e4134e086b6 | Use the reference image only for the teenage boy with glasses and headphones in the framed photo; keep his face and hair. Character reference sheet of an original character: Sam Brooks, a 17-year-old teenage boy, a tech enthusiast; slim, wavy dark-brown hair, light-brown skin, round dark-rimmed glasses, quick bright smile; a navy-blue hoodie with front pockets full of small screws and a coiled cable, over-ear headphones resting around his neck, grey jeans, worn sneakers; a small screwdriver behind one ear. Front view, side view, back view, and three facial expressions (excited talking fast, focused, embarrassed grin). Plain background. |

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B6-01-dukkan-kapi | Alex, Maya, B2-01-dukkan-dis, kaydedici | 0,5 | 21981eda-2bb5-4923-9519-18924da87db1 | Use the reference images for Alex, Maya, the small book-and-tea shop front and the small old red voice recorder. Scene: bright Saturday morning at the door of the small harbour book-and-tea shop; Maya stands in the open doorway and waves happily; Alex walks up to the door holding the small red voice recorder in her hand. Distinct outfits: Maya wears a bright yellow raincoat over a blue-and-white striped sweater and dark jeans; Alex wears an olive jacket over a cream sweater, jeans and a canvas backpack. No text on any sign or shop window. Vertical composition. |
| B6-02-sam-oda | Sam (R7), Alex, Maya | 0,5 | 467030c0-cec5-45b1-ba2e-479993560195 | Use the reference images for Sam, Alex and Maya. Scene: morning; a small, messy but warm teenager's bedroom full of technology: an old radio on a wooden desk, cables everywhere on the floor and walls, a cardboard box under the bed, two chairs, a computer screen glowing. Sam sits at the desk with his back half turned, big headphones ON his ears, staring at the screen and not noticing anyone. Alex and Maya stand in the open doorway behind him. Distinct outfits: Sam wears a navy-blue hoodie, round dark-rimmed glasses and grey jeans; Alex wears an olive jacket over a cream sweater; Maya wears a bright yellow raincoat over a blue-and-white striped sweater. The screen shows only abstract coloured waves, no text. Vertical composition. |
| B6-03-sam-merhaba | Sam (R7) | 0,5 | c5f8f6ba-14e4-48a0-aa38-a58fbdcbe223 | Use the reference image for Sam. Scene: in his messy tech bedroom in the morning, Sam (navy-blue hoodie, round dark-rimmed glasses) spins around on his desk chair, pulling his big headphones down around his neck, surprised and embarrassed, then grinning and waving hello at the viewer; cables and an old radio on the desk behind him. Vertical composition. |
| B6-04-oda-detay | telsiz | 0,5 | b4a8c93c-029d-4f75-b89a-46a4e81e3841 | Use the reference image only for the style of the old radio. Scene: a clear wide view of a teenager's small tech bedroom with nobody in it, morning light: on the wooden desk there is one old radio; there are many cables everywhere, hanging from the shelves and coiled on the floor; there are exactly two chairs, a desk chair and a small wooden chair; under the bed there is one cardboard box, clearly visible. Tidy enough to read each object easily. No posters with writing, no text. Vertical composition. |
| B6-05-sam-kaydedici | Sam (R7), Alex, kaydedici | 0,5 | e8a7173c-ad16-4e24-b37f-c6228860d421 | Use the reference images for Sam, Alex and the small old red voice recorder. Scene: in Sam's tech bedroom; Alex has put the small old red voice recorder on the desk; Sam (navy-blue hoodie, round glasses, headphones around his neck) grabs it excitedly and turns it over in his hands, talking very fast with a huge grin; Alex (olive jacket, cream sweater) blinks, a little lost. Vertical composition. |
| B6-06-k1-pov | Sam (R7), kaydedici | 0,5 | 118099ab-2d45-46c8-a076-6e988517673d | Use the reference images for Sam and the small old red voice recorder. Scene: first-person point of view from Alex: Sam (navy-blue hoodie, round dark-rimmed glasses, headphones around his neck) leans toward the viewer, talking very fast and gesturing with both hands, holding the small red recorder in one hand; motion lines suggest a fast flood of words, but no speech bubbles and no letters. Calm, slightly muted colours. Vertical composition. |
| B6-07-pil | Sam (R7), kaydedici | 0,5 | 13a92bc8-c2f6-4de7-aa59-7148e92e2320 | Use the reference images for Sam and the small old red voice recorder. Scene: at his desk, Sam (navy-blue hoodie, round glasses) has opened the small battery cover on the back of the red voice recorder with a tiny screwdriver and pushes a new small battery into it, smiling, focused; a desk lamp lights his hands; cables around. Vertical composition. |
| B6-08-k2-pov | kaydedici | 0,5 | e0449990-63f0-43b5-b6da-ceca00901fb7 | Use the reference image for the small old red voice recorder. Close-up, first-person point of view: a young woman's hands with olive jacket sleeves hold the small old red voice recorder; clearly visible are one small slide switch on the side edge and the small battery cover on the back edge; the tiny indicator light is dark and off. Warm morning desk light, background softly blurred. No labels. Vertical composition. |
| B6-09-isik-yandi | kaydedici, Alex, Maya, Sam (R7) | 0,5 | 387e2f33-c409-48b5-bced-540a3940997d | Use the reference images for the small old red voice recorder, Alex, Maya and Sam. Scene: the red voice recorder lies on the desk in the foreground, its tiny red indicator light now glowing; Alex, Maya and Sam lean in close around it, listening with wide eyes, completely still. Distinct outfits: Alex olive jacket over a cream sweater; Maya bright yellow raincoat over a blue-and-white striped sweater; Sam navy-blue hoodie, round glasses, headphones around his neck. Vertical composition. |
| B6-10-uc-bakis | Alex, Maya, Sam (R7) | 0,5 | 6a9bdb6e-0d1d-4729-adff-9bd7f276695a | Use the reference images for Alex, Maya and Sam. Scene: a quiet moment of silence in Sam's tech bedroom: the three friends look at each other, surprised and thoughtful, nobody speaks; soft morning light through the window. Distinct outfits: Alex olive jacket over a cream sweater; Maya bright yellow raincoat over a blue-and-white striped sweater; Sam navy-blue hoodie, round glasses, headphones around his neck. Vertical composition. |
| B6-11-defter | Alex, Maya | 0,5 | ee3aa469-c742-4fa9-84bb-376103e822b3 | Use the reference images for Alex and Maya. Scene: Alex (olive jacket, cream sweater) opens her small notebook on Sam's desk; the pages show only a few small sketches (a tiny red coat drawing, a question mark, a small hill with a café) and no readable words; Maya (bright yellow raincoat over a striped sweater) leans in and frowns, thinking. Vertical composition. |
| B6-12-telsiz-etiket | Sam (R7), telsiz | 0,5 | 8399c038-482d-4d74-b4af-2a879dbfdb8c | Use the reference images for Sam and the old radio. Scene: Sam (navy-blue hoodie, round glasses, headphones around his neck) holds Alex's old cream-and-green portable radio up close to his glasses and studies a small faded blank sticker on its side, one eyebrow raised, very curious; a pencil and a blank sheet of paper on the desk beside him. The sticker is blank, no readable text. Vertical composition. |
| B6-13-harita-fener | Maya, Alex, Sam (R7) | 0,5 | baa21942-cc6b-4867-a8de-a7bc446c6115 | Use the reference images for Maya, Alex and Sam. Scene: Maya (bright yellow raincoat over a blue-and-white striped sweater) has unfolded her hand-drawn paper map on Sam's desk and points firmly with one finger at a small rocky headland on the coast where a tiny lighthouse is drawn; Alex (olive jacket, cream sweater) and Sam (navy-blue hoodie, round glasses) lean over the map, surprised. The map has no labels and no letters. Vertical composition. |

- **Toplam:** 13 sahne görseli + 1 referans (R7) = 14 iş, **7 kr**.
- **Değerlendirme (Claude, temas sayfası `.yerel/h-085/kontak-B6.jpg`):** Yazı, rakam ya da logo yok (bilgisayar ekranı soyut dalga, defterde yalnız küçük çizimler, telsiz etiketi ve harita boş). Alex, Maya ve Sam bütün karelerde tutarlı; kıyafetler karışmadı. B6-04'te masada radyo, her yerde kablo, iki sandalye ve yatağın altında kutu görünüyor (kanıt görevi bu resme dayanır). B6-08'de kaydedicinin ışığı sönük, B6-09'da yanık. Pencerelerde fener sık görünüyor (şehir siluetinin parçası; B6'nın sonunda zaten açılıyor). "Sabah" istendi ama bazı karelerde ışık akşamüstü tonunda (stil paleti; editör değerlendirsin). Kırmızı paltolu kadının yüzü yok. Editör değerlendirmesi bekliyor (H-028).

## Seslendirme

- **Türkçe (H-083):** `tts_episode_tr.py --tr-only --execute`, PatientDesk Alania (kampanya, 2026-11-14'e kadar ücretsiz) + Duyu hizalaması. Saf Türkçe sesler bitti; İngilizce ifade içeren seslerin Türkçe parçaları `audio/_raw/` önbelleğinde, Sarah parçaları kota gelince yeniden Alania ücreti olmadan birleşir. Kayıtlar aşağıdaki tabloda.
- **İngilizce replikler:** ElevenLabs kotası bittiği için üretilmedi. Kuru çalışma (`tts_episode_en.py`): 28 replik, **695 karakter** (Alex/Jessica 7 satır 168 · Maya/Sarah 7 satır 203 · Sam/**ses yok** 10 satır 238 · kayıt sesi VOICE/Lily 4 satır 86). **Sam'in sesi kullanıcı onayı bekliyor**; tanımsız ses varsa araç hiç çağrı yapmaz.
- **Kayıt sesi (VOICE):** B1'deki çağrı sesiyle aynı (Lily, telsiz süzgeci). B7 aynı kaydı yeniden kullanır (`../A1-006-the-recording/audio/b6_20_voice`, `b6_21_voice`).

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T17:31:04Z | tr_h-k1.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.76 | 410d87d5f9cd484493a3d3612bdb0a17 | 49660f4f30bd96db |
| 2026-10-14T17:31:04Z | tr_h-k1.p1 | duyu-1 | - | - | - | 1.76 | - | 49660f4f30bd96db |
| 2026-10-14T17:31:05Z | tr_h-k1.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 5 | 0.8 | c6b6b2eb69404a139eae835e8d376a30 | 9ae4ef6995aa4eca |
| 2026-10-14T17:31:06Z | tr_h-k1.p3 | duyu-1 | - | - | - | 0.8 | - | 9ae4ef6995aa4eca |
| 2026-10-14T17:31:07Z | tr_h-k1.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.6 | 702095bce4e646439cc5b16a36667551 | 31c4f8c54ed686e6 |
| 2026-10-14T17:31:08Z | tr_h-k1.p5 | duyu-1 | - | - | - | 1.6 | - | 31c4f8c54ed686e6 |
| 2026-10-14T17:31:09Z | tr_r-k2-b.p2 | alania-v2 | alania2-f1 | alania-v2.1 | 44 | 3.68 | 8cc60638ea9e4447a53398b4d0750589 | 9bc9085152498c9c |
| 2026-10-14T17:31:10Z | tr_r-k2-b.p2 | duyu-1 | - | - | - | 3.68 | - | 9bc9085152498c9c |
| 2026-10-14T17:31:11Z | tr_h-lab1.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 5.12 | ee31a55de67447febc39682ea4ddad86 | 3d1eaba6ddc16052 |
| 2026-10-14T17:31:13Z | tr_h-lab1.p1 | duyu-1 | - | - | - | 5.12 | - | 3d1eaba6ddc16052 |
| 2026-10-14T17:31:14Z | tr_h-lab1.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.12 | 294639457f8849e08112080fea286c16 | 2d228a3cb6a2fd78 |
| 2026-10-14T17:31:15Z | tr_h-lab1.p3 | duyu-1 | - | - | - | 1.12 | - | 2d228a3cb6a2fd78 |
| 2026-10-14T17:31:15Z | tr_h-lab1.p6 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.64 | cb1d4e4f963e4680938911263dc41ead | 48542bd05e95cf41 |
| 2026-10-14T17:31:16Z | tr_h-lab1.p6 | duyu-1 | - | - | - | 0.64 | - | 48542bd05e95cf41 |
| 2026-10-14T17:31:17Z | tr_t-kanit.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 64 | 5.28 | bec4f870e14149dea6eef1b48fa42a86 | 50287611d08b92a7 |
| 2026-10-14T17:31:19Z | tr_t-kanit.p1 | duyu-1 | - | - | - | 5.28 | - | 50287611d08b92a7 |
| 2026-10-14T17:31:20Z | tr_t-gorev | alania-v2 | alania2-f1 | alania-v2.1 | 56 | 4.96 | fd718598b3f1435db0ec1de2d25432c0 | 9d0ab0df20fab599 |
| 2026-10-14T17:31:21Z | tr_t-gorev | duyu-1 | - | - | - | 4.96 | - | 9d0ab0df20fab599 |
| 2026-10-14T17:31:22Z | tr_c-clues.p1 | alania-v2 | alania2-m1 | alania-v2.1 | 20 | 1.92 | b7a07cc8155543198ceccab52740a154 | f36fee9a9d8ed6a9 |
| 2026-10-14T17:31:23Z | tr_c-clues.p1 | duyu-1 | - | - | - | 1.92 | - | f36fee9a9d8ed6a9 |
| 2026-10-14T17:31:24Z | tr_c-clues.p3 | alania-v2 | alania2-m1 | alania-v2.1 | 12 | 1.28 | e11fd446e38c4ca1bea8c3a7fbbd83d1 | cc134d1f41fce578 |
| 2026-10-14T17:31:25Z | tr_c-clues.p3 | duyu-1 | - | - | - | 1.28 | - | cc134d1f41fce578 |
| 2026-10-14T17:31:26Z | tr_c-clues.p5 | alania-v2 | alania2-m1 | alania-v2.1 | 55 | 3.84 | 695a60bc9b3f4890a99eefed348728b0 | 831a987b24257b5c |
| 2026-10-14T17:31:27Z | tr_c-clues.p5 | duyu-1 | - | - | - | 3.84 | - | 831a987b24257b5c |
| 2026-10-14T17:31:28Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 37 | 3.2 | bca5fe2fa4c44fbc90a3cb5fe1ddb864 | 101f250f284b8d8c |
| 2026-10-14T17:31:29Z | tr_c-oq | duyu-1 | - | - | - | 3.2 | - | 101f250f284b8d8c |
| 2026-10-14T17:32:46Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 45 | 3.84 | 205502333a384f2292540e1885976850 | 816749fc718966e4 |
| 2026-10-14T17:32:48Z | tr_c-oq | duyu-1 | - | - | - | 3.84 | - | 816749fc718966e4 |

## İngilizce replik seslendirme kayıtları (tts_episode_en.py)

| Tarih (UTC) | Kimlik | Konuşmacı | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|---|
| 2026-10-14T17:36:22Z | b6_01_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 4b8f928656bca969 |
| 2026-10-14T17:36:23Z | b6_02_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 26 | ccfbcadf04fd0405 |
| 2026-10-14T17:36:24Z | b6_03_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 21 | 5cc914602622a667 |
| 2026-10-14T17:36:25Z | b6_04_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 26 | 8234b327d98acbbf |
| 2026-10-14T17:36:26Z | b6_05_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 24 | 907c03408b58ed5d |
| 2026-10-14T17:36:28Z | b6_06_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 29 | 3b93056243a7e685 |
| 2026-10-14T17:36:29Z | b6_07_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | ec0d438d635c9933 |
| 2026-10-14T17:36:30Z | b6_08_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 33 | c468441a9d3be68c |
| 2026-10-14T17:36:32Z | b6_09_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 40 | c208a5234ab12c2e |
| 2026-10-14T17:36:33Z | b6_10_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 5270dc7bdc6d2a47 |
| 2026-10-14T17:36:34Z | b6_11_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 15 | fa5c66ef1ed857b6 |
| 2026-10-14T17:36:35Z | b6_12_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 14 | 308c8f3227d091b7 |
| 2026-10-14T17:36:36Z | b6_13_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 32 | 6da496d05b75e917 |
| 2026-10-14T17:36:37Z | b6_14_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 10 | a67d2a9391f4302e |
| 2026-10-14T17:36:38Z | b6_15_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 16 | 5192198cfb889d50 |
| 2026-10-14T17:36:39Z | b6_16_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 20 | bc922675d4a4938d |
| 2026-10-14T17:36:40Z | b6_17_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 17 | 8c554b7be3066915 |
| 2026-10-14T17:36:41Z | b6_18_voice | VOICE | Lily pFZP5JQG7iQjIQuC4Bku | eleven_v3 | 0.9 | 22 | 272d63c092848fd5 |
| 2026-10-14T17:36:42Z | b6_19_voice | VOICE | Lily pFZP5JQG7iQjIQuC4Bku | eleven_v3 | 0.9 | 17 | 3ce21e888a576986 |
| 2026-10-14T17:36:44Z | b6_20_voice | VOICE | Lily pFZP5JQG7iQjIQuC4Bku | eleven_v3 | 0.9 | 32 | 975c458378ba9015 |
| 2026-10-14T17:36:45Z | b6_21_voice | VOICE | Lily pFZP5JQG7iQjIQuC4Bku | eleven_v3 | 0.9 | 15 | 9470cd993c584797 |
| 2026-10-14T17:36:46Z | b6_22_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 14 | f02342374995ad07 |
| 2026-10-14T17:36:47Z | b6_23_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 35 | d7279519bb2c7956 |
| 2026-10-14T17:36:49Z | b6_24_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 41 | 2fc2583a4ff5218d |
| 2026-10-14T17:36:51Z | b6_25_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 34 | 7a2efc3dad6fa12d |
| 2026-10-14T17:36:52Z | b6_26_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 16 | af55692e9068515e |
| 2026-10-14T17:36:54Z | b6_27_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 30 | 980c27890bea49bd |
| 2026-10-14T17:36:55Z | b6_28_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 44 | 72b10712432ec7de |

## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|
| 2026-10-14T17:36:56Z | tr_h-k1.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | 2227ee5d16c1438d |
| 2026-10-14T17:36:57Z | tr_h-k1.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | dcb309e251fc66de |
| 2026-10-14T17:36:58Z | tr_r-k2-b.p1 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 10 | e679ca0953315c31 |
| 2026-10-14T17:36:59Z | tr_h-lab1.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 8 | 162d89aaa1738394 |
| 2026-10-14T17:37:00Z | tr_h-lab1.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 9 | a16d1aeb2ffd1b12 |
| 2026-10-14T17:37:02Z | tr_h-lab1.p5 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 19 | c4dd5ec3663972c2 |
| 2026-10-14T17:37:03Z | tr_h-lab1.p7 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | a346227d71c90b51 |
| 2026-10-14T17:37:04Z | tr_t-kanit.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 10 | 8f6a37423d65f83c |
| 2026-10-14T17:37:05Z | tr_c-clues.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 43 | 9aa83334c1daa8fa |
| 2026-10-14T17:37:06Z | tr_c-clues.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 15 | 80470e6277682ecb |
