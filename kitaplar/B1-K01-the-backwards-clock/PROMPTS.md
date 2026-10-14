# B1-K01 The Backwards Clock: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B1), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B1-K01 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B1 konuları |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B1-K01 *The Backwards Clock* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize uyarak yaz. 5 bölüm, 20 sayfa, ~3.000 kelime (B1 hedefi 3.000 ± %20). B1: bağlaçlı birleşik cümleler; past simple anlatı, gereken yerde past perfect (*had never heard*), *used to*, present perfect (*ever / never, for / since, yet*), past continuous (*while*), 1. tip koşul, ilgi cümleleri (*who / which / that*), *might*, *-ed / -ing* sıfatları. İngiliz yazımı. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli; gerçek marka ve kişi yok; dağ kasabası Haldenberg kurmaca. Kapsama CEFR-J ≤ B1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Katalogdan küçük yorumlar:**
- Katalogda 2. bölümün kancası "Saat bu kez 7.15'te durmuştur." Metinde saat her cumartesi bir saat daha erken durur (11.15 → 10.15 → 9.15 → 8.15); 2. bölümün kancası Aziz'in bu düzeni fark edip bir sonraki duruşun **yediyi çeyrek geçe** olacağını hesaplamasıdır ("Somebody was counting down. But to what?"). Saat 7.15'te ancak son gece durur. Böylece "geri sayım" ipucu adil biçimde önceden verilir.
- Katalogdaki "dansın 30 yıl önce son kez yapıldığı tarihe geri sayım" fikri: 7.15, vadiden gelen son otobüsün varış ve müziğin başlama saatidir; son gece, son dansın 30. yıl dönümü olan ağustosun son cumartesisidir.
- 4. ve 5. bölüm aynı gecede geçer: Aziz yaşlıları kulede yakalar, saati 7.15'te kendisi durdurur ve dans aynı gece başlar. Son sayfa (p20) Aziz'in saati yeniden doğru çalıştırmasıdır.
- Dans grubunun beş yaşlısının adları: Otto (akordeon), Rosa ve Bernard (keman), Klaus (davul), Hanne. Kütüphaneci Pavel ayrı, genç bir karakterdir.

**Adil son için yerleştirilen ipuçları:**
- Bayan Brandt'ın çok küçük ayakları ve yeşil ayakkabıları (p02); kuledeki küçük, yıldız desenli izler (p05); ayakkabılarının üstündeki gri kule tozu (p11); dans fotoğrafındaki ayakları yere değmeyen ufak tefek genç kadın (p10).
- Dükkânın arkasındaki hep kilitli küçük kapı, "yalnızca eski kutular" (p02); kule kapısını bütün gece izleyen Aziz'in kimseyi görmemesi (p07); taze yağ (p04).
- "Dizlerim o merdivenler için fazla yaşlı" (p04) ama dükkândaki merdivene kedi gibi çıkması (p12); "Hayaletini yakaladın mı?" sorusuna aniden gülmesi (p05); "Uzun bir gece olabilir" (p13).
- Kafedeki beş yaşlının hayaletten hiç endişe etmemesi, gri sakallı adamın kahvesine gülümsemesi (p03, p08); fotoğraftaki akordeon çalan genç adamın tanıdık yüzü (p10).
- Marta'nın anlattığı dans, son otobüs ve yediyi çeyrek geçe (p06); her hafta bir saat daha erken duran saat (p08); fotoğraflarda hep 7.15'i gösteren saat ve "son dans, ağustosun son cumartesisi, bu yaz otuz yıl" yazısı (p09–p10).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: B1 metinleri ve görselleri ("sana onaylar verdim", 2026-10-14). GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p05.png`, `images/p09.png`, `images/p13.png`, `images/p17.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Woodcut print combined with soft watercolour washes, non-photorealistic storybook illustration, visible carved lines and paper grain. Palette: brass yellow, fir green, deep night blue, warm cream paper; small brass gears and clock mechanisms as recurring details. Mood: curiosity, mystery and gentle nostalgia, never scary. A small fictional mountain town in summer. Clock faces have no numerals, only simple tick marks and two hands. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; notebooks, photographs, posters and shop fronts are blank or drawn with abstract lines only. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Aziz:** 17-year-old boy, slim, olive skin, short dark curly hair, thick dark eyebrows, curious serious eyes; rolled-up sleeves on a dark-blue work shirt, a brown canvas apron with small tools in the pocket.
- **Mrs Ilse Brandt:** small, thin woman of 71, short white hair, sharp kind eyes, round reading glasses on a chain, grey cardigan over a dark-green dress, very small feet in green shoes; quick and light in her movements.
- **The five old friends:** Otto, tall man with a long grey beard and a flat cap; Rosa, round woman with a red scarf; Hanne, thin woman with a long white braid; Bernard, bald man with a bow tie; Klaus, short man with big glasses. All in their 70s, warm and mischievous.
- **Marta:** café owner in her 50s, curly brown hair tied up, striped apron, friendly face.
- **Haldenberg square:** a small cobbled square surrounded by tall fir forests and mountains; old wooden houses with flower boxes; a tall stone clock tower with a big round white clock face (no numerals); the clock shop with a green door next to the tower; a café with outdoor tables.
- **The clock room:** the room behind the clock face inside the tower: huge brass and iron gear wheels of many sizes, light glowing through the white glass of the clock face, stone walls, dust.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Night view of the stone clock tower above the empty square under a starry night-blue sky; the clock face glows softly, its hands moving (motion lines curving backwards); far below, Aziz stands alone at a small lit window of the clock shop, looking up. |
| p01.png | p01 (Bölüm 1, The Apprentice) | Inside the clock shop in daylight: walls covered with many clocks without numerals; Mrs Brandt at her work table looking through a magnifier at a tiny watch; Aziz beside her in his apron, watching closely; brass gears on the table. |
| p05.png | p05 (Bölüm 2, Footprints) | Aziz kneeling on a dusty stone spiral staircase inside the tower, holding a torch; the beam lights up small footprints with a tiny star pattern in the grey dust; deep shadows above. |
| p09.png | p09 (Bölüm 3, Old Photographs) | A small attic library: Aziz sits on the floor among open dusty boxes, holding an old black-and-white photograph (its content not visible, only the back of the paper); young bored librarian Pavel leans on a shelf behind him; soft light from a round window. |
| p13.png | p13 (Bölüm 4, Midnight) | The clock room at night: Aziz hides in the dark behind a huge brass gear wheel, holding his breath, torch switched off; through the glowing white clock face, the light of the full square below. |
| p17.png | p17 (Bölüm 5, Seven Fifteen) | The square at night full of townspeople under strings of warm lights and stars; everyone looks up at the tower clock, which shows a quarter past seven; Aziz stands at the tower door, smiling. |

