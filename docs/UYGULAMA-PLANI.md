# hiVelzon: Faz 1 (MVP) uygulama planı (H-025)

**Sürüm:** 0.1 · **Tarih:** 2026-10-11 · **Durum:** Onaylandı (2026-10-11). İlk dilim: önce oynatıcı; ilk test cihazı iOS simülatörü.
**Dayanak:** CLAUDE.md "Onaylı içerik mimarisi kararları" ve "Onaylı oyun tasarımı kararları"; `docs/OYUN-TASARIMI.md`; `docs/ICERIK-MIMARISI.md`.
**Kural:** Bu plan onaylanmadan kod yazılmaz. Oynatıcı işi var olan H-031 numarasını korur; yeni işler H-033'ten başlar, sıradaki boş numara H-049. Her alt faz ayrı bir H işidir: küçük, test edilebilir ve geri alınabilir.

---

## 1. MVP kapsamı (kararlardan özet)

**Platform:** Flutter (iOS + Android), Spring Boot 4 + PostgreSQL.

**MVP'de var:**
- Hikâye modu: Sezon 1, A1; bölüm 1–4 hazır.
- Etkileşimli bölüm oynatıcısı.
- Harita, ipucu panosu, defter ve FSRS tekrarı.
- Keşfet (kısa klipler).
- Onboarding: 13 yaş ve üstü, rızalar, prolog ve atlanabilir yerleştirme testi.
- Misafir modu (prolog + B1).
- Hesap, rıza kaydı, denetim kaydı, 30 gün geri alınabilir hesap silme.
- İnce editör onay ekranı.

**MVP'de yok:**
- AI konuşma pratiği ve Hi sohbeti (v1: yerel LLM + RAG, `docs/HI-ASISTAN-VE-KOC.md`; serbest sohbet 18+, 13–17 rehberli);
- çevrimdışı indirme;
- reklam, satın alma, lig.

