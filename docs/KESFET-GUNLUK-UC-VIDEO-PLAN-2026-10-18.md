# Keşfet — Günlük üç kısa video: uygulama planı (H-094)

**Tarih:** 2026-10-18 (kullanıcı kararları işlendi) · **Durum:** Plan + kararlar — kodlama, ücretli üretim veya yayın onayı **değildir**.
**Kaynak brief:** `docs/KESFET-GUNLUK-UC-VIDEO-YAZILIMCIYA-NOT-2026-10-18.md` (kullanıcı, aynı gün).
**Bağlayıcı karar tabanı:** `CLAUDE.md` (K-15, K-24, K-25, K-30, K-32, H-024, §5.4 telif, §5.6 marka, §8 bütçe), `docs/ICERIK-MIMARISI.md`, `docs/OYUN-TASARIMI.md`, `docs/KELIME-TEKRARI.md`.
**Kapsam notu:** Bu belge yalnız **inceleme + plan + kullanıcı kararları**dır. Harcama, içerik onayı ve yayın ayrı adımlardır. Uygulama (kredisiz), gerçek içerik üretimi ve kullanıcı pilotu **üç ayrı teslim**tir (§11 sonu).

---

## 1. Doğrulanmış mevcut durum ve dosya etkisi

### 1.1 Keşfet bugün (H-040)

- **Kaynak tek yerden:** sezon paketindeki `clips.json` (`SeasonInfo.clipsPath`). Klipler bölüm kayıtlarından **ücretsiz** kesilir; sıra = dosya sırası; **kategori yok**.
- **Veri modeli** (`mobile/lib/features/discover/domain/clip.dart`): `FeedClip` — `id, episodeId (zorunlu), episodeNumber, episodeTitle, titleTr, video, poster, duration, target, subtitles, grammarId/grammarTitle, quiz, sourceStatus`. `ClipCatalog` şeması `schemaVersion: 1`.
- **Akış** (`domain/feed.dart`): `buildFeed` — `kQuizEvery = 4`, `kBreakEvery = 10`, sonunda `EndEntry` (**sonsuz kaydırma yok**). `DiscoverLimit` (13–17 ve 13 altı 20 dk), `localDayKey`.
- **Sağlayıcılar** (`application/discover_providers.dart`): `kDiscoverSeason = 1`; `clipCatalogProvider` → `clips.json`; `discoverClipsProvider` **yalnız açılmış bölümlerin** kliplerini tutar (`seasonMapProvider.unlockedIds`); `total`/`hasLocked` ile “daha var, hikâyede ilerle” bilgisi.
- **Denetleyici önbelleği** (`application/clip_controllers.dart`): `ClipControllerCache`, **sert üst sınır `maxLive = 3`** (atılmayı bekleyenler dahil); ekrandaki + sıradaki açılır.
- **Cihaz kaydı** (`data/discover_store.dart`): **yalnız günlük saniye** (`discover.watch.<yerel-gün>`), `app_meta`’da, eşitlenmez. Başka hiçbir şey saklanmaz.
- **Ekran** (`presentation/discover_screen.dart` 681 satır; `widgets/clip_page.dart` 815; `widgets/feed_cards.dart` 423): `DiscoverScreen → DiscoverFeedState` (PageController, saniye sayacı, sessiz, görünürlük/ön plan, sınır kapısı), tam ekran `ClipPage` (anahtarlar: `clip-page-<id>`, `clip-subtitle`, `clip-meaning`, `clip-save`, `clip-full-story`, `clip-grammar`, `clip-mute`, `clip-replay`, `clip-swipe-hint`).
- **Medya** (`shared/content/content_source.dart`): `seasonMediaUri(season, path)`; `resolveMediaUri` yolu öneke göre ayırır: `_books/…`, `_grammar/…`, `_season/S<n>/…`. Başka bir şey yok.
- **Defter** (`shared/meaning/notebook_repository.dart`): `SavedPhrase(contentId, sourceId, kind, en, tr, context, source, sourceTitle, imagePath, audio, contextAudio)`; **aynı ifade iki kez eklenmez** (`key`); `NotebookItem` FSRS kartı olur.
- **Kanıt basamakları** (`features/notebook/domain/evidence_ladder.dart`, H-089): `seen → helped → ownUse → recalledLater`; `helped` = tanıma/taklit pratiği; `ownUse` yalnız **denetlenmiş bağımsız üretim**; `recalledLater` uzun vade. `EvidenceRules.fromResult` bunu tek noktada kurar.
- **Testler:** `test/features/discover/discover_feed_test.dart` (502 satır), `test/support/discover_harness.dart`, `test/support/fake_content_source.dart`, `test/goldens/h040_discover_golden_test.dart`.
- **Metinler:** `mobile/lib/l10n/tr_strings.dart` (`DiscoverTexts`), `docs/ARAYUZ-METINLERI.md` §7.1.

### 1.2 Üretim hattı (H-024 standart yol)

