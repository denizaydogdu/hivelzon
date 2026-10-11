# HiVelzon — Proje Rehberi

**HiVelzon:** Velzon Bilişim Teknolojileri Ltd. Şti.'nin, yapay zekâ videolarıyla İngilizce öğreten **mobil uygulaması** (iOS + Android).
- Kitle: herkes, A1–C1.
- Gelir modeli: tamamen ücretsiz.
- Alan adı ileride `hi.velzon.tr`; şimdilik web yok.

> **Durum:** Planlama. **Kullanıcı planı onaylamadan kod yazılmaz.** Plan: `docs/IS-PLANI.md`. Ayrıntılı gereksinimler: `docs/SARTNAME.md` (taslak 0.1, 2026-10-11). Plan onayına kadar migration, dış servis çağrısı, Higgsfield üretimi ve yayın da yapılmaz.

**Karışmasın:** Velzon'un genel Higgsfield görsel/video atölyesi bu klasör değildir; `~/Dev/velzon-gorsel` altındadır (ayrı oturum). HiVelzon kendi içeriği için Higgsfield'ı **buradan doğrudan** kullanır (bkz. "Higgsfield ile görsel, video ve ses üretimi"). WishSay ayrı bir projedir: `~/Dev/wishsay`. Hazır video boru hattı kodu `~/Dev/videoGenerator` altındadır (bkz. "videoGenerator projesinden yararlanma").

## Ürünün dört ayağı
1. Hazır ders videoları (Higgsfield; sabit yapay zekâ öğretmen karakteri)
2. Yapay zekâ konuşma pratiği (günlük kota)
3. Kişiselleştirme: kişiye özel video değil, etkinlikler ve hazır videoların varyantları
4. 30 sn'lik kısa video akışı

## Önerilen teknik yığın
WishSay ile aynı: Flutter + Spring Boot 4 + PostgreSQL. WishSay'den yeniden kullanılacak desenler:
- kimlik doğrulama;
- denetim kaydı (IP/port/saat);
- onay kayıtları;
- 30 gün geri alınabilir hesap silme;
- iş takip düzeni.

Ayrıntı: `docs/IS-PLANI.md` §10.

## Belgeler ve öncelik sırası

| Belge | Rolü |
|---|---|
| `CLAUDE.md` (bu dosya) | Bağlayıcı çalışma kuralları |
| `docs/IS-PLANI.md` | İş ve ürün planı; kullanıcı onayı bekliyor (H-001) |
| `docs/SARTNAME.md` | Ayrıntılı ürün, teknik mimari ve uygulama şartnamesi: ekranlar, veri modeli, API taslağı, test stratejisi, MVP kabul kriterleri |
| `yapilacaklar/IS-SIRASI.md` | Güncel durum ve sıra |

- Şartnamedeki etiketler: **[KARAR]** onaysız değişmez. **[ARAŞTIRMA]** rakiplerin kamuya açık iddiasıdır ve doğrulanmadan ürün kararı sayılmaz. **[ÖNERİ]** plan onayında karara bağlanır.
- Şartnamedeki veri modeli (§10) ve API (§11) **taslaktır**. Kod başlarken WishSay desenleriyle karşılaştırılıp kesinleştirilir.
- Belgeler çeliştiğinde sessizce seçim yapılmaz. Çelişki "mevcut durum / rehber kararı / önerilen çözüm" biçiminde kullanıcıya sunulur.

### Plan ile şartname arasındaki açık çelişkiler (H-001'de karara bağlanacak)

| Konu | `IS-PLANI.md` | `SARTNAME.md` |
|---|---|---|
| Konuşma pratiğinin zamanı | Faz 2 (v1). MVP'de yok (§11). | P0/MVP içinde (§5.1). Yol haritasında ise Faz 4 (§16). |
| Faz yapısı | Faz 0–3 (§11) | Faz 0–5 (§16) |
| Seviye testi | Uyarlamalı, 15–25 soru (§4.5) | İsteğe bağlı, kısa, atlanabilir; sonuç yalnızca "önerilen başlangıç seviyesi" (§4.2) |
| Günlük hedef seçenekleri | 10 / 20 / 30 dk (§4.7) | 5 / 10 / 15 dk (§4.2) |
| Seri (streak) | Seri dondurma ve "kurtarma" görevi var (§4.7) | Rekabetçi seri baskısı ve suçlayıcı seri mesajlarından kaçınılır (§3.1, §14.3) |
| Telaffuz puanı | v1'de "Söyle" alıştırmalarıyla birlikte (§11) | Yalnızca güvenilir biçimde ölçülebiliyorsa gösterilir; kesin skor iddiası yok (§6.5) |
| Yaş | 13 altı alınmaz. 13–17 konuşma pratiği için karar H-002'de açık. | İçerik hedefi 13+. Kullanıcı yaş kapsamı hukukla doğrulanacak (§18/10). |

