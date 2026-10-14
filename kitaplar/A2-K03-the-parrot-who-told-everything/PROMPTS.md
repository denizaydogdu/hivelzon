# A2-K03 The Parrot Who Told Everything: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-069 pilot kitaplar, yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A2-K03 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A2-K03 *The Parrot Who Told Everything* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 3 bölüm, 14 sayfa, ~1.400 kelime (A2 hedefi 1.500 ± %20). A2: her cümle ≤ 12 kelime; past simple (düzenli ve düzensiz), *going to*, ev kuralları listesinde *must / mustn't*, sıklık zarfları, karşılaştırma (*faster, happier, redder*). Komik zamanlama: Kaptan Max'in sözlerini tekrarlar. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J ≤ A2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Adil son için yerleştirilen ipuçları:** duvardaki tozlu eski gitar ve Bell Bey'in "Not anymore" demesi (p02); Kaptan'ın geceleri çocukların odasında uyuması (p03); Kaptan'ın odada sessiz ama gözlerinin açık olması, Max'in "You two are very brave" demesi ve ninniyi söylemesi (p10).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: pilot görselleri ≈ 15 kr (\"Görseller: Yaklaşık 15 kredi … ( onay )\", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, quality medium, 1k = 0,5 kr/görsel; sayfalar kapak işi referans verilerek üretildi (karakter tutarlılığı). Başarısız işler ücretlendirilmedi ve yeniden denendi.
> Dosya adları `book.json` ile aynı: `images/cover.png`, `images/p01.png` … `images/p14.png` (git dışı).

