# İş Sırası — hiVelzon

> Son güncelleme: 2026-10-14 · Güncelleyen: Claude

Bu dosya tek takip noktasıdır. Hangi işin hangi sırada yapıldığını, şu an ne üzerinde çalışıldığını ve neyin bittiğini gösterir. Her işin ayrıntısı kendi `H-<numara>-<başlık>.md` dosyasındadır.

## Nerede kaldık
- **Şu an:** **Faz 1 (MVP) uygulaması sürüyor** (`docs/UYGULAMA-PLANI.md`, H-025 onaylı). Kod var: `mobile/` (Flutter), `backend/` (Spring Boot 4 iskeleti), `tools/content-pipeline/`, `tools/dev-content-server/`. Son commit `035f890` (H-035); `main` GitHub'da, CI yeşil.
- **Her şey yerelde** (kullanıcı kararı): Docker PostgreSQL (5434), yerel içerik sunucusu (`python3 tools/dev-content-server/serve.py`, 127.0.0.1:8787), iOS simülatörü "hiVelzon iPhone 17". Sunucu, Bunny Stream, mağaza ve geliştirici hesapları en sonda (H-044).
- **Biten uygulama işleri:** H-033 repo iskeleti · H-034 bölüm paketi + content-lint · H-045 tasarım yönü (6 taslak, 6 kr) · H-031 etkileşimli oynatıcı · H-046 altyazıya dokun → Türkçe anlam (B1–B4 çevirileri APPROVED) · H-047 Hi kararları · H-049 sezon jeneriği (6,69 kr) · H-050 başlıkla açılış (schemaVersion 2) · H-035 hikâye haritası + Drift ilerleme + kilit kuralı.
- **İçerik:** B1–B4 üretildi (pilot + B2–B4), jenerik, 6 arayüz taslağı, harita görseli. B5–B12 diyalogları onaylı (H-032) ama üretilmedi; kalan Sezon 1 üretimi ≈ 8 × ~8,5 kr. Higgsfield kredisi **84,56** (lite plan).
- **Sıradaki adım:** Tasarım yenilemesi (Adım 6): H-057, H-058, H-059, H-041 ve H-039, H-060, H-061 bitti H-062, H-063 bitti → **H-064** tasarım kalite turu, H-040 (Kitaplık H-065… paralel); sonra H-042 … H-044.
- **Kullanıcı kararı bekleyenler** (kodlamayı durdurmuyor):
  - H-001: güncellenen iş planının (`docs/IS-PLANI.md`, H-023) son onayı.
  - H-003: günlük konuşma kotasının ölçüsü, uyarı eşikleri, bütçe sorumlusu (tavan 300 USD/ay kararlaştı; v1 öncesi).
  - H-006: yayından önce ticari ElevenLabs hesabı; AI sohbet sağlayıcısı (v1).
  - H-008: ham ses ve transkript saklama (v1 öncesi).
  - H-015: telaffuz puanı gösterilecek mi.
  - H-016: logo, palet, tipografi, mağaza adı, "Port Lumen" ad kontrolü.
  - H-037 öncesi: giriş yöntemi (e-posta + parola mı, Apple / Google mı).
  - H-023: iş planı güncellemesi yapıldı (2026-10-12), kullanıcının gözden geçirmesini bekliyor.
