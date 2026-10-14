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

## Görsel planı (üretilmedi)

> **Henüz üretilmedi.** Kullanıcı kararı (2026-10-14, H-071/H-072): kalan kitaplarda resim yoğunluğu **kapak + bölüm başı**. Bu kitapta 6 görsel: `images/cover.png`, `images/p01.png`, `images/p06.png`, `images/p11.png`, `images/p16.png`, `images/p21.png` (git dışı; dosya adları `book.json` ile aynı, diğer sayfalar resimsiz ve palet renkli). Model: GPT Image 2.5, 3:4, ≈ 0,5 kr/görsel (dalga 1'de 1k medium ile doğrulandı); tahmini toplam ≈ 3 kr. **Her üretimden önce `higgsfield generate cost` ile maliyet gösterilir ve kullanıcı onayı alınır.** Bölüm başı görselleri kapak işi referans verilerek üretilir (karakter tutarlılığı).

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

## Seslendirme kayıtları (tts_book.py)

Henüz üretilmedi. Anlatıcı **Sarah** (`EXAVITQu4vr4xnSDxMaL`, kullanıcı seçimi), model `eleven_v3`, hız 1.0 (B2 başlangıç değeri). Anlatım temposu B2 varsayılanıyla kapalı (`off`, §6.5); hedef ~145–155 k/dk, gerçek hız `book-lint`'te ölçülür, gerekirse `narration.pacing` ayarlanır. Ses **ElevenLabs Creator** (ticari lisans) hesabıyla, önce `tts_book.py` kuru çalışmasıyla karakter ve kredi gösterilip kullanıcı onayı alındıktan sonra üretilecek. Anahtar repo dışında (`ELEVENLABS_API_KEY`). Aşağıdaki tabloya satırları `tts_book.py --execute` ekler.

| Tarih (UTC) | Bölüm | Parça | Ses | Model | Hız | Karakter | Metin sha256 | Dosya |
|---|---|---|---|---|---|---|---|---|
