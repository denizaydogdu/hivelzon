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
paket klasörü tercih edilir, yoksa kaynak klasörden okunur. `/reels/index.json`
katalog listesi **çalışma anında taranır** (kitap ve ders listeleri gibi).

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
```

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
http://127.0.0.1:8787/reels/index.json          -> reel listesi (çalışma anında taranır)
http://127.0.0.1:8787/reels/<id>/<yol>          -> reel.json, <id>.mp4, stills/*.webp, audio/*.m4a
```

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
- **P4:** backend `ContentType.REEL`, onay/geri çekme ve yayın süzmesi; gerçek
  kullanıcı pilotunun ön koşulu.
- **Simülatör denemesi için yerel demo medyası:** `reeller/<id>/` altına
  ücretsiz, yerel üretilmiş yer tutucular (mp4, poster, `stills/`, `audio/`)
  konabilir; hepsi `.gitignore` dışındadır ve **onaylı üretimin yerine geçmez**
  (gerçek içerik üretimi ayrı bir teslimdir). Yer tutucular varken `reel-lint`
  medya uyarısı vermez; bu yüzden `tests/test_reels.py` medyanın varlığına
  değil "medya asla hata sayılmaz" kuralına bakar.
