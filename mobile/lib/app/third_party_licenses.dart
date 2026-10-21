import 'package:flutter/foundation.dart';

/// Taşınan ya da uyarlanan kodun MIT bildirimleri Flutter'ın Lisanslar
/// sayfasına eklenir (H-042; `docs/LISANS-RAPORU.md` §4). Paket olarak
/// eklenen bağımlılıklar sayfaya zaten kendiliğinden girer.
void registerThirdPartyLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ['py-fsrs'],
      '$_mitHead'
      'Copyright (c) 2022 Open Spaced Repetition\n\n$_mitBody',
    );
    yield const LicenseEntryWithLineBreaks(
      ['EnglishPractice'],
      '$_mitHead'
      'Copyright (c) 2026 recepyagmur\n\n$_mitBody',
    );
  });
}

const _mitHead = 'MIT License\n\n';
const _mitBody =
    'Permission is hereby granted, free of charge, to any person obtaining a '
    'copy of this software and associated documentation files (the '
    '"Software"), to deal in the Software without restriction, including '
    'without limitation the rights to use, copy, modify, merge, publish, '
    'distribute, sublicense, and/or sell copies of the Software, and to '
    'permit persons to whom the Software is furnished to do so, subject to '
    'the following conditions:\n\n'
    'The above copyright notice and this permission notice shall be included '
    'in all copies or substantial portions of the Software.\n\n'
    'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS '
    'OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF '
    'MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. '
    'IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY '
    'CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, '
    'TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE '
    'SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.';