Şartnamedeki **açık kararlar listesi** (§18) var olan H-002…H-005 işleriyle örtüşür. Örtüşmeyenler H-001 onayında yeni H işi olarak açılır. Örnekler: misafir kullanımı, çevrimdışı kullanım, CDN, kısa akışta otomatik oynatma.

## Ürün ilkeleri (şartname §3.3, §6)
- Kullanıcı uygulamayı açınca 3–10 dakikada bitirebileceği tek bir öğrenme eylemi görür. Ana sayfa sonsuz akış gibi davranmaz.
- Pasif izleme aktif öğrenmeye bağlanır: video ve klipten sonra soru, kelime kaydetme ya da tam derse geçiş sunulur. Başarı yalnızca izlenme süresiyle ölçülmez.
- Konuşmada önce akıcılık gelir. Düzeltme çoğunlukla oturum sonunda yapılır ve en fazla 1–3 öncelikli noktayla sınırlıdır. Dil yargılayıcı olmaz; hatanın nedeni Türkçe açıklanır.
- Kota bittiğinde kullanıcıya sakin bir dille açıklama yapılır. Ücretsiz bir alternatif önerilir, sıfırlanma saati yerel saatle gösterilir. Ücretli plana yönlendirme baskısı yapılmaz.
- Utandırıcı ve cezalandırıcı dil kullanılmaz: seri, hedef ve geri bildirim mesajlarında da.
- Her kişiselleştirilmiş önerinin görünür bir gerekçesi vardır. İlk sürümde öneriler kural tabanlıdır.
- AI öğretmen romantik, manipülatif ya da bağımlılık yaratan bir dil kullanmaz. Kullanıcıya AI ile konuştuğu açıkça söylenir.

## Mühendislik ilkeleri (kod başladığında geçerli; şartname §9–§13)
- Yapı modüler monolittir; modüller paket olarak ayrılır (§9.3). Controller ince tutulur, iş kuralı servistedir. DTO ile entity ayrıdır. Migration'lar sürümlenir.
- AI, TTS ve ASR sağlayıcıları adaptör arkasında durur. **Sağlayıcı anahtarları yalnızca sunucuda tutulur, mobil uygulamaya konmaz.**
- Medya PostgreSQL'de blob olarak tutulmaz; nesne depolama ya da CDN kullanılır. Uzun AI işleri arka plan işi olarak çalışır, API isteği içinde beklenmez.
- Her ücretli çağrıdan **önce** kota ve bütçe kontrolü yapılır. Çağrılar idempotent olmalıdır: tekrar çağrı çift ücret ya da çift yayın üretmez. Kota sayacı eşzamanlı isteklerde atomik güncellenir.
- Aylık tavan konfigürasyondan okunur, koda gömülmez. **Tavan tanımlı değilse ücretli üretim varsayılan olarak kapalıdır.**
- Ham ses varsayılan olarak saklanmaz. Transkriptlerin erişimi kısıtlıdır ve saklama süresi vardır. Loglara ve telemetriye token, parola, ses, tam transkript ve e-posta yazılmaz.
- Zaman UTC saklanır, kullanıcıya yerel saatle gösterilir. Hatalar makinece okunabilir kodla döner (`QUOTA_EXCEEDED` vb.). İstemciye stack trace ve prompt dönmez.
- Mikrofon izni yalnızca konuşma özelliği açılınca istenir. Mikrofon izni olmadan da hikâye ve video özellikleri tam çalışır.
- Her ekranda yükleniyor, boş ve hata durumları bulunur. Sonsuz spinner kullanılmaz. Erişilebilirlik için §13.1 geçerlidir.
- İşler küçük parçalara bölünür. Her işin kapsamı, kabul kriteri, test komutu ve geri alma notu olur. İlgisiz refactor yapılmaz. Çalıştırılmayan test geçmiş gibi yazılmaz.

