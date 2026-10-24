# H-094 · 18 reelin ön değerlendirmesi (2026-10-23)

> **Amaç:** H-092 pilotundan önce 18 reelin teknik, görsel ve öğretim kalitesini denetlemek.
> **Kapsam:** Ücretsiz, yerel inceleme. Ücretli üretim yapılmadı; içerik değiştirilmedi.
> **Sınır:** Bu bir **ön değerlendirmedir**, insan/öğretmen değerlendirmesinin (H-028) yerine geçmez.
> Ses kalitesi kulakla değil, ölçümle (LUFS, tepe, F0) değerlendirildi; müzik/ton hissi dinlenmedi.
> **Yöntem:** 18 paketin `reel.json` + `production.json` dosyaları; her reel için 4 kare (ffmpeg);
> karakter karşılaştırma sayfaları; CEFR-J kapsama (`hvpipeline.cefr`); `reel-lint`; LUFS/tepe;
> konuşma–altyazı hizası (8 kHz enerji zarfı); F0 (otokorelasyon); mp4 faststart.
> Çalışma dosyaları: `.yerel/h094-review/` (git dışı).

## Yönetici özeti

- **Teknik olarak 18/18 yayına uygun:** 720×1280 H.264/AAC, 11,0–13,4 sn, faststart, ses −15,5…−16,2 LUFS,
  altyazı–ses hizası 0,04–0,28 sn, cue dışı konuşma yok, 3 seçenekli sorularda tek doğru.
- **Pilot öncesi 2 içerik hatası var:** (1) `A1-R-SPO-02`'de konuşmacı/hedef ifade ters (Elif topa sahipken
  pas istiyor); (2) `A1-R-CIN-02`'de Türkçe çeviri hatası ("Koltugum" → "Koltuğum").