- **Klipler:** `tools/content-pipeline/hvpipeline/clips.py` — `icerik/_evren/klipler/S<n>.json` okur, bölümün `_build/package/segments/*.720p.mp4` dosyalarından `media.cut_clip` ile keser, `parts_loudness` (her klip ayrı −16 LUFS), `frame_webp`; `clips.json` + `clips/` yazar.
- **Sezon paketi:** `hvpipeline/season.py` → `export_season(...)` = `/packages/_season/S<n>/` (jenerik, harita, konu setleri, `hi.json`, `talk.json`, `clips.json`). Tetikleyici: `export_package.py --season N`.
- **Sunum:** yerel `tools/dev-content-server/serve.py` → `/packages/`, `/books/`, `/grammar/`.
- **Görsel:** Higgsfield `gpt_image_2_5`, 9:16, quality low, referanslarla (geçmiş ölçüm: **0,5 kr/görsel** — üretimde yeniden ölçülecek).
- **Hareket:** varsayılan **yerel Ken Burns** (ffmpeg, 0 kr); kilit anlar için **Seedance 2.0 Mini** (geçmiş ölçüm: **5 kr / 5 sn** — yeniden ölçülecek).
- **İngilizce ses:** ElevenLabs, `eleven_v3`, zaman damgalı (`tts_episode_en.py`); ses havuzu `icerik/_evren/sesler.json` → `episodeEnglish.voices`.
- **Türkçe ses:** PatientDesk Alania + Duyu (`tts_episode_tr.py`; kampanya — **iş gününde teyit edilecek**).
- **Yazılar:** ImageMagick katmanı (görselin içinde yazı yok).
- **Bütçe:** aylık **300 USD** tavan (H-003), diğer AI işleriyle ortak. Her ücretli çağrıdan önce `higgsfield generate cost` + kullanıcı onayı; her prompt `PROMPTS.md`’ye.

### 1.3 Backend

- `ContentType` enum’ı yalnız **EPISODE** ve **BOOK** (`backend/.../catalog/ContentType.java`); kimlik kalıpları `^(A1|A2|B1|B2|C1)-[0-9]{3}$` ve `…-K[0-9]{2}$`; yol öneki `_books`.
- `CatalogImportService` klasör kalıpları (`EPISODE_DIR`, `BOOK_DIR`), `CatalogService` görünürlük süzmesi, `EditorialService` onay + kontrol listesi; şema V1–V14 (Flyway).

### 1.4 Yeniden kullanılacak / değişecek dosyalar

| Dosya / alan | Karar |
|---|---|
| `discover/domain/clip.dart` | `FeedClip` korunur (bölüm klibi = `sourceType: episode_clip`). Ortak arayüz (`FeedVideo`) eklenir; bağımsız reel için ayrı `Reel` sınıfı. `episodeId` **zorunlu olmaktan çıkar** (yoksa null). |
| `discover/domain/feed.dart` | `buildFeed` (havuz) korunur; **günlük set** için yeni `buildDailyFeed` (3 video + her videonun sonunda isteğe bağlı tek soru + bitiş; `quizEvery=4`’e güvenmez). |
| `discover/application/discover_providers.dart` | Seviye + ilgi süzmesi; `reelCatalogProvider` (yeni); bölüm kilitleri yalnız hikâye kliplerinde; günlük seçki sağlayıcısı. |
| `discover/application/clip_controllers.dart` | **Değişmez.** Yeni kaynak adresleriyle aynı sert sınır (3) korunur. |
| `discover/data/discover_store.dart` | Saniye sayacı **aynen kalır**; yanına günlük seçki ve reel izleme durumu **ayrı anahtarlarla** eklenir (karıştırılmaz). |
| `discover/presentation/discover_screen.dart` | Açılış başlığı + seviye çipi + kategori çipleri; günlük set / kategori havuzu ayrımı; medya ve anlam çözümlemesi reel kimliğine genişletilir. |
| `discover/presentation/widgets/clip_page.dart` | `VideoPage`’e genelleştirilir; “Tam hikâye” **yalnız gerçek ilgili bölüm varsa** görünür. |
| `shared/content/content_source.dart` | `listReels()`, `loadReel(id)`, `reelMediaUri(id, path)` eklenir; `resolveMediaUri` `_reels/…` önekini tanır. |
| `tools/content-pipeline/hvpipeline/clips.py` | **Değişmez** (mevcut kesme yolu korunur). Yanına bağımsız reel için yeni `reels.py` + `export_reel.py` + `reel_lint.py`. |
| `tools/content-pipeline/hvpipeline/season.py` / `export_package.py` | Sezon `clips` yolu korunur; reeller ayrı `/reels/` alanına yazılır (kitap/dilbilgisi gibi). |
| `tools/dev-content-server/serve.py` | `/reels/` kökü eklenir. |
| Backend `ContentType`, catalog, editor, içe aktarma, yayın süzmesi | Yeni `ContentType.REEL` + klasör kalıbı + onay/geri çekme. **Gerçek kullanıcı pilotunun ön koşulu** (P4); P0–P3 deneme verisiyle ilerler. |
| `mobile/lib/l10n/tr_strings.dart`, `docs/ARAYUZ-METINLERI.md` | Yeni metinler (seviye çipi/paneli, kategori adları, bitiş kartı, mini soru). |
| `docs/REEL-PAKETI.md` (yeni) | Reel biçimi + lint kuralları (`BOLUM-PAKETI.md`’ya paralel). |

---

## 2. Ürün kararları (sabitlenen)

1. **Kategori = konu:** Sinema, Spor, Kitap (genişleyebilir). “Kelime/dilbilgisi” bir **öğrenme hedefi**, A1/A2 bir **seviye filtresidir**; kategori listesine karışmaz (Macera/Kitaplık/Dilbilgisi kaynak türleri de ayrı kalır).
2. **Reels = izleme biçimi**, sosyal ağ değil. Sonsuz akış, beğeni/yorum yok. Üç video sonunda sakin bitiş.
3. **Hibrit kaynak:** bağımsız konu videoları + mevcut hikâye klipleri (hikâye klipleri **ayrı çip**, kendi kilitleri ve spoiler korumasıyla; bağımsız reel’de gereksiz bölüm kilidi yok). **Günlük seçki bağımsız konu videolarına odaklanır.**
4. **“Bugünün seçkisi”** (Bugüne özel değil): ortak onaylı havuzdan seçilir; gece silinmez, kaçırma baskısı/geri sayım yok; geçmiş ve kaydedilenlere erişim sürer.
5. **Plan ≠ ücretli üretim.** Bu belge plan; harcama ayrı onaylanır (§14.4).
6. **Önceki hatalar kapanmış varsayılmaz:** H-087/H-089 “bitti” olsa da **17 Ekim raporundaki** eksik olumsuzluk, yanlış mesaj kabulü ve yardımlı cevabın bağımsız sayılması örnekleri **yeni Keşfet yolunda yeniden test edilir** (§12.13). Keşfet pilotu, temel düzeltmeleri gölgelemez.