## İçerik türleri: sosyal medya + A1–C1 İngilizce hikâye ve videoları

Sosyal medya içeriğine **ek olarak** artık A1'den C1'e kadar seviyeli **İngilizce hikâyeler** ve bu hikâyelerin **videoları** üretilir. Bunlar hem uygulamadaki ders/kısa video akışını (dört ayaktan 1 ve 4) besler hem de sosyal medyada (Shorts/Reels/TikTok) paylaşılabilir.

### Seviye kılavuzu (CEFR, başlangıç önerisi — editör ayarlayabilir)

| Seviye | Hikâye uzunluğu | Kelime havuzu | Cümle | Dilbilgisi odağı | Anlatım hızı (TTS) | Video süresi |
|---|---|---|---|---|---|---|
| **A1** | 80–150 kelime | ~500 temel kelime | ≤ 8 kelime, tek yan cümle yok | present simple, *to be*, *there is/are*, *can* | yavaş, ~100–110 kelime/dk | 30–60 sn |
| **A2** | 150–300 kelime | ~1.000 | ≤ 12 kelime, *and/but/because* | past simple, *going to*, karşılaştırma | ~115–125 | 60–90 sn |
| **B1** | 300–600 kelime | ~2.000 | bağlaçlı birleşik cümle | present perfect, 1. tip koşul, *used to* | ~130–140 | 1,5–3 dk |
| **B2** | 500–900 kelime | ~4.000 | karmaşık cümle serbest | edilgen, dolaylı anlatım, 2./3. tip koşul | ~145–155 | 3–5 dk |
| **C1** | 800–1.500 kelime | geniş, deyim ve eşdizimler | doğal, üslup çeşitliliği | inversion, cleft, modal nüansları, deyimler | doğal hız, ~160+ | 4–8 dk |

Kurallar:
- Her hikâyede seviyenin **üstündeki** kelimeler sözlükte (glossary) açıklanır; A1–A2'de toplam bilinmeyen kelime oranı %5'i geçmez.
- Türk öğrencinin tipik hataları (ör. *I am agree*, *-s* takısı, *the* kullanımı) uygun hikâyelere bilinçli olarak yerleştirilir ve sözlükte not edilir.
- Konular 13+ için güvenli olur (§5.5): şiddet, cinsellik, siyaset ve din yok; gerçek marka, ünlü veya telifli karakter yok (§5.6).
- 30 sn'lik sosyal medya kesitleri uzun hikâyeden türetilir (ayrı hikâye yazılmaz); kesit kendi başına anlaşılır olmalı ve sonunda "devamı uygulamada" çağrısı olabilir.

### Her hikâyenin çıktıları (`icerik/<id>/`)

Kimlik biçimi: `<SEVİYE>-<3 hane>-<kisa-baslik>` (ör. `icerik/A1-001-lost-cat/`). Plan §5.2'deki `icerik/<id>/` düzeninin devamıdır.

```
icerik/A1-001-lost-cat/
├── story.en.md        # İngilizce metin (sahne sahne bölünmüş)
├── story.tr.md        # Türkçe çeviri (insan kontrolünden geçmiş)
├── glossary.md        # seviye üstü kelimeler + Türkçe karşılık + örnek cümle
├── quiz.md            # 3–5 soru, cevap anahtarı
├── PROMPTS.md         # Higgsfield/LLM prompt'ları, model, tarih, kredi (zorunlu)
├── audio/             # TTS çıktıları (sahne başına ya da tek parça)
├── images/ , clips/   # üretilen görseller ve video parçaları
├── subs/              # en.srt, tr.srt (ve gerekirse burn-in .ass)
└── final/             # 9:16 (sosyal/kısa akış) ve 16:9 ya da 9:16 (uygulama) son videolar
```

