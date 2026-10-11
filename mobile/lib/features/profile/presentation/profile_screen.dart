import 'package:flutter/material.dart';

import '../../../shared/widgets/placeholder_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Profil',
      icon: Icons.person,
      message: 'İlerlemen ve ayarların burada olacak.',
    );
  }
}
