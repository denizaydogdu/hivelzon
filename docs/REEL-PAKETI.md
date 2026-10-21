# Reel paketi (bağımsız konu reeli) — H-094

Keşfet'in **günlük üç kısa video** alanında kullanılan **bağımsız konu reelleri**nin
paket biçimi. Kitaplık (`docs/KITAPLIK.md`) ve dilbilgisi (`docs/DILBILGISI.md`)
paketleriyle aynı yaklaşımdadır: kaynak klasör depoda, üretilen paket `_build/`
altında, geliştirme sunucusu `/reels/` kökünden sunar.

Hikâye klipleri (`clips.json`, H-040) **bu pakete girmez**; `/reels/` yalnız
bağımsız konu içeriğidir (`sourceType = standalone`). İkisi ayrı kaynaktır
(plan §4). Amaç, kapsam ve kararlar: `docs/KESFET-GUNLUK-UC-VIDEO-PLAN-2026-10-18.md`.

## 1. Yerleşim

```
reeller/<id>/reel.json           senaryo, altyazı, hedef, soru (depoda)
reeller/<id>/<id>.mp4            720×1280 H.264/AAC faststart (depo dışı)
reeller/<id>/<id>.webp           ilk kare (depo dışı)
reeller/<id>/stills/*.webp       sahne kareleri; Defter görseli (depo dışı)
reeller/<id>/audio/<cue>.m4a     kesilmiş ifade sesi; Defter sesi (depo dışı)
```

Üretim çıktısı `reeller/<id>/_build/package/` altına yazılır; `reel.json` hazırsa
paket klasörü tercih edilir, yoksa kaynak klasörden okunur. Uygulama varsayılan
olarak **backend'in yayımlanmış kataloğunu** okur (`/api/v1/catalog/reels`);
`/reels/index.json` yalnız geliştirme/demo içindir (dosya sistemini tarar,
yayın durumunu bilmez).

## 2. Kimlik

`<SEVİYE>-R-<KAT>-<NN>` — ör. `A1-R-CIN-01`, `A2-R-SPO-03`.

- **Seviye:** `A1` · `A2` · `B1` · `B2` · `C1` · `C2` (ilk pilot A1/A2).
- **Kategori (konu):** `CIN` Sinema · `SPO` Spor · `BOK` Kitap.
- **Sıra:** iki haneli (`01`).

Klasör adı kimlikle **aynı** olmalı. Seviye ve kategori kimlikten okunur ve
`reel.json` alanlarıyla uyuşmalıdır.

## 3. `reel.json` alanları

| Alan | Zorunlu | Amaç |
|---|---|---|
| `schemaVersion` | ✔ | Şu an `1`. Bilinmeyen sürüm **sessizce boş gösterilmez**; açık hata. |
| `id` | ✔ | Kimlik (bkz. §2). |
| `contentVersion` | ✔ | İçerik sürümü (≥ 1). Artınca eski izlenme/soru sonucu yeni sürüme taşınmaz. |
| `sourceType` | ✔ | `/reels/` paketinde yalnız `standalone`. |
| `category`, `categoryTr` | ✔ | Konu kodu ve Türkçe adı. |
| `level` | ✔ | Seviye. |
| `titleTr` | ✔ | Türkçe başlık. |
| `learningObjective` | — | **Tek** iletişim hedefi. |
| `family` | — | Aynı iletişim hedefinin seviye/bağlam sürümlerini bağlar. Yalnız aynı kategoride olmak aile kurmaz. |
| `duration` | ✔ | Süre (sn, > 0). |
| `video`, `poster` | ✔ / — | Video ve ilk kare (paket içi yol). |
| `image`, `audio` | — | Defter kartının taşıyacağı görsel ve kesilmiş ses (paket içi yol). |
| `target` | ✔ | `{kind: phrase\|word, en, tr, cue}`. `cue` altyazıda bulunmalı. |
| `cues` | ✔ | Zamanlı altyazı: `id`, `start`, `end`, `speaker`, `text`, `tr`, `words[]`. Zamanlar videonun başına görelidir. |
| `practice` | — | İsteğe bağlı **tek** anlama sorusu (atlanabilir): `{promptTr, options[], explainTr}`; tam olarak bir doğru. |
| `related` | — | Gerçek bağ: `{kind: episode\|book\|grammar, id, titleTr}`. Boşsa arayüzde "Tam hikâye" gizlenir. |
| `status` | — | `DRAFT` · `APPROVED` · `PUBLISHED` · `WITHDRAWN`. **Yayın yetkisi vermez**; yetkili durum backend'dedir (plan §6.4). |

## 4. Medya yolu ve Defter

