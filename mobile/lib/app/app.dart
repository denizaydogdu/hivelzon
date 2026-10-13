import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/account/application/account_providers.dart';
import 'router.dart';
import 'theme.dart';

class HiVelzonApp extends ConsumerWidget {
  const HiVelzonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // H-038: hesap açıksa eşitleme zamanlayıcısı (hesap yoksa hiçbir şey yapmaz).
    ref.watch(syncControllerProvider);
    return MaterialApp.router(
      title: 'hiVelzon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      // Arayüz Türkçe (H-053): Material'ın kendi metinleri ve ekran okuyucu
      // etiketleri de ("Geri", "Kapat", "Sekme 1/5") Türkçe olur.
      locale: const Locale('tr'),
      supportedLocales: const [Locale('tr')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
