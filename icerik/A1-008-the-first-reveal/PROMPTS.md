# PROMPTS: A1-008-the-first-reveal (üretim, 2026-10-14, H-085)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low. Maliyet önce `higgsfield generate cost` ile ölçüldü: görsel başına 0,5 kr (tahmin = gerçek).
- **Kullanıcı onayı:** H-085 görevi (kullanıcı 500 kr yükledi ve bekleyen işleri onayladı; B6–B8 için tavan 45 kr).
- **Ders (B4-01) uygulandı:** Birden çok karakterli her sahnede kıyafetler açıkça yazıldı: Alex zeytin yeşili ceket + krem kazak + kanvas çanta; Maya sarı yağmurluk + mavi-beyaz çizgili kazak; Sam lacivert kapüşonlu + yuvarlak gözlük + boynunda kulaklık; Jordan turuncu kurye ceketi + gri kask ("NOT an olive jacket"); Mrs Brooks krem örgü kazak + lacivert kot önlük.
- **Kredi (hesap, `higgsfield account status`):** B6–B8 başında 451,56 → sonunda 399,56. Fark aynı hesabı kullanan başka oturumun (B9–B12) işlerini de içerir; B6–B8'in toplam harcaması **26 kr** (B6 7 · B7 7,5 · B8 11,5).
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; saat ("Friday · 6:58 pm", "7:00 pm"), babaannenin Türkçe notu, kanal "7" ve "Hilltop Café" kurguda (`signs`) eklenir. Kanal kadranında yalnız boş çentikler.
- **Referanslar:** Alex (R1), telsiz (R3), Maya (R4), Sam (R7); mekân için B3-05 liman (job `acc2c480…`).
- **Yeniden kullanılan görsel (ücretsiz):** özet B7-14. Çağrı sesi B1'den (`voice_01`, `voice_02`): bölümün keşfi tam olarak bu ("It's the same. Every word!").
- **Bu bölümün harcaması: 11,5 kr** (13 sahne görseli × 0,5 + ★ klip 5).

## ★ Kilit klip: telsizin ışığı yanar, anten titrer (sezon planı B8 ★)

