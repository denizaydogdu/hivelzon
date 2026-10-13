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
  static const empty =
      'Defterin henüz boş. Bir bölümü bitirince hedef ifadeler buraya gelir. '
      'Altyazıda bir kelimeye dokunup "Deftere ekle" de diyebilirsin.';
  static const noMatch = 'Aradığın ifade defterinde yok.';
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
  static const cluesEmpty =
      'Henüz ipucu yok. Bölüm sonunda bulduğun ipuçları ve açık sorular '
      'burada toplanır.';
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
  static String helped(int n) => '$n nesneye birlikte baktık.';
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
  static String tomorrow(int n) => '$n ifade yarın yeniden gelecek.';
  static String later(int n) => '$n ifade daha sonra gelecek.';
  static const done = 'Tamam';
}

/// Profil.
abstract final class ProfileTexts {
  static const title = 'Profil';
  static const subtitle = 'Adın, defterin ve günlük hedefin.';
  static const nameSection = 'Sana nasıl seslenelim?';
  static const nameLabel = 'Adın ya da takma adın';
  static const nameHelper = 'İsteğe bağlı. Yalnızca bu cihazda saklanır.';
  static const nameTooLong = 'En fazla 20 karakter yazabilirsin.';
  static const nameInvalid =
      'Yalnızca harf, boşluk, kesme işareti ve tire kullanabilirsin.';
  static const nameSaved = 'Adın kaydedildi.';
  static const nameCleared = 'Adın silindi; Ana Sayfa "Merhaba!" der.';
  static const notebookSection = 'Defter';
  static const notebookTile = 'Defterini aç';
  static const notebookLoading = 'İfadeler ve İpucu panosu';
  static const notebookEmpty =
      'Henüz ifade yok. Bölüm bitince ifadeler buraya eklenir.';
  static String notebookCount(int total, int due) => due > 0
      ? 'Defterinde $total ifade var; $due ifadenin tekrar zamanı geldi.'
      : 'Defterinde $total ifade var.';
  static const goalSection = 'Günlük hedef';
  static const goalIntro = 'Günde ne kadar zaman ayırmak istersin?';
  static String goalOption(int minutes) => '$minutes dk';
  static String goalNote(int newPerDay) =>
      'Kelime tekrarında günde en fazla $newPerDay yeni ifade açılır.';
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

/// Oynatıcıda değişen metinler (geri kalanı widget'larda; kılavuzda listeli).
abstract final class PlayerTexts {
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
      'Hi önerilerini yalnızca bu cihazdaki kayıtlara bakarak seçer. '
      'Bu bilgiler sunucuya gönderilmez ve reklam için kullanılmaz.';
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
  static const profileSection = 'Söyle alıştırmaları';
  static const profileToggle = 'Söyle alıştırmalarını göster';
  static const profileToggleSub =
      'Kelime tekrarında, anlam panelinde, karar anında ve bölüm sonunda '
      'İngilizceyi sesli söyleyebilirsin. İsteğe bağlıdır.';
  static const profilePrivacy =
      'Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere '
      'gönderilmez.';
  static const profileUnsupported =
      'Bu telefon İngilizce konuşmayı kendi içinde yazıya çeviremiyor. '
      'Sesin dışarı gönderilmesin diye Söyle alıştırmaları kapalı; her şey '
      'dokunarak çalışır.';
  static const profileDenied =
      'Mikrofon ya da konuşma tanıma izni kapalı. İstersen telefonun '
      'Ayarlar bölümünden açabilirsin; her şey dokunarak da çalışır.';

  // "Hi benim hakkımda ne biliyor?"
  static const privacyRow = 'Söyle alıştırmaları';
  static String privacyValue(int attempts, int full) => attempts == 0
      ? 'Henüz söylemedin. Sesin ve söylediklerinin yazısı hiç saklanmaz.'
      : '$attempts kez söyledin; $full tanesinde ifadenin tamamı duyuldu. '
            'Yalnızca bu sonuç saklanır; sesin ve söylediklerinin yazısı '
            'saklanmaz.';
}
