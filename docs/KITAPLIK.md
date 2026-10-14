# Kitaplık: seviyeli, resimli, sesli kitaplar (H-065…H-073)

> Durum: **plan** (kullanıcı isteği ve onayı 2026-10-14). Kararlar §2'de; işler §9'da.

## 1. Neden
Uygulamada hep okuma ve dilbilgisi var. Kullanıcı bazen yalnızca **dinlemek** ister (ör. yatakta): "A2 seviyesinde bir hikâye aç."
- Sistem okumadığı bir kitabı seçer ve sesli okur.
- Metin ekranda renkli, resimli bir kitap sayfası olarak görünür.
- Okunan cümle vurgulanır; kullanıcı nerede olduğunu görür.
- İstediği an durdurabilir.
- Kelimeye ya da cümleye dokununca Türkçesini görür.
- Sesi kapatıp kendi de okuyabilir.
- Okuduğu ve yarıda kalan kitapları takip eder.
- **Hedef:** A1, A2, B1, B2, C1 ve C2 seviyelerinin her birinde 5 kitap, toplam **30 kitap**. Sıkmayan, merak ettiren kitaplar.

Ana hikâyeden (*The Missing Signal*) ayrı ama onu tamamlayan bir **dinleme + kapsamlı okuma** ayağıdır. Pasif dinleme aktif öğrenmeye bağlanır: dokun → anlam → deftere ekle → FSRS tekrarı (ürün ilkesi).

## 2. Kullanıcı kararları (2026-10-14)
| Konu | Karar |
|---|---|
| Resimler | **Önce pilot:** 2 pilot kitap (A1 + A2) her sayfası resimli, yaklaşık 30 görsel ≈ 15 kr. Uygulamada görüldükten sonra kalan 28 kitabın resim yoğunluğu seçilir. Seçenekler: her sayfa / A1–A2 her sayfa + B1 ve üstünde bölüm başı / kapak + her 3 sayfada 1. Yazı resmin içinde değil, uygulamada çizilir. Resimsiz sayfalar da kitabın renk paletiyle renkli olur. |
| Ses | **ElevenLabs, önce pilot.** Bölümlerdeki gibi zaman damgalı TTS. Pilot ücretsiz kotayla ve yalnız iç kullanım için. 30 kitap ≈ 870 bin karakter, ticari plan gerekir (H-006). Plan ve maliyet ayrıca onaylanır. |
| Uzunluk | **Kısa kitap**, yatak öncesi bir oturuşta biter. Bölümlere ayrılır ve kaldığın yerden devam edilir. §4'teki tablo. |
| Konu | **Bağımsız kitaplar, karışık türler.** Her seviyede 5 ayrı tür: gizem, macera, mizah, bilimkurgu/fantastik, günlük hayat/duygu. Hepsi özgün. Port Lumen kanonuna bağlı değil. |
| C2 | Kullanıcı C2'yi de istedi. Belgelerdeki seviye tablosu C1'de bitiyordu; Kitaplık için C2 eklenir (§4, §6). |

## 3. Dünyadaki örnekler (2026-10-14 taraması)
- **Beelinguapp:** Sesli kitapta karaoke tarzı cümle vurgusu ve yan yana çeviri. Bizde çeviri yan yana durmaz; dokununca anlam paneli açılır (K-03 ile aynı dil).
- **LingQ:** Dinle + oku, kelimeye dokununca anlam ve sesi, kelimeyi tekrar listesine ekleme, tek cümle modu. Bizde tekrar listesi defter + FSRS ile yapılır.
- **Readle:** Kelimeye dokununca sözlük, cümle cümle dinleme.
- **Apple Books / EPUB 3 Media Overlays:**
  - Sesli okumada kelime, cümle ya da vurgusuz okuma seçilebilir.
  - Metin parçası ile ses aralığı SMIL'de eşlenir.
  - Apple'da yalnız sabit yerleşimli kitaplarda çalışır.
  - Bizim biçimimiz aynı fikri JSON'la uygular: cümle ve kelime → başlangıç/bitiş sn.
