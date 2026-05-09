import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/enums/transaction_type.dart';
import '../../../../database/daos/categories_dao.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/i_category_repository.dart';

@LazySingleton(as: ICategoryRepository)
class CategoryRepositoryImpl implements ICategoryRepository {
  final CategoriesDao _dao;

  CategoryRepositoryImpl(this._dao);

  @override
  Stream<List<CategoryEntity>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Stream<List<CategoryEntity>> watchByType(String type) {
    return _dao.watchByType(type).map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<CategoryEntity?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> insert(CategoryEntity category) {
    return _dao.insertCategory(CategoriesCompanion.insert(
      id: category.id,
      name: category.name,
      type: category.type.value,
      icon: Value(category.icon),
      color: Value(category.color),
      sortOrder: Value(category.sortOrder),
      isDefault: Value(category.isDefault ? 1 : 0),
    ));
  }

  @override
  Future<void> update(CategoryEntity category) {
    return _dao.updateCategory(CategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      type: Value(category.type.value),
      icon: Value(category.icon),
      color: Value(category.color),
      sortOrder: Value(category.sortOrder),
    ));
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteCategory(id);
  }

  CategoryEntity _toEntity(Category row) {
    return CategoryEntity(
      id: row.id,
      name: row.name,
      type: TransactionType.fromValue(row.type),
      icon: row.icon,
      color: row.color,
      sortOrder: row.sortOrder,
      isDefault: row.isDefault == 1,
    );
  }
}
