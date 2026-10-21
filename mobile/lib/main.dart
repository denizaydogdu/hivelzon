import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/design/font_licenses.dart';
import 'app/third_party_licenses.dart';
import 'features/library/application/audio_service_host.dart';
import 'shared/perf/perf_log.dart';

void main() {
  // H-054: açılış ve kare ölçümü (yalnızca debug/profile).
  PerfLog.start();
  // H-057: gömülü yazı tiplerinin OFL lisansları Lisanslar sayfasında.
  registerFontLicenses();
  // H-042: taşınan / uyarlanan kodun MIT bildirimleri (py-fsrs,
  // EnglishPractice).
  registerThirdPartyLicenses();
  // H-068: kitap dinlemenin kilit ekranı oturumu (beklenmez; okuyucu açılınca
  // hazırdır). Bölüm, dilbilgisi ve Keşfet bu oturumu kullanmaz.
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(AudioServiceBookSessionHost.start());
  runApp(const ProviderScope(child: HiVelzonApp()));
}