- **Engel:** Yok. Dış hesaplar bilerek en sona bırakıldı.

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
- **Numaralar:** Tek sayaçla verilir. Sıradaki boş numara: **H-087**.

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
| 1 | H-001 | İş planını gözden geçir ve onayla (uygulama planı H-025 onaylı; güncel `IS-PLANI.md` onayı kaldı) | Yüksek | H-023 | ⛔ |
| 2 | H-007 | Plan ile şartname arasındaki çelişkileri uzlaştır (konuşma pratiği MVP'de mi?) | Yüksek | H-001 ile birlikte | ✅ |
| 1a | H-029 | **Oyun ve hikâye tasarımı kararları** (`OYUN-TASARIMI.md` §17) | Yüksek | — | ✅ |
| 2a | H-026 | İçerik mimarisi kararları (`ICERIK-MIMARISI.md` §14) | Yüksek | H-007 ile birlikte | ✅ |
| 2b | H-028 | İçerik onayı, roller ve kapasite | Yüksek | H-004 | ✅ |
| 3 | H-002 | Yaş politikası | Yüksek | — | ✅ |
| 4 | H-003 | Yapay zekâ aylık bütçe tavanı ve kotalar (tavan 300 USD/ay kararlaştı; kota ayrıntısı v1 öncesi) | Yüksek | — | ⛔ |
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
| 23 | H-023 | İş planını şartnameyle ve oyun yönüyle güncelle (belge güncellendi; kullanıcı onayı H-001'de) | Yüksek | H-007, H-026, H-029 | 🔄 |
| 24 | H-024 | Pilot: S1·B1 "A Strange Message" etkileşimli bölüm + 3 klip (kredi harcar, onaylı) | Yüksek | H-004, H-005, H-026, H-027, H-028 | ✅ |

### Adım 4 — Uygulama planı
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 25 | H-025 | Faz 1 (MVP) uygulama planı | Yüksek | H-001, H-007, H-023, H-029 | ✅ |

Plan: `docs/UYGULAMA-PLANI.md`. H-025 2026-10-11'de onaylandı; kodlama başladı (Adım 5).

### Adım 5 — Faz 1 (MVP) uygulaması (kod)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| 1.0 | H-033 | Repo iskeleti (mobil + backend) | Yüksek | H-025 | ✅ |
| 1.1 | H-034 | Bölüm paketi formatı, dışa aktarma, content-lint | Yüksek | H-033 | ✅ |
| 1.2 | H-031 | Etkileşimli bölüm oynatıcısı | Yüksek | H-033, H-034 | ✅ |
| 1.2b | H-046 | Altyazıya dokun → Türkçe anlam (kademeli panel) | Yüksek | H-031 | ✅ |
| 1.2c | H-050 | Bölüm açılışı: doğrudan başlık | Orta | H-049, H-046 | ✅ |
| — | H-049 | Sezon 1 jeneriği (6,69 kr) | Orta | — | ✅ |
| — | H-047 | Hi asistanı ve koç kararları (`docs/HI-ASISTAN-VE-KOC.md`) | Yüksek | — | ✅ |
| 1.3 | H-035 | Hikâye haritası, bölüm kapısı, yerel ilerleme | Yüksek | H-031 | ✅ |
| 1.4 | H-036 | Defter, ipucu panosu, FSRS | Yüksek | H-035 | ✅ |
| 1.4' | H-052 | Defter ince ayarı ("Listen.", sözlük filtresi) | Orta | H-036 | ✅ |
| 1.4' | H-053 | Arayüz metinleri ve sayfa netliği | Yüksek | H-036 | ✅ |
| 1.4'' | H-054 | Performans temeli (720p video, WebP, ölçüm) | Yüksek | H-053 | ✅ |
| 1.4a | H-051 | Hikâye mekânlarına bağlı konu setleri + sahne avı | Yüksek | H-036 | ✅ |
| 1.4b | H-048 | Hi-A: yönlendiren Hi (balon + kural tabanlı koç) | Yüksek | H-036, H-046 | ✅ |
| 1.4c | H-055 | "Söyle" alıştırmaları (S1, cihazda tanıma) | Yüksek | H-048 | ✅ |
| 1.5 | H-037 | Backend çekirdek | Yüksek | H-033 | ✅ |
| 1.6 | H-038 | Mobil ↔ backend, isteğe bağlı hesap | Yüksek | H-035, H-037 | ✅ |
| 1.6' | H-056 | Eşitleme ince ayarı (bitti kazanır, 30 sn hoşgörü, çıkışlı silme, sekme yenileme) | Yüksek | H-038 | ✅ |
| 1.7 | H-039 | Onboarding ve yerleştirme | Orta | H-038 | ✅ |
| 1.8 | H-040 | Keşfet akışı | Orta | H-038 | ✅ |
| 1.9 | H-041 | Editör onay ekranı, içerik içe aktarma | Orta | H-038 | ✅ |
| 1.10 | H-042 | Profil, ayarlar, hukuki metinler | Orta | H-038 | ⏳ |
| 1.11 | H-043 | Kalite ve iç beta hazırlığı | Orta | H-039 … H-042 | ⏳ |
| — | H-045 | Arayüz tasarım yönü (6 ekran taslağı, 6 kr) | Orta | H-033 | ✅ |
| 1.12 | H-044 | Dış hesaplar, barındırma ve mağaza (en son) | Orta | H-043 | ⏳ |

### Adım 6 — Tasarım yenilemesi (2026-10-14, kullanıcı isteği; sıra önemli)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| T0 | H-057 | Tasarım sistemi v2 (belirteçler, bileşen kitaplığı, hareket, yazı tipleri) | Yüksek | H-053, H-054 | ✅ |
| T1 | H-058 | Ekran taslakları v2 ve illüstrasyonlar (Higgsfield, ~8 kr) | Yüksek | H-057 | ✅ |
| T2 | H-059 | Profil, Hesap, "Hi benim hakkımda", hukuk metni tasarımı | Yüksek | H-057, H-058 | ✅ |
| T3 | H-060 | Ana Sayfa, harita, bölüm paneli, jenerik tasarımı | Orta | H-057, H-058, H-039 | ✅ |
| T3' | H-074 | Günlük hedef için gerçek süre ölçümü | Orta | H-060 | ⏳ |
| T4 | H-061 | Defter, Kelime tekrarı, Konu seti, Sahne avı tasarımı | Orta | H-057, H-058 | ✅ |
| T5 | H-062 | Oynatıcı katmanlarının tasarımı | Orta | H-057 | ✅ |
| T6 | H-063 | Hi'nin canlılığı (ifadeler, animasyonlar) | Orta | H-057 | ✅ |
| T7 | H-064 | Tasarım kalite turu (erişilebilirlik, golden, temizlik) | Orta | H-059 … H-063, H-040 | ✅ |

**Sıra:** H-057 → H-058 → H-059 → H-039 → H-060 → H-061 → H-062 → H-063 → H-040 → H-064 → H-041, H-042, H-043, H-044.

### Adım 7 — Kitaplık: seviyeli, resimli, sesli kitaplar (2026-10-14, kullanıcı isteği; `docs/KITAPLIK.md`)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| K0 | H-065 | Kitaplık kararları ve 30 kitaplık katalog | Yüksek | — | ✅ |
| K1 | H-066 | Kitap paketi ve içerik boru hattı (book-lint, C1/C2 listesi, TTS betiği) | Yüksek | H-065 | ✅ |
| K2 | H-067 | Kitaplık ve okuyucu (sesli/sessiz, cümle vurgusu, Defter'e ekle) | Yüksek | H-066 | ✅ |
| K3 | H-068 | Arka planda dinleme ve kilit ekranı | Orta | H-067 | 🔄 |
| K4 | H-069 | Pilot kitaplar A1 + A2 (≈ 15 kr görsel, maliyet onayı önce) | Yüksek | H-065, H-066, H-067 | ✅ |
| K5 | H-070 | Kitaplık arka ucu (BOOK, C2, onay) | Orta | H-066 | ✅ |
| K6 | H-071 | Kitap dalgası 1: A1 + A2 (kalan 8) | Orta | H-069 | 🔄 |
| K7 | H-072 | Kitap dalgası 2: B1 + B2 (10) | Orta | H-071 | 🔄 |
| K8 | H-073 | Kitap dalgası 3: C1 + C2 (10) | Orta | H-072 | ⏳ |
| K7' | H-084 | B2-K01 eksik bölüm başı görseli (p13), kredi yüklenince | Düşük | kredi | ✅ |
| K2' | H-086 | Kitap okuyucuda "Sayfanın Türkçesi" (panel + satır altı ayarı) | Orta | H-067 | 🔄 |
| S1 | H-085 | Sezon 1 Bölüm 5–12 üretimi (üretim bitti; simülatör denemesi + editör onayı bekliyor) | Yüksek | H-032, H-083 | 🔄 |

**Sıra:** H-065 hemen (belge + katalog) → H-066 ve H-067, tasarım fazlarıyla paralel, ayrı dallarda → H-069 pilot → resim yoğunluğu ve ses planı kararı → H-068, H-070 → H-071 → H-072 → H-073.

### Adım 8 — Dilbilgisi: Hi'den Türkçe konu anlatımı (2026-10-14, kullanıcı isteği; `docs/DILBILGISI.md`)
| # | İş | Başlık | Öncelik | Bağımlılık | Durum |
|---|---|---|---|---|---|
| D0 | H-075 | Türkçe ses: Alania + Duyu hizalama | Yüksek | — | ✅ |
| D0 | H-076 | Dilbilgisi müfredatı (~70 konu) | Yüksek | — | ✅ |
| D1 | H-077 | Ders paketi ve grammar-lint | Yüksek | H-075, H-076 | ✅ |
| D2 | H-078 | Dilbilgisi ekranı (Hikâye'de 3. bölüm, bölüm panelinde teklif) | Yüksek | H-077 | ✅ |
| D3 | H-079 | Pilot: 3 A1 konusu | Yüksek | H-076…H-078 | ✅ |
| D4 | H-080 | Dalga 1: A1 + A2 | Orta | H-079 | 🔄 |
| D5 | H-081 | Dalga 2: B1 + B2 | Orta | H-080 | 🔄 |
| D6 | H-082 | Dalga 3: C1 + C2 | Orta | H-081 | 🔄 |
| D0' | H-083 | Türkçe seslerin Alania'ya geçişi (Hi, Alex, babaanne, ipucu kartları, Hi paneli) | Yüksek | H-075 | ✅ |

**Sıra:** H-075 ve H-076 hemen ve paralel (Alania'nın ücretsiz ayı sınırlı) → H-077 → H-078 → H-079 → dalgalar.

## Devam eden işler
| İş | Başlık | Başlangıç | Not |
|---|---|---|---|
| H-023 | İş planını kararlarla güncelle | 2026-10-12 | `docs/IS-PLANI.md` v0.2 ve `docs/SARTNAME.md` karar notları yazıldı; kullanıcının gözden geçirmesi ve H-001 onayı bekleniyor |
| H-071 | Kitap dalgası 1: A1 + A2 (kalan 8) | 2026-10-14 | 8 kitabın metni, çevirisi (DRAFT), sözlüğü ve görsel planı (kapak + bölüm başı) yazıldı; book-lint 0 hata. Kullanıcı onayı, görsel ve ses bekleniyor |

## Biten işler
| İş | Başlık | Bitiş | Doğrulama |
|---|---|---|---|
| H-064 | Tasarım kalite turu | 2026-10-14 | Profil ve açılışta durum çubuğu şeridi, dar ekranda tek satır alt menü, Titreşim ayarı (tek yardımcıdan), bütün ekranlarda dokunma/etiket/kontrast + 320×568 1,3× testleri, sabit renk/yazı boyutu 0, Hi balonu katman olarak yüzer; flutter 924 |
| H-083 | Türkçe seslerin Alania'ya geçişi | 2026-10-14 | 44 klip (Hi f1, Alex nisa, babaanne selin, anlatıcı m1; İngilizce ifadeler Sarah), Hi panelinde "Hi'yi dinle", Türkçe klipler kendi -16 LUFS'u; kullanıcı onayladı |
| H-040 | Keşfet akışı | 2026-10-14 | 17 klip (B1–B4, ücretsiz kesim), quiz/mola kartları, günlük 20 dk sınırı (13–17 ve 13 altı), sonsuz kaydırma yok, bellek ölçümü sızıntısız; kullanıcı onayladı |
| H-079 | Dilbilgisi pilotu (3 A1 konusu) | 2026-10-14 | to be, a/an, -s; Türkçe Alania + İngilizce Sarah; lint 0 hata; simülatörde denendi; kullanıcı onayladı (öğretmen kontrolü yayından önce) |
| H-078 | Dilbilgisi ekranı | 2026-10-14 | Macera · Kitaplık · Dilbilgisi, ders kartları, puansız alıştırma, kural kartı → Defter/FSRS, bölüm/kitap panelinde teklif, "Bu yapı ne?", Hi önerisi, Drift v7 + V9; flutter 785, mvn 132; kullanıcı onayladı |
| H-063 | Hi'nin canlılığı | 2026-10-14 | 7 kodla çizilen ifade ve geçişler, sakin 3 nefes, bağlama göre ifade, bölüm sonunda mutlu Hi, Hi paneli bölündü (703 → 248 satır), renkler belirteçte; flutter 716/716; kullanıcı onayladı |
| H-077 | Ders paketi ve grammar-lint | 2026-10-14 | `lesson.json` + `lesson.md` biçimi, `grammar_lint.py`, `tts_lesson.py` (TR Alania+Duyu, EN ElevenLabs), `export_grammar.py`, dev sunucuda `/grammar/`, bölüm ve kitapta `grammarTopics`; pytest 212/212 |
| H-076 | Dilbilgisi müfredatı | 2026-10-14 | 71 konu, önkoşullar, Türkçeyle karşılaştırma, tipik hata, doğrulanmış hikâye bağları, bölüm → konu eşlemesi; kullanıcının genel onayı |
| H-075 | Türkçe ses: Alania + Duyu | 2026-10-14 | `tts_tr.py`: Alania TTS → Duyu kelime zamanları → `align.py` biçimi, -16 LUFS; varsayılan kuru çalışma, tavansız çalışmaz, idempotent, 429 bekleme, anahtar repo dışında; gerçek deneme 154 karakter; pytest 184/184 |
| H-062 | Oynatıcı katmanlarının tasarımı | 2026-10-14 | Oynatıcı ve anlam paneli yalnız belirteçlerle; ~45 metin l10n'de; karar kartı ve Hi paneli giriş animasyonları; sakin bölüm sonu; geçiş ve senkron testleri; flutter 691/691; kullanıcı onayladı |
| H-069 | Pilot kitaplar (A1 + A2) | 2026-10-14 | The Blue Door (metin, çeviri, 12 görsel, ses Sarah, 105 k/dk) ve The Parrot Who Told Everything (metin, çeviri, 15 görsel; ses Creator planıyla); 27 görsel 14 kr; simülatörde denendi, kullanıcı onayladı |
| H-067 | Kitaplık ve okuyucu | 2026-10-14 | Macera · Kitaplık, raflar, Bana bir kitap oku, okuyucu (sesli/sessiz, cümle vurgusu, otomatik sayfa, hız, uyku zamanlayıcısı), anlam paneli, Defter'e ekle (kaynak satırı), kitap ilerlemesi eşitlemesi (Drift v6, V8), Hi önerisi; flutter 649, mvn 126; kullanıcı onayladı |
| H-061 | Defter, Kelime tekrarı, Konu seti, Sahne avı tasarımı | 2026-10-14 | Tek satır biçimli Defter (kaynak satırı), sakin doğru/Bilmiyorum geri bildirimi + hafif haptic, özet StatRow + sakin kutlama, illüstrasyonlu boş durumlar, ortak DontKnowButton; flutter test 581/581; kullanıcı onayladı |
| H-066 | Kitap paketi ve içerik boru hattı | 2026-10-14 | `book.json`/`pages.json` şeması, `book_lint.py` (A1–C2, kapsama, cümle, çeviri, hizalama), `export_book.py` (-16 LUFS, WebP, manifest), `tts_book.py` (varsayılan kuru çalışma, tavansız çalışmaz, idempotent, anahtar yalnız ortamdan), dev sunucuda `/books/`; pytest 151/151 |
| H-065 | Kitaplık kararları ve 30 kitaplık katalog | 2026-10-14 | `kitaplar/KATALOG.md` (6 seviye × 5 tür) kullanıcı onaylı; pilot A1-K01 + A2-K03; yerleşim Hikâye sekmesinde "Macera · Kitaplık" |
| H-060 | Ana Sayfa, harita, bölüm paneli, jenerik tasarımı | 2026-10-14 | Hedef halkalı selam (aşılınca 10/10 + onay), dalga kesimli bölüm kartı, yeni harita başlığı, bir kez oynayan açılış ışığı, AppSheet paneli, metinler l10n'de; flutter test 531/531, CI yeşil; kullanıcı onayladı |
| H-039 | Açılış ve yerleştirme | 2026-10-14 | Hoş geldin → doğum yılı (saklanmaz; yalnız geçmemiş yaş eşiği) ve isteğe bağlı ad → bilgilendirme → hedef + Türkçe altyazı → atlanabilir kademeli test (22 madde, kullanıcı onaylı) → hazır; 13 altına hesap yok; bir kez gösterim; flutter test geçti, CI yeşil |
| H-059 | Profil, Hesap, Hi gizlilik, hukuk metni tasarımı | 2026-10-14 | Şekilli başlık, istatistik şeridi, gruplanmış ayarlar, tehlikeli bölge; golden testler (yalnız macOS) + belirteç kontrast testi; flutter test 464/464, CI yeşil; kullanıcı tasarımı onayladı |
| H-058 | Ekran taslakları v2 ve illüstrasyonlar | 2026-10-14 | 16 görsel (8 kr, `tasarim/v2/PROMPTS.md`), 6 illüstrasyon WebP olarak uygulamada; kullanıcı onayladı |
| H-057 | Tasarım sistemi v2 | 2026-10-14 | Nunito + Inter (gömülü, OFL, Türkçe glif testli), belirteçler, `shared/ui` bileşenleri, flutter_animate, /tasarim vitrini, golden + erişilebilirlik testleri; sabit renk 31 → 10; flutter test 439 → 463 (H-059 ile) |
| H-041 | Editör onay ekranı ve içerik içe aktarma | 2026-10-14 | Durum veritabanında (içe aktarma dokunmaz), lint özeti (`--write-reports`), 6 geçiş + kontrol listesi + iyimser kilit + denetim kaydı, `/admin` Türkçe ekran; zamanlanmış içerik tam zamanında görünür; mvn verify 121/121, pytest 112 geçti; gerçek B1–B4 paketleriyle ayrı veritabanında curl denemesi |
| H-056 | Eşitleme ince ayarı | 2026-10-14 | "Bitti" kazanır (sunucu + telefon), yenilemede 30 sn hoşgörü, çıkışlı Hi silme girişte işlenir, sekme yenileme hatası giderildi; flutter test 404/404, mvn verify 110/110 |
| H-038 | Telefon ↔ sunucu, isteğe bağlı hesap | 2026-10-13 | E-posta koduyla hesap, ilk aktarım, iki yönlü eşitleme, Hi silme her cihazda; hesapsız trafik yok; simülatörde iki cihaz denemesi; flutter test 389/389, mvn verify 97/97 |
| H-037 | Backend çekirdeği | 2026-10-13 | Kimlik (e-posta kodu, oturum, rıza, denetim, 30 gün silme) + katalog (ETag) + eşitleme (idempotent, LWW, transkript reddi) + FSRS Java (159/159); mvn verify 94/94; uçtan uca curl denemeleri |
| H-055 | "Söyle" alıştırmaları (S1) | 2026-10-13 | Cihazda tanıma (speech_to_text 7.4.0), 4 yer, puan yok, ses/metin saklanmıyor (testli); 2. denemede tam → Hard; flutter test 356/356. Simülatörde gerçek tanıma çalışmadı → gerçek cihaz H-043 |
| H-048 | Hi-A: yönlendiren Hi | 2026-10-13 | Balon + panel (tek öneri + gerekçe), "Bu ne demek?", haftalık özet, hata kataloğu (9), konu tanıtımı (5), yan görev (4), gizlilik ekranı; kullanıcı onayı; flutter test 281/281, pytest 120/120 |
| H-051 | Konu setleri ve sahne avı | 2026-10-13 | 4 set onaylı (Alex'in odası, Maya'nın dükkânı, Liman, Masadaki iki not); sahne avı (ipucu ilk yanlıştan sonra, yakınlaştırma); kredisiz; flutter test 232/232, pytest 106/106 |
| H-054 | Performans temeli | 2026-10-13 | İndirilen boyut −%60 (151,9 → 60,4 MB); senkron ≤ 0,01 sn; SSIM 0,98; iskelet görünümler; flutter test 205/205, pytest 77/77 |
| H-053 | Arayüz metinleri ve sayfa netliği | 2026-10-12 | `docs/ARAYUZ-METINLERI.md`; "Merhaba Deniz!", Hikâyen / Kelime tekrarı bölümleri; Profil'de isteğe bağlı ad; flutter test 193/193 |
| H-052 | Defter ince ayarı | 2026-10-12 | "Listen." ve 2 eksik anlam eklendi (kullanıcı onayı); sözlük filtresi; pytest 70/70 |
| H-036 | Defter, ipucu panosu, FSRS tekrarı | 2026-10-12 | flutter test 180/180; FSRS-6 py-fsrs 6.3.2 portu, 159 adım birebir; simülatörde taşıma, Bilmiyorum akışı, 10 dk yeniden öğrenme, ses doğrulandı |
| H-035 | Hikâye haritası ve kalıcı ilerleme | 2026-10-12 | flutter test 129/129, pytest 64/64; simülatörde temiz kurulum → B1 bitir → B2 açıldı → yeniden açılışta korundu; Drift; harita görseli 1 kr |
| H-046 | Altyazıya dokun → Türkçe anlam | 2026-10-12 | Kullanıcı çevirileri onayladı; B1–B4 `ceviri.tr.json` APPROVED; flutter test 63→86 |
| H-049 | Sezon 1 jeneriği | 2026-10-12 | Kullanıcı onayı; 6,69 kr; -16 LUFS; donmuş kare yok |
| H-050 | Bölüm açılışı: doğrudan başlık | 2026-10-12 | flutter test 86/86, pytest 62/62; B1–B4 başlıkla açılıyor; başlık→hikâye ~39 ms; schemaVersion 2 |
| H-047 | Hi asistanı ve koç kararları | 2026-10-11 | Kullanıcı soru-cevap kararı; `docs/HI-ASISTAN-VE-KOC.md` v0.2; CLAUDE.md'ye işlendi |
| H-031 | Etkileşimli bölüm oynatıcısı | 2026-10-11 | flutter test 51/51; B1–B4 simülatörde baştan sona; geçiş 35–131 ms, siyah kare yok; kaldığın yerden devam. Android ölçümü H-043'e taşındı (kullanıcı kararı) |
| H-034 | Bölüm paketi ve content-lint | 2026-10-11 | pytest 43/43; lint 13 bölüm temiz (7 uyarı); B1–B4 paketleri, senkron ≤ 0,01 sn, -16 LUFS, 29–48 MB |
| H-045 | Arayüz tasarım yönü | 2026-10-11 | Kullanıcı onayı ("devam"). 6 taslak, 6 kr; tema belirteçleri Flutter'a işlendi, testler yeşil |
| H-033 | Repo iskeleti | 2026-10-11 | `flutter analyze` temiz, `flutter test` 1/1; `mvn test` 2/2 (Testcontainers); iOS simülatöründe 5 sekme; `/actuator/health` UP |
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
| H-028 | İçerik onayı, roller ve kapasite | 2026-10-11 | Kullanıcı kararı: Claude üretir, kullanıcı onaylar; ünite sonunda öğretmen/editör toplu kontrolü. Kalan: öğretmenin kim olacağı |
| H-007 | Plan–şartname uzlaştırma | 2026-10-11 | Kullanıcı kararı: konuşma pratiği MVP'de yok; birleşik 4 faz (K-17) |
| H-002 | Yaş politikası | 2026-10-11 | Kullanıcı kararı: 13+, AI sohbeti 18+. Hukukçu teyidi bekliyor |
| H-004 | Higgsfield planı | 2026-10-11 | Kullanıcı kararı: lite plan ile devam; bölüm başı ~8,5 kr |
| H-005 | Öğretmen karakteri | 2026-10-11 | Kullanıcı kararı: Hi = ışıklı konuşma balonu ve gözler; Soul ID gerekmez |
| H-009 | Misafir kullanım | 2026-10-11 | Kullanıcı kararı: prolog + B1 kayıtsız; ilerleme için hesap |
| H-010 | Çevrimdışı kullanım | 2026-10-11 | Kullanıcı kararı: MVP'de yok (F3) |
| H-013 | Günlük hedef, seri, bildirim | 2026-10-11 | Kullanıcı kararı: 5/10/15 dk; günde en fazla 1 hatırlatma; seri K-16 |
| H-017 | Sosyal medya yayın kapsamı | 2026-10-11 | Kullanıcı kararı: ayrı ve onaylı faz; elle yükleme |
| H-018 | Yayın bölgesi | 2026-10-11 | Kullanıcı kararı: yalnızca Türkiye |
| H-020 | Reklam yok | 2026-10-11 | Kullanıcı kararı: reklam SDK'sı eklenmez |

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
  - H-050 bitti ve commit edildi. Sıradaki: H-035 (hikâye haritası; sezon jeneriği oraya taşınacak). Bekleyen kullanıcı onayları: H-046 çeviriler, H-049 jenerik.
  - Kullanıcı H-046 (çeviriler) ve H-049'u (jenerik) onayladı. H-035 başladı. Sezon haritası görseli üretildi (1 kr onaylı; kredi 84,56).
  - H-035 bitti: harita (map.jpg + 12 nokta), kilit kuralı, Drift ilerleme, Ana Sayfa kartı. Kullanıcı merak cümlelerini onayladı; eski bitirmeler kapı tamam sayılır. Sıradaki: H-036 (defter, ipucu panosu, FSRS).
  - Belgeler gerçek duruma göre güncellendi (H-023 başladı → `devam-edenler/`): CLAUDE.md (durum satırı, Geliştirme ortamı bölümü, çözülen çelişkiler, kredi 84,56, belge tablosu), IS-SIRASI, H dosyalarının durum satırları, `UYGULAMA-PLANI.md` (durum sütunu), `IS-PLANI.md` v0.2, `SARTNAME.md` başına karar notları, `OYUN-TASARIMI.md`, `ICERIK-MIMARISI.md`, `HI-ASISTAN-VE-KOC.md`, README. Kod ve içerik dosyalarına dokunulmadı.
  - Kullanıcı EnglishPractice reposunu sordu. İnceleme: kod MIT, içerik CC BY-SA 4.0. Kullanıcı kararı: kod desen olarak, içerik yalnızca referans. `docs/ENGLISHPRACTICE-INCELEME.md`; CLAUDE.md, LISANS-RAPORU, HI-ASISTAN-VE-KOC, H-036, H-048 notları.
  - Kullanıcı sosyal medyadaki görsel kelime şablonlarını sordu. Kararlar: kart = görsel + kelime + cümle + ses; tekrar hatırlama sorularıyla + FSRS + "Bilmiyorum" (bilinemeyen sonra tekrar sorulur); konu setleri hikâye mekânlarına bağlı + sahne avı (H-051, H-036'dan hemen sonra).
  - H-036 bitti (180 test). Kararlar: "Listen." anlamı + sözlük filtresi → H-052; tekrar ayarları onaylı. Sıradaki: H-052 (küçük), H-051 (konu setleri + sahne avı), H-048 (Hi-A).
  - Kullanıcı isteği: arayüz metinleri ve sayfa netliği ("Merhaba Deniz", Ana Sayfa başlıkları, net sayılar). Kararlar: Profil'de isteğe bağlı ad; H-052 ile birlikte. H-053 açıldı.
  - H-052 ve H-053 bitti. Sıradaki: H-051 (konu setleri + sahne avı).
  - Kullanıcı bir performans kontrol listesi paylaştı. Ölçüm: paketler 26–46 MB, video ~4,6 Mbps. Karar: H-054 (720p video, WebP, ölçüm, temizlik) H-051'den önce; kalan maddeler H-037, Hi-B, H-043, H-044'e eklendi.
- **2026-10-13:**
  - H-054 bitti ve commit edildi. H-051 (konu setleri + sahne avı) başladı.
  - H-051 bitti. Sıradaki: H-048 (Hi-A: yönlendiren Hi + konu tanıtımı).
  - Kullanıcı önerisi: tekrar yerlerinde mikrofonla konuşma ve doğruluk kontrolü. Kararlar: S1 MVP (H-055; 4 yer; cihazda tanıma, ses çıkmaz/saklanmaz, puan yok; desteklenmiyorsa gizli; bütün yaşlar), S2 v1, S3 sonra (H-015). `docs/KONUSMA-ALISTIRMASI.md`.
  - H-048 bitti ve commit edildi. Sıradaki: H-055 ("Söyle" alıştırmaları) + balon örtme ve haftalık özet düzeltmeleri.
  - H-055 bitti (simülatör + sahte tanıyıcı). Gerçek cihaz ve iOS izin metni H-043/H-042'ye eklendi. Sıradaki: H-037 (backend çekirdeği; önce giriş yöntemi sorulacak).
  - Kullanıcı kararı: giriş yöntemi e-postaya tek kullanımlık kod (parolasız); Apple/Google H-044. H-037 başladı (Bölüm 1: kimlik, Bölüm 2: veri).
  - H-037 Bölüm 1 (kimlik: e-posta kodu, oturum, rıza, denetim, 30 gün silme) bitti, mvn verify 44/44; yerel PostgreSQL portu 5435'e taşındı. Kullanıcı 13 yaş sınırının kaldırılmasını istedi (H-002 değişikliği; sonuçları soruldu).
  - Kullanıcı kararı (H-002 güncellendi): her yaş kullanır; hesap 13+; 13 altı hesapsız tam kullanım (cihazda); AI sohbeti 18+. H-039 ve H-042'ye not düşüldü. Backend 13 altı kaydı reddetmeye devam eder (değişiklik yok).
  - Kullanıcı ilkesi: "Ne kadar az bilgi alırsak kullanıcılar o kadar rahat eder." Karar: hesap herkes için isteğe bağlı, uygulamanın tamamı hesapsız (H-009 güncellendi); veri minimizasyonu CLAUDE.md mühendislik ilkelerine eklendi; H-038/H-039 notları.
  - H-037 bitti. Kararlar: Hi kayıtları silme her cihazda; onay durumu veritabanında. Sıradaki: H-038 (telefon ↔ sunucu, isteğe bağlı hesap).
  - H-038 bitti. Kararlar → H-056 (bitti kazanır, 30 sn hoşgörü, çıkışlı silme girişte işlenir, sekme yenileme).
- **2026-10-14:**
  - H-056 bitti ve gönderildi. Kullanıcı ara verdi; sıradaki H-039.
  - Kullanıcı isteği: sayfaların tasarımını gözden geçiren fazlı iş (Profil "iç içe, düz yazı gibi"; daha hareketli, şekilli, çekici). Plan modunda planlandı ve onaylandı. Kararlar: ~8 kr, başlık yazı tipi yuvarlak + metin Inter (gömülü), yalnız açık tema, önce tasarım sistemi + Profil. H-057 … H-064 açıldı (Adım 6).
  - H-057 kodu bitti (439 test). H-058: 16 görsel üretildi (8 kr), onay bekliyor. H-059 başladı.
  - H-057 bitti; H-058 (16 görsel, 8 kr) ve H-059 (Profil, Hesap, Hi gizlilik, hukuk) kodu bitti, tasarım onayı bekliyor. Commit + push (kalıcı onay).
  - H-041 ayrı dalda (`h-041-editor-onay`) paralel yapıldı ve bitti: onay durumu veritabanında, `/admin` editör ekranı, V7. Not: V7, yerel veritabanında H-037 içe aktarmasının `PUBLISHED` yazdığı B1/B2'yi `IN_REVIEW`'e çeker; birleştirmeden sonra açık katalog, editör ekranından onaylanana kadar boş görünür.
  - Mobil CI kontrast hatası giderildi (piksel denetimi yalnız macOS'ta, belirteç kontrastı her platformda; 5688a49, CI yeşil). H-039 ayrı dalda başladı.
  - Kullanıcı H-058 taslaklarını ve H-059 tasarımını onayladı; ikisi de bitti.
  - H-039 ayrı dalda yapıldı ve `main`'e birleştirildi (494 test): açılış akışı, 13 altına hesap yok, Türkçe altyazı tercihi, atlanabilir kademeli test (taslak 22 soru). Açık kararlar kullanıcıya soruldu.
  - Kullanıcı kararları: doğum yılı saklanmaz (yalnız geçmemiş eşik), adım zorunlu, hesapta yıl yeniden sorulur. Soru havuzu onaylandı; H-039 bitti. Sıradaki H-060.
  - Kullanıcı isteği: Kitaplık (seviyeli, resimli, sesli kitaplar; okunan cümle vurgulu; dokun → Türkçe; Defter'e ekle; okuduklarım/yarıda kalanlar; 6 seviye × 5 = 30 kitap). Önerilen kararlar onaylandı (pilot önce, ElevenLabs, kısa kitap, bağımsız türler). `docs/KITAPLIK.md` ve H-065…H-073 açıldı. H-060 ayrı dalda sürüyor.
  - H-060 ayrı dalda yapıldı ve `main`'e birleştirildi (530 test): hedef halkalı Ana Sayfa, yeni harita başlığı, bir kez oynayan bölüm açılış ışığı, AppSheet bölüm paneli. Kullanıcı onayı ve açık sorular bekleniyor.
  - Kullanıcı H-060 tasarımını onayladı; hedef aşılınca "10/10" + onay ikonu; animasyon güncelleyenlere bir kez; gerçek süre ölçümü H-074 olarak açıldı. H-060 bitti; sıradaki H-061.
  - Kullanıcı 30 kitaplık kataloğu, pilot kitapları (The Blue Door, The Parrot Who Told Everything) ve yerleşimi onayladı; H-065 bitti. Sıradaki: H-066 (kitap paketi + boru hattı) ve H-061, paralel.
  - H-066 ayrı dalda yapıldı ve `main`'e birleştirildi (pytest 151/151); bitti. H-061 sürüyor. Sıradaki Kitaplık işi H-067 (okuyucu).
  - H-061 ayrı dalda yapıldı ve `main`'e birleştirildi (581 test): tek satır biçimli Defter, sakin geri bildirimli tekrar, özet istatistikleri, dokunma tepkili konu setleri. Kullanıcı onayı bekleniyor.
  - Kullanıcı H-061'i onayladı (özet sayısı kalır; titreşim ayarı H-064'e; "Bölüm N'den ekledin" H-067'ye). H-061 bitti. H-067 okuyucu ayrı dalda başladı.
  - Pilot kitaplar: metin + çeviri onaylı; 27 görsel üretildi (14 kr; kredi 46,06); A1 sesi Sarah ile (3.880 karakter, ücretsiz kota). A1 hızı 144–168 k/dk → cümle arası duraklarla düzeltme ayrı dalda.
  - H-067 ayrı dalda yapıldı ve `main`'e birleştirildi (flutter 649, mvn 126, pytest 153): Macera · Kitaplık, okuyucu, Defter'e ekleme, kitap ilerlemesi eşitlemesi, Hi önerisi. Pilotla simülatör denemesi bekleniyor.
  - Pilot simülatörde denendi (vurgu, otomatik sayfa, anlam paneli çalışıyor). Kullanıcı H-067 ve pilotu onayladı. Kararlar: uzun basma sesli/sessiz moda göre; kalan kitaplarda kapak + bölüm başı resim (~90 kr, kredi yüklemesi gerekir); ses ElevenLabs Creator (kullanıcı hesabı açacak). Sıradaki: H-062 oynatıcı tasarımı; kitap dalgası 1 (H-071) metinleri paralel.
  - H-062 (oynatıcı katmanları: belirteçler, ~45 metin l10n'e, giriş animasyonları, sakin bölüm sonu) `main`'e birleştirildi; onay bekleniyor. Okuyucuya bölüm bazlı ses ve okunan cümleyi takip eden kaydırma eklendi (kullanıcının bildirdiği hata). A2-K03 bölüm 1–2 seslendirildi (ücretsiz kota bitti). Dalga 1 metinleri (8 kitap) `main`'de, onay bekliyor.
  - Kullanıcı kararı: Türkçe cümleler PatientDesk Alania ile seslendirilir (ilk ay ücretsiz); Duyu ile kelime zamanlaması alınır (denendi, çalışıyor). Anahtar sunucu ayarında (`hivelzon.tts.patientdesk`), değer repo dışında `~/.config/hivelzon/backend.yml`.
  - Kullanıcı isteği: Dilbilgisi (Hi'den Türkçe konu anlatımı, A1–C2, ~70 konu; bölüm panelinde "Bu bölümdeki dilbilgisi" teklifi; ayrı Dilbilgisi alanı). Kararlar alındı; `docs/DILBILGISI.md` ve H-075…H-082 açıldı.
  - Kullanıcı H-062'yi ve dalga 1'in 8 kitap metnini onayladı; 34 görsel (~17 kr) üretimine geçildi.
  - Dalga 1'in 34 görseli üretildi (17 kr, başarısız iş yok; kredi 29,06). 10 kitabın paketi hazır, dev sunucuda 10 kitap. Seslendirme ElevenLabs Creator anahtarı gelince. H-075 Türkçe ses aracı bitti.
  - H-076 müfredat (71 konu) onaylandı ve kaydedildi; pilot konular to be, a/an, -s. A2-K04 p09 dilbilgisi hatası düzeltildi.
  - H-063 (7 ifade, sakin nefes, panel bölünmesi, bölüm sonunda mutlu Hi) `main`'e birleştirildi (716 test). H-078 dilbilgisi ekranı ve H-079 pilot dersler sürüyor.
  - H-079: 3 pilot ders (to be, a/an, -s) `main`'de; Türkçe sesler Alania ile (2.730 karakter, ücretsiz), İngilizce örnekler ElevenLabs anahtarını bekliyor (627 karakter). G-A1-13'te "siz" eksiği düzeltildi.
  - Kullanıcı yeni ElevenLabs anahtarı verdi (repo dışında `~/.config/hivelzon/elevenlabs.env`); hesap **ücretsiz** (10.000 karakter/ay, ticari lisans yok → yayından önce ücretli planla yeniden üretim, H-006). Üretildi (6.559 karakter, ayrı defter `elevenlabs-hesap2-karakter.json`): A2-K03 bölüm 3 (pilot tamamen sesli), dilbilgisi pilotunun İngilizce örnekleri (3 ders tamamen sesli), A1-K03 The Red Kite. Sesli kitap sayısı: 3/10.
  - Kullanıcı kararı (hukukçu görüşü): ücretsiz ElevenLabs sesleri yayında kullanılabilir; yeniden üretim gerekmez (H-006 güncellendi).
  - H-078 dilbilgisi ekranı `main`'e birleştirildi (flutter 785, mvn 132; Drift v7, V9). Birleşmede Hi ifade eşlemesine dilbilgisi önerisi (düşünen) eklendi. Simülatör denemesi bekleniyor.
  - Kullanıcı kararı: uygulamada Türkçe konuşan her yer Alania ile (mevcut 14 Hi repliği + sessiz Hi replikleri, Hi paneli, Alex'in Türkçe cümleleri, babaannenin notu, ipucu ve açık soru kartları). H-083 açıldı.
  - Kullanıcı H-078 ve H-079'u onayladı. H-080 (dilbilgisi dalga 1: kalan 28 A1–A2 konusu) başladı; Türkçe sesler kampanyada ücretsiz.
  - H-083: 44 Türkçe klip Alania'ya geçti (Hi f1, Alex nisa, babaanne selin, anlatıcı m1; İngilizce ifadeler Sarah); Hi paneline "Hi'yi dinle". (a)/(b) örnekleri `.yerel/h083/`. flutter 799, pytest 223.
  - H-080: A1 13 + A2 15 ders yazıldı ve Türkçe sesleri üretildi; toplam 31 ders lint 0 hata. Bölüm/kitap `grammarTopics` dolduruldu (en fazla 3, aynı/alt seviye). İngilizce örnek sesleri ~9.250 karakter bekliyor.
  - H-081: B1 14 + B2 12 ders yazıldı, Türkçe sesleri üretildi; toplam 57 ders lint 0 hata. Kalan: C1–C2 (14 ders, H-082). İngilizce örnek sesleri toplam ~20.300 karakter bekliyor.
  - H-040 Keşfet `main`'e birleştirildi: 17 klip (B1–B4, ücretsiz kesim, -16 LUFS), quiz ve mola kartları, günlük 20 dk sınırı (13–17 ve 13 altı), sonsuz kaydırma yok, bellek ölçümü sızıntısız (RSS tepe +60 MB, en fazla 2 canlı oynatıcı). Onay bekliyor.
  - H-082: C1 8 + C2 6 ders yazıldı ve Türkçe sesleri üretildi. **71 konunun tamamı yazıldı, Türkçe sesli (toplam ~69.000 karakter, ücretsiz kampanya), lint 0 hata.** İngilizce örnek sesleri toplam ~27.800 karakter bekliyor. Hi balonu katman olarak yüzer (H-064 notu).
  - H-072: 5 B1 kitabının metni (2.974–3.265 kelime, kapsama %98,7–99,4, B1 yapıları doğal biçimde) main'de; onay ve görsel (28 görsel ≈ 14 kr) bekleniyor. Dilbilgisi listesinde ilerleme yüzdesi ve İngilizce örnekler için cihaz sesi eklendi (main'de, 871 test).
  - H-068 (just_audio + audio_service, MIT): kitaplar ekran kapalıyken çalar, kilit ekranında oynat/duraklat, 10 sn geri, sonraki bölüm, kapak; main'de (887 test). Kilit ekranı görünümü gerçek iPhone'da denenecek.
  - H-072: 5 B2 kitabının metni de main'de. Kitaplıkta 20 kitap (A1 5, A2 5, B1 5, B2 5), hepsi lint 0 hata. Görseller: B1+B2 59 görsel ≈ 29,5 kr (kredi 29,06; yükleme gerekir).
  - Kullanıcı onayları: Keşfet (13 altı da 20 dk), H-083 (b) yolu, B1+B2 kitap metinleri ve çevirileri. B1 görselleri (28, ~14 kr) üretime alındı; B2 görselleri (31, ~15,5 kr) kredi yüklemesi bekliyor.
  - H-084 açıldı: B2 görselleri 15,06 krediye sığsın diye 30/31 üretiliyor; B2-K01 p13 (4. bölüm başı) kredi yüklenince tamamlanacak.
  - H-064 tasarım kalite turu bitti (924 test). Tasarım yenilemesi (Adım 6) H-057…H-064 tamamlandı.
  - Üçüncü ücretsiz ElevenLabs hesabı (kullanıcının arkadaşının; anahtar repo dışında `~/.config/hivelzon/elevenlabs-3.env`, defter `elevenlabs-hesap3-karakter.json`): A1-K04 ve A1-K05 seslendirildi; A1 dilbilgisinin 16 dersinin hepsi İngilizce örnekleriyle sesli. Sesli kitap: 5/20.
  - Kullanıcı Higgsfield'a 500 kredi yükledi ve yarım kalan işler için onay verdi. H-084 bitti (p13). Kitaplık: 20 kitabın hepsi tam resimli.
  - H-085 (Bölüm 5–12 üretimi; B5 başladı) ve H-086 (kitapta "Sayfanın Türkçesi", kullanıcı isteği) açıldı. C1–C2 kitapları main'de (30 kitap yazıldı); 80 görsel üretiliyor.
  - C1–C2'nin 80 görseli üretildi (40 kr). 30 kitabın hepsi yazıldı ve tam resimli; sesli kitap 5/30. H-086 "Sayfanın Türkçesi" main'de (940 test).
  - H-085 (dal `h-085-bolum-5`): B5 "Too Late?" İngilizce ses hariç üretildi: 14 görsel + Jordan ve kaydedici referansları (8 kr), kurgu ve çeviri (lint 0 hata), Türkçe sesler 615 karakter (5 tam, 5 Sarah parçası bekliyor). Bekleyen: Jordan'ın sesi (öneri Charlie) ve 964 İngilizce karakter (replik 804 + Sarah 160). Yeni: `tts_episode_en.py`, `--tr-only`, `docs/BOLUM-URETIM-REHBERI.md`.
  - **B5 "Too Late?" tamamlandı** (14 görsel 8 kr, Türkçe Alania, İngilizce 964 karakter: hesap3 + hesap1; senkron 0,01 sn; lint 0 hata). Jordan = Chris. B6–B12 için ~7.700 İngilizce karakter gerekiyor.
  - **Sezon 1'in 12 bölümü de üretildi** (H-085): B6–B12 görsel, ★ klipler, Türkçe (Alania) ve İngilizce (hesap4) sesler, paketler; haritada 12/12 oynanabilir, lint 0 hata, -16,0 LUFS. Yeni sesler: Rosa Matilda, Mr Grant Bill, Tom Will, Sunucu Daniel, Satıcı Laura. Bekleyen: simülatör denemesi ve editör onayı (H-028). Higgsfield 385,06 kr.
  - Dilbilgisi A2: 7 dersin İngilizce örnekleri sesli (G-A2-01…07; 08 kısmen); hesap4 doldu. G-A1-15 hikâye bağı düzeltildi (0 hata). H-070 ve H-074 ayrı dallarda başladı.
  - **H-070 bitti:** kitaplar `content_items` içinde (BOOK türü, C2 yalnız kitap, V10), içe aktarma + K-05 onayı + `GET /api/v1/catalog/books`; yönetim ekranında Kitaplık süzgeci; `book_lint.py --write-reports` (export_book sonrası çalışmalı). Backend 137 test, araçlar 281 test geçti.
