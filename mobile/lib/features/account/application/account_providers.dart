import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:http/http.dart' as http;

import '../../../shared/api/api_client.dart';
import '../../../shared/api/auth_service.dart';
import '../../../shared/api/token_store.dart';
import '../../../shared/storage/app_database.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../../shared/sync/sync_engine.dart';
import '../../../shared/sync/sync_store.dart';

// ------------------------------------------------------------ bağımlılıklar

final apiConfigProvider = Provider<ApiConfig>(
  (ref) => ApiConfig.fromEnvironment(),
);

/// Testlerde sahte istemciyle (`MockClient`) değiştirilir.
final apiHttpClientProvider = Provider<http.Client>((ref) {
  final c = http.Client();
  ref.onDispose(c.close);
  return c;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    client: ref.watch(apiHttpClientProvider),
    baseUrl: ref.watch(apiConfigProvider).baseUrl,
  ),
);

/// Testlerde [MemoryTokenStore].
final tokenStoreProvider = Provider<TokenStore>((ref) => SecureTokenStore());

final syncStoreProvider = Provider<SyncStore>(
  (ref) => SyncStore(ref.watch(appDatabaseProvider)),
);

final authServiceProvider = Provider<AuthService>((ref) {
  final s = AuthService(
    api: ref.watch(apiClientProvider),
    tokens: ref.watch(tokenStoreProvider),
    store: ref.watch(syncStoreProvider),
  );
  ref.onDispose(s.dispose);
  return s;
});

final syncEngineProvider = Provider<SyncEngine>(
  (ref) => SyncEngine(
    store: ref.watch(syncStoreProvider),
    auth: ref.watch(authServiceProvider),
  ),
);

// ------------------------------------------------------------ durum

/// Hesap ve eşitleme durumu (`sync_state`). Okunamazsa hesap yok sayılır:
/// uygulama hesapsız çalışmaya devam eder.
final accountStateProvider = StreamProvider<SyncStateRow?>((ref) async* {
  final store = ref.watch(syncStoreProvider);
  try {
    await store.state();
    yield* store.watchState();
  } on Object catch (e) {
    debugPrint('[H038] hesap durumu okunamadı: $e');
    yield null;
  }
});

/// Silme isteği bekleyen hesap (H-042): oturum kapalıyken de "silinmek
/// üzere" kartı için. Hesap durumu her değiştiğinde yeniden okunur; kalıcı
/// silme tarihi geçtiyse işaret silinir. Okunamazsa yok sayılır.
final pendingDeletionProvider = FutureProvider<PendingDeletion?>((ref) async {
  ref.watch(accountStateProvider);
  try {
    return await ref.watch(syncStoreProvider).pendingDeletion();
  } on Object catch (e) {
    debugPrint('[H042] silme işareti okunamadı: $e');
    return null;
  }
}, retry: (_, _) => null);

/// Arayüz için hesap özeti.
class AccountView {
  const AccountView(this.row, {this.ageBlockedUntil, this.deletion});

  final SyncStateRow? row;

  /// Silme isteği bekleyen hesap (oturum kapalıyken de; H-042).
  final PendingDeletion? deletion;

  /// Oturum kapalı ama bu telefonda silinmek üzere olan bir hesap var.
  bool get signedOutPendingDeletion => !signedIn && deletion != null;

  /// 13 yaş altı (H-002): bu yıla kadar hesap açılamaz.
  final int? ageBlockedUntil;

  bool get signedIn => row?.accountUserId != null;
  bool get pendingDeletion =>
      signedIn && row?.accountStatus == AccountStatus.pendingDeletion;
  bool ageBlocked(DateTime now) =>
      ageBlockedUntil != null && now.toUtc().year < ageBlockedUntil!;
}

