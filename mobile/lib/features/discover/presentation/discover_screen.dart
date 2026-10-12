import 'package:flutter/material.dart';

import '../../../l10n/tr_strings.dart';
import '../../../shared/widgets/placeholder_view.dart';

/// Keşfet: kısa klip akışı sonra gelir (K-15); şimdilik ne geleceğini söyler.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: PlaceholderTexts.discoverTitle,
      icon: Icons.explore,
      heading: PlaceholderTexts.discoverHeading,
      message: PlaceholderTexts.discoverBody,
    );
  }
}
