import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/sync/sync_ids.dart';

/// Backend `UuidsTest` ile aynı girdiler ve beklenen değerler (H-038): iki
/// taraf aynı satır kimliğini üretmeli.
const vectors = {
  'user_story_flags:A1-002|greet_tone': '8cc37cb7-98a0-52ff-b79e-6260d302a489',
  'user_story_progress:A1-001': 'aed2a1d8-95cf-52de-bcc2-5fb2bf6860f0',
  'season_state:1': 'd3147e52-35d9-5898-8ddc-ab9721b00660',
  'notebook_items:phrase|can you hear me?':
      'bba85315-8783-545b-b4fa-5150fa6bd4ca',
  'review_cards:phrase|can you hear me?':
      'cbe4a0d5-f3a8-57c9-ae03-0ccba42ae872',
  'hi_records:hi_reset|all': '9ada9723-770e-51a4-80a7-64290f2b3853',
  'gate_progress:A1-001|activeTask|t-kanit':
      '016b2cb0-a692-568f-a69d-3090ec5db262',
  'review_logs:cbe4a0d5-f3a8-57c9-ae03-0ccba42ae872|2026-10-13T09:05:00Z|3':
      '815799ab-b9c7-5461-9431-881f4908fde9',
  'notebook_items:word|çay': '9ed87269-6fbc-5124-a567-3d4b4f243d52',
};

void main() {
  test('UUIDv5 backend ile aynı (test vektörleri)', () {
    vectors.forEach((name, id) => expect(SyncIds.v5(name), id, reason: name));
  });

  test('doğal anahtar ve kart/cevap kuralları', () {
    expect(
      SyncIds.natural('user_story_flags', ['A1-002', 'greet_tone']),
      vectors['user_story_flags:A1-002|greet_tone'],
    );
    expect(SyncIds.natural('season_state', [1]), vectors['season_state:1']);
    final card = SyncIds.card('phrase|can you hear me?');
    expect(card, 'cbe4a0d5-f3a8-57c9-ae03-0ccba42ae872');
    expect(
      SyncIds.reviewLog(card, DateTime.utc(2026, 10, 13, 9, 5), 3),
      '815799ab-b9c7-5461-9431-881f4908fde9',
    );
  });

  test('Java Instant biçimi', () {
    expect(
      javaInstant(DateTime.utc(2026, 10, 13, 9, 5)),
      '2026-10-13T09:05:00Z',
    );
    expect(
      javaInstant(DateTime.utc(2026, 10, 13, 9, 5, 0, 120)),
      '2026-10-13T09:05:00.120Z',
    );
    expect(
      javaInstant(DateTime.utc(2026, 10, 13, 9, 5, 0, 120, 5)),
      '2026-10-13T09:05:00.120005Z',
    );
  });

  test('eski olay kimliği tireli UUID olur (aynı değer)', () {
    expect(
      SyncIds.fromLegacyEventId('0123456789abcdef0123456789abcdef'),
      '01234567-89ab-cdef-0123-456789abcdef',
    );
    expect(SyncIds.isUuid(SyncIds.fromLegacyEventId('legacy-1')), isTrue);
    expect(SyncIds.isUuid(SyncIds.v4()), isTrue);
  });
}
