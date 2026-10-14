import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../shared/fsrs/fsrs.dart';
import '../../../shared/storage/app_database.dart';
import '../../../shared/sync/sync_ids.dart';
import '../domain/clue_board.dart';
import '../domain/deck_builder.dart';
import '../domain/notebook_item.dart';
import '../domain/review_policy.dart';
import '../domain/review_session.dart';

/// Defter, FSRS kartları, ipuçları ve bölüm bağları (Drift, H-036).
///
/// Yazmalar idempotent: aynı ifade (`item_key`) ikinci kez eklenmez; var olan
/// kartın yalnızca boş görsel/ses alanları doldurulur; ipucu ve bağ satırları
/// birincil anahtarla tekildir.
class NotebookStore {
  NotebookStore(this._db, {Future<void>? ready, DateTime Function()? clock})
    : _ready = ready ?? Future<void>.value(),
      _clock = clock ?? (() => DateTime.now().toUtc());

  static const dailyGoalKey = 'settings.dailyGoalMinutes';

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  DateTime now() => _clock().toUtc();

  // ------------------------------------------------------------ kartlar

  /// Yeni ifadeleri ekler (her birine yeni FSRS kartı). Eklenen sayısını döndürür.
  Future<int> addItems(Iterable<NotebookItem> items) async {
    await _ready;
    var added = 0;
    await _db.transaction(() async {
      for (final item in items) {
        if (await _insert(item)) added++;
      }
    });
    return added;
  }