Uygulama paket içi dosyayı `/reels/<id>/<yol>` üzerinden alır
(`ContentSource.reelMediaUri`). Defter kartı yolu `_reels/<id>/<yol>` önekini
taşır; `resolveMediaUri` bu öneki tanıyıp reel paketine yönlendirir
(`mobile/lib/shared/content/content_source.dart`).

## 5. Denetim (`reel-lint`)

```bash
tools/content-pipeline/.venv/bin/python tools/content-pipeline/reel_lint.py reeller/A1-R-CIN-01
tools/content-pipeline/.venv/bin/python tools/content-pipeline/reel_lint.py reeller/* --json
tools/content-pipeline/.venv/bin/python tools/content-pipeline/reel_lint.py reeller/* --write-reports
```

`--write-reports`, reel başına `<reel>/_build/lint.json` yazar (bölümlerdeki
`content_lint.py`/`book_lint.py` gibi, H-041): `tool`, `contentId`, `level`,
`errors[]`, `warnings[]`, `generatedAt`. Backend onayı bu raporu okur; rapor
`reel.json`'dan (üretim paketindeyse paket dosyasından) eskiyse yok sayılır.
Rapor **hata sayısı 0** değilse reel onaylanamaz (durum `DRAFT`'ta kalır).

Denetimler: kimlik kalıbı ve klasör uyumu; seviye/kategori/`sourceType`/`status`;
hedef satırının altyazıda bulunması; satır kimliklerinin tekilliği ve zaman
tutarlılığı; sorunun tam olarak bir doğru seçeneği olması; `related.kind`.
**Medya dosyaları eksikse yalnız uyarı** verir (paket, üretim öncesi de incelenebilir).

Çıkış kodu: `0` hata yok, `1` en az bir hata, `2` kullanım hatası.

## 6. Geliştirme sunucusu

```bash
python3 tools/dev-content-server/serve.py            # --reels-root reeller
```

```
http://127.0.0.1:8787/reels/index.json          -> demo listesi (dosya taraması; yayın durumu yok)
http://127.0.0.1:8787/reels/<id>/<yol>          -> reel.json, <id>.mp4, stills/*.webp, audio/*.m4a
```

Uygulamanın yetkili kataloğu backend'dedir:

```
GET http://127.0.0.1:8080/api/v1/catalog/reels?level=A1&size=100
    -> yalnız yayımlanmış sürümler; her kayıtta packageBaseUrl
```

`ContentSource.listReels()` varsayılan olarak bu uca gider
(`--dart-define=REEL_CATALOG_URL=...`, boş dize = eski dosya kataloğu). Backend
yanıt vermezse dosya kataloğuna **sessizce düşülmez**; hata gösterilir.

Backend `VideoHostingPort` yolu `packages/_reels/<id>/<yol>` aynı pakete gider
(kitaplardaki `_books` gibi).

## 7. Durum

- **P0:** paket biçimi, `Reel`/`ReelCatalog`, kaynak yolları, `/reels/` örneği,
  `reel-lint`, mobil ve Python testleri. Medya yok (ücretli üretim onayı yok) →
  lint uyarı, testler yeşil.
- **P1 (deneme verisi):** pilot kapsamı **6 paket** — 3 kategori × 2 seviye:
  `A1-R-BOK-01`, `A1-R-CIN-01`, `A1-R-SPO-01`, `A2-R-BOK-01`, `A2-R-CIN-01`,
  `A2-R-SPO-01` (hepsi `DRAFT`, `related` boş → "Tam hikâye" gizli, çünkü
  uydurma bölüm bağı kurulmaz). Dart kopyaları
  `mobile/test/fixtures/reels/` altında; `pytest` kayma koruması paketleri ve
  `index.json` özetlerini karşılaştırır.
- **P2 (seçim + saklama):** günlük seçki belirlenimli kurallarla (kategori başına
  birer; hiç tamamlanmamış → en uzun süredir gösterilmemiş) ve **gün içinde
  sabit**. Cihazda `discover.daily.<gün>` = `{version, level, prefsSnapshot,
  items:[{id, contentVersion, repeat}]}`, `discover.reel.<id>` =
  `{contentVersion, watchedSeconds, completed, lastShownDay, practiceResult?}`,
  `discover.prefs` = seviye + kategoriler (eşitlenmez). Aynı gün **kalınan yer**
  `discover.resume.<gün>` ile saklanır. `contentVersion` artınca
  eski izleme/soru sonucu taşınmaz; geri çekilen içeriğin yerine aynı seviye ve
  kategoriden yedek konur. Bu kayıtlar **öğrenme kanıtı değildir**.
- **P3 (kanıt + Defter bağı):** "Kaydet" yalnız ifadeyi ekler; izlemek, tekrar
  izlemek, anlam panelini açmak, seçenekten bulmak ve "Tam hikâye" **kanıt
  yazmaz**. Soru sonucu ayrıdır (`discover.reel.<id>.practiceResult`); Defter
  kartı (FSRS), `review_logs` ve kanıt değişmez. Taklit yalnız `helped`
  (H-093); `ownUse` yalnız Defter kartının denetlenmiş üretiminden gelir.
  Defter görseli/sesi `resolveMediaUri(contentId, …)` ile reel paketine
  çözülür.
- **P4 (backend):** `content_items` tablosunda `content_type = 'REEL'`; kimlik
  `<SEVİYE>-R-<KAT>-<NN>` (A1–C2, kategori CIN/SPO/BOK), `season` ve `genre`
  yok, `number` kimlikteki NN, `descriptor` zorunlu (kategori, başlık, hedef,
  süre, `related`). Paket yolu `_reels/<id>` (`VideoHostingPort`). İçe aktarma
  `reeller/<id>[-<slug>]/` altında önce `_build/package/reel.json`, yoksa kaynak
  `reel.json`'ı okur; `reel.json → status` yok sayılır (durum veritabanında).
  Onay kontrol listesinde **kanon maddesi istenmez** (reel bağımsız içeriktir);
  diğer dört madde ve temiz lint zorunludur. Açık uç `GET /api/v1/catalog/reels`
  (`?level=`, `?category=`) yalnız **yayımlanmış ya da zamanı gelmiş onaylı**
  sürümü döner; **geri çekilen içerik görünmez**. Testler:
  `backend/.../catalog/ReelCatalogTest.java` (7) + Python `write_reports` (2).
  **Uygulama bağlantısı (2026-10-21):** `ContentSource.listReels()` varsayılan olarak
  bu ucu okur; `family` alanı seçki için backend'den gelir; geri çekilen video
  uygulamada oynatılmaz, günlük seçki aynı kategoriden yedeklenir.
- **Maliyet (2026-10-19):** güncel fiyat tablosu `docs/REEL-MALIYET-2026-10-19.md`
  içindedir (`higgsfield generate cost` ile ölçüldü; geçmiş 0,5 kr / 5 kr güncel
  sayılmaz). Önerilen yol: 3 örnek ≈ **17 kr** (senaryo A) → onay → 18 video
  ≈ **55 kr** (senaryo A) ya da ≈ **266 kr** (2k high, senaryo B). Bakiye 298,06 kr.
- **3 örnek üretildi (2026-10-19):** A1 Sinema/Spor/Kitap için 13 görsel +
  2 hareket klibi = **16,50 kr** (bakiye 298,06 → **281,56** kr). Paketler
  `reeller/<id>/_build/package/` altında; kurgu ve krediler `reeller/PROMPTS.md`
  içinde.
- **18 video + ses tamam (2026-10-20/21):** 60 görsel + 3 klip = 45,00 kr
  (toplam **61,50 kr**; bakiye **236,56**). Ses ayrı ücretsiz ElevenLabs
  hesabında; konuşmacıya göre Sarah/Will/Chris. 18 paket sesli, süreler
  11,9–13,4 sn; `reel-lint` **18 · 0 hata · 0 uyarı**. Ayrıntı: §8,
  `docs/REEL-MALIYET-2026-10-19.md`.
- **Simülatör denemesi için yerel demo medyası:** `reeller/<id>/` altına
  ücretsiz, yerel üretilmiş yer tutucular (mp4, poster, `stills/`, `audio/`)
  konabilir; hepsi `.gitignore` dışındadır ve **onaylı üretimin yerine geçmez**
  (gerçek içerik üretimi ayrı bir teslimdir). Yer tutucular varken `reel-lint`
  medya uyarısı vermez; bu yüzden `tests/test_reels.py` medyanın varlığına
  değil "medya asla hata sayılmaz" kuralına bakar.

## 8. Üretim hattı (ücretsiz araçlar + ücretli üretim)

Kaynak dosyalar (`reel.json`, `shots.json`, `clips.json`) **depoda**; üretilen görsel/ses/video
git dışında (`reeller/**/_raw/`, `clips/`, `_build/`).

| Araç | İş | Ücret |
|---|---|---|
| `tools/content-pipeline/gen_reel_images.py` | `shots.json` → `_raw/kN.png` (Higgsfield `gpt_image_2_5`) | kare başına (2k low **0,50 kr**) |
| `tools/content-pipeline/gen_reel_clips.py` | `clips.json` → `clips/<ad>.mp4` (`seedance_2_0_mini`) | klip başına (720p 5 sn **5,00 kr**) |
| `tools/content-pipeline/tts_reel.py` | `reel.json` cue'ları → `_raw/tts/<cue>.mp3` (ElevenLabs; konuşmacıya göre Sarah/Will/Chris) | karakter (ortak aylık tavan) |
| `tools/content-pipeline/build_reel.py` | `shots.json → timeline` + kaynaklar → `_build/package/` | **0** (yerel ffmpeg) |
| `tools/content-pipeline/reel_lint.py` | paket denetimi; `--write-reports` → `_build/lint.json` | 0 |

**Kurallar**
- Ücretli araçlar **varsayılan olarak kuru çalışır** (`--dry-run`): karakter/kredi sayısı yazılır, çağrı
  yapılmaz; yalnız `--execute` ile harcar. Her çağrıdan önce `generate cost` teyit edilir.
- **İdempotent:** var olan kare/klip/ses yeniden üretilmez (`--force` ile); TTS metin sha'sıyla önbelleklenir.
- Kayıt: `_raw/jobs.json`, `_raw/clip-jobs.json`, `_raw/tts/timing.json` + `reeller/PROMPTS.md`
  (job kimliği, kredi, sha, tarih). İstem değişirse sha değişir, yeniden üretim ayrı görünür.
- TTS **ortak defter** kullanır: `kitaplar/_maliyet/elevenlabs-karakter.json` (aylık tavan
  `HIVELZON_TTS_MONTHLY_CHAR_CAP`; tavan yoksa üretim kapalıdır). **Ayrı hesap** kullanılırsa
  `HIVELZON_TTS_LEDGER` ile ayrı deftere yönlendirilir; ana defter okunmaz/yazılmaz
  (2026-10-20: `elevenlabs-karakter-alt.json`).
- **Ses sığması:** bir cue'nun sesi kendi çekim penceresine (`len − aoff`) sığmalıdır; sığmazsa kurgu
  sesi **keser** → `reel-lint` hatası `reel.audio.fit`. Çözüm: son kareyi uzatmak (metni kısaltmak değil).
- **Cue hizası:** çekim süresi değişince elle yazılan alt yazı zamanları kayar. `build_reel.py` cue
  `start/end` ve kelime aralıklarını **gerçek kurgudan** yeniden hesaplar (çekim başı + `aoff`, süre
  `timing.json`'dan; kelimeler yeni pencereye ölçeklenir) ve paket `reel.json`'a yazar. Kaynakta eski
  zaman → `reel.cue.window` **uyarısı**; kurulmuş pakette → **hata**.
- Süre de pakette güncellenir (`reel.json → duration`), böylece uygulamanın %90 tamamlanma eşiği
  videonun gerçek süresiyle uyuşur.
- **Ses yoksa:** paket **sessiz önizleme** olarak kurulur (`production.json → hasAudio:false`, boş AAC
  izi); `reel-lint` yalnız `reel.media` uyarısı verir (hata değil). TTS geldikten sonra
  `build_reel.py --force` yeterlidir; kaynak dosya değişmez.

**Paket (`_build/package/`)**
```
reel.json          # kaynağın kopyası + güncel duration ve yeniden hizalanmış cue'lar
<id>.mp4           # 720×1280, H.264 High + AAC, faststart (uygulamanın oynattığı sürüm)
<id>.webp          # afiş (ilk kare)
stills/<sahne>.webp# Defter kartı ve önizleme durağan görseli (hedef cue'nun karesi)
audio/<cue>.m4a    # hedef ifadenin sesi (TTS varsa); Defter'e bu gider
production.json    # üretim izi: job kimlikleri, kredi, sha, aiLabel, kurgu planı, cuesRetimed
```
`production.json` kullanıcıya gösterilmez; `reel.json` şemasını değiştirmez (içe aktarma bilinmeyen
dosyaları yok sayar). **Görüntüye yazı gömülmez** (alt Yazı uygulamada; AI notu `aiLabel` alanında —
klip paketleriyle aynı yaklaşım, H-040).

**3 örnek (2026-10-19/20, A1: CIN/SPO/BOK):** 13 görsel (6,50 kr) + 2 klip (10,00 kr) +
TTS 220 karakter (o gün ana defter 9.851/10.000) = **16,50 kr**; süreler **12,6 / 11,0 / 11,0 sn**
(ses sığsın diye CIN ve BOK'un son karesi uzatıldı). **18 video toplamı:** 61,50 kr; ses ayrı
ücretsiz hesapta (1.670 karakter / 72 çağrı), ana defter değişmedi. Ayrıntı ve job kimlikleri:
`reeller/PROMPTS.md`; fiyat tablosu: `docs/REEL-MALIYET-2026-10-19.md`.
