# Dilbilgisi: Hi'den Türkçe konu anlatımı (H-075…H-082)

> Durum: **uygulamada** (2026-10-30): A1–C2 toplam 71 ders yazıldı, Türkçe sesleri hazır ve `grammar_lint` 0 hata. A1 İngilizce örnekleri tam; A2 kısmen, B1–C2 bekliyor. Kalan: öğretmen/editör incelemesi ile çalışan ElevenLabs erişimi veya ayrı onaylı ücretli plan. **2026-10-30:** Yeni ücretsiz anahtarın abonelik sorgusu 10.000 kredi gösterse de üç üretim denemesi `401 detected_unusual_activity` verdi; ses/kredi üretilmedi. Kalan İngilizce örnekler ≈21.544 karakter. İşler §8'de; ders paketi ve araçlar §9'da.

## 1. Neden
Kullanıcının gözlemi: "Türk öğrenciler bazen konuları anlamıyor."

Hikâye, kitap ve kelime tekrarı dili bağlam içinde öğretiyor. Ama bir yapının **nasıl işlediğini** Türkçe ve Türkçeyle karşılaştırarak anlatan bir yer yok. Türk öğrencinin zorlandığı yapıların çoğunun Türkçede karşılığı yok ya da farklı işliyor:
- *the / a*;
- üçüncü tekil *-s*;
- *present perfect*;
- kelime sırası (Türkçe özne-nesne-yüklem, İngilizce özne-yüklem-nesne);
- edat ile Türkçe hâl ekleri;
- *I am agree* tipi hatalar.

Bu iş, ürünün ilk ayağının ("hazır ders videoları, sabit yapay zekâ öğretmen") hikâyeye bağlı karşılığıdır. "Öğretmenin köşesi" kısa serisi (`ICERIK-MIMARISI.md` §4.3) de buraya oturur. H-047'deki farklılık önceliğine de uyar: "Türkçeye göre koçluk".

## 2. Kullanıcı kararları (2026-10-14)
| Konu | Karar |
|---|---|
| Anlatıcı | **Hi.** K-23 ile uyumlu: Hi dile Türkçe yardım eder, gizemi çözmez. Türkçe anlatım PatientDesk **Alania** sesiyle (`alania2-f1`) yapılır. İngilizce örnekleri kitaplardaki gibi **Sarah** (ElevenLabs) okur. |
| Biçim | **Canlı ders kartları:** uygulama içinde adım adım kartlar. Türkçe anlatımda okunan yer vurgulanır; İngilizce örnekler, kodla çizilen şemalar ve alıştırma var. Video değil. İstenirse sonra sosyal medya için videoya çevrilir. |
| Yer | **Hikâye sekmesinde üçüncü bölüm:** "Macera · Kitaplık · Dilbilgisi". Ayrıca bağlamdan da açılır: anlam panelinde "Bu yapı ne?", Hi'nin hata notu, bölüm ya da kitap sonu. Sekme sayısı değişmez (K-30). |
| Kapsam | **Pilot 3 A1 konusu, sonra dalgalar.** Önce müfredat listesi (~70 konu) onaylanır, sonra 3 A1 konusu uçtan uca hazırlanır. A1–A2 Türkçe sesleri ücretsiz ayda üretilir. Ardından B1–B2 ve C1–C2. |
| Hikâyeden önce | **Bölüm panelinde ikincil düğme** (kullanıcı kararı 2026-10-14). Haritada bölüme dokununca açılan panelde "Başla"nın yanında "Bu bölümdeki dilbilgisi (~2 dk)" düğmesi ve o bölümde geçen konuların adları bulunur. Kitapta aynı teklif kitap açma ekranında yer alır. Kullanıcı kabul ederse o hikâyede geçen konular sırayla anlatılır, sonra hikâye başlar. Kabul etmezse hiçbir şey görmez. H-050 bozulmaz: bölüm yine doğrudan başlıkla açılır. Ayrı Dilbilgisi alanı da vardır. |
| Türkçe ses | PatientDesk Alania: **lansman kampanyasıyla 14 Kasım 2026'ya kadar ücretsiz ve sınırsız** (kullanıcı bildirimi 2026-10-14); bu yüzden 70 konunun Türkçe sesleri bu tarihten önce üretilir. Önceki bilgi: ilk ay ücretsiz, sonra 1.000 karakter 0,75 TL. Kelime zamanlaması **Duyu** ile çıkarılır; 2026-10-14'te denendi ve kelime kelime doğru çıktı. Anahtar sunucu ayarında (`hivelzon.tts.patientdesk`), değer repo dışında. Yalnız Türkçe cümleler için kullanılır. || Her yer Alania (H-083) | "Uygulamadaki Türkçe konuşan her yer Alania ile" (kullanıcı kararı 2026-10-14): bölümlerdeki Hi replikleri, Alex'in Türkçe cümleleri, babaannenin notu, ipucu panosu ve açık soru kartları, Hi panelinin metinleri (hata notu, konu tanıtımı, köprü görevi). Ses eşlemesi §2.1. |

