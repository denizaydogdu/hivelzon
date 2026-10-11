import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_view.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Hikâye',
      icon: Icons.auto_stories,
      message: 'The Missing Signal: Sezon 1 haritası burada açılacak.',
    );
  }
}
