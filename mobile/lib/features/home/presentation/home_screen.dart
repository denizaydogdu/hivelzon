import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Ana Sayfa',
      icon: Icons.home,
      message: 'Bugünkü öğrenme adımın burada görünecek.',
    );
  }
}
