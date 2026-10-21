import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/app_info.dart';

/// Yerel çökme kaydı (H-043): son [CrashLog.capacity] hata, yalnızca bu
/// telefonda. Kişisel veri yok, üçüncü taraf yok, kendiliğinden hiçbir yere
/// gönderilmez. Kullanıcı isterse Profil → "Hata kaydını paylaş" ile sistem
/// paylaşım penceresinden kendisi gönderir.
///
/// **Neden Drift değil, küçük bir dosya:** kayıt tam da bir şey bozulduğunda
/// yazılır; bozulan şey veritabanının kendisi (açılış, göç, kilit) olabilir.
/// Hata yolunda veritabanına yazmak yeni hata ve döngü doğurabilir; ayrıca
/// eşitleme ve "Bu telefondaki verileri sil" tablolarından bağımsız kalır.
/// Dosya `Application Support/diagnostics/crash_log.json`; yazma geçici
/// dosya + yeniden adlandırma ile atomiktir (yarım dosya kalmaz).
///
/// Her satırda yalnızca: etiket, hata türü (`runtimeType`), kısaltılmış
/// yığın, uygulama sürümü, UTC saat. **Hata mesajı saklanmaz** (adres,
/// e-posta ya da kullanıcının yazdığı metin içerebilir). Yığın satırları da
/// [scrubDiagnosticText] ile temizlenir.
class CrashLog {
  CrashLog({
    required Future<Directory> Function() directory,
    required this.appVersion,
    DateTime Function()? clock,
  }) : _directory = directory,
       _clock = clock ?? (() => DateTime.now().toUtc());

  /// Uygulamanın tek kaydı (Application Support).
  static final CrashLog instance = CrashLog(
    directory: getApplicationSupportDirectory,
    appVersion: AppInfo.version,
  );

  /// Ring buffer boyutu (kullanıcı kararı 1: son 200 satır).
  static const capacity = 200;

  /// Yığından tutulan en fazla satır.
  static const maxFrames = 8;

  /// Satır başına en fazla karakter (uzun serbest metin kesilir).
  static const maxLineLength = 160;

  final Future<Directory> Function() _directory;
  final String appVersion;
  final DateTime Function() _clock;

  List<CrashEntry>? _entries;
  Future<void> _queue = Future<void>.value();

  /// Bir hata kaydeder. Hiçbir zaman fırlatmaz (hata yolunda çağrılır).
  /// Art arda aynı hata tekrar ederse yeni satır açılmaz, sayaç artar (her
  /// karede tekrar eden çizim hatası 200 satırı doldurmasın).
  Future<void> record(String tag, Object error, StackTrace? stack) {
    final entry = CrashEntry(
      tag: _clip(scrubDiagnosticText(tag)),
      type: _clip(error.runtimeType.toString()),
      stack: trimStack(stack),
      version: appVersion,
      at: _clock(),
    );
    return _serial(() async {
      final list = await _load();
      final last = list.isEmpty ? null : list.last;
      if (last != null && last.sameAs(entry)) {
        list[list.length - 1] = last.repeated(entry.at);
      } else {
        list.add(entry);
        if (list.length > capacity) {
          list.removeRange(0, list.length - capacity);
        }
      }
      await _save(list);
    });
  }

  /// Kayıtlar (eskiden yeniye).
  Future<List<CrashEntry>> entries() async {
    List<CrashEntry> out = const [];
    await _serial(() async => out = List.unmodifiable(await _load()));
    return out;
  }

  /// Paylaşılacak düz metin; kayıt yoksa null.
  Future<String?> exportText() async {
    final list = await entries();
    if (list.isEmpty) return null;
    final b = StringBuffer()
      ..writeln('hiVelzon hata kaydı · sürüm $appVersion')
      ..writeln(
        'Kişisel bilgi içermez: yalnızca hata türü, kodun yeri, sürüm ve '
        'saat (UTC).',
      )
      ..writeln();
    for (final e in list.reversed) {
      b.writeln(e.toText());
    }
    return b.toString();
  }

  /// "Bu telefondaki verileri sil": kayıt da silinir. Fırlatmaz.
  Future<void> clear() => _serial(() async {
    _entries = [];
    final f = await _file();
    if (await f.exists()) await f.delete();
  });

  // ------------------------------------------------------------ iç

  Future<void> _serial(Future<void> Function() job) {
    final next = _queue.then((_) => job()).catchError((Object e) {
      // Kayıt hatası uygulamayı etkilemez; yalnızca geliştirmede görünür.
      if (kDebugMode) debugPrint('[H043] hata kaydı yazılamadı: $e');
    });
    _queue = next;
    return next;
  }

  Future<File> _file() async {
    final dir = await _directory();
    return File(p.join(dir.path, 'diagnostics', 'crash_log.json'));
  }

