# H-109: Yeni Türkçe ses yerleri (Faz 1, 2, 3, 3b)

- **Durum:** 🔄 Üretildi ve paketlendi (2026-11-27/28, kullanıcı onayıyla); **simülatörde deneme (izinle) ve kulakla
  kontrol bekliyor**, sonra `bitenler/`. Kullanıcı kararları: "türkçe sesleri bitirelim", "yapılması gereken her yere yap",
  H-116 tavanı iptal ("tavan filan yok"); araç kuralı gereği her koşuya yalnız o işin karakteri kadar tek seferlik tavan verildi.
- **Tür:** İçerik hattı (Alania + Duyu) + mobil arayüz
- **Öncelik:** Düşük–Orta
- **Bağımlılık:** H-083, H-104, H-105, H-108 (gerçek ücret durumu) · editör incelemesi (metin değişirse yeniden seslendirme)

## Arka plan
Tasarımda Türkçe konuşulan her yer zaten sesli; 2026-11-20 kuru çalışmalarında eksik 0: 13 bölüm (Hi, Alex, babaanne,
anlatıcı), Hi paneli + Konuş (56 ses), 30 kitap "Sayfanın Türkçesi" (626 sayfa), 71 dilbilgisi anlatımı.
PatientDesk `GET /v1/usage`: `free: false`, `free_until` 2026-11-14 10:57 UTC; kalan Duyu kotası ≈ 985 saat.
Tarife 0,75 TL/1.000 karakter (Alania) + 6 TL/ses saati (Duyu) ≈ 0,87 TL/1.000 karakter.

## Öneri (sesi olmayan Türkçe metinler)
| Faz | Kapsam | Karakter | ≈ TL | Not |
|---|---|---|---|---|
| 1 | Dilbilgisi yanlış cevap açıklamaları (`!`) A1–C2 + Keşfet reel alıştırma metinleri (A1–A2) | 13.270 (11.642 + 1.628) | 12 | Önerilen; "hatanın nedeni Türkçe açıklanır" ilkesi; önce A1–A2 |
| 2 | Kitap sonu soruların Türkçesi + kitap tanıtımı (`blurbTr`) | 12.014 (2.855 + 9.159) | 10,5 | İsteğe bağlı |
| 3 | Çeviri sesleri (dilbilgisi örnek Türkçesi, bölüm hikâye Türkçesi, reel altyazı) | ≈ 80.000 | ≈ 70 | Önerilmez (K-03, K-23; İngilizce dinlemenin yerini alır) |
| 4 | Dinamik uygulama metinleri (Hi önerileri, açılış) | — | — | H-044 sonrası, sunucuda TTS; ayrı karar |

Her fazda: araç parçası (kart kimliği kaymaz) + mobilde "dinle" düğmesi (otomatik çalma yok, ses yoksa görünmez, H-104 deseni)
+ lint/test → kuru çalışma maliyeti → kullanıcı onayı → tavanla üretim → simülatör (izinle) → kulakla kontrol → editör.

## Kabul kriterleri (onaylanırsa)
- Seçilen fazın bütün metinleri sesli; kuru çalışma eksik 0; harcama `PROMPTS.md` ve defterde.
- Lint 0 hata; pytest, `flutter analyze`, `flutter test` yeşil; uygulamada düğme yalnız ses varken görünür.

## Not
Asıl ses açığı İngilizce: 24 kitap, B1–C2 dilbilgisi örnekleri, 19 yeni kanca (çalışan ElevenLabs erişimi/onaylı plan).

## Uygulama (2026-11-27; ücretli çağrı yok)
**Parça kimlikleri sabit** (metin sırası değişse de kaymaz):
- Dilbilgisi: `audio/tr/<alıştırma>-fb.{mp3,align.json}` (ör. `c07-q1-fb`; alıştırma kimliği uygulamadakiyle aynı).
  Ses ve üslup anlatımla aynı (Hi). Ayrı sözlük `lesson.json → feedbackPronunciations` (yalnız açıklamaya gider;
  anlatımın ödenmiş sesinin anahtarı değişmez), kelime sınırında ve büyük/küçük harfe duyarlı.
- Reel: `reeller/<id>/audio/tr/practice-prompt` (soru + Türkçe seçenekler, kaynaktaki sırayla) ve `practice-explain`.
  Kayıt `reeller/<id>/PROMPTS.md`.
