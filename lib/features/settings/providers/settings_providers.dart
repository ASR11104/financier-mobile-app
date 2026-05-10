import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/preferences_entity.dart';
import '../domain/repositories/i_preferences_repository.dart';

part 'settings_providers.g.dart';

@riverpod
IPreferencesRepository preferencesRepository(Ref ref) =>
    getIt<IPreferencesRepository>();

@riverpod
Stream<PreferencesEntity?> preferences(Ref ref) =>
    ref.watch(preferencesRepositoryProvider).watchPreferences();

@riverpod
ThemeMode themeMode(Ref ref) {
  final prefs = ref.watch(preferencesProvider).valueOrNull;
  return switch (prefs?.themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

/// Whether the app is currently showing the lock screen.
///
/// Set to true on launch (if lock is enabled) and when the app is backgrounded.
/// Set to false by [AppLockScreen] after successful authentication.
final appLockedProvider = StateProvider<bool>((ref) => false);
