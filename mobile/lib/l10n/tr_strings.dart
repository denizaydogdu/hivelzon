// Arayüz metinleri (H-053). Kaynak ve gerekçe: `docs/ARAYUZ-METINLERI.md`.
//
// Kurallar (kısaca): sade Türkçe, "sen" dili, suçlamasız; düğmeler fiille
// ("Başla", "Devam et", "Tekrara başla"); sayılar cümle içinde. Büyük harfli
// etiketler burada normal yazılır, ekranda `upperTr` ile büyütülür.
//
// Terimler: **ifade** = defterde öğrenilen İngilizce birim (kelime, kalıp ya
// da cümle; sayımda hep "ifade"). **kart** = ifadenin ekrandaki görünümü
// (yalnızca "kartı aç" gibi nesne anlamında). **Kelime tekrarı** = aralıklı
// tekrar özelliğinin adı. **Bölüm**, **Sezon**, **Görev**, **Hedef ifade**,
// **İpucu panosu** (hikâyede bulunan ipuçları ve açık sorular).

import '../features/story/domain/unlock_rule.dart' show accusativeNumber;
import '../shared/text/turkish.dart';

/// Ortak düğmeler ve durumlar.
abstract final class CommonTexts {
  static const back = 'Geri';
  static const goBack = 'Geri dön';
  static const close = 'Kapat';
  static const retry = 'Tekrar dene';
  static const save = 'Kaydet';
  static const ok = 'Tamam';
  static const continueAction = 'Devam et';
  static const start = 'Başla';
  static const loading = 'Yükleniyor…';
  static const serverDownTitle = 'Bağlantı kurulamadı';
  static const serverDownBody = 'İnternet bağlantını kontrol edip tekrar dene.';

  /// Yerel geliştirme: içerik sunucusu kapalıysa (yalnızca debug derlemede).
  static const devServerHint =
      'Geliştirici notu: python3 tools/dev-content-server/serve.py';
}

/// Alt sekme çubuğu.
abstract final class TabTexts {
  static const home = 'Ana Sayfa';
  static const discover = 'Keşfet';
  static const story = 'Hikâye';
  static const talk = 'Konuş';
  static const profile = 'Profil';
}

/// Ana Sayfa (H-035, H-036, H-053).
abstract final class HomeTexts {
  static String greeting(String? name) =>
      name == null || name.isEmpty ? 'Merhaba!' : 'Merhaba $name!';
  static const subtitle = 'Bugün için önerimiz:';

  static const storySection = 'Hikâyen';
  static String episodeLabel(int season, int number) =>
      upperTr('Sezon $season · Bölüm $number');
  static String seasonProgress(int done, int total) => done <= 0
      ? 'Bu sezonda $total bölüm var.'
      : 'Bu sezonda $total bölümden ${possessiveNumber(done)} bitti.';
  static const play = 'Başla';
  static const resume = 'Devam et';
  static const replay = 'Tekrar oyna';
  static const goToMap = 'Haritaya git';
  static const seasonDone = 'Sezonu bitirdin';
  static const seasonDoneBody = 'Bölümleri haritadan yeniden oynayabilirsin.';
  static String comingSoon(int number) => 'Bölüm $number hazırlanıyor';
  static const storyLoading = 'Hikâyen yükleniyor…';
  static const storyError = 'Hikâye yüklenemedi.';

  static const reviewSection = 'Kelime tekrarı';
  static String reviewDue(int n, int minutes) =>
      '$n ifadenin tekrar zamanı geldi · yaklaşık $minutes dk';
  static const reviewStart = 'Tekrara başla';
  static const reviewNone =
      'Şu an tekrar edilecek ifade yok. Yeni ifadeler bölüm bitince '
      'defterine eklenir.';
  static const reviewEmpty =
      'Bir bölümü bitirince ifadeler defterine eklenir; tekrar zamanları '
      'burada görünür.';
  static const reviewLoading = 'Defterin hazırlanıyor…';

  /// Kart başına ~20 sn; yukarı yuvarlanır, en az 1 dk.
  static int reviewMinutes(int cards) =>
      cards <= 0 ? 0 : ((cards * 20) / 60).ceil().clamp(1, 999);

  // Günlük hedef halkası (H-060). Süre yaklaşıktır: biten bölümlerin tahmini
  // süresi + bugün tekrar edilen ifadeler (ifade başına ~20 sn).
  /// Hedef aşılınca abartılmaz: "10/10" + onay ikonu (kullanıcı kararı
  /// 2026-10-14). İkon halkada çizilir; yazı tipinde ✓ glifi yok.
  static bool goalReached(int minutes, int goal) => goal > 0 && minutes >= goal;
  static String goalRing(int minutes, int goal) =>
      goalReached(minutes, goal) ? '$goal/$goal' : '$minutes/$goal';
  static const goalUnit = 'dk';
  static String goalSemantics(int minutes, int goal) =>
      goalReached(minutes, goal)
      ? 'Günlük hedef tamamlandı: bugün yaklaşık $minutes dakika, '
            'hedefin $goal dakika'
      : 'Günlük hedef: bugün yaklaşık $minutes dakika, hedefin $goal dakika';
}

/// Hikâye sekmesi: harita ve bölüm paneli.
abstract final class StoryTexts {
  static const title = 'Hikâye';
  static const intro =
      'Bölümleri sırayla aç; bitirdiğin bölümü istediğin zaman yeniden '
      'oynayabilirsin.';
  static String seasonTitle(int season, String name) => 'Sezon $season · $name';
  static String progress(int done, int total) => '$done / $total';
  static String progressSemantics(int done, int total) =>
      '$total bölümden ${possessiveNumber(done)} tamamlandı';
  static const progressLabel = 'Sezon ilerlemesi';
  static const watchIntro = 'Jeneriği izle';
  static const mapLoading = 'Harita yükleniyor…';
  static const noEpisodesTitle = 'Henüz bölüm yok';
  static const noEpisodesBody = 'Yeni bölümler hazır olunca burada görünür.';
  static const mapError = 'Bölümler yüklenemedi.';
  static String focusLabel(int number, String state) =>
      'Bölüm $number · $state';

  // Bölüm paneli
  static String sheetLabel(int number, String state) =>
      upperTr('Bölüm $number · $state');
  static const play = 'Başla';
  static const resume = 'Devam et';
  static const restart = 'Baştan başla';
  static const replay = 'Tekrar oyna';
  static const lockDetail =
      'Acele yok; önceki bölümü istediğin kadar tekrar oynayabilirsin.';
  static const comingSoon = 'Yakında';
  static const comingSoonDetail = 'Bu bölüm hazırlanıyor.';

  /// Yeni açılan bölümün ilk gösterimi (H-060): ekran okuyucuya bir kez.
  static String unlockedAnnouncement(int number) => 'Bölüm $number açıldı';
}

/// Kitaplık (H-067): Hikâye sekmesinde "Macera · Kitaplık".
abstract final class LibraryTexts {
  static const segmentAdventure = 'Macera';
  static const segmentLibrary = 'Kitaplık';
  static const segmentsLabel = 'Hikâye bölümü';
  static const intro =
      'Seviyene göre kısa, resimli kitaplar. İstersen dinle, istersen kendin '
      'oku.';

  static const readToMe = 'Bana bir kitap oku';
  static const readToMeHint =
      'Seviyeni seç; okumadığın bir kitabı senin için sesli açalım.';
  static const pickLevel = 'Hangi seviyede olsun?';
  static String suggested(String level) => 'Önerilen seviye: $level';
  static const openRandom = 'Kitabı aç';
  static const noUnreadTitle = 'Bu seviyede açmadığın kitap kalmadı';
  static const noUnreadBody =
      'Başka bir seviye seçebilir ya da sevdiğin bir kitabı yeniden '
      'dinleyebilirsin.';

  static const shelfContinue = 'Okumaya devam et';
  static String shelfMine(String level) => 'Senin seviyen · $level';
  static String shelfLevel(String level) => '$level kitapları';
  static const shelfFinished = 'Okuduklarım';

  static String genre(String code) => switch (code) {
    'mystery' => 'Gizem',
    'adventure' => 'Macera',
    'humor' => 'Mizah',
    'scifi-fantasy' => 'Bilimkurgu',
    'everyday' => 'Günlük hayat',
    _ => 'Kitap',
  };
  static String minutes(int m) => '~$m dk';
  static String percent(int p) => '%$p';
  static const done = 'Okundu';

  /// Kartın ekran okuyucu metni.
  static String cardSemantics({
    required String title,
    required String level,
    String? genre,
    int? minutes,
    int? percent,
    bool done = false,
  }) => [
    title,
    '$level seviyesi',
    ?genre,
    if (minutes != null) 'yaklaşık $minutes dakika',
    if (done) 'okundu' else if (percent != null) 'yüzde $percent okundu',
  ].join(', ');

  static const loading = 'Kitaplık hazırlanıyor…';
  static const emptyTitle = 'Kitaplar hazırlanıyor';
  static const emptyBody =
      'İlk kitaplar hazır olunca burada görünür. O zamana kadar maceraya '
      'devam edebilirsin.';
  static const loadError = 'Kitaplar yüklenemedi.';
}

/// Kitap okuyucu (H-067).
abstract final class ReaderTexts {
  static const close = 'Kitabı kapat';
  static const loading = 'Kitap açılıyor…';
  static const loadError = 'Kitap açılamadı.';
  static String pageOf(int n, int total) => 's. $n / $total';
  static String pageSemantics(int n, int total) => '$total sayfadan $n. sayfa';
  static String chapterLabel(int n) => 'Bölüm $n';

