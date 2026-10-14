/// Eşitlenen tabloların tanımı (H-038): backend `ProgressSyncTables` ve
/// `LearningSyncTables` aynası. JSON adları mobil Drift alanlarıyla aynı
/// (camelCase), kolonlar snake_case.
library;

enum SyncType { text, integer, real, boolean, dateTime, jsonObject, jsonArray }

class SyncCol {
  const SyncCol(this.json, this.column, this.type, {this.localDefault});

  final String json;
  final String column;
  final SyncType type;

  /// Sunucuda boş olabilen ama yerelde `NOT NULL` kolonun varsayılanı.
  final Object? localDefault;

  bool get isJson => type == SyncType.jsonObject || type == SyncType.jsonArray;
}

class SyncTableSpec {
  const SyncTableSpec({
    required this.name,
    required this.order,
    required this.mutable,
    required this.keys,
    required this.data,
    this.lww,
  });

  final String name;

  /// Uygulama sırası (küçük önce; backend ile aynı).
  final int order;

  /// Değişebilir (son yazan kazanır, silme işareti) mi, yalnız eklenen mi.
  final bool mutable;

  /// Doğal anahtar (boşsa UUID `clientId`).
  final List<SyncCol> keys;
  final SyncCol? lww;
  final List<SyncCol> data;

  bool get naturalKey => keys.isNotEmpty;

  List<SyncCol> get all => [...keys, ?lww, ...data];
}

const _t = SyncType.text;
const _i = SyncType.integer;
const _r = SyncType.real;
const _b = SyncType.boolean;
const _d = SyncType.dateTime;

const _contentId = SyncCol('contentId', 'content_id', _t);
const _updatedAt = SyncCol('updatedAt', 'updated_at', _d);