| Yol | Nasıl | Çözünürlük | Kredi | Dosya | Değerlendirme |
|---|---|---|---|---|---|
| Seedance 2.0 Mini | Başlangıç: B8-02-telsiz-kapali (B8-03'ten yerelde ImageMagick ile LED karartıldı, 0 kr; yerel dosya yüklendi). Bitiş: B8-03-telsiz-acik (job `9d14250f…`). Prompt: "The small green indicator light on the old radio turns on and begins to glow softly with a faint flicker; the thin metal rods of the small handmade antenna on the right tremble very slightly in the evening wind; very slow camera push-in; the hands stay still; the harbour lights twinkle; nothing else changes." Ses kapalı, 9:16, 5 sn. | 720×1280, 5,04 sn | 5 (tahmin 5, `generate cost`) | clips/K-anten-isik-seedance-mini.mp4 (job e1093f58-186b-4129-b995-213e8a47496b; yanıt `clips/K-anten-isik-seedance-mini.json`) | ✅ Işık doğal biçimde yanıyor, yavaş yakınlaşma, eller ve kadran tutarlı. ⚠️ 720p (B1 klibiyle aynı). |

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B8-01-tepe-yolu | Alex, Maya, Sam (R7), telsiz | 0,5 | a08c8f46-1987-4bb1-8b96-57e41af18463 | Use the reference images for Alex, Maya, Sam and the old radio. Scene: Friday evening at dusk on a winding hill road above a small coastal town; far below, the harbour lights glow on the water; the three friends stop at a bend of the road. Sam holds up a small handmade directional antenna (a few thin metal rods on a short wooden handle with a thin cable); Alex holds the old cream-and-green radio in both hands; Maya holds her small notebook. Distinct outfits: Alex olive jacket over a cream sweater, canvas backpack; Maya bright yellow raincoat over a blue-and-white striped sweater; Sam navy-blue hoodie, round dark-rimmed glasses, headphones around his neck. Deep blue sky with a last orange glow. Vertical composition. |
| B8-03-telsiz-acik | telsiz, Alex | 0,5 | 9d14250f-3374-499e-b17d-5ce819bae1f3 | Use the reference images for the old radio and Alex's olive jacket sleeves. Close-up at dusk on a hill road: a young woman's hands in olive jacket sleeves hold the old cream-and-green portable radio; its small green indicator light glows brightly; beside the radio, a small handmade directional antenna (thin metal rods on a short wooden handle) is held by another hand in a navy-blue hoodie sleeve; blurred harbour lights far below in the background. No text, no numbers on the dial. Vertical composition. |
| B8-04-iki-kayit | Alex, Maya, Sam (R7), telsiz | 0,5 | 22d0c863-0889-44fc-89b3-73869771c289 | Use the reference images for Alex, Maya, Sam and the old radio. Scene: evening on the hill road under a single street lamp; Alex (olive jacket, cream sweater) holds her phone right next to the old radio with its green light on, comparing two sounds; Maya (bright yellow raincoat over a striped sweater) and Sam (navy-blue hoodie, round glasses, headphones around his neck) lean in close with their ears toward the two devices, concentrating. The phone screen shows only a simple sound wave, no text. Vertical composition. |
| B8-05-alex-farkinda | Alex, telsiz | 0,5 | 20b01d7a-25b2-4ce8-ae48-1349425ac5b9 | Use the reference images for Alex and the old radio. Scene: evening on the hill road; Alex (olive jacket over a cream sweater) holds the old radio against her chest and looks down at it with a quiet, thoughtful realisation, a little sad but calm; the town lights below are soft and blurred. Vertical composition. |
| B8-06-anten-cevirme | Sam (R7) | 0,5 | cae054fd-5477-4343-81bb-1a5beae2ab48 | Use the reference image for Sam. Scene: evening on the hill road; Sam (navy-blue hoodie, round dark-rimmed glasses, headphones on his ears now) slowly turns a small handmade directional antenna (thin metal rods on a short wooden handle) in one hand; in the other hand he holds a small handheld box with a row of five little lights, only two of them lit; intense concentration. No numbers, no text on the box. Vertical composition. |
| B8-07-k2-yon-pov | — | 0,5 | afedd89d-9dc3-4c36-b1ac-adb449f68631 | First-person point of view from a bend of a hill road at dusk, looking out over a small coastal town: three clear directions are visible at once: on the LEFT, the road climbs further up the green hill toward a small lit window among trees, and far beyond it a rocky headland with a lighthouse; STRAIGHT AHEAD, the wide open sea under the evening sky; on the RIGHT and below, the small harbour with boats and lights. A hand in a navy-blue hoodie sleeve holds a small handmade antenna in the foreground. No text, no signs. Vertical composition. |
| B8-08-sinyal-guclu | Sam (R7), Alex, Maya | 0,5 | e231bc05-d98b-4480-9d13-a612e1b32915 | Use the reference images for Sam, Alex and Maya. Scene: evening on the hill road; Sam (navy-blue hoodie, round glasses, headphones around his neck) points the small handmade antenna up toward the dark hilltop; the little handheld box in his other hand now has all five lights glowing; he grins with excitement; Alex (olive jacket, cream sweater) and Maya (bright yellow raincoat over a striped sweater) look up the hill in the same direction, amazed. No text. Vertical composition. |
| B8-09-harita-cizgi | Maya | 0,5 | 830da6f0-52bb-4738-a970-c7e5895ee72f | Use the reference image for Maya. Close-up under a street lamp in the evening: Maya's hand (yellow raincoat sleeve) draws a straight pencil line on her unfolded hand-drawn paper map, from a small hill with a tiny café drawing to a rocky headland with a tiny lighthouse drawing on the coast. The map has no labels and no letters. Vertical composition. |
| B8-10-babaanne-notu | Alex, Maya | 0,5 | ec7e333e-ea97-4c63-965f-00692716b51f | Use the reference images for Alex and Maya. Scene: evening under a street lamp on the hill road; Alex (olive jacket, cream sweater, canvas backpack) carefully unfolds a small old yellowed handwritten paper note taken from her backpack and shows it to Maya (bright yellow raincoat over a blue-and-white striped sweater), who leans in, curious. The note shows only faint illegible pencil marks, no readable letters or numbers. Tender, quiet mood. Vertical composition. |
| B8-11-kanal-dugmesi | telsiz | 0,5 | b3a97c81-b20e-4338-a0f4-f1b29e06a0df | Use the reference image for the old radio. Extreme close-up in warm lamp light: the round channel dial of the old cream-and-green portable radio, its pointer turned to one position; a young man's finger in a navy-blue hoodie sleeve taps next to the dial; the green indicator light glows. The dial has only small blank tick marks, no numbers, no text. Vertical composition. |
| B8-12-durak-yolcu | Alex, B3-05-liman | 0,5 | fb84b0d3-e241-4418-a427-a2257edaaa1f | Use the reference images for Alex and the small harbour. Scene: daytime at the small harbour bus stop shelter; Alex (olive jacket, cream sweater, jeans, canvas backpack) talks politely with a tall passenger, a young man with short dark hair, a light-grey coat and a blue shoulder bag, who points down the road to the left; a small café across the street. Blank timetable board, no text on any sign. Vertical composition. |
| B8-13-tepe-kafe-isik | — | 0,5 | 91020fa1-4159-4ce8-bdb2-63181204d86e | Night on top of a green hill above a small coastal town: among dark trees, one small café building with a single warm lit window and a blank wooden sign board above the door; a narrow path leads up to it; far away on the coast the beam of a lighthouse; stars in a deep blue sky. Quiet, inviting, mysterious. No text on the sign. Vertical composition. |
| B8-14-iyi-geceler | Alex, Maya, Sam (R7) | 0,5 | e479a5de-2f0f-4fb7-94d9-75463b3e51b4 | Use the reference images for Alex, Maya and Sam. Scene: night at a bend of the hill road under a street lamp; Sam (navy-blue hoodie, round glasses, headphones around his neck) walks off up the road with his small antenna on his shoulder, turning back to wave good night; Alex (olive jacket, cream sweater) and Maya (bright yellow raincoat over a striped sweater) wave back, smiling, excited for tomorrow. Vertical composition. |

- **Toplam:** 13 sahne görseli (6,5 kr) + B8-02 yerel (0) + ★ klip (5 kr) = **11,5 kr**.
- **Değerlendirme (Claude, temas sayfası `.yerel/h-085/kontak-B8.jpg`):** Yazı ve rakam yok (sinyal kutusunda yalnız ışıklar, kafe tabelası boş, not okunmaz). Alex, Maya, Sam tutarlı. B8-07 POV'da üç yön ayırt ediliyor (solda tepe ve uzakta fener, önde deniz, sağda liman). B8-12'deki yolcu uzun boylu ve mavi çantalı (kanıt görevindeki "He is tall. He has a blue bag."). Fener birçok karede ufukta (tepe → Lumen Point yönü bu bölümün keşfi; ad açılmıyor). Editör değerlendirmesi bekliyor (H-028).

## Seslendirme

- **Türkçe (H-083):** `tts_episode_tr.py --tr-only --execute`, PatientDesk Alania (kampanya, 2026-11-14'e kadar ücretsiz) + Duyu hizalaması. Saf Türkçe sesler bitti; İngilizce ifade içeren seslerin Türkçe parçaları `audio/_raw/` önbelleğinde, Sarah parçaları kota gelince yeniden Alania ücreti olmadan birleşir. Kayıtlar aşağıdaki tabloda.
- **İngilizce replikler:** ElevenLabs kotası bittiği için üretilmedi. Kuru çalışma (`tts_episode_en.py`): 29 replik, **805 karakter** (Alex/Jessica 12 satır 339 · Maya/Sarah 8 satır 223 · Sam/**ses yok** 9 satır 243). **Sam'in sesi kullanıcı onayı bekliyor.**
- **Yeniden kullanılan sesler:** çağrı = B1 `voice_01`, `voice_02` (telsiz süzgeci).

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T17:31:59Z | tr_r-k1-b | alania-v2 | alania2-f1 | alania-v2.1 | 62 | 4.96 | 2411dcb754bf46d2ac7c7d006608c424 | 05122090469506df |
| 2026-10-14T17:32:00Z | tr_r-k1-b | duyu-1 | - | - | - | 4.96 | - | 05122090469506df |
| 2026-10-14T17:32:01Z | tr_t-gorev | alania-v2 | alania2-f1 | alania-v2.1 | 64 | 4.16 | 7254bf4f08714a7291eacdd39b46b793 | 239a04ef433b2a43 |
| 2026-10-14T17:32:02Z | tr_t-gorev | duyu-1 | - | - | - | 4.16 | - | 239a04ef433b2a43 |
| 2026-10-14T17:32:04Z | tr_t-kanit | alania-v2 | alania2-f1 | alania-v2.1 | 73 | 4.96 | df984f740f6c43468ca5b096796d8e4c | 9186be5ae4ed0c7f |
| 2026-10-14T17:32:05Z | tr_t-kanit | duyu-1 | - | - | - | 4.96 | - | 9186be5ae4ed0c7f |
| 2026-10-14T17:32:06Z | tr_c-alex1 | alania-v2 | alania2-nisa | alania-v2.1 | 32 | 2.56 | 7fa8fd1deb5e43a88fd2dc15ff120f05 | 19f78b79db139c93 |
| 2026-10-14T17:32:07Z | tr_c-alex1 | duyu-1 | - | - | - | 2.56 | - | 19f78b79db139c93 |
| 2026-10-14T17:32:08Z | tr_c-alex2 | alania-v2 | alania2-nisa | alania-v2.1 | 34 | 2.56 | 11d637c57a21416faf2c12f2a891587d | 1416b5a65d98e10a |
| 2026-10-14T17:32:09Z | tr_c-alex2 | duyu-1 | - | - | - | 2.56 | - | 1416b5a65d98e10a |
| 2026-10-14T17:32:10Z | tr_r-k3-b.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.56 | 8768cb5a4be64c38b523f9fa1ef11756 | 2d97d3b5af8dfbeb |
| 2026-10-14T17:32:11Z | tr_r-k3-b.p1 | duyu-1 | - | - | - | 2.56 | - | 2d97d3b5af8dfbeb |
| 2026-10-14T17:32:12Z | tr_r-k3-b.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.76 | b91a4e7012044665a6c696f47fad4bf0 | 17f943675622d632 |
| 2026-10-14T17:32:12Z | tr_r-k3-b.p3 | duyu-1 | - | - | - | 1.76 | - | 17f943675622d632 |
| 2026-10-14T17:32:13Z | tr_r-k3-b.p5 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.76 | 4a030482e38e4c9fbcf44944c08bbed1 | 70fe832120ff0a57 |
| 2026-10-14T17:32:14Z | tr_r-k3-b.p5 | duyu-1 | - | - | - | 1.76 | - | 70fe832120ff0a57 |
| 2026-10-14T17:32:15Z | tr_r-k3-b.p7 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.6 | 4794bb8fff594fa29bcb975785a1649b | 7a360b9f8bb5b980 |
| 2026-10-14T17:32:15Z | tr_r-k3-b.p7 | duyu-1 | - | - | - | 1.6 | - | 7a360b9f8bb5b980 |
| 2026-10-14T17:32:16Z | tr_h-lab1.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 29 | 2.24 | 3d80d41721234a5fac79a2385b55b248 | 3a693991e6619358 |
| 2026-10-14T17:32:17Z | tr_h-lab1.p1 | duyu-1 | - | - | - | 2.24 | - | 3a693991e6619358 |
| 2026-10-14T17:32:18Z | tr_h-lab1.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.6 | 26d8cfa45c1b4e0ca829f74c8a00f88d | 5c8f520d707516e3 |
| 2026-10-14T17:32:19Z | tr_h-lab1.p3 | duyu-1 | - | - | - | 1.6 | - | 5c8f520d707516e3 |
| 2026-10-14T17:32:20Z | tr_c-clues.p1 | alania-v2 | alania2-m1 | alania-v2.1 | 68 | 6.08 | 46576641bc41495da9744de2c0195500 | 545a73be8dc43525 |
| 2026-10-14T17:32:21Z | tr_c-clues.p1 | duyu-1 | - | - | - | 6.08 | - | 545a73be8dc43525 |
| 2026-10-14T17:32:22Z | tr_c-clues.p3 | alania-v2 | alania2-m1 | alania-v2.1 | 88 | 5.92 | 1290197656dc4f6984ecca64f12bfd34 | 86ef4f4eea13e08f |
| 2026-10-14T17:32:23Z | tr_c-clues.p3 | duyu-1 | - | - | - | 5.92 | - | 86ef4f4eea13e08f |
| 2026-10-14T17:32:25Z | tr_c-oq | alania-v2 | alania2-m1 | alania-v2.1 | 41 | 3.36 | 200f1d94ce2d4bdcb5c605be3448a03e | 5ddc57a2f993f15e |
| 2026-10-14T17:32:26Z | tr_c-oq | duyu-1 | - | - | - | 3.36 | - | 5ddc57a2f993f15e |
| 2026-10-14T17:32:51Z | tr_h-lab1.p1 | alania-v2 | alania2-f1 | alania-v2.1 | 52 | 3.2 | 7d7430d63fe14a42926019c1723a9dc2 | 1f9646f83d322408 |
| 2026-10-14T17:32:52Z | tr_h-lab1.p1 | duyu-1 | - | - | - | 3.2 | - | 1f9646f83d322408 |
| 2026-10-14T17:32:53Z | tr_h-lab1.p3 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.8 | d160bdff5ced4629910525dd755bdf20 | 62622e1fcbae1bec |
| 2026-10-14T17:32:53Z | tr_h-lab1.p3 | duyu-1 | - | - | - | 0.8 | - | 62622e1fcbae1bec |

## İngilizce replik seslendirme kayıtları (tts_episode_en.py)

| Tarih (UTC) | Kimlik | Konuşmacı | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|---|
| 2026-10-14T17:38:08Z | b8_01_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 16 | cd61bf0cc67fc223 |
| 2026-10-14T17:38:09Z | b8_02_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 27 | 60e564ac60180d78 |
| 2026-10-14T17:38:10Z | b8_03_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 27 | 8351afa8725ca482 |
| 2026-10-14T17:38:12Z | b8_04_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 19 | d9cbe0ca1e884f66 |
| 2026-10-14T17:38:13Z | b8_05_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 26 | 30ba53c034bccf5e |
| 2026-10-14T17:38:14Z | b8_06_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 28 | 14b51cfa7f7136ca |
| 2026-10-14T17:38:15Z | b8_07_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 25 | c53e50029e45adbb |
| 2026-10-14T17:38:17Z | b8_08_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 26 | d9bee76ea29efe67 |
| 2026-10-14T17:38:18Z | b8_09_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 22 | 0906367e0bbf3b11 |
| 2026-10-14T17:38:20Z | b8_10_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 40 | d47f54d62dfc8c4e |
| 2026-10-14T17:38:22Z | b8_11_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 34 | ef6ca6ce902f1a37 |
| 2026-10-14T17:38:23Z | b8_12_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 23 | e7c103d33bfca108 |
| 2026-10-14T17:38:24Z | b8_13_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 23 | ae363d6612636dbc |
| 2026-10-14T17:38:26Z | b8_14_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 43 | 26862856d0be60f6 |
| 2026-10-14T17:38:28Z | b8_15_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 34 | 1a3becbb33d2ab31 |
| 2026-10-14T17:38:29Z | b8_16_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 14 | dcad8dbda5baf404 |
| 2026-10-14T17:38:30Z | b8_17_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 13 | 810d7c3ca6aa6411 |
| 2026-10-14T17:38:31Z | b8_18_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 32 | e21f4b9e0fd4555d |
| 2026-10-14T17:38:33Z | b8_19_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 27 | 7d5988995ab76939 |
| 2026-10-14T17:38:35Z | b8_20_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 51 | 5201c314e4805567 |
| 2026-10-14T17:38:36Z | b8_21_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 42 | 0c0d23cf517b6c4c |
| 2026-10-14T17:38:38Z | b8_22_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 21 | ee43d8712a880ac3 |
| 2026-10-14T17:38:39Z | b8_23_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 37 | 1a3e9185b525a0e8 |
| 2026-10-14T17:38:40Z | b8_24_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 18 | fef68b7b9841e6d7 |
| 2026-10-14T17:38:41Z | b8_25_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 14 | 4f05e2e6f4917f80 |
| 2026-10-14T17:38:43Z | b8_26_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 28 | 77dcd85aa94991fc |
| 2026-10-14T17:38:44Z | b8_27_maya | MAYA | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 32 | 7320916777dd98e0 |
| 2026-10-14T17:38:46Z | b8_28_alex | ALEX | Jessica cgSgspJ2msm6clMCkdW9 | eleven_v3 | 0.9 | 31 | 1fb065abbca28c14 |
| 2026-10-14T17:38:47Z | b8_29_sam | SAM | Liam TX3LPaxmHKxFdv7VOQHJ | eleven_v3 | 0.9 | 32 | a0b39c379f460ff7 |

## İngilizce ifade seslendirme kayıtları (tts_episode_tr.py)

| Tarih (UTC) | Parça | Ses | Model | Hız | Karakter | Metin sha256 |
|---|---|---|---|---|---|---|
| 2026-10-14T17:38:48Z | tr_r-k3-b.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 6 | e21f3f372a46d4be |
| 2026-10-14T17:38:50Z | tr_r-k3-b.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | 9eabf78ee51d7ae9 |
| 2026-10-14T17:38:51Z | tr_r-k3-b.p6 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | edbe5beb0f5946d4 |
| 2026-10-14T17:38:52Z | tr_r-k3-b.p8 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 13 | a991476846335b0e |
| 2026-10-14T17:38:54Z | tr_h-lab1.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 8 | 469232241405bd42 |
| 2026-10-14T17:38:55Z | tr_h-lab1.p4 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 25 | c53e50029e45adbb |
| 2026-10-14T17:38:57Z | tr_c-clues.p2 | Sarah EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 51 | 5201c314e4805567 |
| 2026-11-28T06:49:32Z | l-e920309665 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.44 | d1a97403bffd4a889371396704ca2dda | 88392024cc07377b |
| 2026-11-28T06:49:34Z | l-e920309665 | duyu-1 | - | - | - | 1.44 | - | 88392024cc07377b |
| 2026-11-28T06:49:35Z | l-cd61bf0cc6 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 1.28 | a556dda5b4674b25a935671df1848d49 | 0452ceadda5b16d2 |
| 2026-11-28T06:49:36Z | l-cd61bf0cc6 | duyu-1 | - | - | - | 1.28 | - | 0452ceadda5b16d2 |
| 2026-11-28T06:49:37Z | l-60e564ac60 | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.92 | 9f14163d380144558ada3ded61e6e161 | a9d5535abd6dcbaa |
| 2026-11-28T06:49:38Z | l-60e564ac60 | duyu-1 | - | - | - | 1.92 | - | a9d5535abd6dcbaa |
| 2026-11-28T06:49:40Z | l-aaf2190772 | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.64 | a4158538284f47bebb93062d1a6d1c79 | cb895fea667eceb8 |
| 2026-11-28T06:49:41Z | l-aaf2190772 | duyu-1 | - | - | - | 0.64 | - | cb895fea667eceb8 |
| 2026-11-28T06:49:42Z | l-37e79c35d4 | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.6 | d0cb7e20116b4e6c8f8bb402d1246a81 | a87521cf883b0062 |
| 2026-11-28T06:49:43Z | l-37e79c35d4 | duyu-1 | - | - | - | 1.6 | - | a87521cf883b0062 |
| 2026-11-28T06:49:45Z | l-8351afa872 | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.72 | e7218d7e730c49669e9827d769625c23 | c44322241cb42173 |
| 2026-11-28T06:49:46Z | l-8351afa872 | duyu-1 | - | - | - | 2.72 | - | c44322241cb42173 |
| 2026-11-28T06:49:47Z | l-aef7491dc7 | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.8 | a3152ddab3b44444a1a7f94e22135864 | bb833e5f1c35faa1 |
| 2026-11-28T06:49:48Z | l-aef7491dc7 | duyu-1 | - | - | - | 0.8 | - | bb833e5f1c35faa1 |
| 2026-11-28T06:49:50Z | l-9242eb956c | alania-v2 | alania2-f1 | alania-v2.1 | 30 | 2.08 | efd665bd098c49c9a55694ccc49c3ee3 | 8dbedf2a05d0f4a1 |
| 2026-11-28T06:49:51Z | l-9242eb956c | duyu-1 | - | - | - | 2.08 | - | 8dbedf2a05d0f4a1 |
| 2026-11-28T06:49:52Z | l-09a8f386b0 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.6 | 36e383970ee448ca9e9460ff3220bbf8 | b708eaecbf9eda25 |
| 2026-11-28T06:49:54Z | l-09a8f386b0 | duyu-1 | - | - | - | 1.6 | - | b708eaecbf9eda25 |
| 2026-11-28T06:49:55Z | l-5cddd4f42f | alania-v2 | alania2-f1 | alania-v2.1 | 54 | 4.8 | 412871cf65fc40129e8381308e7ab0b0 | 84736c0aced0dbb2 |
| 2026-11-28T06:49:56Z | l-5cddd4f42f | duyu-1 | - | - | - | 4.8 | - | 84736c0aced0dbb2 |
| 2026-11-28T06:49:58Z | l-d9cbe0ca1e | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 384607db96a647dfaf70dba364b3e924 | 55422409898f0800 |
| 2026-11-28T06:49:59Z | l-d9cbe0ca1e | duyu-1 | - | - | - | 1.28 | - | 55422409898f0800 |
| 2026-11-28T06:50:01Z | l-7c2c7bd1a5 | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 0.8 | 0b46796d8c1f46bfbf447fb64c03e491 | 9251b3c2383584f6 |
| 2026-11-28T06:50:02Z | l-7c2c7bd1a5 | duyu-1 | - | - | - | 0.8 | - | 9251b3c2383584f6 |
| 2026-11-28T06:50:03Z | l-e558cdf17f | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 2.08 | 7d414bd92d374992a5753cf6466d71fc | 080f01dcce9ecfdc |
| 2026-11-28T06:50:04Z | l-e558cdf17f | duyu-1 | - | - | - | 2.08 | - | 080f01dcce9ecfdc |
| 2026-11-28T06:50:06Z | l-14b51cfa7f | alania-v2 | alania2-f1 | alania-v2.1 | 27 | 1.92 | b80cf9b460f244b691fa379b1512d6e6 | 103cdb96c620ba62 |
| 2026-11-28T06:50:07Z | l-14b51cfa7f | duyu-1 | - | - | - | 1.92 | - | 103cdb96c620ba62 |
| 2026-11-28T06:50:08Z | l-c53e50029e | alania-v2 | alania2-f1 | alania-v2.1 | 19 | 1.76 | e95230b292d6446a9584a5a4c5bc5f21 | af32b4c3c4d298af |
| 2026-11-28T06:50:09Z | l-c53e50029e | duyu-1 | - | - | - | 1.76 | - | af32b4c3c4d298af |
| 2026-11-28T06:50:11Z | l-4084d0411c | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 2.08 | 875b47ebef9945f99bafdcb8d0b04b11 | bdd1f57167330fcf |
| 2026-11-28T06:50:12Z | l-4084d0411c | duyu-1 | - | - | - | 2.08 | - | bdd1f57167330fcf |
| 2026-11-28T06:50:14Z | l-021e46faf0 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 7e8c5ad35e484f8a86e2c76dab838f66 | b0543b595683ddd9 |
| 2026-11-28T06:50:15Z | l-021e46faf0 | duyu-1 | - | - | - | 1.28 | - | b0543b595683ddd9 |
| 2026-11-28T06:50:16Z | l-0906367e0b | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 2.88 | 49c78d7abe2140fa99e2db93b19d436c | ff6c415e24988358 |
| 2026-11-28T06:50:17Z | l-0906367e0b | duyu-1 | - | - | - | 2.88 | - | ff6c415e24988358 |
| 2026-11-28T06:50:19Z | l-10715d408e | alania-v2 | alania2-f1 | alania-v2.1 | 26 | 2.08 | ce65c16572054183a0cd4323e297add2 | 625e59b1cf661641 |
| 2026-11-28T06:50:20Z | l-10715d408e | duyu-1 | - | - | - | 2.08 | - | 625e59b1cf661641 |
| 2026-11-28T06:50:22Z | l-185886c430 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 0.96 | a83a9e4eecce4821841c5e01f6d65fba | e8e47acd0d82efe8 |
| 2026-11-28T06:50:23Z | l-185886c430 | duyu-1 | - | - | - | 0.96 | - | e8e47acd0d82efe8 |
| 2026-11-28T06:50:24Z | l-869e610b8e | alania-v2 | alania2-f1 | alania-v2.1 | 9 | 0.96 | 18cc107a96384307b43afed4a231831b | aa4fc733e58a9841 |
| 2026-11-28T06:50:25Z | l-869e610b8e | duyu-1 | - | - | - | 0.96 | - | aa4fc733e58a9841 |
| 2026-11-28T06:50:27Z | l-1e7649982b | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.28 | 63f947da87fa4cbca56b2841d8634518 | cdaf258a39342400 |
| 2026-11-28T06:50:28Z | l-1e7649982b | duyu-1 | - | - | - | 1.28 | - | cdaf258a39342400 |
| 2026-11-28T06:50:29Z | l-e7c103d33b | alania-v2 | alania2-f1 | alania-v2.1 | 18 | 1.6 | 0d6fbb3e53b74b48b08924d8e135ff7e | 84fe4b0649f9f2f6 |
| 2026-11-28T06:50:30Z | l-e7c103d33b | duyu-1 | - | - | - | 1.6 | - | 84fe4b0649f9f2f6 |
| 2026-11-28T06:50:32Z | l-ae363d6612 | alania-v2 | alania2-f1 | alania-v2.1 | 16 | 1.28 | ac0544c365f54505a792dada0ec39add | 2ef6227b0766331b |
| 2026-11-28T06:50:33Z | l-ae363d6612 | duyu-1 | - | - | - | 1.28 | - | 2ef6227b0766331b |
| 2026-11-28T06:50:34Z | l-b74cbc4023 | alania-v2 | alania2-f1 | alania-v2.1 | 21 | 2.08 | 05e6203417dd4fc6bb49edc2628a42a7 | caad4cee906400ae |
| 2026-11-28T06:50:35Z | l-b74cbc4023 | duyu-1 | - | - | - | 2.08 | - | caad4cee906400ae |
| 2026-11-28T06:50:37Z | l-4a09f951d9 | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.44 | f7d9f138bd7e42de98aad290a221c61e | b6e0f774a02e5fd4 |
| 2026-11-28T06:50:38Z | l-4a09f951d9 | duyu-1 | - | - | - | 1.44 | - | b6e0f774a02e5fd4 |
| 2026-11-28T06:50:40Z | l-08c6e5abaa | alania-v2 | alania2-f1 | alania-v2.1 | 13 | 1.12 | 03841bd921764db8b453beb665df66f1 | 0272cc8ef2f8293b |
| 2026-11-28T06:50:41Z | l-08c6e5abaa | duyu-1 | - | - | - | 1.12 | - | 0272cc8ef2f8293b |
| 2026-11-28T06:50:42Z | l-10931d15ff | alania-v2 | alania2-f1 | alania-v2.1 | 20 | 1.44 | ba22b617d9f2415ba45616d9f266a2ee | aa1c9af8c89f2f3a |
| 2026-11-28T06:50:43Z | l-10931d15ff | duyu-1 | - | - | - | 1.44 | - | aa1c9af8c89f2f3a |
| 2026-11-28T06:50:44Z | l-dcad8dbda5 | alania-v2 | alania2-f1 | alania-v2.1 | 10 | 0.96 | 8b86b184e982402796e3a4b56a40091f | 392efe7d3b49ff40 |
| 2026-11-28T06:50:45Z | l-dcad8dbda5 | duyu-1 | - | - | - | 0.96 | - | 392efe7d3b49ff40 |
| 2026-11-28T06:50:47Z | l-810d7c3ca6 | alania-v2 | alania2-f1 | alania-v2.1 | 11 | 0.96 | be2f9bd482ba4616a9417c6898d6af6b | ccf713d6a7979434 |
| 2026-11-28T06:50:48Z | l-810d7c3ca6 | duyu-1 | - | - | - | 0.96 | - | ccf713d6a7979434 |
| 2026-11-28T06:50:49Z | l-ddfd032cce | alania-v2 | alania2-f1 | alania-v2.1 | 6 | 0.96 | 0f8a1bb8be334431a960ba5cffbe79ce | 322c2cfd79253d10 |
| 2026-11-28T06:50:50Z | l-ddfd032cce | duyu-1 | - | - | - | 0.96 | - | 322c2cfd79253d10 |
| 2026-11-28T06:50:51Z | l-841e69986e | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.28 | 773914f81462489894864ab6dd07f366 | 439e76bf31c215d8 |
| 2026-11-28T06:50:52Z | l-841e69986e | duyu-1 | - | - | - | 1.28 | - | 439e76bf31c215d8 |
| 2026-11-28T06:50:54Z | l-e21f4b9e0f | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 1.92 | 7bf59671cec1442f94a40f22b2fe9987 | 2cea6dd1c7fd08b1 |
| 2026-11-28T06:50:55Z | l-e21f4b9e0f | duyu-1 | - | - | - | 1.92 | - | 2cea6dd1c7fd08b1 |
| 2026-11-28T06:50:57Z | l-7d5988995a | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.92 | 14da681af8ff4296a66ee5837bd108c5 | b24ec8512ef13ac9 |
| 2026-11-28T06:50:58Z | l-7d5988995a | duyu-1 | - | - | - | 1.92 | - | b24ec8512ef13ac9 |
| 2026-11-28T06:53:33Z | l-0637318fcc | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.08 | 6d32c94bf65640abba52472cbd6c58da | f7a5bad3545536d0 |
| 2026-11-28T06:53:34Z | l-0637318fcc | duyu-1 | - | - | - | 2.08 | - | f7a5bad3545536d0 |
| 2026-11-28T06:53:36Z | l-af162cad8b | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 2.24 | 974e16d18c39401495988646fbe6cd2d | eb3438198f6defb8 |
| 2026-11-28T06:53:37Z | l-af162cad8b | duyu-1 | - | - | - | 2.24 | - | eb3438198f6defb8 |
| 2026-11-28T06:53:38Z | l-9548b3b4df | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.4 | 37fc80eb26e345fc8a62244abc1ba6fe | 5421e2b1f90dd001 |
| 2026-11-28T06:53:39Z | l-9548b3b4df | duyu-1 | - | - | - | 2.4 | - | 5421e2b1f90dd001 |
| 2026-11-28T06:53:41Z | l-ee43d8712a | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.92 | ed575fe97ad44221badc08d123f03213 | 7091ccdaf575078d |
| 2026-11-28T06:53:42Z | l-ee43d8712a | duyu-1 | - | - | - | 1.92 | - | 7091ccdaf575078d |
| 2026-11-28T06:53:44Z | l-4f05e2e6f4 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.6 | a1ff8351e2c040d3ba9dffdd6e3ad53b | a7845a9d87798bd8 |
| 2026-11-28T06:53:45Z | l-4f05e2e6f4 | duyu-1 | - | - | - | 1.6 | - | a7845a9d87798bd8 |
| 2026-11-28T06:53:46Z | l-e24cd036c9 | alania-v2 | alania2-f1 | alania-v2.1 | 7 | 0.96 | 74e99bf05f734bc19cff873e33ad8489 | 3bdb3adcf2d949bb |
| 2026-11-28T06:53:47Z | l-e24cd036c9 | duyu-1 | - | - | - | 0.96 | - | 3bdb3adcf2d949bb |
| 2026-11-28T06:53:48Z | l-7619eed4e6 | alania-v2 | alania2-f1 | alania-v2.1 | 22 | 2.24 | 782c5fd8c65144a1be0e5c2043b9b586 | 02408432918b49ff |
| 2026-11-28T06:53:49Z | l-7619eed4e6 | duyu-1 | - | - | - | 2.24 | - | 02408432918b49ff |
| 2026-11-28T06:53:51Z | l-2960a46f72 | alania-v2 | alania2-f1 | alania-v2.1 | 15 | 1.12 | 6f9a146afaa34538b1a1a8d409b9ad0c | 69e2bc9ead53a74f |
| 2026-11-28T06:53:51Z | l-2960a46f72 | duyu-1 | - | - | - | 1.12 | - | 69e2bc9ead53a74f |
| 2026-11-28T06:53:53Z | l-fef68b7b98 | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.12 | bf55bd9bc4f9483cb643bfef0f0a5ad5 | fc22ad2888a93588 |
| 2026-11-28T06:53:54Z | l-fef68b7b98 | duyu-1 | - | - | - | 1.12 | - | fc22ad2888a93588 |
| 2026-11-28T06:53:55Z | l-77dcd85aa9 | alania-v2 | alania2-f1 | alania-v2.1 | 23 | 1.6 | e3b2bf13f7f74416b6c03046be1c817a | 2a53b08dfd5cb7ca |
| 2026-11-28T06:53:56Z | l-77dcd85aa9 | duyu-1 | - | - | - | 1.6 | - | 2a53b08dfd5cb7ca |
| 2026-11-28T06:53:58Z | l-7320916777 | alania-v2 | alania2-f1 | alania-v2.1 | 33 | 3.04 | 2f560c362e004112b2b78ff6f9d23908 | 97dac51f228ea61c |
| 2026-11-28T06:53:59Z | l-7320916777 | duyu-1 | - | - | - | 3.04 | - | 97dac51f228ea61c |
| 2026-11-28T06:54:01Z | l-bfe9575dca | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.44 | 82e54606b58c4eff872701823321ce15 | a225d95ce5343398 |
| 2026-11-28T06:54:02Z | l-bfe9575dca | duyu-1 | - | - | - | 1.44 | - | a225d95ce5343398 |
| 2026-11-28T06:54:03Z | l-c9c56d0ea7 | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.6 | 072e787129644bde8cd6d709c5cdca1d | 2afff22d5aadc1e4 |
| 2026-11-28T06:54:04Z | l-c9c56d0ea7 | duyu-1 | - | - | - | 1.6 | - | 2afff22d5aadc1e4 |
| 2026-11-28T06:54:05Z | l-cd921e03ed | alania-v2 | alania2-f1 | alania-v2.1 | 12 | 1.12 | 4958adf3de1149d387f0f835f3348724 | 4e9b38eb2185c3cf |
| 2026-11-28T06:54:06Z | l-cd921e03ed | duyu-1 | - | - | - | 1.12 | - | 4e9b38eb2185c3cf |
| 2026-11-28T06:54:08Z | l-bd81e844eb | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.76 | efc3cdecd9c444b583d061c445832154 | b29749893258a76f |
| 2026-11-28T06:54:09Z | l-bd81e844eb | duyu-1 | - | - | - | 1.76 | - | b29749893258a76f |
| 2026-11-28T06:54:10Z | l-550fa02858 | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.44 | 8598c4fafffa4c44a74c834685b42d73 | abcd82bf3a917f3c |
| 2026-11-28T06:54:11Z | l-550fa02858 | duyu-1 | - | - | - | 1.44 | - | abcd82bf3a917f3c |
| 2026-11-28T06:54:12Z | l-878fa9a2fa | alania-v2 | alania2-f1 | alania-v2.1 | 24 | 3.04 | 7866736e236c44ba82833cc0d5b3f911 | 4904ed4594801883 |
| 2026-11-28T06:54:14Z | l-878fa9a2fa | duyu-1 | - | - | - | 3.04 | - | 4904ed4594801883 |
| 2026-11-28T06:54:15Z | l-9efc15208e | alania-v2 | alania2-f1 | alania-v2.1 | 14 | 1.44 | 6f2db7395f9b4b99b04b9bf538bed90f | 868bbc3b81881d8c |
| 2026-11-28T06:54:16Z | l-9efc15208e | duyu-1 | - | - | - | 1.44 | - | 868bbc3b81881d8c |
| 2026-11-28T06:54:18Z | p-2b2e6386fd | alania-v2 | alania2-f1 | alania-v2.1 | 4 | 0.64 | 8908d7822d2342e1a82405bd27d816ad | 9c9f49343affc33c |
| 2026-11-28T06:54:19Z | p-2b2e6386fd | duyu-1 | - | - | - | 0.64 | - | 9c9f49343affc33c |
| 2026-11-28T06:54:20Z | p-028d920546 | alania-v2 | alania2-f1 | alania-v2.1 | 17 | 1.44 | 018a10dc8d44406d9f9f16f965b9ea1a | 56cd1da3d42a9cc5 |
| 2026-11-28T06:54:21Z | p-028d920546 | duyu-1 | - | - | - | 1.44 | - | 56cd1da3d42a9cc5 |