---

## 3. Örnek kullanıcı akışı

**Açılış (Keşfet sekmesi, yeni üst şerit):**
```
[Senin seviyen: A2 · Değiştir]   ← üstteki çip; panel: “Önerilen seviyem (A2)” + elle seçim + “Önerilen seviyeye dön”
                                   (yalnız Keşfet zorluğunu değiştirir; genel yerleştirme sonucunu değiştirmez)
Bugün senin için 3 kısa video
[ Bugün ] [ Sinema ] [ Spor ] [ Kitap ] [ Hikâye klipleri ]   ← yatay çipler
```
- **Bugün** (varsayılan açılış): dikey tam ekran 3 reel; başlıkta `kategori · seviye · kısa başlık · 1/3`.
- **Kategori çipi** (Sinema/Spor/Kitap): o kategori + kullanıcının seviyesindeki **havuz**; sıralı, sonunda bitiş kartı.
- **Hikâye klipleri:** mevcut `clips.json` akışı (quiz/mola kartları, spoiler kilidi korunur) — **ayrı kaynak**.
- **Kaydettiklerim / video koleksiyonu:** pilotta **yok** (§14.2).

**Tek video (tam ekran, 9:16):**
- Dokun → **duraklat** (mevcut davranış). Yukarı kaydır → sıradaki. Uçta bitiş.
- Video bitince **kendiliğinden sıradakine geçmez** (K-32): “Tekrar izle” + “Sonraki için yukarı kaydır.”
- Sağ/alt eylemler: **Tekrar izle · İngilizce altyazı · Türkçe anlam (isteğe bağlı) · İfadeyi dinle · Defter’e ekle · Hız.**
- **Her videonun sonunda isteğe bağlı, atlanabilir tek anlama sorusu** (pilot kararı, §14.8): yanlış cevap **ilerlemeyi engellemez**; üçlü sonunda **ikinci zorunlu sınav yok**.
- Kaydetme ayrımı: şimdilik **yalnız “İfadeyi Defter’e ekle”**; **“Videoyu kaydet” video koleksiyonu pilotta ertelendi** (ikisi karıştırılmaz).
- Altyazı/anlam paneli açılınca video durur, çalışma süresi sayacı tutarlı davranır; arka planda/görünmeyen sekmede ses durur.

**Bitiş kartı (3/3 sonrası) — sade metin:**
```
Bugünkü seçkini tamamladın.
[ Kaydettiğin ifadeleri çalış ]   [ Sinema havuzuna bak ]
```
- Videoların akşam kaybolacağını **ima etme**; süreli içerik algısı yaratma. “3 videoyu izledin ≠ 3 ifadeyi öğrendin” ayrımı **iç ölçüm kuralıdır**, kullanıcıya gösterilmez.
- Yeni videolar kendiliğinden sonsuza yüklenmez. Günlük süre sınırı (13–17, 13 altı) korunur; kategori/seviye değiştirmek veya tekrar izlemek sınırı **sıfırlamaz**.

---

## 4. Seçim kuralları (öneri motoru yok, kural tabanlı)

Günlük 3’lü, aşağıdaki **belirlenimli** sırayla seçilir:

1. **Aday havuzu:** yayına açık (`availability.status = published`, yetkili) ve yaş/konu bakımından uygun reeller.
2. **Seviye süzmesi:** kullanıcının seçtiği düzey (varsayılan yerleştirme önerisi; üstteki çipten değiştirilir). O düzeyde yeterli içerik yoksa **yanlış seviyeyi sessizce gösterme**: daha az video göster **ya da** kullanıcının **açıkça seçtiği, etiketlenmiş kolay pratik** sun. Örn. B2 kullanıcısına A1 video “seviyene uygun” diye sunulmaz.
3. **İlgi dağıtımı:** seçili kategoriler arasında birer (varsayılan sinema/spor/kitap). Kapatılan kategori zorla gösterilmez.
4. **Öncelik:** önce **hiç izlenmemiş**; sonra **en uzun süredir gösterilmemiş** uygun reeller.
5. **Kontrollü tekrar:** aynı hedef ifade yakın zamanda gösterilmediyse **farklı bağlamda** bir kez daha duyurulabilir.
6. **Yetersizlik:** uygun içerik yoksa 3’ten az video ya da açıkça etiketli tekrar; **asla farklı seviyeden doldurma**.

**Kişiselleştirme sınırı:** Defter’e kayıtlı sözcük ≠ bilinen sözcük. İlk sürümde kişiselleştirme yalnız **seviye + açık tercihler**; güvenilir hatırlama kanıtları sonraki adımda. İzleme süresini maksimize eden sıralama **yasak**.

---

## 5. Günlük seçkinin kararlılığı ve veri saklama

