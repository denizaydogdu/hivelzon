import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android release debug anahtarıyla imzalanmaz', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, isNot(contains('signingConfigs.getByName("debug")')));
    expect(gradle, contains('key.properties'));
    expect(gradle, contains('create("release")'));
  });

  test('Android upload key şablonu var, gerçek sırlar git dışında', () {
    final example = File('android/key.properties.example');
    expect(example.existsSync(), isTrue);
    final text = example.readAsStringSync();
    for (final key in [
      'storeFile',
      'storePassword',
      'keyAlias',
      'keyPassword',
    ]) {
      expect(text, contains('$key='));
    }

    final ignore = File('android/.gitignore').readAsStringSync();
    expect(ignore, contains('key.properties'));
    expect(ignore, contains('**/*.jks'));
  });

  test('iOS mağaza derlemesi yerel ağ iznini taşımaz', () {
    final release = File('ios/Runner/Info-Release.plist');
    expect(release.existsSync(), isTrue);
    final text = release.readAsStringSync();
    expect(text, isNot(contains('NSAllowsLocalNetworking')));
    expect(text, isNot(contains('NSAppTransportSecurity')));
    expect(
      text,
      contains('<key>CFBundleDisplayName</key>\n\t<string>Hi</string>'),
    );

    final project = File(
      'ios/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    expect(
      project,
      contains('INFOPLIST_FILE = Runner/Info-Release.plist;'),
      reason: 'Release yapılandırması ayrı plist kullanmalı',
    );
  });

  test('iOS debug/profile yerel ağ iznini korur, anahtarlar eşleşir', () {
    final debug = File('ios/Runner/Info.plist').readAsStringSync();
    expect(debug, contains('NSAllowsLocalNetworking'));

    Set<String> keys(String plist) => RegExp(
      r'<key>([^<]+)</key>',
    ).allMatches(plist).map((m) => m.group(1)!).toSet();

    final release = File('ios/Runner/Info-Release.plist').readAsStringSync();
    expect(
      keys(release),
      keys(
        debug,
      ).difference({'NSAppTransportSecurity', 'NSAllowsLocalNetworking'}),
      reason: 'İki plist yalnızca yerel ağ izniyle ayrılmalı',
    );
  });
}
