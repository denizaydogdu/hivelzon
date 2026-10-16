import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/ui/ui.dart';
import '../../account/application/account_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/evidence_ladder.dart';
import '../../player/presentation/widgets/hi_avatar.dart';
import '../../profile/application/profile_providers.dart';
import '../application/hi_providers.dart';
import '../data/hi_store.dart';
import '../domain/weekly_summary.dart';
import 'panel/hi_week_card.dart' show weekEvidenceLine;

/// Profil → "Hi benim hakkımda ne biliyor?" (H-048, HI-ASISTAN-VE-KOC §5;
/// tasarım H-059).
///
/// Cihazda saklananları sade dille gösterir: Hi ile tek cümle giriş, nerede
/// saklandığı (bilgi kartı), sayılar (`StatTile`), saklananlar (salt okunur
/// satırlar), öğrenme kanıtları (ifade, basamak, tarih; H-093), konu
/// çipleri, son 7 gün. "Hi'nin kayıtlarını sil" öğrenme olaylarını, öğrenme
/// kanıtlarını, Söyle sonuçlarını ve yan görev durumlarını siler (onaylı).
/// İlerleme, defter (FSRS kartları ve hatırlama cevapları) ve ad silinmez.
class HiPrivacyScreen extends ConsumerWidget {
  const HiPrivacyScreen({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final account = accountViewOf(ref.read).signedIn;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(HiTexts.privacyConfirmTitle),
        content: Text(
          account
              ? HiTexts.privacyConfirmBodyAccount
              : HiTexts.privacyConfirmBody,
        ),
        actions: [
          TextButton(
            key: const ValueKey('hi-privacy-cancel'),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(HiTexts.privacyConfirmCancel),
          ),
          FilledButton(
            key: const ValueKey('hi-privacy-confirm'),
            style: AppButtonStyles.dangerFilled(),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(HiTexts.privacyConfirmDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(hiStoreProvider).deleteLearningData();
    refreshHi(ref);
    // Profil'deki "Neler yapabiliyorsun" kanıttan okunur (H-093).
    refreshNotebook(ref);
    // H-038: hesap açıksa silme işareti hemen gönderilsin (öteki cihazlar).
    if (account) unawaited(ref.read(syncControllerProvider.notifier).syncNow());
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(HiTexts.privacyDeleted)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final k = ref.watch(hiKnowledgeProvider);
    final name = ref.watch(displayNameProvider).value;
    final week = ref.watch(weeklySummaryProvider).value;
    final account = accountViewOf(ref.watch).signedIn;
    return Scaffold(
      appBar: AppBar(title: const Text(HiTexts.privacyTitle)),
      body: SafeArea(
        top: false,
        child: switch (k) {
          AsyncData(:final value) => ListView(
            key: const ValueKey('hi-privacy'),
            padding: const EdgeInsets.fromLTRB(
              AppSpace.page,
              AppSpace.s8,
              AppSpace.page,
              AppSpace.s32,
            ),
            children: [
              StaggeredList(
                spacing: AppSpace.s24,
                children: [
                  _Intro(account: account),
                  _Numbers(k: value),
                  _Stored(k: value, name: name),
                  _Evidence(items: value.evidence),
                  _Errors(counts: value.errorCounts),
                  _Week(week: week),
                  _DeleteBlock(
                    onDelete: () => unawaited(_delete(context, ref)),
                  ),
                ],
              ),
            ],
          ),
          AsyncError() => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSpace.s24),
              child: EmptyState(
                icon: Icons.cloud_off_outlined,
                title: HiTexts.privacyError,
              ),
            ),
          ),
          _ => const Center(
            child: CircularProgressIndicator(semanticsLabel: HiTexts.loading),
          ),
        },
      ),
    );
  }
}

/// Hi + tek cümle + nerede saklandığı.
class _Intro extends StatelessWidget {
  const _Intro({required this.account});