/// Hesap özeti; `ref.watch` ya da `container.read` verilir. (Türetilmiş bir
/// Provider kullanılmaz: görünmeyen ekranda duraklatılmış türetilmiş sağlayıcı,
/// ekran yeniden görünürken build sırasında yenilenip hata veriyordu.)
AccountView accountViewOf(T Function<T>(ProviderListenable<T> p) watch) =>
    AccountView(
      watch(accountStateProvider).value,
      ageBlockedUntil: watch(ageGateProvider).value,
      deletion: watch(pendingDeletionProvider).value,
    );

// ------------------------------------------------------------ yaş kapısı

/// 13 yaş altı bilgisi yalnızca cihazda: doğum yılı saklanmaz, yalnızca
/// hesabın açılabileceği yıl (`app_meta`).
class AgeGate {
  AgeGate(this._db);

  final AppDatabase _db;
  static const key = 'account.ageBlockedUntil';

  Future<int?> blockedUntil() async {
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return int.tryParse(row?.value ?? '');
  }

  Future<void> block(int birthYear, {int minimumAge = 13}) => _db
      .into(_db.appMeta)
      .insertOnConflictUpdate(
        AppMetaCompanion.insert(key: key, value: '${birthYear + minimumAge}'),
      );
}

final ageGateStoreProvider = Provider<AgeGate>(
  (ref) => AgeGate(ref.watch(appDatabaseProvider)),
);

final ageGateProvider = FutureProvider<int?>((ref) async {
  try {
    return await ref.watch(ageGateStoreProvider).blockedUntil();
  } on Object {
    return null;
  }
}, retry: (_, _) => null);

// ------------------------------------------------------------ Ana Sayfa kartı

