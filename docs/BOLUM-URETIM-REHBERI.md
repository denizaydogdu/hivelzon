# Bölüm üretim rehberi (S1 B6–B12 için)

**Tarih:** 2026-10-14 (H-085, B5 ile denendi) · **Ayrıntılar:** `docs/BOLUM-PAKETI.md` (biçim, lint kuralları), `CLAUDE.md` (Higgsfield kuralları, H-024 standart yol), örnek bölümler `icerik/A1-004-the-note/` ve `icerik/A1-005-too-late/`.

Kısa yol: **diyalog → kurgu.json → görseller → Türkçe ses → İngilizce ses → çeviri → lint → paket.** Her adım idempotenttir; yarıda kalırsa aynı komut kaldığı yerden sürer.

```bash
P=tools/content-pipeline/.venv/bin/python          # worktree'de venv yoksa ana kopyanınki
HF=~/.nvm/versions/node/v18.20.7/bin/higgsfield
B=icerik/A1-006-the-recording                       # bölüm klasörü
```

## 0. Hazırlık

- [ ] `yapilacaklar/IS-SIRASI.md`'den sıradaki H numarasını al; iş dosyasını `devam-edenler/`e aç.
- [ ] Oku: `$B/story.en.md` (H-032 onaylı diyalog), `$B/content.json`, `icerik/_evren/SEASON_01_OUTLINE.md` (bölüm satırı; ★ = gerçek klip), `CHARACTER_PROFILES.md` (kıyafet ve ses), önceki bölümün `kurgu.json`'ı ve son karesi.
- [ ] Görsel referansları ve önceki bölüm görselleri yalnızca **ana kopyada** (git dışı). Worktree'de çalışılıyorsa sahne görselleri worktree'ye üretilir; referanslar için job kimliği yeterlidir (dosya kopyalamak gerekmez).

## 1. Ses kimlikleri ve kurgu (`audio_manifest.json`, `kurgu.json`)

- [ ] `audio_manifest.json`: her İngilizce replik `"KONUŞMACI|metin": "b<N>_<sıra>_<ad>"`. Hi ve `(TR)` satırları buraya **girmez** (Türkçe sesi araç kendisi `tr_<düğüm>` olarak adlandırır).
- [ ] `kurgu.json`: `title` → `recap` (önceki bölümün son karesi, ≤ 15 sn, `../A1-00x-…/images/…`) → sahneler. Düzen için A1-004/A1-005'i kopyala.
  - Saatler, tabelalar, notlar, harita yazıları **görselde değil** `signs[]` ile (caption / note).
  - Karar: yanlış seçenek → `reaction` (karakterin nazik tepkisi + Hi balonu) → aynı karara döner. İki doğru seçenekte, öteki bilgi de gerekiyorsa her dal ikisini de içeren bir segmentle birleşir (A1-005 `k2-who` / `k2-where`).
  - Hi satırları: `card` (kind `hi`) ya da `bubble`; İngilizce ifadeler `speechTr` içinde `{…}` (b kipi: Türkçe Alania + İngilizce Sarah). Hi'nin yalnız Türkçe geri bildirimleri İngilizce kotası gerektirmez.
  - `gate`: `comprehension` (görev), `targetPhrase` (karar/görev), `activeTask` (kanıt görevi). A1'de en çok 4 karar.
- [ ] Ses yokken de lint çalışır: süreler `audio_manifest.json` metninden tahmin edilir (`missing-audio` uyarısı).

```bash
$P tools/content-pipeline/content_lint.py $B --no-sets --no-hi --no-clips   # 0 hata hedefi
```

## 2. Görseller (Higgsfield, H-024)

- [ ] Çekim listesi: sahne başına 1–3 görsel; karar arka planları (POV), görev arka planı, son kare. B5: 14 görsel ≈ 7 kr.
- [ ] Yeni karakter ya da nesne ilk kez çıkıyorsa önce referans sayfası (3:2, 0,5 kr) üret; `_evren/style/PROMPTS.md` ve `STYLE_PREFIX.md` tablosuna yaz. Var olanlar: Alex `663ea0fe-3df5-4cea-ba8c-e08c80e48a96`, Hi `48e01750-…`, telsiz `74fb45e8-d78d-4902-b6d6-e95fd85aca46`, Maya `6db4fa91-a3ff-4587-9b02-43a480ecb45a`, Jordan (job) `185195f6-f42d-4cbe-a013-7151a26d759a`, kaydedici (job) `72e65920-4ec7-4946-ae36-502810c61948`.
- [ ] Prompt kuralları: "Use the reference image(s) for …" ile başla; **birden çok karakterde kıyafetleri açıkça yaz** ("NOT an olive jacket", B4-01 dersi); "no text on any sign"; sonuna STYLE v1.1 öneki.
- [ ] Maliyet ve bakiye: `$HF account status` (hesap başka oturumlarla ortak) ve `$HF generate cost gpt_image_2_5 --prompt x --aspect_ratio 9:16 --resolution 2k --quality low` (0,5 kr). Toplamı göster, onayı al.
- [ ] Üretim: `$HF generate create gpt_image_2_5 --aspect_ratio 9:16 --resolution 2k --quality low --prompt "…" --image-references <id> … --wait --json` → yanıtı `images/<ad>.json`'a yaz (depoda), `result_url`'u `images/<ad>.png`'ye indir (git dışı). **Önce hedef klasörü oluştur**: çıktı kaydedilemezse iş yine ücretlenir (B5'te `generate list --json` ile kurtarıldı).
- [ ] ★ gerçek klip yalnızca sezon planında işaretli anda: Seedance 2.0 Mini, başlangıç + bitiş karesi, 5 kr / 5 sn.
- [ ] Temas sayfası ve gözden geçirme (yazı, kıyafet karışması, spoiler; ör. Ellen'in yüzü S1'de yok):
  ```bash
  magick montage $B/images/B*.png -font /System/Library/Fonts/Supplemental/Arial.ttf -label '%t' \
    -geometry 360x640+8+8 -tile 7x -pointsize 16 .yerel/<iş>/kontak.jpg
  ```
