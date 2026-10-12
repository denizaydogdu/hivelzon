# İş Sırası — hiVelzon

> Son güncelleme: 2026-10-11 · Güncelleyen: Claude

Bu dosya tek takip noktasıdır. Hangi işin hangi sırada yapıldığını, şu an ne üzerinde çalışıldığını ve neyin bittiğini gösterir. Her işin ayrıntısı kendi `H-<numara>-<başlık>.md` dosyasındadır.

## Nerede kaldık
- **Şu an:** Planlama, Faz 0. Kod yok.
- **Şimdi yapılan (ara verildi 2026-10-11 gece):** `h-046-altyazi-anlam` dalında H-046 kodu bitti ve testli (flutter 63/63, pytest 53/53), **commit edilmedi**. Kaldığımız yer: (1) kullanıcı simülatörde çevirilere bakıp onay/düzeltme verecek; (2) panelde "Deftere ekle" kelimeye dokununca ekran altına düşüyor, düzeltilecek; (3) onaydan sonra `ceviri.tr.json` durumları APPROVED, tek commit: H-046 + H-047/H-048 belgeleri (CLAUDE.md, HI-ASISTAN-VE-KOC.md, UYGULAMA-PLANI.md). Sonra sırada H-035 (harita). Yerel içerik sunucusu: `python3 tools/dev-content-server/serve.py` (127.0.0.1:8787).
- **Sıradaki adım:**
  1. Kullanıcı 1. adımda kalan kararları verir. En kritikleri:
     - H-001 ve H-007: konuşma pratiği MVP'de mi, faz yapısı ne olacak?
     - H-028: içeriği kim onaylayacak, ilk 3 ayın kapasitesi ne?
     - İçerik mimarisi kararları (H-026) verildi.
  2. H-029 ve H-030 onaylandı. Sıradaki yazım işi H-032 (Claude, kodsuz).
- **Engel:** Kullanıcı kararları.

## Nasıl takip ediyoruz
- **İş dosyası nerede durur:** Durum değişince dosya klasör değiştirir:
  - başlanmamış iş `yapilacaklar/` klasöründe durur;
  - başlanınca `devam-edenler/` klasörüne taşınır;
  - kabul kriterleri doğrulanınca `bitenler/` klasörüne taşınır.
- **Her durum değişikliğinde:**
  - aşağıdaki tablodaki durum güncellenir;
  - H dosyasının `Durum` satırı güncellenir;
  - **Günlük** bölümüne bir satır eklenir.
- **Biten işler:** "Biten işler" tablosuna doğrulama kanıtıyla birlikte yazılır.
- **Numaralar:** Tek sayaçla verilir. Sıradaki boş numara: **H-051**.

**Durum simgeleri:**
- ⛔ Kullanıcı kararı bekliyor
- ⏳ Sırada (başlanabilir ya da bağımlılık bekliyor)
- 🔄 Devam ediyor
- ✅ Bitti (doğrulandı)
- ⏸ Ertelendi

## Sıra

