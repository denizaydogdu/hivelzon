# hiVelzon — Proje Rehberi

**hiVelzon:** Velzon Bilişim Teknolojileri Ltd. Şti.'nin, yapay zekâ videolarıyla İngilizce öğreten **mobil uygulaması** (iOS + Android).
- Kitle: herkes, A1–C1.
- Gelir modeli: tamamen ücretsiz.
- Alan adı ileride `hi.velzon.tr`; şimdilik web yok.

> **Durum (2026-10-29):** Faz 1 (MVP) sürüyor; son gönderilen `main` commit'i `32b5832` (CI klip denetimi düzeltmesi). H-001/H-003/H-006/H-008/H-015/H-016 kararları ve H-098…H-101 tamamlandı. Tam sistem denetimi: mobil **1483/1483**, `flutter analyze` temiz, backend **164/164**, pytest 383; bölüm/konuş/reel/grammar/book lint'lerinde 0 hata. GitHub CI'daki eksik `ffmpeg` ve paket dışı klip denetimi giderildi; **CI koşusu `40828736476` üç işiyle yeşil**. **Sıradaki bağımlılık sırası:** (1) H-043/H-068 gerçek iPhone, (2) H-085/H-086 kullanıcı denemesi, (3) öğretmen/editör incelemesi, (4) çalışan ElevenLabs erişimi isteyen eksik İngilizce sesler, (5) en sonda H-044 dış hesap/mağaza, (6) H-044 sonrasında H-092 pilotu. Bağımsız yerel ürün kodu işi yok; pilot sonucu olmadan yeni büyük içerik kapsamı açılmaz. Ayrıntı: `yapilacaklar/IS-SIRASI.md`, `docs/SISTEM-DENETIMI-2026-10-28.md`, `docs/HANDOFF-2026-10-27.md`.
> - **Her şey yerelde çalışır** (kullanıcı kararı): Docker PostgreSQL, yerel içerik sunucusu, iOS simülatörü. Sunucu, Bunny Stream, mağaza ve geliştirici hesapları en sonda (H-044); o zamana kadar dış barındırma ve yayın yapılmaz.
> - **Simülatör izni (2026-10-28):** Kullanıcıya sormadan simülatörü açma/başlatma veya simülatörde uygulama/test çalıştırma. Her yeni çalıştırmadan önce açık izin al; genel “devam” talebi simülatör izni sayılmaz.
> - **Planda olmayan yeni kapsam kullanıcı onayı olmadan eklenmez.** Her ücretli üretimden (Higgsfield vb.) önce maliyet gösterilir ve onay alınır.
> - İş planı: `docs/IS-PLANI.md` v0.2 (**H-001 ile 2026-10-27'de onaylandı**). Ayrıntılı gereksinimler: `docs/SARTNAME.md` (taslak 0.1; güncel karar notları başında).

**Karışmasın:** Velzon'un genel Higgsfield görsel/video atölyesi bu klasör değildir; `~/Dev/velzon-gorsel` altındadır (ayrı oturum). hiVelzon kendi içeriği için Higgsfield'ı **buradan doğrudan** kullanır (bkz. "Higgsfield ile görsel, video ve ses üretimi"). Hazır video boru hattı kodu `~/Dev/videoGenerator` altındadır (bkz. "videoGenerator projesinden yararlanma").

## Ürünün dört ayağı
1. Hazır ders videoları (Higgsfield; sabit yapay zekâ öğretmen karakteri)
2. Yapay zekâ konuşma pratiği (günlük kota)
3. Kişiselleştirme: kişiye özel video değil, etkinlikler ve hazır videoların varyantları
4. 30 sn'lik kısa video akışı

## Ana deneyim: oyunlaştırılmış, sürekli hikâye (kullanıcı kararı, 2026-10-11)

- hiVelzon'un omurgası **bir ana kahramanın etrafında, bölüm bölüm ilerleyen, oyun gibi oynanan bir video maceradır.** Dört ayak bu omurgaya bağlanır:
  - hazır videolar = bölümler;
  - konuşma pratiği = karakterlerle canlı sahne;
  - kısa akış = bölüm klipleri;
  - kişiselleştirme = tekrar ve yan görevler.
- **Her bölüm bir öncekine bağlanır.** Her bölüm:
  - kendi görevini kapatır;
  - önceki bir soruyu cevaplar;
  - tam olarak bir yeni somut soru açar.

  Kullanıcı merak ettiği için devam eder.
- **Ayrıntılar:** `docs/OYUN-TASARIMI.md`. Kullanıcının kaynak belgesi: `docs/HIKAYE-EVRENI.md`.

### Onaylı oyun tasarımı kararları (H-029, 2026-10-11)

| # | Karar |
|---|---|
| K-21 | Konsept: ***The Missing Signal***. Telsiz, Alex'in Türkiye'deki büyükannesinden kalmadır (Türkiye bağı). |
| K-22 | Kahraman **Alex**: ~18–19 yaşında, şehre yeni gelmiş. **Hibrit:** ara sahnede görünür, karar anında POV ya da omuz üstü. Kullanıcı Alex'in repliklerini seçer. Özelleştirme yok. Alex'in İngilizcesi kullanıcıyla birlikte büyür. |
| K-23 | Yol arkadaşı **Hi**: Alex'in telefonundaki maskot AI asistan, fotogerçekçi değil. Hikâye içinde yapay zekâ olduğunu söyler. Türkçe desteği sezonlar ilerledikçe azalır. Dile yardım eder, gizemi Alex'in yerine çözmez. |
| K-24 | Görsel tarz: fotogerçekçi olmayan animasyon dizi / çizgi roman tonu, çocuksu değil. Görsel model pilotta seçilir. |
| K-25 | Seviye ve hikâye: MVP'de **sezon = seviye** (Model A). Pilottan sonra yüksek seviyeden başlayana hızlı başlangıç varyantı (Model C). Her bölüm için her seviyede ayrı sürüm yapılmaz. |
| K-26 | Sezon 1 = 12 bölüm + isteğe bağlı prolog (A1). **Üretim önde:** lansmanda 4 bölüm açık, sonra haftada 1. Yayınlanmış bölümler her zaman açık. |
| K-27 | Bölüm anatomisi 9 adım, 5–8 dk. A1–A2'de sahne başına 1–2, bölüm başına en fazla 4 karar anı. Karar anında video durur, müzik ve hareket kısılır. |
| K-28 | Dallanma: dal ve dar boğaz. Yanlış seçim kibar bir tepki parçasından sonra aynı karar anına döner. Bölüm başına en fazla 3 kalıcı bayrak. Zaman mağarası ve çoklu son yok. |
| K-29 | Bölüm kapısı: anlama + hedef ifade + en az 1 aktif görev. Zaman kilidi yok. |
| K-30 | Sekmeler: **Ana Sayfa · Keşfet · Hikâye · Konuş · Profil** (K-02'nin yerine geçer). |
| K-31 | MVP oyun sistemleri: harita, görev kartı, ipucu panosu, defter, anı albümü, sezon özeti, yan görevler. P1: meydan okuma modu, karakter güveni. |
| K-32 | Yasaklar: can/enerji, loot box, zaman kilidi ve geri sayım, suçlayıcı bildirim, lig, ilerleme satın alma, süreli soru. |
| K-33 | Klasör: hikâye kanonu `icerik/_evren/`'de; bölümler K-01 düzeninde (`icerik/A1-001-a-strange-message/`). |
| K-34 | Durum makinesi K-05 olarak kalır. Kanon kontrolü onay kontrol listesinin bir maddesidir. |
| K-35 | A1 hikâye videosu 45–90 sn (CEFR tablosu güncellendi). |
| H-007 | **Konuşma pratiği (AI sohbet) MVP'de yok;** v1'de gelir. |
| H-002 | **Her yaş kullanabilir; hesap 13+** (kullanıcı kararı 2026-10-13, eski "13+" kararının yerine). 13 yaş altı uygulamanın tamamını **hesapsız** kullanır: bütün bölümler, defter, tekrar, Söyle; veriler yalnızca cihazda, e-posta ve hesap yok. Hesap açma 13+ (backend 13 altı kaydı reddeder). AI sohbeti yalnızca 18+. Yaş için yalnız doğum yılı sorulur. **Hukukçu teyit etti (2026-10-21):** 13 altı hesapsız kullanım ve 13–17 hesap için veli onayı gerekmez, doğum yılı beyanı yeterli; cihazda konuşma tanıma KVKK kapsamında değil. Mağaza aile politikaları H-044. |
| H-003 | **Aylık AI harcama tavanı 300 USD.** Kota oturum bazlıdır: sesli en fazla 5 dk/10 tur, yazılı 10 tur; 18+ günde 1 sesli + 3 yazılı, 13–17 günde 1 rehberli yazılı, 13 altı AI sohbeti yok. %50/%80/%100 uyarı; %80'de yalnız metin, %100'de AI durur. |
| H-028 | İçerik onayı: Claude üretir, kullanıcı onaylar; her ünite sonunda öğretmen ya da editör toplu kontrol yapar. |
| K-17 | **Birleşik 4 faz:** F0 kararlar + pilot · F1 MVP (hikâye modu, S1 A1, harita, defter, kısa akış, editör onayı) · F2 v1 (AI konuşma, S2 A2) · F3 v2 (S3+, çevrimdışı, gelişmiş seviye modeli) |
| H-016/H-101 | **Marka Hi:** bütün ekranlarda ve uygulama etiketinde **Hi**; depo/paket/iç adlar `hiVelzon`, hukuki şirket **Velzon Bilişim Teknolojileri Ltd. Şti.** Logo konuşma balonu içinde “Hi”; mevcut kıyı paleti. Mağaza: **Hi: İngilizce Öğren** · alt başlık **İngilizceyi hikâyeyle öğren**. Yerel varlıklar `tasarim/marka/`; uygulama simgeleri `mobile/tool/brand_icons.sh`. |
| H-013 | Günlük hedef 5 / 10 / 15 dk; günde en fazla 1 hatırlatma, saati kullanıcı seçer |
| H-009 | **Hesap herkes için isteğe bağlı** (kullanıcı kararı 2026-10-13: "ne kadar az bilgi alırsak kullanıcılar o kadar rahat eder"). Uygulamanın tamamı hesapsız kullanılır; veriler cihazda. Hesap (13+) yalnızca yedek ve çoklu cihaz için; sakin uyarı: "İlerlemen yalnızca bu telefonda. Kaybolmasın istersen hesap aç." v1 AI sohbeti kota için hesap isteyebilir. Eski karar (misafir: prolog + B1) kaldırıldı. |
| H-018 | Yayın bölgesi: yalnızca Türkiye |
| H-020 | Hiç reklam yok |
| H-017 | Sosyal medya: ayrı ve onaylı faz; hesaplar lansmana yakın açılır; elle yükleme, her yayın onaylı |
| H-010 | Çevrimdışı kullanım MVP'de yok (F3) |
| H-005 | Hi'nin görünümü: yuvarlak, yumuşak ışıklı konuşma balonu ve gözler |
| H-006 | **Sağlayıcı kararı:** Hi-B yerel Ollama + RAG ile başlar (`AiTutorPort`); barındırılan LLM ancak ölçüm yetersizse ve H-044 sonrası ayrı onayla. STT cihazda; İngilizce TTS ElevenLabs, Türkçe TTS PatientDesk Alania. Anahtarlar repo dışında/sunucuda; mobilde sır yok. Almanya sunucusu dışında yeni aktarım ayrı hukukçu onayı ister. |
| H-008 | **Ham ses saklanmaz.** Bulut ses işleme ayrı `VOICE_PROCESSING` rızası ister. Transkript tutulursa yalnız geri bildirim için en fazla 30 gün; eğitim/reklam/analitik yok, hesap silinince silinir. Rıza ve denetim kayıtlarının 2 yıllık süresi ayrıdır. |
| H-015 | S1/S2'de **sayısal telaffuz puanı yok**. S3 yalnız Türk L1 örnekleminde insan değerlendirmesiyle doğrulanırsa açılır; yüzde yerine en fazla 1–3 nitel gelişim noktası gösterilir. |
| H-024 | Pilot (S1·B1 + 3 klip) mevcut Higgsfield kredileriyle başladı. Her üretimden önce maliyet onayı alınır. |
| H-024 | **Standart üretim yolu** (pilotla doğrulandı, kullanıcı onayı):
- **Görsel:** GPT Image 2.5, 9:16, quality low, 0,5 kr/görsel, referanslarla.
- **Hareket:** Yerel Ken Burns. 3 kat süper örnekleme + `zoompan` + 0,35 sn geçiş; takılma ölçümü 0/44 hareketsiz kare.
- **Kilit an:** Seedance 2.0 Mini, başlangıç ve bitiş karesiyle, 5 kr / 5 sn.
- **Ses:** ElevenLabs zaman damgalı, -16 LUFS.
- **Yazılar:** ImageMagick PNG ile eklenir.
- **Explainer:** Kullanılmaz. Gemini Omni 10 sn = 30 kr; B1 ≈ 187 kr. Biçim de uymuyor (tek anlatıcı; karakter sesi ve karar anı yok). Kural 4 karşılaştırması bu gerekçeyle kapandı. |
| H-004 | Higgsfield: mevcut lite plan ile devam (karar anında 110,25 kr; Sezon 1 ≈ 60–100 kr). **Güncel kredi 483,72 (2026-10-27; H-099'da harcama yok).** Kredi 25'in altına inince bir kez hatırlatılır. |
| H-006 (ek) | Ücretsiz ElevenLabs hesaplarıyla üretilen sesler hukukçu görüşüne göre yayında kullanılabilir; yeniden üretim gerekmez. **2026-10-27:** Verilen yeni ücretsiz anahtar API'de `401 detected_unusual_activity` döndürdü; yeni ses üretilmedi, anahtar saklanmadı. Yeni üretim çalışan anahtar veya ayrıca onaylanmış ücretli plan bekler. |
| H-047 | **Hi her yerde: asistan + öğrenme koçu** (`docs/HI-ASISTAN-VE-KOC.md`). Hikâye ve görev dışında sağ altta, menünün üstünde Hi balonu durur. **Hi-A (MVP):** kural tabanlı, AI yok, bütün yaşlar: günlük tek öneri + görünür gerekçe, haftalık özet, onaylı veriden "bu ne demek?". **Hi-B (v1):** metin sohbeti; `AiTutorPort` arkasında yerel Ollama + RAG (pgvector), üretim sağlayıcısı ölçümle H-044'te seçilir. 13–17 rehberli mod, serbest sohbet 18+. Kullanıcı konuşmaları otomatik olarak model eğitimine girmez. Farklılık önceliği: Türkçeye göre koçluk, utanmadan prova, her gün tek adım, gerçek hayat köprü görevleri. |
| H-036/H-051 | **Kelime kartları ve konu setleri** (kullanıcı kararı 2026-10-12): Kart = görsel + kelime + örnek cümle + ses + Türkçesi. Tekrar hatırlama sorularıyla (resimden seç → dinle-seç → yaz/söyle) ve FSRS ile. "Bilmiyorum" utandırmaz; bilinemeyen kart oturum sonunda ve ertesi gün yeniden sorulur. Konu setleri genel değil, **hikâye mekânlarına bağlı** (Alex'in odası, Maya'nın dükkânı, Liman, Kafe) + sahne avı. Görselde yazı yok; başkasının şablonu kopyalanmaz. |
| H-037 | **Giriş: e-postaya tek kullanımlık kod (parolasız)** (kullanıcı kararı 2026-10-13). Parola tutulmaz. Apple/Google ile giriş H-044'te (geliştirici hesaplarıyla). Hesap silme durumu `PENDING_DELETION`. |
| H-055 | **"Söyle" alıştırmaları MVP'de (S1)** (kullanıcı kararı 2026-10-13): telefonun **cihazda** konuşma tanımasıyla "beklenen ifade söylendi mi" kontrolü; puan yok, utandırma yok, 2 deneme + "Geç", hikâyeyi kilitlemez. Yerler: kelime tekrarı "Dinle ve söyle", anlam paneli "Sen de söyle", karar anı "Söyleyerek seç", bölüm sonu hedef ifadeler. **Ses cihazdan çıkmaz, kaydedilmez;** cihaz desteklemiyorsa özellik görünmez. Bütün yaşlar (serbest AI sohbet 18+ kuralı ayrı). S2 serbest prova/karakter konuşması v1; S3 telaffuz puanı yalnız doğrulanırsa (H-015). `docs/KONUSMA-ALISTIRMASI.md`. |
| H-050 | **Her bölüm doğrudan bölüm başlığıyla açılır** (kullanıcı kararı 2026-10-12). Başlıktan önce video, yazı ya da kart yok. Başlık = kısa jenerik animasyonu üstünde "Sezon N · Bölüm N · Başlık". Ardından (B2+) atlanabilir "Önceki bölümde", sonra hikâye. Açılışta ayrı görev kartı yok (K-27 adım 2 değişti): görev ve hedef ifadeler 🎯 panelinde ve bölüm sonunda. Tam jenerik sezonun ilk açılışında bir kez oynar. |
| H-057…H-064 | **Tasarım yenilemesi** (kullanıcı kararı 2026-10-14; Profil "iç içe, düz yazı gibi" bulundu): bütün sayfalar daha hareketli, şekilli ve çekici. **Yazı tipi:** başlıklarda Nunito, metinde Inter; ikisi OFL ve uygulamaya gömülü. **Yalnız açık tema.** Hareket dili sakin ve amaçlı; "Hareketi azalt" açıksa statik; K-32 yasakları geçerli. Ortak bileşen kitaplığı `mobile/lib/shared/ui/`; belirteçler dışında sabit renk/yazı boyutu yok. Marka H-016/H-101 ile tamamlandı. |
| H-065…H-073 | **Kitaplık** (kullanıcı isteği 2026-10-14; `docs/KITAPLIK.md`): seviyeli, resimli, sesli kitaplar. Okunan cümle vurgulanır, dokununca Türkçe çıkar, bilinmeyen kelime **Defter'e** eklenip **Kelime tekrarına** girer. Sesi kapatıp kendin okuyabilirsin; okuduklarım ve yarıda kalanlar takip edilir; "Bana bir kitap oku" okunmamış bir kitabı açar. **A1–C2 × 5 = 30 kitap**, özgün, bağımsız, karışık türler, kısa kitap (A1 ~700 … C2 ~10.000 kelime). Önce 2 pilot kitap (A1 + A2, her sayfa resimli ≈ 15 kr); kalan resim yoğunluğu pilottan sonra seçilir. Ses ElevenLabs (pilot ücretsiz kota, iç kullanım; 30 kitap için ticari plan ayrıca onaylanır). C1/C2 kelime listesi Octanove (ayrı veri seti). **Pilot sonrası (2026-10-14):** kalan 28 kitapta resim kapak + bölüm başı (≈ 90 kr); ses ElevenLabs **Creator** planı (~22 USD/ay, ticari; hesabı kullanıcı açar, anahtar repo dışında). Kitap anlatımı A1–B1'de cümle arası duraklarla seviye hızına getirilir (ücretsiz, dışa aktarmada). |
| H-075…H-082 | **Dilbilgisi** (kullanıcı isteği 2026-10-14; `docs/DILBILGISI.md`): Hi'den Türkçe konu anlatımı, A1–C2, ~70 konu, Türkçeyle karşılaştırmalı. Canlı ders kartları: vurgulu Türkçe anlatım, İngilizce örnekler, şema, puansız alıştırma, "Hikâyede gör", kural kartı → Defter/FSRS. Yer: Hikâye'de "Macera · Kitaplık · Dilbilgisi" ve bağlamdan. **Bölüm panelinde "Bu bölümdeki dilbilgisi" ikincil düğmesi** (H-050 korunur). Yayından önce öğretmen ya da editör kontrolü zorunlu. **Türkçe ses: PatientDesk Alania** (lansman kampanyası: **14 Kasım 2026'ya kadar ücretsiz ve sınırsız**, kullanıcı bildirimi 2026-10-14; sonra 0,75 TL/1.000 karakter; araçtaki tavan yüksek tutulur, harcama yine kaydedilir), kelime zamanları Duyu ile; yalnız Türkçe cümleler. Anahtar sunucu ayarında (`hivelzon.tts.patientdesk`), değer repo dışında. **Kullanıcı kararı (2026-10-14): uygulamada Türkçe konuşan her yer Alania ile** (Hi `alania2-f1`; Alex, babaanne, anlatıcı ayrı sabit Alania sesleri; H-083). |
| H-087…H-092 | **Ürün incelemesi sonrası odak** (kullanıcı onayı 2026-10-16; `docs/URUN-INCELEMESI-2026-10-15.md`): (1) Geliştirme odağı ve tanıtım vaadi **A1–A2 Türkçe konuşan öğrenci**; A1–C2 içerik silinmez, ileri içerik yardımcı kitaplık olarak kalır, kapsamlı kurs vaadi yok. (2) **Yeni C1/C2 içerik dalgası yok;** yeni avatar, ek animasyon, lig/XP, sosyal akış, sınırsız AI sohbeti, doğrulanmamış telaffuz yüzdesi eklenmez. (3) Sıra: H-087 konuşma eşleştirme hatası → H-088 tek günlük plan (Ana Sayfa = Hi; B1+ kullanıcıya birincil öneri seviyesinde kitap) → H-089 taklit/hatırlama ayrımı ve kanıt basamakları (Gördü → Yardımla yaptı → Kendi kullandı → Sonra hatırladı) → H-090 ilk 7 gün + Konuş'ta 3 yönlendirmeli sahne ve kısa mesaj yazma (AI yok) → H-091 kitap sonu 2 soru + yeniden anlatma → H-092 kullanıcı pilotu. (4) Sekme düzeni K-30 şimdilik korunur; "Ana Sayfa · Öğren · Pratik · Profil" pilotta karşılaştırılır. (5) Bağlantı işleri önce; kalan kitap/dilbilgisi İngilizce sesleri ElevenLabs anahtarı geldikçe paralel sürer. |
| H-030 | Kahraman **Aleyna "Alex" Yıldız** (kadın, 19, İzmir). Story Bible ve Sezon 1 planı onaylandı; kanon `icerik/_evren/`'de kilitli. S1'de fiyatlar birimsiz söylenir ("It's thirteen."). |

**Bölümler arası bağ kuralları** (`OYUN-TASARIMI.md` §4.3, bağlayıcı):
- Her bölümün `content.json`'ında şu alanlar zorunludur: `previously`, `payoff`, `openQuestion`, `answers`, `cluesUnlocked`, `callbackPhrases`.
- Açılan her soru en geç 3 bölümde kapanır.
- Aynı anda en fazla 1 sezon sorusu + 2 bölüm sorusu açıktır. Seri sorusu arka plandadır ve bu sayıma girmez.
- Sahte kanca yoktur.
- **Kesin sınırlar** (önceki kararlarla uyumlu):
  - can, enerji, loot box, zaman kilidi, satın alınan bekleme, suçlayıcı bildirim ve lig yok;
  - hata hikâyeyi kalıcı kilitlemez;
  - hikâye ilerlemesi ile dil ustalığı ayrı ölçülür;
  - kanca hikâyenin içinden gelir, korkudan değil meraktan beslenir.

## Önerilen teknik yığın
Flutter + Spring Boot 4 + PostgreSQL. Aşağıdakiler hiVelzon'un **kendi tasarımıyla** yapılır:
- kimlik doğrulama;
- denetim kaydı (IP/port/saat);
- onay kayıtları;
- 30 gün geri alınabilir hesap silme.


Ayrıntı: `docs/IS-PLANI.md` §10.

## Geliştirme ortamı (yerel; ayrıntı kök `README.md`)
```bash
colima start && docker compose up -d --wait            # PostgreSQL 17, 127.0.0.1:5435
python3 tools/dev-content-server/serve.py              # içerik sunucusu, 127.0.0.1:8787 (ayrı terminal)
xcrun simctl boot "hiVelzon iPhone 17"; open -a Simulator
cd mobile && flutter run -d "hiVelzon iPhone 17"       # içerik adresi: --dart-define=CONTENT_BASE_URL=...
```
- Bölüm paketi üretme: `tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_package.py icerik/A1-00[1-4]-*`; yalnızca sezon paketi: `… export_package.py --season 1`. Uygulama içi pakette AI etiketi gömülmez; sosyal medya için `--ai-label`.
- İçerik denetimi: `tools/content-pipeline/.venv/bin/python tools/content-pipeline/content_lint.py icerik/A1-0*`; testler: `tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline`.
- Drift kodu yeniden üretme: `cd mobile && dart run build_runner build --force-jit` (`app_database.g.dart` depoda tutulur).
- Mobil testler: `cd mobile && flutter analyze && flutter test`. Backend: `cd backend && mvn -B verify` (Colima için Testcontainers değişkenleri README'de).

## Belgeler ve öncelik sırası

| Belge | Rolü |
|---|---|
| `CLAUDE.md` (bu dosya) | Bağlayıcı çalışma kuralları |
| `docs/UYGULAMA-PLANI.md` | **Faz 1 (MVP) uygulama planı** (H-025, onaylandı): alt fazlar, işler ve durumları |
| `docs/IS-PLANI.md` | İş ve ürün planı; kararlara göre güncellendi (H-023), H-001 ile 2026-10-27'de onaylandı |
| `docs/SARTNAME.md` | Ayrıntılı ürün, teknik mimari ve uygulama şartnamesi: ekranlar, veri modeli, API taslağı, test stratejisi, MVP kabul kriterleri |
| `docs/ICERIK-MIMARISI.md` | İçerik mimarisi sentezi (web araştırması + içerik stratejisi): müfredat ve lisanslar, formatlar, ekranlar, seviye takibi, yayın hattı. Kararlar H-026'da onaylandı (K-01…K-20) |
| `docs/OYUN-TASARIMI.md` | **Oyunlaştırılmış hikâye tasarımı:** evren, kahraman, bölümler arası bağ, Sezon 1 zinciri, ekranlar, veri modeli. Kararlar H-029'da onaylandı (K-21…K-35). |
| `docs/BOLUM-PAKETI.md` | Bölüm paketi biçimi (`scenes.json` schemaVersion 2, altyazı JSON, sezon paketi) ve content-lint kuralları (H-034, H-046, H-050) |
| `docs/BOLUM-URETIM-REHBERI.md` | Bir bölümü mevcut araçlarla üretme kontrol listesi (H-085; B6–B12 bunu izler) |
| `docs/KELIME-TEKRARI.md` | Kelime tekrarı: hatırlama ile pratiğin ayrımı, FSRS not kuralları, öğrenme kanıtı basamakları ve Profil kazanımları (H-089) |
| `docs/HI-ASISTAN-VE-KOC.md` | Hi asistanı ve öğrenme koçu kararları: Hi-A (MVP, kural tabanlı), Hi-B (v1, yerel LLM + RAG) (H-047) |
| `docs/LISANS-RAPORU.md` | Kelime listesi ve içerik lisanslarının doğrulaması (H-027) |
| `tasarim/README.md` | Arayüz tasarım yönü ve tema belirteçleri (H-045) |
| `docs/HIKAYE-EVRENI.md` | Kullanıcının Storyworld belgesi (*The Missing Signal*), olduğu gibi |
| `docs/VIDEOGENERATOR-RAPORU.md` | videoGenerator sınıf incelemesi ve taşıma planı (H-022) |
| `docs/VIDEOGENERATOR-AI-SERVISLERI.md` | videoGenerator'ın kullandığı AI servisleri (OpenAI, ElevenLabs) |
| `docs/VIDEOGENERATOR-GERCEK-MALIYET.md` | videoGenerator'ın gerçek maliyet kayıtları ve hiVelzon tahmini |
| `docs/ICERIK-STRATEJISI.md` | Kullanıcının içerik stratejisi belgesi (olduğu gibi). Ünite listeleri ve beceri matrisi burada |
| `docs/DILBILGISI.md` | Dilbilgisi: Hi'den Türkçe konu anlatımı; kararlar, ders yapısı, ses üretimi, fazlar (H-075…H-082) |
| `docs/KITAPLIK.md` | Kitaplık: seviyeli, resimli, sesli kitaplar; kararlar, paket biçimi, okuyucu, fazlar (H-065…H-073) |
| `docs/ARAYUZ-METINLERI.md` | Arayüz metin kılavuzu (H-053): ilkeler, terimler (ifade / kart / Kelime tekrarı), ekran ekran metinler. Yeni metin buna uyar. |
| `yapilacaklar/IS-SIRASI.md` | Güncel durum ve sıra |

- Şartnamedeki etiketler: **[KARAR]** onaysız değişmez. **[ARAŞTIRMA]** rakiplerin kamuya açık iddiasıdır ve doğrulanmadan ürün kararı sayılmaz. **[ÖNERİ]** plan onayında karara bağlanır.
- Şartnamedeki veri modeli (§10) ve API (§11) **taslaktır**. Kod başlarken kesinleştirilir.
- Belgeler çeliştiğinde sessizce seçim yapılmaz. Çelişki "mevcut durum / rehber kararı / önerilen çözüm" biçiminde kullanıcıya sunulur.

### Plan ile şartname arasındaki çelişkiler (2026-10-12: telaffuz dışında hepsi çözüldü)

| Konu | `IS-PLANI.md` | `SARTNAME.md` |
|---|---|---|
| ~~Konuşma pratiğinin zamanı~~ | **Çözüldü (H-007):** MVP'de yok; v1'de (F2) Hi-B ile gelir (H-047) | ~~P0/MVP içinde (§5.1)~~ |
| ~~Faz yapısı~~ | **Çözüldü (K-17, H-007):** birleşik 4 faz F0–F3 | ~~Faz 0–5 (§16)~~ |
| ~~Seviye testi~~ | **Çözüldü (K-06, 2026-10-11):** kademeli, en fazla ~20 soru, atlanabilir; sonuç "önerilen başlangıç seviyesi" (`ICERIK-MIMARISI.md` §7.2) | |
| ~~Günlük hedef seçenekleri~~ | **Çözüldü (H-013):** 5 / 10 / 15 dk; günde en fazla 1 hatırlatma | |
| ~~Seri (streak)~~ | **Çözüldü (K-16, 2026-10-11):** kırık seri vurgulanmaz; dondurma ve onarma var; kurtarma görevi yok; seri anlamlı etkinlikle korunur | |
| ~~Telaffuz puanı~~ | **Çözüldü (H-015, 2026-10-27):** S1/S2'de sayısal puan yok; S3 yalnız Türk L1 doğrulamasından sonra, sayı/yüzde yerine 1–3 nitel nokta | Güvenilir değilse gösterilmez (§6.5) |
| ~~Yaş~~ | **Çözüldü (H-002, 2026-10-13 güncellendi):** her yaş kullanır; hesap 13+, 13 altı hesapsız tam kullanım (cihazda); AI sohbeti 18+, 13–17 rehberli (H-047). Hukukçu teyit etti (2026-10-21). | |

Şartnamedeki **açık kararlar listesi** (§18) H-002…H-020 işlerine dağıtıldı. Sıra ve durum: `yapilacaklar/IS-SIRASI.md`.

### Onaylı içerik mimarisi kararları (H-026, 2026-10-11)
Kullanıcı `docs/ICERIK-MIMARISI.md` §14'teki önerileri onayladı. Ayrıntı ve gerekçe o belgededir. Bağlayıcı olanlar:

| # | Karar |
|---|---|
| K-01 | İçerik kimliği `icerik/<SEVİYE>-<3 hane>-<kisa-baslik>/` olarak kalır. Konu `content.json`'da tutulur. `content.json` ve `rights-and-review.md` zorunludur. |
| K-02 | ~~Sekmeler: Ana Sayfa · Keşfet · Öğren · Konuş · Profil~~ → **K-30 ile değişti:** Ana Sayfa · Keşfet · **Hikâye** · Konuş · Profil. Keşfet, kısa video akışıdır. |
| K-03 | Altyazı: varsayılan İngilizce, hedef kelimede küçük Türkçe karşılıkla. A1'de onboarding'de Türkçe satır önerilir; A2 ve üstünde Türkçe satır varsayılan kapalıdır. Sosyal medyada gömülü `.ass` kullanılır. **Uygulamada (H-031, H-046):** altyazı ElevenLabs zaman damgalı JSON'dan uygulama tarafından çizilir (WebVTT kullanılmaz); satıra dokununca video durur ve Türkçe anlam paneli açılır. |
| K-04 | Kelime tekrarı: **FSRS**, hedef hatırlama %90, hesaplama sunucuda (py-fsrs'ten Java'ya taşınır, kaynak belirtilir). |
| K-05 | Durumlar: `DRAFT → IN_REVIEW → APPROVED → SCHEDULED → PUBLISHED → ARCHIVED`, ayrıca `WITHDRAWN`. İnceleme adımları onay kontrol listesinin maddeleridir. `APPROVED` kontrolü backend'de yapılır; AI'ın yayın yetkisi yoktur. |
| K-06 | Seviye testi: kademeli, en fazla ~20 soru, atlanabilir. Sonuç "önerilen başlangıç seviyesi" olarak sunulur. |
| K-07 | Kapsama kuralı ve kelime havuzu: bkz. "İçerik türleri" bölümü. |
| K-08 | Hacim: A1–C1 için ~160 hikâye. Seviye vaadi yoktur. |
| K-09 | Yayın ritmi: ilk 4 hafta haftada 1 hikâye + 3–4 kısa video. Ölçümden sonra haftada 1 hikâye + 1 ders + 7 kısa video. |
| K-10 | Ana dizi "Yeni gelen" ortak evrenidir; her seviye bir sezondur. Yanında kısa seriler vardır (`ICERIK-MIMARISI.md` §4.3). Haftanın kelimeleri bütün serilerde tekrar eder; hedef, kelime başına 8 ve üzeri karşılaşmadır. |
| K-11 | Rubrikli yazma görevi MVP'de yoktur (P1). |
| K-12 | İçerik kod olarak yönetilir: git → `content-lint` → içe aktarma → ince Spring onay ekranı. Headless CMS kullanılmaz. |
| K-13 | Video barındırma: Bunny Stream, `VideoHostingPort` adaptörünün arkasında. |
| K-14 | Sosyal medya: önce elle yükleme. API otomasyonu platform denetiminden sonra kurulur. AI etiketi her zaman konur. |
| K-15 | Keşfet akışı: 4–5 klipte bir quiz kartı, ~10 klipte bir mola kartı. 13–17 yaş için günlük 20 dk varsayılan sınır. Beğeni sayısı ve yorum yoktur. |
| K-16 | Seri: kırık seri vurgulanmaz; dondurma ve onarma vardır. |
| K-20 | A2–B1 içeriklerine MEB tema etiketi eklenir. |

**Sonradan kapananlar** (eskiden "hâlâ açık"):
- **K-17 Faz yapısı:** birleşik 4 faz (H-007).
- **K-18 Onay ve kapasite:** H-028.
- **K-19 Lisans doğrulaması:** H-027 (`docs/LISANS-RAPORU.md`).
- Günlük hedef 5/10/15 dk ve bildirim sıklığı: H-013.

**Açık çelişki kalmadı:** Telaffuz kararı H-015 ile 2026-10-27'de kapandı.

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
- **Veri minimizasyonu (kullanıcı ilkesi, 2026-10-13):** Gerekenden fazla bilgi istenmez. Hesap isteğe bağlıdır; hesapta yalnızca e-posta ve doğum yılı; ad isteğe bağlı ve cihazda. Reklam, izleme ve üçüncü taraf analitik yok. Öğrenme verisi hesap yoksa cihazdan çıkmaz.
- Ham ses varsayılan olarak saklanmaz. Transkriptlerin erişimi kısıtlıdır ve saklama süresi vardır. Loglara ve telemetriye token, parola, ses, tam transkript ve e-posta yazılmaz.
- Zaman UTC saklanır, kullanıcıya yerel saatle gösterilir. Hatalar makinece okunabilir kodla döner (`QUOTA_EXCEEDED` vb.). İstemciye stack trace ve prompt dönmez.
- Mikrofon izni yalnızca konuşma özelliği ilk kez kullanılınca istenir. Mikrofon izni olmadan da hikâye ve video özellikleri tam çalışır. MVP'deki "Söyle" alıştırmaları yalnızca cihazda tanıma kullanır; ses gönderilmez ve saklanmaz (H-055).
- Her ekranda yükleniyor, boş ve hata durumları bulunur. Sonsuz spinner kullanılmaz. Erişilebilirlik için §13.1 geçerlidir.
- İşler küçük parçalara bölünür. Her işin kapsamı, kabul kriteri, test komutu ve geri alma notu olur. İlgisiz refactor yapılmaz. Çalıştırılmayan test geçmiş gibi yazılmaz.

## İçerik türleri: sosyal medya + A1–C1 İngilizce hikâye ve videoları

Sosyal medya içeriğine **ek olarak** artık A1'den C1'e kadar seviyeli **İngilizce hikâyeler** ve bu hikâyelerin **videoları** üretilir. Bunlar hem uygulamadaki ders/kısa video akışını (dört ayaktan 1 ve 4) besler hem de sosyal medyada (Shorts/Reels/TikTok) paylaşılabilir.

### Seviye kılavuzu (CEFR, başlangıç önerisi — editör ayarlayabilir)

| Seviye | Hikâye uzunluğu | Kelime havuzu | Cümle | Dilbilgisi odağı | Anlatım hızı (TTS) | Video süresi |
|---|---|---|---|---|---|---|
| **A1** | 80–150 kelime | ~550 başlık kelime | ≤ 8 kelime, tek yan cümle yok | present simple, *to be*, *there is/are*, *can* | yavaş, ~100–110 kelime/dk | 45–90 sn (K-35) |
| **A2** | 150–300 kelime | ~1.000 | ≤ 12 kelime, *and/but/because* | past simple, *going to*, karşılaştırma | ~115–125 | 60–90 sn |
| **B1** | 300–600 kelime | ~1.600–2.000 | bağlaçlı birleşik cümle | present perfect, 1. tip koşul, *used to* | ~130–140 | 1,5–3 dk |
| **B2** | 500–900 kelime | ~2.500–2.800 | karmaşık cümle serbest | edilgen, dolaylı anlatım, 2./3. tip koşul | ~145–155 | 3–5 dk |
| **C1** | 800–1.500 kelime | ~3.800, deyim ve eşdizimler | doğal, üslup çeşitliliği | inversion, cleft, modal nüansları, deyimler | doğal hız, ~160+ | 4–8 dk |

Kurallar:
- Kelime havuzu değerleri graded reader standartlarına göre güncellendi (K-07, 2026-10-11; `ICERIK-MIMARISI.md` §3.2).
- Her hikâyede seviyenin **üstündeki** kelimeler sözlükte (glossary) açıklanır.
- **Kapsama kuralı (bütün seviyeler):** Kümülatif CEFR-J listesine göre token kapsaması **≥ %98** hedeftir. Özel isimler sayılmaz.
  - **%95** alt sınırdır; buna yalnızca seviye üstü kelimeler sözlükte açıklanmış ve görselle desteklenmişse izin verilir.
- **Müfredat omurgası** (lisanslar H-027'de doğrulandı, `docs/LISANS-RAPORU.md`):
  - **Kelime:** CEFR-J Wordlist **v1.6** (A1–B2; atıfla ticari kullanım serbest) ve Octanove C1/C2 (CC BY-SA; ayrı veri seti olarak tutulur).
  - **Dilbilgisi sırası:** CEFR-J Grammar Profile **referans** alınır. Ham veri uygulamaya gömülmez; Tono Lab'dan yazılı teyit beklenir.
  - **Cambridge EVP/EGP kullanılmaz.** Cambridge bu verileri ticari amaçla lisanslamıyor. Editör de seviye kararında EVP'ye başvurmaz.
  - **Ticari kullanıma kapalı:** Oxford 3000/5000, GSE, COCA ve BNC; uygulamaya aktarılmaz, LLM istemine konmaz.
  - **CEFR tanımlayıcıları:** Companion Volume "All rights reserved"; can-do hedefleri kendi cümlemizle yazılır.
  - Lisanslar H-027'de doğrulanır.
- **Seviye denetimi LLM'e bırakılmaz:** LLM taslağı → deterministik `content-lint` (kapsama, cümle uzunluğu, dilbilgisi) → editör.
- **Vaat yok:** Uygulama tamamlayıcıdır. "Seni X seviyesine ulaştırır" vaadi verilmez (K-08).
- Türk öğrencinin tipik hataları (ör. *I am agree*, *-s* takısı, *the* kullanımı) uygun hikâyelere bilinçli olarak yerleştirilir ve sözlükte not edilir.
- Konular 13+ için güvenli olur (§5.5): şiddet, cinsellik, siyaset ve din yok; gerçek marka, ünlü veya telifli karakter yok (§5.6).
- 30 sn'lik sosyal medya kesitleri uzun hikâyeden türetilir (ayrı hikâye yazılmaz); kesit kendi başına anlaşılır olmalı ve sonunda "devamı uygulamada" çağrısı olabilir.

### Her hikâyenin çıktıları (`icerik/<id>/`)

Kimlik biçimi: `<SEVİYE>-<3 hane>-<kisa-baslik>` (ör. `icerik/A1-001-lost-cat/`). Plan §5.2'deki `icerik/<id>/` düzeninin devamıdır.

K-01 (2026-10-11) ile şunlar onaylandı:
- Kimlik değişmez.
- Konu kodu kimliğe değil, `content.json`'a yazılır.
- `content/A2/A2-TRAVEL-001-…` biçimi kullanılmaz.

```
icerik/_evren/          # hikâye kanonu (K-33): STORY_BIBLE, CHARACTER_PROFILES, CANON_AND_TIMELINE,
                        #   OPEN_QUESTIONS, LANGUAGE_PROGRESSION, SEASON_xx_OUTLINE, style/
icerik/A1-001-lost-cat/ # bölüm klasörü (ör. A1-001-a-strange-message)
├── scenes.json        # segment ve karar düğümü grafiği (oyunlaştırılmış bölüm)
├── mission.json       # görev, başarı ölçütü, ipucu politikası
├── content.json       # makinece okunur meta veri (seviye, konu, hedefler, sürüm, durum, publishAt, kaynak sahne…)
├── rights-and-review.md # kaynaklar, lisans, güvenlik ve onay geçmişi
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

`~/Dev/videoGenerator` (Java 17 + Maven, saf Java SE, Spring yok) zaten **hikâye → sahne görselleri → TTS → altyazı → 1080×1920 video → çoklu platform yayını** hattını uçtan uca çalıştırıyor (Velzon sosyal medya paylaşımları ve İngilizce hikâye kanalları bu kodla üretiliyor). hiVelzon hikâye videoları için tekerleği yeniden icat etme; önce oradaki parçaları incele.

| videoGenerator sınıfı | Ne yapar | hiVelzon'da kullanımı |
|---|---|---|
| `service/StoryWriter` | Tek LLM çağrısında hikâye + sahne başına görsel prompt'u üretir (görsel her zaman anlatımla uyumlu) | Seviyeli hikâye üretimi: prompt'a CEFR kısıtları (yukarıdaki tablo) eklenerek |
| `service/SceneImageService` | Her sahne için görsel üretir; kanalın sabit stil önekini (`stylePrefix`) uygular; var olan görseli tekrar üretmez. **Düzeltme (H-022):** Higgsfield değil, **OpenAI gpt-image-2** kullanıyor (görsel başına sabit 0,08 USD). | Stil kilidi deseni alınır; Higgsfield adaptörü **yeniden yazılır** |
| `service/TranslationService` | Anlatımı dillere çevirir, dil başına başlık/açıklama üretir | TR çeviri taslağı + sosyal medya metadata'sı |
| `api/ElevenLabsClient` | Zaman damgalı (alignment) TTS | Seviyeye göre hız ayarlı anlatım; altyazı zamanlaması için hizalama |
| `processor/SceneTimer` | TTS hizalamasından sahne geçiş zamanlarını çıkarır; görüntü ve altyazı aynı kaynaktan zamanlanır, kayma olmaz | Hikâye videosunda sahne süreleri |
| `processor/SubtitleRenderer` | Kelime → cue gruplayıp güvenli alan payıyla `.ass` altyazı üretir | EN burn-in altyazı (A1–B1 için kelime vurgulu altyazı fikrinin temeli) |
| `processor/KenBurnsRenderer` | Durağan görselleri yakınlaştırma/uzaklaştırma + geçiş + altyazıyla 1080×1920 videoya çevirir | **Ucuz hikâye videosu:** görsel başına ~0,12 kredi, video kredisi harcamadan |
| `processor/AudioProcessor`, `FFmpegWrapper` | Anlatım + müzik karışımı (ducking, normalizasyon), ffmpeg işlemleri. **Not (H-022):** `loudnorm` parametresiz çalışıyor (~-24 LUFS, tek geçiş). | Son kurgu. Normalizasyon -16 LUFS (uygulama) ve -14 LUFS (sosyal medya) hedefiyle iki geçişli olarak yeniden yazılır. |
| `job/JobPipeline`, `Job`, `JobStore` | Adım adım, her adımdan sonra atomik `job.json`; çökme sonrası kaldığı yerden devam | İçerik üretim boru hattının iskeleti |
| `job/BudgetGuard`, `CostTracker` | Ücretli her çağrıdan **önce** aylık harcama tavanı kontrolü; aylık maliyet dosyası. **Not (H-022):** Tavan yoksa 100 USD varsayıyor. Yarıda kalan işin harcaması kaydedilmiyor. | Desen alınır, ama hiVelzon kuralına göre düzeltilir: tavan yoksa üretim kapalı; her harcama kaydedilir; üretim öncesi onay |
| `channel/ChannelProfile` (`channels/*.json`) | Kanal başına konu, stil öneki, ses kimliği, diller, platformlar | Seviye başına profil (ör. `hivelzon-a1-en`) mümkün |
| `publish/*` (`YouTubePublisher`, `MetaReelsPublisher`, `TikTokPublisher`, `PublishService`) | İdempotent çoklu platform yayını | hiVelzon sosyal medya hesapları açılınca yeniden kullanılabilir |
| `web/BackofficeServer` | İş onay/izleme paneli (`PENDING_REVIEW` → onay → yayın) | Editör onayı (insan kontrolü) akışı için örnek |

Kurallar:
- **Önce oku, sonra taşı.** hiVelzon backend'i Spring Boot 4 olacak; videoGenerator saf Java SE. Sınıflar doğrudan bağımlılık olarak değil, **desen/kod olarak taşınır** (kaynağı belirterek). İki repo birbirine bağlanmaz.
- videoGenerator'da değişiklik hiVelzon oturumundan **yapılmaz**; gerekiyorsa kullanıcıya sorulur. O projenin canlı Velzon paylaşım işleri vardır.
- videoGenerator'ın hattı çalışırken orada `mvn package` **çalıştırılmaz** (çalışan JVM'in jar'ı altından değişir).
- videoGenerator'ı hiVelzon içeriği üretmek için doğrudan kullanmak (yeni `channels/hivelzon-*.json` profili + yayın) kullanıcı onayı ister; yayın dışa dönük ve geri alınamaz bir işlemdir.
- Ayrıntı için videoGenerator'ın kendi `CLAUDE.md`, `README.md` ve `thoughts/` belgelerine bak.

## Dış referans: EnglishPractice

https://github.com/recepyagmur/EnglishPractice (Türk öğrenciye yönelik yerel AI İngilizce uygulaması). Kullanıcı kararı (2026-10-12): **kod MIT, desen olarak uyarlanır** (kaynak belirtilerek; iki repo bağlanmaz); **içerik CC BY-SA 4.0, kopyalanmaz ve uyarlanmaz**, yalnızca referans alınır. Ayrıntı: `docs/ENGLISHPRACTICE-INCELEME.md`.

## Higgsfield ile görsel, video ve ses üretimi

Bu klasörden Higgsfield CLI ve Claude Code skill'leriyle görsel, video, ses (TTS/müzik/efekt) ve 3B üretilebilir.

### Kurulum durumu (2026-10-11 doğrulandı; kredi 2026-10-21)

- CLI: `higgsfield` **1.1.26** kurulu (`~/.nvm/versions/node/v18.20.7/bin/higgsfield`; kısa adları `higgs`, `hf`).
- Oturum: açık — `info@velzon.tr`, **lite** plan. Kredi **236,56** (2026-10-20/21 ölçümü; son harcama Keşfet'in 18 reeli, 61,50 kr). Önceki ölçümler: 385,06 (2026-10-14; 500 kredi yüklendi, sonra C1–C2 kitap görselleri 40 kr ve S1 B5–B12); önce 499,56; önceki: 84,56 → H-058 8 kr → kitap pilotu 14 → dalga 1 17 → B1 14 → B2 15 kr. Daha önce: pilot sonrası 110,25, sonra B2–B4, 6 arayüz taslağı, jenerik ve harita görseli). Başka oturumlar da aynı hesabı kullanıyor; harcamadan önce her seferinde `higgsfield account status` ile kontrol edilir.
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

| Skill | hiVelzon'da kullanım |
|---|---|
| `higgsfield-generate` | Genel üretim: sahne görselleri, kısa video klipleri, görselden videoya, TTS dışı ses/müzik/efekt. Varsayılanlar: görsel/metin için GPT Image 2.5, video için Seedance 2.5, çizgi karakter için Nano Banana 2, ses için Seed Audio 1.0 |
| `higgsfield-video-explainer` | **Hikâye videoları için ilk aday:** 10 sn'lik bloklardan anlatımlı, foto-gerçekçi olmayan (animasyon/çizim) hikâye videosu; tek anlatıcı, tek stil anahtarı, isteğe bağlı gömülü altyazı. A1–B1 hikâyelerine çok uygun |
| `higgsfield-soul-id` | Sabit öğretmen karakterinin yüzünü eğitir (§5.1, H-005). Sonra `higgsfield-generate` ile `--soul-id` kullanılarak tutarlı yüz |
| `higgsfield-youtube-thumbnail` | YouTube kapağı, Shorts/Reels kapak görseli |
| `higgsfield-brandkit` | hiVelzon görsel kimliği: renk paleti, logo, tipografi, sosyal medya şablonları |
| `higgsfield-websites` | İleride `hi.velzon.tr` tanıtım sitesi (şimdilik kapsam dışı) |
| `higgsfield-product-photoshoot`, `higgsfield-marketplace-cards` | Ürün fotoğrafı/pazar yeri kartı içindir; hiVelzon'da genelde **kullanılmaz** |

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
6. **Güvenlik ve telif:** Gerçek kişi yüzü/sesi, ünlü benzerliği, gerçek marka ve telifli karakter yok. "Yapay zekâ ile üretilmiştir" ibaresi (§5.6): **sosyal medya ve uygulama dışına çıkan videolarda gömülü** (K-14); **uygulama içi videolarda gömülmez**, uygulama bölüm başında ~4 sn küçük bir not gösterir ve kaybolur (kullanıcı kararı 2026-10-12: "kullanıcı az görsün").
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

## Kurallar
- Kullanıcıyla Türkçe konuş.
- Commit: `/commit` skill, Claude imzası yok. GitHub: `github.com/denizaydogdu/hivelzon`.
- Higgsfield üretiminden önce maliyet gösterilir; her prompt kaydedilir.
- Yapay zekâ maliyetleri ölçülür; aylık harcama tavanı aşılmaz (§8).
- Çocuk kullanıcı ihtimali yüksek: KVKK, COPPA benzeri kurallar ve mağaza eğitim kategorisi kuralları dikkate alınır (§9).