- **Kararlılık:** seçki **kimlik + içerik sürümü listesiyle** saklanır; her açılışta yeniden rastgele seçilmez. Aynı yerel gün içinde set ve kalınan yer korunur.
- **Yerel gün / gece yarısı:** gün dönünce **izlenmekte olan video kesilmez**; yeni seçki kullanıcı çıkınca/yeni oturumda sunulur. Saat dilimi ve saat değişimi test edilir.
- **Gün içi değişiklik:** kategori veya seviye değişirse **yeni seçim açıkça başlar**; **günlük süre ve öğrenme kayıtları silinmez** (sayaç kategori/seviye değişerek sıfırlanmaz).
- **Geri çekme:** içerik güvenlik/kalite nedeniyle geri çekildiyse sabit listeye rağmen erişim kesilir, aynı seviye/kategoriden yedek sunulur (ya da daha az video).
- **İçerik değişimi:** içerik `contentVersion` artarsa (düzeltilmiş görsel/ses/altyazı ya da değişen hedef) eski izleme/soru sonucu **yeni sürüme taşınmaz**; o reel yeniden “izlenmemiş” sayılır. Sabit seçkide oynatılırken **güncel sürüm** gösterilir; geri çekilen içerik sabit seçkide olsa bile **oynatılmaz**.
- **Saklama (en az veri):**
  - `discover.watch.<gün>` → **aynen kalır** (saniye).
  - `discover.daily.<gün>` → `{version, level, prefsSnapshot, items: [{id, contentVersion}]}` (yalnız cihaz, eşitlenmez; **içerik sürümü de saklanır**).
  - `discover.reel.<id>` → `{contentVersion, watchedSeconds, completed, lastShownDay, difficulty?, practiceResult?}`.
  - Tercihler (`discover.prefs`) → kategoriler + seviye geçersiz kılma (eşitlenmez; hesap eşitlemesi sonraki adım).
- **Tamamlanma:** videoyu açmak/ilk kareyi görmek **tamamlanma değildir**; aktif oynatma kapsamı + sona yaklaşma birlikte değerlendirilir. Aynı iki saniyeyi döndürmek tamamlanma sayılmaz. Bu bir **ürün ölçümüdür**, öğrenme başarısı değil.

---

## 6. İçerik/paket modeli (bağımsız reel) ve uyumluluk

### 6.1 Kimlik ve yol

- **Tür:** yeni bağımsız içerik türü. Öneri: kimlik **`<SEVİYE>-R-<KAT>-<NN>`** (ör. `A1-R-CIN-01`, `A2-R-SPO-03`). Böylece kategori ve seviye kimlikten okunur, mevcut içerik kimlikleriyle (A1-001, A1-K01) aynı “seviye başta” düzenine uyar. *(Brief’teki `R-A1-CIN-001` de olur; mevcut kalıplarla tutarlılık için seviyeyi başa almayı öneriyorum.)*
- **Aile kimliği:** `family` yalnız **aynı iletişim hedefini** farklı seviyede ya da bağlamda çalıştıran içerikleri bağlar. **Yalnız aynı kategoride olmak aile kurmaz** (bilet istemek ile film sonunu beğenmek ayrı hedeflerdir). Günlük seçki kimliği içerik kimliğinden **ayrıdır**; her gün yeni kimlikle aynı video çoğaltılmaz.
- **Paket yolu:** kitap/dilbilgisi gibi ayrı kök → **`/reels/`** (medya yolu öneki `_reels/<id>/…`).

### 6.2 Paket düzeni

```
/reels/index.json                katalog: özet liste (id, kategori, seviye, süre, durum, kapak, contentVersion)
/reels/<id>/reel.json            içerik: cues, target, quiz/practice, related, sürümler
/reels/<id>/<id>.mp4             720×1280 H.264/AAC faststart
/reels/<id>/<id>.webp            ilk kare
/reels/<id>/audio/<cue>.m4a      (varsa) kesilmiş ifade sesi
```

### 6.3 Alanlar

| Alan | Amaç |
|---|---|
| `id`, `contentVersion`, `schemaVersion` | Kalıcı içerik kimliği, içerik ve biçim sürümü |
| `sourceType` | `standalone` (reel) \| `episode_clip` (mevcut klip) |
| `sourceContentId`, `sourceCueId` | Defter/anlamın gerçek kaynağı (reel kimliği + cue) |
| `episodeId` | Yalnız hikâyeden türeyen içerikte; bağımsızda **yok** |
| `category`, `tags` | Sinema/Spor/Kitap + isteğe bağlı alt konu |
| `level`, `learningObjective`, `target` | Düzey, **tek** iletişim hedefi, hedef ifade (+TR) |
| `family` | Aynı iletişim hedefinin seviye/bağlam sürümlerini bağlar (yalnız gerçek eşleşme) |
| `video`, `poster`, `duration`, `cues` | Medya + zamanlı altyazı (İngilizce, kelime zamanları, TR anlam) |
| `practice` | İsteğe bağlı tek anlama sorusu (atlanabilir) ve **yardım** davranışı |
| `relatedContent` | Gerçekten varsa bölüm/kitap/dilbilgisi bağı (yoksa “Tam hikâye” gizli) |
| `availability`, `approval` | Yetkili editör akışı + yayın/geri çekme durumu |
| `productionManifest` | Senaryo, görsel, ses, model/ayar, maliyet izi (kullanıcıya gösterilmez) |

### 6.4 Katalog, onay ve eski klip uyumu

- **İki katman ayrı:** katalogdaki kısa `status` bilgisi **yayın yetkisi vermez**; yetkili durum backend’dedir (`EditorialService`).
- **Gerçek pilot ön koşulu:** kullanıcıya gerçek içerik sunulmadan önce **backend yayın ve geri çekme kontrolleri (P4) tamamlanmış** olmalı.
- **Eski istemci korunur:** `clips.json` `schemaVersion: 1` okunmaya devam eder; yeni `/reels/` kataloğu eskisini kırmaz. Katalog sürümü büyürse uygulama bilinmeyen sürümde **sessizce boş göstermez**, açık “güncelle” durumu verir.
- **Defter:** eklerken reel kimliği, cümle, TR anlam, görsel ve (varsa) kesilmiş ses taşınır; **aynı ifade tekrar eklenmez** (mevcut `key` davranışı korunur). Kaynağı yeniden açabilmek için reel kimliği/bağ kaybolmaz; birden çok kaynak gerekiyorsa mevcut “ilk kaynak” politikası bozulmaz.
- **Medya/anlam:** `resolveMediaUri` + anlam çözümlemesi `_reels/<id>/…` önekini ve reel `contentId`’sini tanıyacak şekilde genişletilir (doğrulama maddesi; anlam çözümlemesi bugün `contentId`’ye bağlı).