  // Mod
  static const listen = 'Sesli';
  static const silent = 'Sessiz';
  static const modeLabel = 'Okuma biçimi';
  static const noAudio =
      'Bu kitabın sesi şu an açılamıyor. Sessiz okuyabilirsin.';
  static const chapterNoAudio =
      'Bu bölümün sesi henüz hazır değil; kendin okuyabilirsin.';

  // Okunan yeri izleme (sesli mod)
  static const followBack = 'Okunan yere dön';

  // Ses denetimleri
  static const play = 'Dinle';
  static const pause = 'Duraklat';
  static const back10 = '10 saniye geri';
  static String speed(double s) => switch (s) {
    0.75 => '0,75x',
    1.25 => '1,25x',
    _ => '1x',
  };
  static String speedSemantics(double s) => switch (s) {
    0.75 => 'Hız yavaş. Değiştirmek için dokun.',
    1.25 => 'Hız hızlı. Değiştirmek için dokun.',
    _ => 'Hız normal. Değiştirmek için dokun.',
  };
  static const prevPage = 'Önceki sayfa';
  static const nextPage = 'Sonraki sayfa';
  static const finishBook = 'Kitabı bitir';

  // Uyku zamanlayıcısı (geri sayım gösterilmez; K-32)
  static const sleep = 'Uyku zamanlayıcısı';
  static const sleepOff = 'Kapalı';
  static const sleepChapter = 'Bölüm sonunda';
  static String sleepMinutes(int m) => '$m dakika sonra';
  static String sleepOn(String option) => 'Uyku zamanlayıcısı: $option';
  static const sleepFired = 'Uyku zamanlayıcısı sesi durdurdu. İyi uykular!';

  // Ayarlar
  static const settings = 'Okuma ayarları';
  static const textSize = 'Yazı boyutu';
  static const textSizes = ['Küçük', 'Orta', 'Büyük'];
  static const wordHighlight = 'Okunan kelimeyi de vurgula';
  static const wordHighlightHint = 'Kapalıyken yalnız okunan cümle vurgulanır.';

  // Bölümler
  static const chapters = 'Bölümler';
  static String chapterRow(int n, String title) => '$n. $title';
  static String chapterPage(int page) => 's. $page';

  // Anlam ve defter
  static const sentenceHint = 'Anlamını göstermek için dokun';
  static const quickAdded = 'Deftere eklendi';
  static String alreadySaved(String en) => '"$en" zaten defterinde.';
  static const saveFailed =
      'Şu an deftere eklenemedi. Biraz sonra tekrar dene.';

  // Bitiş (puan, lig, geri sayım yok; K-32)
  static const endTitle = 'Kitabı bitirdin';
  static String endBody(String title) =>
      '"$title" bitti. Dinlediğin ve okuduğun her sayfa kulağını güçlendirir.';
  static const savedHeading = 'Bu kitapta kaydettiklerin';
  static const savedEmpty =
      'Bu kitaptan defterine ifade eklemedin. Bir dahakine bilmediğin '
      'kelimeye dokunup "Deftere ekle" diyebilirsin.';
  static const savedReviewNote = 'Bu ifadeler Kelime tekrarında karşına çıkar.';
  static const nextBook = 'Sıradaki kitabı aç';
  static const backToLibrary = 'Kitaplığa dön';
  static const readAgain = 'Baştan oku';
}

/// Dilbilgisi (H-078): Hikâye sekmesinde "Macera · Kitaplık · Dilbilgisi",
/// ders kartları ve giriş noktaları (`docs/DILBILGISI.md`).
abstract final class GrammarTexts {
  static const segment = 'Dilbilgisi';
  static const intro =
      'Hi, İngilizcenin nasıl işlediğini Türkçe ve kısaca anlatır.';

  // Raflar
  static const shelfFromStory = 'Hikâyende geçenler';
  static String shelfMine(String level) => 'Senin seviyen · $level';
  static String shelfLevel(String level) => '$level konuları';
  static const shelfCompleted = 'Tamamladıkların';
  static String minutes(int m) => '~$m dk';
  static const done = 'Tamamlandı';
  static String cardSemantics({
    required String title,
    required String level,
    int? minutes,
    bool done = false,
  }) => [
    title,
    '$level seviyesi',
    if (minutes != null) 'yaklaşık $minutes dakika',
    if (done) 'tamamlandı',
  ].join(', ');
  static const loading = 'Dersler hazırlanıyor…';
  static const emptyTitle = 'Dersler hazırlanıyor';
  static const emptyBody =
      'İlk dilbilgisi dersleri hazır olunca burada görünür. O zamana kadar '
      'maceraya devam edebilirsin.';
  static const loadError = 'Dersler yüklenemedi.';

  // Ders ekranı
  static const close = 'Dersi kapat';
  static const lessonLoading = 'Ders açılıyor…';
  static const lessonError = 'Ders açılamadı.';
  static String cardOf(int n, int total) => 'Kart $n / $total';
  static String cardOfSemantics(int n, int total) =>
      '$total karttan ${possessiveNumber(n)}';
  static const previous = 'Önceki kart';
  static const next = 'Devam et';
  static const finish = 'Dersi bitir';
  static const soundOn = 'Sesi kapat';
  static const soundOff = 'Sesi aç';
  static const noAudio =
      'Bu dersin sesi şu an açılamıyor. Okuyarak devam edebilirsin.';
  static const listen = 'Dinle';
  static const stop = 'Durdur';
  static const hiSpeaking = 'Hi anlatıyor';
  static const hiLabel = 'Hi, yapay zekâ yardımcın';

  /// Kart türünün etiketi (ekranda büyük harfle).
  static String cardLabel(String type) => switch (type) {
    'hook' => 'Bu cümlede',
    'explain' => 'Anlatım',
    'examples' => 'Örnekler',
    'contrast' => 'Türkçede nasıl?',
    'practice' => 'Alıştırma',
    'seeInStory' => 'Hikâyede gör',
    'rule' => 'Kural',
    _ => 'Anlatım',
  };
  static String playExample(String en) => 'Örneği dinle: $en';
  static const examplesHint = 'Anlamı için kelimeye dokun.';
  static const wrongLabel = 'Sık yapılan hata';
  static const rightLabel = 'Doğrusu';
  static const diagramLabel = 'Şema';
  static const timelinePast = 'geçmiş';
  static const timelineNow = 'şimdi';
  static const timelineFuture = 'gelecek';

  // Alıştırma (puan, süre, can yok; K-32)
  static String questionOf(int n, int total) => 'Soru $n / $total';
  static const chooseHint = 'Boşluğa uyan kelimeyi seç.';
  static const fillHint = 'Boşluğa uyan kelimeyi yaz.';
  static const fillField = 'Cevabın';
  static const check = 'Kontrol et';
  static const orderHint = 'Kelimeleri doğru sıraya diz.';
  static const orderAnswer = 'Senin cümlen';
  static const orderReset = 'Baştan diz';
  static const sayHint = 'Cümleyi dinle, sonra sen de söyle.';
  static const sayNoSpeech = 'Cümleyi dinle, sonra sesli tekrar et.';
  static const correct = 'Doğru!';
  static const tryTitle = 'Bir daha bakalım.';
  static const tryAgain = 'Tekrar dene';
  static const skip = 'Geç';
  static const nextQuestion = 'Sonraki soru';
  static const practiceDone = 'Alıştırma tamam. Puan yok; denemek yeter.';
  static String answerWas(String solved) => 'Doğrusu: $solved';

  // Hikâyede gör
  static String episodeSource(String title) => 'Bölüm: $title';
  static String bookSource(String title, int? page) =>
      page == null ? 'Kitap: $title' : 'Kitap: $title, s. $page';
  static const openEpisode = 'Bölümü aç';
  static const openBook = 'Kitapta aç';
  static const linkLocked =
      'Bu bölüm henüz açık değil. Önceki bölümleri bitirince buradan da '
      'açabilirsin.';

  // Kural kartı ve bitiş
  static const addRule = 'Deftere kural kartı ekle';
  static const ruleAdded = 'Kural kartı defterine eklendi.';
  static const ruleExists = 'Bu kural kartı zaten defterinde.';
  static const ruleInNotebook = 'Defterinde';
  static const ruleNote = 'Kelime tekrarında karşına çıkar.';
  static const ruleFailed =
      'Şu an deftere eklenemedi. Biraz sonra tekrar dene.';
  static const doneTitle = 'Dersi bitirdin';
  static String doneBody(String title) =>
      '"$title" tamam. Bu yapıyı hikâyede gördükçe daha kolay tanırsın.';
  static String nextLesson(String title) => 'Sıradaki konu: $title';
  static const startEpisode = 'Bölümü başlat';
  static const openBookNow = 'Kitabı aç';
  static const backToList = 'Dilbilgisine dön';

  // Giriş noktaları
  static String episodeOffer(int m) => 'Bu bölümdeki dilbilgisi (~$m dk)';
  static String bookOffer(int m) => 'Bu kitaptaki dilbilgisi (~$m dk)';
  static String offerTopics(List<String> titles) => titles.join(' · ');
}

