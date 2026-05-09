import 'package:flutter_test/flutter_test.dart';
import 'package:finsight/core/enums/transaction_type.dart';
import 'package:finsight/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finsight/features/categories/domain/entities/category_entity.dart';

import '../../../helpers/test_database.dart';

void main() {
  late CategoryRepositoryImpl repo;

  setUp(() {
    final db = openTestDatabase();
    repo = CategoryRepositoryImpl(db.categoriesDao);
  });

  CategoryEntity _makeCategory({
    String id = 'cat-1',
    String name = 'Food',
    TransactionType type = TransactionType.expense,
    bool isDefault = false,
  }) {
    return CategoryEntity(
      id: id,
      name: name,
      type: type,
      icon: 'restaurant',
      color: '#FF5722',
      sortOrder: 0,
      isDefault: isDefault,
    );
  }

  test('insert and watchAll emits category', () async {
    await repo.insert(_makeCategory());

    final cats = await repo.watchAll().first;
    expect(cats.any((c) => c.id == 'cat-1'), true);
  });

  test('watchByType filters by type', () async {
    await repo.insert(_makeCategory(id: 'exp-1', type: TransactionType.expense));
    await repo.insert(_makeCategory(
        id: 'inc-1', name: 'Salary', type: TransactionType.income));

    final expenseCats =
        await repo.watchByType(TransactionType.expense.value).first;
    expect(expenseCats.every((c) => c.type == TransactionType.expense), true);

    final incomeCats =
        await repo.watchByType(TransactionType.income.value).first;
    expect(incomeCats.every((c) => c.type == TransactionType.income), true);
  });

  test('delete removes user-created category', () async {
    await repo.insert(_makeCategory(id: 'del-1'));
    await repo.delete('del-1');

    final cats = await repo.watchAll().first;
    expect(cats.any((c) => c.id == 'del-1'), false);
  });

  test('delete does not remove default category', () async {
    await repo.insert(_makeCategory(id: 'def-1', isDefault: true));
    await repo.delete('def-1');

    final cats = await repo.watchAll().first;
    expect(cats.any((c) => c.id == 'def-1'), true);
  });
}
