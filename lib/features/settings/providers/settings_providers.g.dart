// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$preferencesRepositoryHash() =>
    r'39d1529a832801165ed6590108586ab9f565db7f';

/// See also [preferencesRepository].
@ProviderFor(preferencesRepository)
final preferencesRepositoryProvider =
    AutoDisposeProvider<IPreferencesRepository>.internal(
      preferencesRepository,
      name: r'preferencesRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preferencesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreferencesRepositoryRef =
    AutoDisposeProviderRef<IPreferencesRepository>;
String _$preferencesHash() => r'b0bd587a2a578129471980eb21d648614819027d';

/// See also [preferences].
@ProviderFor(preferences)
final preferencesProvider =
    AutoDisposeStreamProvider<PreferencesEntity?>.internal(
      preferences,
      name: r'preferencesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$preferencesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreferencesRef = AutoDisposeStreamProviderRef<PreferencesEntity?>;
String _$themeModeHash() => r'c60ad4f17d7528f225f57287e447bf612020ebda';

/// See also [themeMode].
@ProviderFor(themeMode)
final themeModeProvider = AutoDisposeProvider<ThemeMode>.internal(
  themeMode,
  name: r'themeModeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThemeModeRef = AutoDisposeProviderRef<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