**Sabit stil öneki (her istemin başına):**
`Risograph-print style comic illustration, non-photorealistic, slightly misregistered ink layers and grain, flat bold shapes. Limited palette: parrot green, tomato red, mustard yellow, cream paper, dark ink blue. Chaotic but cute, exaggerated funny facial expressions, warm family-friendly humour. Absolutely no text, letters, numbers, speech bubbles, signs or writing anywhere in the image; lists, clocks and notes are drawn with abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler (her istemde adı geçen karakterin tanımı aynen eklenir):**
- **Max:** 16-year-old boy, tall and thin, messy dark-blond hair, freckles, mustard-yellow T-shirt, green checked overshirt, jeans, white socks (often covered in flour later).
- **Finn and Nora:** 7-year-old twins, same bright red curly hair, freckles, gap-toothed mischievous grins; Finn in a green striped T-shirt, Nora in a tomato-red dungaree dress.
- **Captain:** big green parrot with an orange eye ring, yellow forehead feathers, very expressive, often with a theatrical pose; lives in a large round brass cage.
- **Biscuit:** chubby light-brown cat with a white chest (later dusted white with flour).
- **Mr Bell:** tall man in his 40s, tired kind face, short brown beard, grey cardigan; wedding suit in the evening.
- **Mrs Bell:** woman in her 40s, short red hair, round glasses, energetic, mustard dress for the wedding.
- **The house:** cosy, colourful family house; living room with a green sofa and an old brown guitar on the wall; white kitchen; blue-tiled bathroom; small back garden with a bush.

**Sayfa sayfa istem (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sahne |
|---|---|
| cover.png | Captain the parrot leans out of his cage with a wide-open beak; Max behind him covers his mouth in panic; Finn and Nora giggle. |
| p01.png | Max presses his face to a music shop window, dreaming of a shiny red guitar; a phone rings in his hand. |
| p02.png | Mr Bell opens the front door; behind his legs the red-haired twins peek out with identical dangerous grins at Max. |
| p03.png | Mrs Bell hands Max a long list drawn with abstract lines; Mr Bell points at the big cage where Captain stares with one orange eye. |
| p04.png | Max sits on the green sofa with his head in his hands; Captain looks delighted; two small red curls show behind the sofa. |
| p05.png | Two red-haired heads pop up from behind the sofa laughing; then a big white cloud bursts out of the kitchen doorway. |
| p06.png | A kitchen covered in white flour; the twins stand like two little white ghosts holding an empty flour bag; Biscuit is white too. |
| p07.png | Pancake chaos: broken eggs on the floor, one pancake stuck to the ceiling, Max flipping a perfect golden pancake, the twins cheering. |
| p08.png | A blue bathroom overflowing with bubbles; an unhappy Biscuit sits in the bath; Nora holds a sponge; Max stands at the door in shock. |
| p09.png | Max lies on wet grass in his socks reaching under a bush towards Biscuit; his hair still white with flour. |
| p10.png | Night in the twins' bedroom, soft lamp light; Max sits on the floor between two beds singing; Captain listens quietly in his cage. |
| p11.png | Max stands frozen in the messy living room as Mr and Mrs Bell come in wearing wedding clothes; Captain shouts from upstairs. |
| p12.png | Mr Bell looks up at the pancake on the ceiling; Mrs Bell looks at the half-white cat; Max's face is bright tomato red. |
| p13.png | Captain sings with his eyes closed in his cage; Mr Bell's face softens; the twins in pyjamas peek from the top of the stairs. |
| p14.png | Mr Bell gives the old brown guitar to an amazed Max; Mrs Bell smiles; Captain flaps his wings happily. |


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi | Not |
|---|---|---|---|---|---|---|
| cover.png | 596443c8-257d-429b-960a-d17e27fe4f23 | — | 2026-10-14T10:00:31+00:00 | 3:4, medium, 1k | 0.5 |  |
| p02.png | fa87c169-0fdb-49ea-aa7f-ac12d880f506 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:01:11+00:00 | 3:4, medium, 1k | 0.5 |  |
| p03.png | fb78700b-031d-4193-9cc7-c7e975fc03ed | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:01:17+00:00 | 3:4, medium, 1k | 0.5 |  |
| p04.png | 4447e38f-6bb1-44cf-8ba1-afbb349daa4b | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:01:17+00:00 | 3:4, medium, 1k | 0.5 |  |
| p01.png | a8315782-28ee-4ecd-81e8-e3b6d5d87f29 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:01:29+00:00 | 3:4, medium, 1k | 0.5 |  |
| p06.png | 85f8fdc9-4195-4104-9af3-6b5c9b12e271 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:01:54+00:00 | 3:4, medium, 1k | 0.5 |  |
| p07.png | 600a59fc-71cc-4366-89a5-dcdb278d56a3 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:01:58+00:00 | 3:4, medium, 1k | 0.5 |  |
| p08.png | d6988495-de8f-49e8-8ffa-8973df97543b | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:02:04+00:00 | 3:4, medium, 1k | 0.5 |  |
| p09.png | d774f7a7-63a4-4337-b0af-445c4741e998 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:02:14+00:00 | 3:4, medium, 1k | 0.5 |  |
| p10.png | 98a5cb2c-ee99-4a17-b793-bab98f0897d3 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:02:30+00:00 | 3:4, medium, 1k | 0.5 |  |
| p12.png | 77ef47d1-8834-4b28-8401-2c5b3c7166d6 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:02:36+00:00 | 3:4, medium, 1k | 0.5 |  |
| p11.png | 962371ba-052e-4391-8420-55654d29590e | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:02:51+00:00 | 3:4, medium, 1k | 0.5 |  |
| p13.png | 7a898dfc-9c0c-4226-ad35-aba2c1daf505 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:02:52+00:00 | 3:4, medium, 1k | 0.5 |  |
| p14.png | 197ca496-2c64-4006-a048-aa23ce08135e | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:03:11+00:00 | 3:4, medium, 1k | 0.5 |  |
| p05.png | 10662875-c6d8-4648-858d-da9862458090 | 596443c8-257d-429b-960a-d17e27fe4f23 | 2026-10-14T10:04:32+00:00 | 3:4, medium, 1k | 0.5 |  |

**Toplam:** 7.5 kr. İstem = sabit stil öneki + sahnede geçen karakter/mekân tanımları + sahne (yukarıdaki tablo). Tam istem metinleri yerel `images/_jobs.json`'da (git dışı).

**Editör değerlendirmesi:** Karakter ve üslup tutarlı; görselde yazı yok. Küçük notlar: A1 p11 dört karelik kolaj olarak çizildi; A2 p10'da ikizler uyumuyor. Telif/AI: özgün istem, gerçek kişi/marka yok; uygulama içi AI notu bölüm başındaki gibi gösterilir.

## Seslendirme kayıtları (tts_book.py)

**Kısmen üretildi (2026-10-14), anlatıcı Sarah:** c1 + c2 (5.751 karakter), ücretsiz kotanın kalanıyla (kullanıcı: "6.120 karakteri bitir"); c3 (2.075) yeni anahtarla. Dışa aktarmada tempo: 120 k/dk (ham 156/162). Eski not: Pilot ses ElevenLabs ücretsiz kotasıyla, yalnız iç kullanım için üretilecek (H-069); önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilir. `narration.voiceId` henüz seçilmedi; pilotta tek anlatıcı (Kaptan'ın replikleri için ayrı ses daha sonra değerlendirilir). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T10:46:59Z | c1 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 2909 | 4459e0bfbdd74428 | audio/c1.mp3 |
| 2026-10-14T10:47:45Z | c2 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.95 | 2842 | 759f5c6c5d3aa279 | audio/c2.mp3 |