/// Sezon jeneriği (H-049, H-050; metinler H-060'ta buraya taşındı).
abstract final class SeasonIntroTexts {
  static String semantics(int season, String? title) =>
      'Sezon $season jeneriği${title == null ? '' : ': $title'}';
  static const error = 'Jenerik açılamadı.';
  static const goBack = CommonTexts.goBack;
  static const skip = 'Geç';
  static const skipSemantics = 'Jeneriği geç';
  static const aiLabel = 'Yapay zekâ ile üretilmiştir';
}

/// Defter, İpucu panosu ve kelime tekrarı.
abstract final class NotebookTexts {
  static const title = 'Defter';
  static const tabPhrases = 'İfadeler';
  static const tabClues = 'İpucu panosu';
  static const tabSets = 'Konu setleri';
  static const setsIntro =
      'Hikâyedeki yerlerin nesneleri. Bir bölümü bitirince o bölümün yeri '
      'açılır.';
  static const phrasesIntro =
      'Bölümlerde öğrendiğin ifadeler burada. Birine dokununca kartı açılır.';
  static const cluesIntro =
      'Hikâyede bulduğun ipuçları ve henüz cevabı olmayan sorular.';

  static const reviewHeading = 'Kelime tekrarı';
  static const reviewPreparing = 'İfadelerin hazırlanıyor…';

  /// İskelet görünümünün ekran okuyucu duyurusu (H-054).
  static const listLoading = 'Defterin hazırlanıyor…';
  static const cluesLoading = 'İpucu panosu hazırlanıyor…';
  static String reviewDue(int n, int minutes) =>
      HomeTexts.reviewDue(n, minutes);
  static const reviewEmpty = 'Bölüm bitirdikçe ifadelerin burada birikir.';
  static const reviewDoneToday =
      'Bugünlük tekrar bitti. İfadeler zamanı gelince yeniden gelir.';
  static const reviewHowTo =
      'Resme bak, dinle, seç. Bilmediğin ifade sorun değil: oturumun sonunda '
      'yeniden gelir.';
  static const reviewStart = 'Tekrara başla';

  static String listHeading(int n) =>
      n == 0 ? 'Topladığın ifadeler' : 'Topladığın ifadeler ($n)';
  static const search = 'İngilizce ya da Türkçe ara';
  // Boş durum (H-061: illüstrasyonlu `EmptyState`; başlık + açıklama).
  static const emptyTitle = 'Defterin henüz boş';
  static const emptyBody =
      'Bir bölümü bitirince hedef ifadeler buraya gelir. Altyazıda bir '
      'kelimeye dokunup "Deftere ekle" de diyebilirsin.';
  static const noMatch = 'Aradığın ifade defterinde yok.';

  /// Satırın kaynak satırı (H-061, H-067). Bölümün kendi eklediği ifadelerde
  /// (hedef ifade, bakılan kelime) kaynak yalnız soldaki bölüm etiketidir
  /// ("B1"); kullanıcının kendi eklediğinde bölüm de yazılır.
  static const sourceTopicSet = 'Konu setinden';
  static String sourceEpisode(int n) => "Bölüm ${ablativeNumber(n)} ekledin";
  static String sourceBook(String title, int? page) =>
      page == null ? 'Kitap: $title' : 'Kitap: $title, s. $page';
  static const sourceBookUnknown = 'Kitaptan';

  /// Dilbilgisi kural kartı (H-078): "Dilbilgisi: Üçüncü tekil -s".
  static String sourceGrammar(String title) => 'Dilbilgisi: $title';
  static const ruleLabel = 'KURAL';

  /// Kaynağa göre süzme (H-067; kitaptan eklenen ifade varsa görünür).
  static const filterLabel = 'Kaynağa göre süz';
  static const filterAll = 'Hepsi';
  static const filterStory = 'Hikâyeden';
  static String filterBook(String title) => title;
  static const loadError =
      'Defter açılamadı. Uygulamayı yeniden başlatıp dene.';
  static String removed(String en) => '"$en" defterinden çıkarıldı.';
  static const remove = 'Defterden çıkar';
  static const options = 'Seçenekler';
  static const openCard = 'Kartı aç';

  static const dueNew = 'Yeni ifade: ilk tekrarını bekliyor.';
  static const dueNow = 'Tekrar zamanı geldi.';
  static const dueToday = 'Bugün yeniden gelecek.';
  static const dueTomorrow = 'Yarın yeniden gelecek.';
  static String dueInDays(int days) => '$days gün sonra yeniden gelecek.';

  // İpucu panosu
  static const cluesEmptyTitle = 'Henüz ipucu yok';
  static const cluesEmptyBody =
      'Bölüm sonunda bulduğun ipuçları ve açık sorular burada toplanır.';
  static const cluesError = 'İpucu panosu açılamadı.';
  static const openQuestions = 'Açık sorular';
  static String openQuestionLabel(int episode) =>
      upperTr('Açık soru · Bölüm $episode');
  static String partialNote(String note) => 'Şimdilik bildiğin: $note';
  static const foundClues = 'Bulduğun ipuçları';
  static String clueEpisode(int episode) => upperTr('Bölüm $episode');
}

/// Konu setleri (H-051). Sahnedeki öğe "nesne"dir; deftere girince "ifade"
/// olarak sayılır.
abstract final class TopicSetTexts {
  static const listLoading = 'Konu setleri hazırlanıyor…';
  static const listError =
      'Konu setleri açılamadı. Bağlantını kontrol edip tekrar dene.';
  static const empty =
      'Henüz konu seti yok. Yeni setler bölümlerle birlikte gelir.';
  static const locked = 'Kilitli';
  static String objectCount(int n) => '$n nesne';
  static const openSet = 'Seti aç';
  static const setLoading = 'Konu seti hazırlanıyor…';
  static const setError = 'Konu seti açılamadı.';
  static const huntHeading = 'Sahne avı';
  static const huntIntro =
      'Nesnenin İngilizce adını oku, sonra resimde ona dokun. Süre yok.';
  static const huntStart = 'Sahne avına başla';
  static const gridHeading = 'Nesneler';
  static String inDeckCount(int inDeck, int total) => inDeck == 0
      ? 'Bu sette $total nesne var. Birine dokununca kartı açılır.'
      : 'Bu sette $total nesne var; ${possessiveNumber(inDeck)} defterinde.';
  static const addAll = 'Hepsini defterime ekle';
  static const allInDeck = 'Hepsi defterinde';
  static const addOne = 'Defterime ekle';
  static const inDeck = 'Defterinde';
  static String addedAll(int n) => n == 0
      ? 'Bu setteki ifadeler zaten defterindeydi.'
      : '$n ifade defterine eklendi. Tekrar zamanı gelince "Kelime tekrarı" '
            'bölümünde karşına çıkar.';
  static String addedOne(String en) => '"$en" defterine eklendi.';
  static const addError = 'Şu an deftere eklenemedi. Biraz sonra tekrar dene.';
  static const exampleLabel = 'ÖRNEK CÜMLE';
  static String itemSemantics(String en, String tr, bool inDeck) =>
      '$en, $tr${inDeck ? ', defterinde' : ''}. Kartı aç.';
}

/// Sahne avı (H-051): süre ve puan yok; yanlış dokunuş suçlanmaz (K-32).
abstract final class HuntTexts {
  static const title = 'Sahne avı';
  static String progress(int position, int total) => 'Nesne $position / $total';
  static const exit = 'Sahne avından çık';
  static const found = 'Buldun!';
  static const miss = 'Bir daha bakalım.';
  static const hint = 'İpucu: parlayan yere bak.';
  static const revealed = 'Burada. Sorun değil, birlikte bakalım.';
  static const dontKnow = 'Bilmiyorum';
  static const next = 'Devam et';
  static const finish = 'Sonucu gör';
  static const listen = 'Dinle';
  static const zoomIn = 'Yakınlaştır';
  static const zoomReset = 'Resmin tamamını göster';
  static String sceneLabel(String title) => '$title sahnesi';
  static const choicesHeading = 'Doğru nesneyi seç:';
  static const doneTitle = 'Sahne avı tamam';
  static String foundAlone(int n, int total) => n == total
      ? '$total nesnenin hepsini kendin buldun.'
      : n == 0
      ? 'Bu sefer nesnelere birlikte baktık.'
      : '$total nesneden $n tanesini kendin buldun.';
  // Özetin istatistikleri (H-061, `StatRow`): sayı + kısa etiket; ekran
  // okuyucu "10 nesneye baktın" diye okur. Puan, yüzde, "yanlış" yok.
  static const statTotal = 'nesneye baktın';
  static const statAlone = 'kendin buldun';
  static const statHelped = 'birlikte baktık';
  static String deckUpdated(int n) =>
      'Defterindeki $n ifadenin tekrar zamanı güncellendi.';
  static const notInDeck =
      'Bu nesneleri defterine eklersen kelime tekrarında da karşına çıkar.';
  static const playAgain = 'Tekrar oyna';
  static const backToSet = 'Sete dön';
}

