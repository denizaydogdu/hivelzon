import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../../shared/widgets/skeleton.dart';
import '../application/talk_providers.dart';
import 'talk_message_view.dart';
import 'talk_scene_view.dart';

/// Konuş görevi (H-090; tam ekran): sahne ya da kısa mesaj. Yükleniyor ve
/// hata durumları var; görev bulunamazsa sakin bir hata ve "Tekrar dene".
class TalkTaskScreen extends ConsumerWidget {
  const TalkTaskScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(talkTaskProvider(taskId));
    return switch (task) {
      AsyncData(:final value) =>
        value.isScene
            ? TalkSceneView(key: ValueKey(value.id), task: value)
            : TalkMessageView(key: ValueKey(value.id), task: value),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: EmptyState(
            key: const ValueKey('talk-task-error'),
            icon: Icons.error_outline_rounded,
            title: TalkTexts.taskError,
            message: TalkTexts.errorBody,
            action: OutlinedButton(
              onPressed: () => ref.invalidate(talkCatalogProvider),
              child: const Text(CommonTexts.retry),
            ),
          ),
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: const Padding(
          padding: EdgeInsets.all(AppSpace.page),
          child: ListSkeleton(label: TalkTexts.loading, rows: 3),
        ),
      ),
    };
  }
}
