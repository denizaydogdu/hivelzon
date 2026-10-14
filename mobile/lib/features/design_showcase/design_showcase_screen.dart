import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/ui/ui.dart';
import '../../shared/widgets/page_header.dart';
import 'showcase_hi_section.dart';

// Bileşen vitrini (H-057): yalnız debug derlemede `/tasarim` yolunda açılır,
// uygulamadan bağlantı verilmez. Geliştirici aracıdır; metinleri bu yüzden
// `tr_strings.dart`'ta değil, burada durur.

/// Tasarım sistemi vitrini: belirteçler, düğmeler ve `shared/ui`
/// bileşenleri.
class DesignShowcaseScreen extends StatelessWidget {
  const DesignShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasarım sistemi')),
      body: ListView(
        key: const ValueKey('showcase-list'),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.page,
          AppSpace.s8,
          AppSpace.page,
          AppSpace.s48,
        ),
        children: const [
          ShowcaseHeaderSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseColorsSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseTypeSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseSpacingSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseButtonsSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseCardsSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseSettingsSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseProgressSection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseEmptySection(),
          SizedBox(height: AppSpace.s32),
          ShowcaseHiSection(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SectionHeading(title),
      const SizedBox(height: AppSpace.s12),
      ...children,
    ],
  );
}

/// Şekilli başlıklar (dalga ve çapraz kesim).
class ShowcaseHeaderSection extends StatelessWidget {
  const ShowcaseHeaderSection({super.key});

  @override
  Widget build(BuildContext context) => _Section('Şekilli başlık', [
    ClipRRect(
      borderRadius: AppRadius.mdAll,
      child: ShapedHeader(
        title: 'Merhaba Deniz',
        subtitle: 'Bugün 6 ifade tekrar ettin.',
        leading: Container(
          width: AppSpace.s48,
          height: AppSpace.s48,
          decoration: const BoxDecoration(
            color: AppPalette.lighthouseYellow,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            'D',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppPalette.ink),
          ),
        ),
      ),
    ),
    const SizedBox(height: AppSpace.s16),
    const ClipRRect(
      borderRadius: AppRadius.mdAll,
      child: ShapedHeader(
        title: 'Defter',
        subtitle: 'Kaydettiğin ifadeler burada.',
        shape: HeaderShape.diagonal,
        height: 160,
        color: AppPalette.seaBlue700,
      ),
    ),
  ]);
}

/// Renk belirteçleri.
class ShowcaseColorsSection extends StatelessWidget {
  const ShowcaseColorsSection({super.key});

  static const _colors = <(String, Color)>[
    ('seaBlue50', AppPalette.seaBlue50),
    ('seaBlue100', AppPalette.seaBlue100),
    ('seaBlue300', AppPalette.seaBlue300),
    ('seaBlue', AppPalette.seaBlue),
    ('seaBlue700', AppPalette.seaBlue700),
    ('seaBlue900', AppPalette.seaBlue900),
    ('yellow50', AppPalette.yellow50),
    ('yellow100', AppPalette.yellow100),
    ('yellow200', AppPalette.yellow200),
    ('lighthouseYellow', AppPalette.lighthouseYellow),
    ('yellow700', AppPalette.yellow700),
    ('sand50', AppPalette.sand50),
    ('sand', AppPalette.sand),
    ('sand200', AppPalette.sand200),
    ('sand300', AppPalette.sand300),
    ('sand500', AppPalette.sand500),
    ('orange50', AppPalette.orange50),
    ('orange100', AppPalette.orange100),
    ('eveningOrange', AppPalette.eveningOrange),
    ('orange700', AppPalette.orange700),
    ('ink', AppPalette.ink),
    ('ink700', AppPalette.ink700),
    ('ink500', AppPalette.ink500),
    ('ink300', AppPalette.ink300),
    ('ink200', AppPalette.ink200),
    ('ink100', AppPalette.ink100),
    ('success', AppPalette.success),
    ('successSurface', AppPalette.successSurface),
    ('warning', AppPalette.warning),
    ('warningSurface', AppPalette.warningSurface),
    ('danger', AppPalette.danger),
    ('dangerSurface', AppPalette.dangerSurface),
  ];

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium;
    return _Section('Renkler', [
      Wrap(
        spacing: AppSpace.s8,
        runSpacing: AppSpace.s8,
        children: [
          for (final (name, color) in _colors)
            Container(
              width: 104,
              height: 56,
              padding: const EdgeInsets.all(AppSpace.s8),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppRadius.smAll,
                border: Border.all(color: AppPalette.ink100),
              ),
              child: Text(
                name,
                style: style?.copyWith(
                  color: color.computeLuminance() > 0.35
                      ? AppPalette.ink
                      : AppPalette.white,
                ),
              ),
            ),
        ],
      ),
    ]);
  }
}