- Kitap: `kitaplar/<id>/audio/tr/q1`, `q2` (soru kimliği) ve `blurb` (sayfa sesleriyle aynı klasör ve ses).

**Araçlar:** `tts_lesson.py --part feedback`, `tts_reel_tr.py` (yeni; `--package` kurulmuş pakete ekler, video yeniden
kurulmaz), `tts_book_tr.py --part questions --part blurb`. Varsayılanlar eski davranış (anlatım+örnek / sayfalar);
yeni parçalar yalnız istenince planlanır. `tts_tr.py`'ye dokunulmadı (açık API: `Segment`, `check_segments`,
`check_pronunciations`, `plan_segments`, `execute`).

**Lint:** grammar-lint `feedback-audio` (eksik ses ders başına tek uyarı; eskimiş ses uyarı) ve `feedback-english`
(açıklamada sözlükte olmayan İngilizce, ders başına tek uyarı); reel-lint `reel.tr-audio` (reel başına tek uyarı;
pakette dosya ve `textSha256` denetimi); book-lint sayfa sesiyle aynı kural (üretilmemiş ses sorun değil, eskimiş ses
uyarı; `trAudio.extra` istatistiği).

**Paket:** `cards.json` alıştırmada `feedbackAudio`/`feedbackDuration` (+ manifest `textSha256`, `feedbackMissing`);
reel `reel.json → practice.audioTr.{prompt,explain} = {audio, duration, textSha256}`; kitap `book.json → trAudio =
{questions: {q1, q2}, blurb}` (+ manifest `trExtraAudio`, `trTextSha256`). Eskimiş ses pakete girmez.

**Mobil:** `HiListenButton` (`lessonId`, `reelId` eklendi): dilbilgisinde yanlış cevap kutusunda "Açıklamayı dinle"
(ders sessiz moddaysa gizli; ders sesiyle aynı anda çalmaz), Keşfet reel sorusunda "Soruyu dinle" ve cevaptan sonra
"Açıklamayı dinle", kitap sonu soruda "Türkçesini dinle". Yalnız dokununca çalar, ses yoksa görünmez.

### Kuru çalışma (2026-11-27, `--offline`; ≈ 0,87 TL / 1.000 karakter)
| Faz | Kapsam | Parça | Karakter | ≈ TL |
|---|---|---|---|---|
| 1 | Dilbilgisi `!` (A1 2.378 · A2 2.391 · B1 1.982 · B2 2.271 · C1 1.561 · C2 1.059) | 285 | 11.642 | 10,12 |
| 1 | Reel alıştırma (A1 824 · A2 909; soru + seçenekler + açıklama, ayraç noktaları dahil) | 36 | 1.733 | 1,51 |
| | **Faz 1 toplam** | 321 | **13.375** | **≈ 11,6** |
| 2 | Kitap sonu soruların Türkçesi | 60 | 2.855 | 2,48 |
| 2 | Kitap tanıtımı (`blurbTr`) | 30 | 9.159 | 7,96 |
| | **Faz 2 toplam** | 90 | **12.014** | **≈ 10,4** |

Komutlar (P=`tools/content-pipeline/.venv/bin/python`):
`$P tools/content-pipeline/tts_lesson.py dilbilgisi/G-* --part feedback --offline` ·
`$P tools/content-pipeline/tts_reel_tr.py reeller/*-R-* --offline` ·
`$P tools/content-pipeline/tts_book_tr.py kitaplar/*-K* --part questions --part blurb --offline`.

### Karar bekleyen bulgular (2026-11-28: çözüldü)
> Çözüm: 69 derse `feedbackPronunciations` söyleniş sözlüğü yazıldı ve açıklamalar sözlükle üretildi; tanıtım sesleri
> kullanıcının "her yere yap" kararıyla üretildi ve pakette (`Book.blurbTrAudio`), ekranda yeri hâlâ yok (ayrı küçük karar).
- **Açıklamalarda İngilizce kelime:** 285 açıklamanın 221'inde İngilizce kelime var (ör. "Ben (I) için am gelir.";
  en sık: to, have, the, is, will, was, be, are). Alania bunları Türkçe okur. Üretimden önce
  `feedbackPronunciations` sözlüğü yazılmalı (lint `feedback-english` ders başına listeler; 67 ders) ya da kabul edilmeli.
  `tts_lesson.py --part feedback --execute` bu açıklamaları **reddeder** (`--allow-english` ile açıkça geçilir); sözlük
  sonradan eklenirse anahtar değişir ve ses yeniden ücretlenir (lint/paket eskimiş sayar).