  Future<List<CrashEntry>> _load() async {
    final cached = _entries;
    if (cached != null) return cached;
    final list = <CrashEntry>[];
    try {
      final f = await _file();
      if (await f.exists()) {
        final raw = jsonDecode(await f.readAsString());
        if (raw is List) {
          for (final item in raw) {
            final e = CrashEntry.tryParse(item);
            if (e != null) list.add(e);
          }
        }
      }
    } on Object {
      // Bozuk dosya: baştan başlanır (bir sonraki yazma üzerine yazar).
    }
    if (list.length > capacity) list.removeRange(0, list.length - capacity);
    return _entries = list;
  }

  Future<void> _save(List<CrashEntry> list) async {
    final f = await _file();
    await f.parent.create(recursive: true);
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(
      jsonEncode([for (final e in list) e.toJson()]),
      flush: true,
    );
    await tmp.rename(f.path);
  }

  static String _clip(String s) =>
      s.length <= maxLineLength ? s : '${s.substring(0, maxLineLength - 1)}…';

  /// Yığının ilk [maxFrames] satırı, temizlenmiş ve kısaltılmış.
  static List<String> trimStack(StackTrace? stack) {
    if (stack == null) return const [];
    final lines = stack
        .toString()
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty && l != '<asynchronous suspension>');
    return [
      for (final l in lines.take(maxFrames)) _clip(scrubDiagnosticText(l)),
    ];
  }
}

/// Tek kayıt satırı.
@immutable
class CrashEntry {
  const CrashEntry({
    required this.tag,
    required this.type,
    required this.stack,
    required this.version,
    required this.at,
    this.count = 1,
  });

  /// Nereden yakalandı: `flutter`, `platform`, `zone` (ya da özel etiket).
  final String tag;

  /// Hata türü (`runtimeType`); mesaj saklanmaz.
  final String type;
  final List<String> stack;
  final String version;

  /// UTC (son görülme).
  final DateTime at;

  /// Art arda kaç kez görüldü.
  final int count;

  bool sameAs(CrashEntry o) =>
      tag == o.tag &&
      type == o.type &&
      version == o.version &&
      listEquals(stack, o.stack);

  CrashEntry repeated(DateTime when) => CrashEntry(
    tag: tag,
    type: type,
    stack: stack,
    version: version,
    at: when,
    count: count + 1,
  );

  Map<String, Object> toJson() => {
    'tag': tag,
    'type': type,
    'stack': stack,
    'version': version,
    'at': at.toUtc().toIso8601String(),
    'count': count,
  };

  static CrashEntry? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final at = DateTime.tryParse('${raw['at']}');
    final stack = raw['stack'];
    if (at == null || raw['tag'] is! String || raw['type'] is! String) {
      return null;
    }
    return CrashEntry(
      tag: raw['tag'] as String,
      type: raw['type'] as String,
      stack: stack is List ? [for (final s in stack) '$s'] : const [],
      version: '${raw['version'] ?? ''}',
      at: at.toUtc(),
      count: raw['count'] is int ? raw['count'] as int : 1,
    );
  }

  String toText() {
    final b = StringBuffer(
      '${at.toUtc().toIso8601String()} [$tag] $type · $version',
    );
    if (count > 1) b.write(' · ×$count');
    for (final s in stack) {
      b.write('\n  $s');
    }
    return b.toString();
  }
}

final _url = RegExp(r'''\b[a-zA-Z][a-zA-Z0-9+.-]*://[^\s'"<>)]+''');
final _email = RegExp(r'[\w.+-]+@[\w-]+(\.[\w-]+)+');
final _bearer = RegExp(
  r'\b(Bearer|Basic|token|key|secret|password|parola)'
  r'''[\s:=]+[^\s'"]+''',
  caseSensitive: false,
);
final _uuid = RegExp(
  r'\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
  r'[0-9a-fA-F]{12}\b',
);
// JWT, base64/hex anahtarlar: 24+ karakterlik boşluksuz harf-rakam dizisi.
final _longToken = RegExp(r'[A-Za-z0-9_\-+/=.]{24,}');
final _homePath = RegExp(r'/(Users|home|var/mobile|data/user/\d+)/[^\s/)]+');

/// Tanı metnini temizler (H-043): adres, e-posta, belirteç, UUID ve kullanıcı
/// klasör adları yer tutucuya çevrilir. `package:hivelzon/...dart:12:3` gibi
/// kod konumları korunur.
String scrubDiagnosticText(String s) {
  var out = s
      .replaceAll(_url, '<adres>')
      .replaceAll(_email, '<e-posta>')
      .replaceAllMapped(_bearer, (m) => '${m[1]} <gizli>')
      .replaceAll(_uuid, '<kimlik>')
      .replaceAll(_homePath, '/<klasör>');
  out = out.replaceAllMapped(_longToken, (m) {
    final t = m[0]!;
    // Dart dosya yolları ve paket adları (harf/eğik çizgi ağırlıklı) kalır;
    // rakam ve harf karışık uzun diziler belirteç sayılır.
    final digits = t.replaceAll(RegExp(r'[^0-9]'), '').length;
    final looksLikePath = t.contains('/') && t.endsWith('.dart');
    return !looksLikePath && digits >= 4 ? '<gizli>' : t;
  });
  return out;
}
