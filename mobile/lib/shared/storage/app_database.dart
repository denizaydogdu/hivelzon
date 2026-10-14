import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../sync/sync_ids.dart';
import '../sync/sync_schema.dart';

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

  /// Son yazan kazanır zamanı (H-038, şema 5).
  DateTimeColumn get updatedAt => dateTime().nullable()();

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

  /// Son yazan kazanır zamanı (H-038, şema 5).
  DateTimeColumn get updatedAt => dateTime().nullable()();

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

  /// `auto_target_phrase` | `user_saved` | `lookup` | `topic_set` | `book`
  TextColumn get source => text()();

  /// Kaynağın adı (şema 6, H-067): kitaptan eklenende kitabın başlığı
  /// (`Kitap: <başlık>, s. N` satırı için; sayfa `cueId`'den).
  TextColumn get sourceTitle => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  /// Son yazan kazanır zamanı (H-038, şema 5).
  DateTimeColumn get updatedAt => dateTime().nullable()();
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

  /// Son yazan kazanır zamanı (H-038, şema 5).
  DateTimeColumn get updatedAt => dateTime().nullable()();
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

  /// Eşitleme kimliği (H-038, şema 5): kart + zaman + nottan UUIDv5
  /// ([SyncIds.reviewLog]); verilmezse rastgele UUIDv4. Tekil (dizin).
  TextColumn get clientId => text().nullable().clientDefault(SyncIds.v4)();
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

  /// Eşitleme kimliği (H-038, şema 5; UUID). Eski kayıtlarda
  /// [clientEventId]'nin tireli biçimi. Tekil (dizin).
  TextColumn get clientId => text().nullable().clientDefault(SyncIds.v4)();
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

// ---------------------------------------------------------------- Söyle (H-055, şema 4)

/// "Söyle" alıştırmasının **yalnızca sonucu** (H-055). Ses ve tanıma yazısı
/// (transkript) hiçbir zaman saklanmaz: burada yalnızca yer, içerik, beklenen
/// ifade (içerikten), eşleşme düzeyi, duyulmayan kelime sayısı ve varsa hata
/// kataloğu kimliği durur. "Hi'nin kayıtlarını sil" bunları da siler.
@DataClassName('SpeechAttemptRow')
class SpeechAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `review` | `meaning` | `decision` | `episode_end`
  TextColumn get place => text()();
  TextColumn get contentId => text().nullable()();

  /// Beklenen ifade (içerikteki metin) ya da karar seçeneği (`k1#a`).
  TextColumn get itemRef => text()();

  /// `full` | `close` | `no` (karar anında seçilemediyse `no`).
  TextColumn get matchLevel => text()();
  IntColumn get missingCount => integer().withDefault(const Constant(0))();

  /// Hata kataloğu kimliği (`can-short-answer` vb.).
  TextColumn get errorNoteId => text().nullable()();
  DateTimeColumn get at => dateTime()();

  /// Eşitleme kimliği (H-038, şema 5; UUIDv4). Tekil (dizin).
  TextColumn get clientId => text().nullable().clientDefault(SyncIds.v4)();
}

// ---------------------------------------------------------------- Kitaplık (H-067, şema 6)

/// Kitap başına ilerleme (`docs/KITAPLIK.md` §7). Hesap varsa eşitlenir;
/// "bitti" kazanır (H-056 kuralı), öteki alanlarda son yazan kazanır.
class UserBookProgress extends Table {
  TextColumn get bookId => text()();

  /// `NOT_STARTED` | `IN_PROGRESS` | `COMPLETED`
  TextColumn get status => text().withDefault(const Constant('NOT_STARTED'))();

  /// Kalınan yer: bölüm (`c1`), sayfa numarası, sayfadaki cümle sırası
  /// (−1: bölüm başlığı) ve bölüm sesindeki konum (sn).
  TextColumn get chapterId => text().nullable()();
  IntColumn get pageNumber => integer().nullable()();
  IntColumn get sentenceIndex => integer().nullable()();
  RealColumn get positionSec => real().nullable()();

  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {bookId};
}

// ---------------------------------------------------------------- eşitleme (H-038, şema 5)