### 2.1 Karakter–ses eşlemesi (H-083)

Kaynak: `icerik/_evren/sesler.json` (sabit; değişirse o rolün bütün sesleri yeniden üretilir). Sesler PatientDesk `/v1/voices` listesinden seçildi (2026-10-14; Alania v2, 48 kHz): kadın `alania2-f1`, `-nisa`, `-selin`, `-lina`, `-melisa`, `-nil`; erkek `alania2-m1`, `-oncel`, `-emre`, `-fikri`, `-sezgin`. Ses yaşı ve tınısı API'de yazmıyor; seçim perde aralığına (f0) ve deneme kayıtlarına göre yapıldı. Deneme kayıtları (8 aday × 3 cümle): `.yerel/h083/ses-secimi/<ses>/` (git dışı).

| Rol | Ses | Neden |
|---|---|---|
| Hi | `alania2-f1` | Dilbilgisi anlatıcısıyla aynı; Hi her yerde tek sesle konuşur. |
| Alex (19, genç kadın) | `alania2-nisa` | Kadın sesleri içinde en yüksek perde (≈ 218–280 Hz); Hi'den ayırt edilir. |
| Babaanne Nermin (not) | `alania2-selin` + `instructions` (yavaş, sıcak, şefkatli) | Kadın sesleri içinde en pes perde (≈ 180–213 Hz): olgun ve sıcak. |
| Anlatıcı (ipucu panosu, açık soru) | `alania2-m1` + `instructions` (sakin, tarafsız) | Üç kadın karakterden ayrılan sakin erkek sesi. |
| İngilizce ifadeler (karışık satırda) | ElevenLabs Sarah `EXAVITQu4vr4xnSDxMaL` (`eleven_v3`, hız 0,9) | Kitap ve derslerdeki İngilizce ses. Yalnız kısa ifadeler. |

**Karışık dil satırları** (Türkçe + İngilizce ifade; ör. "Böyle de söyleyebilirsin: Excuse me, where is the old station?"):
- **b (varsayılan, gönderilen):** Türkçe parçalar Alania, İngilizce ifade Sarah; kırpılır, ses düzeyi eşitlenir, 0,15 sn boşlukla birleştirilir, tek hizalama.
- **a:** Tümü Alania, İngilizce kelimeler söyleniş sözlüğüyle (`sesler.json` → `pronunciations`). Yalnız Türkçe ek alan özel adda kullanılır (A1-004 `c-oq`: "Pier 3'te" → "Pir 3'te").
- Karşılaştırma örnekleri (2 satır, a ve b): `.yerel/h083/b2_17_hi-*.mp3`, `.yerel/h083/b4_21_hi-*.mp3`. Kullanıcı seçimi bekliyor (H-083).

## 3. Müfredat (H-076'da kesinleşir)
- **Dağılım:** Yaklaşık 70 konu: A1 15, A2 15, B1 14, B2 12, C1 8, C2 6.
- **Kaynaklar:**
  - Sıra CEFR-J Grammar Profile **referans** alınarak kurulur. Ham veri uygulamaya ve isteme gömülmez (`LISANS-RAPORU.md`).
  - Cambridge EGP/EVP, Oxford, GSE kullanılmaz.
  - Konu adları ve hedefler kendi cümlemizle yazılır.
- **Her konunun içeriği:**
  - Kimlik `G-<SEVİYE>-<2 hane>-<kisa-ad>` (ör. `G-A1-03-third-person-s`).
  - Türkçe ad ve tek cümlelik hedef.
  - Önkoşul konular.
  - **Türkçeyle karşılaştırma notu** ve tipik Türk öğrenci hatası.
  - Hikâye bağı: o yapının geçtiği S1 bölümü ya da kitap.
