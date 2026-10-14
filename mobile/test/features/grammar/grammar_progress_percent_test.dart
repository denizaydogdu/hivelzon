import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/domain/grammar_lesson.dart';
import 'package:hivelzon/features/grammar/domain/grammar_progress.dart';
import 'package:hivelzon/shared/speech/example_speech.dart';

GrammarLessonSummary _lesson(String id, {int? cards = 7}) =>
    GrammarLessonSummary(
      id: id,
      level: GrammarLessonSummary.levelOf(id),
      titleTr: id,
      cardCount: cards,
    );

GrammarProgress _p(String id, GrammarStatus s, [String? card]) =>
    GrammarProgress(lessonId: id, status: s, lastCard: card);

/// Dilbilgisi listesindeki ilerleme yüzdesi ve seviye özeti; cihaz sesi
/// seçimi (H-064 ek).
void main() {
  group('grammarLessonProgress', () {
    final l = _lesson('G-A1-03-a-an');

    test('kayıt yok ya da başlanmadı → %0', () {
      expect(grammarLessonProgress(l, null), GrammarLessonProgress.notStarted);
      expect(
        grammarLessonProgress(l, _p(l.id, GrammarStatus.notStarted)),
        GrammarLessonProgress.notStarted,
      );
    });

    test('bitti → %100 (kalınan kart ne olursa olsun)', () {
      final r = grammarLessonProgress(
        l,
        _p(l.id, GrammarStatus.completed, 'c02'),
      );
      expect(r.percent, 100);
      expect(r.isCompleted, isTrue);
    });

    test('sürüyor: görülen kart / kart sayısı', () {
      expect(
        grammarLessonProgress(
          l,
          _p(l.id, GrammarStatus.inProgress, 'c03'),
        ).percent,
        43,
      );
      expect(
        grammarLessonProgress(
          l,
          _p(l.id, GrammarStatus.inProgress, 'c01'),
        ).percent,
        14,
      );
    });

    test('bitmemiş ders %100 göstermez; başlamış en az %1', () {
      expect(
        grammarLessonProgress(
          l,
          _p(l.id, GrammarStatus.inProgress, 'c07'),
        ).percent,
        99,
      );
      expect(
        grammarLessonProgress(
          l,
          _p(l.id, GrammarStatus.inProgress, 'c09'),
        ).percent,
        99,
      );
      final big = _lesson('G-A1-01-to-be', cards: 300);
      expect(
        grammarLessonProgress(
          big,
          _p(big.id, GrammarStatus.inProgress, 'c01'),
        ).percent,
        1,
      );
    });

    test('kart sayısı ya da kart sırası bilinmiyor → yüzde yok', () {
      final noCount = _lesson('G-A1-02-x', cards: null);
      final r = grammarLessonProgress(
        noCount,
        _p(noCount.id, GrammarStatus.inProgress, 'c03'),
      );
      expect(r.isStarted, isTrue);
      expect(r.percent, isNull);
      expect(
        grammarLessonProgress(
          l,
          _p(l.id, GrammarStatus.inProgress, 'hook'),
        ).percent,
        isNull,
      );
    });

    test('kart numarası', () {
      expect(grammarCardNumber('c03'), 3);
      expect(grammarCardNumber('c12'), 12);
      expect(grammarCardNumber(null), isNull);
      expect(grammarCardNumber('x03'), isNull);
    });
  });

  test('seviye özeti: bütün dersler, biten raftan bağımsız sayılır', () {
    final lessons = [
      _lesson('G-A1-01-a'),
      _lesson('G-A1-02-b'),
      _lesson('G-A1-03-c'),
      _lesson('G-A2-01-d'),
    ];
    final s = grammarLevelSummaries(lessons, {
      'G-A1-01-a': _p('G-A1-01-a', GrammarStatus.completed),
      'G-A1-02-b': _p('G-A1-02-b', GrammarStatus.inProgress, 'c02'),
      'G-X-unknown': _p('G-X-unknown', GrammarStatus.completed),
    });
    expect(
      s['A1'],
      const GrammarLevelSummary(level: 'A1', completed: 1, total: 3),
    );
    expect(
      s['A2'],
      const GrammarLevelSummary(level: 'A2', completed: 0, total: 1),
    );
    expect(s.keys, ['A1', 'A2']);
  });

  group('cihaz sesi seçimi', () {
    DeviceVoice v(
      String name,
      String locale, {
      String? id,
      String? quality,
      bool network = false,
      bool notInstalled = false,
    }) => DeviceVoice(
      name: name,
      locale: locale,
      identifier: id,
      quality: quality,
      networkRequired: network,
      notInstalled: notInstalled,
    );

    test('en-GB önce, yoksa en-US; başka dil yok', () {
      expect(
        pickEnglishVoice([
          v('Samantha', 'en-US', id: 'com.apple.voice.compact.en-US.Samantha'),
          v('Daniel', 'en-GB', id: 'com.apple.voice.compact.en-GB.Daniel'),
          v('Yelda', 'tr-TR'),
        ])?.name,
        'Daniel',
      );
      expect(
        pickEnglishVoice([
          v('Samantha', 'en-US', id: 'com.apple.voice.compact.en-US.Samantha'),
          v('Karen', 'en-AU'),
        ])?.name,
        'Samantha',
      );
      expect(pickEnglishVoice([v('Yelda', 'tr-TR')]), isNull);
      expect(pickEnglishVoice(const []), isNull);
    });

    test('Android: ağ isteyen ya da kurulu olmayan ses seçilmez', () {
      expect(
        pickEnglishVoice([
          v('en-gb-x-gba-network', 'en-GB', network: true),
          v('en-gb-x-gbb-local', 'en-GB', notInstalled: true),
          v('en-us-x-sfg-local', 'en-US'),
        ])?.name,
        'en-us-x-sfg-local',
      );
      expect(
        pickEnglishVoice([v('en-gb-x-gba-network', 'en-GB', network: true)]),
        isNull,
      );
    });

    test('Apple eğlence/eski sesleri seçilmez; kaliteli ses önce', () {
      expect(
        pickEnglishVoice([
          v('Bubbles', 'en-US', id: 'com.apple.speech.synthesis.voice.Bubbles'),
          v('Eddy', 'en-US', id: 'com.apple.eloquence.en-US.Eddy'),
          v('Alex', 'en-US', id: 'com.apple.voice.compact.en-US.Alex'),
          v(
            'Ava',
            'en-US',
            id: 'com.apple.voice.premium.en-US.Ava',
            quality: 'premium',
          ),
        ])?.name,
        'Ava',
      );
    });

    test('eklenti haritasından', () {
      final a = DeviceVoice.fromMap({
        'name': 'en-gb-x-gba-local',
        'locale': 'en-GB',
        'quality': 'very high',
        'network_required': '0',
        'features': 'networkTimeoutMs\tnotInstalled',
      })!;
      expect(a.networkRequired, isFalse);
      expect(a.notInstalled, isTrue);
      expect(a.normalizedLocale, 'en-gb');
      expect(DeviceVoice.fromMap({'name': 1}), isNull);
      expect(DeviceVoice.fromMap('x'), isNull);
      expect(
        const DeviceVoice(name: 'Daniel', locale: 'en_GB').normalizedLocale,
        'en-gb',
      );
    });

    test('hız: A1–A2 biraz yavaş', () {
      expect(exampleSpeechSpeed('A1'), 0.85);
      expect(exampleSpeechSpeed('A2'), 0.85);
      expect(exampleSpeechSpeed('B1'), 1);
    });

    test('okunan kelime: karakter konumu → ekrandaki kelime sırası', () {
      const t = 'He goes to school.';
      expect(wordIndexAt(t, 0), 0);
      expect(wordIndexAt(t, 3), 1);
      expect(wordIndexAt(t, 2), 1); // boşluk → sonraki kelime
      expect(wordIndexAt(t, 11), 3);
      expect(wordIndexAt(t, 99), 3);
      expect(wordIndexAt('', 0), isNull);
    });
  });
}
