import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'page_header.dart';

/// Henüz gelmeyen sekmeler için yer tutucu (H-053): sekme başlığı, ne
/// geleceğini söyleyen başlık ve tek paragraf açıklama.
class PlaceholderView extends StatelessWidget {
  const PlaceholderView({
    super.key,
    required this.title,
    required this.icon,
    required this.heading,
    required this.message,
  });

  final String title;
  final IconData icon;
  final String heading;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.sm),
          children: [
            PageHeader(title: title),
            const SizedBox(height: AppSpacing.lg),
            Icon(icon, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              heading,
              key: const ValueKey('placeholder-heading'),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
