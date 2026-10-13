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

// ---------------------------------------------------------------- defter (H-036, şema 2)

/// Defterdeki kelime, kalıp ya da cümle (kart = görsel + ifade + örnek cümle
/// + ses + Türkçesi; kullanıcı kararı 2026-10-12).
@DataClassName('NotebookItemRow')
class NotebookItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `<kind>|<normalleştirilmiş İngilizce>`: aynı ifade iki kez girmez.
  TextColumn get itemKey => text().unique()();

  /// `word` | `phrase` | `sentence`
  TextColumn get kind => text()();
  TextColumn get textEn => text()();
  TextColumn get textTr => text().nullable()();
  TextColumn get exampleEn => text().nullable()();
  TextColumn get exampleTr => text().nullable()();

  /// Kaynak bölüm ve satır (`A1-001`, `s02-04`).
  TextColumn get contentId => text().nullable()();
  TextColumn get cueId => text().nullable()();

  /// Bölüm paketindeki görsel (`stills/T2-pov.jpg`) ve isteğe bağlı kırpma
  /// (normalleştirilmiş `x,y,w,h`; yoksa görselin tamamı).
  TextColumn get imagePath => text().nullable()();
  TextColumn get imageCrop => text().nullable()();

  /// Ses: segment videosu (`segments/s02.mp4`) + ifadenin aralığı (sn) ya da
  /// tek ses dosyası (`audio/x.m4a`, aralık yok).
  TextColumn get audioPath => text().nullable()();
  RealColumn get audioStart => real().nullable()();
  RealColumn get audioEnd => real().nullable()();

  /// Örnek cümlenin aralığı (aynı ses dosyasında).
  RealColumn get exampleStart => real().nullable()();
  RealColumn get exampleEnd => real().nullable()();

  /// `auto_target_phrase` | `user_saved` | `lookup`
  TextColumn get source => text()();
  DateTimeColumn get createdAt => dateTime()();
}

/// FSRS kartı (K-04). Yeni kart: `reps = 0`, `lastReview = null`.
@DataClassName('ReviewCardRow')
class ReviewCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().unique().references(
    NotebookItems,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// FSRS durumu: 1 learning, 2 review, 3 relearning.
  IntColumn get state => integer().withDefault(const Constant(1))();
  IntColumn get step => integer().nullable()();
  RealColumn get stability => real().nullable()();
  RealColumn get difficulty => real().nullable()();
  DateTimeColumn get due => dateTime()();
  IntColumn get reps => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReview => dateTime().nullable()();
}

/// Her cevap (FSRS optimizasyonu ve H-038 eşitlemesi için).
@DataClassName('ReviewLogRow')
class ReviewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cardId =>
      integer().references(ReviewCards, #id, onDelete: KeyAction.cascade)();

  /// 1 Again, 2 Hard, 3 Good, 4 Easy.
  IntColumn get rating => integer()();
  DateTimeColumn get reviewedAt => dateTime()();

  /// `picture_choice` | `listen_choice` | `arrange` | `type` | `self_check`
  TextColumn get taskType => text()();
  BoolColumn get correct => boolean()();

  /// "Bilmiyorum" seçildi mi.
  BoolColumn get dontKnow => boolean().withDefault(const Constant(false))();
  IntColumn get durationMs => integer()();

  /// İnceleme öncesi kart yeni miydi (günlük yeni kart sınırı için).
  BoolColumn get wasNew => boolean().withDefault(const Constant(false))();
}

/// Öğrenme olayları (H-046'dan taşındı). Sunucuya eşitlenecek (H-038).
@DataClassName('LearningEventRow')
class LearningEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// İstemci kimliği: eşitlemede çift kaydı önler.
  TextColumn get clientEventId => text().unique()();
  TextColumn get contentId => text()();
  TextColumn get sourceId => text()();
  TextColumn get target => text()();
  DateTimeColumn get at => dateTime()();

  /// Hata türü (isteğe bağlı) ve sürümlü sınıflandırma
  /// (`shared/meaning/error_taxonomy.dart`). Bakmak hata değildir: null.
  TextColumn get errorType => text().nullable()();
  IntColumn get errorTaxonomyVersion => integer().nullable()();
}

/// Açılan ipuçları (bölüm sonu ipucu kartı).
@DataClassName('ClueRow')
class Clues extends Table {
  TextColumn get contentId => text()();
  TextColumn get clueId => text()();
  TextColumn get textTr => text()();
  TextColumn get textEn => text().nullable()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId, clueId};
}

/// Biten bölümün bağları (`episode.links`): açık sorular buradan türetilir.
@DataClassName('StoryLinkRow')
class StoryLinks extends Table {
  TextColumn get contentId => text()();
  IntColumn get number => integer()();

  /// Bölümün açtığı soru (`Q1`) ve spoiler'sız Türkçe metni.
  TextColumn get openQuestionId => text()();
  TextColumn get openQuestionTr => text().nullable()();

  /// Cevapladığı sorular, JSON dizi (`["Q1:partial"]`).
  TextColumn get answers => text()();

  /// Kısmi cevap notları, JSON nesne (`{"Q1": "limanda"}`).
  TextColumn get partialNotes => text().withDefault(const Constant('{}'))();
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

// ---------------------------------------------------------------- Hi-A (H-048, şema 3)

/// Hi'nin cihazdaki küçük kayıtları: görülen konu tanıtımı, yan görev durumu,
/// açılan not. Gizlilik ekranından görülür; "Hi'nin kayıtlarını sil" yan görev
/// ve not kayıtlarını siler (konu tanıtımı ilerleme sayılır, kalır).
@DataClassName('HiRecordRow')
class HiRecords extends Table {
  /// `topic_intro` | `bridge_task` | `note_read`
  TextColumn get kind => text()();

  /// Konu ya da görev kimliği; `note_read` için hata türü kodu.
  TextColumn get refId => text()();

  /// `seen` | `done` | `dismissed` | `read`
  TextColumn get status => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {kind, refId};
}

@DriftDatabase(
  tables: [
    UserStoryProgress,
    UserStoryFlags,
    GateProgress,
    SeasonState,
    AppMeta,
    NotebookItems,
    ReviewCards,
    ReviewLogs,
    LearningEvents,
    Clues,
    StoryLinks,
    HiRecords,
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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // 1 → 2 (H-036): defter, FSRS, öğrenme olayları, ipucu panosu.
      if (from < 2) {
        await m.createTable(notebookItems);
        await m.createTable(reviewCards);
        await m.createTable(reviewLogs);
        await m.createTable(learningEvents);
        await m.createTable(clues);
        await m.createTable(storyLinks);
      }
      // 2 → 3 (H-048): Hi-A kayıtları.
      if (from < 3) {
        await m.createTable(hiRecords);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Sıradaki kartlar `due` ile aranır (idempotent).
      await customStatement(
        'CREATE INDEX IF NOT EXISTS review_cards_due ON review_cards (due)',
      );
    },
  );
}
