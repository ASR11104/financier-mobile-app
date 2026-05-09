import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/app_theme.dart';

/// Root widget for the Finsight app.
class FinsightApp extends ConsumerWidget {
  const FinsightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch theme mode from preferences provider
    return MaterialApp.router(
      title: 'Finsight',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
