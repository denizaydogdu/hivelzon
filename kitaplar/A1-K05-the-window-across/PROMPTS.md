# A1-K05 The Window Across: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-071 kitap dalgası 1, yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → A1-K05 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6 |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json` |

**İstem (özet):** "A1-K05 *The Window Across* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 2 bölüm, 10 sayfa, ~650–750 kelime (A1 hedefi 700 ± %20). A1: her cümle ≤ 8 kelime, present simple, yan cümle yok; selamlaşma, günün saatleri, duygu sıfatları (*sad, cold, shy*), *Do you…?* soruları. İlk sayfada merak sorusu, bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. Omar'ın Faslı oluşu saygıyla, dinsiz ve kalıp yargısız. 13+ güvenli; gerçek marka ve kişi yok. Kapsama CEFR-J A1 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Adil son için yerleştirilen ipuçları:** kızın gözlerinin Omar'ın yüzünde değil, biraz aşağıda olması (p01); dışarıdaki süt bardağı ve "her sabah bardak dolu değil" (p03–p04); karda küçük çiçeğe benzeyen izler (p04); kızın "Omar'ın penceresine" gülümsemesi (p04); fırtına gecesi yalnız fırının sıcak kalması, sabah bardağın dolu ve karın izsiz olması (p05); torbaların arkasındaki küçük ses (p06).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: dalga 1 metinleri ve 34 görsel (~17 kr) onaylandı ("İlk dalganın 8 kitap metni … onay", 2026-10-14). Kesin maliyet `generate cost` ile doğrulandı: GPT Image 2.5, 3:4, medium, 1k = 0,5 kr. Bölüm başları kapak işi referans verilerek üretildi. Eski plan notu: Kullanıcı kararı (2026-10-14): kalan kitaplarda yalnız **kapak + bölüm başı** görseli. Model GPT Image 2.5, 3:4, ~0,5 kr/görsel; her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve onay alınır. Dosyalar `images/cover.png`, `images/p01.png`, `images/p06.png` (git dışı); diğer sayfalar resimsiz, palet renkli (`book.json → image: null`). Sayfa görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı). **Toplam: 3 görsel ≈ 1,5 kr.**

**Sabit stil öneki (her istemin başına):**
`Linocut print style storybook illustration, non-photorealistic, bold carved lines and visible print texture, simple shapes. Palette: winter blue-grey, snow white, warm orange window light, bread brown, soft cream. Quiet, gentle mood moving from loneliness to warmth; never sad or dark in a heavy way. Absolutely no text, letters, numbers, signs, shop names or writing anywhere in the image; shop windows, letters and photos are drawn without any marks. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekân (her istemde adı geçenin tanımı aynen eklenir):**
- **Omar:** 34-year-old North African man, slim, short black curly hair, short neat beard, warm brown skin, kind shy eyes; white baker's apron over a dark blue jumper; in the street a long brown coat and a dark green scarf.
- **Freya:** 8-year-old girl, pale skin, rosy cheeks, two blond braids, a knitted yellow hat with a small pompom, light blue pyjama top at the window, red winter coat outside.
- **Anna:** Freya's mother, about 40, tall, blond hair in a loose ponytail, the same knitted yellow hat, grey wool jumper, calm warm smile.
- **The street:** a narrow, snowy street in a cold northern city; old three-storey houses face each other; on the ground floor of Omar's house a small bread shop with a big plain glass window and warm orange light; Omar's small window is above the shop; Freya's window is across the street, one floor up.
- **Mimi (yalnız p06 ve sonrası için tanım; kapak ve p01 istemlerine EKLENMEZ):** small grey-and-white street cat with a white face and white paws, green eyes.

**Görsel istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sahne |
|---|---|
| cover.png | View from inside Omar's dim little flat at dawn: Omar stands at his window, seen from behind and slightly from the side, one hand raised in a small wave; across the snowy street, in a warm orange window, a little girl in a yellow hat waves and smiles. His windowsill is covered in smooth, untouched snow. No animals anywhere. |
| p01.png | Early morning in the snowy northern street, seen from the street level: the bread shop's warm orange window downstairs, Omar's small window above it with his face and a raised hand; across the street, Freya in her yellow hat waves from her window. Snow falls softly. No animals anywhere; the windowsills are piled with plain snow. |
| p06.png | Evening, deep snow: Omar in his brown coat and green scarf crosses the street with a round flat bread wrapped in a cloth, holding it close; he looks nervous but brave. Behind him the bread shop window glows orange; above, across the street, a warm window with a yellow hat silhouette. No cat visible. |

**Sürpriz kontrolü:** Kitabın sürprizi, kızın Omar'a değil pervazdaki kediye el sallaması ve kedinin fırına sığınması. Bu yüzden kapak ve p01 istemlerinde kedi, pati izi ve süt bardağı yok; pervaz düz, izsiz karla çizilir ve istemde "No animals anywhere" yazılı. p06 (2. bölüm başı, adı "The Cat") kediyi göstermez, yalnız Omar'ın cesaretini (sokağı geçişini) gösterir; un çuvalları ve fırının içi de çizilmez, böylece kedinin nerede olduğu ele verilmez. Mimi'nin tanımı yalnız ileride sayfa içi görsel istenirse kullanılır.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 0d7055b4-deb0-4cdb-b96a-eef79ddb9640 | — | 2026-10-14T11:10:53+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | a615893d-2d82-4cc5-963f-30375bc36c40 | 0d7055b4-deb0-4cdb-b96a-eef79ddb9640 | 2026-10-14T11:13:55+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | b1fd84e9-33a5-4a12-8583-2929dd39adb1 | 0d7055b4-deb0-4cdb-b96a-eef79ddb9640 | 2026-10-14T11:13:55+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 1.5 kr. Tam istem metinleri yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı kararı), model `eleven_v3`, hız 0.9 (A1 başlangıç değeri; anlatım temposu dışa aktarmada `auto`, §6.5). Ses ElevenLabs Creator (ticari lisans) hesabıyla, `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip maliyet onayı alındıktan sonra üretilir. Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
| 2026-10-14T16:32:12Z | c1 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 1873 | 673149a21ca7f350 | audio/c1.mp3 |
| 2026-10-14T16:32:44Z | c2 | 1/1 | EXAVITQu4vr4xnSDxMaL | eleven_v3 | 0.9 | 2095 | bcf25ed737dfd8b9 | audio/c2.mp3 |
