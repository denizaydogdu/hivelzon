import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/tr_strings.dart';
import '../../../shared/diagnostics/crash_reporting.dart';
import '../../../shared/ui/ui.dart';

/// Sistem paylaşım penceresini açar ([origin]: iPad'de pencerenin çıktığı
/// yer). Testlerde değiştirilir.
typedef CrashLogSharer = Future<void> Function(String text, Rect? origin);

final crashLogSharerProvider = Provider<CrashLogSharer>(
  (ref) => (text, origin) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: CrashTexts.shareSubject,
        sharePositionOrigin: origin,
      ),
    );
  },
);

/// Profil → Hakkında → "Hata kaydını paylaş" (H-043, kullanıcı kararı 1).
/// Yalnızca kullanıcı dokununca, sistem paylaşımıyla; kendiliğinden hiçbir
/// yere gönderilmez. Kayıt yoksa sakin bir not görünür.
class CrashLogShareRow extends ConsumerWidget {
  const CrashLogShareRow({super.key});

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null || !box.hasSize
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    final messenger = ScaffoldMessenger.maybeOf(context);
    void note(String text) =>
        messenger?.showSnackBar(SnackBar(content: Text(text)));
    try {
      final text = await ref.read(crashLogProvider).exportText();
      if (text == null) {
        note(CrashTexts.shareEmpty);
        return;
      }
      await ref.read(crashLogSharerProvider)(text, origin);
    } on Object catch (e) {
      debugPrint('[H043] hata kaydı paylaşılamadı: ${e.runtimeType}');
      note(CrashTexts.shareFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => SettingsRow(
    key: const ValueKey('profile-crash-log'),
    icon: Icons.bug_report_outlined,
    title: CrashTexts.shareRow,
    subtitle: CrashTexts.shareRowHint,
    onTap: () => unawaited(_share(context, ref)),
  );
}