/// Yazı ölçeği (Nunito başlık, Inter metin).
class ShowcaseTypeSection extends StatelessWidget {
  const ShowcaseTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final rows = <(String, TextStyle?)>[
      ('headlineMedium · Nunito 700', t.headlineMedium),
      ('headlineSmall · Nunito 700', t.headlineSmall),
      ('titleLarge · Nunito 700', t.titleLarge),
      ('titleMedium · Nunito 700', t.titleMedium),
      ('bodyLarge · Inter 400', t.bodyLarge),
      ('bodyMedium · Inter 400', t.bodyMedium),
      ('bodySmall · Inter 400', t.bodySmall),
      ('labelLarge · Inter 500', t.labelLarge),
      ('labelMedium · Inter 500', t.labelMedium),
    ];
    return _Section('Yazı ölçeği', [
      for (final (name, style) in rows)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: t.labelMedium?.copyWith(color: AppPalette.ink500),
              ),
              Text('Çığlık öğrenci şöyle: İzmir’de ağaç', style: style),
            ],
          ),
        ),
      const SizedBox(height: AppSpace.s8),
      const CapsLabel('Sezon 1 · Bölüm 2'),
      const SizedBox(height: AppSpace.s8),
      const CapsLabel('Açık soru · ipucu', tone: CapsTone.blue),
    ]);
  }
}

/// Boşluk, köşe ve gölge ölçekleri.
class ShowcaseSpacingSection extends StatelessWidget {
  const ShowcaseSpacingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final label = Theme.of(context).textTheme.labelMedium;
    const spaces = [
      AppSpace.s4,
      AppSpace.s8,
      AppSpace.s12,
      AppSpace.s16,
      AppSpace.s24,
      AppSpace.s32,
      AppSpace.s48,
      AppSpace.s64,
    ];
    const radii = [
      ('8', AppRadius.smAll),
      ('12', AppRadius.mdAll),
      ('20', AppRadius.lgAll),
    ];
    const shadows = [
      ('1', AppShadows.level1),
      ('2', AppShadows.level2),
      ('3', AppShadows.level3),
    ];
    return _Section('Boşluk, köşe, gölge', [
      for (final s in spaces)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpace.s4),
          child: Row(
            children: [
              SizedBox(
                width: AppSpace.s32,
                child: Text('${s.round()}', style: label),
              ),
              Container(
                width: s,
                height: AppSpace.s12,
                color: AppPalette.seaBlue300,
              ),
            ],
          ),
        ),
      const SizedBox(height: AppSpace.s16),
      Row(
        children: [
          for (final (name, r) in radii) ...[
            Container(
              width: 72,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppPalette.seaBlue100,
                borderRadius: r,
              ),
              child: Text(name, style: label),
            ),
            const SizedBox(width: AppSpace.s12),
          ],
          Container(
            width: 72,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppPalette.seaBlue100,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text('tam', style: label),
          ),
        ],
      ),
      const SizedBox(height: AppSpace.s24),
      Row(
        children: [
          for (final (name, s) in shadows) ...[
            Expanded(
              child: Container(
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppPalette.white,
                  borderRadius: AppRadius.mdAll,
                  boxShadow: s,
                ),
                child: Text('Gölge $name', style: label),
              ),
            ),
            if (name != '3') const SizedBox(width: AppSpace.s16),
          ],
        ],
      ),
    ]);
  }
}

/// Düğme varyantları.
class ShowcaseButtonsSection extends StatelessWidget {
  const ShowcaseButtonsSection({super.key});

  @override
  Widget build(BuildContext context) => _Section('Düğmeler', [
    FilledButton(onPressed: () {}, child: const Text('Hikâyeye devam')),
    const SizedBox(height: AppSpace.s12),
    FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.play_arrow_rounded),
      label: const Text('Bölümü başlat'),
    ),
    const SizedBox(height: AppSpace.s12),
    OutlinedButton(onPressed: () {}, child: const Text('Defteri aç')),
    const SizedBox(height: AppSpace.s12),
    TextButton(onPressed: () {}, child: const Text('Şimdi değil')),
    const SizedBox(height: AppSpace.s12),
    OutlinedButton(
      onPressed: () {},
      style: AppButtonStyles.danger(),
      child: const Text('Hesabımı sil'),
    ),
    const SizedBox(height: AppSpace.s12),
    FilledButton(
      onPressed: () {},
      style: AppButtonStyles.dangerFilled(),
      child: const Text('Sil'),
    ),
    const SizedBox(height: AppSpace.s12),
    Center(
      child: DontKnowButton(
        label: 'Bilmiyorum',
        onPressed: () {},
        minimumSize: const Size(220, 48),
      ),
    ),
    const SizedBox(height: AppSpace.s12),
    const FilledButton(onPressed: null, child: Text('Devre dışı')),
  ]);
}

