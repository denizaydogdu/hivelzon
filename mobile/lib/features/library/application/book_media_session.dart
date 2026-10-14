/// Kitap sesinin kilit ekranı ve bildirim oturumu (H-068).
///
/// [BookAudio] arayüzü değişmez; arka planda çalabilen ses ayrıca bu arayüzü
/// taşır. Okuyucu sesi [BookMediaSession] ise kilit ekranı komutlarını dinler
/// ve bölüm değişince künyeyi (kitap, bölüm, kapak) günceller.
library;

/// Kilit ekranından, bildirimden ya da kulaklık düğmesinden gelen komut.
/// Sistem kesintileri (telefon araması, kulaklığın çıkması) de buraya
/// çevrilir: okuyucu sesin tek sahibi kalır.
enum BookRemoteCommand { play, pause, back10, nextChapter, stop }

/// Kilit ekranında görünen künye.
class BookMediaInfo {
  const BookMediaInfo({
    required this.bookTitle,
    required this.chapterTitle,
    this.artUri,
    this.hasNextChapter = false,
  });

  final String bookTitle;
  final String chapterTitle;

  /// Paketteki kapak (`images/cover.webp`) adresi; yoksa null.
  final Uri? artUri;

  /// Sıradaki bölüm (sesi hazır) var mı: "Sonraki bölüm" düğmesi.
  final bool hasNextChapter;

  @override
  bool operator ==(Object other) =>
      other is BookMediaInfo &&
      other.bookTitle == bookTitle &&
      other.chapterTitle == chapterTitle &&
      other.artUri == artUri &&
      other.hasNextChapter == hasNextChapter;

  @override
  int get hashCode =>
      Object.hash(bookTitle, chapterTitle, artUri, hasNextChapter);

  @override
  String toString() => 'BookMediaInfo($bookTitle, $chapterTitle)';
}

/// Arka planda çalabilen kitap sesinin oturum yüzü.
abstract interface class BookMediaSession {
  /// Kilit ekranı / bildirim komutları (yalnız oturumun sahibine gelir).
  Stream<BookRemoteCommand> get commands;

  /// Künyeyi günceller (aynı künye ikinci kez gönderilmez).
  Future<void> setMediaInfo(BookMediaInfo info);
}
