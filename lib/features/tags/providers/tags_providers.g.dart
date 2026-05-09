// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tagRepositoryHash() => r'603006758201e6108e4ab0fcf99fd07733ae3636';

/// See also [tagRepository].
@ProviderFor(tagRepository)
final tagRepositoryProvider = AutoDisposeProvider<ITagRepository>.internal(
  tagRepository,
  name: r'tagRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagRepositoryRef = AutoDisposeProviderRef<ITagRepository>;
String _$tagsHash() => r'4fdb366f97525ab1a5306aafb27dbde012b53362';

/// See also [tags].
@ProviderFor(tags)
final tagsProvider = AutoDisposeStreamProvider<List<TagEntity>>.internal(
  tags,
  name: r'tagsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TagsRef = AutoDisposeStreamProviderRef<List<TagEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
