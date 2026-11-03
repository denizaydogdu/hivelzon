# B1-K02 Where Is Pamuk?: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B1-K02 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B1 konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B1-K02 *Where Is Pamuk?* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. Kerem'in ağzından birinci tekil şahıs. 4 bölüm (Free, The Boat, The Bay, Under the Sand), 18 sayfa, ~3.000 kelime (B1 hedefi 3.000 ± %20). B1: bağlaçlı birleşik cümleler; present perfect (*ever / never, for / since, already*), past continuous (*while we were sailing*), *used to*, 1. tip koşul, *although / so*, ilgi cümleleri, *might*, past perfect (*had never seen*), *-ed / -ing* sıfatları; deniz ve doğa sözcükleri. Standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Fırtına güvenli işlenir: kararları yetişkinler verir. 13+ güvenli; gerçek marka, kurum ve kişi yok. Kapsama CEFR-J ≤ B1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Katalogdan küçük yorumlar:**
- Katalogdaki "He's too young; we can't tell yet" repliği biyolojiye uygun hâle getirildi: Sevgi Teyze Pamuk'un kuyruğunun kısa olduğunu, bunun dişi ya da henüz büyümemiş genç bir erkek anlamına gelebileceğini söyler ve "We can't tell yet." der (p04).
- Katalog yalnızca "etiket kumun altında kaldı" diyor; metinde verici yapıştırıcısı ilk yuvayı kazarken kopar ve kuma gömülür. Pamuk o gece ikinci yuvasını yapar; verici, bip eden kutuyla ilk yuvanın kenarında bulunur (p17).
- Kanca cümlesi katalogdaki gibi *her tracker* olarak kaldı: anlatıcı hikâyeyi sonradan anlatıyor, bu yüzden ilk cümlede farkında olmadan doğruyu söylüyor; hikâyenin içinde ise herkes "he" diyor. Bu, okura ilk ipucudur.

**Adil son için yerleştirilen ipuçları:**
- Kanca cümlesinde *her tracker* (p01).
- Pamuk'un kuyruğu kısa; erkeklerin kuyruğu uzun; "We can't tell yet"; herkes alışkanlıkla "he" diyor (p04).
- Verici yalnızca yüzeyde sinyal gönderir; yakından bip sesiyle bulunabilir; yapıştırıcı sonsuza kadar kalmaz, verici bir gün düşebilir (p04); "Or it has already fallen off" (p06).
- Pamuk mayısta çok yiyor ve ağırlaşıyor (p04–p05).
- Pamuk, kayıp koyun yakınındaki tepelerin yanında bir ağda bulunmuştu (p03, p06).
- Hasan Amca: "Eskiden bu kumsallar her yaz kaplumbağa izleriyle dolu olurdu"; kaplumbağaların neden sudan çıktığı sorusu cevapsız kalır (p07).
- Sevgi Teyze kumsalda ışığı yasaklar: "If there are animals here, light might frighten them" (p12); izler sudan kumsalın yukarısına çıkar ve bir çukurda biter; çukurdan kum fışkırır (p12–p13).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: B1 metinleri ve görselleri ("sana onaylar verdim", 2026-10-14). GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 5 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p10.png`, `images/p14.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 2,5 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Gouache adventure book illustration, non-photorealistic, soft opaque water-based paint with visible brush texture, wide open compositions with lots of sky and sea. Palette: Mediterranean turquoise, sand beige, pine green, warm sunset coral, deep evening blue. Mood: adventure, wonder and love of nature, warm and hopeful, never scary. South-west coast of Türkiye: small coves, red rocks, pine-covered hills, clear water. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; computer screens and maps are drawn with abstract shapes and a simple dot only, notebooks are blank, the boat has no name painted on it. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Kerem:** 16-year-old Turkish boy from the city, slim, short dark curly hair, light-brown skin, dark eyes, eager face; faded turquoise T-shirt, khaki shorts, canvas shoes; on the boat an orange life jacket that is clearly too big for him.
- **Aunt Sevgi:** Turkish woman about 45, a marine vet, practical and kind, dark hair in a low ponytail with a few grey strands, sun-tanned face, small round glasses; white short-sleeved work shirt with rolled sleeves, sand-coloured trousers, a canvas shoulder bag.
- **Uncle Hasan:** old Turkish fisherman about 70, broad and strong, deeply tanned and lined face, thick white moustache, white stubble, flat cap, faded blue work shirt, calm smiling eyes.
- **Ela:** 17-year-old local volunteer, long black hair in a braid, sporty, light-green centre T-shirt without any logo.
- **Pamuk:** a loggerhead sea turtle about one metre long, reddish-brown shell with soft patterns, big round head, gentle dark eyes; a long pale healed scar on one front flipper. While at the centre and on release day, a small plain grey box is glued to the top of the shell.
- **The rescue centre:** a white single-storey building beside a beach, with large round blue tanks of sea water inside, bright and clean.
- **Martı:** a small, old, blue wooden fishing boat with a tiny white cabin, nets and ropes on deck, a small wooden rowing boat tied behind it.
- **The bay:** a tiny hidden cove between two pine-covered hills, a beach of soft pale sand, high red-grey rocks at both ends, grass at the top of the beach.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Kerem stands at the bow of the small blue boat Martı, shading his eyes and looking towards a distant hidden cove between two green hills; turquoise sea, a few dolphins' backs in the water, dark storm clouds far away on the horizon. No turtle and no beach details are shown. |
| p01.png | p01 (Bölüm 1, Free) | Release day on the beach by the white rescue centre: Kerem and Aunt Sevgi kneel at the edge of the water as Pamuk, with the small grey box on its shell, walks into the small waves; a crowd of townspeople behind them, Uncle Hasan with a small girl on his shoulders, Ela filming with a phone (blank screen). |
| p06.png | p06 (Bölüm 2, The Boat) | Early morning in the harbour: Uncle Hasan at the helm of Martı, Kerem in a too-big orange life jacket, Aunt Sevgi with her canvas bag; the sea flat and shiny like a mirror, red rocks and pine trees along the coast. |
| p10.png | p10 (Bölüm 3, The Bay) | The boat anchored in the tiny cove as the storm arrives: dark clouds, the first heavy raindrops, white waves outside the cove, calm water inside; a warm light in the little cabin window. |
| p14.png | p14 (Bölüm 4, Under the Sand) | Before dawn on the beach: Kerem, Aunt Sevgi and Uncle Hasan sit close together on the cool sand, seen from behind, wrapped in jackets, looking up the beach towards the dark grass at the foot of the hills; the sky over the hills just turning pink and orange; a big pale moon setting over the sea. No turtle, pit or tracks are visible. |

