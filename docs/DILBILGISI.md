# Dilbilgisi: Hi'den Türkçe konu anlatımı (H-075…H-082)

> Durum: **plan** (kullanıcı isteği ve kararları 2026-10-14). İşler §8'de.

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
| Türkçe ses | PatientDesk Alania: ilk ay ücretsiz, sonra 1.000 karakter 0,75 TL. Kelime zamanlaması **Duyu** ile çıkarılır; 2026-10-14'te denendi ve kelime kelime doğru çıktı. Anahtar sunucu ayarında (`hivelzon.tts.patientdesk`), değer repo dışında. Yalnız Türkçe cümleler için kullanılır. |

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