/// Kelime tekrarı oturumu.
abstract final class ReviewTexts {
  static const title = 'Kelime tekrarı';
  static String progress(int position, int total) =>
      'Kelime tekrarı · $position / $total';
  static const emptyTitle = 'Şu an tekrar edilecek ifade yok';
  static const emptyBody = 'İfadeler zamanı gelince yeniden gelir.';
  static const errorTitle = 'Tekrar açılamadı';
  static const errorBody = 'Defterin yerinde; birazdan yeniden dene.';
  static const pictureChoice = 'Resme ve anlama bak: doğru ifadeyi seç.';
  static const listenChoice = 'Dinle ve duyduğun ifadeyi seç.';
  static const arrange = 'Kelimeleri doğru sıraya diz.';
  static const type = 'İngilizcesini yaz.';
  static const selfCheck = 'İngilizcesini aklından söyle, sonra kartı aç.';
  static const listen = 'Dinle';
  static const typeHint = 'İngilizcesini yaz';
  static const check = 'Kontrol et';
  static const openCard = 'Kartı aç';
  static const knewIt = 'Bildim';
  static const dontKnow = 'Bilmiyorum';
  static const correct = 'Doğru!';
  static const dontKnowFeedback = 'Sorun değil, birlikte bakalım.';
  static const wrongFeedback = 'Doğrusu bu.';
  static const requeued = 'Bu ifade oturumun sonunda yeniden gelecek.';
  static const soon = 'Bu ifadeyi yakında yeniden göreceksin.';
  static String chosen(String option) => 'Seçtiğin: $option';
  static const continueAction = 'Devam et';
  static const doneTitle = 'Tekrar tamam';
  static String reviewed(int n) => '$n ifadeyi tekrar ettin.';
  // Özetin istatistikleri (H-061, `StatRow`; sıfır olanlar gösterilmez):
  // ekran okuyucu "2 ifade yarın gelecek" diye okur.
  static const statFirstTry = 'ilk seferde bildin';
  static const statTomorrow = 'ifade yarın gelecek';
  static const statLater = 'ifade sonra gelecek';
  static const done = 'Tamam';
}

/// Profil.
abstract final class ProfileTexts {
  static const title = 'Profil';

  // Başlık (H-059): ad varsa "Merhaba Deniz", yoksa "Merhaba!".
  static String greeting(String? name) =>
      name == null ? 'Merhaba!' : 'Merhaba $name';

  /// Ad yokken avatarın ekran okuyucu metni.
  static const avatarNoName = 'Hi';

  /// Başlığın altındaki tek satır: bu haftadan olumlu bir cümle; kayıt
  /// yoksa sakin bir davet (yapılmayan söylenmez, K-16).
  static String status({
    required int phrasesAdded,
    required int phrasesReviewed,
    required int episodesCompleted,
  }) {
    if (phrasesReviewed > 0) {
      return 'Bu hafta $phrasesReviewed ifadeyi tekrar ettin.';
    }
    if (phrasesAdded > 0) {
      return 'Bu hafta $phrasesAdded yeni ifade topladın.';
    }
    if (episodesCompleted > 0) {
      return 'Bu hafta $episodesCompleted bölüm bitirdin.';
    }
    return 'Bugün küçük bir adım yeter.';
  }

  // İstatistik kutuları (sayı + ne sayıldığı).
  static const statPhrases = 'ifade';
  static const statEpisodes = 'bölüm bitti';
  static const statWeekReviews = 'bu hafta tekrar';

  // Gruplar
  static const learningGroup = 'Öğrenme';
  static const accountGroup = 'Hesap ve gizlilik';

  // Defter satırı
  static const notebookTile = 'Defter';
  static const notebookLoading = 'İfadeler, İpucu panosu ve Konu setleri';
  static const notebookEmpty = 'Bölüm bitince ifadeler buraya eklenir.';
  static String notebookCount(int total, int due) => due > 0
      ? '$total ifade · $due ifadenin tekrar zamanı geldi'
      : '$total ifade';

  // Günlük hedef satırı ve paneli
  static const goalSection = 'Günlük hedef';
  static const goalIntro = 'Günde ne kadar zaman ayırmak istersin?';
  static String goalOption(int minutes) => '$minutes dk';
  static String goalNote(int newPerDay) =>
      'Kelime tekrarında günde en fazla $newPerDay yeni ifade açılır.';
  static const goalChangeNote =
      'İstediğin zaman değiştirebilirsin. Hedefin altında kalmak sorun değil.';

  // Konu setleri satırı
  static const topicSetsTile = 'Konu setleri';
  static const topicSetsHint = 'Hikâyedeki yerlerin nesneleri.';

  // Ad satırı ve paneli
  static const nameRow = 'Adın';
  static const nameRowEmpty = 'Eklenmedi';
  static const nameRowHint = 'Ana Sayfa seni bu adla selamlar.';
  static const nameSection = 'Sana nasıl seslenelim?';
  static const nameLabel = 'Adın ya da takma adın';
  static const nameHelper = 'İsteğe bağlı. Yalnızca bu cihazda saklanır.';
  static const nameTooLong = 'En fazla 20 karakter yazabilirsin.';
  static const nameInvalid =
      'Yalnızca harf, boşluk, kesme işareti ve tire kullanabilirsin.';
  static const nameSaved = 'Adın kaydedildi.';
  static const nameCleared = 'Adın silindi; Ana Sayfa "Merhaba!" der.';
}

/// Henüz gelmeyen sekmeler.
abstract final class PlaceholderTexts {
  static const discoverTitle = 'Keşfet';
  static const discoverHeading = 'Kısa klipler yakında';
  static const discoverBody =
      'Bölümlerden 30 saniyelik klipler burada akacak. Her klipten sonra kısa '
      'bir soru ya da kelime kaydetme seçeneği olacak.';
  static const talkTitle = 'Konuş';
  static const talkHeading = 'Konuşma pratiği yakında';
  static const talkBody =
      'Hikâyedeki karakterlerle İngilizce konuşma pratiği sonraki sürümde '
      'geliyor. Karşındakinin yapay zekâ olduğu her zaman söylenecek.';
}

/// Oynatıcı (H-031, H-050; H-062'de bütün metinler buraya taşındı).
/// Kılavuz: ARAYUZ-METINLERI §4.4–4.5. Büyük harfli etiketler normal
/// yazılır, ekranda `CapsLabel` (`upperTr`) büyütür.
abstract final class PlayerTexts {
  // Açılış (H-050)
  static String titleSemantics(int season, int episode, String title) =>
      'Sezon $season, Bölüm $episode: $title';
  static const recap = 'Önceki bölümde';
  static const recapSkip = 'Atla';
  static const recapSkipSemantics = 'Önceki bölüm özetini atla';

  // Üst çubuk
  static const exitEpisode = 'Bölümden çık';
  static String sceneProgress(int n, int total) => 'Sahne $n / $total';
  static const missionButton = 'Görev ve hedef ifadeler';
  static String speed(double s) => s == 1.0 ? '1x' : '0,75x';
  static String speedSemantics(double s) => s == 1.0
      ? 'Hız normal. Yavaşlatmak için dokun.'
      : 'Hız 0,75. Normale dönmek için dokun.';

  // Altyazı menüsü: kısa ad (düğmede), ekran okuyucu adı, menü satırı.
  static const subtitleEn = 'EN';
  static const subtitleEnTr = 'EN+TR';
  static const subtitleOff = 'Kapalı';
  static const subtitleEnSpoken = 'İngilizce';
  static const subtitleEnTrSpoken = 'İngilizce ve Türkçe';
  static const subtitleOffSpoken = 'kapalı';
  static String subtitleTooltip(String spoken) => 'Altyazı: $spoken';
  static const subtitleMenuEn = 'EN (İngilizce)';
  static const subtitleMenuEnTr = 'EN + TR (Türkçe satırla)';
  static const subtitleMenuOff = 'Kapalı';

  /// Anlamı olan İngilizce satırın ekran okuyucu etiketi (H-046).
  static String tapForMeaning(String text) =>
      '$text. Anlamını görmek için dokun.';
  static String subtitleSemantics(String en, String? tr) =>
      '$en.${tr == null ? '' : ' $tr.'} Anlamını görmek için dokun.';

  // Çıkış sorusu
  static const exitTitle = 'Bölümden çıkılsın mı?';
  static const exitBody =
      'Kaldığın sahne kaydedilecek. Sonra oradan devam edebilirsin.';
  static const exitStay = 'Kal';
  static const exitLeave = 'Çık';

  // Yükleme ve hata
  static const loading = 'Bölüm yükleniyor…';
  static const genericError = 'Bir şeyler ters gitti.';
  static const errorHint =
      'Bağlantını ya da içerik sunucusunu kontrol edip tekrar deneyebilirsin.';
  static const retry = 'Tekrar dene';

  // Kaldığın yerden devam
  static String resumeBody(String? scene) => scene == null
      ? 'Bu bölümü yarıda bırakmıştın.'
      : 'Bu bölümü yarıda bırakmıştın: $scene';
  static const resumeContinue = 'Kaldığın yerden devam';
  static const restart = 'Baştan başla';

  // Karar anı (süre yok, geri sayım yok; K-32)
  static const decisionHeading = 'Ne dersin?';
  static const askHint = "Hi'den ipucu al";
  static String listenTo(String text) => 'Dinle: $text';
  static const listen = 'Dinle';

  // Hi'nin ipucu ve tepki balonu
  static String hintTitle(int level, int total) => 'İpucu $level / $total';
  static const hintMore = 'Bir ipucu daha';
  static const hintAllOpen = 'Tüm ipuçları açık';
  static const listenHi = "Hi'yi dinle";
  static const hiSemantics = 'Hi, yapay zekâ yardımcın';

  /// Yanlış seçimde nazik, cezalandırmayan geri bildirim (sırayla).
  static const gentleRetry = [
    'Bir daha bakalım.',
    'Neredeyse! Bir kez daha dene.',
    'Acele yok, tekrar dene.',
  ];