- **Tanıtım (`blurbTr`) uygulamada gösterilmiyor:** ses pakete ve modele (`Book.blurbTrAudio`) girer ama ekranda
  yeri yok. Faz 2'nin en büyük kalemi (9.159 karakter); yer kararı (ör. kitap açılışı ya da Bölümler paneli) olmadan
  üretilmemesi önerilir.


## Faz 3: çeviri sesleri (kullanıcı kararı 2026-11-27: yapılsın; araç hazır, ücretli üretim yok)
Kapsam: uygulamanın gösterdiği **cümle düzeyi Türkçe çeviriler**. Önerideki ≈ 80.000 karakter tahmini; gerçek
sayım aynı metnin tekrarı ayıklanınca, yalnız pakette gerçekten görünen cümleler sayılınca ve kelime düzeyi
anlamlar çıkınca **37.946 karakter**.

**Dahil:**
- Dilbilgisi: doğru örneklerin (`+ … | Türkçesi`) ve "Söyle" alıştırmalarının Türkçesi. Parça `audio/tr/<örnek>-tl`
  (ör. `c03-ex1-tl`, `c07-q5-tl`); aynı Türkçe ders içinde bir kez, pakette metni aynı olan her yer aynı sesi alır.
- Bölümler: `ceviri.tr.json` `lines`/`phrases` Türkçesi, yalnız kuru derlemede pakete bağlananlar (altyazı satırı,
  kart satırı, karar repliği, görev kökü, 🎯 hedef ifade). Parça `audio/ceviri/l-<sha256(İngilizce)[:10]>` (ifade `p-…`):
  kimlik İngilizceden gelir, Türkçe düzeltilince kaymaz (ses eskimiş sayılır). Keşfet'in bölüm klipleri satırları
  olduğu gibi kopyaladığından aynı sesi kullanır (ek karakter yok).
- Reeller: altyazı satırlarının Türkçesi (`cues[].tr`). Parça `reeller/<id>/audio/tr/sub-<satır>`.

**Dışarıda (gerekçe):**
- Kelime ve kalıp anlamları (`words`/`gloss`, `chunks`, `stemChunks`, `episode.glossary`, konu seti kelime `tr`): sözlük
  parçaları, çoğu not içerir ("(olmak; Türkçede karşılığı yok)"); cümle değil.
- Dilbilgisi yanlış biçim notu (`x … | Ek eksik.`; 157 not, 4.446 karakter): çeviri değil, açıklama; istenirse ayrı parça.
- Kitapta cümle Türkçesi (anlam paneli): sayfa düzeyindeki "Sayfanın Türkçesi" sesi (H-105) zaten kapsıyor.
- Pakette bağlanmayan `ceviri.tr.json` satırları (TITLE/CARD/TASK taslakları, 64 satır).
- Konuş'ta karakter repliği/örnek cevap/kapanış Türkçesi (`turns[].line.tr`, `model.tr`, `outro.tr`; ≈ 540 karakter)
  ve konu seti örnek cümlesi Türkçesi (`exampleTr`, 745 karakter; Defter/Kelime tekrarı kartlarına gider): ayrı ekran ve
  ayrı paket hattı (Konuş `tts_episode_tr.py --talk` düzeni, konu setleri sezon paketi); Konuş'taki Türkçe bilerek
  açılıp kapanan bir destek, tekrar kartında Türkçe ses hatırlamayı ele verebilir. → **Faz 3b'de eklendi** (aşağıda).
- Keşfet bölüm kliplerinin alıştırma metinleri (`klipler/S1.json` `quiz.promptTr/explainTr`, 1.192 karakter): çeviri
  değil; Faz 1 yalnız reelleri kapsadı → **Faz 3b'de eklendi**.
- Defter kayıtlarının Türkçesi (kaydedilen kopyalar) ve görev/ipucu/Hi metinleri (çeviri değil).

**Araçlar** (varsayılanlar değişmedi; yeni bölüm yalnız istenince planlanır):
`tts_lesson.py --part translation`; `tts_episode_tr.py --part translation` (`--package` kurulmuş bölüm paketine ekler,
`--tr-ledger`, `--allow-english`; `--hi/--talk` ile karışmaz); `tts_reel_tr.py --part subtitles` (varsayılan `practice`;
`--allow-english`). Ses Hi (`alania2-f1`). Anahtar = metin + ses + model + üslup + söyleniş: biri değişince ses eskir ve
pakete girmez.