- **Yayın bağı:** Konular hikâye ilerlemesiyle eşleşir (ör. S1·B2'de *there is/are* geçiyorsa A1 konusu o bölümden sonra önerilir). Kilit yoktur; her konu her zaman açıktır.

## 4. Bir dersin yapısı (2–4 dk; kartlar)
1. **Kanca:** Hikâyeden ya da kitaptan gerçek bir cümle, sesiyle. Hi: "Bu cümlede ilginç bir şey var…"
2. **Anlatım:** Türkçe, kısa (kart başına en fazla 3 cümle). Alania sesiyle okunan kelime vurgulanır. Gerektiğinde kodla çizilen şema kullanılır: zaman çizgisi, kutu–ok, renkli ek. Görsel kredisi harcanmaz.
3. **Örnekler:** 3–5 İngilizce örnek, Sarah'nın sesi ve Türkçe karşılığı. Hedef yapı renkle işaretlenir. Kelimeye dokununca anlam paneli açılır.
4. **"Türkçede nasıl?":** Karşılaştırma ve tipik hata. Örnek: *She go* → *She goes*. Utandırmaz.
5. **Alıştırma:** 3–5 soru. Türleri: seç, boşluk doldur, sıraya koy, isteğe bağlı "Söyle" (H-055).
   - Puan, süre ve can yok (K-32).
   - Yanlışta kısa Türkçe açıklama verilir ve aynı soru tekrar sorulur.
6. **Hikâyede gör:** Bu yapının geçtiği gerçek bölüm ve kitap cümleleri. Paket üretilirken etiketlerden çıkarılır; dokununca o sahne ya da sayfa açılır.
7. **Kapanış:** "Deftere kural kartı ekle". Kart kural, bir örnek ve Türkçesinden oluşur; FSRS tekrarına girer. Sakin kutlama gösterilir.

**Kurallar:**
- "Hareketi azalt" desteklenir.
- Erişilebilirlik: dokunma hedefi en az 48, metin 1,3× büyütülebilir.
- Ses kapalıyken de ders tam okunabilir.
- Metinler `ARAYUZ-METINLERI.md`'ye uyar.

## 5. İçerik akışı ve doğruluk
- **Akış:** Claude yazar → `grammar-lint` → kullanıcı onayı (H-028) → **öğretmen ya da editör kontrolü (zorunlu)** → yayın.
- **Neden öğretmen kontrolü zorunlu:** Yanlış anlatılan bir kural zararlıdır. Bu içerikte, hikâyelerden farklı olarak, öğretmen kontrolü yayın şartıdır.
- **`grammar-lint` denetimleri:**
  - İngilizce örneklerin seviye kapsaması (konunun seviyesine göre, K-07);
  - örnek sayısı;
  - kart başına cümle sayısı ve uzunluk;
  - alıştırma cevap anahtarı;
  - "Hikâyede gör" bağlarının çözülmesi;
  - Türkçe metnin bulunması;
  - ses ve hizalama uyumu.
- **Yasak kaynaklar:** Cambridge, Oxford, GSE ve benzeri kaynakların metni kopyalanmaz.

## 6. Ses üretimi
- **Türkçe anlatım:**
  - Alania (`alania-v2`, `alania2-f1`), 48 kHz WAV.
  - Ardından Duyu (`duyu-1`, `verbose_json`, kelime zaman damgası) ile kelime zamanları alınır ve mevcut hizalama biçimine çevrilir.
  - Ses -16 LUFS'a getirilir.
- **İngilizce örnekler:** ElevenLabs (Sarah), kitaplardaki betik ve kurallar.
- **Kurallar:**
  - Varsayılan kuru çalışma: yalnız karakter sayısı ve tahmini maliyet gösterilir, çağrı yapılmaz.
  - Gerçek çağrı için `--execute` gerekir.
  - Aylık karakter tavanı tanımlı değilse araç çalışmaz.
  - Var olan ses yeniden üretilmez.
  - Her çağrı `PROMPTS.md`'ye yazılır.
  - Anahtar yalnız ortamdan ya da repo dışındaki dosyadan okunur.
- **Söyleniş sözlüğü:** Alania İngilizce kelimeleri Türkçe okur. Türkçe anlatımda geçen İngilizce örnekler (ör. "*goes* kelimesi") ya ayrı ses parçası olarak Sarah'ya okutulur ya da söyleniş sözlüğüne yazılır. Pilotta ikisi karşılaştırılır.
- **Maliyet (tahmin):** Türkçe ~1.500 karakter/konu × 70 ≈ 105 bin karakter; ilk ay ücretsiz, sonra ≈ 80 TL. İngilizce ~300 karakter/konu × 70 ≈ 21 bin karakter ElevenLabs.

### 6.1 Araç: `tts_tr.py` (H-075)
Girdi, kimlikli Türkçe parça listesidir:
- JSON: `[{"id","text","instructions"?,"pronunciations"?}]` ya da `{"instructions"?, "segments": [...]}`;
- Markdown: her parça `## <kimlik>` başlığı ve altındaki metin.

```bash
P=tools/content-pipeline/.venv/bin/python
# Kuru çalışma (varsayılan): karakter ve tahmini TL; API çağrılmaz.
$P tools/content-pipeline/tts_tr.py <parcalar.json> --out-dir <klasör>
# Gerçek üretim: aylık tavan şart (HIVELZON_TR_TTS_MONTHLY_CHAR_CAP ya da --monthly-char-cap).
$P tools/content-pipeline/tts_tr.py <parcalar.json> --out-dir <klasör> --execute --monthly-char-cap 50000
```

- **Çıktı:** `<kimlik>.mp3` (-16 LUFS, 44,1 kHz, 128 kb/sn; kitaplarla aynı) ve `<kimlik>.align.json`. Hizalama ElevenLabs `alignment` biçimindedir; `align.py` (`Alignment.load`, `sentence_timings`) değişmeden okur. Ek olarak kelime listesi (`words`: kelime, zaman, `exact|fuzzy|weak|missing`, Duyu'nun duyduğu) ve `quality` bulunur.
- **Eşleme:** Duyu kelimeleri özgün metne eşlenir; zaman Duyu'dan, metin her zaman özgün metinden gelir. Noktalama, büyük/küçük harf, Türkçe harf farkları ve bölünmüş ya da birleşmiş kelimeler (ör. "-s ekleriz" → "sekleriz") tolere edilir. Duyu'nun duymadığı kelimeye komşuları arasında zaman verilir.
- **Uyarı:** İyi eşleşen kelime oranı %85'in altındaysa, art arda 2 kelime zayıf ya da eksikse veya Duyu metinde olmayan çok kelime duyduysa uyarı verilir ve `quality.ok = false` yazılır. `--strict` ile çıkış kodu 3 olur. Uyarılı parça dinlenmeden kullanılmaz.
- **Önbellek ve idempotentlik:** Ödenmiş ham WAV ve Duyu sonucu `_raw/` altında tutulur. Anahtar; metin, model, ses, `instructions` ve söyleniş sözlüğünün sha256'sıdır. Güncel çıktı varsa hiçbir çağrı yapılmaz.
- **Kayıt:** Her Alania ve Duyu çağrısı `--prompts` dosyasına yazılır (varsayılan: parça dosyasının yanındaki `PROMPTS.md`). Satırda tarih, parça, model, ses, sürüm, karakter, ses süresi, istek kimliği ve metin sha256'sı bulunur. Aylık defter: `kitaplar/_maliyet/patientdesk-karakter.json` (karakter, çağrı, Duyu saniyesi).
- **Anahtar:** `PD_API_KEY` ortamdan ya da `~/.config/hivelzon/patientdesk.env`'den, yalnız `--execute` ile okunur. Ekrana ve dosyaya yazılmaz. 429 yanıtında `Retry-After` kadar beklenir (en fazla 5 deneme).
- **Duman testi (2026-10-14, ücretsiz ay):** Hi'nin "-s takısı" anlatımından 2 cümle üretildi: 154 karakter, 4,32 + 7,20 sn, -16,5 / -16,6 LUFS.
  - Türkçe cümlede 10 kelimenin 10'u eşleşti.
  - İngilizce örnekli cümlede (`he, she … She plays`) Alania İngilizce kelimeleri Türkçe okudu; Duyu bunları "h", "ş", "fi" duydu. Araç bu parçayı uyarıyla işaretledi (%81).
  - Sonuç: İngilizce örnekler ayrı Sarah parçası olur ya da söyleniş sözlüğüne yazılır (pilotta karşılaştırılır). "-s" de "şakısını" diye duyuldu; söyleniş sözlüğü adayıdır (ör. `-s` → "se").

## 7. Uygulama
- **Ekranlar:**
  - Hikâye → Dilbilgisi: seviye rafları, "Senin seviyen", "Hikâyende geçenler", tamamlananlar.
  - Ders ekranı: kartlar.
- **Giriş noktaları:**
  - **Hikâyeden önce:** bölüm panelinde ve kitap açma ekranında "Bu bölümdeki dilbilgisi". Bölüm ve kitap paketinde `grammarTopics` alanı bulunur; bu alan etiketlerden üretilir.
  - Anlam panelinde "Bu yapı ne?" (cümle bir konuyla etiketliyse);
  - Hi'nin hata notu (`errorNote`, aynı hata tekrarlanınca);
  - bölüm ve kitap sonu.
- **İlerleme:** `user_grammar_progress` tablosu (görüldü / bitti), cihazda ve hesap varsa eşitlenir.
  - **Listede yüzde (H-064 ek, 2026-10-14):** her ders kartında yarımsa ince çubuk ve "%43 ilerledin" (kalınan kartın sırası / dizindeki `cardCount`; `c03` → 3 kart görüldü), bittiyse onay ve "Tamamladın", başlanmamışsa sakin (yazı yok). Bitmemiş ders en çok %99. Kalınan kart sayıldığı için kullanıcı geri dönerse yüzde de geri gider (ayrı "en ileri kart" sütunu yok; şema değişmedi). Seviye raflarında "A1 · 3/16 tamamlandı". Kod: `grammarLessonProgress`, `grammarLevelSummaries` (`grammar_progress.dart`).
- **İngilizce örneklerin sesi, cihaz yedeği (H-064 ek, 2026-10-14; kullanıcı kararı):** Örneğin ya da "Söyle" cümlesinin önceden üretilmiş Sarah sesi (`audio/en/…`) varsa her zaman o çalar. Yoksa (ya da açılamazsa) örnek **telefonun kendi metin okuma motoruyla** okunur; Sarah sesleri üretildikçe kendiliğinden onların yerini alır.
  - Eklenti: `flutter_tts` 4.2.x (MIT), `ExampleSpeech` bağlantı noktasının arkasında (`mobile/lib/shared/speech/example_speech.dart`, adaptör `device_example_speech.dart`; testlerde sahtesi).
  - iOS: AVSpeechSynthesizer, cihazda çalışır. Android: sistemin TextToSpeech motoru; yalnız cihazda kurulu ve ağ istemeyen ses seçilir (`network_required = 0`, `notInstalled` değil). Ağ sesi hiçbir koşulda seçilmez; uygun ses yoksa düğme görünmez. Android 11+ için manifestte `TTS_SERVICE` sorgusu var.
  - Ses: önce en-GB, yoksa en-US; aynı dilde daha kaliteli ses; Apple'ın eğlence/eski sesleri (`speech.synthesis.voice.*`, Eloquence) seçilmez. Hız A1–A2'de biraz yavaş (0,85), üstünde normal.
  - Kayıt yok, dosya yazılmaz, ağ yok; okunan yalnız ekrandaki İngilizce örnektir. Ücretli hizmet değildir.
  - Aynı anda tek ses: örnek başlayınca Türkçe anlatım durur; kart değişince, anlam paneli açılınca ve ekrandan çıkınca okuma durur. Motor okunan kelimeyi bildirirse ekranda vurgulanır. Sessiz modda cihaz sesi de okumaz.
  - Anlam panelinde cümle cihaz sesiyle dinlenebilir; kelime kelime dinleme yalnız Sarah sesinin zaman damgalarıyla (cihaz sesinde kelime düğmesi yok, ortak `MeaningAudio` arayüzü değişmedi).
- **Hi önerisi:** Görünür gerekçeyle gelir; örnek: "Bu bölümde *there is* çok geçti, kısaca anlatayım mı?"

## 8. Fazlar ve işler
| Faz | İş | Kapsam | Kabul |
|---|---|---|---|
| D0 | **H-075** Türkçe ses: Alania + Duyu | Boru hattında Türkçe TTS adaptörü (kuru çalışma, tavan, idempotent, kayıt), Duyu ile kelime zamanı → hizalama biçimi, -16 LUFS; sunucu ayarı (yapıldı) | pytest yeşil; örnek cümle uçtan uca |
| D0 | **H-076** Müfredat (~70 konu) | Konu listesi, sıra, önkoşul, Türkçe karşılaştırma notu, hikâye bağı | Kullanıcı onayı |
| D1 | **H-077** Ders paketi ve `grammar-lint` | `lesson.json` şeması (kartlar, örnekler, alıştırma, bağlar), lint, dışa aktarma, dev sunucuda `/grammar/` | pytest yeşil |
| D2 | **H-078** Dilbilgisi ekranı (mobil) | Hikâye'de 3. bölüm, ders kartları, vurgulu Türkçe ses, örnek sesleri, alıştırma, Hikâyede gör, kural kartı → Defter/FSRS, giriş noktaları, ilerleme + eşitleme, Hi önerisi | Testler yeşil; golden; erişilebilirlik |
| D3 | **H-079** Pilot: 3 A1 konusu | Metin → lint → kullanıcı onayı → Türkçe ses (Alania, ücretsiz) + İngilizce örnek sesi → paket → simülatör | Kullanıcı dener ve onaylar |
| D4 | **H-080** Dalga 1: A1 + A2 (kalan ~27) | Aynı akış; Türkçe sesler ücretsiz ayda | Onaylı |
| D5 | **H-081** Dalga 2: B1 + B2 (~26) | Aynı akış | Onaylı |
| D6 | **H-082** Dalga 3: C1 + C2 (~14) | Aynı akış | Onaylı |

**Sıra:** H-075 ve H-076 hemen ve paralel → H-077 → H-078 (H-077 ile paralel olabilir) → H-079 → H-080… Ücretsiz ay sınırlı olduğu için A1–A2 metinleri öne alınır.

## 9. Ders paketi biçimi (H-077)
Araçlar `tools/content-pipeline/` altındadır. Şemalar: `schema/lesson.schema.json`, `cards.schema.json`, `lesson-audio.schema.json`. Örnek ders: `tools/content-pipeline/tests/fixtures/grammar/G-A1-99-third-person-s/` (sahte hizalamalı, yalnız test).

### 9.1 Kaynak: `dilbilgisi/<G-ID>/`
| Dosya | İçerik |
|---|---|
| `lesson.json` | `id` (klasör adıyla aynı), `level`, `titleTr`, `titleEn`?, `goalTr`, `prerequisites` (G-ID listesi), `contentVersion`, `status` (K-05), `aiGenerated`, `teacherReview` (`null` ya da `{by, at, notes?}`), `linksTo` (`episodes`, `books`). İsteğe bağlı: `glossary`, `properNouns`, `pronunciations` (`[{term, say_as}]`, Alania söyleniş sözlüğü; yalnız terimi geçen parçaya gider), `narration.tr` (`voice`, `model`, `instructions`), `narration.en` (`voiceId`, `modelId`, `speed`; varsayılan Sarah `EXAVITQu4vr4xnSDxMaL`, `eleven_v3`, seviye hızı). |
| `lesson.md` | Kartlar (§9.2). |
| `PROMPTS.md`, `rights-and-review.md` | Zorunlu. Ses çağrıları `PROMPTS.md`'ye yazılır. |
| `audio/tr/<kart>-tr.{mp3,align.json}` | Türkçe anlatım (kart başına bir parça). |
| `audio/en/<örnek>.{mp3,align.json}` | İngilizce örnek ve "Söyle" cümlesi (her biri ayrı parça). |
| `audio/lesson-audio.json` | Kart → ses parçaları haritası (yol, metin sha256, süre, Duyu kalitesi, var mı). |

Ses (mp3) ve ödenmiş ham önbellek (`_raw/`) git dışındadır; hizalamalar ve harita depodadır.

### 9.2 `lesson.md` işaretleri
```text
# G-A1-03-third-person-s                  isteğe bağlı; kimlikle aynı
> yorum                                   denetime ve sese girmez
## hook | Kart başlığı                    kart başı; başlık isteğe bağlı
Düz Türkçe cümleler.                      Hi'nin anlatımı (Alania); boş satır paragraf sonu
+ She [[goes]] to school. | O okula gider.    İngilizce örnek | Türkçesi; [[ ]] hedef yapı (Sarah okur)
x She go to school. | Ek eksik.           yanlış biçim (contrast); sessiz, kapsamaya girmez
? choose | She ___ to school. | go | *goes    seç; doğru seçenek *
? fill | He ___ football. (play) | plays      boşluk doldur; kabul edilen cevaplar
? order | the box / opens / Ece | Ece opens the box.   sıraya koy
? say | She goes to school. | O okula gider.  Söyle (H-055); cümleyi Sarah okur
! Türkçe kısa açıklama                    önceki sorunun yanlış cevap açıklaması
- episode A1-001 s01 | Can you hear me?   Hikâyede gör: bölüm (+ isteğe bağlı düğüm)
- book A1-K01 p03 | Lina opens the door.  kitap (+ isteğe bağlı sayfa)
@diagram timeline | past: I played | now: I play | future: I will play
@diagram boxes | She :: özne | goes :: fiil ve ek | to school
@diagram suffix | go+es | play+s
```
- **Kart türleri ve sıra:** `hook → explain (tekrar edebilir) → examples → contrast → practice → seeInStory → rule`. `seeInStory` dışındakiler zorunludur. Kartlar sırayla `c01, c02…` kimliğini alır.
- **Parça kimlikleri:** Türkçe `c02-tr`; örnek `c03-ex1`; yanlış biçim `c04-x1`; soru `c05-q1`.
- Türkçe anlatım düz metindir: yıldız, alt çizgi, ters tırnak ve köşeli parantez kullanılmaz; İngilizce kelime yazılmaz. İngilizce kelime ayrı bir `+` örneğine taşınır; ek gösterimi (`-s`) `pronunciations`'a yazılır.

### 9.3 Ses: `tts_lesson.py`
```bash
P=tools/content-pipeline/.venv/bin/python
$P tools/content-pipeline/tts_lesson.py dilbilgisi/G-…            # kuru çalışma: karakter, TL ve kredi
HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=50000 HIVELZON_TTS_MONTHLY_CHAR_CAP=10000 \
  $P tools/content-pipeline/tts_lesson.py dilbilgisi/G-… --execute [--lang tr|en] [--card c02]
$P tools/content-pipeline/tts_lesson.py dilbilgisi/G-… --manifest-only   # yalnız haritayı yaz
```
- **Türkçe:** `tts_tr` (Alania + Duyu, -16 LUFS mp3, hizalama). Tavan `HIVELZON_TR_TTS_MONTHLY_CHAR_CAP`, defter `kitaplar/_maliyet/patientdesk-karakter.json`.
- **İngilizce:** ElevenLabs zaman damgalı (tts.py ile aynı uç nokta ve ayarlar). Tavan `HIVELZON_TTS_MONTHLY_CHAR_CAP`, defter `kitaplar/_maliyet/elevenlabs-karakter.json` (kitaplarla ortak).
- **Kurallar:**
  - Varsayılan kuru çalışmadır.
  - `--execute` için iş olan her dilin tavanı tanımlı olmalı; yoksa hiçbir çağrı yapılmaz.
  - Tavan her parçadan önce denetlenir.
  - Güncel çıktı atlanır (anahtar: metin + ses + model + ayar).
  - Ödenmiş ham çıktı `_raw/`'dan yeniden kurulur. Aynı İngilizce cümle derste birden çok kez geçerse bir kez ücretlenir.
  - Her çağrı `PROMPTS.md`'ye yazılır.
  - Türkçe anlatımda İngilizce kelime görülürse uyarı verilir.

### 9.4 Denetim: `grammar_lint.py`
```bash
$P tools/content-pipeline/grammar_lint.py dilbilgisi/G-* [--json]
```
| Denetim | Düzey |
|---|---|
| `lesson.json` şeması; kimlik = klasör adı, seviyeyle başlar; zorunlu dosyalar | hata |
| `teacherReview` (by, at) yok ve durum APPROVED, SCHEDULED ya da PUBLISHED | hata |
| `linksTo` bölüm/kitap bulunamadı | hata |
| Önkoşul ders henüz yok | uyarı |
| Kart sırası, zorunlu kartlar, tekrar eden kart | hata |
| `seeInStory` kartı yok | uyarı |
| Kanca, anlatım, karşılaştırma ve kural kartında Türkçe anlatım yok | hata |
| Anlatım kartında 3'ten çok cümle | hata |
| Diğer kartlarda 4'ten çok cümle | uyarı |
| Türkçe cümle 20 kelimeden uzun | hata (15'ten uzunsa uyarı) |
| Türkçe anlatımda İngilizce kelime ya da `-s` gibi ek (söyleniş sözlüğünde değilse) | uyarı |
| Örnek kartında 3–5 örnek yok; örneğin Türkçesi yok; örnekler, karşılaştırma ve kuralda `[[ ]]` hedefi yok | hata |
| Kural kartında örnek yok | hata |
| Kancada bağ ya da sesli örnek yok; karşılaştırmada `x`/`+` yok | uyarı |
| Kapsama (K-07: ≥ %98, %95 yalnız sözlükle) ve cümle uzunluğu (İngilizce örnekler ve çözülmüş alıştırmalar) | hata/uyarı (bölümle aynı) |
| Alıştırma 3–5 soru değil; cevap anahtarı geçersiz (seç: tek `___`, en az 2 seçenek, tek doğru, tekrar yok; boşluk: tek `___` ve cevap; sırala: parçalar cevapla aynı kelimeler; söyle: metin) | hata |
| Sırala parçaları zaten doğru sırada; yanlış cevap açıklaması (`!`) yok | uyarı |
| "Hikâyede gör" bağı birebir cümleyle çözülmüyor | hata |
| Bağ birden çok yerde geçiyor ya da yalnız `story.en.md` satırına çözülüyor; bağ `linksTo`'da yok | uyarı |
| Hizalama metinle uyuşmuyor (`textSha256` ya da karakterler) | hata |
| Hizalama ya da ses dosyası yok; Duyu kalitesi düşük | uyarı |

**Bağ çözümü:**
- **Bölüm:** Önce paket altyazılarına (`_build/package/subs`) bakılır. Paket yoksa `kurgu.json` kuru derlenir; o da yoksa yalnız `story.en.md` satırı kullanılır.
  - Altyazı satırı birden çok cümle taşıyabilir; cümlelerden biri birebir eşleşmelidir.
- **Kitap:** Kaynak metin (`text.en.md`) kullanılır. Cümle kimlikleri `pages.json` ile aynıdır.
- Boşluk ve tırnak biçimi farkı yok sayılır. Büyük/küçük harf ve noktalama sayılır.

### 9.5 Paket: `export_grammar.py` → `dilbilgisi/<G-ID>/_build/package/`
```bash
$P tools/content-pipeline/export_grammar.py dilbilgisi/G-… [--require-media]
```
| Dosya | İçerik |
|---|---|
| `lesson.json` | Kaynak meta veri (ses ayarı, söyleniş ve öğretmen notu olmadan). Ek alanlar: `durations` (`narration`, `examples`, `total`, kart başına), `estimatedMinutes` (ses + soru başına 10 sn), `cardCount`, `teacherReviewed`. |
| `cards.json` | Kartlar: `narration` (Türkçe metin, ses, süre, cümle başına `start/end` ve kelime zamanları), `examples` (en, tr, `targets` karakter aralıkları, ses, kelime zamanları), `wrong`, `diagrams`, `practice` (seç: `options[{text, correct}]`; boşluk: `answers`; sırala: `tokens`, `answer`; söyle: `text`, ses; `feedbackTr`), `links` (derin bağ: `episodeId + node + cueId` ya da `bookId + chapter + page + sentenceId`). |
| `audio/<parça>.m4a` | Her parça ayrı -16 LUFS. |
| `manifest.json` | Dosyalar, sha256, ses düzeyi, metin sha256, eksik medya. |

- Eksik ses paketi durdurmaz: `manifest.missing` listesine yazılır, zamanlar hizalamadan gelir. `--require-media` ile eksik ses hata olur.
- Hizalama metinle uyuşmazsa paket üretilmez.

### 9.6 Dev içerik sunucusu ve `grammarTopics`
- **Sunucu:** `serve.py` şu adresleri de sunar: `/grammar/index.json` (ders listesi: kimlik, seviye, ad, hedef, önkoşul, bağlar, kart sayısı, süre) ve `/grammar/<G-ID>/<yol>`. Klasör `--grammar-root`'tur (varsayılan `dilbilgisi/`).
- **`grammarTopics`:** Bölüm (`content.json`) ve kitap (`book.json`) isteğe bağlı bu alanı taşır: G-ID listesi.
  - Bölüm paketinde `scenes.json → episode.grammarTopics`, kitap paketinde `book.json` içinde bulunur.
  - Sunucu dizinlerinde (`/packages/index.json`, `/books/index.json`) de yer alır. Uygulamadaki "Bu bölümdeki dilbilgisi" düğmesi bu alanı kullanır.
  - **Denetim:** `content-lint` ve `book-lint`. Biçim hatalıysa hata. `dilbilgisi/`'de ders varsa bilinmeyen kimlik hatadır; henüz hiç ders yoksa uyarıdır.
  - Alan yoksa çıktı eskisiyle aynıdır.