Bir hikâye, plandaki §5.5 kalite kontrol listesi ve şartnamedeki §7.2 yayın kontrol listesi tamamlanmadan "yayına hazır" sayılmaz. Şartname listesi plandakini genişletir; editör onayının kaydı da bu listededir. 30 sn'lik klipler yalnızca editörün onayladığı içerikten türetilir. Her klip bir öğrenme hedefi taşır: ifade, kelime ya da dilbilgisi.

## videoGenerator projesinden yararlanma

`~/Dev/videoGenerator` (Java 17 + Maven, saf Java SE, Spring yok) zaten **hikâye → sahne görselleri → TTS → altyazı → 1080×1920 video → çoklu platform yayını** hattını uçtan uca çalıştırıyor (Velzon sosyal medya paylaşımları ve İngilizce hikâye kanalları bu kodla üretiliyor). HiVelzon hikâye videoları için tekerleği yeniden icat etme; önce oradaki parçaları incele.

| videoGenerator sınıfı | Ne yapar | HiVelzon'da kullanımı |
|---|---|---|
| `service/StoryWriter` | Tek LLM çağrısında hikâye + sahne başına görsel prompt'u üretir (görsel her zaman anlatımla uyumlu) | Seviyeli hikâye üretimi: prompt'a CEFR kısıtları (yukarıdaki tablo) eklenerek |
| `service/SceneImageService` | Her sahne için görsel üretir; kanalın sabit stil önekini (`stylePrefix`) uygular; var olan görseli tekrar üretmez | HiVelzon için tek tip görsel stil kilidi; yarıda kalan işte kredi israfını önler |
| `service/TranslationService` | Anlatımı dillere çevirir, dil başına başlık/açıklama üretir | TR çeviri taslağı + sosyal medya metadata'sı |
| `api/ElevenLabsClient` | Zaman damgalı (alignment) TTS | Seviyeye göre hız ayarlı anlatım; altyazı zamanlaması için hizalama |
| `processor/SceneTimer` | TTS hizalamasından sahne geçiş zamanlarını çıkarır; görüntü ve altyazı aynı kaynaktan zamanlanır, kayma olmaz | Hikâye videosunda sahne süreleri |
| `processor/SubtitleRenderer` | Kelime → cue gruplayıp güvenli alan payıyla `.ass` altyazı üretir | EN burn-in altyazı (A1–B1 için kelime vurgulu altyazı fikrinin temeli) |
| `processor/KenBurnsRenderer` | Durağan görselleri yakınlaştırma/uzaklaştırma + geçiş + altyazıyla 1080×1920 videoya çevirir | **Ucuz hikâye videosu:** görsel başına ~0,12 kredi, video kredisi harcamadan |
| `processor/AudioProcessor`, `FFmpegWrapper` | Anlatım + müzik karışımı (ducking, normalizasyon), ffmpeg işlemleri | Ses seviyesi normalizasyonu (§5.5), son kurgu |
| `job/JobPipeline`, `Job`, `JobStore` | Adım adım, her adımdan sonra atomik `job.json`; çökme sonrası kaldığı yerden devam | İçerik üretim boru hattının iskeleti |
| `job/BudgetGuard`, `CostTracker` | Ücretli her çağrıdan **önce** aylık harcama tavanı kontrolü; aylık maliyet dosyası | §8 aylık tavan kuralının hazır uygulaması |
| `channel/ChannelProfile` (`channels/*.json`) | Kanal başına konu, stil öneki, ses kimliği, diller, platformlar | Seviye başına profil (ör. `hivelzon-a1-en`) mümkün |
| `publish/*` (`YouTubePublisher`, `MetaReelsPublisher`, `TikTokPublisher`, `PublishService`) | İdempotent çoklu platform yayını | HiVelzon sosyal medya hesapları açılınca yeniden kullanılabilir |
| `web/BackofficeServer` | İş onay/izleme paneli (`PENDING_REVIEW` → onay → yayın) | Editör onayı (insan kontrolü) akışı için örnek |

