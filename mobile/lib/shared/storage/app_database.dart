import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Yerel veritabanı (Drift/SQLite, H-035; `docs/UYGULAMA-PLANI.md` §2).
///
/// Zamanlar UTC yazılır (`build.yaml`: ISO-8601 metin). Kod üretimi:
/// `dart run build_runner build` → `app_database.g.dart` (depoda tutulur).

/// Bölüm başına ilerleme.
class UserStoryProgress extends Table {
  TextColumn get contentId => text()();

  /// `NOT_STARTED` | `IN_PROGRESS` | `COMPLETED`
  TextColumn get status => text().withDefault(const Constant('NOT_STARTED'))();

  /// Kaldığı yer (sahne başı kontrol noktası); bölüm bitince `null`.
  TextColumn get lastCheckpointNodeId => text().nullable()();

  /// Motorun tam kaydı (bayraklar, geçilen düğümler, içerik sürümü) — JSON.
  TextColumn get checkpointSnapshot => text().nullable()();

  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

/// Biten bölümün kalıcı bayrakları (K-28; sonraki bölümler okur).
class UserStoryFlags extends Table {
  TextColumn get contentId => text()();
  TextColumn get flag => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {contentId, flag};
}

/// Bölüm kapısı (K-29): karşılanan ölçüt ve onu karşılayan düğüm.
class GateProgress extends Table {
  TextColumn get contentId => text()();

  /// `comprehension` | `targetPhrase` | `activeTask`
  TextColumn get itemKind => text()();
  TextColumn get nodeId => text()();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId, itemKind, nodeId};
}

/// Sezon başına cihaz durumu (tam jenerik izlendi mi, H-050).
class SeasonState extends Table {
  IntColumn get seasonId => integer()();
  BoolColumn get introSeen => boolean().withDefault(const Constant(false))();
  DateTimeColumn get introSeenAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {seasonId};
}

/// Küçük anahtar–değer kayıtları (ör. bir kerelik taşıma işareti).
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    UserStoryProgress,
    UserStoryFlags,
    GateProgress,
    SeasonState,
    AppMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Testler için bellek içi veritabanı.
  factory AppDatabase.memory() => AppDatabase(NativeDatabase.memory());

  /// Cihazdaki dosya: `<uygulama destek klasörü>/hivelzon.sqlite`.
  factory AppDatabase.open() => AppDatabase(
    LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      await dir.create(recursive: true);
      return NativeDatabase.createInBackground(
        File(p.join(dir.path, 'hivelzon.sqlite')),
      );
    }),
  );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
