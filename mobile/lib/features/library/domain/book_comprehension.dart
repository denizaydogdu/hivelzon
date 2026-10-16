// Kitap sonu anlama (H-091; `docs/KITAPLIK.md` §6.6, §7.1). Saf Dart.
//
// İçerik `book.json → comprehension`: tam 2 çoktan seçmeli soru (3 seçenek,
// tek doğru) ve isteğe bağlı yeniden anlatma için model özet. Sonuç cihazda
// yalnızca sayı ve öz değerlendirme olarak tutulur; kullanıcının yazdığı
// metin hiçbir yere yazılmaz.

/// Bir anlama sorusu.
class ComprehensionQuestion {
  const ComprehensionQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.answer,
    this.promptTr,
    this.pageId,
  });

  /// Geçersiz soru (seçenek sayısı ya da cevap sırası bozuk) null döner.
  static ComprehensionQuestion? fromJson(Object? json) {
    if (json is! Map) return null;
    final options = [
      for (final o in (json['options'] as List? ?? const []))
        if (o is String && o.trim().isNotEmpty) o,
    ];
    final answer = json['answer'];
    final prompt = json['prompt'];
    if (prompt is! String || prompt.trim().isEmpty) return null;
    if (options.length < 2 || answer is! int) return null;
    if (answer < 0 || answer >= options.length) return null;
    return ComprehensionQuestion(
      id: (json['id'] as String?) ?? '',
      prompt: prompt,
      promptTr: json['promptTr'] as String?,
      options: options,
      answer: answer,
      pageId: json['page'] as String?,
    );
  }

  final String id;
  final String prompt;
  final String? promptTr;
  final List<String> options;

  /// Doğru seçeneğin sırası (0'dan).
  final int answer;

  /// Cevabın geçtiği sayfa (`p05`).
  final String? pageId;
}

/// Kitabın sonu: sorular + model özet.
class BookComprehension {
  const BookComprehension({
    required this.questions,
    required this.modelEn,
    this.modelTr,
  });

  /// İçerik yoksa ya da kullanılamazsa null (okuyucu doğrudan kitap sonuna
  /// geçer).
  static BookComprehension? fromJson(Object? json) {
    if (json is! Map) return null;
    final questions = [
      for (final q in (json['questions'] as List? ?? const []))
        ?ComprehensionQuestion.fromJson(q),
    ];
    final retell = json['retell'];
    final modelEn = retell is Map ? retell['modelEn'] : null;
    if (questions.isEmpty || modelEn is! String || modelEn.trim().isEmpty) {
      return null;
    }
    return BookComprehension(
      questions: questions,
      modelEn: modelEn,
      modelTr: retell is Map ? retell['modelTr'] as String? : null,
    );
  }

  final List<ComprehensionQuestion> questions;
  final String modelEn;
  final String? modelTr;
}

/// Yeniden anlatmanın öz değerlendirmesi (puan değil).
enum RetellSelfCheck {
  all('all'),
  some('some'),
  notYet('not_yet');

  const RetellSelfCheck(this.code);

  final String code;

  static RetellSelfCheck? parse(Object? v) {
    for (final s in values) {
      if (s.code == v) return s;
    }
    return null;
  }
}

/// Kaydedilen sonuç (Drift `user_book_comprehension`).
class ComprehensionResult {
  const ComprehensionResult({
    required this.bookId,
    required this.answered,
    required this.firstTryCorrect,
    required this.retellDone,
    this.contentVersion = 1,
    this.selfCheck,
    this.completedAt,
  });

  final String bookId;
  final int contentVersion;
  final int answered;
  final int firstTryCorrect;
  final bool retellDone;
  final RetellSelfCheck? selfCheck;
  final DateTime? completedAt;
}