### Adım 1 — Kararlar (kullanıcı)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 1 | H-001 | İş planını gözden geçir ve onayla | Yüksek | H-007 ile birlikte | ⛔ |
| 2 | H-007 | Plan ile şartname arasındaki çelişkileri uzlaştır (konuşma pratiği MVP'de mi?) | Yüksek | H-001 ile birlikte | ✅ |
| 1a | H-029 | **Oyun ve hikâye tasarımı kararları** (`OYUN-TASARIMI.md` §17) | Yüksek | — | ✅ |
| 2a | H-026 | İçerik mimarisi kararları (`ICERIK-MIMARISI.md` §14) | Yüksek | H-007 ile birlikte | ✅ |
| 2b | H-028 | İçerik onayı, roller ve kapasite | Yüksek | H-004 | ✅ |
| 3 | H-002 | Yaş politikası | Yüksek | — | ✅ |
| 4 | H-003 | Yapay zekâ aylık bütçe tavanı ve kotalar | Yüksek | — | ⛔ |
| 5 | H-006 | Yapay zekâ sağlayıcıları ve yurt dışı aktarım | Yüksek | — | ⛔ |
| 6 | H-008 | Ham ses ve transkript saklama politikası | Yüksek | H-006 | ⛔ |
| 7 | H-004 | Higgsfield planı ve video üretim emeği | Yüksek | — | ✅ |
| 8 | H-005 | Yapay zekâ öğretmen karakteri | Yüksek | — | ✅ |
| 9 | H-018 | Mağaza yayın bölgesi | Orta | H-002 | ✅ |
| 10 | H-009 | Misafir kullanım ve kayıt zorunluluğu | Orta | H-002 | ✅ |
| 11 | H-013 | Günlük hedef, seri ve bildirim politikası | Orta | H-007 | ✅ |
| 12 | H-014 | Kısa video akışının davranışı | Orta | — | ✅ |
| 13 | H-015 | Konuşma geri bildirimi ve telaffuz puanının güvenilirliği | Orta | H-006, H-007 | ⛔ |
| 14 | H-016 | Marka ve görsel kimlik | Orta | H-005 | ⛔ |
| 16 | H-011 | İçerik yönetim ve editör onay paneli | Orta | H-021, H-022 | ✅ |
| 17 | H-012 | Medya depolama ve CDN | Orta | H-021 | ✅ |
| 18 | H-010 | Çevrimdışı kullanım MVP'de olacak mı? | Düşük | H-012 | ✅ |
| 19 | H-017 | Sosyal medya yayın kapsamı | Düşük | — | ✅ |
| 20 | H-020 | Reklam yok kararı | Düşük | — | ✅ |

### Adım 2 — Kodsuz inceleme (Claude; kararları beklemeden yapılabilir)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 22 | H-022 | videoGenerator sınıflarının incelemesi (yalnızca okuma) | Yüksek | — | ✅ |
| 22a | H-027 | Kelime listesi ve içerik lisanslarının doğrulanması (hukuk görüşü gereken maddeler kullanıcıya) | Yüksek | — | ✅ |

### Adım 3 — Plan güncellemesi ve pilot
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 22b | H-030 | Story Bible, karakter kitabı ve Sezon 1 bölüm planı (Claude yazar; kredisiz) | Yüksek | H-029 | ✅ |
| 22c | H-032 | Sezon 1 diyalog taslakları B4–B12 (A1 denetimli; kodsuz) | Yüksek | H-030 | ✅ |
| 23 | H-023 | İş planını şartnameyle ve oyun yönüyle güncelle | Yüksek | H-007, H-026, H-029 | ⏳ |
| 24 | H-024 | Pilot: S1·B1 "A Strange Message" etkileşimli bölüm + 3 klip (kredi harcar, onaylı) | Yüksek | H-004, H-005, H-026, H-027, H-028 | ✅ |

### Adım 4 — Uygulama planı
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 25 | H-047 | Hi asistanı ve koç kararları | 2026-10-11 | Kullanıcı soru-cevap kararı; `docs/HI-ASISTAN-VE-KOC.md` v0.2; CLAUDE.md'ye işlendi |
| H-031 | Etkileşimli bölüm oynatıcısı | 2026-10-11 | flutter test 51/51; B1–B4 simülatörde baştan sona; geçiş 35–131 ms, siyah kare yok; kaldığın yerden devam. Android ölçümü H-043'e taşındı (kullanıcı kararı) |
| H-034 | Bölüm paketi ve content-lint | 2026-10-11 | pytest 43/43; lint 13 bölüm temiz (7 uyarı); B1–B4 paketleri, senkron ≤ 0,01 sn, -16 LUFS, 29–48 MB |
| H-045 | Arayüz tasarım yönü | 2026-10-11 | Kullanıcı onayı ("devam"). 6 taslak, 6 kr; tema belirteçleri Flutter'a işlendi, testler yeşil |
| H-033 | Repo iskeleti | 2026-10-11 | `flutter analyze` temiz, `flutter test` 1/1; `mvn test` 2/2 (Testcontainers); iOS simülatöründe 5 sekme; `/actuator/health` UP |
| H-025 | Faz 1 (MVP) uygulama planı | Yüksek | H-001, H-007, H-023, H-029 | ✅ |

Plan: `docs/UYGULAMA-PLANI.md`. Kod yazımı H-025 onaylandıktan sonra başlar.

### Adım 5 — Faz 1 (MVP) uygulaması (kod)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 1.0 | H-033 | Repo iskeleti (mobil + backend) | Yüksek | H-025 | ✅ |
| 1.1 | H-034 | Bölüm paketi formatı, dışa aktarma, content-lint | Yüksek | H-033 | ✅ |
| 1.2 | H-031 | Etkileşimli bölüm oynatıcısı | Yüksek | H-033, H-034 | ✅ |
| 1.2b | H-046 | Altyazıya dokun → Türkçe anlam (kademeli panel) | Yüksek | H-031 | 🔄 |
| 1.2c | H-050 | Bölüm açılışı (4 katman) ve Hi'nin konu tanıtımı | Orta | H-049, H-046 | ⏳ |
| — | H-049 | Sezon 1 jeneriği (bir kez, ~6,4 kr) | Orta | — | 🔄 |
| 1.3 | H-035 | Hikâye haritası, bölüm kapısı, yerel ilerleme | Yüksek | H-031 | ⏳ |
| 1.4 | H-036 | Defter, ipucu panosu, FSRS | Yüksek | H-035 | ⏳ |
| 1.4b | H-048 | Hi-A: yönlendiren Hi (balon + kural tabanlı koç) | Yüksek | H-036, H-046 | ⏳ |
| 1.5 | H-037 | Backend çekirdek | Yüksek | H-033 | ⏳ |
| 1.6 | H-038 | Mobil ↔ backend, misafir modu | Yüksek | H-035, H-037 | ⏳ |
| 1.7 | H-039 | Onboarding ve yerleştirme | Orta | H-038 | ⏳ |
| 1.8 | H-040 | Keşfet akışı | Orta | H-038 | ⏳ |
| 1.9 | H-041 | Editör onay ekranı, içerik içe aktarma | Orta | H-038 | ⏳ |
| 1.10 | H-042 | Profil, ayarlar, hukuki metinler | Orta | H-038 | ⏳ |
| 1.11 | H-043 | Kalite ve iç beta hazırlığı | Orta | H-039 … H-042 | ⏳ |
| — | H-045 | Arayüz tasarım yönü (6 ekran taslağı, 6 kr) | Orta | H-033 | ✅ |
| 1.12 | H-044 | Dış hesaplar, barındırma ve mağaza (en son) | Orta | H-043 | ⏳ |

## Devam eden işler
| İş | Başlık | Başlangıç | Not |
|---|---|---|---|

## Biten işler
| İş | Başlık | Bitiş | Doğrulama |
|---|---|---|---|
| — | İş planı ve proje iskeleti | 2026-10-11 | 13 bölüm, 22 kaynak; GitHub'a gönderildi |
| — | Ürün/teknik şartname kaydı ve CLAUDE.md güncellemesi | 2026-10-11 | `docs/SARTNAME.md` eklendi; commit `15198a2`, GitHub'a gönderildi |
| — | İçerik mimarisi web araştırması ve sentez | 2026-10-11 | 5 araştırma kolu + kullanıcının içerik stratejisi → `docs/ICERIK-MIMARISI.md` (20 karar, kaynaklı) |
| H-026 | İçerik mimarisi kararları | 2026-10-11 | Kullanıcı onayı ("onayladım"). K-01…K-16 ve K-20 CLAUDE.md'ye işlendi. |
| H-011 | İçerik yönetim ve editör onay paneli | 2026-10-11 | K-12: içerik kod olarak + ince Spring onay ekranı |
| H-012 | Medya depolama ve CDN | 2026-10-11 | K-13: Bunny Stream (adaptör arkasında). KVKK bildirimi hukukçu teyidi bekliyor. |
| H-014 | Kısa video akışının davranışı | 2026-10-11 | K-15: quiz ve mola kartları, 13–17 yaş için 20 dk sınır |
| H-022 | videoGenerator sınıflarının incelemesi | 2026-10-11 | `docs/VIDEOGENERATOR-RAPORU.md`; videoGenerator `git status` temiz |
| H-032 | Sezon 1 diyalogları B4–B12 | 2026-10-11 | Kullanıcı onayı. A1 %95,7–99,0; 8 kelimeyi aşan cümle yok; zincir tutarlı |
| H-024 | Pilot S1·B1 + 3 kısa klip | 2026-10-11 | Kullanıcı onayı. 17 kr (bölüm başı ~8,5). Önizleme v3 senkron ≤ 0,16 sn, -16 LUFS. D-001 dersleri. |
| H-030 | Story Bible ve Sezon 1 planı | 2026-10-11 | Kullanıcı onayı. Aleyna "Alex", birimsiz fiyat. `icerik/_evren/` + prolog ve B1–B3 (A1 %96–98) |
| H-029 | Oyun ve hikâye tasarımı kararları | 2026-10-11 | Kullanıcı onayı; K-21…K-35 CLAUDE.md'ye işlendi |
| H-025 | Faz 1 (MVP) uygulama planı | 2026-10-11 | Kullanıcı onayı. `docs/UYGULAMA-PLANI.md`; H-033…H-043 açıldı |
| H-027 | Lisans doğrulaması | 2026-10-11 | `docs/LISANS-RAPORU.md`. CEFR-J v1.6 omurga; EVP/EGP kullanılmaz; hukukçuya 12 soru |

## Günlük
- **2026-10-11:**
  - Kullanıcı hiVelzon'u duyurdu: yapay zekâ videolarıyla İngilizce öğrenme; hazır videolar, konuşma pratiği, kişiselleştirme, kısa video akışı; herkes; ücretsiz; "şimdilik sadece iş planı, kodlama yok".
  - Plan yazıldı ve GitHub'a gönderildi.
  - Kullanıcı ayrıntılı ürün/teknik şartname taslağını (0.1) paylaştı → `docs/SARTNAME.md`. CLAUDE.md'ye belge hiyerarşisi, ürün ve mühendislik ilkeleri ile plan–şartname çelişkileri eklendi (konuşma pratiğinin MVP'deki yeri, faz yapısı, seviye testi, günlük hedef, seri, telaffuz puanı). Çelişkiler H-001 onayında çözülecek.
  - Klasör çakışması: başka bir oturum `~/Dev/hiVelzon`'u görsel atölye sanmıştı. Kullanıcı kararıyla atölye `~/Dev/velzon-gorsel`e taşındı (o oturum taşıdı, hiçbir şey silinmedi).
  - Kullanıcı isteğiyle her iş için `yapilacaklar/` altında H dosyası açıldı (H-006…H-025); `IS-SIRASI.md` adımlı takip tablosuna çevrildi.
    - **Numara düzeltmesi:** H-006 eskiden burada "Faz 1 uygulama planı" idi, `IS-PLANI.md` §13.2 ise H-006'yı sağlayıcılar için kullanıyordu. Plana uyuldu: H-006 artık sağlayıcılar, Faz 1 planı H-025 oldu.
  - Kullanıcı isteğiyle içerik yapısı internetten araştırıldı. Beş kol: müfredat ve lisanslar, seviye takibi, ekranlar, yayın ve dağıtım, formatlar ve seriler. Kullanıcı kendi bulduğu içerik stratejisi belgesini de paylaştı → `docs/ICERIK-STRATEJISI.md`.
    - Sentez: `docs/ICERIK-MIMARISI.md`. Yeni işler açıldı: H-026 (karar), H-027 (lisans doğrulaması), H-028 (onay ve kapasite).
    - H-005, H-011…H-015 ve H-017'ye araştırma notları eklendi.
    - Öne çıkan bulgular:
      - LLM'e istenen seviyede metin yazdırmak güvenilir değil (Uchida 2025: istenen seviyede çıkan metin %5–12,5). Deterministik seviye denetçisi şart.
      - EVP, Oxford ve GSE listeleri yalnızca referans olabilir; omurga CEFR-J olmalı.
      - CLAUDE.md'deki "%5 bilinmeyen kelime" kuralı ve "B2 ~4.000 kelime" değeri için düzeltme önerisi var (K-07).
  - Kullanıcı `ICERIK-MIMARISI.md` §14 önerilerini onayladı.
    - Onaylanan K-01…K-16 ve K-20 CLAUDE.md'ye işlendi: "Onaylı içerik mimarisi kararları" bölümü, CEFR tablosu (kelime havuzu, %98/%95 kapsama, CEFR-J omurgası) ve `content.json` + `rights-and-review.md` dosya yapısı.
    - Bitti ve `bitenler/`e taşındı: H-026, H-011, H-012, H-014.
    - Kısmen çözülüp açık kalanlar:
      - H-007: seviye testi çözüldü.
      - H-013: seri kısmı çözüldü.
      - H-017: yöntem kararı verildi.
    - `IS-PLANI.md` ve `SARTNAME.md` henüz güncellenmedi; H-023 kapsamında yapılacak.
  - Kullanıcı sıradaki adımı Claude'a bıraktı ("sen karar ver"). Ürün kararları kullanıcıda kalıyor. Kararları beklemeden yapılabilen kodsuz işler başlatıldı: H-021, H-022, H-027 (`devam-edenler/`).
  - Kullanıcı yeni bir yön belirledi: **oyunlaştırılmış hikâye.** Bir ana kahraman olacak, bölüm bölüm oyun gibi öğrenilecek ve her bölüm bir öncekine bağlanacak. Kullanıcı ayrıca Storyworld belgesini paylaştı (*The Missing Signal*, Alex).
    - Kaydedildi: `docs/HIKAYE-EVRENI.md`.
    - Sentez: `docs/OYUN-TASARIMI.md`. İçinde bağ sistemi (4 katmanlı yay, bağ şablonu, en fazla 3 açık soru, 3 bölüm kuralı), Sezon 1'in 12 bölümlük zinciri, ekranlar, veri modeli ve K-21…K-35 kararları var.
    - Oyun araştırması işlendi:
      - hibrit kahraman (karar anında POV);
      - sahne başına 1–2 karar anı;
      - haftalık yayın;
      - Flutter'da dallanan video paketi olmadığı için prototip gerekiyor.
    - Yeni işler: H-029 (karar), H-030 (Story Bible), H-031 (oynatıcı prototipi).
  - H-021 ve H-022 bitti. H-022 bulguları CLAUDE.md'ye işlendi:
    - `SceneImageService` OpenAI kullanıyor;
    - `loudnorm` ~-24 LUFS;
    - `BudgetGuard` tavan yoksa 100 USD varsayıyor.
    - **Risk:** videoGenerator'daki `TODO.md` dosyasında açık duran bir API anahtarı parçası kullanıcıya iletildi.
  - H-027 bitti. CEFR-J v1.6 (ticari kullanım atıfla serbest) doğrulandı. Cambridge EVP/EGP ticari lisans vermiyor → **kullanılmaz**. CEFR-J Grammar Profile yalnızca referans. CLAUDE.md ve ICERIK-MIMARISI güncellendi. Hukukçu soruları (S1–S12) ve yazılı teyit taslakları kullanıcıya iletildi; gönderilmedi.
  - Kullanıcı "onayladım" dedi: H-029 onaylandı (K-21…K-35 CLAUDE.md'de). K-02 → K-30 (sekme "Hikâye"), A1 video 45–90 sn. Bağ kuralları bağlayıcı hâle geldi. H-030 başladı. Dışa yazışmalar (Cambridge, Tono Lab, hukukçu) ayrı onay bekliyor.
  - H-030 taslağı yazıldı: Story Bible, karakterler, kanon (F-001…F-020), açık sorular denetimi, dil ilerlemesi, Sezon 1 planı (prolog + 12 bölüm), prolog ve B1–B3 diyalogları.
    - CEFR-J v1.6 indirildi (atıfla ticari kullanım serbest). Diyaloglar A1 listesine göre denetlendi: %96–98 A1, sözlükle %100; hiçbir cümle 8 kelimeyi aşmıyor.
    - Denetim sonucunda A2/B1 kelimeler A1 karşılıklarıyla değiştirildi.
    - Kullanıcıdan Alex'in adı ve cinsiyeti için karar ve taslak onayı bekleniyor.
  - Kullanıcı soru-cevapla karar verdi: Alex = **Aleyna "Alex" Yıldız** (kadın); Story Bible ve Sezon 1 onaylandı (kanon kilitli); S1'de fiyatlar birimsiz; commit ve push onaylandı. H-030 bitti; H-032 (B4–B12 diyalogları) açıldı.
  - Soru-cevap kararları (2. tur):
    - konuşma pratiği MVP'de yok (H-007);
    - içerik onayı: kullanıcı + dönemsel öğretmen (H-028 bitti);
    - AI tavanı 300 USD/ay (H-003; kota v1'de);
    - 13+, AI sohbet 18+ (H-002 bitti).
  - Soru-cevap kararları (3. tur):
    - birleşik 4 faz (K-17; H-007 bitti);
    - ad yazımı hiVelzon (belgeler çevrildi; kullanıcının olduğu gibi kaydedilen belgeleri hariç);
    - günlük hedef 5/10/15 (H-013 bitti);
    - misafir: prolog + B1 (H-009 bitti).
  - Soru-cevap kararları (4. tur):
    - yalnızca Türkiye (H-018);
    - reklam yok (H-020);
    - sosyal medya ayrı ve onaylı faz, elle yükleme (H-017);
    - çevrimdışı MVP'de yok (H-010).
    - Dördü de bitti.
  - Soru-cevap kararları (5. tur):
    - pilot mevcut kredilerle başlasın (H-024 başladı);
    - Hi ışıklı konuşma balonu olacak (H-005 bitti);
    - seslendirme ElevenLabs ile yapılacak. videoGenerator'daki hesap ücretsiz plan ve ticari lisans yok; o anahtar kullanılmaz. hiVelzon için ayrı, ücretli anahtar istendi (H-006);
    - dış yazışmalar şimdilik yok (H-027 notu).
  - H-024 pilot başladı.
    - Referanslar: GPT Image 2.5 seçildi (7,5 kr). B1 sahne testi 9:16 (1 kr), karakter tutarlılığı iyi. Kredi 117,75.
    - Kilit klip: Seedance 2.5 pahalı (5 sn = 15–35 kr); Mini ve Grok Lite 5 kr; yerel geçiş ücretsiz.
  - videoGenerator raporları geldi (`VIDEOGENERATOR-AI-SERVISLERI.md` alt ajandan; `VIDEOGENERATOR-GERCEK-MALIYET.md` VIDEO-INCELEME oturumundan):
    - yalnızca OpenAI ve ElevenLabs kullanılıyor;
    - ElevenLabs ücretsiz plan;
    - maliyetin ~%70'i görsel;
    - `TODO.md`'deki anahtar parçası AI servisine değil, Velzon piyasa verisi API'sine ait.
  - H-024 ilerlemesi:
    - B1 görselleri (2,5 kr);
    - kilit klip olarak Seedance Mini seçildi (5 kr);
    - ElevenLabs seslendirmesi (videoGenerator hesabı, ücretsiz plan, yalnızca iç pilot, kullanıcı onayı, 447 karakter);
    - B1 doğrusal önizleme videosu (65,7 sn, -16 LUFS, yerel kurgu).
    - Kredi 110,25.
  - Pilot bitti (H-024).
    - Kullanıcı geri bildirimleriyle iki düzeltme yapıldı: akıcılık (v2) ve ses-yazı senkronu (v3, zaman damgalı altyazı, ölçümle doğrulandı).
    - Explainer karşılaştırması kapandı (~187 kr).
    - Bölüm başına ~8,5 kr. Sezon 1 ≈ 60–100 kr; kalan 110 kr.
    - Ders: D-001.
  - Kullanıcı kararları: yerelde mevcut ElevenLabs hesabıyla devam (H-006 notu); Higgsfield 110 kr ile devam (H-004 bitti); H-032'yi Claude yapıyor.
  - H-032: B4–B12 taslakları yazıldı (3 ajan paralel).
    - Sezon denetimi: A1 %95,7–99,0; 8 kelimeyi aşan cümle yok; zincir ve açık sorular tutarlı.
    - B9 dilbilgisi ve hikâye boşluğu, B12 bayrak adı düzeltildi.
    - Kullanıcı onayı bekleniyor.
  - H-032 onaylandı ve bitti. Sıradaki: B2–B4 üretimi (kullanıcı kararı).
  - Kullanıcı: "Bu proje başka bir projeyle ilgili değil." Proje dışı bütün atıflar belgelerden temizlendi. H-019 ve H-021 (proje dışı konu) ve ilgili rapor kaldırıldı; git geçmişinde duruyor.
  - B2–B4 üretimi (kullanıcı onayı):
    - Maya referansı + 22 sahne (11,5 kr) + B4-01 yeniden üretimi (0,5 kr; Maya'nın kıyafeti yanlıştı). Kredi 98,25.
    - ElevenLabs: 75 satır, 2.314 karakter; yeni sesler Maya = Sarah, Mrs Brooks = Alice, adam = George.
    - B2–B4 önizlemeleri kurgulandı (78,8 / 67,9 / 98,9 sn; -16 LUFS; altyazı–ses farkı ölçümle doğrulandı).
  - Kullanıcı: içerik üretiminde burada durulsun, mobil uygulamaya fazlı başlansın. H-025 planı yazıldı (`docs/UYGULAMA-PLANI.md`, Faz 1.0–1.11). İşler H-033…H-043 açıldı; oynatıcı H-031 numarasını korudu. Kullanıcı onayladı (önce oynatıcı, iOS simülatörü); H-025 bitti.

  - Kullanıcı kararı: sunucu yeri, Bunny Stream hesabı ve Apple / Google geliştirici hesapları en sona bırakıldı. Yeni iş H-044 açıldı; o zamana kadar her şey yerelde (Docker PostgreSQL, yerel medya adaptörü, iOS simülatörü).
  - H-033 bitti: Flutter (`tr.velzon.hivelzon`, Riverpod 3, go_router 17) + Spring Boot 4.0.8 + PostgreSQL 17 (yerel port 5434) + CI. Testler yeniden çalıştırılıp doğrulandı.
  - H-045: Kullanıcı arayüz tasarımında Higgsfield/GPT kullanımına izin verdi. 6 ekran taslağı üretildi (GPT Image 2.5, 2k, 6 kr onaylı; kredi 92,25). Tasarım belirteçleri `tasarim/README.md`. Kullanıcı geri bildirimi bekleniyor.
  - H-045 onaylandı ve bitti; tema `mobile/lib/app/theme.dart`'a işlendi.
  - H-034 bitti: `tools/content-pipeline/` (dışa aktarma + content-lint), `docs/BOLUM-PAKETI.md`, bölüm başına `kurgu.json`. Editör onayı bekleyenler: Hi ipucu seviye 1–2 metinleri, A1-003 görev seçenekleri; sözlükte eksik: *yeah* (B5), *voice* (B7), *far* (B9).
  - Kullanıcı önerisi: altyazıya dokununca Türkçe anlam. Kararlar: kademeli panel, karar seçenekleri çevrilmez, çeviri Claude taslak + kullanıcı onayı, H-031'den hemen sonra. H-046 açıldı.
  - H-031 bitti (simülatör). Android bellek ve gerçek telefon ses–yazı kontrolü H-043'e taşındı. H-046 çeviri taslağı (B1–B4 `story.tr.md` + `ceviri.tr.json`) yazıldı, kullanıcı onayı bekliyor.
  - Kullanıcı önerisi: Hi her yerde (sağ alt balon) + AI sohbet + gelişimi izleyen ajan; yerel LLM/RAG mimarisi paylaşıldı. H-047 kararları: Hi-A MVP (AI yok), AI sohbeti v1 (yerel Ollama + RAG, üretim kararı H-044), 13–17 rehberli, öncelikler F1–F4. H-048 açıldı.
  - Kullanıcı ara verdi ("yarın devam ederiz"). H-046 commit'siz bekliyor; dal `h-046-altyazi-anlam`.
- **2026-10-12:**
  - Ortam yeniden açıldı (Colima, içerik sunucusu, simülatör). H-046 paneli düzeltildi: eylem düğmeleri altta sabit; flutter test 63/63.
  - Kullanıcı önerisi: konu başında animasyonlu video. Kararlar: bölüm başı + konu başı; 4 katmanlı açılış (önceki bölümde, kanca, jenerik bir kez, Hi tanıtımı; ≤ 30 sn, atlanabilir); önce senaryo ve kareler. H-049 (jenerik) ve H-050 (uygulama) açıldı. Jenerik, var olan telsiz klibini yeniden kullanıyor: tahmin 6,4 kr.
  - Jenerik üretildi (6,69 kr; kalan 85,56). Kullanıcı kararı: "Yapay zekâ ile üretilmiştir" uygulama içi videolara gömülmez; bölüm başında ~4 sn not. Sosyal medyada gömülü kalır (K-14). B1–B4 etiketsiz yeniden paketlendi; CLAUDE.md kural 6 güncellendi.
  - Kullanıcı: B1 başındaki "Friday." yazısı gereksiz. Soğuk açılıştaki yazı kaldırıldı (Alex hemen ardından "OK. Friday." diyor), çekim 3,8 → 2,5 sn. B1 yeniden paketlendi; senkron 0,003 sn; testler 63/63.
  - Kullanıcı kararı: her bölüm doğrudan bölüm başlığıyla açılır; öncesinde video/yazı/kart yok; görev kartı açılıştan kalktı (🎯 + bölüm sonu); tam jenerik sezon ilk açılışında. H-050 güncellendi, CLAUDE.md'ye işlendi.
