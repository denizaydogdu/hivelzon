import 'dart:convert';
import 'dart:io';

import 'package:hivelzon/features/player/domain/episode.dart';

/// Gerçek B1–B4 `scenes.json` kopyaları (yalnızca JSON; medya yok).
Episode loadFixture(String id) => Episode.fromJson(
  jsonDecode(File('test/fixtures/$id.scenes.json').readAsStringSync()),
);

String fixtureText(String name) =>
    File('test/fixtures/$name').readAsStringSync();
