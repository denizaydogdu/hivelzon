import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_view.dart';

/// Konuşma pratiği MVP'de yok (H-007); sekme "Yakında" durumunu gösterir.
class TalkScreen extends StatelessWidget {
  const TalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Konuş',
      icon: Icons.chat_bubble,
      message:
          'Yakında\nKarakterlerle konuşma pratiği sonraki sürümde geliyor.',
    );
  }
}