- [ ] `PROMPTS.md`: her görsel için ad, referans, kredi, job, prompt; toplam kredi ve hesap bakiyesi önce/sonra; değerlendirme.

## 3. Türkçe sesler (Alania, H-083)

```bash
$P tools/content-pipeline/tts_episode_tr.py $B                                  # kuru çalışma
$P tools/content-pipeline/tts_episode_tr.py $B --tr-cap 2000000 --execute        # İngilizce kota varsa
$P tools/content-pipeline/tts_episode_tr.py $B --tr-cap 2000000 --tr-only --execute   # ElevenLabs kotası bitmişse
```

- PatientDesk anahtarı `~/.config/hivelzon/patientdesk.env`'den okunur; kampanya 2026-11-14'e kadar ücretsiz.
- `--tr-only`: saf Türkçe sesler biter; `{…}` içeren satırların Türkçe parçaları `_raw/` önbelleğine alınır. Sarah kotası gelince aynı komut `--tr-only` olmadan çalıştırılır; Türkçe parçalar yeniden ücretlenmez.
- Araç `kurgu.json`'a `audio` ekler ve `PROMPTS.md`'ye yazar.

## 4. İngilizce replikler (ElevenLabs)

```bash
$P tools/content-pipeline/tts_episode_en.py $B                                  # kuru çalışma: satır, ses, karakter
$P tools/content-pipeline/tts_episode_en.py $B --execute --cap 10000 \
   --ledger kitaplar/_maliyet/elevenlabs-hesapN-karakter.json --key-file ~/.config/hivelzon/elevenlabs.env
```

- Sesler `_evren/sesler.json` → `episodeEnglish.voices` (Alex Jessica, Maya Sarah, telsiz Lily, Mrs Brooks Alice, adam George). **Yeni karakterin sesi kullanıcı onayıyla eklenir**; tanımsız ses varsa araç çağrı yapmaz.
- Hangi hesap ve defter kullanılacağı kullanıcıya sorulur (ücretsiz hesaplar yalnız iç kullanım, H-006).

## 5. Çeviri ve lint

- [ ] `ceviri.tr.json`: altyazı satırları **ipucu metniyle birebir** (bölme kuralı: cümle; tek kelimelik cümle sonrakine eklenir; ör. "Hello! Is that a radio?"). Kart İngilizcesi, karar repliği (`cue`), görev kökleri, hedef ifadeler (altyazıda yoksa `phrases`), sözlük kelimeleri. Durum `DRAFT`.
- [ ] Gerçek ses gelince ipucu metinleri değişmez; yalnızca zamanlar değişir.
- [ ] `story.tr.md` (okunur çeviri, editör için).
- [ ] Lint 0 hata: `$P tools/content-pipeline/content_lint.py $B`

## 6. Paket (ana kopyada; ffmpeg + ImageMagick)

```bash
$P tools/content-pipeline/export_package.py $B          # bütün İngilizce sesler hazır olmalı
$P tools/content-pipeline/content_lint.py $B             # paket denetimi (missing-file, senkron)
```

- Sezon başlık arka planı (`_evren/jenerik/_build/`) ve önceki bölüm görselleri ana kopyada; worktree'de paket üretilmez.
- Ses eksikse araç "ses dosyası yok: …mp3" ile durur (ücretli çağrı yapmaz).

## 7. Kapanış

- [ ] Commit: metin, json, `*.align.json` (medya değil). `/commit`, Claude imzası yok.
- [ ] İş dosyası ve `IS-SIRASI.md` (kredi, karakter, kalan işler).
- [ ] Editör onayı (H-028): görseller, çeviri, ipuçları (1. ve 2. düzey Claude yazdı).