/// Bütün eşitlenen tablolar, uygulama sırasıyla. `app_meta` eşitlenmez.
const syncTables = <SyncTableSpec>[
  SyncTableSpec(
    name: 'user_story_progress',
    order: 10,
    mutable: true,
    keys: [_contentId],
    lww: _updatedAt,
    data: [
      SyncCol('status', 'status', _t),
      SyncCol('lastCheckpointNodeId', 'last_checkpoint_node_id', _t),
      SyncCol('checkpointSnapshot', 'checkpoint_snapshot', SyncType.jsonObject),
      SyncCol('startedAt', 'started_at', _d),
      SyncCol('completedAt', 'completed_at', _d),
    ],
  ),
  SyncTableSpec(
    name: 'user_story_flags',
    order: 20,
    mutable: true,
    keys: [_contentId, SyncCol('flag', 'flag', _t)],
    lww: _updatedAt,
    data: [SyncCol('value', 'value', _t)],
  ),
  SyncTableSpec(
    name: 'gate_progress',
    order: 30,
    mutable: false,
    keys: [
      _contentId,
      SyncCol('itemKind', 'item_kind', _t),
      SyncCol('nodeId', 'node_id', _t),
    ],
    data: [SyncCol('recordedAt', 'recorded_at', _d)],
  ),
  SyncTableSpec(
    name: 'season_state',
    order: 40,
    mutable: true,
    keys: [SyncCol('seasonId', 'season_id', _i)],
    lww: _updatedAt,
    data: [
      SyncCol('introSeen', 'intro_seen', _b),
      SyncCol('introSeenAt', 'intro_seen_at', _d),
    ],
  ),
  SyncTableSpec(
    name: 'clues',
    order: 50,
    mutable: false,
    keys: [_contentId, SyncCol('clueId', 'clue_id', _t)],
    data: [
      SyncCol('textTr', 'text_tr', _t),
      SyncCol('textEn', 'text_en', _t),
      SyncCol('unlockedAt', 'unlocked_at', _d),
    ],
  ),
  SyncTableSpec(
    name: 'story_links',
    order: 60,
    mutable: true,
    keys: [_contentId],
    lww: SyncCol('recordedAt', 'recorded_at', _d),
    data: [
      SyncCol('number', 'number', _i),
      SyncCol('openQuestionId', 'open_question_id', _t),
      SyncCol('openQuestionTr', 'open_question_tr', _t),
      SyncCol('answers', 'answers', SyncType.jsonArray),
      SyncCol(
        'partialNotes',
        'partial_notes',
        SyncType.jsonObject,
        localDefault: '{}',
      ),
    ],
  ),
  // Kitap ilerlemesi (H-067): "bitti" kazanır (`SyncStore`, backend
  // `ProgressMerger`).
  SyncTableSpec(
    name: 'user_book_progress',
    order: 70,
    mutable: true,
    keys: [SyncCol('bookId', 'book_id', _t)],
    lww: _updatedAt,
    data: [
      SyncCol('status', 'status', _t),
      SyncCol('chapterId', 'chapter_id', _t),
      SyncCol('pageNumber', 'page_number', _i),
      SyncCol('sentenceIndex', 'sentence_index', _i),
      SyncCol('positionSec', 'position_sec', _r),
      SyncCol('startedAt', 'started_at', _d),
      SyncCol('completedAt', 'completed_at', _d),
    ],
  ),
  // Dilbilgisi dersi ilerlemesi (H-078): "bitti" kazanır (`SyncStore`,
  // backend `ProgressMerger`).
  SyncTableSpec(
    name: 'user_grammar_progress',
    order: 80,
    mutable: true,
    keys: [SyncCol('lessonId', 'lesson_id', _t)],
    lww: _updatedAt,
    data: [
      SyncCol('status', 'status', _t),
      SyncCol('lastCard', 'last_card', _t),
      SyncCol('startedAt', 'started_at', _d),
      SyncCol('completedAt', 'completed_at', _d),
    ],
  ),
  // Günlük ölçülen süre (H-074): (yerel gün, kaynak) başına toplam; her
  // satırı yalnız kendi cihazı yazar (düz LWW).
  SyncTableSpec(
    name: 'daily_activity',
    order: 90,
    mutable: true,
    keys: [SyncCol('day', 'day', _t), SyncCol('sourceId', 'source_id', _t)],
    lww: _updatedAt,
    data: [SyncCol('activeSeconds', 'active_seconds', _i, localDefault: 0)],
  ),
  SyncTableSpec(
    name: 'notebook_items',
    order: 100,
    mutable: true,
    keys: [SyncCol('itemKey', 'item_key', _t)],
    lww: _updatedAt,
    data: [
      SyncCol('kind', 'kind', _t),
      SyncCol('textEn', 'text_en', _t),
      SyncCol('textTr', 'text_tr', _t),
      SyncCol('exampleEn', 'example_en', _t),
      SyncCol('exampleTr', 'example_tr', _t),
      SyncCol('contentId', 'content_id', _t),
      SyncCol('cueId', 'cue_id', _t),
      SyncCol('imagePath', 'image_path', _t),
      SyncCol('imageCrop', 'image_crop', _t),
      SyncCol('audioPath', 'audio_path', _t),
      SyncCol('audioStart', 'audio_start', _r),
      SyncCol('audioEnd', 'audio_end', _r),
      SyncCol('exampleStart', 'example_start', _r),
      SyncCol('exampleEnd', 'example_end', _r),
      SyncCol('source', 'source', _t),
      SyncCol('sourceTitle', 'source_title', _t),
      SyncCol('createdAt', 'created_at', _d),
    ],
  ),
  // Kartın anahtarı defterdeki `itemKey`'dir (yerelde `item_id` ile bağlı).
  SyncTableSpec(
    name: 'review_cards',
    order: 110,
    mutable: true,
    keys: [SyncCol('itemKey', 'item_key', _t)],
    lww: _updatedAt,
    data: [
      SyncCol('state', 'state', _i),
      SyncCol('step', 'step', _i),
      SyncCol('stability', 'stability', _r),
      SyncCol('difficulty', 'difficulty', _r),
      SyncCol('due', 'due', _d),
      SyncCol('reps', 'reps', _i),
      SyncCol('lapses', 'lapses', _i),
      SyncCol('lastReview', 'last_review', _d),
    ],
  ),
  // Cevap karta `cardClientId` (kartın UUIDv5'i) ile bağlanır.
  SyncTableSpec(
    name: 'review_logs',
    order: 120,
    mutable: false,
    keys: [],
    data: [
      SyncCol('cardClientId', 'card_client_id', _t),
      SyncCol('rating', 'rating', _i),
      SyncCol('reviewedAt', 'reviewed_at', _d),
      SyncCol('taskType', 'task_type', _t, localDefault: 'self_check'),
      SyncCol('correct', 'correct', _b, localDefault: false),
      SyncCol('dontKnow', 'dont_know', _b),
      SyncCol('durationMs', 'duration_ms', _i, localDefault: 0),
      SyncCol('wasNew', 'was_new', _b),
    ],
  ),
  SyncTableSpec(
    name: 'learning_events',
    order: 130,
    mutable: false,
    keys: [],
    data: [
      _contentId,
      SyncCol('sourceId', 'source_id', _t),
      SyncCol('target', 'target', _t),
      SyncCol('at', 'at', _d),
      SyncCol('errorType', 'error_type', _t),
      SyncCol('errorTaxonomyVersion', 'error_taxonomy_version', _i),
    ],
  ),
  SyncTableSpec(
    name: 'hi_records',
    order: 140,
    mutable: true,
    keys: [SyncCol('kind', 'kind', _t), SyncCol('refId', 'ref_id', _t)],
    lww: _updatedAt,
    data: [SyncCol('status', 'status', _t)],
  ),
  SyncTableSpec(
    name: 'speech_attempts',
    order: 150,
    mutable: false,
    keys: [],
    data: [
      SyncCol('place', 'place', _t),
      _contentId,
      SyncCol('itemRef', 'item_ref', _t),
      SyncCol('matchLevel', 'match_level', _t),
      SyncCol('missingCount', 'missing_count', _i),
      SyncCol('errorNoteId', 'error_note_id', _t),
      SyncCol('at', 'at', _d),
    ],
  ),
];

final syncTablesByName = {for (final t in syncTables) t.name: t};
