import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/design/font_licenses.dart';
import 'app/release_config.dart';
import 'app/third_party_licenses.dart';
import 'features/library/application/audio_service_host.dart';
import 'shared/api/api_client.dart';
import 'shared/content/http_content_source.dart';
import 'shared/diagnostics/crash_log.dart';
import 'shared/diagnostics/crash_reporting.dart';
import 'shared/perf/perf_log.dart';

void main() {
  // H-043: yakalanmamış hatalar yerel kayda (kişisel veri yok, ağ yok).
  // `ensureInitialized` ve `runApp` aynı bölgede olmalı.
  runZonedGuarded(_main, CrashReporting.onZoneError);
}

void _main() {
  validateReleaseEndpoints(
    isRelease: kReleaseMode,
    apiBaseUrl: kApiBaseUrl,
    contentBaseUrl: kContentBaseUrl,
    reelCatalogUrl: kReelCatalogUrl,
  );
  // H-054: açılış ve kare ölçümü (yalnızca debug/profile).
  PerfLog.start();
  WidgetsFlutterBinding.ensureInitialized();
  CrashReporting.install(CrashLog.instance);
  // H-057: gömülü yazı tiplerinin OFL lisansları Lisanslar sayfasında.
  registerFontLicenses();
  // H-042: taşınan / uyarlanan kodun MIT bildirimleri (py-fsrs,
  // EnglishPractice).
  registerThirdPartyLicenses();
  // H-068: kitap dinlemenin kilit ekranı oturumu (beklenmez; okuyucu açılınca
  // hazırdır). Bölüm, dilbilgisi ve Keşfet bu oturumu kullanmaz.
  unawaited(AudioServiceBookSessionHost.start());
  runApp(const ProviderScope(child: HiVelzonApp()));
}