- **Graded reader yayınevleri (Oxford Bookworms, Penguin Readers):**
  - Seviyeyi başlık kelime, yapı ve kitap uzunluğuyla belirler.
  - Bizim uzunluklar bilinçli olarak daha kısa: uygulama içi, bir oturuşluk.

Kaynaklar:
- [Beelinguapp (App Store)](https://apps.apple.com/app/beelinguapp-learn-languages/id1225056371)
- [Beelinguapp incelemesi](https://www.alllanguageresources.com/beelinguapp/)
- [Apple Books Asset Guide: read aloud](https://help.apple.com/itc/booksassetguide/en.lproj/itc6db639756.html)
- [EPUB Media Overlays 3.2](https://www.w3.org/publishing/epub32/epub-mediaoverlays.html)
- [LingQ](https://apps.apple.com/app/id379385811)
- [OUP graded readers](https://www.oupjapan.co.jp/en/gradedreaders/bookworms.shtml)

## 4. Seviye ve uzunluk (kısa kitap)
| Seviye | Kelime (yaklaşık) | Sayfa | Bölüm | Dinleme | Anlatım hızı | Cümle | Kelime listesi |
|---|---|---|---|---|---|---|---|
| A1 | ~700 | 10–12 | 2–3 | ~6–7 dk | ~100–110 k/dk | ≤ 8 kelime | CEFR-J A1 |
| A2 | ~1.500 | 14–16 | 3–4 | ~12–13 dk | ~115–125 | ≤ 12 kelime | CEFR-J ≤A2 |
| B1 | ~3.000 | 18–20 | 4–5 | ~22 dk | ~130–140 | bağlaçlı | CEFR-J ≤B1 |
| B2 | ~5.000 | 22–24 | 5–6 | ~33 dk | ~145–155 | serbest | CEFR-J ≤B2 |
| C1 | ~8.000 | 26–28 | 6–7 | ~50 dk | ~160 | doğal | CEFR-J + Octanove C1 |
| C2 | ~10.000 | 28–30 | 7–8 | ~60 dk | doğal | doğal, üslup | CEFR-J + Octanove C1/C2 |

- **Kapsama kuralı (K-07):** Hedef ≥ %98, alt sınır %95. %95'e yalnızca sözlükle ve görselle desteklenirse izin verilir. Özel isimler sayılmaz.
- **C1/C2 kelime listesi:** Octanove C1/C2 (CC BY-SA 4.0) **ayrı veri seti** olarak eklenir; özgün metinlerimiz share-alike'a girmez (`docs/LISANS-RAPORU.md`).
- **Yasak kaynaklar:** Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA, BNC kullanılmaz ve LLM istemine konmaz.
- **Toplam:** ~145 bin kelime ≈ 870 bin karakter ses. Görsel sayısı pilottan sonra seçilen yoğunluğa göre: ~210 / ~320 / ~635 görsel, yani ≈ 105 / 160 / 320 kr.

## 5. Kitap içeriği ve kalite
- **Özgün metin; uyarlama ve gerçek marka yok.** 13+ güvenli (§5.5): şiddet, cinsellik, siyaset, din yok; gerçek kişi ya da ünlü yok.
- **Merak motoru (sıkmama):**
  - İlk sayfada bir soru açılır.
  - Her bölüm sonu küçük bir kanca taşır.
  - Son, sürprizli ama adil olur.
  - Karakterin bir isteği ve bir engeli vardır.
  - Seviye düştükçe olay basitleşir, gerilim düşmez.
- **Türk öğrenciye özel:** Tipik hatalar (*I am agree*, -s takısı, *the*) uygun yerlerde ve sözlükte not edilir.
- **Türkçe:**
  - Her cümlenin onaylı Türkçesi ve öbek çevirileri bulunur.
  - Seviye üstü kelimelerin Türkçe karşılığı ve örnek cümlesi sözlüktedir.
  - Bölümlerdeki `ceviri.tr.json` biçiminin kitap karşılığı kullanılır.
- **Akış:** Claude yazar → deterministik `book-lint` (kapsama, cümle uzunluğu, sözlük, çeviri durumu) → **kullanıcı onayı** (H-028) → editör toplu kontrolü.
- **Seslendirme:**
  - Tek anlatıcı.
  - Diyaloglarda en fazla 2 ek karakter sesi olabilir; pilotta tek anlatıcıyla başlanır.
  - Seviye hızına uygun ses, -16 LUFS.
- **Görseller:**
  - GPT Image 2.5, 9:16 ya da 3:4, düşük kalite (H-024).
  - Kitap başına sabit stil öneki ve karakter tanımı.
  - Görselde yazı yok.
  - Her istem ve maliyet `kitaplar/<id>/PROMPTS.md`'ye yazılır.
  - Her üretimden önce maliyet gösterilir ve onay alınır.

## 6. Kitap paketi (H-066'da kesinleşir)
**Kaynak klasör:** `kitaplar/<SEVİYE>-K<2 hane>-<kisa-baslik>/`, örnek `kitaplar/A1-K01-the-blue-door/`. İçeriği:
- `book.json`: meta veri (seviye, tür, başlık, Türkçe tanıtım, sürüm, durum, paletler, bölümler).
- `text.en.md`: sayfa sayfa İngilizce metin.
- `ceviri.tr.json`: onay durumlu Türkçe çeviri.
- `glossary.md`, `rights-and-review.md`, `PROMPTS.md`.
- `audio/`: bölüm başına `.mp3` (git dışı) ve `.align.json`.
- `images/`: sayfa ve kapak görselleri (git dışı; WebP pakete girer).

**Paket:** `_build/package/`. İçeriği:
- `book.json`
- `pages.json`: sayfa → cümleler → kelimeler; her öğede `start`/`end` sn (bölüm sesi içinde), `tr`, `gloss`.
- `audio/<bölüm>.m4a`
- `images/<sayfa>.webp`
- `manifest.json` (sha256)

Zamanlama mevcut `hvpipeline/align.py` ile ElevenLabs karakter hizalamasından üretilir. Bölümlerdeki altyazı biçiminin (`subs.schema.json`) kitap karşılığıdır.

**Kimlik:** `<SEVİYE>-K<2 hane>`. Bölüm kimlikleriyle (`A1-001`) çakışmaz.

**Backend:**
- İçerik türü olarak `BOOK` eklenir.
- Seviyeye C2 eklenir.
- İçe aktarma ve `/admin` onayı genişletilir (K-05 durum makinesi aynen).

## 7. Uygulama deneyimi (taslak; H-067'de tasarım taslağıyla kesinleşir)
**Yer:**
- **Hikâye** sekmesinde iki bölüm: "Macera" (harita) ve "Kitaplık". Sekme sayısı değişmez (K-30).
- Ana Sayfa'daki tek eylem ilkesi korunur. Kitap, Hi'nin önerisi olarak ya da yarıda kalan kitap varsa ikincil kartta görünür.
- Bu yerleşim UNCONFIRMED; H-065'te kullanıcıya sorulur.

**Kitaplık ekranı:**
- **Raflar:** "Okumaya devam et" (yarıda kalanlar, yüzdesiyle), "Senin seviyen", diğer seviyeler, "Okuduklarım".
- **Kitap kartı:** kapak, tür, süre, seviye, ilerleme halkası.
- **Rastgele kitap:** "Bana bir kitap oku" düğmesi → seviye seç (varsayılan önerilen seviye) → okunmamış kitaplardan biri seçilir ve sesli açılır.

**Okuyucu:**
- **Sayfa:** Renkli kitap sayfası; üstte resim, altta metin. Sayfa çevirme hareketi var; "Hareketi azalt" açıksa kayma.
- **Sesli mod:**
  - Okunan **cümle** vurgulanır. Kelime vurgusu ayarla açılıp kapanır.
  - Sayfa sonunda sayfa kendiliğinden çevrilir.
  - Oynat/duraklat, 10 sn geri, hız 0,75 / 1 / 1,25.
  - **Uyku zamanlayıcısı:** bölüm sonunda ya da 10/20/30 dk.
- **Sessiz mod:** Kullanıcı kendi okur ve sayfayı kendi çevirir. Bir cümleye uzun basınca yalnız o cümle seslendirilir.
- **Dokun:** Kelimeye ya da cümleye dokununca ses durur ve mevcut **anlam paneli** açılır (`shared/meaning/`): Türkçe, kelime sesi, "Sen de söyle" (H-055), "Deftere ekle". Panel kapanınca ses kaldığı yerden devam eder.
- **Bilmediğin kelimeyi Defter'e ekle (kullanıcı isteği 2026-10-14):**
  - Her kelime ve cümle Defter'e eklenebilir.
    - Kelimeye dokununca açılan panelde "Deftere ekle".
    - Kelimeye uzun basınca tek dokunuşla ekleme ve küçük bir onay ("Deftere eklendi").
    - Panelde kelime, öbek ya da bütün cümle seçilebilir.
  - Kayıtta neler var:
    - Kelime;
    - Türkçesi;
    - kitaptaki örnek cümle;
    - kitap sesinden kesilmiş telaffuz;
    - kaynak: "Kitap: <başlık>, s. N".
  - Defter'de kitaba göre süzme yapılır.
  - Kartlar mevcut **Kelime tekrarı**na (FSRS) girer.
  - Kitap bitince "Bu kitapta kaydettiklerin" listesi gösterilir.
  - Aynı kelime ikinci kez eklenmez (idempotent).
  - Görsel yoksa kart kitap sayfasının resmini ya da kitap kapağını kullanır.
- **İlerleme:** Kitap, bölüm, sayfa ve son cümle cihazda saklanır, hesap varsa eşitlenir. "Bitti" kazanır (H-056 kuralı).
- **Arka plan:** Ekran kilitliyken dinleme ve kilit ekranı denetimleri (H-068).
- **Bitiş:** Sakin kutlama, "bu kitaptan 5 ifade" kartı ve "sıradaki kitap" önerisi. Puan, lig ve geri sayım yok (K-32).
- **Erişilebilirlik:** Yazı boyutu ayarı (okuma için ayrı, 3 kademe), dokunma hedefi en az 48, ekran okuyucu metni okur.

## 8. Mevcut koddan yeniden kullanılacaklar
- **Zamanlama:** `tools/content-pipeline/hvpipeline/align.py` (ElevenLabs hizalama → cümle/kelime zamanı), `media.py` (-16 LUFS), `translation.py`, `cefr.py`, `lint.py` (kapsama kuralları).
- **Mobil:**
  - Anlam paneli: `mobile/lib/shared/meaning/` (`MeaningController`, `MeaningSheet`, `MeaningAudio` arayüzü).
  - Defter ve tekrar: `NotebookRepository`, FSRS.
  - Altyazı modeli: `features/player/domain/subtitles.dart` (`SubtitleWord` deseni).
  - Hi önerisi: `features/hi/domain/coach_rules.dart` (yeni öneri türleri `continueBook` / `startBook`).
  - Eşitleme: `shared/sync/` (yeni tablo `user_book_progress`, UUIDv5, LWW + "bitti kazanır").
  - Tasarım: `shared/ui/` bileşenleri.
- **Backend:** `CatalogImportService`, `/admin` onay ekranı (H-041), genel `/api/v1/sync`.
- **Eksik olanlar (yeni):**
  - Sesli kitap oynatıcısı. Bugün yalnız `video_player` var; arka plan ve kilit ekranı yok.
  - Kitap paketi biçimi.
  - C1/C2 kelime listesi.
  - C2 seviyesi: veritabanı kısıtı ve lint.
  - TTS betiği. Bugüne kadar seslendirme elle yapıldı.

## 9. Fazlar ve işler
| Faz | İş | Kapsam | Kabul | Maliyet |
|---|---|---|---|---|
| K0 | **H-065** Kitaplık kararları ve 30 kitaplık katalog | Bu belgenin kesinleşmesi; 30 kitabın başlık, tür, tek cümlelik kanca ve karakter listesi; yerleşim ve okuyucu taslağı (kodla çizilmiş tel çerçeve) | Kullanıcı kataloğu ve yerleşimi onaylar | 0 |
| K1 | **H-066** Kitap paketi ve içerik boru hattı | `book.json` / `pages.json` şeması; `book-lint` (kapsama A1–C2, cümle uzunluğu, sözlük, çeviri); Octanove C1/C2 ayrı veri seti; ElevenLabs TTS betiği (zaman damgalı, idempotent, bütçe kontrolü, maliyet kaydı, anahtar repo dışında); WebP ve m4a dışa aktarma; dev içerik sunucusuna `/books/` | pytest yeşil; örnek kitapla paket üretilir | 0 |
| K2 | **H-067** Kitaplık ve okuyucu (mobil) | Kitaplık ekranı, okuyucu (sesli/sessiz, cümle ve kelime vurgusu, otomatik sayfa çevirme, dokun → anlam paneli, hız, uyku zamanlayıcısı), **bilmediğin kelimeyi Defter'e ekleme → Kelime tekrarı**, "Bana bir kitap oku", ilerleme tablosu + eşitleme, Hi önerisi | Kitaptan eklenen kelime Defter'de kaynağıyla görünür ve tekrara girer; testler yeşil; vurgu kayması ≤ 0,2 sn; golden; erişilebilirlik | 0 |
| K3 | **H-068** Arka planda dinleme | `just_audio` + `audio_service` (lisans kontrolü), iOS `UIBackgroundModes: audio`, Android medya bildirimi, kilit ekranı denetimleri | Ekran kilitliyken ses sürer; testler yeşil | 0 |
| K4 | **H-069** Pilot kitaplar (A1 + A2) | 2 kitap: metin → lint → çeviri → kullanıcı onayı → görseller (~30, ≈ 15 kr, maliyet onayı) → ses (ücretsiz kota, iç kullanım) → paket → simülatörde deneme | Kullanıcı pilotu dener; resim yoğunluğu ve ses planı kararı verilir | ≈ 15 kr |
| K5 | **H-070** Kitaplık arka ucu | İçerik türü `BOOK`, seviye C2, kimlik biçimi, içe aktarma, `/admin` onayı, katalog uç noktası | `mvn verify` yeşil | 0 |
| K6 | **H-071** Kitap dalgası 1: A1 + A2 (kalan 8) | Yazım, lint, çeviri, onay, görsel, ses, paket | 10 kitap onaylı | Seçilen yoğunluğa göre |
| K7 | **H-072** Kitap dalgası 2: B1 + B2 (10) | Aynı akış | 10 kitap onaylı | Aynı |
| K8 | **H-073** Kitap dalgası 3: C1 + C2 (10) | Aynı akış | 10 kitap onaylı | Aynı |

**Sıra ve paralellik:**
- H-065 hemen başlar; yalnız belge ve katalog işi.
- Tasarım yenilemesiyle (H-060…H-064) paralel yürüyebilecekler:
  - H-066 ve H-069'un metin kısmı;
  - H-067 (ayrı dalda).
- H-069 pilotu H-066 ve H-067'den sonra uygulamada denenir.
- Dalgalar (H-071…H-073) pilot kararından sonra gelir.
- Ses için ticari ElevenLabs planı yayından önce şarttır (H-006, H-044 ile birlikte).

**Kural:** Her ücretli üretimden önce maliyet gösterilir ve onay alınır. Aylık AI tavanı 300 USD'dir (H-003). Higgsfield kredisi şu an 60,06 kr; 25 kr'nin altına inince bir kez hatırlatılır.
