import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../domain/entities/category_entity.dart';
import '../domain/repositories/i_category_repository.dart';

part 'categories_providers.g.dart';

@riverpod
ICategoryRepository categoryRepository(Ref ref) =>
    getIt<ICategoryRepository>();

@riverpod
Stream<List<CategoryEntity>> categories(Ref ref) =>
    ref.watch(categoryRepositoryProvider).watchAll();

@riverpod
Stream<List<CategoryEntity>> categoriesByType(Ref ref, String type) =>
    ref.watch(categoryRepositoryProvider).watchByType(type);

@riverpod
Future<CategoryEntity?> categoryById(Ref ref, String id) =>
    ref.watch(categoryRepositoryProvider).getById(id);
