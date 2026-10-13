import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'shared/perf/perf_log.dart';

void main() {
  // H-054: açılış ve kare ölçümü (yalnızca debug/profile).
  PerfLog.start();
  runApp(const ProviderScope(child: HiVelzonApp()));
}