  // Kartlar
  static const missionLabel = 'Görev';
  static const newClueLabel = 'Yeni ipucu';
  static const finishEpisode = 'Bölümü bitir';
  static const messageFallback = 'Mesaj';

  // Görevler
  static const taskDone = 'Harika, buldun!';
  static const listenRecording = 'Kaydı dinle';
  static const yourSentence = 'Senin cümlen';
  static const matchHelp = 'Önce soldan bir parça, sonra sağdan eşini seç.';
  static const check = 'Kontrol et';
  static String tokenRemove(String t) => '$t, çıkarmak için dokun';
  static String tokenAdd(String t) => '$t, eklemek için dokun';
  static const blankName = 'Adın';
  static const blankFrom = 'Nerelisin';

  // 🎯 paneli (H-050)
  static const targetPhrasesLabel = 'Hedef ifadeler';

  // Bölüm sonu (puan, lig, geri sayım yok; K-32)
  static const endTitle = 'Görev tamam!';
  static const cluesLabel = 'Toplanan ipuçları';
  static const openQuestionLabel = 'Açık soru';
  static String nextTeaser(String t) => 'Sıradaki: $t';
  static const phrasesLabel = 'Bu bölümün ifadeleri';

  static const backToMap = 'Haritaya dön';
  static const endNotebookNote =
      'Bu ifadeler defterine eklendi. Tekrar zamanı gelince Ana Sayfa\'daki '
      '"Kelime tekrarı" bölümünde karşına çıkar.';
  static String taskProgress(int index, int total) => 'Soru $index / $total';
  static const newTopicSetLabel = 'Yeni konu seti';
  static String newTopicSet(String title) => 'Yeni konu seti açıldı: $title';
  static const topicSetLabel = 'Konu seti';
  static String topicSet(String title) =>
      'Bu bölümün yerindeki nesneler: $title';
  static const openTopicSet = 'Konu setini aç';
  static const continueAction = 'Devam et';
}

/// Anlam paneli (H-046; oynatıcı, Keşfet ve kitap okuyucu ortak). H-062'de
/// buraya taşındı.
abstract final class MeaningTexts {
  /// H-078: içeriğin dilbilgisi konuları ("Bu yapı ne?").
  static const structureLabel = 'Bu yapı ne?';
  static const title = 'Anlam';
  static const close = CommonTexts.close;
  static const closeSemantics = 'Paneli kapat';
  static const hintWithAudio =
      'Bir kelimeye dokun: anlamını gör ve sesini dinle.';
  static const hint = 'Bir kelimeye dokun: anlamını gör.';
  static const properNoun = 'Özel ad: Türkçesi aynı kalır.';
  static const blank = 'boşluk';
  static String wordSemantics(String w) => '$w. Anlamı için dokun.';
  static const chunkLabel = 'Kalıp';
  static const turkishLabel = 'Türkçesi';
  static const reveal = 'Türkçesini göster';
  static const replay = 'Tekrar dinle';
  static const slow = '0,75x';
  static const slowOn = 'Yavaş dinleme açık (0,75). Normale dönmek için dokun.';
  static const slowOff = 'Yavaş dinle (0,75)';
  static const save = 'Deftere ekle';
  static const saveFailed =
      'Şu an deftere eklenemedi. Biraz sonra tekrar dene.';

  // Konuşmacı adları (kart, görev ve başlık satırları için "Anlam").
  static const speakerRadio = 'Telsizdeki ses';
  static const speakerNote = 'Not';
}

/// Hi-A (H-048): balon, panel, öneri gerekçeleri, notlar, konu kartı, yan
/// görev ve "Hi benim hakkımda ne biliyor?". Kılavuz: ARAYUZ-METINLERI §10.
/// Hi suçlamaz, acele ettirmez, romantik ya da bağımlılık yaratan dil
/// kullanmaz; yapay zekâ olduğunu söyler (K-23, K-32).
abstract final class HiTexts {
  // Balon ve panel
  static const bubbleLabel = "Hi'yi aç";
  static const bubbleLabelNew = "Hi'yi aç. Bugün için yeni bir önerisi var.";
  static const intro = 'Ben Hi, yapay zekâ asistanınım.';
  static const introSub =
      'Önerilerimi bu cihazdaki ilerlemene bakarak, kurallarla seçiyorum.';
  static const todayHeading = 'Bugünkü öneri';
  static const why = 'Neden?';
  static const quickHeading = 'Hızlı eylemler';
  static const quickStory = 'Hikâyeye devam';
  static const quickReview = 'Kelime tekrarı';
  static const quickNotebook = 'Defter';
  static const quickSets = 'Konu setleri';
  static const loading = 'Hi hazırlanıyor…';

  static String _minutes(int? est, int goal) {
    if (est == null || est <= 0) return '';
    if (est <= goal) {
      return ' Yaklaşık $est dk sürer; günlük hedefine ($goal dk) sığar.';
    }
    return ' Yaklaşık $est dk sürer. Günlük hedefin $goal dk; istediğin yerde '
        'bırakıp sonra devam edebilirsin.';
  }

  // a) yarım bölüm
  static String continueTitle(String title) => 'Hikâyeye devam: $title';
  static String continueReason(int number, int? est, int goal) =>
      'Bölüm ${accusativeNumber(number)} yarıda bırakmıştın; kaldığın '
      'sahneden devam edersin.${_minutes(est, goal)}';
  static const continueAction = 'Devam et';

  // b) kelime tekrarı
  static const reviewTitle = 'Kelime tekrarı';
  static String reviewReason(int n, int minutes, int goal) =>
      '$n ifadenin tekrar zamanı geldi. Zamanında tekrar edilen ifade daha '
      'kolay hatırlanır.${_minutes(minutes, goal)}';
  static const reviewAction = 'Tekrara başla';

  // c) tekrarlayan hata türü
  static String noteTitle(String label) => "Hi'nin notu: $label";
  static String noteReason(String typeLabel, int n) =>
      'Son 7 günde "$typeLabel" konusunda $n kez takıldın. Bu çok olağan; '
      'Türkçeyle karşılaştıran kısa bir not var, 1 dk sürer.';
  static const noteAction = 'Notu aç';
  static const notebookTitle = 'Defterine göz at';
  static String notebookReason(String typeLabel, int n) =>
      'Son 7 günde "$typeLabel" konusunda $n kez yeniden denedin. '
      'Kartlarına bir kez bakmak hatırlamayı kolaylaştırır; 2 dk sürer.';
  static const notebookAction = 'Defteri aç';

  // d) sıradaki bölüm
  static String startTitle(String title) => 'Sıradaki bölüm: $title';
  static String startReason(int number, int done, int? est, int goal) =>
      (done == 0 || number <= 1
          ? 'Hikâye buradan başlıyor.'
          : 'Bölüm ${accusativeNumber(number - 1)} bitirdin; Bölüm $number '
                'seni bekliyor.') +
      _minutes(est, goal);
  static const startAction = 'Başla';

  // e) sahne avı
  static String huntTitle(String set) => 'Sahne avı: $set';
  static String huntReason(String set, int? episode) =>
      '${episode == null ? 'Bölümü' : 'Bölüm ${accusativeNumber(episode)}'} '
      'bitirince "$set" seti açıldı. Nesneleri resimde bul; süre yok, '
      'yaklaşık 3 dk.';
  static const huntAction = 'Sahne avına başla';

  // g) yarım kitap (H-067)
  static String continueBookTitle(String title) => 'Kitaba devam: $title';
  static String continueBookReason(
    String title,
    int percent,
    int? est,
    int goal,
  ) =>
      '"$title" kitabının %$percent kadarını okudun; kaldığın cümleden '
      'devam edersin.${_minutes(est, goal)}';
  static const continueBookAction = 'Kitaba devam et';

  // h) kitap başla (H-067)
  static String startBookTitle(String title) => 'Bir kitap dinle: $title';
  static String startBookReason(String level, int? est, int goal) =>
      'Bugünkü işlerin bitti. İstersen $level seviyesinde kısa bir kitabı '
      'dinleyerek kulağını çalıştır.${_minutes(est, goal)}';
  static const startBookAction = 'Dinlemeye başla';

  // i) dilbilgisi (H-078): oynanan bölümde ya da okunan kitapta geçen,
  // bitirilmemiş konu.
  static String grammarTitle(String title) => 'Kısa bir konu: $title';
  static String grammarReason(String source, int? est, int goal) =>
      '$source bu yapı geçti. İstersen Türkçe ve kısaca anlatayım.'
      '${_minutes(est, goal)}';
  static String grammarSourceEpisode(String title) => '"$title" bölümünde';
  static String grammarSourceBook(String title) => '"$title" kitabında';
  static const grammarAction = 'Konuyu aç';

  // f) dinlenme
  static const restTitle = 'Bugünlük bu kadar yeter';
  static const restReason =
      'Tekrar zamanı gelen ifade yok, sıradaki bölüm de hazırlanıyor. '
      'İstersen aşağıdan bir kelimenin anlamına bakabilirsin.';

  // Bu ne demek?
  static const lookupHeading = 'Bu ne demek?';
  static const lookupHint = 'İngilizce ya da Türkçe yaz';
  static const lookupIntro =
      'Bölümlerde geçen kelime ve kalıpların anlamını bulurum.';
  static const lookupNoMatch =
      'Bunu henüz bilmiyorum; bölümlerde geçen kelimeleri arayabilirim.';
  static const lookupExample = 'ÖRNEK';
  static const lookupListen = 'Dinle';
  static const lookupListenExample = 'Örneği dinle';
  static String lookupSource(String tag) => 'Geçtiği yer: $tag';
  static const lookupFromNotebook = 'Defterinde';
  static const lookupFromSet = 'Konu setinde';