Kurallar:
- **Önce oku, sonra taşı.** HiVelzon backend'i Spring Boot 4 olacak; videoGenerator saf Java SE. Sınıflar doğrudan bağımlılık olarak değil, **desen/kod olarak taşınır** (kaynağı belirterek). İki repo birbirine bağlanmaz.
- videoGenerator'da değişiklik HiVelzon oturumundan **yapılmaz**; gerekiyorsa kullanıcıya sorulur. O projenin canlı Velzon paylaşım işleri vardır.
- videoGenerator'ın hattı çalışırken orada `mvn package` **çalıştırılmaz** (çalışan JVM'in jar'ı altından değişir).
- videoGenerator'ı HiVelzon içeriği üretmek için doğrudan kullanmak (yeni `channels/hivelzon-*.json` profili + yayın) kullanıcı onayı ister; yayın dışa dönük ve geri alınamaz bir işlemdir.
- Ayrıntı için videoGenerator'ın kendi `CLAUDE.md`, `README.md` ve `thoughts/` belgelerine bak.

## Higgsfield ile görsel, video ve ses üretimi

Bu klasörden Higgsfield CLI ve Claude Code skill'leriyle görsel, video, ses (TTS/müzik/efekt) ve 3B üretilebilir.

### Kurulum durumu (2026-10-11 doğrulandı)

