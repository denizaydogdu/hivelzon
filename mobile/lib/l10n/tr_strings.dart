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
  static const continueAction = 'Devam et';
}