  // Haftalık özet
  static const weekHeading = 'Haftalık özet';
  static const weekSub = 'Son 7 gün, yalnızca bu cihazda.';
  static String weekPhrases(int n) => '$n yeni ifade topladın.';
  static String weekReviews(int n) => '$n ifadeyi tekrar ettin.';
  static String weekEpisodes(int n) => '$n bölüm bitirdin.';
  static String weekFocus(String label) =>
      'En çok üzerinde çalıştığın konu: $label.';
  static const weekEmpty =
      'Bu hafta henüz kayıt yok. İlk adım için bugünkü öneriye bakabilirsin.';

  // Hi'nin sesi (H-083): not, konu kartı ve yan görevde "Dinle".
  static const listen = "Hi'yi dinle";
  static const listenStop = 'Durdur';

  // Hi'nin notu
  static const noteLabel = "Hi'nin notu";
  static const noteTurkish = 'Türkçeden aklına gelen';
  static const noteEnglish = 'İngilizcede';

  /// Kelime tekrarında yanlış cevaptan sonra ("yanlış" sözcüğü kullanılmaz).
  static const whyWrong = 'Neden böyle?';

  // Konu tanıtımı
  static const topicLabel = 'Yeni konu';
  static const topicContinue = 'Devam et';
  static const topicSkip = 'Geç';
  static const topicNotesHeading = "Hi'nin konu notları";
  static String topicNotesCount(int n) =>
      'Hikâyede tanıştığın $n konu. Birine dokununca kartı açılır.';
  static const topicNotesEmpty =
      'Bölümlerde yeni bir konu geçince Hi kısa bir not bırakır; '
      'notlar burada toplanır.';

  // Yan görev (köprü)
  static const bridgeLabel = 'Yan görev';
  static const bridgeNote = 'İsteğe bağlı. Yalnızca sen bilirsin.';
  static const bridgeDone = 'Yaptım';
  static const bridgeDismiss = 'Şimdi değil';
  static const bridgeThanks =
      'Harika! Hikâyedeki ifade gerçek hayatta da işe yaradı.';

  // Gizlilik
  static const privacyTile = 'Hi benim hakkımda ne biliyor?';
  static const privacyTileSub = 'Bu cihazda saklananları gör, istersen sil.';
  static const privacyTitle = 'Hi benim hakkımda ne biliyor?';
  static const privacyIntro =
      'Hi önerilerini bu cihazdaki kayıtlara bakarak seçer. Reklam için '
      'kullanılmaz.';

  // Konum notu (H-059): hesap yoksa / varsa.
  static const privacyLocalTitle = 'Yalnızca bu telefonda';
  static const privacyLocalBody =
      'Bu bilgiler telefonundan dışarı gönderilmez.';
  static const privacyAccountTitle = 'Hesabına da eşitlenir';
  static const privacyAccountBody =
      'Hesabın açık olduğu için bu kayıtlar yedek olarak hesabına da '
      'eşitlenir. Silersen hesabına bağlı öteki cihazlardan da silinir.';

  // Sayılar (H-059)
  static const privacyNumbers = 'Sayılarla';
  static const statLookups = 'kez anlamına baktın';
  static const statRetries = 'kez yeniden denedin';
  static const statSpeech = 'kez söyledin';
  static const privacyStored = 'Bu cihazda saklananlar';
  static const weekStatAdded = 'yeni ifade';
  static const weekStatReviewed = 'ifade tekrar';
  static const weekStatEpisodes = 'bölüm bitti';
  static String errorChip(String label, int n) => '$label · $n';
  static const privacyName = 'Adın';
  static const privacyNoName = 'Kaydetmedin.';
  static const privacyProgress = 'Hikâye ilerlemen';
  static String privacyProgressValue(int done, int inProgress) =>
      inProgress == 0
      ? '$done bölüm bitti.'
      : '$done bölüm bitti, $inProgress bölüm yarım.';
  static const privacyNotebook = 'Defterin';
  static String privacyNotebookValue(int items, int reviews) =>
      'Defterinde $items ifade var; $reviews tekrar cevabı kayıtlı.';
  static const privacyEvents = 'Hi\'nin öğrenme kayıtları';
  static String privacyEventsValue(int lookups, int errors) =>
      '$lookups kez bir kelimenin anlamına baktın; $errors kez bir seçimi '
      'yeniden denedin.';
  static const privacyErrors = 'Konulara göre yeniden denemeler';
  static const privacyErrorsNone = 'Kayıt yok.';
  static const privacyWeek = 'Son 7 gün';
  static const privacyBridge = 'Yan görevler';
  static String privacyBridgeValue(int done, int dismissed) =>
      '$done yan görevi yaptın, $dismissed tanesini geçtin.';
  static const privacyDelete = "Hi'nin kayıtlarını sil";
  static const privacyDeleteNote =
      'Öğrenme kayıtları, Söyle sonuçları ve yan görev durumları silinir. '
      'Hikâye ilerlemen, defterin ve adın silinmez.';
  static const privacyConfirmTitle = "Hi'nin kayıtları silinsin mi?";
  static const privacyConfirmBody =
      'Anlamına baktığın kelimeler, yeniden denediğin seçimler, Söyle '
      'sonuçları ve yan görev durumları silinir. Bu geri alınamaz. Hikâye ilerlemen ve defterin '
      'yerinde kalır.';
  static const privacyConfirmCancel = 'Vazgeç';
  static const privacyConfirmDelete = 'Sil';
  static const privacyDeleted =
      "Hi'nin kayıtları silindi. İlerlemen ve defterin yerinde.";
  static const privacyError = 'Kayıtlar okunamadı. Biraz sonra tekrar dene.';

  // Hesap açıkken (H-038): kayıtlar hesaba da eşitlenir; silme her yerde.
  static const privacyConfirmBodyAccount =
      'Anlamına baktığın kelimeler, yeniden denediğin seçimler, Söyle '
      'sonuçları ve yan görev durumları silinir. Hesabına bağlı öteki '
      'cihazlardan da silinir. Bu geri alınamaz. Hikâye ilerlemen ve defterin '
      'yerinde kalır.';
}

/// "Söyle" alıştırmaları (H-055). Puan, yüzde ve "yanlış" yok; utandırmaz.
abstract final class SpeakTexts {
  // Düğmeler
  static const say = 'Söyle';
  static const sayAgain = 'Bir daha söyle';
  static const meaningSay = 'Sen de söyle';
  static const decisionSay = 'Söyleyerek seç';
  static const skip = 'Geç';
  static const stop = 'Bitirdim';
  static const listening = 'Dinliyorum… Söyleyince biraz bekle.';

  // Geri bildirim
  static const full = 'Söyledin!';
  static const closeTitle = 'Neredeyse!';
  static String close(String word) => 'Neredeyse! Şu kelimeyi duyamadım: $word';
  static String missing(List<String> words) => words.length == 1
      ? 'Şu kelimeyi duyamadım: ${words.single}'
      : 'Şu kelimeleri duyamadım: ${words.join(', ')}';
  static const tryAgain = 'Bir daha dene.';
  static const silence = 'Seni duyamadım. Bir daha dene.';
  static const reveal = 'Sorun değil. İfade şöyle:';
  static const why = 'Neden böyle?';

  // Kelime tekrarı
  static const reviewTask = 'Dinle ve söyle.';
  static const reviewHint =
      'Dinle, sonra mikrofona dokunup İngilizcesini söyle.';
  static const reviewAccept = 'Devam et';

  // Karar anı
  static const decisionUnclear = 'Seni tam duyamadım. İstersen dokunarak seç.';
  static const decisionTapOnly = 'Dokunarak seçebilirsin.';

  // Bölüm sonu
  static const endSection = 'Hedef ifadeleri söyle';
  static const endIntro =
      'İstersen bu bölümün ifadelerini bir kez de sen söyle. İsteğe bağlı.';

  // İzin öncesi açıklama
  static const permissionTitle = 'Söyle alıştırmaları';
  static const permissionBody =
      'Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere '
      'gönderilmez. Söylediğinin yazısı da saklanmaz; yalnızca '
      '"söyledin" ya da "bir daha dene" sonucu bu cihazda kalır.';
  static const permissionNext =
      'Şimdi telefonun mikrofon ve konuşma tanıma iznini soracak.';
  static const permissionContinue = 'Devam et';
  static const permissionLater = 'Şimdi değil';
  static const permissionDenied =
      'İzin verilmedi. Her şey dokunarak çalışmaya devam eder.';

  // Profil
  static const profileToggle = 'Söyle alıştırmaları';
  static const profilePrivacy =
      'Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere '
      'gönderilmez.';
  static const profileUnsupported =
      'Bu telefon İngilizceyi kendi içinde yazıya çeviremiyor; sesin dışarı '
      'gönderilmesin diye kapalı. Her şey dokunarak çalışır.';
  static const profileDenied =
      'Mikrofon izni kapalı. Telefonun Ayarlar bölümünden açabilirsin; her '
      'şey dokunarak da çalışır.';
  static const profileUnavailable = 'Kapalı';