  final bool account;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // Ayrı düğüm: "görsel" işareti sayfanın geri kalanına geçmesin.
            Semantics(
              container: true,
              child: const HiAvatar(size: 64, pulseCycles: 1),
            ),
            const SizedBox(width: AppSpace.s12),
            Expanded(
              child: Text(
                HiTexts.privacyIntro,
                key: const ValueKey('hi-privacy-intro'),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s16),
        account
            ? const InfoCard(
                key: ValueKey('hi-privacy-account'),
                tone: InfoTone.info,
                icon: Icons.cloud_sync_outlined,
                title: HiTexts.privacyAccountTitle,
                body: HiTexts.privacyAccountBody,
              )
            : const InfoCard(
                key: ValueKey('hi-privacy-local'),
                tone: InfoTone.success,
                icon: Icons.phone_iphone_rounded,
                title: HiTexts.privacyLocalTitle,
                body: HiTexts.privacyLocalBody,
              ),
      ],
    );
  }
}

class _Numbers extends StatelessWidget {
  const _Numbers({required this.k});

  final HiKnowledge k;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const CapsLabel(HiTexts.privacyNumbers),
      const SizedBox(height: AppSpace.s8),
      StatRow(
        key: const ValueKey('hi-privacy-stats'),
        tiles: [
          StatTile.count(
            count: k.lookups,
            label: HiTexts.statLookups,
            icon: Icons.translate_rounded,
          ),
          StatTile.count(
            count: k.errors,
            label: HiTexts.statRetries,
            icon: Icons.replay_rounded,
            color: AppPalette.orange700,
          ),
          StatTile.count(
            count: k.speechAttempts,
            label: HiTexts.statSpeech,
            icon: Icons.mic_none_rounded,
            color: AppPalette.success,
          ),
        ],
      ),
    ],
  );
}

/// Saklananlar: salt okunur satırlar (dokunulmaz, ok yok).
class _Stored extends StatelessWidget {
  const _Stored({required this.k, required this.name});

  final HiKnowledge k;
  final String? name;

  @override
  Widget build(BuildContext context) => SettingsGroup(
    title: HiTexts.privacyStored,
    children: [
      SettingsRow(
        icon: Icons.badge_outlined,
        title: HiTexts.privacyName,
        subtitle: name ?? HiTexts.privacyNoName,
      ),
      SettingsRow(
        icon: Icons.auto_stories_outlined,
        title: HiTexts.privacyProgress,
        subtitle: HiTexts.privacyProgressValue(
          k.completedEpisodes,
          k.inProgressEpisodes,
        ),
      ),
      SettingsRow(
        icon: Icons.menu_book_outlined,
        title: HiTexts.privacyNotebook,
        subtitle: HiTexts.privacyNotebookValue(
          k.notebookItems,
          k.reviewAnswers,
        ),
      ),
      SettingsRow(
        key: const ValueKey('hi-privacy-events'),
        icon: Icons.insights_outlined,
        title: HiTexts.privacyEvents,
        subtitle: HiTexts.privacyEventsValue(k.lookups, k.errors),
      ),
      SettingsRow(
        key: const ValueKey('hi-privacy-speech'),
        icon: Icons.mic_none_rounded,
        title: SpeakTexts.privacyRow,
        subtitle: SpeakTexts.privacyValue(k.speechAttempts, k.speechFull),
      ),
      SettingsRow(
        icon: Icons.flag_outlined,
        title: HiTexts.privacyBridge,
        subtitle: HiTexts.privacyBridgeValue(k.bridgeDone, k.bridgeDismissed),
      ),
    ],
  );
}

/// Öğrenme kanıtları (H-093): ifade, basamak ve ilk tarih; en yeniden
/// eskiye. İlk [shown] satır, sonra "Hepsini göster". Salt okunur.
class _Evidence extends StatefulWidget {
  const _Evidence({required this.items});

  final List<HiEvidence> items;

  static const shown = 5;

  @override
  State<_Evidence> createState() => _EvidenceState();
}

class _EvidenceState extends State<_Evidence> {
  bool _all = false;