---

## 7. Video → anlam → pratik → tekrar bağlantısı

- Üç videoluk sette **`quizEvery = 4` çalışmaz**. Yerine: **her videonun sonunda isteğe bağlı, atlanabilir tek anlama sorusu** (pilot kararı). Yanlış cevap **videolar arası ilerlemeyi engellemez**; üçlü sonunda **ikinci zorunlu sınav yok**.
- **Puan yok.** “Kolaydı / Uygundu / Zorlandım” geri bildirimi isteğe bağlı; tek izleme/beyan **seviye değiştirmez**.
- **Kanıt (H-089 ile uyum):**
  - İzlemek, tekrar dinlemek, altyazıyı açmak, seçenekten doğruyu bulmak → **kanıt yazılmaz**.
  - Başarılı **taklit** (“Sen de söyle”, H-093’teki güvenilir denetim) → yalnız **`helped`**.
  - **`ownUse`** yalnız defter kartının **denetlenmiş bağımsız üretim** görevinden gelir (mevcut kelime tekrarı akışı).
  - **`recalledLater`** yalnız uzun vade kartında, H-089 kuralıyla.
  - Bağımsız pratik sonucu **ayrı** saklanır (`practiceResult`); FSRS’e yalnız mevcut hatırlama kurallarına uyan görev yazılır.
- **Önceki hata örnekleri bu yola taşınmaz** (§12.13): eksik olumsuzluk, yanlış mesaj kabulü, yardımlı cevabın bağımsız sayılması; hepsi regresyon testi olur.

---

## 8. Üretim hattı (önceden hazırlanır; kaydırırken üretim yok)

```text
Konu + seviye + tek öğrenme hedefi
→ İngilizce senaryo, Türkçe anlam, tek anlama sorusu
→ öğretim/doğallık kontrolü (A1: ≤8 kelime, CEFR-J A1 kapsama)
→ sahne planı (3–5 kare)
→ mevcut görseller / Higgsfield görsel üretimi
→ ElevenLabs İngilizce ses + zamanlar
→ yerel Ken Burns kurgu; gerekirse kısa gerçek hareketli parça
→ altyazı + hedef ifade + soru paketi
→ reel-lint + görsel/sesli önizleme
→ editör onayı
→ /reels/ kataloğunda yayın; günlük seçkiye uygunluk
```

- **Kaydetme:** hesap anahtarları mobil pakete girmez; uygulama yalnız onaylı paketi oynatır.
- **Hareket (pilot):** başlangıçta **zorunlu değil**; önce mevcut görseller + Ken Burns. Hareket öğrenme hedefini etkiliyorsa (örn. bazı spor sahneleri) **kısa gerçek hareketli parça** için **ayrı maliyet** sunulur; sabit görüntünün yeterli olup olmadığı önizlemede görülür. Yapay karakterlerin ağız hareketi zorunlu değil.
- **Idempotent:** önbellek anahtarı = metin + ses kimliği + model + hız/ayar (ses); prompt + referans + model/ayar (görsel); kurgu sürümü + kaynak özetleri (video). Biten iş **yeniden ücretlenmez**; sağlayıcı isteği sonuçsuzsa körlemesine yeniden denemek yerine iş kimliği sorgulanır; indirme geçici adrese bağlanmaz, çıktı kendi paketimize alınır.
- **Ses:** hız seviyeye göre ayarlanır (mevcut 0.9 her içerik için doğru sayılmaz). Türkçe **anlatım** zorunlu değil; TR anlam metni çoğu durumda yeterli; Türkçe ses gerekiyorsa **ayrı yardım eylemi**.
- **Çıktı:** 720×1280, H.264/AAC, faststart, −16 LUFS başlangıç. Altyazı videoya **gömülmez**, uygulamada etkileşimli; hedef vurgusu ayrı katman. Görselde modelin yazdığı bozuk tabelaya güvenilmez. İlk pilotta müzik gerekmez.
- **Telif/marka (§5.4, §5.6):** gerçek film/maç yayını/müzik/ünlü sesi yok; **özgün** sahneler ve kurmaca karakterler. Her içerikte üretim kaynağı ve onay bilgisi bulunur.

---

## 9. Pilot: 18 videoluk konu tablosu (A1/A2) — henüz üretim yok

Yapı: **3 kategori × 2 seviye × 3 video = 18**. Her satır tek küçük hedef; cümleler A1 için ≤8 kelime. Bunlar **yön örnekleri**dir; kesin senaryolar öğretim/doğallık kontrolünden geçer.

### Sinema (CIN)
| # | Seviye | Sahne (taslak) | Hedef ifade | Yardımcı sözcükler | Mini soru fikri |
|---|---|---|---|---|---|
| 1 | A1 | Gişede iki arkadaş | “Two tickets, please.” | ticket, two, please, here you are | “Kaç bilet isteniyor?” |
| 2 | A1 | Salonda yer arıyor | “Where is my seat?” | seat, row, screen, number | “Ne soruluyor?” |
| 3 | A1 | Atıştırmalık alıyor | “Popcorn, please.” | popcorn, water, small, big | “Ne isteniyor?” |
| 4 | A2 | Filmden sonra sohbet | “I liked the ending.” | ending, story, funny, boring | “Son nasıl bulundu?” |
| 5 | A2 | Tür seçimi | “I love adventure films.” | adventure, comedy, genre, prefer | “Hangi tür seviliyor?” |
| 6 | A2 | Akşam planı | “Let’s watch a film tonight.” | tonight, plan, together, free | “Plan ne?” |