  Future<bool> _insert(NotebookItem item) async {
    final existing = await (_db.select(
      _db.notebookItems,
    )..where((t) => t.itemKey.equals(item.key))).getSingleOrNull();
    if (existing != null) {
      await _fillMissing(existing, item);
      return false;
    }
    final at = (item.createdAt ?? now()).toUtc();
    final id = await _db
        .into(_db.notebookItems)
        .insert(_companion(item, at), mode: InsertMode.insertOrIgnore);
    if (id == 0) return false;
    await _db
        .into(_db.reviewCards)
        .insert(
          ReviewCardsCompanion.insert(
            itemId: id,
            due: at,
            updatedAt: Value(at),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    return true;
  }

  /// Var olan satırın boş alanlarını doldurur (dolu alanlara dokunmaz).
  Future<void> _fillMissing(NotebookItemRow row, NotebookItem item) async {
    final merged = _toItem(row).fillFrom(item);
    final audioMissing = row.audioPath == null && merged.audio != null;
    // Yalnızca boş alan dolarsa yazılır (H-038: değişmeyen satır eşitleme
    // kuyruğuna girmesin, LWW zamanı boşuna ilerlemesin).
    Value<T> fill<T>(Object? current, T? value) =>
        current == null && value != null ? Value(value) : const Value.absent();
    final c = NotebookItemsCompanion(
      textTr: fill(row.textTr, merged.textTr),
      exampleEn: fill(row.exampleEn, merged.exampleEn),
      exampleTr: fill(row.exampleTr, merged.exampleTr),
      contentId: fill(row.contentId, merged.contentId),
      cueId: fill(row.cueId, merged.cueId),
      imagePath: fill(row.imagePath, merged.imagePath),
      audioPath: audioMissing
          ? Value(merged.audio!.path)
          : const Value.absent(),
      audioStart: audioMissing
          ? Value(merged.audio!.start)
          : const Value.absent(),
      audioEnd: audioMissing ? Value(merged.audio!.end) : const Value.absent(),
      exampleStart: audioMissing
          ? Value(merged.exampleAudio?.start)
          : const Value.absent(),
      exampleEnd: audioMissing
          ? Value(merged.exampleAudio?.end)
          : const Value.absent(),
    );
    if (c.toColumns(false).isEmpty) return;
    await (_db.update(_db.notebookItems)..where((t) => t.id.equals(row.id)))
        .write(c.copyWith(updatedAt: Value(now())));
  }

  /// Görseli ya da sesi eksik kartlar (zenginleştirme için).
  Future<List<NotebookItem>> itemsMissingMedia() async {
    await _ready;
    final rows =
        await (_db.select(_db.notebookItems)..where(
              (t) =>
                  t.contentId.isNotNull() &
                  // Kitaptan eklenenler kaydedilirken doldurulur (H-067).
                  t.source.equals(NotebookSource.book.code).not() &
                  (t.imagePath.isNull() | t.audioPath.isNull()),
            ))
            .get();
    return rows.map(_toItem).toList();
  }

  /// Zenginleştirilmiş kartın eksik alanlarını yazar.
  Future<void> fillMissing(NotebookItem item) async {
    await _ready;
    final row = await (_db.select(
      _db.notebookItems,
    )..where((t) => t.itemKey.equals(item.key))).getSingleOrNull();
    if (row != null) await _fillMissing(row, item);
  }

  /// Konu seti görseli (H-051): aynı ifadenin kartı sahne görseli yerine
  /// setteki kırpılmış nesne görselini kullanır. Yalnızca görseli sahne
  /// görseli olan (ya da hiç olmayan) kart güncellenir; eksik ses de doldurulur.
  /// İdempotent: ikinci çağrı bir şey değiştirmez. Güncellenen satır sayısı.
  Future<int> applySetImage(NotebookItem setItem) async {
    await _ready;
    final path = setItem.imagePath;
    if (path == null) return 0;
    final row = await (_db.select(
      _db.notebookItems,
    )..where((t) => t.itemKey.equals(setItem.key))).getSingleOrNull();
    if (row == null) return 0;
    if (row.audioPath == null && setItem.audio != null) {
      await _fillMissing(row, setItem);
    }
    if (row.imagePath != null &&
        (row.imagePath!.startsWith('_season/') ||
            row.imagePath!.startsWith('_books/'))) {
      return 0;
    }
    if (row.imagePath == path && row.imageCrop == setItem.imageCrop) return 0;
    return (_db.update(
      _db.notebookItems,
    )..where((t) => t.id.equals(row.id))).write(
      NotebookItemsCompanion(
        imagePath: Value(path),
        imageCrop: Value(setItem.imageCrop),
        updatedAt: Value(now()),
      ),
    );
  }

  /// Kullanıcının eklediği kart silinebilir (kartı ve geçmişiyle): "Deftere
  /// ekle" ile ya da konu setinden (H-051) eklenenler. Set kendisi etkilenmez;
  /// "Hepsini defterime ekle" yeniden ekleyebilir.
  Future<bool> removeUserItem(int itemId) async {
    await _ready;
    final n =
        await (_db.delete(_db.notebookItems)..where(
              (t) =>
                  t.id.equals(itemId) &
                  t.source.isIn([
                    NotebookSource.userSaved.code,
                    NotebookSource.topicSet.code,
                    NotebookSource.book.code,
                  ]),
            ))
            .go();
    return n > 0;
  }

  Future<List<NotebookEntry>> entries() async {
    await _ready;
    final q = _db.select(_db.notebookItems).join([
      innerJoin(
        _db.reviewCards,
        _db.reviewCards.itemId.equalsExp(_db.notebookItems.id),
      ),
    ])..orderBy([OrderingTerm.desc(_db.notebookItems.id)]);
    final rows = await q.get();
    return [
      for (final r in rows)
        NotebookEntry(
          _toItem(r.readTable(_db.notebookItems)),
          _toCard(r.readTable(_db.reviewCards)),
        ),
    ];
  }

  Future<void> saveOutcome(ReviewOutcome o) async {
    await _ready;
    final c = o.after;
    await _db.transaction(() async {
      final itemKey = (await (_db.select(
        _db.notebookItems,
      )..where((t) => t.id.equals(c.itemId))).getSingleOrNull())?.itemKey;
      await (_db.update(
        _db.reviewCards,
      )..where((t) => t.id.equals(c.id))).write(
        ReviewCardsCompanion(
          state: Value(c.fsrs.state.value),
          step: Value(c.fsrs.step),
          stability: Value(c.fsrs.stability),
          difficulty: Value(c.fsrs.difficulty),
          due: Value(c.fsrs.due.toUtc()),
          reps: Value(c.reps),
          lapses: Value(c.lapses),
          lastReview: Value(c.fsrs.lastReview?.toUtc()),
          updatedAt: Value(now()),
        ),
      );
      await _db
          .into(_db.reviewLogs)
          .insert(
            ReviewLogsCompanion.insert(
              cardId: c.id,
              rating: o.rating.value,
              reviewedAt: o.reviewedAt.toUtc(),
              taskType: o.taskType.code,
              correct: o.correct,
              dontKnow: Value(o.dontKnow),
              durationMs: o.elapsed.inMilliseconds,
              wasNew: Value(o.wasNew),
              // H-038: kart + zaman + nottan UUIDv5 (backend kuralı).
              clientId: itemKey == null
                  ? const Value.absent()
                  : Value(
                      SyncIds.reviewLog(
                        SyncIds.card(itemKey),
                        o.reviewedAt,
                        o.rating.value,
                      ),
                    ),
            ),
          );
    });
  }

  /// [fromUtc, toUtc) aralığında ilk kez tekrar edilen (yeni) kart sayısı.
  Future<int> newIntroducedBetween(DateTime fromUtc, DateTime toUtc) async {
    await _ready;
    final count = _db.reviewLogs.cardId.count(distinct: true);
    final q = _db.selectOnly(_db.reviewLogs)
      ..addColumns([count])
      ..where(
        _db.reviewLogs.wasNew.equals(true) &
            _db.reviewLogs.reviewedAt.isBiggerOrEqualValue(fromUtc.toUtc()) &
            _db.reviewLogs.reviewedAt.isSmallerThanValue(toUtc.toUtc()),
      );
    return (await q.getSingle()).read(count) ?? 0;
  }

  Future<List<ReviewLogRow>> logs() async {
    await _ready;
    return (_db.select(
      _db.reviewLogs,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
  }

  // ------------------------------------------------------------ ayar

  Future<int> dailyGoalMinutes() async {
    final v = int.tryParse(await meta(dailyGoalKey) ?? '');
    return ReviewPolicy.newCardsPerDayByGoal.containsKey(v)
        ? v!
        : ReviewPolicy.defaultDailyGoalMinutes;
  }

  Future<void> setDailyGoalMinutes(int minutes) =>
      setMeta(dailyGoalKey, '$minutes');

  Future<String?> meta(String key) async {
    await _ready;
    return (await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;
  }

  Future<void> setMeta(String key, String value) async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: value),
        );
  }

  // ------------------------------------------------------------ ipucu panosu

  Future<void> addClues(String contentId, List<ClueDraft> clues) async {
    await _ready;
    final at = now();
    await _db.transaction(() async {
      for (final c in clues) {
        await _db
            .into(_db.clues)
            .insert(
              CluesCompanion.insert(
                contentId: contentId,
                clueId: c.clueId,
                textTr: c.textTr,
                textEn: Value(c.textEn),
                unlockedAt: at,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
    });
  }

  Future<List<ClueItem>> clues() async {
    await _ready;
    final rows = await _db.select(_db.clues).get();
    return [
      for (final r in rows)
        ClueItem(
          contentId: r.contentId,
          clueId: r.clueId,
          textTr: r.textTr,
          unlockedAt: r.unlockedAt.toUtc(),
        ),
    ];
  }

  Future<void> saveStoryLinks(StoryLinkDraft l) async {
    await _ready;
    await _db
        .into(_db.storyLinks)
        .insertOnConflictUpdate(
          StoryLinksCompanion.insert(
            contentId: l.contentId,
            number: l.number,
            openQuestionId: l.openQuestionId,
            openQuestionTr: Value(l.openQuestionTr),
            answers: jsonEncode(l.answers),
            partialNotes: Value(jsonEncode(l.partialNotes)),
            recordedAt: now(),
          ),
        );
  }

  Future<List<StoryLinkRecord>> storyLinks() async {
    await _ready;
    final rows = await _db.select(_db.storyLinks).get();
    List<String> list(String raw) {
      try {
        return [for (final e in jsonDecode(raw) as List) e as String];
      } on Object {
        return const [];
      }
    }

    Map<String, String> map(String raw) {
      try {
        return Map<String, String>.from(jsonDecode(raw) as Map);
      } on Object {
        return const {};
      }
    }

    return [
      for (final r in rows)
        StoryLinkRecord(
          contentId: r.contentId,
          number: r.number,
          openQuestionId: r.openQuestionId,
          openQuestionTr: r.openQuestionTr,
          answers: list(r.answers),
          partialNotes: map(r.partialNotes),
        ),
    ];
  }

  // ------------------------------------------------------------ eşleme

  static NotebookItemsCompanion _companion(NotebookItem i, DateTime at) =>
      NotebookItemsCompanion.insert(
        itemKey: i.key,
        kind: i.kind.name,
        textEn: i.textEn,
        textTr: Value(i.textTr),
        exampleEn: Value(i.exampleEn),
        exampleTr: Value(i.exampleTr),
        contentId: Value(i.contentId),
        cueId: Value(i.cueId),
        imagePath: Value(i.imagePath),
        imageCrop: Value(i.imageCrop),
        audioPath: Value(i.audio?.path),
        audioStart: Value(i.audio?.start),
        audioEnd: Value(i.audio?.end),
        exampleStart: Value(i.exampleAudio?.start),
        exampleEnd: Value(i.exampleAudio?.end),
        source: i.source.code,
        sourceTitle: Value(i.sourceTitle),
        createdAt: at,
        updatedAt: Value(at),
      );

  static NotebookItem _toItem(NotebookItemRow r) {
    final path = r.audioPath;
    final ranged = r.audioStart != null;
    return NotebookItem(
      id: r.id,
      kind: NotebookKind.values.asNameMap()[r.kind] ?? NotebookKind.phrase,
      textEn: r.textEn,
      textTr: r.textTr,
      exampleEn: r.exampleEn,
      exampleTr: r.exampleTr,
      contentId: r.contentId,
      cueId: r.cueId,
      imagePath: r.imagePath,
      imageCrop: r.imageCrop,
      audio: path == null
          ? null
          : MediaClip(path, start: r.audioStart, end: r.audioEnd),
      exampleAudio: path == null
          ? null
          : ranged && r.exampleStart == null
          ? null
          : MediaClip(path, start: r.exampleStart, end: r.exampleEnd),
      source: NotebookSource.parse(r.source),
      sourceTitle: r.sourceTitle,
      createdAt: r.createdAt.toUtc(),
    );
  }

  static ReviewCardState _toCard(ReviewCardRow r) => ReviewCardState(
    id: r.id,
    itemId: r.itemId,
    reps: r.reps,
    lapses: r.lapses,
    fsrs: FsrsCard(
      state: FsrsState.fromValue(r.state),
      step: r.state == FsrsState.review.value ? null : (r.step ?? 0),
      stability: r.stability,
      difficulty: r.difficulty,
      due: r.due.toUtc(),
      lastReview: r.lastReview?.toUtc(),
    ),
  );
}
