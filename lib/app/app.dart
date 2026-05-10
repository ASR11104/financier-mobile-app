import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/widgets/app_lock_screen.dart';
import '../features/settings/providers/settings_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root widget for the Finsight app.
class FinsightApp extends ConsumerStatefulWidget {
  const FinsightApp({super.key});

  @override
  ConsumerState<FinsightApp> createState() => _FinsightAppState();
}

class _FinsightAppState extends ConsumerState<FinsightApp>
    with WidgetsBindingObserver {
  bool _initialLockChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      final prefs = ref.read(preferencesProvider).valueOrNull;
      if (prefs?.isLockEnabled == true) {
        ref.read(appLockedProvider.notifier).state = true;
        _initialLockChecked = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(preferencesProvider, (_, next) {
      if (!_initialLockChecked) {
        _initialLockChecked = true;
        if (next.valueOrNull?.isLockEnabled == true) {
          ref.read(appLockedProvider.notifier).state = true;
        }
      }
    });

    final themeMode = ref.watch(themeModeProvider);
    final isLocked = ref.watch(appLockedProvider);

    return MaterialApp.router(
      title: 'Finsight',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        if (isLocked) return const AppLockScreen();
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