  // "Hi benim hakkımda ne biliyor?"
  static const privacyRow = 'Söyle alıştırmaları';
  static String privacyValue(int attempts, int full) => attempts == 0
      ? 'Henüz söylemedin. Sesin ve söylediklerinin yazısı hiç saklanmaz.'
      : '$attempts kez söyledin; $full tanesinde ifadenin tamamı duyuldu. '
            'Yalnızca bu sonuç saklanır; sesin ve söylediklerinin yazısı '
            'saklanmaz.';
}

/// Hesap ve eşitleme (H-038). Hesap isteğe bağlıdır; hesapsız her şey
/// çalışır. Sıkıştırmayan, suçlamayan, sakin dil; teknik terim yok.
abstract final class AccountTexts {
  static const section = 'Hesap';

  // Profil satırı ve Ana Sayfa kartı
  static const tileSignedOut = 'Hesap aç ya da giriş yap';
  static const localOnly =
      'İlerlemen yalnızca bu telefonda. Kaybolmasın istersen hesap aç.';
  static const nudgeTitle = 'İlerlemen yalnızca bu telefonda';
  static const nudgeBody =
      'Kaybolmasın istersen hesap aç. İstemezsen hesapsız devam edebilirsin.';
  static const nudgeOpen = 'Hesap aç';
  static const nudgeLater = 'Şimdi değil';
  static String tileSignedIn(String email) => 'Hesabın: $email';

  // Profil → Hesap satırı (H-059): sağda kısa durum.
  static const rowValueSignedOut = 'Açık değil';
  static const rowValueBlocked = '13+';

  // Yaş (H-002): 13 yaş altı hesap açamaz; uygulamanın tamamı çalışır.
  static const ageBlockedTitle = 'Hesap için en az 13 yaş';
  static const ageBlocked =
      'Hesap açmak için en az 13 yaşında olmalısın; uygulamanın tamamını '
      'hesapsız kullanabilirsin.';
  static const ageBlockedNothingSaved = 'Yazdığın bilgiler kaydedilmedi.';
  static const backToApp = 'Uygulamaya dön';

  // Hesap ekranı (oturum kapalı)
  static const title = 'Hesap';
  static const intro = 'Hesap isteğe bağlı. Hesapsız da her şey çalışır.';
  static const benefitBackup =
      'Hesap açarsan ilerlemen, defterin ve Hi\'nin kayıtları hesabına '
      'yedeklenir.';
  static const benefitDevices =
      'Başka bir telefonda aynı hesapla giriş yapınca kaldığın yerden devam '
      'edersin.';
  static const benefitLocal =
      'Hesap açmazsan hiçbir bilgin bu telefondan çıkmaz.';
  static const methodsHeading = 'Nasıl devam etmek istersin?';

  // Fayda satırları (H-059): kısa başlık + açıklama.
  static const benefitBackupTitle = 'İlerlemen yedeklenir';
  static const benefitDevicesTitle = 'Başka telefonda devam et';
  static const benefitLocalTitle = 'Hesapsız da her şey çalışır';
  static const methodEmail = 'E-postayla devam et';
  static const methodEmailNote =
      'Şifre yok: e-postana tek kullanımlık bir kod göndeririz.';

  // Giriş: e-posta
  static const signInTitle = 'Hesap aç ya da giriş yap';
  static const emailHeading = 'E-posta adresin';
  static const emailLabel = 'E-posta';
  static const emailHelper =
      'Hesabın varsa giriş yaparsın, yoksa yeni hesap açılır.';
  static const emailInvalid = 'Geçerli bir e-posta adresi yaz.';
  static const sendCode = 'Kod gönder';

  // Giriş: kod
  static const codeHeading = 'Kodu yaz';
  static String codeSent(String email, int minutes) =>
      '$email adresine 6 haneli bir kod gönderdik. Kod $minutes dakika '
      'geçerli.';
  static const codeLabel = '6 haneli kod';
  static const codeInvalidFormat = 'Kod 6 rakamdan oluşur.';
  static const verify = 'Doğrula';
  static String resendIn(int seconds) =>
      'Yeni kodu $seconds sn sonra isteyebilirsin.';
  static const resend = 'Yeni kod gönder';
  static const codeResent = 'Yeni kod gönderildi.';
  static const changeEmail = 'E-postayı değiştir';
  static const checking = 'Kontrol ediliyor…';

  // Kayıt bilgileri (yeni hesap)
  static const signupHeading = 'Hesabını aç';
  static const signupIntro = 'Son birkaç bilgi kaldı.';
  static const birthYearLabel = 'Doğum yılın';
  static const birthYearHelper = 'Yalnızca yılı soruyoruz.';
  static const birthYearInvalid = 'Doğum yılını dört haneli yaz (ör. 2008).';
  static const displayNameLabel = 'Sana nasıl seslenelim? (isteğe bağlı)';
  static const displayNameInvalid =
      'Yalnızca harf, boşluk, kesme işareti ve tire kullanabilirsin.';
  static const termsCheck = 'Kullanım koşullarını okudum, kabul ediyorum.';
  static const privacyCheck = 'KVKK aydınlatma metnini okudum.';
  static const readText = 'Metni aç';
  static const marketing =
      'hiVelzon\'daki yenilikleri e-postayla almak istiyorum.';
  static const marketingNote = 'İsteğe bağlı. İstediğin zaman vazgeçebilirsin.';
  static const consentMissing = 'Devam etmek için iki metni de onayla.';
  static const createAccount = 'Hesabımı aç';

  // Silinmek üzere olan hesap
  static const restoreHeading = 'Hesabın silinmek üzere';
  static String restoreBody(String date) =>
      'Hesabını silme isteğin var. $date tarihine kadar geri alabilirsin; o '
      'gün hesabın ve hesabındaki veriler kalıcı olarak silinir.';
  static const restore = 'Hesabımı geri al';
  static const restoreDecline = 'Geri alma, çıkış yap';
  static const restored = 'Hesabın geri alındı.';
  static String pendingDeletion(String date) =>
      'Hesabın silinmek üzere. $date tarihine kadar e-postanla yeniden giriş '
      'yapıp geri alabilirsin.';

  // İlk eşitleme
  static const syncing = 'Verilerin eşitleniyor…';
  static const synced = 'Verilerin eşitlendi';
  static const syncedBody = 'Bu telefondaki ilerlemen artık hesabında da.';
  static const syncLater =
      'Şu an eşitlenemedi. Verilerin bu telefonda duruyor; bağlantı gelince '
      'kendiliğinden eşitlenir.';
  static const done = 'Tamam';

  // Oturum açıkken
  static const signedInHeading = 'Giriş yaptığın hesap';
  static String syncLine(DateTime? last, DateTime now) {
    if (last == null) return 'Eşitleme: henüz yapılmadı';
    final d = now.difference(last);
    if (d.inMinutes < 1) return 'Eşitleme: az önce';
    if (d.inHours < 1) return 'Eşitleme: son ${d.inMinutes} dk önce';
    if (d.inDays < 1) return 'Eşitleme: son ${d.inHours} sa önce';
    return 'Eşitleme: son ${d.inDays} gün önce';
  }

  static const syncWaiting = 'Bağlantı gelince kendiliğinden eşitlenecek.';

  // Tehlikeli bölge (H-059): geri alınması zor eylemler ayrı grupta.
  static const dangerZone = 'Tehlikeli bölge';
  static const wipeRowHint =
      'Çıkış yapılır. Hesabındaki kopya durur; yeniden giriş yapınca geri '
      'gelir.';
  static const deleteRowHint =
      '30 gün içinde aynı e-postayla giriş yapıp geri alabilirsin.';
  static const syncNow = 'Şimdi eşitle';
  static const syncNowDone = 'Eşitlendi.';
  static const signOut = 'Çıkış yap';
  static const signOutTitle = 'Çıkış yapılsın mı?';
  static const signOutBody =
      'Verilerin bu telefonda kalır; eşitleme durur. İstediğin zaman yeniden '
      'giriş yapabilirsin.';
  static const wipeAlso = 'Bu telefondaki verileri sil';
  static const wipeTitle = 'Bu telefondaki veriler de silinsin mi?';
  static const wipeBody =
      'İlerlemen, defterin ve Hi\'nin kayıtları bu telefondan silinir. '
      'Hesabındaki kopya durur; yeniden giriş yapınca geri gelir.';
  static const wipeConfirm = 'Sil ve çıkış yap';
  static const cancel = 'Vazgeç';
  static const signedOut = 'Çıkış yaptın. Verilerin bu telefonda.';
  static const signedOutWiped = 'Çıkış yaptın; bu telefondaki veriler silindi.';
  static const deleteAccount = 'Hesabımı sil';
  static const deleteTitle = 'Hesabın silinsin mi?';
  static const deleteBody =
      '30 gün içinde aynı e-postayla giriş yapıp hesabını geri alabilirsin. '
      '30 gün sonra hesabın ve hesabındaki veriler kalıcı olarak silinir. Bu '
      'telefondaki verilerin silinmez.';
  static String deleted(String date) =>
      'Silme isteğin alındı. $date tarihine kadar geri alabilirsin.';

  // Oturum cihazda kapandıysa (sakin açıklama)
  static String? signedOutReason(String? code) => switch (code) {
    'TOKEN_REUSED' =>
      'Güvenliğin için bu telefondaki oturumu kapattık. Verilerin bu telefonda '
          'duruyor; istersen yeniden giriş yapabilirsin.',
    'REFRESH_TOKEN_INVALID' =>
      'Oturumun sona erdi. Verilerin bu telefonda duruyor; istersen yeniden '
          'giriş yapabilirsin.',
    _ => null,
  };

