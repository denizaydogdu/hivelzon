# Öğretmen / editör inceleme paketi

> **Durum:** Hazır, editör bekliyor (2026-10-30). Depo `e22e5d2` üzerinde sayıldı.
> **Karar:** H-028 (`bitenler/H-028-onay-ve-icerik-kapasitesi.md`). Claude üretir, kullanıcı onaylar, ünite sonunda öğretmen ya da editör toplu kontrol yapar.
> **Bu belge:** Editörün tek giriş noktası. Önce §1–§4'ü okuyun, sonra §5'teki föylere geçin.
> **Bu iş sırasında içerik değiştirilmedi.** Bulgular §7'de, düzeltmeler editör turundan sonra yapılır.

## 1. Kısaca proje

- **Hi**, yapay zekâ videolarıyla İngilizce öğreten ücretsiz bir mobil uygulamadır (iOS + Android). Şirket: Velzon Bilişim Teknolojileri Ltd. Şti.
- **Omurga:** *The Missing Signal* adlı, bölüm bölüm ilerleyen bir hikâye. Kahraman Aleyna "Alex" Yıldız (19, İzmir). Yol arkadaşı Hi, telefondaki yapay zekâ asistanıdır.
- **Hedef kitle (H-087):** A1–A2 düzeyinde, Türkçe konuşan öğrenci. B1–C2 içerik silinmez, yardımcı kitaplık olarak kalır.
- **Yaş:** Uygulamayı her yaş kullanır. İçerik 13+ için güvenli yazılır.
- **Uygulama tamamlayıcıdır.** "Seni X seviyesine ulaştırır" sözü verilmez (K-08).

## 2. Ton ve içerik ilkeleri

Kontrol ederken şunlara bakın. Ayrıntı: `docs/ARAYUZ-METINLERI.md` §1.

1. **Utandırmayan dil.** "Yanlış", "başarısız", "kaçırdın" yok. Yanlış seçimden sonra kibar bir tepki gelir.
2. **"Sen" dili, sade Türkçe.** Kısa cümle, günlük kelime.
3. **13+ güvenli konu.** Şiddet, cinsellik, siyaset ve din yok.
4. **Gerçek marka, ünlü, gerçek kişi ve telifli karakter yok.** Görselde de yok.
5. **Görselde yazı yok.** Ekrandaki İngilizce metin kurguda eklenir.
6. **Yasak oyun öğeleri yok:** can, enerji, geri sayım, suçlayıcı bildirim, lig (K-32).
7. **Türk öğrencinin tipik hataları** (*I am agree*, *-s* takısı, *the*) bilerek yer alabilir. Sözlükte ya da notta açıklanmış olmalıdır.
8. **Sezon 1'de fiyatlar birimsizdir:** "It's thirteen." (H-030).

## 3. Editör neye karar verir, neye vermez

| Editör karar verir | Editör karar vermez |
|---|---|
| İngilizce doğru ve doğal mı | Ürün kapsamı, ekran tasarımı, yeni özellik |
| Seviyeye uygun mu (A1, A2 …) | Hikâyenin ana kurgusu (kanon kilitli, `icerik/_evren/`) |
| Türkçe çeviri doğru ve doğal mı | Maliyet, ücretli üretim, ses sağlayıcısı |
| Sözlük anlamı bağlama uyuyor mu | Yayın tarihi ve sırası |
| Soru ve cevap anahtarı doğru mu, çeldiriciler makul mü | Teknik denetimler (lint zaten koşuyor, §8) |
| Dilbilgisi anlatımı doğru mu | |
| Kültürel uygunluk, ton, 13+ güvenliği | |
| Görsel sahneye uyuyor mu, yapay zekâ kusuru var mı | |

- Her öğe için iki seçenek vardır: **Onay** ya da **Düzeltme** (not ile).
- Kanonla çelişen bir şey görürseniz yalnızca not düşün. Kanon değişikliği kullanıcı kararıdır.
- **Durum makinesi (K-05):** `DRAFT → IN_REVIEW → APPROVED → SCHEDULED → PUBLISHED`. Editör onayı, `APPROVED` için gereken son insan adımıdır. Yapay zekânın yayın yetkisi yoktur.

## 4. Öncelik sırası ve süre

Sayılar depodan sayıldı. **Süreler kaba tahmindir;** ilk birkaç öğeden sonra gerçek hızınıza göre düzeltin.

| Sıra | Alan | Öğe sayısı | Hacim | Tahmini süre |
|---|---|---|---|---|
| 1 | Sezon 1 bölümleri **B5–B12** (H-085) | 8 bölüm | 13–16 görsel, 2–3 karar anı, 2–3 görev/bölüm | ~6 sa (bölüm başına ~45 dk) |
| 1b | Sezon 1 bölümleri **B1–B4** (çeviri kullanıcı onaylı; ünite toplu kontrolü yapılmadı) | 4 bölüm | 7–9 görsel/bölüm | ~1,5 sa |
| 1c | Kanon okuma (`icerik/_evren/*.md`) | 6 belge | ~9.600 kelime | ~1 sa (göz atma) |
| 2 | Konuş sekmesi (H-090) | 3 sahne + 3 mesaj = 6 görev | 12 tur, 55 kabul cevabı | ~1 sa |
| 3 | Kitap sonu soruları (H-091) | 30 kitap × 2 soru + 1 model özet | 60 soru, 30 özet | ~2,5 sa |
| 3b | Kitap Türkçesi, A1–A2 (tam) | 10 kitap | ~12.100 İngilizce kelime | ~5 sa |
| 3c | Kitap Türkçesi, B1–C2 (örneklem: kitap başına 1 bölüm) | 20 kitap | toplam ~139.000 kelime | ~5 sa |
| 4 | Dilbilgisi A1–A2 (**yayın şartı**) | 31 ders | ~17.200 kelime | ~8 sa |
| 4b | Dilbilgisi B1–C2 (**yayın şartı**) | 40 ders | ~24.500 kelime | ~8 sa |
| 5 | Keşfet reelleri (H-094) | 18 reel | 220 sn video | ~1,5 sa |
| 5b | Sezon 1 bölüm klipleri (Keşfet) | 17 klip | 174 sn video | ~1 sa |
| | **Toplam** | | | **~40 sa** |

**Önerilen tur düzeni:**
- **1. tur (~20 sa):** 1, 1b, 1c, 2, 3, 3b, 4, 5. Hedef kitle A1–A2 olduğu için önce bunlar.
- **2. tur (~20 sa):** 3c, 4b, 5b.
- H-028 notu: Sezon 1 için kontrol en az B4, B8 ve B12'den sonra yapılmalıydı. Bu üç kontrol henüz yapılmadı; 1. tur üçünü birlikte karşılar.

