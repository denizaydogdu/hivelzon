import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/router.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../account/application/account_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/review_policy.dart';
import '../../player/application/player_session.dart' show SubtitleMode;
import '../../player/data/subtitle_preference_store.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/data/user_profile_store.dart';
import '../application/onboarding_providers.dart';
import '../domain/age.dart';
import '../domain/placement.dart';

/// Açılış adımları (H-039). Test ve sonuç, "Seviye" adımının parçasıdır.
enum OnboardingStep {
  welcome,
  about,
  privacy,
  prefs,
  level,
  test,
  result,
  ready,
}

/// İlk açılış (H-039; taslak `tasarim/v2/onizleme/S09-acilis.jpg`):
/// karşılama → doğum yılı ve isteğe bağlı ad → kısa bilgilendirme → günlük
/// hedef ve Türkçe altyazı satırı (K-03) → atlanabilir yerleştirme testi
/// (K-06) → hazır.
///
/// - Hesap istenmez (H-009). 13 yaş altına hesap hiç önerilmez (H-002);
///   yaş kapısı ([AgeGate]) mevcut hesap ekranlarıyla ortaktır.
/// - Doğum yılı ve ad yalnızca bu telefonda (`app_meta`).
/// - Bildirim izni burada **istenmez**; günlük hatırlatma (H-013) ilk bölüm
///   bittikten sonra, hatırlatma saati seçilirken sorulacak.
/// - Prolog (A1-000) henüz oynanabilir paket değil: bitişte Ana Sayfa'ya
///   gidilir; oradaki tek eylem ilk bölümü açar.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.next, this.clock});

  /// Açılıştan sonra gidilecek yol (yönlendirmenin `sonra` parametresi).
  final String? next;

  /// Testler için saat (yaş hesabı).
  final DateTime Function()? clock;

  /// Karşılama illüstrasyonu (H-058 I06; görselde yazı yok).
  static const welcomeImage = AssetImage('assets/illustrations/hosgeldin.webp');

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  OnboardingStep _step = OnboardingStep.welcome;
  final _year = TextEditingController();
  final _name = TextEditingController();
  String? _yearError;
  String? _nameError;
  AgeBand? _band;
  int _goal = ReviewPolicy.defaultDailyGoalMinutes;
  bool _turkishLine = true;
  CefrLevel? _guess;
  PlacementEngine? _engine;
  CefrLevel? _result;
  bool _busy = false;

  DateTime get _now => (widget.clock ?? DateTime.now)().toUtc();

  @override
  void initState() {
    super.initState();
    unawaited(_prefill());
  }

  /// Açılış yarıda kaldıysa girilen ad geri gelir.
  Future<void> _prefill() async {
    try {
      // Doğum yılı saklanmadığı için yalnızca ad geri gelir.
      final name = await ref.read(userProfileStoreProvider).displayName();
      if (!mounted) return;
      if (name != null && _name.text.isEmpty) _name.text = name;
    } on Object catch (e) {
      debugPrint('[H039] açılış bilgileri okunamadı: $e');
    }
  }

  @override
  void dispose() {
    _year.dispose();
    _name.dispose();
    super.dispose();
  }

  bool get _child {
    final blocked = accountViewOf(ref.watch).ageBlocked(_now);
    return blocked || _band == AgeBand.under13;
  }

  void _go(OnboardingStep step) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _step = step);
  }

  void _back() {
    switch (_step) {
      case OnboardingStep.welcome:
        return;
      case OnboardingStep.about:
        _go(OnboardingStep.welcome);
      case OnboardingStep.privacy:
        _go(OnboardingStep.about);
      case OnboardingStep.prefs:
        _go(OnboardingStep.privacy);
      case OnboardingStep.level:
        _go(OnboardingStep.prefs);
      case OnboardingStep.test:
      case OnboardingStep.result:
        _go(OnboardingStep.level);
      case OnboardingStep.ready:
        _go(OnboardingStep.level);
    }
  }

  // ------------------------------------------------------------ eylemler

  Future<void> _saveAbout() async {
    final yearError = switch (validateBirthYear(_year.text, _now)) {
      null => null,
      BirthYearError.empty => OnboardingTexts.birthYearEmpty,
      BirthYearError.format => OnboardingTexts.birthYearInvalid,
      BirthYearError.outOfRange => OnboardingTexts.birthYearOutOfRange,
    };
    final nameError = switch (validateDisplayName(_name.text)) {
      null => null,
      DisplayNameError.tooLong => OnboardingTexts.nameTooLong,
      DisplayNameError.invalidCharacters => OnboardingTexts.nameInvalid,
    };
    setState(() {
      _yearError = yearError;
      _nameError = nameError;
    });
    if (yearError != null || nameError != null || _busy) return;
    final year = int.parse(_year.text.trim());
    final band = ageBandOf(year, _now);
    setState(() => _busy = true);
    try {
      await ref.read(onboardingStoreProvider).setAgeThresholds(year, _now);
      if (band == AgeBand.under13) {
        // Hesap ekranlarıyla aynı kapı: hesap açma gösterilmez (H-002).
        // Açılışta geri dönülüp yıl değiştirilse de kapı açılmaz.
        await ref.read(ageGateStoreProvider).block(year);
        ref.invalidate(ageGateProvider);
      }
      await ref
          .read(userProfileStoreProvider)
          .setDisplayName(normalizeDisplayName(_name.text));
      ref.invalidate(displayNameProvider);
    } on Object catch (e) {
      debugPrint('[H039] açılış bilgileri kaydedilemedi: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (!mounted) return;
    _band = band;
    _go(OnboardingStep.privacy);
  }

  Future<void> _acceptNotice() async {
    final config = ref.read(apiConfigProvider);
    try {
      await ref
          .read(onboardingStoreProvider)
          .setNoticeVersion(config.privacyNoticeVersion);
      // H-095: açılışta gösterilen sürümler görüldü; "metin güncellendi"
      // kartı yalnızca sonraki bir sürümde çıkar.
      await ref
          .read(legalUpdateNoticeStoreProvider)
          .markSeen(
            termsVersion: config.termsVersion,
            privacyVersion: config.privacyNoticeVersion,
          );
    } on Object catch (e) {
      debugPrint('[H039] bilgilendirme kaydı yazılamadı: $e');
    }
    if (mounted) _go(OnboardingStep.prefs);
  }

  Future<void> _savePrefs() async {
    try {
      await ref.read(notebookStoreProvider).setDailyGoalMinutes(_goal);
      ref.invalidate(dailyGoalProvider);
      await ref
          .read(subtitlePreferenceStoreProvider)
          .setMode(_turkishLine ? SubtitleMode.enTr : SubtitleMode.en);
    } on Object catch (e) {
      debugPrint('[H039] tercihler kaydedilemedi: $e');
    }
    if (mounted) _go(OnboardingStep.level);
  }

  Future<void> _startTest() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final bank = await ref.read(placementBankProvider.future);
      if (!mounted) return;
      _engine = PlacementEngine(bank, selfLevel: _guess);
      _result = null;
      _go(OnboardingStep.test);
    } on Object catch (e) {
      // Havuz yüklenemezse test atlanır; açılış sürer.
      debugPrint('[H039] soru havuzu yüklenemedi: $e');
      if (mounted) _go(OnboardingStep.ready);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _answer(int? option) {
    final engine = _engine;
    if (engine == null) return;
    setState(() => engine.answer(option));
    final result = engine.result;
    if (result == null) return;
    _result = result;
    unawaited(
      ref
          .read(onboardingStoreProvider)
          .setSuggestedLevel(result.code)
          .catchError((Object e) => debugPrint('[H039] sonuç yazılamadı: $e')),
    );
    _go(OnboardingStep.result);
  }

  Future<void> _finish() async {
    if (_busy) return;
    setState(() => _busy = true);
    await ref.read(onboardingGateProvider.notifier).complete();
    if (!mounted) return;
    final next = widget.next;
    context.go(
      next != null && next.startsWith('/') && !isOnboardingPath(next)
          ? next
          : AppRoutes.home,
    );
  }

  // ------------------------------------------------------------ görünüm

  @override
  Widget build(BuildContext context) {
    final gate = ref.watch(onboardingGateProvider);
    if (gate == OnboardingGate.checking) {
      // Kısa okuma: boş zemin (yanıp sönen ekran ya da sonsuz gösterge yok).
      return Scaffold(
        body: Semantics(
          label: OnboardingTexts.loading,
          child: const SizedBox.expand(),
        ),
      );
    }
    return PopScope(
      canPop: _step == OnboardingStep.welcome,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: switch (_step) {
        OnboardingStep.welcome => _welcome(context),
        OnboardingStep.about => _about(context),
        OnboardingStep.privacy => _privacy(context),
        OnboardingStep.prefs => _prefs(context),
        OnboardingStep.level => _level(context),
        OnboardingStep.test => _test(context),
        OnboardingStep.result => _resultView(context),
        OnboardingStep.ready => _ready(context),
      },
    );
  }

  static const _dotCount = 6;

  int get _dotIndex => switch (_step) {
    OnboardingStep.welcome => 0,
    OnboardingStep.about => 1,
    OnboardingStep.privacy => 2,
    OnboardingStep.prefs => 3,
    OnboardingStep.level || OnboardingStep.test || OnboardingStep.result => 4,
    OnboardingStep.ready => 5,
  };

  Widget _page({
    required List<Widget> children,
    required List<Widget> actions,
    Widget? header,
    bool showBack = true,
    Widget? trailing,
  }) {
    final body = Column(
      children: [
        if (header == null)
          SafeArea(
            bottom: false,
            child: _TopRow(
              onBack: showBack ? _back : null,
              index: _dotIndex,
              count: _dotCount,
              trailing: trailing,
            ),
          ),
        Expanded(
          child: ListView(
            key: const ValueKey('onboarding-scroll'),
            padding: EdgeInsets.zero,
            children: [
              ?header,
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.page,
                  AppSpace.s8,
                  AppSpace.page,
                  AppSpace.s24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: FadeSlideIn(
                      key: ValueKey('step-${_step.name}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: children,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (actions.isNotEmpty)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.page,
                AppSpace.s8,
                AppSpace.page,
                AppSpace.s16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: actions,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
    return Scaffold(
      key: ValueKey('onboarding-${_step.name}'),
      // Başlık illüstrasyonu durum çubuğunun altına uzanır; kaydırınca
      // metin saatin altına girmesin (H-064 durum çubuğu perdesi).
      body: header == null ? body : StatusBarScrim(child: body),
    );
  }

  Widget _title(BuildContext context, String text, {String? body}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            text,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppPalette.seaBlue,
            ),
          ),
        ),
        if (body != null) ...[
          const SizedBox(height: AppSpace.s8),
          Text(
            body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppPalette.ink700,
            ),
          ),
        ],
        const SizedBox(height: AppSpace.s24),
      ],
    );
  }

  Widget _primary(String label, VoidCallback? onPressed, {Key? key}) =>
      PressScale(
        enabled: onPressed != null,
        child: FilledButton(
          key: key,
          onPressed: _busy ? null : onPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.primary),
          ),
          child: Text(label, textAlign: TextAlign.center),
        ),
      );

  Widget _quiet(String label, VoidCallback onPressed, {Key? key}) => Padding(
    padding: const EdgeInsets.only(top: AppSpace.s8),
    child: TextButton(
      key: key,
      onPressed: _busy ? null : onPressed,
      child: Text(label, textAlign: TextAlign.center),
    ),
  );

  // ---- karşılama

  Widget _welcome(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    return _page(
      showBack: false,
      header: ShapedHeader(
        image: OnboardingScreen.welcomeImage,
        height: 260 + topInset,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(
            OnboardingTexts.welcomeTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppPalette.seaBlue,
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s12),
        Text(
          OnboardingTexts.welcomeBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.ink700),
        ),
        const SizedBox(height: AppSpace.s24),
        const InfoCard(
          tone: InfoTone.info,
          icon: Icons.phone_iphone_rounded,
          title: OnboardingTexts.welcomeNoAccount,
        ),
      ],
      actions: [
        _primary(
          OnboardingTexts.welcomeStart,
          () => _go(OnboardingStep.about),
          key: const ValueKey('onboarding-start'),
        ),
      ],
    );
  }

  // ---- doğum yılı ve ad

  Widget _about(BuildContext context) {
    final theme = Theme.of(context);
    return _page(
      children: [
        _title(
          context,
          OnboardingTexts.aboutTitle,
          body: OnboardingTexts.aboutBody,
        ),
        TextField(
          key: const ValueKey('onboarding-birth-year'),
          controller: _year,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
          autofillHints: const [AutofillHints.birthdayYear],
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            if (_yearError != null) setState(() => _yearError = null);
          },
          decoration: InputDecoration(
            labelText: OnboardingTexts.birthYearLabel,
            helperText: OnboardingTexts.birthYearHelper,
            helperMaxLines: 3,
            counterText: '',
            errorText: _yearError,
            errorMaxLines: 3,
          ),
        ),
        const SizedBox(height: AppSpace.s24),
        Text(OnboardingTexts.nameHeading, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpace.s8),
        TextField(
          key: const ValueKey('onboarding-name'),
          controller: _name,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          enableSuggestions: false,
          maxLength: UserProfileStore.maxNameLength,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => unawaited(_saveAbout()),
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
          decoration: InputDecoration(
            labelText: OnboardingTexts.nameLabel,
            helperText: OnboardingTexts.nameHelper,
            helperMaxLines: 2,
            counterText: '',
            errorText: _nameError,
            errorMaxLines: 3,
          ),
        ),
      ],
      actions: [
        _primary(
          CommonTexts.continueAction,
          () => unawaited(_saveAbout()),
          key: const ValueKey('onboarding-about-next'),
        ),
      ],
    );
  }

  // ---- bilgilendirme

  static const _privacyIcons = [
    Icons.phone_iphone_rounded,
    Icons.mic_off_outlined,
    Icons.block_rounded,
    Icons.auto_awesome_outlined,
  ];

  Widget _privacy(BuildContext context) {
    return _page(
      children: [
        _title(
          context,
          OnboardingTexts.privacyTitle,
          body: OnboardingTexts.privacyBody,
        ),
        StaggeredList(
          spacing: AppSpace.s12,
          children: [
            for (var i = 0; i < OnboardingTexts.privacyPoints.length; i++)
              InfoCard(
                icon: _privacyIcons[i],
                title: OnboardingTexts.privacyPoints[i].$1,
                body: OnboardingTexts.privacyPoints[i].$2,
              ),
            if (_child)
              const InfoCard(
                key: ValueKey('onboarding-under13-note'),
                tone: InfoTone.info,
                icon: Icons.family_restroom_rounded,
                title: OnboardingTexts.privacyUnder13,
              ),
            InfoCard(
              tone: InfoTone.warning,
              icon: Icons.edit_note_rounded,
              title: OnboardingTexts.draftTitle,
              body: OnboardingTexts.draftBody,
              action: Wrap(
                spacing: AppSpace.s8,
                runSpacing: AppSpace.s4,
                children: [
                  TextButton.icon(
                    key: const ValueKey('onboarding-terms'),
                    onPressed: () =>
                        context.push(AppRoutes.onboardingLegal('kosullar')),
                    icon: const Icon(Icons.description_outlined),
                    label: const Text(OnboardingTexts.termsLink),
                  ),
                  TextButton.icon(
                    key: const ValueKey('onboarding-privacy-notice'),
                    onPressed: () =>
                        context.push(AppRoutes.onboardingLegal('aydinlatma')),
                    icon: const Icon(Icons.privacy_tip_outlined),
                    label: const Text(OnboardingTexts.privacyLink),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
      actions: [
        _primary(
          OnboardingTexts.privacyAccept,
          () => unawaited(_acceptNotice()),
          key: const ValueKey('onboarding-privacy-next'),
        ),
      ],
    );
  }

  // ---- tercihler

  Widget _prefs(BuildContext context) {
    final theme = Theme.of(context);
    return _page(
      children: [
        _title(
          context,
          OnboardingTexts.prefsTitle,
          body: OnboardingTexts.prefsBody,
        ),
        Semantics(
          header: true,
          child: Text(
            OnboardingTexts.goalHeading,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        Text(OnboardingTexts.goalIntro, style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpace.s12),
        SegmentedButton<int>(
          key: const ValueKey('onboarding-goal'),
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            minimumSize: const Size(AppTouch.min, AppTouch.min),
          ),
          segments: [
            for (final m in ReviewPolicy.newCardsPerDayByGoal.keys)
              ButtonSegment(
                value: m,
                label: Text(OnboardingTexts.goalOption(m)),
              ),
          ],
          selected: {_goal},
          onSelectionChanged: (s) => setState(() => _goal = s.first),
        ),
        const SizedBox(height: AppSpace.s24),
        SettingsGroup(
          children: [
            SettingsRow.toggle(
              key: const ValueKey('onboarding-turkish-line'),
              icon: Icons.subtitles_outlined,
              title: OnboardingTexts.turkishLineTitle,
              subtitle: OnboardingTexts.turkishLineBody,
              value: _turkishLine,
              onChanged: (v) => setState(() => _turkishLine = v),
            ),
          ],
        ),
      ],
      actions: [
        _primary(
          CommonTexts.continueAction,
          () => unawaited(_savePrefs()),
          key: const ValueKey('onboarding-prefs-next'),
        ),
      ],
    );
  }

  // ---- seviye

  Widget _level(BuildContext context) {
    final theme = Theme.of(context);
    Widget chip(CefrLevel? level, String label) => ChoiceChip(
      key: ValueKey('onboarding-guess-${level?.code ?? 'unknown'}'),
      label: Text(label),
      selected: _guess == level,
      onSelected: (_) => setState(() => _guess = level),
    );
    return _page(
      children: [
        _title(
          context,
          OnboardingTexts.levelTitle,
          body: OnboardingTexts.levelBody,
        ),
        Semantics(
          header: true,
          child: Text(
            OnboardingTexts.levelGuessHeading,
            style: theme.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpace.s8),
        Wrap(
          spacing: AppSpace.s8,
          runSpacing: AppSpace.s4,
          children: [
            chip(null, OnboardingTexts.levelGuessUnknown),
            for (final l in CefrLevel.values) chip(l, l.code),
          ],
        ),
      ],
      actions: [
        _primary(
          OnboardingTexts.levelStart,
          () => unawaited(_startTest()),
          key: const ValueKey('onboarding-test-start'),
        ),
        _quiet(
          OnboardingTexts.levelSkip,
          () => _go(OnboardingStep.ready),
          key: const ValueKey('onboarding-test-skip'),
        ),
      ],
    );
  }

  // ---- test

  static String _instruction(PlacementItem item) =>
      item.instructionTr ??
      switch (item.kind) {
        PlacementKind.vocabulary => OnboardingTexts.instructionVocabulary,
        PlacementKind.grammar => OnboardingTexts.instructionGrammar,
        PlacementKind.reading => OnboardingTexts.instructionReading,
      };

  Widget _test(BuildContext context) {
    final engine = _engine;
    final item = engine?.current;
    if (engine == null || item == null) return _ready(context);
    final theme = Theme.of(context);
    return _page(
      showBack: false,
      trailing: TextButton(
        key: const ValueKey('placement-quit'),
        onPressed: () => _go(OnboardingStep.ready),
        child: const Text(OnboardingTexts.quitTest),
      ),
      children: [
        CapsLabel(
          OnboardingTexts.questionLabel(
            engine.questionNumber,
            engine.bank.maxQuestions,
          ),
          tone: CapsTone.blue,
        ),
        const SizedBox(height: AppSpace.s12),
        Text(
          _instruction(item),
          style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.ink700),
        ),
        const SizedBox(height: AppSpace.s16),
        if (item.text != null) ...[
          Container(
            padding: const EdgeInsets.all(AppSpace.s16),
            decoration: const BoxDecoration(
              color: AppPalette.white,
              borderRadius: AppRadius.mdAll,
              boxShadow: AppShadows.level1,
            ),
            child: Text(
              item.text!,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
          const SizedBox(height: AppSpace.s16),
        ],
        Semantics(
          label: item.prompt.replaceAll('___', '…'),
          excludeSemantics: true,
          child: Text(
            item.prompt,
            key: const ValueKey('placement-prompt'),
            style: theme.textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSpace.s24),
        for (var i = 0; i < item.options.length; i++) ...[
          PressScale(
            child: OutlinedButton(
              key: ValueKey('placement-option-$i'),
              onPressed: () => _answer(i),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
                alignment: AlignmentDirectional.centerStart,
                backgroundColor: AppPalette.white,
                foregroundColor: AppPalette.ink,
                side: const BorderSide(color: AppPalette.ink200, width: 1.5),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.mdAll,
                ),
                textStyle: theme.textTheme.bodyLarge,
              ),
              child: Text(item.options[i]),
            ),
          ),
          const SizedBox(height: AppSpace.s12),
        ],
        const SizedBox(height: AppSpace.s4),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: DontKnowButton(
            key: const ValueKey('placement-dont-know'),
            label: OnboardingTexts.dontKnow,
            onPressed: () => _answer(null),
          ),
        ),
      ],
      actions: const [],
    );
  }

  // ---- sonuç

  Widget _resultView(BuildContext context) {
    final theme = Theme.of(context);
    final code = (_result ?? CefrLevel.a1).code;
    return _page(
      children: [
        const SizedBox(height: AppSpace.s16),
        const Center(
          child: CapsLabel(OnboardingTexts.resultCaps, tone: CapsTone.blue),
        ),
        const SizedBox(height: AppSpace.s16),
        Center(
          child: Semantics(
            label: OnboardingTexts.resultSemantics(code),
            excludeSemantics: true,
            child: Container(
              key: const ValueKey('placement-result'),
              width: 128,
              height: 128,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppPalette.seaBlue50,
                shape: BoxShape.circle,
              ),
              child: Text(
                code,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: AppPalette.seaBlue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s24),
        Text(
          OnboardingTexts.resultBody(code),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpace.s24),
        const InfoCard(
          tone: InfoTone.info,
          icon: Icons.lightbulb_outline_rounded,
          title: OnboardingTexts.resultNoteTitle,
          body: OnboardingTexts.resultNote,
        ),
      ],
      actions: [
        _primary(
          OnboardingTexts.resultContinue,
          () => _go(OnboardingStep.ready),
          key: const ValueKey('onboarding-result-next'),
        ),
      ],
    );
  }

  // ---- hazır

  Widget _ready(BuildContext context) {
    final child = _child;
    return _page(
      children: [
        EmptyState(
          illustration: const Image(
            image: OnboardingScreen.welcomeImage,
            fit: BoxFit.contain,
          ),
          title: OnboardingTexts.readyTitle,
          message: OnboardingTexts.readyBody,
        ),
        InfoCard(
          key: const ValueKey('onboarding-ready-local'),
          icon: Icons.phone_iphone_rounded,
          title: OnboardingTexts.readyLocalTitle,
          // 13 yaş altına hesaptan hiç söz edilmez (H-002).
          body: child
              ? OnboardingTexts.readyLocalChild
              : OnboardingTexts.readyLocalTeen,
        ),
      ],
      actions: [
        // Bildirim izni burada istenmez (H-039): hatırlatma ilk bölümden
        // sonra, kullanıcı saati seçerken sorulur (H-013).
        _primary(
          OnboardingTexts.readyStart,
          () => unawaited(_finish()),
          key: const ValueKey('onboarding-finish'),
        ),
      ],
    );
  }
}

/// Üst satır: geri düğmesi, adım noktaları ve (testte) "Testi bırak".
class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.onBack,
    required this.index,
    required this.count,
    this.trailing,
  });

  final VoidCallback? onBack;
  final int index;
  final int count;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      child: Row(
        children: [
          SizedBox(
            width: AppTouch.min,
            child: onBack == null
                ? null
                : IconButton(
                    key: const ValueKey('onboarding-back'),
                    onPressed: onBack,
                    tooltip: OnboardingTexts.back,
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
          ),
          // Noktalar süstür: dar ekranda ve büyük yazıda küçülür.
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _StepDots(index: index, count: count),
              ),
            ),
          ),
          if (trailing != null)
            Flexible(child: trailing!)
          else
            const SizedBox(width: AppTouch.min),
        ],
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.base);
    return Semantics(
      label: OnboardingTexts.stepLabel(index + 1, count),
      excludeSemantics: true,
      child: SizedBox(
        height: AppTouch.min,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < count; i++)
              AnimatedContainer(
                duration: duration,
                curve: AppMotion.standard,
                margin: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
                width: i == index ? AppSpace.s24 : AppSpace.s8,
                height: AppSpace.s8,
                decoration: BoxDecoration(
                  color: i <= index ? AppPalette.seaBlue : AppPalette.ink200,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Yol açılışa mı ait (`/acilis` ve alt yolları)?
bool isOnboardingPath(String location) {
  final path = Uri.tryParse(location)?.path ?? location;
  return path == AppRoutes.onboarding ||
      path.startsWith('${AppRoutes.onboarding}/');
}

/// Açılış kapısı (go_router `redirect`): açılış bitmeden ya da durum
/// okunurken her yol `/acilis`e gider (gidilmek istenen yer `sonra`
/// parametresinde); bittikten sonra `/acilis` istenen yere ya da Ana
/// Sayfa'ya yönlenir. Debug derlemede `/acilis?yeniden=1` açılışı yeniden
/// gösterir; tasarım vitrini kapıdan muaftır.
String? onboardingRedirect(OnboardingGate gate, Uri uri) {
  final path = uri.path;
  if (kDebugMode && path == AppRoutes.designShowcase) return null;
  final inOnboarding = isOnboardingPath(path);
  if (gate != OnboardingGate.done) {
    if (inOnboarding) return null;
    final target = uri.toString();
    return Uri(
      path: AppRoutes.onboarding,
      queryParameters: path == AppRoutes.home ? null : {'sonra': target},
    ).toString();
  }
  if (!inOnboarding) return null;
  if (kDebugMode && uri.queryParameters['yeniden'] == '1') return null;
  if (path != AppRoutes.onboarding) return null; // ör. metin sayfası
  final next = uri.queryParameters['sonra'];
  return next != null && next.startsWith('/') && !isOnboardingPath(next)
      ? next
      : AppRoutes.home;
}