- **Görsel kalite:** Stil tutarlı ve sıcak; ancak tekrar eden karakterlerin **yüz kimliği reeller arasında
  kayıyor** (ELIF, MERT, KEREM; LENA'da daha hafif). Birkaç yakın planda **el artefaktı** ve
  `A2-R-CIN-02`'de **boş afiş çerçeveleri** var. Bunlar pilotu durdurmaz; katalog büyürken karakter
  referansı ve el denetimi şart.
- **Seviye:** 18'in 8'i %95 CEFR-J alt sınırının altında (en düşük `A1-R-SPO-03` %80). Liste dışı
  kelimelerin hepsi uygulamada Türkçe karşılıklı; ikisi metin değişikliğiyle ücretsiz düzeltilebilir.

## 1. Teknik tablo

| Reel | Süre | Cue | LUFS | Tepe | Kapsama | Not |
|---|---:|---:|---:|---:|---:|---|
| A1-R-BOK-01 | 11,0 | 3 | −15,8 | −4,9 | %100 | — |
| A1-R-BOK-02 | 12,1 | 3 | −15,5 | −2,3 | %100 | — |
| A1-R-BOK-03 | 11,9 | 3 | −16,0 | −2,3 | %100 | Saç değişimi (4. kare) |
| A1-R-CIN-01 | 12,6 | 3 | −15,9 | −5,7 | %92,9 | "film" A2 (sözlükte) |
| A1-R-CIN-02 | 11,9 | 3 | −16,0 | −6,2 | %85,7 | Çeviri hatası + "%95 altı" |
| A1-R-CIN-03 | 12,7 | 3 | −16,2 | −7,0 | %84,6 | "popcorn" B1 (görsel konu) |
| A1-R-SPO-01 | 11,0 | 3 | −15,5 | −4,7 | %93,8 | "rest" B1 |
| A1-R-SPO-02 | 12,1 | 3 | −15,6 | −4,8 | %91,7 | **Konuşmacı/hedef ters** |
| A1-R-SPO-03 | 12,5 | 3 | −16,0 | −4,6 | %80,0 | "shoots" listede yok, "whole" A2 |
| A2-R-BOK-01 | 13,4 | 3 | −16,2 | −4,9 | %100 | 4. karede boş raflar; el |
| A2-R-BOK-02 | 12,4 | 3 | −16,0 | −5,3 | %100 | — |
| A2-R-BOK-03 | 12,4 | 3 | −16,0 | −4,0 | %100 | Kapakta silik karalama; eller |
| A2-R-CIN-01 | 12,6 | 3 | −15,8 | −2,7 | %100 | Boş sinema tabelası |
| A2-R-CIN-02 | 12,4 | 3 | −16,0 | −3,8 | %100 | **Boş afiş çerçeveleri** |
| A2-R-CIN-03 | 12,5 | 3 | −16,0 | −3,8 | %100 | — |
| A2-R-SPO-01 | 12,0 | 3 | −16,0 | −1,7 | %100 | El artefaktı |
| A2-R-SPO-02 | 12,4 | 3 | −16,0 | −1,4 | %92,9 | **6 parmaklı el**; "routine" B1 |
| A2-R-SPO-03 | 12,3 | 3 | −16,0 | −4,3 | %92,9 | "score" B1; yumruk sahnesi |

- Toplam süre **220,2 sn**; kategoriler 3 × (Sinema · Spor · Kitap), seviyeler A1/A2, **18/18 `standalone`**,
  `related` boş (uygulamada "Tam hikâye" yok — beklenen).
- **5 reel Seedance klibi kullanıyor** (hepsi A1: BOK-02, CIN-01, CIN-03, SPO-01, SPO-02); diğer 13'ü
  Ken Burns. A2'nin tamamı Ken Burns; A2 bu yüzden daha statik duruyor (kural ihlali değil, gözlem).
- Kayıtlı üretim kredisi **61,0 kr** (72 görsel × 0,5 + 5 klip × 5); gerçek harcama **61,50 kr**
  (0,5 kr'luk tek yeniden üretim `production.json`'a işlenmemiş). Bakiye 236,56 kr.
- `reel-lint`: **18 · 0 hata · 0 uyarı**. Faststart: 18/18. Ses–altyazı: konuşma, altyazıdan
  **0,04–0,28 sn sonra** başlıyor (altyazı önce çıkıyor; kabul edilebilir), cue dışında konuşma yok.
- **Ses kimliği:** kadın konuşmacılar 182–271 Hz, erkekler 81–149 Hz; `A1-R-SPO-02`'de "I'm open!"
  bağırma repliği 222 Hz (aynı karakterin diğer repliği 92 Hz) — ses karışması değil, doğal yükselme.
  Konuşmacı→ses eşlemesi (Sarah/Will/Chris) ölçümle doğrulandı.

## 2. Bulgular

### P1 — Pilot öncesi düzeltilmeli

**P1-1 · `A1-R-SPO-02` konuşmacı ve hedef ifade ters.**
- Görsel: Elif topa sahip (1,5 sn); Mert uzakta, kolları havada, top istiyor.
- Altyazı: Mert "I'm open! Over here!" (0,5–2,58) → **Elif "Pass the ball, please."** (3,4–4,76)
  → Mert "Here you go." (9,6–10,48).
- Çelişki: topu olan Elif pas istiyor; "Burada, buyur" diyen Mert topu veriyor. Doğrusu:
  Mert "I'm open! Over here!" + **Mert "Pass the ball, please."**, Elif "Here you go."
- Düzeltme: 2 satırın `speaker` alanı değişir; iki ses yeniden üretilir (Will + Sarah, ~33 karakter);
  soru **"Mert ne istiyor?"**, açıklama "Mert topun kendisine atılmasını istiyor." olur.
  Görsel yeniden üretim gerekmez. Paket + fixture + `contentVersion` yenilenir.

**P1-2 · `A1-R-CIN-02` Türkçe çeviri hatası.**
- `s01-02` çevirisi **"Koltugum nerede?"** → **"Koltuğum nerede?"** (ğ eksik).
- Aynı metin kaynak `reel.json`, `_build/package/reel.json` ve `mobile/test/fixtures/reels/A1-R-CIN-02.json`
  içinde. Backend'de yayınlanan sürüm de bu metni taşıyor.
- Ses yeniden üretimi gerekmez; paket yeniden kurulur, yeni `contentVersion` ile içe aktarılır.

### P2 — Pilotu durdurmaz, kaliteyi düşürür

**P2-1 · `A2-R-CIN-02`: boş afiş çerçeveleri + "bu" işaretinin karşılığı yok.**
- Sinema holünde 3–4 büyük afiş çerçevesi **tamamen boş/beyaz** (0,5–9,3 sn).
- Selin "Then let's watch this one. It is new." (7,0–9,32) derken eliyle **boş çerçeveyi** işaret ediyor.
- `A2-R-CIN-01`'de de büyük sinema tabelası boş. Metinsiz kuralı doğru; ama boş beyaz yüzey
  "yüklenmedi" hissi veriyor. Çözüm: 3–4 kareye soyut/renkli afiş sanatı (yazısız) ya da
  2,0 kr ile 4 kare yeniden üretim.

**P2-2 · `A2-R-BOK-01`: 4. karede raflar boş.**
- İlk üç karede raflar dolu; 10,0 sn'den sonra kütüphaneci ve Kerem'in arkasındaki raflar **tamamen boş**.
- Tek kare yeniden üretimi (0,5 kr) ya da kabul + not.

**P2-3 · `A1-R-BOK-03`: aynı reel içinde saç değişiyor.**
- 1.–3. kare: LENA'nın saçı **topuz/bandana ile toplu**; 4. karede (≈10,5 sn) **uzun, açık**.
- Tek kare yeniden üretimi (0,5 kr); pilotta göze batmıyorsa ertelenebilir.

**P2-4 · El artefaktları (yakın planlarda).**
| Reel | Yer | Ne görülüyor | Ağırlık |
|---|---|---|---|
| A2-R-SPO-02 | Antrenörle konuşma (≈7,5 sn) | Mert'in jest yapan eli **6 parmaklı/webbed** | Yüksek (kare büyük) |
| A2-R-BOK-01 | Bankoda (≈1,0 sn) | Kerem'in eli **mitten** gibi, parmaklar bitişik | Orta |
| A1-R-BOK-03 | Telefonu alırken (≈1,5 sn) | Sağ el telefona yapışmış, başparmak kayıp; sol el mitten | Orta |
| A2-R-BOK-03 | Kitabı tutarken (≈7,5 sn) | İki elde parmak uçları/başparmak zorlanmış | Orta |
| A1-R-CIN-01 | Bilet uzatma (≈7,5 sn) | Başparmak/parmak uçları anatomik değil (6 parmak değil) | Düşük-orta |
| A2-R-SPO-03 | Yumruk (≈11 sn) | Yumruklar ayrı, ama bilek açısı zorlanmış | Düşük |
| A2-R-SPO-01 | Yürürken (≈1 sn) | Eller hafif claw; bacak/knee pozu sert | Düşük |

En görünür olan `A2-R-SPO-02` (tek kare yeniden üretimi 0,5 kr). Diğerleri 720p telefonda kısa süreli;
toplu düzeltme ≈2,5–3 kr.

**P2-5 · Tekrar eden karakterlerin yüz kimliği kayıyor.**
- **ELIF:** A1-SPO-01 (yuvarlak yüz, iri gözler) → A1-SPO-02 (ince yüz) → A2-SPO-03 (olgun, farklı burun).
- **MERT:** A2-SPO-01/02 (yuvarlak yüz, kıvırcık) → A2-SPO-03 (uzun yüz, sivri çene) — **aynı seviyede**
  iki farklı kişi gibi.
- **KEREM:** A1-BOK-02 (genç, dolgun yüz) → A2-BOK-02/03 (daha uzun yüz, farklı burun); 5 reelde görünüyor.
- **LENA:** gözlük + yeşil hırka + saç kimliği taşıyor; yüz farkı daha hafif.
- **Kök neden:** her reel kendi `k1` karesinden üretiliyor; reeller arasında ortak karakter referansı yok
  (`production.json → jobs.images[].ref` yalnız aynı reel içinde). Pilot için kabul edilebilir;
  katalog büyürken karakter sayfası (referans görsel) şart. Mevcut 18 için yeniden üretim önerilmez.

### P3 — Metin, seviye ve tutarlılık

- **Kapsama:** 8/18 reel %95 altında. Liste dışı kelimelerin hepsi sözlükte:
  `film` (A2), `next`/`screen` (A2), `popcorn` (B1), `rest` (B1), `pass` (A2), `shoots` (CEFR-J'de yok),
  `whole` (A2), `routine` (B1), `score` (B1). Kural gereği %95 altı yalnız "sözlükte + görselle destekli"
  ise kabul; `A1-R-CIN-02` (%85,7) ve `A1-R-SPO-03` (%80) bu istisnaya rahat sığmıyor.
  - **Ücretsiz düzeltme:** CIN-02'de "Row five, next to the screen." → **"Row five."** (aynı zamanda
    mantık hatasını da çözer) → %100. SPO-03'te "He shoots!" → **"He kicks the ball!"** ve
    "The whole team runs to him." → **"The team runs to him."** → %100.
  - Kalanlar (film, popcorn, rest, pass, routine, score) görsel konu/yararlı kelime; **editör kararı**.
- **`A1-R-CIN-02` mantık:** "Row five, next to the screen." — beşinci sıra perdenin yanında olmaz;
  yukarıdaki sadeleştirme bunu da çözer.
- **`A2-R-BOK-01`:** "This book is due today." + "Can I keep it for one more week?" + "bring it back
  on Friday." — bugün cuma değilse "bir hafta" ile "cuma" çelişir. "…next Friday." ya da "…in a week."
- **`A2-R-CIN-01`:** "We are outside the cinema now." sahne bilgisini karaktere söyletiyor; doğal değil.
  "That was a good film." ya da doğrudan Selin'in sorusuyla açılmak daha iyi.
- **`A2-R-SPO-01` soru:** "Antrenör neye bakmasını söylüyor?" dilbilgisi bozuk → "Antrenör Mert'e neye
  bakmasını söylüyor?" ya da "Antrenör neye bakmasını istiyor?"
- **Sözlük karşılıkları:** `due → son ödeme günü` yanlış (burada "süresi dolmak"); `train → çalışmak`
  spor bağlamında "antrenman yapmak"; `keep → tut` ("keep your eyes on the ball" = "gözünü ayırma")
  yanıltıcı. `pass → pas vermek`, `score → skor` doğru.
- **Başlıklar:** `A1-R-BOK-02` "Beğeni" çok soyut (uygulamada "Video: Beğeni" olarak görünüyor);
  diğerleri eylem/yer adı. "Bu hikâyeyi seviyorum" ya da "Sevdiği hikâye" daha net.
- **`A2-R-CIN-02`** "It is new." → "Yeni." telegram üslup; "Bu yeni." / "Yeni çıkmış." daha doğal.
- **Görselde yazı:** `A2-R-BOK-03` kitap kapağında **silik, okunmayan karalamalar** var; gerçek metin
  değil ama "yazı" izlenimi veriyor. Kapak sadeleştirilebilir.

## 3. Sorular ve öğretim tasarımı

- 18/18 soru: Türkçe soru + 3 seçenek + **tek doğru** + açıklama. Doğru cevaplar diyalogla uyumlu
  (P1-1 düzeltilince SPO-02 sorusu da güncellenmeli).
- Her reelde hedef ifade **2. replikte** (pattern tutarlı); A1'de cümleler ≤6 kelime, A2'de ≤9.
- Bazı reellerde 3,3–5,5 sn sessizlik var (en uzun `A1-R-CIN-03` 5,5 sn). Görsel anlatım için kabul
  edilebilir; pilotta "video sıkıcı mı" geri bildirimiyle birlikte değerlendirilmeli.
- Günlük seçki için `family` alanı 18'de de benzersiz; "aynı aile bir kez" kuralı pratikte devreye
  girmiyor (her reel ayrı hedef). Tasarım kararıysa sorun yok; ileride aynı hedefin varyantları
  eklenirse çalışır.

## 4. Önerilen düzeltme setleri

**A. Pilot için minimum (ücretsiz metin + 3,5 kr görsel):**
1. `A1-R-SPO-02` konuşmacıları değiştir, iki sesi yeniden üret (~33 karakter), soruyu güncelle.
   → 0 kr görsel.
2. `A1-R-CIN-02`: çeviri hatası + "Row five." sadeleştirmesi; USHER sesi (~10 karakter). → 0 kr görsel.
3. `A1-R-SPO-03`: iki satırı sadeleştir; SPECTATOR sesi (~30 karakter). → 0 kr görsel.
4. `A2-R-CIN-02`: 4 kareye yazısız soyut afiş (yeniden üretim **2,0 kr**; yerel kompozit 0 kr).
5. `A2-R-BOK-01`: 4. kare raflar (**0,5 kr**).
6. `A1-R-BOK-03`: 4. kare saç (**0,5 kr**).
7. `A2-R-SPO-02`: jest yapan el (**0,5 kr**).
- **Toplam ≈ 3,5 kr** (görsel) + ~75 ElevenLabs karakteri. Kullanıcı onayıyla uygulandı;
  fiilî yeni üretim 70 karakter oldu (ana defter 9.851 → 9.921 / 10.000).

**B. Katalog büyümeden önce:**
- Karakter sayfası: LENA, KEREM, ELIF, MERT, MIA, DENIZ, SELIN, COACH için tek referans görsel;
  her reelin `k1` üretiminde bu referansı kullan. Aksi hâlde 18'lik dalga büyüdükçe kimlik kayması artar.
- El/parmak odaklı karelerde üretim sonrası **el denetimi** (özellikle yakın plan, jest, tutma).
- Boş tabela/afiş/raf için **yazısız dolgu sanatı** standardı.
- Kapsama denetimini reel-lint'e ekle (şu an yalnız süre/cue/medya denetleniyor); %95 altında
  editör onayı zorunlu olsun.

**C. Bilinçli olarak ertelenebilecekler:**
- Mevcut 18'de karakter yüzlerinin yeniden üretimi (pahalı, pilot için gereksiz).
- `A2-R-CIN-01` boş tabela, `A2-R-SPO-03` yumruk/bilek, `A1-R-CIN-01` bilet eli (kısa süreli, düşük etki).
- Başlık/üslup düzeltmeleri (editör turunda topluca).

## 5. Süreç notu

- Kaynak `reel.json` değişirse: **`contentVersion` artır** → `build_reel.py --force` → kaynak
  `duration`/`cues` senkronu → mobil fixture → `reel_lint.py --write-reports` → backend'e içe aktar →
  onayla/yayınla. Backend'de onaylı sürüm donmuştur; aynı sürümle yeniden içe aktarma `SKIPPED` döner.
- Ses yeniden üretimi: defter ve tavan açıkça seçilir (`HIVELZON_TTS_LEDGER`,
  `HIVELZON_TTS_MONTHLY_CHAR_CAP`). Bu tur sonunda ana defter 9.921/10.000.

## 6. Uygulama sonucu (2026-10-23)

- A setinin 7 maddesi uygulandı: 7 görsel **3,50 kr**, 70 yeni TTS karakteri.
- `A1-R-SPO-02`, `A1-R-CIN-02`, `A1-R-SPO-03`, `A1-R-BOK-03`, `A2-R-BOK-01`,
  `A2-R-CIN-02`, `A2-R-SPO-02` sürüm 2 olarak yeniden kuruldu ve yayımlandı.
- Lint 18/0/0; açık katalog A1 9 + A2 9; 7 yeni sürümün reel/mp4/hedef sesi 200.
- `pytest` 383, `flutter test` 1454, `flutter analyze` temiz. **Commit:** `1a66ae4` (`origin/main`).