/// Kartlar: bilgi kartı tonları ve dokunulabilir kart.
class ShowcaseCardsSection extends StatelessWidget {
  const ShowcaseCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return _Section('Kartlar', [
      StaggeredList(
        spacing: AppSpace.s12,
        children: [
          TappableCard(
            elevated: true,
            onTap: () {},
            child: Row(
              children: [
                const Icon(
                  Icons.auto_stories_rounded,
                  color: AppPalette.seaBlue,
                ),
                const SizedBox(width: AppSpace.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CapsLabel('Bölüm 3'),
                      Text('Haritadaki işaret', style: t.titleMedium),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppPalette.ink300,
                ),
              ],
            ),
          ),
          const InfoCard(
            title: 'İlerlemen yalnızca bu telefonda',
            body: 'Kaybolmasın istersen hesap aç.',
          ),
          const InfoCard(
            tone: InfoTone.info,
            title: 'İpucu',
            body: 'Telsizdeki ses Alex’in adını söylüyor.',
          ),
          const InfoCard(
            tone: InfoTone.success,
            title: 'Verilerin eşitlendi',
            body: 'Bu telefondaki ilerlemen artık hesabında da.',
          ),
          const InfoCard(
            tone: InfoTone.warning,
            title: 'Şu an eşitlenemedi',
            body: 'Bağlantı gelince kendiliğinden eşitlenir.',
          ),
          InfoCard(
            tone: InfoTone.danger,
            title: 'Hesabın silinmek üzere',
            body: '30 gün içinde geri alabilirsin.',
            action: OutlinedButton(
              onPressed: () {},
              child: const Text('Hesabımı geri al'),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => showAppSheet<void>(
              context: context,
              title: 'Alt panel',
              builder: (context) => const Text(
                'AppSheet: tutamaç, başlık, Kapat düğmesi ve içerik.',
              ),
            ),
            icon: const Icon(Icons.expand_less_rounded),
            label: const Text('Alt paneli aç'),
          ),
        ],
      ),
    ]);
  }
}

/// Ayar grubu ve satırları.
class ShowcaseSettingsSection extends StatefulWidget {
  const ShowcaseSettingsSection({super.key});

  @override
  State<ShowcaseSettingsSection> createState() =>
      _ShowcaseSettingsSectionState();
}

class _ShowcaseSettingsSectionState extends State<ShowcaseSettingsSection> {
  bool _speak = true;

  @override
  Widget build(BuildContext context) => _Section('Ayarlar', [
    SettingsGroup(
      title: 'Öğrenme',
      footer: 'Ses cihazdan çıkmaz, kaydedilmez.',
      children: [
        SettingsRow(
          icon: Icons.menu_book_rounded,
          title: 'Defter',
          subtitle: 'İfadeler, ipuçları, konu setleri',
          onTap: () {},
        ),
        SettingsRow(
          icon: Icons.flag_rounded,
          title: 'Günlük hedef',
          value: '10 dk',
          onTap: () {},
        ),
        SettingsRow.toggle(
          icon: Icons.mic_none_rounded,
          title: 'Söyle alıştırmaları',
          subtitle: 'Cihazda konuşma tanıma',
          value: _speak,
          onChanged: (v) => setState(() => _speak = v),
        ),
      ],
    ),
    const SizedBox(height: AppSpace.s24),
    SettingsGroup(
      title: 'Tehlikeli bölge',
      children: [
        SettingsRow(
          icon: Icons.delete_outline_rounded,
          title: 'Hesabımı sil',
          destructive: true,
          onTap: () {},
        ),
      ],
    ),
  ]);
}

/// İstatistik ve dolan halka.
class ShowcaseProgressSection extends StatelessWidget {
  const ShowcaseProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return _Section('İlerleme', [
      const StatRow(
        tiles: [
          StatTile(value: '42', label: 'ifade', icon: Icons.bookmark_rounded),
          StatTile(
            value: '3',
            label: 'bölüm',
            icon: Icons.auto_stories_rounded,
            color: AppPalette.orange700,
          ),
          StatTile(
            value: '18',
            label: 'bu hafta tekrar',
            icon: Icons.replay_rounded,
            color: AppPalette.success,
          ),
        ],
      ),
      const SizedBox(height: AppSpace.s24),
      Row(
        children: [
          ProgressRing(
            value: 0.6,
            semanticLabel: 'Günlük hedef: 6 / 10 dk',
            child: Text('6/10', style: t.titleMedium),
          ),
          const SizedBox(width: AppSpace.s16),
          const ProgressRing(
            value: 1,
            size: 48,
            strokeWidth: 6,
            color: AppPalette.success,
            semanticLabel: 'Konu seti tamam',
            child: Icon(Icons.check_rounded, color: AppPalette.success),
          ),
          const SizedBox(width: AppSpace.s16),
          const ProgressRing(
            value: 0.25,
            size: 48,
            strokeWidth: 6,
            color: AppPalette.seaBlue,
            trackColor: AppPalette.seaBlue100,
            semanticLabel: 'Sezon: 3 / 12 bölüm',
          ),
        ],
      ),
    ]);
  }
}

/// Boş durum.
class ShowcaseEmptySection extends StatelessWidget {
  const ShowcaseEmptySection({super.key});

  @override
  Widget build(BuildContext context) => _Section('Boş durum', [
    DecoratedBox(
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      child: EmptyState(
        icon: Icons.bookmark_border_rounded,
        title: 'Defterin henüz boş',
        message: 'Bölüm izlerken bir ifadeye dokun, buraya kaydolsun.',
        action: FilledButton(
          onPressed: () {},
          child: const Text('Hikâyeye git'),
        ),
      ),
    ),
  ]);
}
