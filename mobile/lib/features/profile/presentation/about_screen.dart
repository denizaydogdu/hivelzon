import 'package:flutter/material.dart';

import '../../../app/app_info.dart';
import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';

/// Profil → "Hakkında ve lisanslar" (H-042): sürüm, kaynak atıfları
/// (`docs/LISANS-RAPORU.md` §4) ve Flutter'ın açık kaynak lisansları
/// sayfası. İçerik sabittir: yükleniyor / boş / hata durumu yoktur (hiçbir
/// şey okunmaz, ağ kullanılmaz).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const double maxWidth = 600;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AboutTexts.title)),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey('about-screen'),
          padding: const EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s8,
            AppSpace.page,
            AppSpace.s32,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxWidth),
                child: StaggeredList(
                  spacing: AppSpace.s24,
                  children: [
                    Container(
                      key: const ValueKey('about-app'),
                      padding: const EdgeInsets.all(AppSpace.s16),
                      decoration: const BoxDecoration(
                        color: AppPalette.white,
                        borderRadius: AppRadius.mdAll,
                        boxShadow: AppShadows.level1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              'Hi',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: AppPalette.seaBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpace.s4),
                          Text(
                            AboutTexts.tagline,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppPalette.ink700,
                            ),
                          ),
                          const SizedBox(height: AppSpace.s12),
                          CapsLabel(
                            AboutTexts.version(AppInfo.display),
                            key: const ValueKey('about-version'),
                            tone: CapsTone.blue,
                          ),
                          const SizedBox(height: AppSpace.s4),
                          Text(
                            AboutTexts.maker,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppPalette.ink500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SettingsGroup(
                      key: const ValueKey('about-sources'),
                      title: AboutTexts.sourcesHeading,
                      footer: AboutTexts.sourcesIntro,
                      children: [
                        for (final (i, (title, body))
                            in AboutTexts.sources.indexed)
                          Padding(
                            key: ValueKey('about-source-$i'),
                            padding: const EdgeInsets.all(AppSpace.s16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(title, style: theme.textTheme.titleSmall),
                                const SizedBox(height: AppSpace.s4),
                                Text(
                                  body,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppPalette.ink700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SettingsGroup(
                      children: [
                        SettingsRow(
                          key: const ValueKey('about-licenses'),
                          icon: Icons.description_outlined,
                          title: AboutTexts.licensesButton,
                          subtitle: AboutTexts.licensesHint,
                          onTap: () => showLicensePage(
                            context: context,
                            applicationName: 'Hi',
                            applicationVersion: AppInfo.display,
                            applicationLegalese: AboutTexts.maker,
                          ),
                        ),
                      ],
                    ),
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
