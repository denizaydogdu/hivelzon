import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/haptics/haptics.dart';
import '../../../shared/ui/ui.dart';
import '../../account/presentation/account_widgets.dart';
import '../../hi/application/hi_providers.dart';
import '../../hi/presentation/hi_privacy_screen.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/evidence_ladder.dart';
import '../../notebook/domain/notebook_item.dart';
import '../../notebook/domain/review_policy.dart';
import '../../player/presentation/widgets/hi_avatar.dart';
import '../../speak/speech_settings_section.dart';
import '../application/profile_providers.dart';
import '../data/user_profile_store.dart';
import '../../hi/presentation/hi_bubble.dart';

/// Profil (H-036, H-053; tasarım H-059): illüstrasyonlu dalga başlık, ad ve
/// tek satır durum, üç istatistik ve gruplanmış ayarlar. Açıklamalar satır
/// altı ipucudur; ad ve günlük hedef alt panelde değişir.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const headerImage = AssetImage(
    'assets/illustrations/profil-baslik.webp',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(reviewOverviewProvider).value;
    final goal = ref.watch(dailyGoalProvider).value;
    final name = ref.watch(displayNameProvider).value;
    final knowledge = ref.watch(hiKnowledgeProvider).value;
    final week = ref.watch(weeklySummaryProvider).value;
    final minutes = goal ?? ReviewPolicy.defaultDailyGoalMinutes;

    final notebookHint = overview == null
        ? ProfileTexts.notebookLoading
        : overview.totalItems == 0
        ? ProfileTexts.notebookEmpty
        : ProfileTexts.notebookCount(
            overview.totalItems,
            overview.sessionCount,
          );

    Future<void> open(String route, {bool hi = false}) async {
      await context.push(route);
      if (!context.mounted) return;
      refreshNotebook(ref);
      if (hi) refreshHi(ref);
    }

    final topInset = MediaQuery.paddingOf(context).top;
    return Scaffold(
      // Üstte güvenli alan yok: illüstrasyon durum çubuğunun altına uzanır.
      // Hi balonunun payı yalnızca listenin sonunda (HiBubbleInset, H-064).
      // Kaydırınca avatar ve selam saatin altına girmesin: durum çubuğu
      // perdesi (H-064).
      body: StatusBarScrim(
        child: SafeArea(
          top: false,
          child: ListView(
            key: const ValueKey('profile-list'),
            padding: EdgeInsets.only(
              bottom: AppSpace.s32 + HiBubbleInset.of(context),
            ),
            children: [
              ShapedHeader(image: headerImage, height: 168 + topInset),
              _Identity(
                name: name,
                status: week == null
                    ? null
                    : ProfileTexts.status(
                        phrasesAdded: week.phrasesAdded,
                        phrasesReviewed: week.phrasesReviewed,
                        episodesCompleted: week.episodesCompleted,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.page),
                child: StaggeredList(
                  spacing: AppSpace.s24,
                  children: [
                    // H-089: kanıta dayalı küçük kazanımlar.
                    const EvidenceSection(),
                    // İçerik ilerlemesi: bitirilen ve toplanan; dil
                    // ustalığı olarak yorumlanmaz (H-089).
                    SettingsGroup.section(
                      title: ProfileTexts.contentProgressGroup,
                      child: StatRow(
                        key: const ValueKey('profile-stats'),
                        tiles: [
                          StatTile.count(
                            count: overview?.totalItems ?? 0,
                            label: ProfileTexts.statPhrases,
                            icon: Icons.menu_book_rounded,
                          ),
                          StatTile.count(
                            count: knowledge?.completedEpisodes ?? 0,
                            label: ProfileTexts.statEpisodes,
                            icon: Icons.auto_stories_rounded,
                            color: AppPalette.orange700,
                          ),
                          StatTile.count(
                            count: week?.phrasesReviewed ?? 0,
                            label: ProfileTexts.statWeekReviews,
                            icon: Icons.replay_rounded,
                            color: AppPalette.success,
                          ),
                        ],
                      ),
                    ),
                    SettingsGroup(
                      title: ProfileTexts.learningGroup,
                      children: [
                        SettingsRow(
                          key: const ValueKey('profile-notebook'),
                          icon: Icons.menu_book_rounded,
                          title: ProfileTexts.notebookTile,
                          subtitle: notebookHint,
                          onTap: () => unawaited(open(AppRoutes.notebook)),
                        ),
                        SettingsRow(
                          key: const ValueKey('profile-goal'),
                          icon: Icons.track_changes_rounded,
                          title: ProfileTexts.goalSection,
                          subtitle: ProfileTexts.goalNote(
                            ReviewPolicy.newCardsPerDay(minutes),
                          ),
                          value: ProfileTexts.goalOption(minutes),
                          onTap: () => unawaited(showDailyGoalSheet(context)),
                        ),
                        // H-055: aç/kapat; destek ya da izin yoksa nedeni.
                        const SpeechSettingsRow(),
                        // H-064: bütün dokunsal onaylar bu ayara bağlı.
                        const HapticsSettingsRow(),
                        SettingsRow(
                          key: const ValueKey('profile-topic-sets'),
                          icon: Icons.category_outlined,
                          title: ProfileTexts.topicSetsTile,
                          subtitle: ProfileTexts.topicSetsHint,
                          onTap: () => unawaited(open(AppRoutes.notebookSets)),
                        ),
                      ],
                    ),
                    SettingsGroup(
                      title: ProfileTexts.accountGroup,
                      children: [
                        // H-038: isteğe bağlı hesap ve eşitleme.
                        const AccountRow(),
                        HiPrivacyRow(
                          onTap: () =>
                              unawaited(open(AppRoutes.hiPrivacy, hi: true)),
                        ),
                        SettingsRow(
                          key: const ValueKey('profile-name-row'),
                          icon: Icons.badge_outlined,
                          title: ProfileTexts.nameRow,
                          subtitle: ProfileTexts.nameRowHint,
                          value: name ?? ProfileTexts.nameRowEmpty,
                          onTap: () => unawaited(showDisplayNameSheet(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Neler yapabiliyorsun" (H-089): kanıt basamaklarından en çok dört kısa
/// cümle; sayı yığını ve yüzde yok. Basamak kuralları
/// `docs/KELIME-TEKRARI.md` §3.
class EvidenceSection extends ConsumerWidget {
  const EvidenceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(evidenceSummaryProvider).value ?? EvidenceSummary.empty;
    List<String> en(List<NotebookItem> l) => [for (final i in l) i.textEn];
    final lines = <(String, IconData, Color, String)>[
      if (s.recalledLater.isNotEmpty)
        (
          'recalled',
          Icons.event_available_rounded,
          AppPalette.success,
          ProfileTexts.evidenceRecalled(en(s.recalledLater)),
        ),
      if (s.ownUse.isNotEmpty)
        (
          'own',
          Icons.record_voice_over_rounded,
          AppPalette.seaBlue,
          ProfileTexts.evidenceOwnUse(en(s.ownUse)),
        ),
      if (s.helped.isNotEmpty && s.recalledLater.isEmpty && s.ownUse.isEmpty)
        (
          'helped',
          Icons.handshake_outlined,
          AppPalette.orange700,
          ProfileTexts.evidenceHelped(en(s.helped)),
        ),
      if (s.revisit.isNotEmpty)
        (
          'revisit',
          Icons.replay_rounded,
          AppPalette.orange700,
          ProfileTexts.evidenceRevisit(en(s.revisit)),
        ),
      if (!s.hasEvidence && s.revisit.isEmpty)
        (
          'empty',
          Icons.auto_awesome_outlined,
          AppPalette.ink500,
          ProfileTexts.evidenceEmpty,
        ),
    ];
    return SettingsGroup(
      key: const ValueKey('profile-evidence'),
      title: ProfileTexts.evidenceGroup,
      footer: s.hasEvidence ? ProfileTexts.evidenceFooter : null,
      children: [
        for (final (id, icon, color, text) in lines)
          IconLine(
            key: ValueKey('profile-evidence-$id'),
            icon: icon,
            color: color,
            text: text,
          ),
      ],
    );
  }
}

/// Profil → Öğrenme → "Titreşim" (H-064): varsayılan açık; kapalıyken
/// uygulama hiç titreşmez ([Haptics]).
class HapticsSettingsRow extends ConsumerWidget {
  const HapticsSettingsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(hapticsEnabledProvider).value ?? true;
    return SettingsRow.toggle(
      key: const ValueKey('profile-haptics-toggle'),
      icon: Icons.vibration_rounded,
      title: ProfileTexts.hapticsTile,
      subtitle: ProfileTexts.hapticsHint,
      value: on,
      onChanged: (value) async {
        await ref.read(hapticsStoreProvider).setEnabled(value);
        ref.invalidate(hapticsEnabledProvider);
      },
    );
  }
}

/// Avatar (adın ilk harfi; ad yoksa Hi) + "Merhaba Deniz" + durum satırı.
/// Avatar dalganın üstüne biner.
class _Identity extends StatelessWidget {
  const _Identity({required this.name, required this.status});

  final String? name;
  final String? status;

  static const double _avatar = 88;
  static const double _overlap = 32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name == null || name!.isEmpty
        ? null
        : String.fromCharCode(name!.runes.first);
    return Transform.translate(
      offset: const Offset(0, -_overlap),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.page),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Semantics(
              label: name ?? ProfileTexts.avatarNoName,
              image: true,
              excludeSemantics: true,
              child: Container(
                key: const ValueKey('profile-avatar'),
                width: _avatar,
                height: _avatar,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.seaBlue,
                  border: Border.all(color: AppPalette.sand, width: 4),
                  boxShadow: AppShadows.level2,
                ),
                child: initial == null
                    ? const HiAvatar(size: 64, glow: false)
                    : Text(
                        initial,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: AppPalette.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: AppSpace.s16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        ProfileTexts.greeting(name),
                        key: const ValueKey('profile-greeting'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppPalette.seaBlue,
                        ),
                      ),
                    ),
                    if (status != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        status!,
                        key: const ValueKey('profile-status'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppPalette.ink500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Günlük hedef paneli: 5 / 10 / 15 dk ve ne anlama geldiği. Seçim hemen
/// kaydedilir; panel açık kalır.
Future<void> showDailyGoalSheet(BuildContext context) => showAppSheet<void>(
  context: context,
  title: ProfileTexts.goalSection,
  builder: (_) => const DailyGoalPicker(),
);

class DailyGoalPicker extends ConsumerWidget {
  const DailyGoalPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final minutes =
        ref.watch(dailyGoalProvider).value ??
        ReviewPolicy.defaultDailyGoalMinutes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(ProfileTexts.goalIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpace.s16),
        SegmentedButton<int>(
          key: const ValueKey('daily-goal'),
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            minimumSize: const Size(AppTouch.min, AppTouch.min),
          ),
          segments: [
            for (final m in ReviewPolicy.newCardsPerDayByGoal.keys)
              ButtonSegment(value: m, label: Text(ProfileTexts.goalOption(m))),
          ],
          selected: {minutes},
          onSelectionChanged: (s) async {
            await ref.read(notebookStoreProvider).setDailyGoalMinutes(s.first);
            ref.invalidate(dailyGoalProvider);
            refreshNotebook(ref);
            refreshHi(ref);
          },
        ),
        const SizedBox(height: AppSpace.s16),
        InfoCard(
          tone: InfoTone.info,
          icon: Icons.auto_awesome_outlined,
          title: ProfileTexts.goalNote(ReviewPolicy.newCardsPerDay(minutes)),
          body: ProfileTexts.goalChangeNote,
        ),
      ],
    );
  }
}

/// Ad paneli: "Sana nasıl seslenelim?" alanı ve Kaydet.
Future<void> showDisplayNameSheet(BuildContext context) => showAppSheet<void>(
  context: context,
  title: ProfileTexts.nameSection,
  builder: (context) => Padding(
    // Klavye açılınca alan ve düğme görünür kalsın.
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: const SingleChildScrollView(
      child: DisplayNameField(closeOnSave: true),
    ),
  ),
);

/// "Sana nasıl seslenelim?" alanı: isteğe bağlı, en fazla 20 karakter,
/// yalnızca bu cihazda (H-053).
class DisplayNameField extends ConsumerStatefulWidget {
  const DisplayNameField({super.key, this.closeOnSave = false});

  /// Alt paneldeyse kaydedince panel kapanır.
  final bool closeOnSave;

  @override
  ConsumerState<DisplayNameField> createState() => _DisplayNameFieldState();
}

class _DisplayNameFieldState extends ConsumerState<DisplayNameField> {
  final _controller = TextEditingController();
  bool _loaded = false;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _messageFor(DisplayNameError? e) => switch (e) {
    null => null,
    DisplayNameError.tooLong => ProfileTexts.nameTooLong,
    DisplayNameError.invalidCharacters => ProfileTexts.nameInvalid,
  };

  Future<void> _save() async {
    final error = _messageFor(validateDisplayName(_controller.text));
    setState(() => _error = error);
    if (error != null || _saving) return;
    setState(() => _saving = true);
    final name = normalizeDisplayName(_controller.text);
    try {
      await ref.read(userProfileStoreProvider).setDisplayName(name);
      ref.invalidate(displayNameProvider);
      if (!mounted) return;
      _controller.text = name ?? '';
      FocusScope.of(context).unfocus();
      final messenger = ScaffoldMessenger.of(context);
      if (widget.closeOnSave) Navigator.of(context).maybePop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            name == null ? ProfileTexts.nameCleared : ProfileTexts.nameSaved,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(displayNameProvider);
    if (!_loaded && current.hasValue) {
      _loaded = true;
      _controller.text = current.value ?? '';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const ValueKey('profile-name'),
          controller: _controller,
          autofocus: widget.closeOnSave,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          enableSuggestions: false,
          maxLength: UserProfileStore.maxNameLength,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: InputDecoration(
            labelText: ProfileTexts.nameLabel,
            helperText: ProfileTexts.nameHelper,
            helperMaxLines: 2,
            // Sayaç gizli: ekran okuyucu onu İngilizce okuyordu
            // ("characters remaining"). Sınırı `maxLength` korur.
            counterText: '',
            errorText: _error,
            errorMaxLines: 2,
          ),
        ),
        const SizedBox(height: AppSpace.s16),
        FilledButton(
          key: const ValueKey('profile-name-save'),
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.primary),
          ),
          child: const Text(CommonTexts.save),
        ),
      ],
    );
  }
}
