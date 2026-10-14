# H-078: Dilbilgisi ekranı (mobil)

- **Durum:** Yapılacak
- **Tür:** Uygulama (kod)
- **Faz:** Dilbilgisi D2 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-077

## Kapsam
- Hikâye sekmesinde "Macera · Kitaplık · Dilbilgisi".
- Konu rafları.
- Ders kartları: vurgulu Türkçe anlatım, İngilizce örnek sesleri, kodla çizilen şemalar, alıştırma (puansız), Hikâyede gör.
- Kural kartı → Defter ve FSRS.
- Giriş noktaları:
  - bölüm panelinde ve kitap açma ekranında "Bu bölümdeki dilbilgisi";
  - anlam panelinde "Bu yapı ne?";
  - Hi'nin hata notu.
- `user_grammar_progress` tablosu ve eşitlemesi; Hi önerisi.

## Kabul kriterleri
- Testler yeşil; golden; erişilebilirlik; hareketi azalt.

## Test
`cd mobile && flutter analyze && flutter test`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.

2026-10-14 (uygulama, dal `h-078-dilbilgisi-ekrani`): Mobil ekran, giriş noktaları, ilerleme ve eşitleme yapıldı.
- **İçerik kaynağı:** `ContentSource.loadGrammarIndex` / `loadLesson` / `grammarMediaUri` (`/grammar/index.json`, `/grammar/<G-ID>/lesson.json + cards.json + audio/*.m4a`). Bölüm (`PackageSummary`, `EpisodeInfo`) ve kitap (`BookSummary`, `Book`) `grammarTopics` okur. Defterdeki ders sesi yolu `_grammar/<G-ID>/<yol>`.
- **Ekranlar:** Hikâye'de "Macera · Kitaplık · Dilbilgisi" (dar ekranda ikonlar kalkar, etiket kesilmez); raflar "Hikâyende geçenler" · "Senin seviyen" · öteki seviyeler · "Tamamladıkların"; ders ekranı `/dilbilgisi/:id` (`?sonra=` sıradaki dersler, `?devam=bolum|kitap`). Kart kart: Türkçe anlatım kendiliğinden okunur, okunan cümle/kelime vurgulu (kitap okuyucusunun ses eşlemesi, `BookAudio` arayüzü); İngilizce örnekler sesli, hedef yapı işaretli, kelimeye dokununca anlam paneli; şemalar kodla (`timeline|boxes|suffix`); "Türkçede nasıl?"; alıştırma seç/boşluk/sırala/söyle (puansız; yanlışta kısa açıklama + "Tekrar dene", "Geç" hep var, ilerlemeyi kilitlemez; "Söyle" cihazda tanıma varsa `SpeakPractice`, yer `grammar`); "Hikâyede gör" (kitap sayfasında ve cümlesinde sessiz açılır; bölüm haritada açıksa başından, değilse sakin not); kural kartı → Defter (`kind = rule`, `source = grammar`, kaynak "Dilbilgisi: <başlık>", idempotent, FSRS kartı) ve sakin kutlama. Sessiz mod (üst çubuk), sesi olmayan ders ve İngilizce sesi eksik ders tam çalışır. "Hareketi azalt" açıksa kart geçişi anında.
- **Giriş noktaları:** bölüm panelinde ikincil "Bu bölümdeki dilbilgisi (~N dk)" + konu adları → dersler sırayla → "Bölümü başlat" bölümü bugünkü gibi açar (H-050 korunur; vazgeçilirse bölüm açılmaz). Kitapta: kapağa dokununca (yalnız dersi olan kitapta) kitap açma paneli "Kitabı aç" + "Bu kitaptaki dilbilgisi". Anlam panelinde "Bu yapı ne?" çipleri (bölüm ya da kitap konuları; oynatıcıda video durur). Hi koçu `grammarSuggest` (düşük öncelik: kitap önerisinden sonra, dinlenmeden önce; gerekçe kaynağı söyler).
- **İlerleme:** Drift şema 6 → 7 `user_grammar_progress` (`lessonId`, `status`, `lastCard`, `startedAt`, `completedAt`, `updatedAt`); eşitleme tablosu (sıra 80), "bitti kazanır" (mobil `SyncStore`, backend `ProgressMerger.forGrammar`). Backend Flyway `V9__grammar_progress.sql`: tablo; `notebook_items` `kind` `rule` ve `source` `grammar`; `speech_attempts.place` `grammar`; içerik kimliği kolonları 32 → 64 (ders kimlikleri 35 karaktere çıkıyor).
- **Testler:** `flutter analyze` temiz; `flutter test` yeşil (yeni: `test/features/grammar/`, `test/features/hi/coach_grammar_test.dart`, `test/shared/content/http_grammar_test.dart`, `test/shared/storage/schema7_migration_test.dart`, `test/goldens/h078_screens_golden_test.dart`). Golden: `h078_dilbilgisi`, `h078_bolum_paneli`, `h078_ders_anlatim`, `h078_alistirma`, `h078_kural_karti`, `h078_ders_sonu`; seçici üç bölüm olduğu için `h060_harita`, `h060_bolum_paneli_kilitli`, `h060_bolum_paneli_yarim`, `h067_kitaplik` yenilendi. Backend `mvn -B verify` yeşil (yeni `GrammarProgressSyncTest`). Test dersi: `mobile/test/fixtures/grammar/G-A1-99-third-person-s/` (H-077 deneme dersinin `export_grammar.py` çıktısı; sahte sesle, ses dosyaları olmadan).
- **Sapmalar ve açık konular:** (1) Oynatıcı düğümden açılamıyor; "Hikâyede gör" bölümü başından açar (düğüm ve satır pakette var, ileride kullanılabilir). (2) "Hi'nin hata notu"ndan derse bağ yapılmadı: hata kataloğu ile G-ID eşlemesi yok (veri gelince eklenir). (3) Bölüm ve kitap sonundaki giriş noktası yok (plan §7'de var; bu işin kabulünde istenmedi). (4) Tabloya `startedAt` da eklendi (eşitleme birleştiricisi ister). (5) Kural kartında kuralın Türkçesi `exampleTr` alanında tutulur (yeni kolon açılmadı); tekrarda örnek cümle sorulur.
