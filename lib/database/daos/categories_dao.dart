import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';

part 'categories_dao.g.dart';

/// Data Access Object for the [Categories] table.
@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  /// Watch all categories, ordered by sort order.
  Stream<List<Category>> watchAll() {
    return (select(categories)
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch();
  }

  /// Watch categories filtered by type (expense, income, investment).
  Stream<List<Category>> watchByType(String type) {
    return (select(categories)
          ..where((c) => c.type.equals(type))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch();
  }

  /// Get categories filtered by type.
  Future<List<Category>> getByType(String type) {
    return (select(categories)
          ..where((c) => c.type.equals(type))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }

  /// Get a single category by ID.
  Future<Category?> getById(String id) {
    return (select(categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert a new category.
  Future<void> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  /// Update an existing category.
  Future<void> updateCategory(CategoriesCompanion category) {
    return (update(categories)..where((c) => c.id.equals(category.id.value)))
        .write(category);
  }

  /// Delete a user-created category (cannot delete defaults).
  Future<int> deleteCategory(String id) {
    return (delete(categories)
          ..where((c) => c.id.equals(id) & c.isDefault.equals(0)))
        .go();
  }
}