  // Hukuk metinleri (yer tutucu; kesin metinler H-042)
  static const termsTitle = 'Kullanım koşulları';
  static const privacyTitle = 'KVKK aydınlatma metni';
  static String legalVersion(String v) => 'Sürüm: $v';
  static const legalDraftTitle = 'Taslak metin';
  static const legalDraft =
      'Bu bir taslak. Kesin metin yayından önce buraya eklenecek.';

  /// Yer tutucu metinler bölüm bölüm: (başlık, metin). Kesin metinler H-042.
  static const termsSections = <(String, String)>[
    ('Uygulama', 'hiVelzon ücretsiz bir İngilizce öğrenme uygulamasıdır.'),
    ('Hesap', 'Hesap isteğe bağlıdır. Hesapsız da her şey çalışır.'),
    (
      'Hesabını silmek',
      'Hesabını istediğin zaman silebilirsin; silme isteğinden sonra 30 gün '
          'içinde geri alabilirsin.',
    ),
  ];
  static const privacySections = <(String, String)>[
    (
      'Hesap açarsan',
      'E-posta adresin, doğum yılın, isteğe bağlı adın ve öğrenme ilerlemen '
          'saklanır.',
    ),
    ('Sesin', 'Sesin ve söylediklerinin yazısı hiçbir zaman saklanmaz.'),
    ('Hesap açmazsan', 'Hiçbir bilgin bu telefondan çıkmaz.'),
  ];

  /// Hata kodunun Türkçe açıklaması (sunucu metni yedek).
  static String errorFor(String code, {String? fallback}) => switch (code) {
    'NETWORK' =>
      'Bağlantı kurulamadı. İnternet bağlantını kontrol edip tekrar dene.',
    'OTP_INVALID' => 'Bu kod eşleşmedi. E-postandaki kodu bir daha kontrol et.',
    'OTP_EXPIRED' => 'Bu kodun süresi doldu. Yeni bir kod isteyebilirsin.',
    'OTP_TOO_MANY_ATTEMPTS' =>
      'Bu kod için deneme hakkın bitti. Yeni bir kod isteyebilirsin.',
    'RATE_LIMITED' => 'Kısa sürede çok istek geldi. Biraz sonra tekrar dene.',
    'AGE_NOT_ALLOWED' => ageBlocked,
    'CONSENT_VERSION_OUTDATED' =>
      'Metnin yeni bir sürümü var. Uygulamayı güncelleyip yeniden dene.',
    'TOKEN_REUSED' || 'REFRESH_TOKEN_INVALID' => signedOutReason(code)!,
    'ACCOUNT_PENDING_DELETION' =>
      'Hesabın silinmek üzere. Devam etmek için önce hesabını geri '
          'alabilirsin.',
    'MAIL_UNAVAILABLE' =>
      'Şu an e-posta gönderemedik. Biraz sonra tekrar dene.',
    'VALIDATION_FAILED' =>
      'Bilgilerde bir eksik var. Kontrol edip tekrar dene.',
    _ => fallback ?? 'Beklenmeyen bir sorun oldu. Biraz sonra tekrar dene.',
  };

  static const _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', //
    'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  /// `12 Kasım 2026` (yerel saat).
  static String date(DateTime t) {
    final l = t.toLocal();
    return '${l.day} ${_months[l.month - 1]} ${l.year}';
  }
}

/// Açılış ve yerleştirme (H-039; ARAYUZ-METINLERI §13). Hesap istemez;
/// yalnızca doğum yılı ve isteğe bağlı ad, ikisi de bu telefonda. Test
/// atlanabilir, süresiz; sonuç yalnızca öneridir (K-06, K-08). Suçlamasız,
/// geri sayımsız (K-32).
abstract final class OnboardingTexts {
  static const loading = 'hiVelzon açılıyor…';
  static const back = CommonTexts.back;
  static String stepLabel(int step, int total) => 'Adım $step / $total';

  // Karşılama
  static const welcomeTitle = 'hiVelzon\'a hoş geldin!';
  static const welcomeBody = 'Bir hikâye oyna, İngilizceyi oynarken öğren.';
  static const welcomeNoAccount = 'Hesap gerekmez. Her şey bu telefonda kalır.';
  static const welcomeStart = CommonTexts.start;

  // Seni tanıyalım
  static const aboutTitle = 'Seni biraz tanıyalım';
  static const aboutBody =
      'İki kısa soru. Cevapların yalnızca bu telefonda kalır.';
  static const birthYearLabel = AccountTexts.birthYearLabel;
  static const birthYearHelper =
      'Yalnızca yılı soruyoruz. Bazı özellikler yaşa göre açılır.';
  static const birthYearEmpty = 'Doğum yılını yaz (ör. 2008).';
  static const birthYearInvalid = AccountTexts.birthYearInvalid;
  static const birthYearOutOfRange = 'Bu yılı bir daha kontrol eder misin?';
  static const nameHeading = ProfileTexts.nameSection;
  static const nameLabel = ProfileTexts.nameLabel;
  static const nameHelper = ProfileTexts.nameHelper;
  static const nameTooLong = ProfileTexts.nameTooLong;
  static const nameInvalid = ProfileTexts.nameInvalid;

  // Gizlilik ve bilgilendirme
  static const privacyTitle = 'Bilmen gerekenler';
  static const privacyBody = 'Kısaca, bilgilerinle ne yaptığımız:';
  static const privacyPoints = <(String, String)>[
    (
      'Her şey bu telefonda',
      'Hesap gerekmez. İlerlemen, defterin ve ayarların yalnızca bu telefonda '
          'saklanır.',
    ),
    (
      'Sesin kaydedilmez',
      '"Söyle" alıştırmalarında sesin telefonda tanınır; kaydedilmez ve '
          'hiçbir yere gönderilmez.',
    ),
    (
      'Reklam yok',
      'Uygulamada reklam yok; seni başka uygulamalarda izlemiyoruz.',
    ),
    (
      'Yapay zekâ',
      'Hikâye videoları yapay zekâ ile üretilir. Hi de bir yapay zekâ '
          'yardımcısıdır.',
    ),
  ];
  static const privacyUnder13 =
      '13 yaşından küçüksen bu sayfayı bir büyüğünle birlikte oku.';
  static const termsLink = AccountTexts.termsTitle;
  static const privacyLink = AccountTexts.privacyTitle;
  static const draftTitle = AccountTexts.legalDraftTitle;
  static const draftBody =
      'Kullanım koşulları ve aydınlatma metni taslak. Kesin metin yayından '
      'önce eklenecek.';
  static const privacyAccept = 'Anladım, devam et';

  // Tercihler
  static const prefsTitle = 'Sana uygun ayarlar';
  static const prefsBody = 'İkisini de sonra değiştirebilirsin.';
  static const goalHeading = ProfileTexts.goalSection;
  static const goalIntro = ProfileTexts.goalIntro;
  static String goalOption(int minutes) => ProfileTexts.goalOption(minutes);
  static const turkishLineTitle = 'Altyazıda Türkçe satır';
  static const turkishLineBody =
      'İngilizce altyazının altında küçük bir Türkçe satır. 1. Sezon (A1) '
      'için önerimiz: açık. Oynatıcıdan da değiştirebilirsin.';

  // Seviye
  static const levelTitle = 'Seviyeni merak ediyor musun?';
  static const levelBody =
      'Kısa bir test sana bir başlangıç seviyesi önerir. Süre yok, en fazla '
      '20 soru. İstediğin an bırakabilirsin.';
  static const levelGuessHeading = 'Kendi tahminin';
  static const levelGuessUnknown = 'Bilmiyorum';
  static const levelStart = 'Teste başla';
  static const levelSkip = 'Testi atla';

  // Soru
  static String questionLabel(int n, int max) => 'Soru $n · en fazla $max';
  static const instructionVocabulary = 'Boşluğa uygun kelimeyi seç.';
  static const instructionGrammar = 'Boşluğa uygun olanı seç.';
  static const instructionReading = 'Metni oku, soruyu cevapla.';
  static const dontKnow = 'Bilmiyorum';
  static const quitTest = 'Testi bırak';

  // Sonuç
  static const resultCaps = 'Önerilen başlangıç seviyesi';
  static String resultSemantics(String code) =>
      'Önerilen başlangıç seviyesi: $code';
  static String resultBody(String code) => code == 'A1'
      ? 'Hikâyenin 1. Sezonu A1 seviyesinde; tam senin için.'
      : 'Şimdilik hikâyenin yalnızca 1. Sezonu (A1) hazır. Bölümler sana '
            'kolay gelebilir; hikâyenin ve ifadelerin tadını çıkar.';
  static const resultNoteTitle = 'Bu yalnızca bir öneri';
  static const resultNote =
      'Kısa bir tahmin; sınav ya da sertifika sonucu değil.';
  static const resultContinue = CommonTexts.continueAction;

  // Hazır
  static const readyTitle = 'Her şey hazır';
  static const readyBody =
      'Alex şehre yeni geldi. Hikâyesine birlikte başlayalım.';
  static const readyLocalTitle = 'İlerlemen bu telefonda';
  static const readyLocalTeen =
      'İstersen sonra Profil\'den hesap açıp ilerlemeni yedekleyebilirsin.';
  static const readyLocalChild = 'Hesap gerekmez; her şey bu telefonda kalır.';
  static const readyStart = 'Hikâyeye başla';
}
