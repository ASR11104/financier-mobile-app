import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/tag_entity.dart';
import '../domain/repositories/i_tag_repository.dart';

part 'tags_providers.g.dart';

@riverpod
ITagRepository tagRepository(Ref ref) => getIt<ITagRepository>();

@riverpod
Stream<List<TagEntity>> tags(Ref ref) =>
    ref.watch(tagRepositoryProvider).watchAll();