**Sürpriz kontrolü:** Sonun sürprizi Pamuk'un dişi olması ve koyda yumurta bırakmasıdır; vericinin ilk yuvanın kumuna gömülmüş olması da sürprizin parçasıdır. Hiçbir görselde yumurta, yuva, kumdaki çukur, kaplumbağa izi ya da kumdan çıkan bir kaplumbağa gösterilmez; vericisiz bir kabuk da gösterilmez (p01'de verici kabuğun üstünde görünür). Kapak yalnızca yolculuğu ve gizemli koyu gösterir; Pamuk'u göstermez. p14 yalnızca bekleyen üç kişiyi ve şafağı gösterir; ne beklediklerini göstermez. Hiçbir görselde Pamuk'un cinsiyetine dair ipucu (kuyruk vurgusu) yoktur.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 8b679030-c3a0-4bf0-ad3f-0466589b32a1 | — | 2026-10-14T15:53:39+00:00 | 3:4, medium, 1k | 0.5 |
| p10.png | 30bbc856-2aa4-463b-84a7-823367f8794e | 8b679030-c3a0-4bf0-ad3f-0466589b32a1 | 2026-10-14T15:55:55+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | ca0f6bfe-7f01-4b74-8207-fa9f07c0c578 | 8b679030-c3a0-4bf0-ad3f-0466589b32a1 | 2026-10-14T15:55:56+00:00 | 3:4, medium, 1k | 0.5 |
| p14.png | 1d1b81ce-97dd-482e-97e8-d27063f17fbb | 8b679030-c3a0-4bf0-ad3f-0466589b32a1 | 2026-10-14T15:55:56+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | 4cae2405-15a9-4514-a9e6-657c7407c1c0 | 8b679030-c3a0-4bf0-ad3f-0466589b32a1 | 2026-10-14T15:55:56+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 2.5 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, hedef ~135 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T17:34:10Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 837 | 51.54 | f7e3f08c9f3746279bdf98e8a601f023 | 9cd9d15152a2c85a |
| 2026-11-03T17:34:14Z | p01 | duyu-1 | - | - | - | 51.54 | - | 9cd9d15152a2c85a |
| 2026-11-03T17:34:21Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 845 | 52.42 | 0591d527f32e48f6a1e23088586b062a | 3af5f08a3090d823 |
| 2026-11-03T17:34:26Z | p02 | duyu-1 | - | - | - | 52.42 | - | 3af5f08a3090d823 |
| 2026-11-03T17:34:34Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 936 | 58.66 | 043f31d557f841c0af86409590f241f3 | 4e03f368ebecfa45 |
| 2026-11-03T17:34:39Z | p03 | duyu-1 | - | - | - | 58.66 | - | 4e03f368ebecfa45 |
| 2026-11-03T17:34:48Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1043 | 66.7 | 0c73b7c5c7ed4789b378b7f0166faec9 | 850a4a0ade838693 |
| 2026-11-03T17:34:54Z | p04 | duyu-1 | - | - | - | 66.7 | - | 850a4a0ade838693 |
| 2026-11-03T17:35:03Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 888 | 56.24 | 1821768dd2574be0b9b524b95c96f309 | 439765eeae653e8e |
| 2026-11-03T17:35:10Z | p05 | duyu-1 | - | - | - | 56.24 | - | 439765eeae653e8e |
| 2026-11-03T17:35:18Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 861 | 59.41 | ca65e3ee42534c81a5396cc3d5d8de2e | ec29ab44fe3f0a02 |
| 2026-11-03T17:35:22Z | p06 | duyu-1 | - | - | - | 59.41 | - | ec29ab44fe3f0a02 |
| 2026-11-03T17:35:31Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 930 | 58.41 | 902102262cf0405d9f35811e98a5b639 | 36b16c03c6afe000 |
| 2026-11-03T17:35:37Z | p07 | duyu-1 | - | - | - | 58.41 | - | 36b16c03c6afe000 |
| 2026-11-03T17:35:46Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 836 | 54.59 | dad0640da8e845f8848ae92a0dff9d5c | b2ed52416c94dcbe |
| 2026-11-03T17:35:52Z | p08 | duyu-1 | - | - | - | 54.59 | - | b2ed52416c94dcbe |
| 2026-11-03T17:36:00Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 787 | 50.58 | 3dcb2129acc24b8a9780bce53a6108bb | c3652246a4971c99 |
| 2026-11-03T17:36:05Z | p09 | duyu-1 | - | - | - | 50.58 | - | c3652246a4971c99 |
| 2026-11-03T17:36:13Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 772 | 51.1 | e8e99f6287404987bc57aa2e9667c143 | ece955107c813eaf |
| 2026-11-03T17:36:17Z | p10 | duyu-1 | - | - | - | 51.1 | - | ece955107c813eaf |
| 2026-11-03T17:36:24Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 865 | 56.47 | 40d2a494b2c84951a3ea99646a29fb6a | 943c97826cd7da47 |
| 2026-11-03T17:36:31Z | p11 | duyu-1 | - | - | - | 56.47 | - | 943c97826cd7da47 |
| 2026-11-03T17:36:40Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 815 | 53.5 | e3445b769d8140dd8be20d602501eaaa | 660fc2266e17c4e8 |
| 2026-11-03T17:36:44Z | p12 | duyu-1 | - | - | - | 53.5 | - | 660fc2266e17c4e8 |
| 2026-11-03T17:36:52Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 840 | 54.81 | ced61377d2c64cb3b20a23f8f602edbb | 35fb847aad002119 |
| 2026-11-03T17:36:56Z | p13 | duyu-1 | - | - | - | 54.81 | - | 35fb847aad002119 |
| 2026-11-03T17:37:05Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 844 | 55.79 | c101caee5bae448d8aee6b49854192e4 | 07f7cef4edf57540 |
| 2026-11-03T17:37:09Z | p14 | duyu-1 | - | - | - | 55.79 | - | 07f7cef4edf57540 |
| 2026-11-03T17:37:17Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 768 | 50.1 | 84ca2f590e234d718f694c294edf8224 | ad244ed56897eb15 |
| 2026-11-03T17:37:21Z | p15 | duyu-1 | - | - | - | 50.1 | - | ad244ed56897eb15 |
| 2026-11-03T17:37:29Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 952 | 58.37 | a9c875b81b8848668de625ab406c262d | d42945128f2bf414 |
| 2026-11-03T17:37:38Z | p16 | duyu-1 | - | - | - | 58.37 | - | d42945128f2bf414 |
| 2026-11-03T17:37:47Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 898 | 58.32 | 6c5a947856e24a7693ad3d0eacba1df4 | 2a58e4e75fb6115b |
| 2026-11-03T17:37:51Z | p17 | duyu-1 | - | - | - | 58.32 | - | 2a58e4e75fb6115b |
| 2026-11-03T17:37:59Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 833 | 54.03 | 01b03ca44b5f4f3db6f5cc110bcc5be9 | 732d3cc1f35b601a |
| 2026-11-03T17:38:03Z | p18 | duyu-1 | - | - | - | 54.03 | - | 732d3cc1f35b601a |
