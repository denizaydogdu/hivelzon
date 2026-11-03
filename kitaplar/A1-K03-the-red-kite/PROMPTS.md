# A1-K03 The Red Kite: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1 (A1 + A2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A1-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A1-K03 *The Red Kite* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 3 bölüm, 12 sayfa, ~700 kelime (±%20). A1: her cümle ≤ 8 kelime, present simple, yan cümle yok; hareket ve yer edatları (*over, up, down, into, after, near*), hava (*The wind is very strong.*), *can / can't*. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok; fiyat birimsiz. Kapsama CEFR-J A1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Uyarlama notları:** Katalogdaki "The wind turns at noon" A1 düzeyinde ve öğle yemeği saatiyle bağ kursun diye "The wind turns at twelve" oldu (*noon* A1 dışı). Uçurtma "tramvayın çatısında" yerine "tramvayın tepesinde" (*on top of the tram*), "teknenin direğinde" yerine "beyaz teknenin üstünde"; *roof* ve *mast* gereksiz liste dışı kelime olmasın diye.

**Adil son için yerleştirilen ipuçları:** evin tepede olması ve çiçekli küçük balkon (p01); annenin "Lunch is at twelve" demesi (p01, p08); Bay Das'ın "The wind turns at twelve" demesi (p03); rüzgârın sabah uçurtmayı tepeden aşağı, nehre götürmesi (p02–p04); Ravi'nin saat on birde saatine bakması (p08); saat on ikide çalan kasaba saati ve dönen rüzgâr (p10).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14): kalan 28 kitapta **kapak + bölüm başı**. Bu kitapta 4 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png` (git dışı); diğer sayfalar resimsizdir ve kitabın paletiyle renklidir (`book.json → image: null`). Model GPT Image 2.5, 3:4, ~0,5 kr/görsel (≈ 2 kr). Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve onay alınır. Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Watercolour and ink-line storybook illustration, non-photorealistic, light loose washes with fine dark ink outlines, airy and full of movement, bright and cheerful, never scary. Palette: sky blue, soft pastel houses (pink, peach, mint, pale yellow), river grey-blue; the red kite is the only strong warm accent. Hilly harbour town by the sea. Absolutely no text, letters, numbers, signs, shop names or writing anywhere in the image; clocks have plain faces without numbers or marks. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçen tanım aynen eklenir):**
- **Ravi:** 9-year-old boy of Indian heritage, warm brown skin, short thick black hair, big bright eyes, sky-blue T-shirt, khaki shorts, white sneakers, a small wristwatch with a plain face.
- **The red kite:** a diamond-shaped bright red kite with thin yellow stripes and a short yellow ribbon tail, clearly home-made.
- **Mum:** Ravi's mother, late 30s, long black hair in a braid, mustard-yellow kurta top, warm smile.
- **Mr Das:** fruit seller in his 60s, round and cheerful, grey moustache, big white cloth hat, green apron, crates of apples, oranges and bananas.
- **The town:** pastel houses on steep hills, narrow streets with long stone stairs, an old yellow tram, a wide grey-blue river with boats, a small green ferry, a long bridge downstream.
- **Ravi's home:** a pastel house high on a hill with a small balcony full of flowers in pots.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sahne |
|---|---|
| cover.png | Ravi runs down a steep pastel street, arms reaching up; high above the rooftops the red kite flies away towards the river, tail fluttering. |
| p01.png | Sunday morning on the hilltop park: Ravi holds his new red kite high, ready to run; wind bends the trees; the pastel town and the river far below. |
| p05.png | Inside an old yellow tram going downhill; Ravi kneels on the seat with his face at the window, looking up; pastel houses pass by. |
| p09.png | Ravi stands on a small green ferry crossing the wide grey-blue river, hair blowing; ahead, a white boat with a tiny red kite on top. |

**Sürpriz kontrolü:** Sürpriz, rüzgârın öğlen dönüp uçurtmayı Ravi'nin kendi balkonuna getirmesidir. Hiçbir istemde balkon, Ravi'nin evi ya da uçurtmanın geri dönüşü yok. Kapakta uçurtma Ravi'den **uzaklaşıyor** (nehre doğru); p01'de evin balkonu değil, tepe parkı ve uzaktaki nehir var; p09 bölüm 3'ün başındaki ana (karşıya geçiş) kalır, sona geçmez. Annenin tanımı yalnız ileride gerekirse diye tutuldu; bu dört görselde kullanılmaz.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | f4a7da56-91fe-43d7-bdf9-4c6e1801a5bd | — | 2026-10-14T11:10:14+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 66ddba29-10a0-4f0f-acc1-74c0c0875ce9 | f4a7da56-91fe-43d7-bdf9-4c6e1801a5bd | 2026-10-14T11:12:59+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | b76d43f5-6bbb-4d9b-a3b0-39b40cf697cd | f4a7da56-91fe-43d7-bdf9-4c6e1801a5bd | 2026-10-14T11:13:02+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 81de1c55-d2eb-4c7a-9766-87c697259cec | f4a7da56-91fe-43d7-bdf9-4c6e1801a5bd | 2026-10-14T11:13:03+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 0.9; anlatım temposu dışa aktarmada A1 varsayılanı `auto` (§6.5). Ses, **ElevenLabs Creator** (ticari lisans) hesabıyla ve önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip onay alındıktan sonra üretilir. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T12:16:05Z | c1 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1383 | 5f7ae907388f0f9f | audio/c1.mp3 |
| 2026-10-14T12:16:25Z | c2 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1142 | 450c191ff9c8a9db | audio/c2.mp3 |
| 2026-10-14T12:16:47Z | c3 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1332 | cb106b3988bf2cf7 | audio/c3.mp3 |

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:09:21Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 410 | 28.63 | d7a1dd5c3b634f9cb516b5c10418b5f7 | b5fe9532a051cc0d |
| 2026-11-03T17:09:25Z | p01 | duyu-1 | - | - | - | 28.63 | - | b5fe9532a051cc0d |
| 2026-11-03T17:09:32Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 372 | 26.78 | 5ca97e1a076247be9d740c21d6dbbdda | 6317b5f2e9edf175 |
| 2026-11-03T17:09:36Z | p02 | duyu-1 | - | - | - | 26.78 | - | 6317b5f2e9edf175 |
| 2026-11-03T17:09:40Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 416 | 29.9 | 1371adf38c0a4aa0bb93d6cfd45e797b | 6ce50a4f345c8380 |
| 2026-11-03T17:09:43Z | p03 | duyu-1 | - | - | - | 29.9 | - | 6ce50a4f345c8380 |
| 2026-11-03T17:09:47Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 264 | 17.12 | 7e52eff6ffef493aa4d3737ba7068ad2 | 9c6be04b3751f382 |
| 2026-11-03T17:09:49Z | p04 | duyu-1 | - | - | - | 17.12 | - | 9c6be04b3751f382 |
| 2026-11-03T17:09:52Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 369 | 27.68 | cf80725481334cda861fd45f67796240 | 65edfbd58970cfe8 |
| 2026-11-03T17:09:55Z | p05 | duyu-1 | - | - | - | 27.68 | - | 65edfbd58970cfe8 |
| 2026-11-03T17:09:59Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 346 | 23.56 | 7605a96e352144589226471b87cda8b6 | dc8101fc9471d322 |
| 2026-11-03T17:10:02Z | p06 | duyu-1 | - | - | - | 23.56 | - | dc8101fc9471d322 |
| 2026-11-03T17:10:06Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 196 | 14.42 | 672bd18f242942c497f4eabe621fc4aa | d8847ba1874abbb7 |
| 2026-11-03T17:10:08Z | p07 | duyu-1 | - | - | - | 14.42 | - | d8847ba1874abbb7 |
| 2026-11-03T17:10:12Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 289 | 20.83 | ab20abb403454e268cd3c9ba7548e3d9 | 6f7d0a6b4ac9a961 |
| 2026-11-03T17:10:14Z | p08 | duyu-1 | - | - | - | 20.83 | - | 6f7d0a6b4ac9a961 |
| 2026-11-03T17:10:17Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 293 | 20.3 | 2fe21bf42edc477b85cb12b1ad1c084a | 2a7b810dde864d6e |
| 2026-11-03T17:10:20Z | p09 | duyu-1 | - | - | - | 20.3 | - | 2a7b810dde864d6e |
| 2026-11-03T17:10:24Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 339 | 24.53 | affe50e1a17d454885296a9f337b7fbf | ab4145d7208135e7 |
| 2026-11-03T17:10:26Z | p10 | duyu-1 | - | - | - | 24.53 | - | ab4145d7208135e7 |
| 2026-11-03T17:10:30Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 345 | 24.23 | 30e46de8fbc94a1abdc7e630d8da8502 | 50f826becfb8af1e |
| 2026-11-03T17:10:35Z | p11 | duyu-1 | - | - | - | 24.23 | - | 50f826becfb8af1e |
| 2026-11-03T17:10:39Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 387 | 29.18 | 4864ac76cc8343d98bfbd246e266af4a | ce72640932c8347c |
| 2026-11-03T17:10:42Z | p12 | duyu-1 | - | - | - | 29.18 | - | ce72640932c8347c |
