import 'package:flutter/material.dart';

import '../../../l10n/tr_strings.dart';
import '../../../shared/widgets/placeholder_view.dart';

/// Konuşma pratiği MVP'de yok (H-007); sekme "yakında" durumunu gösterir.
class TalkScreen extends StatelessWidget {
  const TalkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: PlaceholderTexts.talkTitle,
      icon: Icons.chat_bubble,
      heading: PlaceholderTexts.talkHeading,
      message: PlaceholderTexts.talkBody,
    );
  }
}