/// "İlerlemen yalnızca bu telefonda" kartı: hesap yokken, biraz ilerleme
/// olunca, ara sıra (kapatılınca 30 gün görünmez, en fazla 3 kez kapatılır).
/// Hiçbir şeyi engellemez.
class AccountNudge {
  AccountNudge(this._db, {DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final DateTime Function() _clock;

  static const dismissedAtKey = 'account.nudgeDismissedAt';
  static const dismissCountKey = 'account.nudgeDismissCount';
  static const pause = Duration(days: 30);
  static const maxDismissals = 3;

  Future<String?> _meta(String k) async => (await (_db.select(
    _db.appMeta,
  )..where((t) => t.key.equals(k))).getSingleOrNull())?.value;

  Future<bool> shouldShow() async {
    final count = int.tryParse(await _meta(dismissCountKey) ?? '') ?? 0;
    if (count >= maxDismissals) return false;
    final at = DateTime.tryParse(await _meta(dismissedAtKey) ?? '');
    if (at != null && _clock().difference(at) < pause) return false;
    final done = await _db
        .customSelect(
          "SELECT (SELECT count(*) FROM user_story_progress WHERE status = "
          "'COMPLETED') AS done, (SELECT count(*) FROM notebook_items) AS items",
        )
        .getSingle();
    return done.read<int>('done') >= 1 || done.read<int>('items') >= 3;
  }

  Future<void> dismiss() async {
    final count = int.tryParse(await _meta(dismissCountKey) ?? '') ?? 0;
    await _db.batch(
      (b) => b.insertAllOnConflictUpdate(_db.appMeta, [
        AppMetaCompanion.insert(
          key: dismissedAtKey,
          value: _clock().toIso8601String(),
        ),
        AppMetaCompanion.insert(key: dismissCountKey, value: '${count + 1}'),
      ]),
    );
  }
}

final accountNudgeStoreProvider = Provider<AccountNudge>(
  (ref) => AccountNudge(ref.watch(appDatabaseProvider)),
);

/// Kartın veri koşulu (hesap ve yaş koşulu kartın kendisinde).
final accountNudgeProvider = FutureProvider.autoDispose<bool>((ref) async {
  try {
    await ref.watch(legacyImportProvider);
    return await ref.watch(accountNudgeStoreProvider).shouldShow();
  } on Object {
    return false;
  }
}, retry: (_, _) => null);

// ------------------------------------------------------------ eşitleme zamanlayıcı

class SyncUiState {
  const SyncUiState({this.syncing = false, this.last, this.dataVersion = 0});

  final bool syncing;
  final SyncOutcome? last;

  /// Başka cihazdan veri geldikçe artar; uygulama kökü bütün sekmeleri
  /// güvenle yeniler (H-056, `refreshLocalData`).
  final int dataVersion;
}

/// Hesap açıkken eşitlemeyi zamanlar (H-038):
/// - açılışta ve uygulama öne gelince (çekme + itme);
/// - kuyruğa değişiklik girince (bölüm sonu, tekrar oturumu, defter) kısa
///   bir beklemeyle, art arda değişiklikler tek turda;
/// - öndeyken 5 dakikada bir; uygulama arka plana geçerken bir kez.
///
/// Hesap yoksa hiçbir zamanlayıcı kurulmaz, hiçbir istek yapılmaz.
class SyncController extends Notifier<SyncUiState> {
  static Duration debounce = const Duration(seconds: 10);
  static Duration period = const Duration(minutes: 5);

  /// Testlerde kapatılır (yaşam döngüsü dinleyicisi bağlama ister).
  static bool listenLifecycle = true;

  StreamSubscription<int>? _outbox;
  Timer? _debounce;
  Timer? _periodic;
  AppLifecycleListener? _life;
  bool _foreground = true;

  @override
  SyncUiState build() {
    ref.onDispose(_stop);
    ref.listen<AsyncValue<SyncStateRow?>>(accountStateProvider, (prev, next) {
      final active =
          next.value?.accountUserId != null &&
          next.value?.accountStatus != AccountStatus.pendingDeletion;
      if (active) {
        _start();
      } else {
        _stop();
      }
    }, fireImmediately: true);
    return const SyncUiState();
  }

  bool get _running => _outbox != null;

  void _start() {
    if (_running) return;
    final store = ref.read(syncStoreProvider);
    _outbox = store.watchPendingCount().listen((n) {
      if (n == 0) return;
      _debounce?.cancel();
      _debounce = Timer(debounce, () => unawaited(syncNow()));
    }, onError: (_) {});
    _periodic = Timer.periodic(period, (_) {
      if (_foreground) unawaited(syncNow());
    });
    if (listenLifecycle) {
      _life = AppLifecycleListener(
        onResume: () {
          _foreground = true;
          unawaited(syncNow());
        },
        onPause: () {
          _foreground = false;
          unawaited(syncNow());
        },
      );
    }
    unawaited(syncNow());
  }

  void _stop() {
    _outbox?.cancel();
    _outbox = null;
    _debounce?.cancel();
    _debounce = null;
    _periodic?.cancel();
    _periodic = null;
    _life?.dispose();
    _life = null;
  }

  /// Yerel veri toplu değişti (ör. "Bu telefondaki verileri de sil"):
  /// bütün sekmeler yeniden okusun.
  void notifyDataChanged() => state = SyncUiState(
    syncing: state.syncing,
    last: state.last,
    dataVersion: state.dataVersion + 1,
  );

  /// Bir eşitleme turu (hesap yoksa hiçbir şey yapmaz).
  Future<SyncOutcome> syncNow() async {
    _debounce?.cancel();
    state = SyncUiState(
      syncing: true,
      last: state.last,
      dataVersion: state.dataVersion,
    );
    try {
      final outcome = await ref.read(syncEngineProvider).sync();
      if (!ref.mounted) return outcome;
      // Başka cihazdan veri geldiyse sürüm artar; uygulama kökü bütün
      // sekmeleri güvenle yeniler (H-056, `refreshLocalData`).
      state = SyncUiState(
        last: outcome,
        dataVersion: state.dataVersion + (outcome.pulled > 0 ? 1 : 0),
      );
      return outcome;
    } on Object catch (e) {
      debugPrint('[H038] eşitleme hatası: ${e.runtimeType}');
      if (ref.mounted) {
        state = SyncUiState(last: state.last, dataVersion: state.dataVersion);
      }
      return const SyncOutcome.skipped();
    }
  }
}

final syncControllerProvider = NotifierProvider<SyncController, SyncUiState>(
  SyncController.new,
);
