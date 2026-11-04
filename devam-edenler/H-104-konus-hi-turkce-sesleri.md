# H-104: Konuş görevlerinde Hi'nin Türkçe yönlendirmelerini seslendirme

- **Durum:** Devam ediyor — sesler üretildi, kod ve testler yeşil (2026-11-03), commit `d2d81c0` (CI `41690063999` yeşil); kullanıcının dinlemesi ve editör kontrolü bekliyor
- **Tür:** İçerik hattı (Alania TTS) + mobil arayüz
- **Öncelik:** Orta
- **Bağımlılık:** H-083 ("Türkçe konuşan her yer Alania"), H-090 (Konuş), H-055, H-075…H-082 (Alania kampanyası 14 Kasım 2026'ya kadar ücretsiz)
- **Kullanıcı onayı:** 2026-11-03

## Kapsam

Konuş görevlerinde (`icerik/_evren/konusma/*.json`, 6 görev) Hi'nin **Türkçe** metinleri PatientDesk Alania
ile seslendirilir (rol `hi`, ses `alania2-f1`):

| Alan | Yer | Ses adı |
|---|---|---|
| `introTr` | sahne girişi | `konusma-<görev>-intro` |
| `taskTr` | mesaj görevi | `konusma-<görev>-task` |
| `turns[].promptTr` | tur görevi ("SIRA SENDE") | `konusma-<görev>-<tur>-prompt` |
| `turns[].distractors[].reactionTr` | yakın seçeneğe kibar tepki | `konusma-<görev>-<tur>-d<n>` |
| `check.hintTr` | mesaj ipucu | `konusma-<görev>-hint` |

- Kaynakta söylenen metin `<alan>SpeechTr` (yalnız gerekiyorsa; ör. hi-intro "1–2" → "bir iki"), ses başvurusu
  `<alan>Audio` = `hi-ses/konusma-….mp3`, görev düzeyinde söyleniş sözlüğü `pronunciations`.
- **ElevenLabs yok:** Konuş seslerinde kip b hiç seçilmez. İngilizce ifade ya da Türkçe ek alan özel ad
  ("Hilltop Café'desin", "Tide & Pages'te") varsa **kip a** (tümü Alania + söyleniş sözlüğü), yoksa düz Türkçe.
- **Kapsam dışı:** karakter replikleri (`line`, `outro`; bölüm kaydı ya da cihaz sesi), kullanıcının İngilizce
  cevapları (`accept`), örnek mesaj (`model`), öz değerlendirme maddeleri (`selfCheckTr`, yalnız hi-intro;
  "My name is…" gibi üç noktalı kalıplar) ve uygulamanın sabit metinleri (`TalkTexts`).

## Yapılanlar

- `hvpipeline/tts_episode_tr.py`: `collect_talk` / `collect_talk_task`, `talk_spots`, `talk_keys`; kaynak
  güncelleme el biçimini korur (`insert_key`); denetim "ses var ama kaynakta `<alan>Audio` yok" uyarısı.
  CLI: `tts_episode_tr.py --talk`.
- `hvpipeline/talk.py`: denetim (ses haritası varsa) — başvuru beklenen adda olmalı, hizalaması bulunmalı
  (hata); mp3 git dışı medya, yoksa uyarı. Dışa aktarma: `talk/konusma-….m4a` (-16 LUFS), `SpeechTr` ve
  `pronunciations` pakete girmez; özet `hiAudio` / `hiAudioMissing`. Şema `talk-task.schema.json` genişletildi.
- `export_package.py --season 1` çıktısına Konuş satırı; `content_lint.py` görev satırında "Hi'nin Türkçe sesi n/m".
- Mobil: `TalkTask.introAudio/taskAudio`, `TalkTurn.promptAudio`, `TalkDistractor.reactionAudio`,
  `MessageCheck.hintAudio`; `TalkHiText` (metin + sade "dinle" düğmesi) ve `HiListenButton(label, filled)`.
  Otomatik oynatma yok; ses yoksa düğme yok; yükleme/hata sessiz (çalar kendiliğinden durur).
  Ekran okuyucu: **"Görevi Hi'den dinle"** / **"İpucunu Hi'den dinle"**, çalarken "Durdur".
- Fixture `mobile/test/fixtures/talk.json` dışa aktarımdan yenilendi; h090 golden'ları güncellendi.

## Üretim

- 2026-11-03: **32 ses, 1.950 karakter**, 32 Alania + 32 Duyu çağrısı (142,9 sn). Maliyet **0 TL**
  (kampanya; tarife ≈ 1,69 TL). Defter `kitaplar/_maliyet/patientdesk-karakter.json` (2026-11), kayıt
  `icerik/_evren/hi-ses/PROMPTS.md`. ElevenLabs 0 karakter.
- Ses düzeyi -16,4…-17,0 LUFS (mp3), pakette -16,0; en kısa ses 1,12 sn; boş/sıfır süreli dosya yok.
- `--strict` hizalama uyarıları (İngilizce kelimeler Türkçe söylenişle okunduğu için beklenen): ask-the-way
  t1-d1 (%46), t3-d1 (%75), cafe-rosa t2-d1 (%56), meet-note hint (%80), cafe-rosa intro (Duyu sonda
  sessizlikte olmayan cümle "duydu").
- **Kulakla dinlenmesi gerekenler** (Duyu dökümüne göre şüpheli söyleniş): ask-the-way t1-d1 "where is the bus
  stop" ("Veriz de bastildi"), ask-the-way t4-d1 "Sorry" ("Soru" gibi), maya-neighbour t2-d1 "Are you…?"
  ("arıyor"), meet-note hint "Pier 3" ("pirtiri"), maya-neighbour t3-d1 "-im" ("yemek"), late-maya task
  "Tide & Pages'te". Düzeltme: görevin `pronunciations` ya da `<alan>SpeechTr` alanı değiştirilip yeniden
  `--talk --execute` (yalnız değişen ses yeniden üretilir).

- **2026-11-03 söyleniş düzeltmeleri** (kullanıcı onayı; 8 ses yeniden, 695 karakter, 0 TL; Duyu önce → sonra):
  ask-the-way "where is the bus stop" ver iz→**vır iz dı bas stap** (%46 → %62; "Veriz de bastildi" → "vrizdı bastırdı";
  "Excuse me" artık tam eşleşiyor; kısmen düzeldi, kulak kararı) · "Sorry" Sori→**Sorri** ("Soru" → "Sori", düzeldi;
  late-maya'da da) · maya-neighbour "Are you" Ar yu→**Aar yuu** ("arıyor" → tam eşleşme, düzeldi) · "-im" için sözlüğe
  `-im`→`im` ("yemek" → "imek", kısmen) · meet-note "Pier 3" Pir tri→**Piır tırii** (Duyu "Peartree" yazıyor: İngilizce
  söylenişe yakın, büyük olasılıkla düzeldi) · late-maya "Tide & Pages'te" Peycız→**Peyciz** ("Teycis'te" → tam eşleşme).

## Kabul kriterleri

- [x] 6 görevin Hi Türkçe metinleri (32 yer) Alania ile seslendirildi; ElevenLabs çağrılmadı.
- [x] Kaynakta `…Audio` başvuruları; content-lint başvuru/hizalama denetliyor (0 hata).
- [x] Sezon paketinde `talk/konusma-*.m4a` (32, eksik 0).
- [x] Uygulamada ses varsa dinle düğmesi, yoksa yok; otomatik oynatma yok; 320×568 1,3× taşma yok; dokunma ≥ 44.
- [ ] Kullanıcı sesleri dinler (yukarıdaki şüpheli satırlar).
- [ ] Editör kontrolü (görevler DRAFT, H-028).

## Test komutları

```bash
P=tools/content-pipeline/.venv/bin/python
$P -m pytest tools/content-pipeline                     # 401
$P tools/content-pipeline/tts_episode_tr.py --talk      # kuru çalışma (32 güncel)
$P tools/content-pipeline/content_lint.py icerik/A1-0* --graph-source kurgu --no-clips
$P tools/content-pipeline/export_package.py --season 1
cd mobile && flutter analyze && flutter test            # 1512
```

## Geri alma

Kaynak JSON'lardan `…Audio`, `taskSpeechTr` ve `pronunciations` alanları silinirse uygulama düğmeyi göstermez
(paketten ses alanı düşer); `icerik/_evren/hi-ses/konusma-*` dosyaları silinebilir. Kod geri alınırsa eski
paket biçimi aynen çalışır (yeni alanlar isteğe bağlı).
