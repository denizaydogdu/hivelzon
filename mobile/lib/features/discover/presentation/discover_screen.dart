import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_view.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Keşfet',
      icon: Icons.explore,
      message: 'Kısa klipler burada akacak.',
    );
  }
}