- CLI: `higgsfield` **1.1.26** kurulu (`~/.nvm/versions/node/v18.20.7/bin/higgsfield`; kısa adları `higgs`, `hf`).
- Oturum: açık — `info@velzon.tr`, **lite** plan, **204,25 kredi** (planda yazan 244,25'ten bu yana 40 kredi harcanmış).
- Skill'ler: `~/.claude/skills/higgsfield-*` altında kurulu (liste aşağıda).

### Yeni bir makinede kurulum (ya da kurulum bozulursa)

1. CLI'yi kur: `npm i -g @higgsfield/cli`
2. Giriş yap: `higgsfield auth login` → açılan tarayıcıda oturumu tamamla. (Etkileşimli komut: kullanıcı Claude Code içinde `! higgsfield auth login` diye kendisi çalıştırmalı.)
3. Skill'leri kur: `npx skills add higgsfield-ai/skills`
4. Doğrula:
   ```bash
   higgsfield --version
   higgsfield account status        # e-posta, plan, kalan kredi
   ls ~/.claude/skills | grep higgsfield
   ```

Not: CLI nvm'in Node 18 kurulumuna bağlı. Node sürümü değişirse `higgsfield` komutu kaybolur; 1. adımı yeni sürümde tekrarla.

### Hangi iş için hangi skill

| Skill | HiVelzon'da kullanım |
|---|---|
| `higgsfield-generate` | Genel üretim: sahne görselleri, kısa video klipleri, görselden videoya, TTS dışı ses/müzik/efekt. Varsayılanlar: görsel/metin için GPT Image 2.5, video için Seedance 2.5, çizgi karakter için Nano Banana 2, ses için Seed Audio 1.0 |
| `higgsfield-video-explainer` | **Hikâye videoları için ilk aday:** 10 sn'lik bloklardan anlatımlı, foto-gerçekçi olmayan (animasyon/çizim) hikâye videosu; tek anlatıcı, tek stil anahtarı, isteğe bağlı gömülü altyazı. A1–B1 hikâyelerine çok uygun |
| `higgsfield-soul-id` | Sabit öğretmen karakterinin yüzünü eğitir (§5.1, H-005). Sonra `higgsfield-generate` ile `--soul-id` kullanılarak tutarlı yüz |
| `higgsfield-youtube-thumbnail` | YouTube kapağı, Shorts/Reels kapak görseli |
| `higgsfield-brandkit` | HiVelzon görsel kimliği: renk paleti, logo, tipografi, sosyal medya şablonları |
| `higgsfield-websites` | İleride `hi.velzon.tr` tanıtım sitesi (şimdilik kapsam dışı) |
| `higgsfield-product-photoshoot`, `higgsfield-marketplace-cards` | Ürün fotoğrafı/pazar yeri kartı içindir; HiVelzon'da genelde **kullanılmaz** |

### Sık komutlar

```bash
higgsfield account status                          # kalan kredi
higgsfield model list --video                      # video modelleri
higgsfield model get <model>                       # modelin parametreleri
higgsfield generate cost <model> --prompt "..."    # maliyet tahmini — KREDİ HARCAMAZ
higgsfield generate create <model> --prompt "..."  # üretim işi başlatır — KREDİ HARCAR
higgsfield generate wait <job_id>                  # iş bitene kadar bekler
higgsfield generate list                           # son işler
higgsfield upload <dosya>                          # referans görsel/ses yükler
higgsfield voices                                  # TTS sesleri
higgsfield workflow list                           # hazır iş akışları
```

### Higgsfield kuralları (zorunlu)

1. **Önce maliyet:** Her `generate create` öncesinde `generate cost` ile kredi hesaplanır, kullanıcıya gösterilir ve **onay alınır**. Toplu üretimde toplam maliyet tek seferde gösterilir.
2. **Kayıt:** Her prompt, model, parametre, tarih, job id ve harcanan kredi `icerik/<id>/PROMPTS.md`'ye yazılır (§5.6 telif kanıtı). Ayrıca şunlar da kaydedilir (şartname §8.3):
   - prompt sürümü;
   - tahmini ve gerçek kredi;
   - kullanıcı onayının referansı;
   - üretilen dosya yolları;
   - editör değerlendirmesi;
   - telif ve AI açıklaması kontrolü.

   Maliyet verisi yoksa tahmin uydurulmaz; güncel fiyat doğrulanır.
3. **Bütçe:** Aylık tavan aşılmaz (§8). Kalan kredi `higgsfield account status` ile kontrol edilir; kredi bitmeye yaklaşınca kullanıcıya **bir kez** hatırlatılır, plan önerisi tekrar tekrar yapılmaz (karar H-004'te).
4. **Ucuz yol önce:** Kredi/sn farkı büyük (§5.3: görsel ~0,12 kredi; video 1–7 kredi/sn). Hikâyelerde varsayılan yol: **Higgsfield görselleri + yerel Ken Burns kurgu (videoGenerator `KenBurnsRenderer` deseni) + TTS + altyazı.** Gerçek video klip yalnızca kanca (ilk 3 sn) ve kilit sahnelerde kullanılır. `higgsfield-video-explainer` daha pahalı ama daha canlı seçenektir; ilk denemede ikisi aynı hikâyeyle karşılaştırılır.
5. **Karakter ve stil tutarlılığı:** Öğretmen için Soul ID; hikâye karakterleri için hikâye başına sabit stil öneki ve karakter tanımı (`PROMPTS.md` başında).
6. **Güvenlik ve telif:** Gerçek kişi yüzü/sesi, ünlü benzerliği, gerçek marka ve telifli karakter yok; videolarda "yapay zekâ ile üretilmiştir" ibaresi var (§5.6).
7. **Metin görselde değil, kurguda:** Görsel modellerin ürettiği yazılar bozulabilir; ekrandaki İngilizce kelimeler, altyazı ve kelime kartları yerel kurguda (ffmpeg/slayt) eklenir.

## İş takibi (H-numaraları)
| Klasör | Anlamı |
|---|---|
| `yapilacaklar/IS-SIRASI.md` | **Önce bunu oku.** Sıra, durum, nerede kalındığı, günlük |
| `yapilacaklar/` | Başlanmamış işler |
| `devam-edenler/` | Üzerinde çalışılan işler |
| `bitenler/` | Bitmiş **ve doğrulanmış** işler |
| `hatalar/` | Hatalar ve riskler |
| `ogrenilenler/` | Dersler (`D-` numaralı) |

Kurallar:
- İşler `H-<3 hane>-<kisa-baslik>.md`, tek sayaç. Dersler `D-<3 hane>-…`.
- Durum değişince dosya ilgili klasöre taşınır ve `IS-SIRASI.md` güncellenir.
- Bir iş, kabul kriterleri doğrulanmadan `bitenler/`e geçmez.
- WishSay'de öğrenilen dersler `~/Dev/wishsay/ogrenilenler/` altında; ilgili olanlar burada da geçerli.

## Kurallar
- Kullanıcıyla Türkçe konuş.
- Commit: `/commit` skill, Claude imzası yok. GitHub: `github.com/denizaydogdu/hivelzon`.
- Higgsfield üretiminden önce maliyet gösterilir; her prompt kaydedilir.
- Yapay zekâ maliyetleri ölçülür; aylık harcama tavanı aşılmaz (§8).
- Çocuk kullanıcı ihtimali yüksek: KVKK, COPPA benzeri kurallar ve mağaza eğitim kategorisi kuralları dikkate alınır (§9).