### Spor (SPO)
| # | Seviye | Sahne (taslak) | Hedef ifade | Yardımcı sözcükler | Mini soru fikri |
|---|---|---|---|---|---|
| 7 | A1 | Sahada arkadaş | “Pass the ball, please.” | ball, pass, please, here | “Ne rica ediliyor?” |
| 8 | A1 | Antrenmanda komut | “Run to the goal!” | run, goal, fast, stop | “Nereye koşuluyor?” |
| 9 | A1 | Tribünde | “Great goal!” | great, goal, team, yes | “Ne oluyor?” |
| 10 | A2 | Maç sonrası | “We played well today.” | played, well, today, team | “Bugün nasıl oynandı?” |
| 11 | A2 | Antrenman günü | “I practice every Tuesday.” | practice, every, Tuesday, week | “Ne zaman çalışılıyor?” |
| 12 | A2 | Sonuç ve duygu | “We lost, but it was fun.” | lost, but, fun, again | “Sonuç nasıl?” |

### Kitap (BOK)
| # | Seviye | Sahne (taslak) | Hedef ifade | Yardımcı sözcükler | Mini soru fikri |
|---|---|---|---|---|---|
| 13 | A1 | Kütüphanede raf | “Where is this book?” | book, where, shelf, here | “Ne soruluyor?” |
| 14 | A1 | Beğeni | “I like this story.” | like, story, this, yes | “Hikâye nasıl bulundu?” |
| 15 | A1 | Sessizlik ricası | “Please be quiet.” | quiet, please, here, read | “Ne rica ediliyor?” |
| 16 | A2 | Konu anlatma | “This story is about a young sailor.” | story, about, young, sailor | “Kitap neyi anlatıyor?” |
| 17 | A2 | Öneri | “You should read this book.” | should, read, book, really | “Ne öneriliyor?” |
| 18 | A2 | Karakter | “The main character is very brave.” | main, character, brave, kind | “Karakter nasıl?” |

**Aile eşlemesi (yalnız aynı iletişim hedefi):** 1 (bilet isteme) ile **aynı işlevin A2 sürümü**; 7 (rica: topu at) ile **aynı işlevin A2 sürümü**; 13 (yer sorma) ile **yer sorma A2 sürümü**. 16 “konu anlatma”dır → 13 ile **aile değildir**; kendi A1 eşini bulur. **Bilet istemek ile film sonunu beğenmek aile değildir.** (Aile, aynı iletişim işlevini farklı seviye/bağlamda çalıştırır.)

---

## 10. Maliyet ve üretim sırası

> **Uyarı:** Aşağıdaki kredi değerleri **geçmiş ölçümdür**; güncel fiyat değildir. Üretimden **önce** `higgsfield generate cost` ile model/çözünürlük/süre bazında yeniden ölçülecek. Web, CLI ve API tarifeleri aynı varsayılmaz. Higgsfield kredisi, USD, TL ve ElevenLabs karakter kotası **ayrı sütunlarda** raporlanır.

### 10.1 Kalem kalem (video başına)

| Kalem | Varsayım (pilot) | Geçmiş ölçüm | Not |
|---|---|---|---|
| Görsel (Higgsfield `gpt_image_2_5`) | video başına **4 kare** | 0,5 kr/kare | = **2 kr/video** (yeniden ölçülecek) |
| Hareket (yerel Ken Burns) | **varsayılan** | **0 kr** | Sağlayıcı kredisi yok; işlem/depolama bedava sayılmaz |
| Hareket (Seedance 2.0 Mini, 5 sn) | **yalnız gerekli sahnelerde** | 5 kr/5 sn | Ayrı maliyet kalemi; pilotta zorunlu değil |
| İngilizce ses (ElevenLabs) | iç pilot | **karakter kotası** | “Sıfır” sayılmaz: hesap kotası, model tüketimi, yeniden denemeler ayrı yazılır |
| Türkçe ses (Alania + Duyu) | pilotta zorunlu değil | kampanya | İş gününde **teyit edilecek**; kalıcı varsayılmaz |
| Kurgu/paketleme (ffmpeg, ImageMagick) | yerel | 0 kr | İşlem süresi + depolama + dağıtım (Bunny) ayrı |

### 10.2 18 videoluk senaryo (varsayımlı aritmetik, güncel fiyat değil)

| | Hesap | Kredi |
|---|---|---|
| Görseller (yalnız sabit kare) | 18 × 4 × 0,5 kr | **36 kr** |
| + 3 hareketli kare (kategori başına 1) | 3 × 5 kr | **15 kr** |
| Ara toplam | | **51 kr** |
| Yeniden üretim/elenen kare payı (~%20–30) | 51 × 0,2…0,3 | **+10…15 kr** |
| **Pilot toplamı (tahmin)** | | **≈ 61–66 kr** |

- **Neden “2–13 kr” değil artık:** aralık, hareketli karenin eklenip eklenmemesinden geliyordu; yukarıda sabit kare (2 kr) ve hareketli kare (+5 kr) **ayrı** gösterildi.
- **Ölçek:** 3 günlük tekrarsız seçki (her seviyede 9 video) → 18 video. **Bir haftalık taze katalog** için `3 × 7 × 2 = 42` video. A1+A2 için her gün üçer yeni video ≈ **ayda 180 video** → **ilk günden taahhüt edilmez.**
- **Onay durumu (2026-10-18):** ücretli üretim bütçesi **onaylanmadı**. Üretime geçmeden önce **güncel fiyatla 3 örnek video** ve **18 videoluk toplam** için **ayrı** maliyet sunulur; harcama sonra değerlendirilir. Mevcut 300 USD/ay tavanı diğer AI işleriyle **ortak**tur.

### 10.3 Üretim sırası

