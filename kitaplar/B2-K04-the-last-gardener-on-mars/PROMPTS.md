# B2-K04 The Last Gardener on Mars: istem ve üretim kayıtları

Kurallar: her ücretli üretimden **önce** `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır (CLAUDE.md, H-024). Her istem, model, tarih, job id ve harcanan kredi buraya yazılır.

## Metin yazımı (2026-10-14)
| Alan | Değer |
|---|---|
| Tarih | 2026-10-14 |
| Model | Claude Opus 5.5 (`claude-opus-5-5`), Claude Code alt ajanı |
| İş | H-072 kitap dalgası 2 (B2), yalnız metin |
| Kaynak | `kitaplar/KATALOG.md` → B2-K04 (özet, kanca, bölüm planı, son sürpriz, dil odağı); `docs/KITAPLIK.md` §4–§6; `dilbilgisi/MUFREDAT.md` B2 konuları (G-B2-01…12) |
| Ücret | Yok (ücretli API çağrılmadı) |
| Çıktılar | `text.en.md`, `ceviri.tr.json` (DRAFT), `glossary.md`, `book.json`, `rights-and-review.md` |

**İstem (özet):** "B2-K04 *The Last Gardener on Mars* kitabının metnini katalogdaki özete, kancaya, bölüm planına ve son sürprize birebir uyarak yaz. 5 bölüm (Yellow Leaves, Normal, The Long Year, The Test Chamber, Buds), 24 sayfa, ~5.000 kelime (B2 hedefi 5.000 ± %20). Sakin, odaklı, merak arttıkça hızlanan anlatım. Bilim akla yatkın olsun: gün uzunluğu ve kış uykusu. Koloni adı uydurma; gerçek ajans ya da şirket yok. B2 yapıları doğal biçimde: edilgen (present perfect edilgen dahil), dolaylı anlatım (cümle, soru, rica), hipotez dili (*could, might, may*), 2. ve 3. tip koşul, *wish*, *must have / can't have / might have*, present perfect continuous, virgüllü ilgi cümlesi, ettirgen *have*, future continuous / perfect, *although / despite / however / whereas*; standart İngiliz İngilizcesi. İlk sayfada merak sorusu, her bölüm sonunda kanca, önceden ipucu verilmiş adil bir son. 13+ güvenli. Kapsama CEFR-J ≤ B2 ≥ %98 (özel adlar hariç). Türkçe çeviri cümle cümle, öbekler ve kelime anlamlarıyla; seviye üstü kelimeler sözlükte."

**Kanca:** Katalogdaki kanca (*On the colony's two-hundredth day of spring, every plant in the greenhouse began to die at once.*) kitabın ilk cümlesidir; `book.json → hookEn` birebir aynıdır. "Bahar" koloninin Dünya'dan kopyalanmış takvimindeki adıdır; dışarıdaki gerçek Mars mevsimi sonbahardır (bu ironi bilmecenin anahtarıdır).

**Bilim çerçevesi:** Sera yaklaşık otuz yıl yalnızca lambayla, her gün aynı saatlerde (on dört saat) aydınlatıldı. Bir yıldan biraz önce cam çatı yapıldı; bitkiler ilk kez gerçek güneşi, yani gün uzunluğundaki mevsim değişimini hissediyor. Bilgisayar yalnızca toplam ışık miktarını ölçtüğü (ve lambalar karanlık günlerde destek verdiği) için "normal" diyor. Dünya'dan gelen tohumlar seralar için üretilmiş, gün uzunluğuna duyarsız çeşitler; Mars doğumlu soylar ise Dr Lindqvist'in otuz yıl boyunca burada en iyi gelişen bitkilerin tohumlarını saklamasıyla Mars'ın uzun yılına uyum sağlamış eski bahçe çeşitleri.

**Adil son için yerleştirilen ipuçları:**
- Koloni takvimi Dünya'dan kopyalanmış, gerçek Mars mevsimleri iki kat uzun ve "kimse dikkat etmiyor"; içeride "hep bahar" (p02).
- Bilgisayar "her şey normal" diyor (p03, p07); hastalık testinde hiçbir şey bulunamıyor (p03).
- Yalnızca Mars doğumlu bitkiler sararıyor, Dünya tohumları sağlıklı ve çiçekli (p05).
- Cam çatı bir yıldan biraz önce yapıldı; önceden lambalar her gün aynı saatlerde yanıyordu (p06).
- Dr Lindqvist'in yüzünde bir an bir şey değişiyor (p08); defterlerdeki notlar: en güçlü bitkilerin tohumları saklandı, "fasulyeler çiçek açmadan önce bekliyor gibi" ve her sayfada ikinci, Mars tarihi (p09, p10).
- "They will learn the long year." (p10); 687 gün ve yaklaşan uzun Mars kışı (p11); gün uzunluğu çizgisinin dönüşü ve sararmanın birkaç hafta sonra başlaması (p12).
- Sap kazınınca altı hâlâ yeşil ve nemli: "Not dead. Waiting." (p16); yaz dolabındaki bitki yeşilleniyor (p17).
- Şişlik sapla son yaprağın arasında, pürüzsüz ve açık yeşil; "olmak üzere olan bir şeye" benziyor (p20).

## Görsel planı ve üretim kaydı (2026-10-14)

> **Üretildi (2026-10-14).** Kullanıcı onayı: "15,06 krediye kadar kullan". GPT Image 2.5, 3:4, medium, 1k = 0,5 kr; bölüm başları kapak işi referans verilerek. Eski plan notu: Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p11.png`, `images/p16.png`, `images/p21.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

**Sabit stil öneki (her istemin başına):**
`Clean-line graphic science-fiction illustration, non-photorealistic, flat colour areas with soft gradients, crisp ink outlines, calm and hopeful with quiet tension. Palette: rust-red Mars landscape and dusty pink-orange sky, deep greenhouse greens, warm sodium-lamp orange light, pale steel and glass. Absolutely no text, letters, numbers, signs, logos or writing anywhere in the image; computer screens and graphs show only simple abstract lines, notebooks show only soft illegible marks, labels are blank. Consistent characters as described. Vertical 3:4.`

**Karakterler ve mekânlar (her istemde adı geçenin tanımı aynen eklenir):**
- **Kofi Asante:** 16-year-old boy born on Mars, slim and tall for his age, dark brown skin, short black hair, serious curious eyes; a faded green work overall with rolled sleeves, soil on his hands; often holds a torch or a small notebook.
- **Yara Haddad:** 17-year-old girl, engineering trainee, olive skin, thick dark curly hair tied up, quick confident grin; a grey-blue work jacket with many pockets, tools at her belt.
- **Dr Lindqvist:** 71-year-old woman, small and thin, very straight posture, short white hair, very clear blue eyes, a sharp but tired face; a plain grey cardigan at home, an old dark green greenhouse jacket in the final chapter.
- **Councillor Hale:** tall careful man about 55, short grey beard, neat dark colony uniform.
- **Kofi's mother:** woman about 45, dark brown skin, short natural hair, water-systems work jacket, calm strong face.
- **Kestrel Colony:** a small cluster of low white domes and connected corridors on red rocky ground under a dusty pink-orange sky; the greenhouse is a long curved building of glass and steel on the edge, with rows of plants in pots and long beds, and hanging lamps.
- **The drying room:** a small storeroom behind the seed store, two old metal cupboards lined with silver sheets, cables, small lamps inside.

**Kapak ve bölüm başı istemleri (İngilizce, stil öneki + karakter tanımlarıyla birlikte gönderilir):**
| Dosya | Sayfa | Sahne |
|---|---|---|
| cover.png | kapak | Kofi stands alone inside the long glass greenhouse at dusk, holding a single yellow leaf in his open hand and looking at it; rows of plants behind him, some green, some fading yellow; through the curved glass roof, the red Martian hills and a low orange sun. |
| p01.png | p01 (Bölüm 1, Yellow Leaves) | Early morning in the greenhouse: Kofi crouches between two long rows of bean plants with a water pipe at his feet, touching a pale yellow leaf that is coming loose; most leaves around him are still green; pink morning sky through the glass. |
| p06.png | p06 (Bölüm 2, Normal) | A small greenhouse office: Kofi sits staring at a computer screen that shows only calm green abstract bars and lines; behind him, through a window, rows of yellowing plants; his notebook lies open on the desk. |
| p11.png | p11 (Bölüm 3, The Long Year) | Kofi and Yara in the engineering workshop at evening, leaning over a screen showing a single simple curved line that rises and then begins to fall; a half-taken-apart pump on the workbench; through a small window, the sun going down early behind red hills. |
| p16.png | p16 (Bölüm 4, The Test Chamber) | The drying room: Yara on her knees fixing cables to small lamps inside two old metal cupboards lined with silver sheets; Kofi carefully carries two tired bean plants in pots with drooping pale leaves; one cupboard glows warm orange, the other is dim and blue-cold. |
| p21.png | p21 (Bölüm 5, Buds) | The crowded main hall of the colony: Kofi stands nervously in front of the council table; Councillor Hale and other councillors sit behind it; Kofi's mother and Yara in the front row; on a small table, a bean plant under a clear cover, seen from a distance with only tired leaves visible. |

**Sürpriz kontrolü:** Sonun sürprizi, bitkilerin ölmediği, Mars kışı için uykuya geçtiği ve saptaki şişliğin bir çiçek tomurcuğu, yani ilk gerçek Mars tohumlarının habercisi olmasıdır. Hiçbir görselde tomurcuk, çiçek ya da şişlik gösterilmez: kapakta Kofi'nin elinde yalnızca sarı bir yaprak vardır; p16'da bitkiler yorgun ve soluktur; p21'de dolaptan gelen bitki uzaktan, yalnızca yorgun yapraklarıyla görünür. Dünya fasulyelerindeki beyaz çiçekler (p05) ve Dr Lindqvist'in salona gelişi (p22) görsellenmez. Defterdeki "They will learn the long year" satırı yazı olduğu için hiçbir görselde yer almaz.


### Üretim kaydı

| Dosya | Job id | Referans | Tarih (UTC) | Parametre | Kredi |
|---|---|---|---|---|---|
| cover.png | 3b7f308d-a091-45d3-9426-c17b1014c5cb | — | 2026-10-14T16:16:37+00:00 | 3:4, medium, 1k | 0.5 |
| p06.png | 142e7f84-655a-439e-92f8-0c3a12819f53 | 3b7f308d-a091-45d3-9426-c17b1014c5cb | 2026-10-14T16:19:58+00:00 | 3:4, medium, 1k | 0.5 |
| p01.png | 2b587f9d-e15f-4336-a10b-e551a8c8bc93 | 3b7f308d-a091-45d3-9426-c17b1014c5cb | 2026-10-14T16:19:58+00:00 | 3:4, medium, 1k | 0.5 |
| p16.png | 81b31f26-67a8-4747-9e6e-22241d8e3984 | 3b7f308d-a091-45d3-9426-c17b1014c5cb | 2026-10-14T16:20:00+00:00 | 3:4, medium, 1k | 0.5 |
| p11.png | a9ce3cb6-e0c4-4acc-96fa-ee338017fc6c | 3b7f308d-a091-45d3-9426-c17b1014c5cb | 2026-10-14T16:20:15+00:00 | 3:4, medium, 1k | 0.5 |
| p21.png | 0985e8ca-b820-40ce-b4e5-8bc41088f3da | 3b7f308d-a091-45d3-9426-c17b1014c5cb | 2026-10-14T16:20:24+00:00 | 3:4, medium, 1k | 0.5 |

**Toplam:** 3 kr. Tam istemler yerel `images/_jobs.json`'da (git dışı). **Editör değerlendirmesi:** karakter ve üslup tutarlı; görselde yazı yok; sürpriz ele verilmiyor.

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri). Anlatım temposu B2 varsayılanıyla kapalı (`off`, §6.5); hedef ~145–155 k/dk, gerçek hız `book-lint`'te ölçülür, gerekirse `narration.pacing` ayarlanır. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|

## Türkçe seslendirme kayıtları (tts_tr.py)

| Tarih (UTC) | Parça | Model | Ses | Sürüm | Karakter | Ses (sn) | İstek kimliği | Metin sha256 |
|---|---|---|---|---|---|---|---|---|
| 2026-11-03T18:47:29Z | p01 | alania-v2 | alania2-f1 | alania-v2.1 | 1044 | 69.57 | 6abd8fb9e52343a599e8a0603fe3f65f | de1729d274a13e0b |
| 2026-11-03T18:47:35Z | p01 | duyu-1 | - | - | - | 69.57 | - | de1729d274a13e0b |
| 2026-11-03T18:47:44Z | p02 | alania-v2 | alania2-f1 | alania-v2.1 | 1201 | 73.14 | 11fbd255349344dd92cffe6d6fe3d734 | 9b753d6b0dfaaeaf |
| 2026-11-03T18:47:50Z | p02 | duyu-1 | - | - | - | 73.14 | - | 9b753d6b0dfaaeaf |
| 2026-11-03T18:48:00Z | p03 | alania-v2 | alania2-f1 | alania-v2.1 | 1093 | 66.8 | db20dc85ce55471b9b1898d3d6db75e0 | a61eead8f1db8a77 |
| 2026-11-03T18:48:05Z | p03 | duyu-1 | - | - | - | 66.8 | - | a61eead8f1db8a77 |
| 2026-11-03T18:48:14Z | p04 | alania-v2 | alania2-f1 | alania-v2.1 | 1133 | 70.15 | 6833662151c04ddc9e66f47fa83dcc75 | 193586034af606ac |
| 2026-11-03T18:48:19Z | p04 | duyu-1 | - | - | - | 70.15 | - | 193586034af606ac |
| 2026-11-03T18:48:30Z | p05 | alania-v2 | alania2-f1 | alania-v2.1 | 1026 | 65.39 | 97db0f425a49483b8be6edb024dae75f | 8c0fe219de92db95 |
| 2026-11-03T18:48:38Z | p05 | duyu-1 | - | - | - | 90.71 | - | 8c0fe219de92db95 |
| 2026-11-03T18:48:47Z | p06 | alania-v2 | alania2-f1 | alania-v2.1 | 1146 | 71.44 | 433b6c9d4e8c4ae79ea62480f35d53bb | 7cef8d5ab736f150 |
| 2026-11-03T18:48:52Z | p06 | duyu-1 | - | - | - | 71.44 | - | 7cef8d5ab736f150 |
| 2026-11-03T18:49:03Z | p07 | alania-v2 | alania2-f1 | alania-v2.1 | 993 | 63.69 | fb40d9561ec9439ab40da0e56571b61b | 435fd26e9b094750 |
| 2026-11-03T18:49:10Z | p07 | duyu-1 | - | - | - | 63.69 | - | 435fd26e9b094750 |
| 2026-11-03T18:49:19Z | p08 | alania-v2 | alania2-f1 | alania-v2.1 | 1152 | 74.61 | 76c0cf32a9884caa8e0bad7731a7f8cb | 9308b5d2dc52f307 |
| 2026-11-03T18:49:29Z | p08 | duyu-1 | - | - | - | 96.46 | - | 9308b5d2dc52f307 |
| 2026-11-03T18:49:40Z | p09 | alania-v2 | alania2-f1 | alania-v2.1 | 1078 | 67.72 | e8d19797da6649aa93cbdd4e079b38ac | 4da85a21f24a6844 |
| 2026-11-03T18:49:45Z | p09 | duyu-1 | - | - | - | 67.72 | - | 4da85a21f24a6844 |
| 2026-11-03T18:49:54Z | p10 | alania-v2 | alania2-f1 | alania-v2.1 | 1030 | 64.67 | 38cd069da2ea471da7b08b89e0850411 | c39485acfb42a776 |
| 2026-11-03T18:49:59Z | p10 | duyu-1 | - | - | - | 64.67 | - | c39485acfb42a776 |
| 2026-11-03T18:50:08Z | p11 | alania-v2 | alania2-f1 | alania-v2.1 | 978 | 62.85 | 0e67ebc2489d4bb2974ee492c9e4f78c | 7bc211a75251529a |
| 2026-11-03T18:50:14Z | p11 | duyu-1 | - | - | - | 62.85 | - | 7bc211a75251529a |
| 2026-11-03T18:50:24Z | p12 | alania-v2 | alania2-f1 | alania-v2.1 | 1041 | 65.07 | 64e0a998fd6841fc9115477a906ac023 | f8f8292e32fd7853 |
| 2026-11-03T18:50:37Z | p12 | duyu-1 | - | - | - | 88.01 | - | f8f8292e32fd7853 |
| 2026-11-03T18:50:46Z | p13 | alania-v2 | alania2-f1 | alania-v2.1 | 1231 | 75.18 | 107fdeac802f4107aaa971efa4873826 | 2aa13744d9a8bfd0 |
| 2026-11-03T18:50:52Z | p13 | duyu-1 | - | - | - | 75.18 | - | 2aa13744d9a8bfd0 |
| 2026-11-03T18:51:03Z | p14 | alania-v2 | alania2-f1 | alania-v2.1 | 1106 | 67.66 | b845ca64561045adb5edc0e99eb71f98 | 4aec4595f34fd010 |
| 2026-11-03T18:51:12Z | p14 | duyu-1 | - | - | - | 67.66 | - | 4aec4595f34fd010 |
| 2026-11-03T18:51:22Z | p15 | alania-v2 | alania2-f1 | alania-v2.1 | 1122 | 69.92 | 63c8f309f00c47bea6498a882e681136 | 050842a04e7ca2eb |
| 2026-11-03T18:51:27Z | p15 | duyu-1 | - | - | - | 69.92 | - | 050842a04e7ca2eb |
| 2026-11-03T18:51:38Z | p16 | alania-v2 | alania2-f1 | alania-v2.1 | 1113 | 74.85 | c07c5c1ac8c94758bfb5e82e4c379f53 | c5ea2cb0e6f57750 |
| 2026-11-03T18:51:47Z | p16 | duyu-1 | - | - | - | 74.85 | - | c5ea2cb0e6f57750 |
| 2026-11-03T18:51:58Z | p17 | alania-v2 | alania2-f1 | alania-v2.1 | 1246 | 79.5 | 4f7e7be4086c46e48b10a348226ca6cc | 443886eb2d7833f6 |
| 2026-11-03T18:52:04Z | p17 | duyu-1 | - | - | - | 79.5 | - | 443886eb2d7833f6 |
| 2026-11-03T18:52:17Z | p18 | alania-v2 | alania2-f1 | alania-v2.1 | 1197 | 78.0 | c7c26c97edc2445e89752673f0f401c0 | 09d0e32b245b471a |
| 2026-11-03T18:52:23Z | p18 | duyu-1 | - | - | - | 78.0 | - | 09d0e32b245b471a |
| 2026-11-03T18:52:34Z | p19 | alania-v2 | alania2-f1 | alania-v2.1 | 1105 | 73.53 | 0f2e6e8f06a941518edb56c1cce2f7c1 | cf41aede51976b8e |
| 2026-11-03T18:52:40Z | p19 | duyu-1 | - | - | - | 73.53 | - | cf41aede51976b8e |
| 2026-11-03T18:52:50Z | p20 | alania-v2 | alania2-f1 | alania-v2.1 | 1018 | 65.26 | 0d3d5f13cc9b474dbcb104f28f8325e0 | 9490bb6f730459ec |
| 2026-11-03T18:52:56Z | p20 | duyu-1 | - | - | - | 65.26 | - | 9490bb6f730459ec |
| 2026-11-03T18:53:05Z | p21 | alania-v2 | alania2-f1 | alania-v2.1 | 1070 | 69.66 | 8c528cd1945e4229a01dba87e6aca950 | 8ce0ed47a08cb4b3 |
| 2026-11-03T18:53:11Z | p21 | duyu-1 | - | - | - | 69.66 | - | 8ce0ed47a08cb4b3 |
| 2026-11-03T18:53:20Z | p22 | alania-v2 | alania2-f1 | alania-v2.1 | 1124 | 70.79 | c8fc8e3f7af54e539e2a78579e62ea6a | c7c37c858fa16430 |
| 2026-11-03T18:53:26Z | p22 | duyu-1 | - | - | - | 70.79 | - | c7c37c858fa16430 |
| 2026-11-03T18:53:36Z | p23 | alania-v2 | alania2-f1 | alania-v2.1 | 1175 | 72.84 | 5433045153354293b5b666ac6379778f | 5a4a51fe1660174d |
| 2026-11-03T18:53:41Z | p23 | duyu-1 | - | - | - | 72.84 | - | 5a4a51fe1660174d |
| 2026-11-03T18:53:52Z | p24 | alania-v2 | alania2-f1 | alania-v2.1 | 1133 | 70.43 | f53d0a3709ed45c9a4d15521b5dbb0b3 | dca7f1cdf8659af4 |
| 2026-11-03T18:53:57Z | p24 | duyu-1 | - | - | - | 70.43 | - | dca7f1cdf8659af4 |
