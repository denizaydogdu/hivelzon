import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';

import '../../support/fake_content_source.dart';

final _now = DateTime.utc(2026, 10, 13, 9);

const _b2 = CoachEpisode(
  contentId: 'A1-002',
  number: 2,
  title: 'The New Neighbour',
  estimatedMinutes: 7,
);
const _b3 = CoachEpisode(
  contentId: 'A1-003',
  number: 3,
  title: 'Find the Station',
  estimatedMinutes: 7,
);
const _harbour = CoachTopicSet(
  id: 'harbour',
  titleTr: 'Liman',
  unlockEpisode: 3,
);

ErrorObservation _err(
  ErrorType t, {
  int hoursAgo = 1,
  String? contentId,
  String? sourceId,
}) => ErrorObservation(
  type: t,
  at: _now.subtract(Duration(hours: hoursAgo)),
  contentId: contentId,
  sourceId: sourceId,
);

CoachInput _input({
  CoachEpisode? inProgress,
  CoachEpisode? next,
  int completed = 0,
  int reviewDue = 0,
  List<ErrorObservation> errors = const [],
  Map<String, DateTime> notesReadAt = const {},
  List<CoachTopicSet> sets = const [],
  int goal = 10,
}) => CoachInput(
  now: _now,
  dailyGoalMinutes: goal,
  inProgress: inProgress,
  next: next,
  completedCount: completed,
  reviewDue: reviewDue,
  errors: errors,
  notesReadAt: notesReadAt,
  unhuntedSets: sets,
  content: loadHiFixture(),
);

/// Suçlayıcı ya da baskı kuran dil (ARAYUZ-METINLERI §1.3, K-32).
const _banned = [
  'yanlış',
  'başarısız',
  'kaçırdın',
  'serini',
  'son şans',
  'hemen',
  'acele et',
  'geride',
];

void _calm(HiSuggestion s) {
  final text = '${s.title} ${s.reasonTr}'.toLowerCase();
  for (final w in _banned) {
    expect(text, isNot(contains(w)), reason: '"$w" — ${s.reasonTr}');
  }
  expect(s.reasonTr, isNotEmpty);
}