1. **Üretim öncesi (kredisiz):** uygulama P0–P3 deneme verisiyle çalışır; **güncel fiyatla 3 örnek** ve **18 toplam** için ayrı maliyet çıkarılır.
2. **Bütçe onayı ayrı:** onay gelince **kategori başına 1 örnek** (3 video) üretilir, kalite önizlemesi kullanıcıya sunulur.
3. Kalan 15 video, onaylı alt bütçe içinde tamamlanır.
4. Yeniden üretim payı görünür tutulur; biten iş yeniden ücretlenmez.
5. **Ödeme/telif:** yalnız özgün sahneler; `PROMPTS.md`’ye her prompt; `H-024` onay akışı.

---

## 11. Uygulama aşamaları

- **P0 — Veri ve paket (kredisiz):** `Reel`/`ReelCatalog` domain; `content_source` reel yolları; `/reels/` örneği (elle yazılmış 1–2 deneme reel); `reel_lint` iskeleti; mevcut Keşfet testleri geçer.
- **P1 — Günlük set UI (kredisiz, deneme verisiyle):** çipler (Bugün/Sinema/Spor/Kitap/Hikâye klipleri), seviye çipi + paneli, `VideoPage` genelleştirmesi (“Tam hikâye” koşullu), bitiş kartı, **her videonun sonunda atlanabilir tek soru**; denetleyici sınırı 3 korunur.
- **P2 — Seçim kuralları + saklama:** `buildDailyFeed`, günlük seçki sağlayıcısı, `discover.daily.*` (`{id, contentVersion}`) / `discover.reel.*` / `discover.prefs`; gün dönümü, kategori/seviye değişimi, içerik sürümü değişimi, geri çekme.
- **P3 — Kanıt ve Defter bağı:** kaydetme ayrımı (yalnız ifade), `helped` (taklit) kuralı, FSRS’e yazılmama; kaydın doğru reel sesi/görseli/kaynağıyla geri açılması; **önceki hata regresyon testleri**.
- **P4 — Backend/editoryel (gerçek pilotun ön koşulu):** `ContentType.REEL`, klasör kalıbı, onay/geri çekme, yayın süzmesi; dev sunucu `/reels/`. **Kullanıcıya gerçek içerik sunulmadan önce bu kontroller tamamlanmış olmalı**; P0–P3 deneme verisiyle ilerler.

**Durum (2026-10-19):** P0–P4 tamamlandı (kredisiz). Ayrıntılar `docs/REEL-PAKETI.md` §7 ve `yapilacaklar/H-094-kesfet-gunluk-uc-video.md`; P4 backend uçları `/api/v1/catalog/reels`.

**Durum (2026-10-21):** Pilot içeriği de tamam. 18 reel (3 kategori × 2 seviye) üretildi ve seslendirildi (kadın/erkek karakter sesleri ayrı: Sarah/Will/Chris); `reel-lint` 18 · 0 hata · 0 uyarı. Backend'de 18/18 yayınlandı; **geri çekme uçtan uca** doğrulandı: uygulama artık `GET /api/v1/catalog/reels` okur, geri çekilen video oynatılmaz ve günlük seçki aynı seviye-kategoriden yedeklenir. Kalan: **H-092 kullanıcı pilotu** + insan değerlendirmesi. Ayrıntı: `docs/H-094-P4-PROVA-2026-10-21.md`.

Her aşama **kendi dalında**, `flutter analyze && flutter test` + `pytest` yeşil; golden’lar bilinçli güncellenir.

**Ayrı teslimler:** (1) **kredisiz uygulama** (P0–P3 + deneme verisi), (2) **gerçek içerik üretimi** (3 örnek → 18 video; bütçe onayı ayrı), (3) **kullanıcı pilotu** (H-092’ye ekleme; P4 ön koşulu). Her biri ayrı onay/bitiş kapısıdır.

---

## 12. Kabul testleri (brief ile eşleşme)

| # | Kabul senaryosu | Tür |
|---|---|---|
| 1 | A1 ve A2 kullanıcı kendi seviyesinde farklı seçkiler görür; kategori karışımı doğru | widget + birim |
| 2 | Seviyede içerik yokken daha kolay video **yanlış etiketle** önerilmez; kolay pratik yalnız açık seçimle | birim |
| 3 | Aynı gün yeniden açılışta set/ilerleme korunur; gece yarısı aktif video kesilmez | widget |
| 4 | Hikâye klibinde spoiler kilidi korunur; bağımsız reel’de gereksiz bölüm kilidi yok | widget |
| 5 | Her videonun sonunda mini soru erişilebilir/atlanabilir; yanlış cevap ilerlemeyi engellemez; eski `quizEvery=4`’e takılmaz; üçlü sonunda ikinci zorunlu sınav yok | widget |
| 6 | Defter’e kaydedilen ifade yeniden açılışta doğru reel sesi/görseli/kaynağıyla çalışır; yinelenmez | widget + Drift |
| 7 | Yardımlı cevap/izleme/yanlış anlamlı cevap `own_use`/`recalled_later` **yazmaz** | birim |
| 8 | Panel, sekme değişimi, arka planda oynatma ve süre sayaçları doğru durur | widget |
| 9 | Üretimi yeniden çalıştırmak aynı işi yeniden ücretlendirmez; bütçe onayı yoksa ücretli çağrı başlamaz | pytest |
| 10 | Taslak/geri çekilen içerik katalogda görünmez; geri çekme sabit günlük listeyi de geçersiz kılar | pytest + widget |
| 11 | Denetleyici sayısı ≤ 3 (atılmayı bekleyenler dahil) | birim (mevcut ölçüm testi) |
| 12 | Gerçek Android + iPhone: bellek, ilk kareye süre, ses-altyazı uyumu, büyük yazı, dokunma alanları | elle (H-043 ile) |
| 13 | **Önceki hata regresyonları (17 Ekim raporu):** eksik olumsuzluk, yanlış mesaj kabulü, yardımlı cevabın bağımsız sayılması örnekleri yeni Keşfet yolunda da **geçmez** | birim + widget |
| 14 | Günlük seçki `{id, contentVersion}` ile saklanır; içerik sürümü artınca eski izlenme/soru sonucu yeni sürüme taşınmaz | birim |
| 15 | Geri çekilen içerik sabit seçkide olsa bile oynatılmaz | widget |
| 16 | Seviye çipi yalnız Keşfet zorluğunu değiştirir; genel yerleştirme sonucu değişmez; “Önerilen seviyeye dön” çalışır | widget |
| 17 | Gerçek kullanıcı pilotundan önce backend yayın/geri çekme kontrolleri tamam (P4 kapısı) | pytest + elle |