/// Hesap ve eşitleme durumu (tek satır, `id = 1`). Hesap yoksa
/// [accountUserId] boştur ve hiçbir değişiklik kuyruğa yazılmaz.
@DataClassName('SyncStateRow')
class SyncState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Hesabın kimliği (`/me` → `id`); yalnızca oturum açıkken dolu.
  TextColumn get accountUserId => text().nullable()();

  /// Gösterim için maskeli e-posta (`d•••@example.com`); açık e-posta
  /// cihazda saklanmaz.
  TextColumn get emailMasked => text().nullable()();

  /// `ACTIVE` | `PENDING_DELETION`
  TextColumn get accountStatus => text().nullable()();
  DateTimeColumn get scheduledPurgeAt => dateTime().nullable()();

  /// Bu kurulumun rastgele kimliği (itmede `deviceId`; sunucu saklamaz).
  TextColumn get deviceId => text().nullable()();

  /// Çekme imleci (`/sync/pull?since=`).
  IntColumn get lastPullCursor => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  DateTimeColumn get lastPushAt => dateTime().nullable()();

  /// Cihazdaki verinin hesaba ilk yüklemesi bitti mi.
  BoolColumn get initialUploadDone =>
      boolean().withDefault(const Constant(false))();

  /// Sunucudan gelen satırlar yazılırken 1: tetikleyiciler kuyruğa yazmaz.
  BoolColumn get applying => boolean().withDefault(const Constant(false))();

  /// "Hi'nin kayıtlarını sil" sonrası `DELETE /sync/speech-attempts` bekliyor.
  BoolColumn get pendingSpeechDelete =>
      boolean().withDefault(const Constant(false))();

  /// Son eşitleme hatasının kodu (`NETWORK`, `RATE_LIMITED` …); başarıda boş.
  TextColumn get lastErrorCode => text().nullable()();

  /// Oturum cihazda kapatıldıysa nedeni (`TOKEN_REUSED` …); gösterilince silinir.
  TextColumn get signedOutReason => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Gönderilecek değişiklikler (H-038). SQLite tetikleyicileri doldurur
/// (yalnızca oturum açıkken; `sync_schema.dart`): satırın tablo adı ve doğal
/// anahtarı (ya da UUID'si). İtmede satırın güncel hâli okunur; satır yoksa
/// silme işareti (tombstone) gönderilir.
@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  TextColumn get tbl => text()();
  TextColumn get k1 => text()();
  TextColumn get k2 => text().withDefault(const Constant(''))();
  TextColumn get k3 => text().withDefault(const Constant(''))();

  /// Değişiklik silme miydi (bilgi; satırın varlığı esastır).
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  /// Her değişiklikte artar: itme sırasında yeniden değişen satır kuyrukta kalır.
  IntColumn get rev => integer().withDefault(const Constant(1))();
  DateTimeColumn get changedAt => dateTime()();

  /// Sunucu bu satırı reddettiyse 1: satır yeniden değişene kadar atlanır
  /// (eşitlemenin tamamı takılmasın).
  BoolColumn get blocked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {tbl, k1, k2, k3};
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
    SpeechAttempts,
    SyncState,
    SyncOutbox,
    UserBookProgress,
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
  int get schemaVersion => 6;

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
      // 3 → 4 (H-055): "Söyle" sonuçları (yalnızca sonuç; ses/yazı yok).
      if (from < 4) {
        await m.createTable(speechAttempts);
      }
      // 4 → 5 (H-038): eşitleme. LWW zamanı, UUID kimlikler, durum ve kuyruk.
      if (from < 5) {
        await m.addColumn(userStoryFlags, userStoryFlags.updatedAt);
        await m.addColumn(seasonState, seasonState.updatedAt);
        // Önceki adımda bu sürümün tanımıyla oluşturulan tablolarda kolon
        // zaten vardır (1 → 2 defter, 3 → 4 "Söyle").
        if (from >= 2) {
          await m.addColumn(notebookItems, notebookItems.updatedAt);
          await m.addColumn(reviewCards, reviewCards.updatedAt);
          await m.addColumn(reviewLogs, reviewLogs.clientId);
          await m.addColumn(learningEvents, learningEvents.clientId);
        }
        if (from >= 4) {
          await m.addColumn(speechAttempts, speechAttempts.clientId);
        }
        await m.createTable(syncState);
        await m.createTable(syncOutbox);
        await backfillSchema5(this);
      }
      // 5 → 6 (H-067): Kitaplık ilerlemesi; defterde kaynağın adı (kitap).
      if (from < 6) {
        if (from >= 2) {
          await m.addColumn(notebookItems, notebookItems.sourceTitle);
        }
        await m.createTable(userBookProgress);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Sıradaki kartlar `due` ile aranır (idempotent).
      await customStatement(
        'CREATE INDEX IF NOT EXISTS review_cards_due ON review_cards (due)',
      );
      // H-038: eşitleme kimlik dizinleri ve değişiklik tetikleyicileri.
      await installSyncSchema(this);
    },
  );
}