**Sürpriz kontrolü:** Sonun sürprizi, saati geri çevirenlerin Bayan Brandt ile kafedeki beş yaşlı (eski dans grubu) olmasıdır. Hiçbir görselde Bayan Brandt ya da yaşlılar kulede, merdivende, yağ kutusuyla, akordeon çantasıyla ya da dans ederken gösterilmez. p01'de Bayan Brandt yalnızca dükkânında çalışır; ayakları ve yeşil ayakkabıları kadraj dışındadır. p05'teki ayak izleri yalnızca küçük ve yıldız desenlidir; kimin olduğu belli değildir. p09'da fotoğrafın içeriği görünmez. p13'te kulenin içindeki gölgeler ve gelen kişiler gösterilmez. p17 yalnızca meydanın kalabalığını ve 7.15'i gösteren saati gösterir; dans, çalgılar ve yaşlılar görünmez. Kapak yalnızca gizemi (gece, kule, geri dönen kollar) gösterir.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | dbbf69f9-44dc-43fb-8426-69945716ea62 | — | 2026-10-14T15:53:19+00:00 | 3:4, medium, 1k | 0.5 |
| p05.png | 952a016a-2376-4aea-86bb-bbc75644d5b4 | dbbf69f9-44dc-43fb-8426-69945716ea62 | 2026-10-14T15:55:01+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 55e2cd48-8d72-41de-ae27-a323b462d819 | dbbf69f9-44dc-43fb-8426-69945716ea62 | 2026-10-14T15:55:04+00:00 | 3:4, medium, 1k | 0.5 |
| p13.png | 5e461056-61d9-409c-9331-e34e72dd82ef | dbbf69f9-44dc-43fb-8426-69945716ea62 | 2026-10-14T15:55:06+00:00 | 3:4, medium, 1k | 0.5 |
| p09.png | 7b0be9c0-51ee-4704-991f-f0f4fac87c2a | dbbf69f9-44dc-43fb-8426-69945716ea62 | 2026-10-14T15:55:06+00:00 | 3:4, medium, 1k | 0.5 |
| p17.png | d8c02e02-f566-4314-a31b-27e8aae11075 | dbbf69f9-44dc-43fb-8426-69945716ea62 | 2026-10-14T15:55:30+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, hedef ~135 k/dk, §6.5). Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