**Sekmeler (K-30):** Ana Sayfa · Keşfet · Hikâye · Konuş (MVP'de "yakında" durumu) · Profil.

## 2. Teknik ilkeler

| Konu | Seçim | Gerekçe |
|---|---|---|
| Paket kimliği | `tr.velzon.hivelzon` | Alan adı `velzon.tr` tersten |
| Flutter durum yönetimi | Riverpod | Test edilebilir, yaygın, Flutter 3.38 ile uyumlu |
| Yönlendirme | go_router | Derin bağlantı (Universal Links / App Links, K-14) için hazır |
| Video | `video_player` (resmî paket), segment başına MP4; uzun içerikte HLS | Araştırma (ICERIK-MIMARISI §6.5, OYUN-TASARIMI §19.1) |
| Altyazı | Uygulamada çizilir; ElevenLabs zaman damgalı JSON'dan | Videoya gömülmez (K-03); senkron pilotla doğrulandı (≤ 0,16 sn) |
| Yerel depolama | Drift (SQLite) | İlerleme, defter, FSRS kartları; sunucuyla eşitlenir |
| FSRS | Dart `fsrs` (istemci) + Java portu (sunucu, py-fsrs'ten, MIT) | K-04; iki uygulama arasında eşdeğerlik testi |
| Backend | Spring Boot 4, Java 17, Maven, Flyway, Testcontainers | Plan §10 |
| Medya | `VideoHostingPort` arkasında; Faz 1.0–1.11'de yerel adaptör (dosya sistemi / yerel sunucu). Bunny Stream adaptörü en sonda (H-044) | K-13; kullanıcı kararı: dış hesaplar en sona |
| Sırlar | Repo dışı (`~/.config/hivelzon/`). Mobilde sağlayıcı anahtarı yok. | CLAUDE.md mühendislik ilkeleri |

## 3. Fazlar ve işler (sıra önemli)

**İlk dilim:** Önce mobil tarafı yapılır. En riskli teknik parça olan etkileşimli oynatıcı, var olan B1–B4 içeriğiyle telefonda oynanır hâle getirilir. Backend daha sonra eklenir.

| Faz | İş | Kapsam | Kabul kriteri (özet) |
|---|---|---|---|
| **1.0** | **H-033** Repo iskeleti | `mobile/` (Flutter, iOS + Android, paket kimliği, tema, 5 sekmelik iskelet), `backend/` (Spring Boot 4 iskeleti, health uç noktası), README geliştirici kurulumu, temel CI | `flutter analyze` ve `flutter test` yeşil; iOS simülatöründe açılıyor; `mvn test` yeşil; `/actuator/health` UP |
| **1.1** | **H-034** Bölüm paketi formatı ve dışa aktarma | `scenes.json` şeması (düğüm: segment, karar, tepki, kart, görev; kenarlar; bayraklar). Kurgu aracının kalıcı sürümü `tools/content-pipeline/`: B1–B4'ü segment MP4 + altyazı JSON + `scenes.json` paketine dönüştürür. `content-lint` ilk sürümü (A1 kapsama, cümle uzunluğu, bağ alanları, grafik denetimi). | B1–B4 paketleri üretiliyor; `content-lint` dört bölümü geçiriyor; şema belgelendi |
| **1.2** | **H-031** Etkileşimli bölüm oynatıcısı (prototipten MVP sürümüne) | Segment sıralama ve ön ısıtma; karar kartları (yerel arayüz); yanlışta tepki dalı → aynı karar anına dönüş; Hi'nin kademeli ipucu; zaman damgalı altyazı (EN, EN+TR, kapalı); 0,75 hız; cümle tekrarı; kontrol noktası; bölüm sonu ekranı | B1–B4 telefonda baştan sona oynanıyor; segment geçişinde siyah kare yok, geçiş ≤ 150 ms; ses–yazı farkı ≤ 0,2 sn; düşük uçlu Android'de bellek ölçümü raporlandı |
| **1.3** | **H-035** Hikâye haritası, bölüm kapısı, yerel ilerleme | Sezon haritası; kilit nedeni; spoiler içermeyen ipucu; bölüm kapısı (K-29); `user_story_progress` yerel kaydı; "Hikâyeye devam" | Kapı kuralı testli; uygulama kapatılıp açılınca kalınan yerden devam ediyor |
| **1.4** | **H-036** Defter, ipucu panosu, FSRS tekrarı | Toplanan ifadeler; ipucu panosu ve açık sorular; FSRS (Bildim / Bilmedim); Ana Sayfa'da "Hızlı pratik" | FSRS birim testleri; eşdeğerlik testi verisi hazır |
| **1.4b** | **H-048** Hi-A: yönlendiren Hi | Sağ alt Hi balonu; günlük tek öneri + gerekçe, haftalık özet, "bu ne demek?", Türkçeye göre hata ipuçları; AI yok (H-047) | Öneri kuralları testli; balon doğru ekranlarda |
| **1.5** | **H-037** Backend çekirdek | Kimlik doğrulama, kullanıcı, rızalar (yalnızca ekleme), `audit_log`, hesap silme (30 gün), içerik kataloğu API'si, ilerleme ve olay (`learning_events`) API'si; Flyway; ProblemDetail hata modeli | Entegrasyon testleri (Testcontainers) yeşil; silme ve geri alma testli; giriş hız sınırı var |
| **1.6** | **H-038** Mobil ↔ backend, misafir modu | Kayıt ve giriş; misafir verisinin hesaba taşınması; ilerleme ve olay eşitleme (idempotent `client_event_id`) | Misafir → kayıt akışı veri kaybetmeden çalışıyor |
| **1.7** | **H-039** Onboarding ve yerleştirme | Dil, yaş beyanı (13+), rızalar, prolog, atlanabilir kademeli test (K-06), bildirim izni sonra | Yaş altı kayıt engelleniyor; test atlanabiliyor |
| **1.8** | **H-040** Keşfet akışı | Kısa klipler (B1–B4'ten); Kaydet / Anlam / Tam hikâye; her 4–5 klipte quiz kartı, ~10 klipte mola kartı; 13–17 yaş için 20 dk sınırı (K-15) | Akış bellek sınırında; mola ve sınır testli |
| **1.9** | **H-041** Editör onay ekranı ve içerik içe aktarma | `content-lint` → içe aktarma → Onayla / Zamanla / Kaldır; sürümler; `publish_at` (K-05, K-12); medya yerel adaptörle | Onaysız içerik katalogda görünmüyor (backend testi) |
| **1.10** | **H-042** Profil, ayarlar, hukuki metinler, hesap silme arayüzü | Beceri ve ilerleme gösterimi; bildirim ayarları; gizlilik; lisans atıfları (CEFR-J vb.) | Hesap silme ve geri alma arayüzden çalışıyor |
| **1.11** | **H-043** Kalite ve iç beta hazırlığı | Erişilebilirlik, hata durumları, çökme raporlama (veri minimizasyonuyla); simülatör ve yerel cihazda uçtan uca deneme | Beta kontrol listesi tamam (mağaza hariç) |
| **1.12** | **H-044** Dış hesaplar, barındırma ve mağaza (en son) | Sunucu yeri ve kurulum; Bunny Stream hesabı ve adaptörü; Apple ve Google geliştirici hesapları; TestFlight / Play dahili test | Uygulama sunucudaki backend ve Bunny medyasıyla çalışıyor; dahili test sürümü yüklendi |

**Bağımlılıklar:**
- H-033 → H-034 → H-031 → H-035 → H-036.
- H-037 paralel başlayabilir.
- H-038 için H-035 ve H-037 gerekir.
- H-039, H-040, H-041 ve H-042 H-038'den sonra.
- H-043, sonra H-044 en son.

## 4. Açık olanlar (ilgili fazdan önce sorulacak)

- **Giriş yöntemi** (H-037): e-posta + parola mı, Apple / Google ile giriş mi?
- **Kullanıcı kararı (2026-10-11):** Sunucu yeri, Bunny Stream hesabı ve Apple / Google geliştirici hesapları **en sona** bırakıldı (H-044). O zamana kadar her şey yerelde çalışır: backend Docker'daki PostgreSQL ile, medya yerel adaptörle, uygulama simülatörde.
- **Ticari ElevenLabs** (H-006): yayından önce şart.
- **Hukuk metinleri ve hukukçu soruları:** KVKK aydınlatması, yaş, lisanslar (H-042'den önce).

## 5. Çalışma şekli

- Her H işi kendi dalında (`h-033-repo-iskeleti` gibi) yapılır. Testler yazılır ve çalıştırılır. Gerçek test çıktısı H dosyasına yazılır, sonra `main`'e alınır. Commit ve push yalnızca kullanıcı onayıyla.
- İçerik üretimi (B5–B12) bu süreçten bağımsız; kullanıcı istediğinde sürer.