---

## 13. H-092 pilotuna eklenme

- Bu iş **ayrı** ilerler (H-094); küçük Keşfet pilotu, **kabul testleri yeşil olduktan sonra** H-092 kullanıcı pilotuna **kontrollü deney** olarak eklenir (A/B değil; gözlem + nitel geri bildirim).
- **Ön koşul:** gerçek kullanıcıya içerik sunulmadan önce **P4 (backend yayın/geri çekme)** tamamlanmış olur.
- Ölçülecekler (H-092 ölçümlerine ek): günlük seti açma, ilk videoyu bitirme, ifadeyi kaydetme, ertesi gün geri dönme; “zorluk” geri bildirimi.
- Veri minimizasyonu korunur: içerik metni/ham ses/transkript yok; olay türü, süre, yardım, sonuç.
- Sonuç görülmeden **geniş katalog üretimine geçilmez**.

---

## 14. Kullanıcı kararları (2026-10-18)

1. **Çip seti:** “Hikâye klipleri” **ayrı çip** kalır (kendi kilitleriyle erişilir). Günlük seçki bağımsız konu videolarına odaklanır.
2. **Video koleksiyonu:** pilotta **ertelendi**; önce yalnız “İfadeyi Defter’e ekle” eksiksiz çalışır. Video kaydetme ile ifade kaydetme **karışmaz**.
3. **Hareket:** başlangıçta **zorunlu değil**; önce mevcut görseller + Ken Burns. Hareketin gerekli olduğu sahne için (örn. spor) **ayrı maliyet** sunulur.
4. **Bütçe:** ücretli üretim **onaylanmadı**. Kredisiz uygulama + deneme verisi kapsamı netleşir; üretim öncesi **3 örnek** ve **18 toplam** için güncel fiyatla **ayrı** maliyet çıkarılır.
5. **Seviye değişimi:** üstteki çipten; panelde “Önerilen seviyem” + elle seçim + **“Önerilen seviyeye dön”**. Yalnız Keşfet zorluğunu değiştirir, genel seviye testi sonucunu **değiştirmez**.
6. **Saklama:** günlük seçki ilk sürümde **cihazda**; hesap eşitlemesi sonra. Aynı gün seçki ve kalınan yer korunur; kategori/seviye değiştirmek **günlük süre sayacını sıfırlamaz**.
7. **Kapsam:** ilk içerik pilotu **A1/A2**; B1+ mimaride hazır ama uygun içerik yokken A1 video “seviyene uygun” diye sunulmaz; kullanıcı isterse **açıkça etiketli kolay pratik** seçebilir.
8. **Mini soru:** **her videonun sonunda atlanabilir tek anlama sorusu**; yanlış cevap ilerlemeyi engellemez; üçlü sonunda ikinci zorunlu sınav yok.

---

## 15. Etkilenecek dosyalar (özet)

**Mobil:** `discover/domain/clip.dart`, `discover/domain/feed.dart` (yeni reel + `buildDailyFeed`), `discover/application/discover_providers.dart`, `discover/data/discover_store.dart`, `discover/presentation/discover_screen.dart`, `discover/presentation/widgets/clip_page.dart`, `shared/content/content_source.dart`, `l10n/tr_strings.dart`; **değişmez:** `discover/application/clip_controllers.dart`.
**Üretim hattı:** yeni `hvpipeline/reels.py`, `export_reel.py`, `reel_lint.py`; `dev-content-server/serve.py` (`/reels/`); mevcut `clips.py`/`season.py` **korunur**.
**Backend (P4):** `catalog/ContentType.java`, `CatalogImportService`, `CatalogService`, `EditorialService`, Flyway (yeni sürüm), `/api/v1/catalog/reels`.
**Belgeler:** `docs/ARAYUZ-METINLERI.md` (yeni metinler), yeni **`docs/REEL-PAKETI.md`** (biçim + lint), `PROMPTS.md` (üretimde).
**İş takibi:** `yapilacaklar/H-094-kesfet-gunluk-uc-video.md`, `yapilacaklar/IS-SIRASI.md`.

---

## Ek — Üretim kalemlerinin sütunlu maliyet tablosu (üretim anında doldurulacak)

| Kalem | Model/ayar | Adet | Kredi | USD | TL | Karakter/kota |
|---|---|---|---|---|---|---|
| Görsel | gpt_image_2_5, 9:16, low | ~72 | — | — | — | — |
| Hareketli kare | Seedance 2.0 Mini, 5 sn | 0–3 | — | — | — | — |
| İngilizce ses | eleven_v3, hız seviyeye göre | 18 | — | — | — | — |
| Türkçe ses | Alania + Duyu (gerekirse) | 0 | — | — | — | — |
| Yeniden üretim payı | ~%20–30 | — | — | — | — | — |
| **Toplam** | | | — | — | — | — |

*(Boş hücreler üretim gününde `higgsfield generate cost` ve ElevenLabs kotası ile doldurulur; **3 örnek** ve **18 toplam** ayrı satır olarak sunulur. Geçmiş 0,5 kr ve 5 kr değerleri bu tabloda varsayılan olarak kullanılmaz.)*