**Söyleniş sözlükleri** (yalnız çeviri sesine gider; anlatım/açıklama/alıştırma seslerinin anahtarı değişmez):
`lesson.json → translationPronunciations` (4 ders: Port Lumen, Alex, Theo, Gavin), `ceviri.tr.json → pronunciations`
(11 bölüm: Alex→Aleks, Lumen Point→Lumın Poynt, Port Lumen→Port Lumın, Light Night→Layt Nayt, Grant→Grent,
Tide & Pages→Tayd end Peyciz, PLRC→Pi El Ar Si, "He mi?" He→Hi, Free→Frii, Fried→Frayd), reellerde
`narrationTr.translationPronunciations` (gerek çıkmadı). Denetim `english_in_translation`: İngilizce kelime listesi +
hikâye ad listesi; Türkçe olan "not, pasta, pardon, Bay, piller, -in/-den/-ma" ve Türkçe okunuşu yeterli adlar
(Maya, Sam, Jordan, Tom, Rosa, Helen, Ellen, E., N. …) yanlış alarm sayılmaz. Şu an **sözlükte olmayan İngilizce 0**.
`--execute` sözlükte olmayan İngilizce kelime/ad varsa reddeder (`--allow-english` ile geçilir).

**Lint:** grammar-lint `translation-audio` (eksik ses ders başına tek uyarı; eskimiş, sahipsiz dosya) ve
`translation-english`; content-lint aynı kodlarla bölüm başına (paket varsa `translationAudio`/`trAudio` bağ denetimi);
reel-lint `reel.tr-audio` (altyazı eksik sesi reel başına tek uyarı, İngilizce uyarısı, paket `cues[].trAudio` yol ve
dosya denetimi).

**Paket:** dilbilgisi `cards.json` örnek ve "Söyle" maddesinde `trAudio`/`trDuration` (+ manifest `textSha256`,
`translationMissing`); bölüm `scenes.json → episode.translationAudio = {Türkçe metin: "audio/ceviri/<parça>.m4a"}` ve
altyazıda `cues[].trAudio` (`export_package.py` kurarken ya da `--package` ile yerinde; manifest dosya listesi yenilenir);
reel `cues[].trAudio = "audio/tr/sub-<satır>.m4a"` (`build_reel.py` ya da `tts_reel_tr.py --package`). Eskimiş ya da
eksik ses paketi durdurmaz.

**Mobil:** anlam panelinde "Türkçesini göster"den sonra Türkçe kutusunda **Türkçesini dinle** (bölüm, Keşfet reel ve
klipleri, dilbilgisi örneği): yalnız ses varken, yalnız dokununca; başlarken panelin İngilizce sesini durdurur, kelime
ya da "Tekrar dinle" başlayınca durur; panel kapanınca durur. Dilbilgisinde "Söyle" Türkçesinin yanında aynı düğme
(ders sesiyle çakışmaz, sessiz modda gizli). Altyazı varsayılanları (K-03) değişmedi.