  static (String, IconData) _stage(EvidenceStage s) => switch (s) {
    EvidenceStage.recalledLater => (
      HiTexts.evidenceStageRecalled,
      Icons.psychology_alt_outlined,
    ),
    EvidenceStage.ownUse => (
      HiTexts.evidenceStageOwnUse,
      Icons.edit_note_rounded,
    ),
    _ => (HiTexts.evidenceStageHelped, Icons.back_hand_outlined),
  };

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final visible = _all ? items : items.take(_Evidence.shown).toList();
    final hidden = items.length - visible.length;
    return Column(
      key: const ValueKey('hi-privacy-evidence'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty) ...[
          // Boş durum: "Konulara göre yeniden denemeler" gibi sakin bir satır.
          Semantics(
            header: true,
            child: Text(
              HiTexts.privacyEvidence,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            HiTexts.privacyEvidenceValue(0),
            key: const ValueKey('hi-privacy-evidence-empty'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
          ),
        ] else
          SettingsGroup(
            title: HiTexts.privacyEvidence,
            footer: HiTexts.privacyEvidenceValue(items.length),
            children: [
              for (final (i, e) in visible.indexed)
                SettingsRow(
                  key: ValueKey('hi-privacy-evidence-$i'),
                  icon: _stage(e.stage).$2,
                  title: '“${e.text}”',
                  subtitle: HiTexts.privacyEvidenceRow(
                    _stage(e.stage).$1,
                    AccountTexts.date(e.at),
                  ),
                ),
            ],
          ),
        if (hidden > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const ValueKey('hi-privacy-evidence-all'),
              onPressed: () => setState(() => _all = true),
              style: TextButton.styleFrom(
                minimumSize: const Size(AppTouch.min, AppTouch.min),
              ),
              child: Text(HiTexts.privacyEvidenceMore(items.length)),
            ),
          ),
      ],
    );
  }
}

/// Konulara göre yeniden denemeler: çipler (çoktan aza).
class _Errors extends StatelessWidget {
  const _Errors({required this.counts});

  final Map<ErrorType, int> counts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Column(
      key: const ValueKey('hi-privacy-errors'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            HiTexts.privacyErrors,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpace.s8),
        if (sorted.isEmpty)
          Text(
            HiTexts.privacyErrorsNone,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.ink500,
            ),
          )
        else
          Wrap(
            spacing: AppSpace.s8,
            runSpacing: AppSpace.s8,
            children: [
              for (final e in sorted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.s12,
                    vertical: AppSpace.s8,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.orange50,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppPalette.orange100),
                  ),
                  child: Text(
                    HiTexts.errorChip(e.key.labelTr, e.value),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppPalette.ink,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// Son 7 gün: küçük istatistik şeridi (+ en çok çalışılan konu).
class _Week extends StatelessWidget {
  const _Week({required this.week});

  final WeeklySummary? week;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = week;
    return Column(
      key: const ValueKey('hi-privacy-week'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(HiTexts.privacyWeek, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpace.s8),
        if (w == null)
          Text(HiTexts.loading, style: theme.textTheme.bodyMedium)
        else if (w.isEmpty)
          Text(
            HiTexts.weekEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.ink500,
            ),
          )
        else ...[
          StatRow(
            tiles: [
              StatTile(
                value: '${w.phrasesAdded}',
                label: HiTexts.weekStatAdded,
              ),
              StatTile(
                value: '${w.phrasesReviewed}',
                label: HiTexts.weekStatReviewed,
              ),
              StatTile(
                value: '${w.episodesCompleted}',
                label: HiTexts.weekStatEpisodes,
              ),
            ],
          ),
          if (weekEvidenceLine(w) case final line?) ...[
            const SizedBox(height: AppSpace.s8),
            Text(
              line,
              key: const ValueKey('hi-privacy-week-evidence'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink700,
              ),
            ),
          ],
          if (w.focus != null) ...[
            const SizedBox(height: AppSpace.s8),
            Text(
              HiTexts.weekFocus(w.focus!.labelTr),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink700,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _DeleteBlock extends StatelessWidget {
  const _DeleteBlock({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          HiTexts.privacyDeleteNote,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
        const SizedBox(height: AppSpace.s12),
        OutlinedButton.icon(
          key: const ValueKey('hi-privacy-delete'),
          onPressed: onDelete,
          style: AppButtonStyles.danger(),
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text(HiTexts.privacyDelete),
        ),
      ],
    );
  }
}

/// Profil'deki satır.
class HiPrivacyRow extends StatelessWidget {
  const HiPrivacyRow({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SettingsRow(
    key: const ValueKey('profile-hi-privacy'),
    icon: Icons.privacy_tip_outlined,
    title: HiTexts.privacyTile,
    subtitle: HiTexts.privacyTileSub,
    onTap: onTap,
  );
}