**Nasıl bakılır?**
- **Metin:** Depodaki Markdown ve JSON dosyaları (yollar föylerde). Okuması zor JSON için Claude'dan iki sütunlu (İngilizce | Türkçe) okuma çıktısı istenebilir.
- **Görsel ve video:** `icerik/<bölüm>/images/`, `reeller/<id>/<id>.mp4`, `icerik/_evren/klipler/`.
- **Uygulamada görmek:** Yerel simülatör ya da cihaz. Simülatör yalnızca kullanıcının açık izniyle çalıştırılır.
- **Yayın onayı:** Yerel backend'de editör hesabıyla (`users.role='EDITOR'`; `devam-edenler/H-094-kesfet-gunluk-uc-video.md`).

## 5. Föyler

Her föyde önce **kontrol maddeleri**, sonra **öğe tablosu** var. Tabloda kutuyu işaretleyin (☒), notu aynı satıra yazın.

**Ortak kontrol maddeleri** (her alanda geçerli; `docs/IS-PLANI.md` §5.5 ve `docs/SARTNAME.md` §7.2'den):
- [ ] İngilizce doğru ve doğal; dilbilgisi hatası yok.
- [ ] Seviyeye uygun: kelime, cümle uzunluğu, dilbilgisi (CLAUDE.md seviye tablosu).
- [ ] Türkçe çeviri doğru ve doğal; anlam kayması yok.
- [ ] Sözlük anlamları bağlama uygun.
- [ ] Soru cevapları doğru; tek doğru var; çeldiriciler makul.
- [ ] Kültürel uygunluk ve 13+ güvenliği.
- [ ] Marka, logo, gerçek kişi, telifli karakter yok.
- [ ] Ton: utandırmayan, sakin dil (§2).

---

### 5.1 Sezon 1 bölümleri (`icerik/A1-0*`)

**Önce okuyun:** `docs/BOLUM-URETIM-REHBERI.md` §5 ve §7, `docs/BOLUM-PAKETI.md` §2 (düğüm türleri, ipuçları, bölüm kapısı) ve §3.1 (çeviri kaynağı), `docs/OYUN-TASARIMI.md` §4.3 (bölümler arası bağ).

**Bir bölümde nereye bakılır:**

| Ne | Dosya |
|---|---|
| İngilizce metin, sahne sahne | `story.en.md` |
| Türkçe okunur çeviri (editör için) | `story.tr.md` |
| Satır satır çeviri, kart ve görev Türkçesi | `ceviri.tr.json` |
| Karar anları, tepkiler, görevler (quiz), ipuçları (`hints`), kartlar, bölüm kapısı | `kurgu.json` |
| Sözlük, hedef ifadeler, bağ alanları (`previously`, `payoff`, `openQuestion`, `answers`, `cluesUnlocked`, `callbackPhrases`) | `content.json` |
| Görev kartı (B6 ve sonrası) | `mission.json` |
| Görseller ve istemleri | `images/`, `PROMPTS.md` |
| Haklar, AI açıklaması ve onay geçmişi | `rights-and-review.md` |
| Kanon | `icerik/_evren/` (STORY_BIBLE, CHARACTER_PROFILES, CANON_AND_TIMELINE, OPEN_QUESTIONS, LANGUAGE_PROGRESSION, SEASON_01_OUTLINE) |

**Bölüme özel kontrol maddeleri:**
- [ ] **Çeviri:** `story.tr.md` ile `ceviri.tr.json` doğal Türkçe; karakterin sesi tutarlı (Alex genç ve samimi, Hi yardımsever).
- [ ] **Karar anları:** doğru seçenek tek ve açık; yanlış seçeneğin tepkisi kibar, utandırmıyor (K-28).
- [ ] **Görevler (quiz):** cevap anahtarı doğru; çeldiriciler makul; geri bildirim Türkçesi sakin.
- [ ] **İpuçları:** 1. düzey anahtar sözcük, 2. düzey kalıp, 3. düzey Türkçe açıklama. Cevabı doğrudan vermiyor.
- [ ] **Sözlük:** seviye üstü kelimeler var ve anlamları bağlama uygun.
- [ ] **Görsel:** sahneye uyuyor; yüz ve kıyafet bölümler arasında tutarlı; el/parmak kusuru yok; görselde yazı yok.
- [ ] **Kanon:** önceki bölüme bağlanıyor; bir soruyu cevaplıyor; tam olarak bir yeni soru açıyor; açılan soru en geç 3 bölümde kapanıyor (OYUN-TASARIMI §4.3).
- [ ] **Kapsama uyarısı varsa** (%95–98): seviye üstü kelime sözlükte ve görselle destekli mi? Bu kararı editör verir.

| Bölüm | Yol | Durum | Not (lint ve bilinen) |
|---|---|---|---|
| A1-000 Arrival (prolog) | `icerik/A1-000-arrival/` | — | **İnceleme dışı.** Yalnızca diyalog taslağı; görsel, kurgu ve çeviri yok. |
| A1-001 A Strange Message | `icerik/A1-001-a-strange-message/` | ☐ Onay ☐ Düzeltme | Çeviri kullanıcı onaylı (2026-10-12). Lint temiz. |
| A1-002 The New Neighbour | `icerik/A1-002-the-new-neighbour/` | ☐ Onay ☐ Düzeltme | Çeviri kullanıcı onaylı. Lint temiz. |
| A1-003 Find the Station | `icerik/A1-003-find-the-station/` | ☐ Onay ☐ Düzeltme | Çeviri kullanıcı onaylı. Kapsama %96,2 (sözlükle %100): görsel desteği kontrol. |
| A1-004 The Note | `icerik/A1-004-the-note/` | ☐ Onay ☐ Düzeltme | Çeviri kullanıcı onaylı. Kapsama %97,6 (sözlükle %100). **B4 ünite kontrolü.** |
| A1-005 Too Late? | `icerik/A1-005-too-late/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. Sözlükte olmayan: *yeah* (A2). |
| A1-006 The Recording | `icerik/A1-006-the-recording/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. |
| A1-007 Who Knows What? | `icerik/A1-007-who-knows-what/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. Sözlükte olmayan: *voice* (A2). |
| A1-008 The First Reveal | `icerik/A1-008-the-first-reveal/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. Kapsama %97,4 (sözlükle %100). **B8 ünite kontrolü.** |
| A1-009 The Café on the Hill | `icerik/A1-009-the-cafe-on-the-hill/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. Kapsama %96,0 (sözlükle %99,6). Sözlükte olmayan: *far* (A2). |
| A1-010 Spare Parts | `icerik/A1-010-spare-parts/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. |
| A1-011 Storm Warning | `icerik/A1-011-storm-warning/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. İpucu kartı Türkçe sesi hizası zayıf (0,944): dinleyin. |
| A1-012 The Lighthouse | `icerik/A1-012-the-lighthouse/` | ☐ Onay ☐ Düzeltme | Çeviri DRAFT. **B12 ünite kontrolü.** |
| Kanon tutarlılığı (bütün sezon) | `icerik/_evren/` | ☐ Onay ☐ Düzeltme | Bölümlerin `canonVersion` değeri 0.1. |

**Ek (isteğe bağlı, düşük öncelik):** Kullanıcının onayladığı konu setleri (`icerik/_evren/setler/`, 4 set; `two-notes` örnek kapsaması %95,8) ve Hi verileri (`hata-katalogu.json`, `konu-tanitimlari.json`, `kopru-gorevleri.json`). Hepsi `APPROVED`; editör toplu bakışı yine de faydalı.

---

### 5.2 Konuş sekmesi (`icerik/_evren/konusma/`)

**Ne:** Yapay zekâ olmayan, yönlendirmeli prova sahneleri ve kısa mesaj görevleri (H-090). Hepsi **DRAFT**, editör onayı bekliyor. Kullanıcı söyleyerek ya da dokunarak cevap verir. Söylenen cevap kabul listesindeki biriyle tam eşleşmelidir (H-087).

**Önce okuyun:** `bitenler/H-090-ilk-yedi-gun-ve-konusma-gorevleri.md` (Notlar), `docs/BOLUM-PAKETI.md` §9a, `docs/ARAYUZ-METINLERI.md` §7.2.

**Kontrol maddeleri:**
- [ ] Her turdaki **kabul edilen cevaplar** aynı anlamda ve doğal. Ters anlamlı ya da anlamı değiştiren cevap listede yok.
- [ ] Eksik doğal cevap var mı? (Öğrencinin söyleyebileceği ama listede olmayan cevaplar not edilir.)
- [ ] Yakın seçenek duyulunca gelen **kibar tepki** utandırmıyor.
- [ ] Karakter repliği kanonla uyumlu (Maya, Rosa, köpekli adam). Sahne "prova"dır, kanonu değiştirmez.
- [ ] Mesaj görevlerinde model cevap ve öz değerlendirme maddeleri doğru.
- [ ] Türkçe (`titleTr`, `introTr`, tur Türkçeleri) sade ve doğal.

| Görev | Yol | Açılış | Durum | Not |
|---|---|---|---|---|
| hi-intro · Hi'ye kendini tanıt (mesaj) | `icerik/_evren/konusma/hi-intro.json` | B1 sonrası | ☐ Onay ☐ Düzeltme | Kural yok, yalnız öz değerlendirme. |
| maya-neighbour · Yeni komşunla tanış (sahne) | `icerik/_evren/konusma/maya-neighbour.json` | B2 sonrası | ☐ Onay ☐ Düzeltme | 4 tur, 20 kabul cevabı. |
| ask-the-way · Yol sor (sahne) | `icerik/_evren/konusma/ask-the-way.json` | B3 sonrası | ☐ Onay ☐ Düzeltme | 4 tur, 16 kabul cevabı. Kapsama %96,2 (sözlükle %100). |
| meet-note · Telefonuna not al (mesaj) | `icerik/_evren/konusma/meet-note.json` | B4 sonrası | ☐ Onay ☐ Düzeltme | Kural: *friday* + *seven*. |
| late-maya · Maya'ya geç kaldığını yaz (mesaj) | `icerik/_evren/konusma/late-maya.json` | B5 sonrası | ☐ Onay ☐ Düzeltme | Kural: *sorry* + *late*; *not/never/no* yok. |
| cafe-rosa · Kafede sipariş ver (sahne) | `icerik/_evren/konusma/cafe-rosa.json` | B9 sonrası | ☐ Onay ☐ Düzeltme | 4 tur, 19 kabul cevabı. Fiyat birimsiz. |

---

### 5.3 Kitaplık (`kitaplar/*-K*`)

**Ne:** 30 özgün, seviyeli kitap (A1–C2 × 5). Metin ve Türkçe çeviri kullanıcı tarafından onaylandı (`ceviri.tr.json` → `APPROVED`, 2026-10-14). Kitap durumu `DRAFT`; editör toplu kontrolü yapılmadı. Kitap sonu soruları (H-091) Claude taslağı, onay bekliyor.

**Önce okuyun:** `docs/KITAPLIK.md` (§ akış ve paket biçimi), `bitenler/H-091-kitap-sonu-anlama.md`, `devam-edenler/H-086-kitap-sayfasinin-turkcesi.md`, her kitabın `rights-and-review.md` dosyası.

**Bir kitapta nereye bakılır:**

| Ne | Dosya |
|---|---|
| İngilizce metin | `text.en.md` |
| Türkçe çeviri (cümle cümle, kelime anlamları, notlar) | `ceviri.tr.json` → `lines`, `phrases`, `notes` |
| Kitap sonu 2 soru + yeniden anlatma model özeti | `book.json` → `comprehension` (`questions`, `retell.modelEn`, `retell.modelTr`) |
| Sözlük | `glossary.md` |
| Görseller | `images/` (kapak + sayfa/bölüm başı) |
| Haklar ve onay geçmişi | `rights-and-review.md` |

**Kontrol maddeleri:**
- [ ] **Sorular:** 3 seçenek, tek doğru; cevabın sayfası (`page`) doğru; `promptTr` doğal; çeldirici metinde gerçekten yanlış.
- [ ] **Model özet:** `modelEn` seviyeye uygun 1–3 cümle; `modelTr` doğru ve doğal.
- [ ] **Çeviri:** cümle Türkçesi doğal; kelime anlamları (`words`) bağlama uygun; notlar doğru.
- [ ] **Seviye:** kelime ve cümle uzunluğu seviyeye uygun. C1/C2'de kapsama otomatik denetlenemiyor (liste yok); seviye kararını editör verir.
- [ ] **Güvenlik ve özgünlük:** 13+ uygun; gerçek marka/kişi yok; başka bir eserden alıntı yok.

| Kitap | Yol | İngilizce kelime | Durum | Not |
|---|---|---|---|---|
| A1-K01 *The Blue Door* | `kitaplar/A1-K01-the-blue-door/` | ~808 | ☐ Onay ☐ Düzeltme | Bekleyen 2 düzeltme (§7): "Her heart is fast." → "Her heart beats fast."; "floor four" → "the fourth floor". |
| A1-K02 *Grandpa's New Phone* | `kitaplar/A1-K02-grandpas-new-phone/` | ~849 | ☐ Onay ☐ Düzeltme | EN ses yok |
| A1-K03 *The Red Kite* | `kitaplar/A1-K03-the-red-kite/` | ~815 | ☐ Onay ☐ Düzeltme | — |
| A1-K04 *Pip Cannot Sleep* | `kitaplar/A1-K04-pip-cannot-sleep/` | ~864 | ☐ Onay ☐ Düzeltme | — |
| A1-K05 *The Window Across* | `kitaplar/A1-K05-the-window-across/` | ~834 | ☐ Onay ☐ Düzeltme | — |
| A2-K01 *The Lemon Cake Mystery* | `kitaplar/A2-K01-the-lemon-cake-mystery/` | ~1.633 | ☐ Onay ☐ Düzeltme | EN ses yok |
| A2-K02 *Into the Fog* | `kitaplar/A2-K02-into-the-fog/` | ~1.626 | ☐ Onay ☐ Düzeltme | EN ses yok |
| A2-K03 *The Parrot Who Told Everything* | `kitaplar/A2-K03-the-parrot-who-told-everything/` | ~1.495 | ☐ Onay ☐ Düzeltme | — |
| A2-K04 *The Girl Who Never Saw Rain* | `kitaplar/A2-K04-the-girl-who-never-saw-rain/` | ~1.615 | ☐ Onay ☐ Düzeltme | EN ses yok |
| A2-K05 *Good Morning. Wrong Number* | `kitaplar/A2-K05-good-morning-wrong-number/` | ~1.573 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B1-K01 *The Backwards Clock* | `kitaplar/B1-K01-the-backwards-clock/` | ~3.227 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B1-K02 *Where Is Pamuk?* | `kitaplar/B1-K02-where-is-pamuk/` | ~3.280 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B1-K03 *The Accidental Chef* | `kitaplar/B1-K03-the-accidental-chef/` | ~3.048 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B1-K04 *The Library of Lost Things* | `kitaplar/B1-K04-the-library-of-lost-things/` | ~3.345 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B1-K05 *Second Violin* | `kitaplar/B1-K05-second-violin/` | ~3.100 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B2-K01 *Two Signatures* | `kitaplar/B2-K01-two-signatures/` | ~5.399 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B2-K02 *The Singing Hill* | `kitaplar/B2-K02-the-singing-hill/` | ~5.424 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B2-K03 *Please Don't Translate That* | `kitaplar/B2-K03-please-dont-translate-that/` | ~5.285 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B2-K04 *The Last Gardener on Mars* | `kitaplar/B2-K04-the-last-gardener-on-mars/` | ~5.429 | ☐ Onay ☐ Düzeltme | EN ses yok |
| B2-K05 *What My Brother Didn't Say* | `kitaplar/B2-K05-what-my-brother-didnt-say/` | ~5.125 | ☐ Onay ☐ Düzeltme | EN ses yok |
| C1-K01 *The Ninth Plate* | `kitaplar/C1-K01-the-ninth-plate/` | ~8.597 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C1-K02 *Eleven Bridges* | `kitaplar/C1-K02-eleven-bridges/` | ~8.729 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C1-K03 *The Anniversary Committee* | `kitaplar/C1-K03-the-anniversary-committee/` | ~8.739 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C1-K04 *The Lake That Remembered Tomorrow* | `kitaplar/C1-K04-the-lake-that-remembered-tomorrow/` | ~8.654 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C1-K05 *Held in Trust* | `kitaplar/C1-K05-held-in-trust/` | ~8.730 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C2-K01 *The Missing Entries* | `kitaplar/C2-K01-the-missing-entries/` | ~10.922 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C2-K02 *The Town That Wasn't There* | `kitaplar/C2-K02-the-town-that-wasnt-there/` | ~10.994 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C2-K03 *A Strongly Worded Letter* | `kitaplar/C2-K03-a-strongly-worded-letter/` | ~10.957 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C2-K04 *The Word Meter* | `kitaplar/C2-K04-the-word-meter/` | ~10.367 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |
| C2-K05 *The Other Half of the Sentence* | `kitaplar/C2-K05-the-other-half-of-the-sentence/` | ~10.112 | ☐ Onay ☐ Düzeltme | EN ses yok, C1/C2 kapsama denetlenmedi |

---

### 5.4 Dilbilgisi (`dilbilgisi/G-*`)

**Ne:** Hi'den Türkçe konu anlatımı, 71 ders (A1 16 · A2 15 · B1 14 · B2 12 · C1 8 · C2 6). Hepsi `DRAFT`. **Öğretmen ya da editör kontrolü yayın şartıdır** (`docs/DILBILGISI.md` §5): yanlış anlatılan kural zararlıdır.

**Önce okuyun:** `docs/DILBILGISI.md` (§ ders yapısı ve §5 içerik akışı), `dilbilgisi/MUFREDAT.md`, her dersin `rights-and-review.md` dosyası.

**Bir derste nereye bakılır:** `lesson.md` (bütün kartlar okunur biçimde: kanca, anlatım, şema, örnekler, alıştırma, kural kartı) · `lesson.json` (meta; `teacherReview` alanı şimdilik boş) · `rights-and-review.md` (onay geçmişi).

**Kontrol maddeleri:**
- [ ] **Kural doğru:** Türkçe anlatım dilbilgisi açısından doğru; aşırı genelleme ya da eksik istisna yok.
- [ ] **Türkçe karşılaştırma doğru:** "Türkçede … , İngilizcede …" cümleleri yanıltmıyor.
- [ ] **Örnekler:** İngilizce doğru ve doğal; Türkçe karşılığı doğru; seviyeye uygun.
- [ ] **Alıştırma:** cevap anahtarı doğru; tek doğru var; çeldiriciler makul.
- [ ] **Kanca ve "Hikâyede gör":** alıntılanan hikâye ya da kitap cümlesi konuyu gerçekten gösteriyor.
- [ ] **Sıra:** konu seviyesine uygun (CEFR-J Grammar Profile referans; Cambridge EVP/EGP kullanılmaz).
- [ ] Türkçe anlatımda İngilizce kelime yok; İngilizce yalnızca örnek parçalarında.

Tablodaki notlar `grammar_lint` uyarılarıdır; hiçbiri inceleme engeli değildir. "EN örnek sesi eksik" olan derslerde örnekleri metinden okuyun.

| Ders | Yol | Durum | Not |
|---|---|---|---|
| A1-01 am / is / are: "olmak" fiili | `dilbilgisi/G-A1-01-to-be/` | ☐ Onay ☐ Düzeltme | — |
| A1-02 to be ile soru ve olumsuz | `dilbilgisi/G-A1-02-to-be-questions-negatives/` | ☐ Onay ☐ Düzeltme | — |
| A1-03 a / an: "bir"i söylemek | `dilbilgisi/G-A1-03-a-an/` | ☐ Onay ☐ Düzeltme | — |
| A1-04 the: ikimizin bildiği şey | `dilbilgisi/G-A1-04-the/` | ☐ Onay ☐ Düzeltme | — |
| A1-05 he / she / it, me / him / her, my / your / his / her ve 's | `dilbilgisi/G-A1-05-pronouns-possessives/` | ☐ Onay ☐ Düzeltme | — |
| A1-06 this / that / these / those ve çoğul -s | `dilbilgisi/G-A1-06-this-that-plurals/` | ☐ Onay ☐ Düzeltme | — |
| A1-07 can / can't: yetenek, rica ve kısa cevap | `dilbilgisi/G-A1-07-can/` | ☐ Onay ☐ Düzeltme | — |
| A1-08 Emir kipi: Go / Turn / Don't… | `dilbilgisi/G-A1-08-imperatives/` | ☐ Onay ☐ Düzeltme | — |
| A1-09 Yer edatları: in / on / under / near / between / behind | `dilbilgisi/G-A1-09-prepositions-place/` | ☐ Onay ☐ Düzeltme | — |
| A1-10 Saat ve gün: at / on / in, What time is it? | `dilbilgisi/G-A1-10-prepositions-time/` | ☐ Onay ☐ Düzeltme | — |
| A1-11 Geniş zaman (present simple): I / you / we / they | `dilbilgisi/G-A1-11-present-simple/` | ☐ Onay ☐ Düzeltme | — |
| A1-12 Kelime sırası: özne + fiil + nesne | `dilbilgisi/G-A1-12-word-order-svo/` | ☐ Onay ☐ Düzeltme | — |
| A1-13 He / she / it ile fiile -s | `dilbilgisi/G-A1-13-third-person-s/` | ☐ Onay ☐ Düzeltme | — |
| A1-14 do / does ile soru ve olumsuz | `dilbilgisi/G-A1-14-do-does/` | ☐ Onay ☐ Düzeltme | — |
| A1-15 there is / there are: "var" demek | `dilbilgisi/G-A1-15-there-is-are/` | ☐ Onay ☐ Düzeltme | — |
| A1-16 have / has: sahiplik ve tarif | `dilbilgisi/G-A1-16-have-has/` | ☐ Onay ☐ Düzeltme | — |
| A2-01 Şimdiki zaman: am / is / are + -ing | `dilbilgisi/G-A2-01-present-continuous/` | ☐ Onay ☐ Düzeltme | — |
| A2-02 Geniş zaman mı, şimdiki zaman mı? | `dilbilgisi/G-A2-02-simple-vs-continuous/` | ☐ Onay ☐ Düzeltme | — |
| A2-03 was / were: geçmişte "idi" | `dilbilgisi/G-A2-03-was-were/` | ☐ Onay ☐ Düzeltme | — |
| A2-04 Geçmiş zaman: düzenli fiiller (-ed) | `dilbilgisi/G-A2-04-past-simple-regular/` | ☐ Onay ☐ Düzeltme | — |
| A2-05 Geçmiş zaman: düzensiz fiiller | `dilbilgisi/G-A2-05-past-simple-irregular/` | ☐ Onay ☐ Düzeltme | — |
| A2-06 did / didn't ile geçmişte soru ve olumsuz | `dilbilgisi/G-A2-06-past-questions-negatives/` | ☐ Onay ☐ Düzeltme | — |
| A2-07 Sayılabilen ve sayılamayan: some / any / much / many / a lot of | `dilbilgisi/G-A2-07-countable-uncountable/` | ☐ Onay ☐ Düzeltme | hikâye bağı A1-000 düğümsüz |
| A2-08 Karşılaştırma: -er / more … than | `dilbilgisi/G-A2-08-comparatives/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| A2-09 En üstünlük: the -est / the most | `dilbilgisi/G-A2-09-superlatives/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| A2-10 going to: plan ve kanıta dayalı tahmin | `dilbilgisi/G-A2-10-going-to/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| A2-11 will: anlık karar, söz ve tahmin | `dilbilgisi/G-A2-11-will/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| A2-12 Zarflar: always / usually / never ve -ly | `dilbilgisi/G-A2-12-adverbs/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| A2-13 Bağlaçlar: and / but / because / so ve when | `dilbilgisi/G-A2-13-conjunctions/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| A2-14 have to / must / should: zorunluluk ve öneri | `dilbilgisi/G-A2-14-have-to-must-should/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| A2-15 Fiilden sonra fiil: want to, like + -ing | `dilbilgisi/G-A2-15-verb-patterns/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-01 Present perfect (1): deneyim, ever / never | `dilbilgisi/G-B1-01-present-perfect-experience/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B1-02 Present perfect (2): since / for | `dilbilgisi/G-B1-02-present-perfect-since-for/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B1-03 Present perfect mi, past simple mı? just / already / yet | `dilbilgisi/G-B1-03-present-perfect-vs-past/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B1-04 Past continuous ve when / while | `dilbilgisi/G-B1-04-past-continuous/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-05 used to: geçmişteki alışkanlık | `dilbilgisi/G-B1-05-used-to/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, kanca gerçek cümle değil, EN örnek sesi eksik |
| B1-06 Gelecek: will, going to, şimdiki zamanla randevu | `dilbilgisi/G-B1-06-future-forms/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-07 Koşul cümleleri: 0 ve 1. tip | `dilbilgisi/G-B1-07-zero-first-conditional/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-08 Tanımlayan sıfat cümlecikleri: who / which / that | `dilbilgisi/G-B1-08-defining-relative-clauses/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-09 -ing mi, to mu? Fiil kalıpları (2) | `dilbilgisi/G-B1-09-gerund-infinitive/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-10 Olasılık: might / may / could | `dilbilgisi/G-B1-10-might-may-could/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-11 Past perfect: "olmuştu" | `dilbilgisi/G-B1-11-past-perfect/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B1-12 bored mı boring mi? -ed / -ing sıfatları | `dilbilgisi/G-B1-12-ing-ed-adjectives/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B1-13 Dolaylı sorular: Can you tell me where…? | `dilbilgisi/G-B1-13-indirect-questions/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B1-14 Artikeller (2): genel mi, belirli mi? | `dilbilgisi/G-B1-14-articles-general-specific/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B2-01 Edilgen yapı (passive): be + V3 | `dilbilgisi/G-B2-01-passive/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B2-02 Dolaylı anlatım (1): say, tell ve zaman kaydırma | `dilbilgisi/G-B2-02-reported-statements/` | ☐ Onay ☐ Düzeltme | EN örnek sesi eksik |
| B2-03 Dolaylı anlatım (2): soru ve rica aktarma | `dilbilgisi/G-B2-03-reported-questions-commands/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B2-04 2. tip koşul (second conditional): gerçek dışı şimdi | `dilbilgisi/G-B2-04-second-conditional/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, kanca gerçek cümle değil, EN örnek sesi eksik |
| B2-05 3. tip koşul (third conditional): olmayan geçmiş | `dilbilgisi/G-B2-05-third-conditional/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B2-06 wish ve if only: dilek ve pişmanlık | `dilbilgisi/G-B2-06-wish-if-only/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, kanca gerçek cümle değil, EN örnek sesi eksik |
| B2-07 Geçmişe dair çıkarım: must have, can't have, might have | `dilbilgisi/G-B2-07-past-modals-deduction/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B2-08 Present perfect continuous: have been + -ing | `dilbilgisi/G-B2-08-present-perfect-continuous/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, kanca gerçek cümle değil, EN örnek sesi eksik |
| B2-09 Tanımlamayan sıfat cümlecikleri: virgüllü who, which, whose | `dilbilgisi/G-B2-09-non-defining-relatives/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| B2-10 Ettirgen yapı (causative): have ya da get something done | `dilbilgisi/G-B2-10-causative/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, kanca gerçek cümle değil, EN örnek sesi eksik |
| B2-11 Gelecekte süren ve bitmiş eylem: will be doing, will have done | `dilbilgisi/G-B2-11-future-continuous-perfect/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, kanca gerçek cümle değil, EN örnek sesi eksik |
| B2-12 Zıtlık bağlaçları: although, despite, however, whereas | `dilbilgisi/G-B2-12-contrast-linkers/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, EN örnek sesi eksik |
| C1-01 Devrik yapı (inversion): Never have I…, Not only… | `dilbilgisi/G-C1-01-inversion/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-02 Vurgulu yapılar (cleft sentences): It was… that…, What I need is… | `dilbilgisi/G-C1-02-cleft-sentences/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-03 Karışık koşul cümleleri (mixed conditionals) | `dilbilgisi/G-C1-03-mixed-conditionals/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-04 Ortaç yan cümleleri (participle clauses): Having finished…, Walking home… | `dilbilgisi/G-C1-04-participle-clauses/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-05 Modal incelikleri: needn't have, be supposed to, would rather | `dilbilgisi/G-C1-05-modal-nuances/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-06 Kişisiz edilgen (impersonal passive): It is said that…, He is believed to… | `dilbilgisi/G-C1-06-impersonal-passive/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-07 Gerçek dışı geçmiş (unreal past): It's time…, would rather…, as if… | `dilbilgisi/G-C1-07-unreal-past/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C1-08 Eksiltme ve yerine koyma (ellipsis and substitution): So do I, I hope not | `dilbilgisi/G-C1-08-ellipsis-substitution/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, EN örnek sesi eksik |
| C2-01 Öne alma ve bilgi yapısı (fronting): Little did she know…, Such was… | `dilbilgisi/G-C2-01-fronting/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C2-02 Adlaştırma (nominalisation): resmî ve akademik yazı | `dilbilgisi/G-C2-02-nominalisation/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C2-03 Yumuşatma ve tutum (hedging and stance): It would appear that…, arguably | `dilbilgisi/G-C2-03-hedging-stance/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C2-04 Resmî dilek kipi ve if'siz şart (subjunctive, inverted conditionals): Should you…, Had I known… | `dilbilgisi/G-C2-04-formal-subjunctive/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C2-05 Bağdaşıklık ve söylem belirleyicileri (cohesion and discourse markers) | `dilbilgisi/G-C2-05-cohesion-discourse/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |
| C2-06 Görünüş incelikleri (aspect): She's being rude, I was wondering… | `dilbilgisi/G-C2-06-aspect-nuance/` | ☐ Onay ☐ Düzeltme | "Hikâyede gör" kartı yok, C1/C2 kapsama denetlenmedi, kanca gerçek cümle değil, EN örnek sesi eksik |

---

### 5.5 Keşfet (`reeller/`, `icerik/_evren/klipler/`)

**Ne:** İki tür kısa video var.
- **18 bağımsız reel** (A1 9 + A2 9; Sinema · Spor · Kitap). 11–13 sn, 3 replik, 3 seçenekli soru. Hepsi `DRAFT`. Teknik ve ilk içerik değerlendirmesi yapıldı; P1 hataları düzeltildi (7 reel sürüm 2).
- **17 Sezon 1 bölüm klibi** (B1–B4'ten kesit; 15'inde soru). Dosya `DRAFT`. Kural: klip yalnızca editörün onayladığı bölümden yayınlanır, bu yüzden önce §5.1'deki B1–B4 onayı gerekir.

**Önce okuyun:** `docs/H-094-REEL-ON-DEGERLENDIRME-2026-10-23.md` (özellikle §2 P3 ve §4 C; tekrar etmiyoruz), `docs/REEL-PAKETI.md`, `devam-edenler/H-094-kesfet-gunluk-uc-video.md`, `docs/BOLUM-PAKETI.md` (klip kuralları).

**Bir reelde nereye bakılır:** `reeller/<id>/<id>.mp4` (izle) · `reel.json` (`titleTr`, `learningObjective`, `target`, `practice` = soru, `cues` = replik ve Türkçesi, sözlük).

**Kontrol maddeleri:**
- [ ] Replik doğal; sahne mantığı tutarlı (kim konuşuyor, ne yapıyor).
- [ ] Türkçe altyazı ve başlık doğal ve somut.
- [ ] Soru tek doğrulu; Türkçe soru cümlesi düzgün.
- [ ] Sözlük karşılığı bağlama uygun.
- [ ] **Kapsama %95 altındaysa** (A seti düzeltmelerinden sonra 6 reel; tabloda işaretli): seviye üstü kelime sözlükte ve görselle destekli mi? Kabul ya da sadeleştirme kararı editörün.
- [ ] Görsel: el/yüz kusuru, boş tabela/afiş, görselde yazı.

| Reel | Yol | Sürüm | Durum | Not (H-094'ten açık kalan) |
|---|---|---|---|---|
| A1-R-BOK-01 Kütüphanede kitap seçimi | `reeller/A1-R-BOK-01/reel.json` | v1 | ☐ Onay ☐ Düzeltme | |
| A1-R-BOK-02 Beğeni | `reeller/A1-R-BOK-02/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Başlık "Beğeni" soyut (H-094 P3) |
| A1-R-BOK-03 Sessizlik ricası | `reeller/A1-R-BOK-03/reel.json` | v2 | ☐ Onay ☐ Düzeltme | |
| A1-R-CIN-01 Gişede iki bilet | `reeller/A1-R-CIN-01/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Kapsama %92,9: "film" (sözlükte) — editör kararı |
| A1-R-CIN-02 Salonda yer arıyor | `reeller/A1-R-CIN-02/reel.json` | v2 | ☐ Onay ☐ Düzeltme | |
| A1-R-CIN-03 Atıştırmalık alıyor | `reeller/A1-R-CIN-03/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Kapsama %84,6: "popcorn" (görsel konu) — editör kararı |
| A1-R-SPO-01 Antrenmandan sonra su | `reeller/A1-R-SPO-01/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Kapsama %93,8: "rest" — editör kararı |
| A1-R-SPO-02 Sahada arkadaş | `reeller/A1-R-SPO-02/reel.json` | v2 | ☐ Onay ☐ Düzeltme | v2: konuşmacı düzeltildi; kapsama %91,7 "pass" — editör kararı |
| A1-R-SPO-03 Tribünde | `reeller/A1-R-SPO-03/reel.json` | v2 | ☐ Onay ☐ Düzeltme | |
| A2-R-BOK-01 Kütüphanede süre uzatma | `reeller/A2-R-BOK-01/reel.json` | v2 | ☐ Onay ☐ Düzeltme | "bring it back on Friday" ↔ "one more week" çelişkisi; sözlük due → "son ödeme günü" yanlış (H-094 P3) |
| A2-R-BOK-02 Konu anlatma | `reeller/A2-R-BOK-02/reel.json` | v1 | ☐ Onay ☐ Düzeltme | |
| A2-R-BOK-03 Öneri | `reeller/A2-R-BOK-03/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Kapakta silik karalama (H-094 P3) |
| A2-R-CIN-01 Filmden sonra | `reeller/A2-R-CIN-01/reel.json` | v1 | ☐ Onay ☐ Düzeltme | "We are outside the cinema now." doğal değil (H-094 P3) |
| A2-R-CIN-02 Tür seçimi | `reeller/A2-R-CIN-02/reel.json` | v2 | ☐ Onay ☐ Düzeltme | v2: afiş düzeltildi; "Yeni." üslubu (H-094 P3) |
| A2-R-CIN-03 Akşam planı | `reeller/A2-R-CIN-03/reel.json` | v1 | ☐ Onay ☐ Düzeltme | |
| A2-R-SPO-01 Antrenörün uyarısı | `reeller/A2-R-SPO-01/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Soru "Antrenör neye bakmasını söylüyor?" bozuk; sözlük train/keep (H-094 P3) |
| A2-R-SPO-02 Antrenman günü | `reeller/A2-R-SPO-02/reel.json` | v2 | ☐ Onay ☐ Düzeltme | v2: el düzeltildi; kapsama %92,9 "routine" — editör kararı |
| A2-R-SPO-03 Sonuç ve duygu | `reeller/A2-R-SPO-03/reel.json` | v1 | ☐ Onay ☐ Düzeltme | Kapsama %92,9 "score" — editör kararı |

**Sezon 1 bölüm klipleri** (`icerik/_evren/klipler/S1.json`; her klipte `titleTr`, `target`, `grammar` bağı, `quiz`):

| Klip | Kaynak bölüm | Hedef | Durum | Not |
|---|---|---|---|---|
| S1-K01 Telsizde bir ses | A1-001 | *Can you hear me?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K02 Bir daha, lütfen | A1-001 | *Again, please.* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K03 Eski istasyon nerede? | A1-001 | *Where is…?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K04 Tanıştığımıza memnun oldum | A1-002 | *Nice to meet you.* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K05 Yeni komşu | A1-002 | *Are you new here?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K06 Nerelisin? | A1-002 | *Where are you from?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K07 Bu annem | A1-002 | *This is my…* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K08 Affedersiniz, istasyon nerede? | A1-002 | *Excuse me, where is…?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K09 Uzak mı? | A1-002 | *Is it far?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K10 Yol tarifi | A1-003 | *Go straight.* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K11 Kimse var mı? | A1-003 | *Is anybody here?* | ☐ Onay ☐ Düzeltme | quiz yok |
| S1-K12 Bugün günlerden ne? | A1-004 | *What day is it today?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K13 Bir not | A1-004 | *a note* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K14 Fri… ne demek? | A1-004 | *Friday* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K15 Saat kaç? | A1-004 | *What time is it?* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K16 3 numaralı iskele | A1-004 | *It's between…* | ☐ Onay ☐ Düzeltme | quiz var |
| S1-K17 İyi misin? | A1-004 | *Are you OK?* | ☐ Onay ☐ Düzeltme | quiz yok |

---

## 6. Notları nasıl geri verirsiniz?

1. **Föy üzerinde çalışın.** Bu dosyanın bir kopyasını (ya da çıktısını) kullanın. Her satırda bir kutu işaretleyin: ☒ Onay ya da ☒ Düzeltme.
2. **Düzeltme notunu kısa ve yerli yazın.** Biçim: `öğe · yer · şimdiki → önerilen · neden`.
   - Örnek: `A1-007 · s04 · "Kim biliyor?" → "Kim bilir?" · daha doğal`
   - Örnek: `G-A2-03 · alıştırma 2 · cevap B değil C · "since" süre değil başlangıç ister`
   - Yer olarak sahne/düğüm kimliğini (`s04`, `k1`), sayfa (`p03`), kart (`c02`) ya da satır numarasını kullanın.
3. **Emin değilseniz** `?` ile işaretleyin. Bu sorular kullanıcıya gider.
4. **Föyü kullanıcıya verin.** Kullanıcı notları onaylar.
5. **Claude düzeltmeleri uygular:**
   - metni ve çeviriyi düzeltir;
   - ilgili lint'i yeniden koşar (§8) ve sonucu föye yazar;
   - ses ya da görsel yeniden üretim gerekiyorsa önce maliyeti gösterir ve onay alır;
   - onayı kaydeder: `ceviri.tr.json` → `status`, dilbilgisinde `lesson.json` → `teacherReview`, ilgili `rights-and-review.md` onay geçmişi (tarih, kim, sonuç).
6. **Yayın onayı** backend'de editör hesabıyla verilir. `APPROVED` kontrolü backend'dedir (K-05).

Kapsam dışı bir şey görürseniz (yeni özellik, ekran önerisi) föyün sonuna "Diğer" başlığıyla yazın. Bu notlar ayrı karar olarak kullanıcıya sunulur.

## 7. Bilinen açık noktalar

Bunlar **inceleme engeli değildir.** Editör bilsin diye yazıldı.

1. **Eksik İngilizce sesler.** ElevenLabs hesabı `401 detected_unusual_activity` ile engelli (`docs/HANDOFF-2026-10-30.md` §2.2). Sesler metinden incelenir.
   - Kitaplar: 30 kitabın 24'ünde ses yok. Sesli olanlar (bütün bölümleri): A1-K01…K05 (A1-K02 2026-10-30'da) ve A2-K03.
   - Dilbilgisi: 36 dersin İngilizce örnek sesi eksik ya da kısmi (B1 10, B2 12, C1 8, C2 6; G-B1-01 kısmi). A1'in 16 ve A2'nin 15 dersi tam (2026-10-30). Türkçe anlatım sesleri hepsinde hazır.
2. **A1-K01 *The Blue Door*:** "Her heart is fast." → "Her heart beats fast." düzeltmesi 2026-10-30'da c3 sesiyle birlikte yapıldı. "live on floor four" / "on floor four" → "on the fourth floor" bekliyor: metin değişince c1/c2 sesi geçersiz olur (book-align HATA), bu yüzden ses yeniden üretilince birlikte yapılacak. Önerilen biçim "Lina and Mum live on the fourth floor." (A1 sınırı 8 sözcük; `fourth` sözlüğe eklenmeli). Editör bu iki cümleyi değerlendirir.
3. **Bölüm `rights-and-review.md` dosyaları 2026-10-30'da eklendi** (`icerik/A1-000`…`A1-012`, 13 dosya; K-01). Depodaki kayıtlardan derlendi: kaynaklar, AI açıklaması, güvenlik notu, §7.2 kontrol listesi (hiçbir madde işaretli değil) ve onay geçmişi. Bölümlerin `content.json` dosyasında hâlâ `status: DRAFT`, `humanReviewed: false`, `rightsStatus: PENDING`; editör onayı **bekliyor**. Doğrulanamayan noktalar dosyalarda "doğrulanmadı" diye işaretli (ör. B5–B12 İngilizce replik seslerinin ElevenLabs hesabı/planı, Higgsfield çıktılarının ticari kullanım koşulu). Editör onayı verildiğinde bu dosyaların onay geçmişine yazılır.
4. **Kitap onay geçmişi tabloları 2026-10-30'da güncellendi.** 30 kitabın hepsinde metin ve çeviri onayı `ceviri.tr.json` `APPROVED` kaydına göre "Onaylandı", görseller `PROMPTS.md` üretim kayıtlarına göre "Üretildi" (GPT Image 2.5, 2026-10-14) yazıyor; ses satırı 6 sesli kitapta (A1-K01…K05, A2-K03) "Üretildi", 24 kitapta "Bekliyor". Editör toplu kontrolü bütün kitaplarda **bekliyor**. Not: bazı kitapların `PROMPTS.md` ses bölümü başlığında eski "Henüz üretilmedi" cümlesi duruyor; altındaki kayıt tablosu geçerlidir.
5. **C1/C2 kapsaması otomatik denetlenmiyor.** Octanove C1/C2 listesi depoda yok. 10 kitap ve 14 derste seviye kararı tamamen editördedir.
6. **Dilbilgisi kanca ve "Hikâyede gör" eksikleri.** 19 derste kanca hikâyeden ya da kitaptan gerçek bir cümle değil; 31 derste "Hikâyede gör" kartı yok. `G-A2-07` hikâye bağı üretilmemiş prologa (A1-000) gidiyor. Editör bu dersleri anlatım açısından yine onaylayabilir; bağ eksikleri ayrıca tamamlanır.
7. **Keşfet reellerinde H-094 P3 maddeleri açık.** `A2-R-BOK-01` "on Friday" ↔ "one more week" çelişkisi ve `due` sözlüğü, `A2-R-CIN-01` sahne cümlesi, `A2-R-SPO-01` soru cümlesi, `A1-R-BOK-02` başlığı. Ayrıntı reel tablosunda.
8. **Görsel yüz kimliği kayması** (reellerde ELIF, MERT, KEREM) bilinçli olarak ertelendi (H-094 §4 C). Not düşülebilir; tek başına düzeltme gerekçesi değildir.
9. **Prolog A1-000** üretilmedi; inceleme dışı.
10. **H-085 / H-086 kullanıcı denemesi** ayrı iştir; editör incelemesini beklemez.

## 8. Teknik kontrol (lint) sonucu

2026-10-30'da `e22e5d2` üzerinde, depo kökünden koşuldu. Uyarılar sayılarıyla aşağıda; **hata yok.**

```bash
P=tools/content-pipeline/.venv/bin/python
$P tools/content-pipeline/content_lint.py icerik/A1-0*      # bölüm + konu seti + Hi verisi + klip + Konuş
$P tools/content-pipeline/book_lint.py kitaplar/*-K*
$P tools/content-pipeline/grammar_lint.py dilbilgisi/G-*
$P tools/content-pipeline/reel_lint.py reeller/*-R-*
```

| Lint | Kapsam | Hata | Uyarı | Uyarıların dağılımı |
|---|---|---|---|---|
| `content_lint` | 13 bölüm, 4 konu seti, 3 Hi dosyası, 1 klip dosyası, 6 Konuş görevi | **0** | 27 | çeviri DRAFT/yok 9 · Konuş DRAFT 6 · kapsama 4 · liste dışı kelime 3 · klip DRAFT 2 · set kapsaması 1 · Konuş kapsaması 1 · Türkçe ses hizası 1 |
| `book_lint` | 30 kitap | **0** | 148 | İngilizce ses yok 138 · C1/C2 kapsama denetlenmedi 10 |
| `grammar_lint` | 71 ders | **0** | 792 | İngilizce örnek sesi eksik 727 · "Hikâyede gör" kartı yok 31 · kanca 19 · C1/C2 kapsama 14 · hikâye bağı 1 |
| `reel_lint` | 18 reel | **0** | 0 | — |

- Dört komutun çıkış kodu 0.
- Bu sayılar `docs/HANDOFF-2026-10-30.md` §5'teki son doğrulamayla (kitap 30/0, dilbilgisi 71/0) uyumludur.
- Not: `reel_lint` kapsama denetlemiyor (H-094 §4 B); reel kapsama sayıları H-094 belgesinden alındı.
- Editör düzeltmelerinden sonra aynı dört komut yeniden koşulur ve sonuç bu bölüme eklenir.

## 9. Bağlantılar

| Belge | Neden |
|---|---|
| `CLAUDE.md` | Bağlayıcı kurallar, seviye tablosu, K-01…K-35, H-kararları |
| `docs/BOLUM-URETIM-REHBERI.md` | Bölüm üretim ve kapanış listesi (§5 çeviri, §7 editör onayı) |
| `docs/BOLUM-PAKETI.md` | Bölüm, klip, Konuş ve konu seti biçimi; lint kuralları |
| `docs/OYUN-TASARIMI.md` | Bölümler arası bağ kuralları (§4.3), karar anı ve ipucu tasarımı |
| `docs/ARAYUZ-METINLERI.md` | Türkçe üslup ilkeleri (§1), Konuş metinleri (§7.2) |
| `docs/KITAPLIK.md` | Kitap paketi, akış, anlama soruları |
| `docs/DILBILGISI.md` | Ders yapısı, içerik akışı (§5), ses |
| `docs/H-094-REEL-ON-DEGERLENDIRME-2026-10-23.md` | Reellerin teknik ve içerik ön değerlendirmesi |
| `docs/IS-PLANI.md` §5.5 · `docs/SARTNAME.md` §7.2 | Kalite ve yayın kontrol listeleri |
| `devam-edenler/H-085-bolum-5-12-uretimi.md` · `H-086` · `H-094` | Açık işlerin durumu |
| `bitenler/H-028-onay-ve-icerik-kapasitesi.md` | Onay süreci kararı |
| `icerik/<bölüm>/rights-and-review.md`, `kitaplar/<kitap>/rights-and-review.md`, `dilbilgisi/<ders>/rights-and-review.md` | Haklar ve onay geçmişi |
