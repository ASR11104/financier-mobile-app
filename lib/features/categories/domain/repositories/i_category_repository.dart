import '../entities/category_entity.dart';

abstract class ICategoryRepository {
  Stream<List<CategoryEntity>> watchAll();
  Stream<List<CategoryEntity>> watchByType(String type);
  Future<CategoryEntity?> getById(String id);
  Future<void> insert(CategoryEntity category);
  Future<void> update(CategoryEntity category);
  Future<void> delete(String id);
}