### Kuru çalışma (2026-11-27, `--offline`; ≈ 0,87 TL / 1.000 karakter)
| Kapsam | Parça | Karakter | ≈ TL |
|---|---|---|---|
| Dilbilgisi örnek + "Söyle" Türkçesi (A1 4.265 · A2 4.718 · B1 4.931 · B2 5.125 · C1 3.687 · C2 3.481) | 951 | 26.207 | 22,78 |
| Bölüm çevirileri (A1-001…A1-012; prolog A1-000'da çeviri yok) | 568 | 10.510 | 9,13 |
| Reel altyazı Türkçesi (18 reel) | 54 | 1.229 | 1,07 |
| **Faz 3 toplam** | **1.573** | **37.946** | **≈ 33** |

Komutlar (P=`tools/content-pipeline/.venv/bin/python`):
`$P tools/content-pipeline/tts_lesson.py dilbilgisi/G-* --part translation --offline` ·
`$P tools/content-pipeline/tts_episode_tr.py icerik/A1-0* --part translation --offline` ·
`$P tools/content-pipeline/tts_reel_tr.py reeller/*-R-* --part subtitles --offline`.
Üretimden sonra paket: `export_grammar.py`, `tts_episode_tr.py icerik/A1-0* --part translation --package` (ya da
`export_package.py`), `tts_reel_tr.py reeller/*-R-* --package`.

### Karar bekleyen (Faz 3) — 2026-11-28: çözüldü (onaylandı, H-116 iptal, üretildi)
- Maliyet onayı (≈ 33 TL, 37.946 karakter) ve H-116 tavanı.
- ~~Faz 3b: Konuş çevirileri ve konu seti örnek Türkçesi yapılsın mı?~~ **Karar 2026-11-27: Türkçe gösterilen her
  yerde Türkçe ses** → Faz 3b (aşağıda; Keşfet bölüm kliplerinin alıştırması da dahil).
- "E." ve "N." (mesajdaki imza harfleri) sözlüksüz, Türkçe harf okunuşuna bırakıldı; İngilizce harf adı ("ii", "en")
  istenirse `ceviri.tr.json → pronunciations`'a eklenir (ses üretilmeden önce eklenirse ek ücret yok).

## Faz 3b: Konuş çevirileri, konu seti örnek Türkçesi, Keşfet klip alıştırması (kullanıcı kararı 2026-11-27)
Karar: "Türkçe gösterilen her yerde Türkçe ses." Faz 3'te dışarıda bırakılan üç yer eklendi. Araç, lint, paket ve
mobil düğme hazır (ücretsiz, commit yok); **ücretli üretim yapılmadı**.

**Kapsam ve parça kimlikleri** (sabit; tur/öğe/klip kimliğinden, metin sırası değişse de kaymaz; aynı Türkçe metin
birimde bir kez):
- **Konuş** (`icerik/_evren/konusma/*.json`): karakter repliğinin Türkçesi `turns[].line.tr` → `<görev>-<tur>-line`,
  mesaj görevinin örnek cevabı `model.tr` → `<görev>-model`, kapanış `outro.tr` → `<görev>-outro`. Ses
  `konusma/audio/ceviri/`, kayıt aynı klasörde `PROMPTS.md`. Ayrı sözlük `translationPronunciations` (Hi'nin yönlendirme
  seslerinin anahtarı değişmesin): cafe-rosa, maya-neighbour, hi-intro Alex → Aleks; meet-note Pier 3 → Piyır srii.
- **Konu seti** (`icerik/_evren/setler/*.json`): `items[].exampleTr` → `<set>-<öğe>-ex`, ses `setler/audio/ceviri/`;
  sözlük `translationPronunciations` (alex-room: Alex → Aleks).
- **Keşfet klip alıştırması** (`icerik/_evren/klipler/S1.json` → `quiz`): reel alıştırmasının (Faz 1) kuralı —
  `<klip>-prompt` = soru + seçenekler (yalnız hepsi Türkçeyse, kaynaktaki sırayla), `<klip>-explain` = açıklama. Ses
  `klipler/audio/tr/`; dosya düzeyinde `pronunciations` (38 terim: sorulardaki İngilizce ifadeler — "Can you hear me" →
  "Ken yu hiir mi", "Nice to meet you" → "Nays tu miit yu", "Pier 3" → "Piyır srii", Türkçe cümlede İngilizce "at" →
  "et" …). Önerideki 1.192 karakter yalnız soru + açıklamaydı; Türkçe seçenekler de okununca (reel kuralı, 8 klip)
  1.778 karakter.

**Araç:** yeni `tts_season_tr.py --part talk|sets|clips` (en az bir `--part` zorunlu; başka aracın varsayılanı
değişmedi). `--offline` kuru çalışma, `--execute` aylık tavan şart, `--segment`, `--season`, `--allow-english`
(varsayılan: sözlükte olmayan İngilizce varsa `--execute` reddeder), `--force`, `--ledger`, `--strict`. Kod
`hvpipeline/seasontr.py`; `tts_tr.py`'ye dokunulmadı. Anahtar = metin + ses + model + üslup + söyleniş: biri değişince
ses eskir, lint uyarır, pakete girmez. **Sözlükte olmayan İngilizce kelime/ad: 0** (üç bölümde de; Türkçe okunuşu
yeterli adlar — Maya, E. — yanlış alarm sayılmaz).

**Lint** (`content_lint.py`, ses haritası varsa): `talk-tr-audio` (eksik ses görev başına tek uyarı), `set-tr-audio`
(set başına tek uyarı), `clip-tr-audio` (klip dosyası başına tek uyarı); eskimiş, yerelde olmayan, zayıf hizalı ve
sahipsiz ses uyarı; bozuk sözlük hata; `*-tr-english` sözlükte olmayan İngilizce uyarısı. Şu an 0 hata (eksik ses
uyarıları: 6 Konuş görevi, 4 set, 1 klip dosyası).

**Paket** (`export_package.py --season 1`; ayrı `--package` adımı yok, sezon paketi zaten sesi kopyalayarak kurulur):
Konuş satırında `trAudio` = `talk/ceviri-<parça>.m4a` (+ season.json `talk.trAudio`, `trAudioMissing`); konu seti
öğesinde `exampleTrAudio` = `<set>/tr-<öğe>.m4a` (`sets/` altında); klipte `quiz.audioTr = {prompt|explain: {audio,
textSha256, duration}}` → `clips/<klip>.tr-<prompt|explain>.m4a`. Yalnız güncel ses girer (metin de birebir
denetlenir); eskimiş/kaldırılmış ses dosyası silinir. 2026-11-27 sezon paketi kuruldu: çeviri sesi 0 (eksik 18), hata yok.

**Mobil** (`HiListenButton`, yalnız dokununca, ses yoksa görünmez):
- Konuş sahnesi: karakter balonunda "Türkçesi" açılınca **Türkçesini dinle**; Türkçe kapanınca düğme gider ve ses
  durur; başlarken satırın İngilizce sesini durdurur, İngilizce satır başlayınca durur. Mesaj görevinde örnek cevap
  kartında (Türkçe orada hep görünür) aynı düğme.
- Defter/Kelime tekrarı/konu seti kartı (`CardFace`): konu setinden gelen kartta örnek cümlenin Türkçesinin yanında
  **Türkçesini dinle** — kart yüzü Türkçeyi zaten gösterir (tekrarda cevaptan sonra), soru yüzünde düğme yok. Ses
  yolu setten okunur (`cueId` `set:<set>/<öğe>`); defterdeki kopya metin setteki metinle aynı değilse düğme yok.
  Kartın İngilizce sesiyle aynı anda çalmaz.
- Keşfet bölüm klibi alıştırması: akıştaki soru kartında (`QuizCard`; ayrıca reel kartıyla ortak `PracticeCard`)
  reel ile aynı "Soruyu dinle" ve (cevaptan sonra) "Açıklamayı dinle"; yol sezon paketinden (`_season/S1/clips/…`).

### Kuru çalışma (2026-11-27, `--offline`; ≈ 0,87 TL / 1.000 karakter)
| Kapsam | Birim | Parça | Karakter | ≈ TL |
|---|---|---|---|---|
| Konuş: replik + örnek cevap + kapanış Türkçesi | 6 görev | 18 | 540 | 0,47 |
| Konu seti örnek Türkçesi | 4 set | 30 | 745 | 0,65 |
| Keşfet klip alıştırması (soru + Türkçe seçenekler + açıklama) | 15 klip | 30 | 1.778 | 1,55 |
| **Faz 3b toplam** | | **78** | **3.063** | **≈ 2,66** |

Komut (P=`tools/content-pipeline/.venv/bin/python`):
`$P tools/content-pipeline/tts_season_tr.py --part talk --part sets --part clips --offline` (bölüm başına ayrı da
çalışır). Üretimden sonra paket: `$P tools/content-pipeline/export_package.py --season 1`.

**Testler:** `tests/test_season_tr.py` (10), `mobile/test/features/h109/season_audio_h109_test.dart` (9).
**İnceleme:** qa-code-reviewer — 1 önemli bulgu düzeltildi (klip sesi düğmesi yalnız `PracticeCard`'daydı; Keşfet
akışının gösterdiği `QuizCard`'a eklendi, akıştan geçen test eklendi); 1 küçük bulgu belgelendi (aynı metin bir
birimde iki yerdeyse ses kimliği ilk yerden).

### Karar bekleyen (Faz 3b) — 2026-11-28: çözüldü (onaylandı, üretildi)
- Maliyet onayı (≈ 2,66 TL, 3.063 karakter) ve H-116 tavanı.
- Klip sorularındaki İngilizce ifadeler Alania ile söyleniş sözlüğünden okunur (Konuş H-104'teki kip a gibi); kulakla
  kontrol önerilir. İstenirse Türkçe seçenekler soru sesinden çıkarılabilir (reel kuralından ayrılır; −586 karakter).


## Üretim sonucu (2026-11-27/28)
| Bölüm | Parça | Karakter |
|---|---|---|
| Faz 1: dilbilgisi yanlış cevap açıklamaları | 285 | 11.642 |
| Faz 1: Keşfet reel alıştırmaları | 36 | 1.733 |
| Faz 2: kitap sonu soruları + tanıtımlar | 90 | 12.014 |
| Faz 3: dilbilgisi örnek/Söyle Türkçesi | 951 | 26.207 |
| Faz 3: bölüm çevirileri (A1-001…012) | 568 | 10.510 (+ ≈ 1,4 bin yeniden) |
| Faz 3: reel altyazıları | 54 | 1.229 |
| Faz 3b: Konuş + konu seti + klip alıştırması | 78 | 3.063 |
- **Defter (`kitaplar/_maliyet/patientdesk-karakter.json`, 2026-11):** 809.255 → **875.717** karakter (+66.462 ≈ **58 TL**,
  0,75 TL/1.000 Alania + Duyu). Ücretsiz durum okuması: ücretli dönem, Duyu kotası ≈ 984 saat.
- **Üretimde bulunan iki sorun (düzeltildi, testli):**
  1. ffmpeg kısa bir mp3'ü VVC video sandı (A1-005 `l-be768cd243`) → `media._inp`/`_probe_fmt` `.mp3` girdisine `-f mp3`.
  2. Alania metnin **başındaki parantezi yönerge sayıyor**: "(Hatalı) Geç kaldım" → "Hatalı" okunmadı; tamamı parantezli
     "(Hatalı sıra: Yedi cuma.)" → HTTP 400 "nothing to speak after its instruction" (ücret yazılmadı). → `tts_tr.spoken_text()`
     baştaki grubu açar ("Hatalı: Geç kaldım"); açılamayan/boş metin ücretli çağrıdan önce reddedilir. Ekran metni değişmez.
     A1-007 "O [erkek]" → "O (erkek)" (ceviri + story.tr.md). Daha önce üretilmiş hiçbir sesin anahtarı değişmedi.
- **Paket:** `export_grammar`, `export_book`, `tts_reel_tr --package` (alıştırma + altyazı), `tts_episode_tr --part translation
  --package`, `export_package --season 1`.
- **Doğrulama:** pytest 684+, `fvm flutter analyze` temiz, `fvm flutter test` 1556; son qa-code-reviewer: engelleyici yok, 3 küçük
  bulgu düzeltildi (açılamayan parantez, Konuş ses sayısı, reel paketinde eski Türkçe ses kalması). Codex kanca bulguları
  (`build_reel` yol/sembolik bağ denetimi, `export_book` boş klasör, hata mesajları) düzeltildi.
- **Kulakla dinlenecekler:** İngilizce kelimeli açıklamalar ("However" → "Hauevır", "Although" → "Oldou", "arguably"),
  hizalama uyarılı parçalar (lint listesi), "(Hatalı) …" satırları, A1-007 "O (erkek)".
- **Commitler (push edildi):** `80f8492` (kod: araçlar, mobil düğmeler, testler, güvenli reel/ffmpeg girdileri) ve
  `a1ecec2` (içerik: hizalamalar, söyleniş sözlükleri, belgeler). CI **`46129256249`** yeşil (içerik, backend, mobil).
  Ses dosyaları git dışı (`.mp3`/`.m4a`); `align.json`, `lesson-audio.json`, PROMPTS kayıtları depoda.

## Kabul için kalan (2026-11-28)
1. **Simülatörde deneme** (kullanıcının açık izniyle): dilbilgisi yanlış cevap açıklaması ve örnek Türkçesi "dinle",
   bölüm anlam paneli çeviri sesi, Keşfet reel alıştırması/altyazı Türkçesi ve bölüm klipleri, kitap sonu soruları,
   Konuş replik/örnek cevap çevirileri, konu seti kartları. Kontrol: yalnız dokununca çalar, ses yoksa düğme yok,
   İngilizceyle üst üste çalmaz, sessiz mod korunur, cevabı önceden açmaz.
2. **Kulakla kontrol** (kullanıcı): yukarıdaki "Kulakla dinlenecekler".
3. İkisi tamamsa dosya `bitenler/`e, `IS-SIRASI.md` güncellenir. Düzeltme gerekirse yalnız ilgili parça yeniden üretilir
   (≈ 0,87 TL/1.000 karakter, maliyet gösterilip onay alınır).