void main() {
  group('öncelik tablosu (her önerinin gerekçesi var)', () {
    final table = <String, (CoachInput, HiSuggestionKind)>{
      // H-088: bugün oynanan yarım bölüm (oturumun ortası) her şeyden önce;
      // dünden kalan yarım bölüm tekrar borcunun arkasına geçer
      // (daily_plan_test.dart).
      'a) bugün oynanan yarım bölüm her şeyden önce': (
        _input(
          inProgress: CoachEpisode(
            contentId: _b2.contentId,
            number: _b2.number,
            title: _b2.title,
            estimatedMinutes: _b2.estimatedMinutes,
            lastPlayedAt: _now.subtract(const Duration(minutes: 20)),
          ),
          next: _b3,
          reviewDue: 20,
          errors: [_err(ErrorType.preposition), _err(ErrorType.preposition)],
          sets: [_harbour],
        ),
        HiSuggestionKind.continueEpisode,
      ),
      'b) tekrar ≥ 5 → kelime tekrarı': (
        _input(
          next: _b3,
          reviewDue: 5,
          errors: [_err(ErrorType.preposition), _err(ErrorType.preposition)],
        ),
        HiSuggestionKind.review,
      ),
      'c) aynı hata türü 2 kez → Hi\'nin notu': (
        _input(
          next: _b3,
          reviewDue: 4,
          errors: [_err(ErrorType.preposition), _err(ErrorType.preposition)],
        ),
        HiSuggestionKind.errorNote,
      ),
      'c) notu olmayan tür (hatırlama) → defter': (
        _input(
          next: _b3,
          errors: [_err(ErrorType.recall), _err(ErrorType.recall)],
        ),
        HiSuggestionKind.notebook,
      ),
      'd) sıradaki bölüm': (
        _input(next: _b3, completed: 2, errors: [_err(ErrorType.preposition)]),
        HiSuggestionKind.startEpisode,
      ),
      'e) sahne avı yapılmamış set': (
        _input(sets: [_harbour], reviewDue: 2),
        HiSuggestionKind.sceneHunt,
      ),
      "b') eşik altı tekrar, başka iş yoksa": (
        _input(reviewDue: 2),
        HiSuggestionKind.review,
      ),
      'f) hiçbiri → bugünlük bu kadar': (_input(), HiSuggestionKind.rest),
    };
    for (final MapEntry(key: name, value: (input, kind)) in table.entries) {
      test(name, () {
        final s = suggestToday(input);
        expect(s.kind, kind);
        _calm(s);
        if (kind != HiSuggestionKind.rest) expect(s.hasAction, isTrue);
      });
    }
  });

  test('a) gerekçe: bölüm ve kaldığı yer; süre ayrı alanda', () {
    final s = suggestToday(_input(inProgress: _b2, goal: 10));
    expect(s.title, 'Hikâyeye devam: The New Neighbour');
    expect(
      s.reasonTr,
      "Bölüm 2'yi yarıda bırakmıştın; kaldığın sahneden devam edersin.",
    );
    expect(s.reasonTr, isNot(contains('Yaklaşık')));
    expect(s.minutes, 7);
    expect(s.actionLabel, 'Devam et');
    expect(s.actionRoute, AppRoutes.play('A1-002', mode: 'resume'));
  });

  test('süre gerekçeden ayrı: hedefi aşan öneri de tek cümlede kalır', () {
    final s = suggestToday(_input(inProgress: _b2, goal: 5));
    expect(s.reasonTr, isNot(contains('Günlük hedefin 5 dk')));
    expect(s.minutes, 7);
  });

  test('b) gerekçe: ifade sayısı; düğme sayıyı söyler', () {
    final s = suggestToday(_input(reviewDue: 12));
    expect(s.reasonTr, startsWith('12 ifadenin tekrar zamanı geldi.'));
    expect(s.minutes, 4);
    expect(s.actionLabel, '12 ifadeyi tekrarla');
    expect(s.actionRoute, AppRoutes.review);
  });

  test('c) olayın kendi notu seçilir (B4 "in seven o\'clock" → at/on)', () {
    final s = suggestToday(
      _input(
        next: _b3,
        errors: [
          _err(ErrorType.preposition, hoursAgo: 30),
          _err(ErrorType.preposition, contentId: 'A1-004', sourceId: 'k2#b'),
        ],
      ),
    );
    expect(s.noteId, 'time-preposition');
    expect(s.errorType, ErrorType.preposition);
    expect(s.title, "Hi'nin notu: Saat ve gün: at / on");
    expect(s.reasonTr, contains('Son 7 günde "Edat" konusunda 2 kez'));
  });

  test('c) 7 günden eski hata sayılmaz', () {
    final s = suggestToday(
      _input(
        next: _b3,
        errors: [
          _err(ErrorType.preposition, hoursAgo: 24 * 8),
          _err(ErrorType.preposition),
        ],
      ),
    );
    expect(s.kind, HiSuggestionKind.startEpisode);
  });

  test('c) not, son hatadan sonra açıldıysa yeniden önerilmez', () {
    final errors = [
      _err(ErrorType.preposition, hoursAgo: 5),
      _err(ErrorType.preposition, hoursAgo: 4),
    ];
    final read = suggestToday(
      _input(
        next: _b3,
        errors: errors,
        notesReadAt: {'preposition': _now.subtract(const Duration(hours: 1))},
      ),
    );
    expect(read.kind, HiSuggestionKind.startEpisode);
    final older = suggestToday(
      _input(
        next: _b3,
        errors: errors,
        notesReadAt: {'preposition': _now.subtract(const Duration(hours: 10))},
      ),
    );
    expect(older.kind, HiSuggestionKind.errorNote);
  });

  test('c) en sık tür seçilir; eşitlikte en yeni', () {
    final s = suggestToday(
      _input(
        errors: [
          _err(ErrorType.wordOrder, hoursAgo: 3),
          _err(ErrorType.wordOrder, hoursAgo: 2),
          _err(ErrorType.preposition, hoursAgo: 9),
          _err(ErrorType.preposition, hoursAgo: 8),
        ],
      ),
    );
    expect(s.errorType, ErrorType.wordOrder);
    expect(s.noteId, 'question-word-order');
  });

  test('d) ilk bölüm: "Hikâye buradan başlıyor."', () {
    const b1 = CoachEpisode(
      contentId: 'A1-001',
      number: 1,
      title: 'A Strange Message',
      estimatedMinutes: 6,
    );
    final s = suggestToday(_input(next: b1));
    expect(s.reasonTr, startsWith('Hikâye buradan başlıyor.'));
    expect(s.actionRoute, AppRoutes.play('A1-001'));
    final s3 = suggestToday(_input(next: _b3, completed: 2));
    expect(
      s3.reasonTr,
      startsWith("Bölüm 2'yi bitirdin; Bölüm 3 seni bekliyor."),
    );
  });

  test('e) sahne avı rotası ve gerekçe', () {
    final s = suggestToday(_input(sets: [_harbour]));
    expect(s.actionRoute, AppRoutes.sceneHunt('harbour'));
    expect(s.reasonTr, contains('"Liman" seti açıldı'));
    expect(s.reasonTr, contains('süre yok'));
  });

  test('f) dinlenme önerisinde eylem yok', () {
    final s = suggestToday(_input());
    expect(s.title, 'Bugünlük bu kadar yeter');
    expect(s.hasAction, isFalse);
  });
}
