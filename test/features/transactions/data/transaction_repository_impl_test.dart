import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finsight/core/enums/account_type.dart';
import 'package:finsight/core/enums/transaction_type.dart';
import 'package:finsight/database/app_database.dart';
import 'package:finsight/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finsight/features/accounts/domain/entities/account_entity.dart';
import 'package:finsight/features/categories/data/repositories/category_repository_impl.dart';
import 'package:finsight/features/categories/domain/entities/category_entity.dart';
import 'package:finsight/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:finsight/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finsight/core/utils/formatters.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl txnRepo;
  late AccountRepositoryImpl accountRepo;
  late CategoryRepositoryImpl categoryRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    txnRepo = TransactionRepositoryImpl(
        db, db.transactionsDao, db.ledgerDao, db.accountsDao);
    accountRepo = AccountRepositoryImpl(db.accountsDao);
    categoryRepo = CategoryRepositoryImpl(db.categoriesDao);

    await accountRepo.insert(AccountEntity(
      id: 'acc-1',
      name: 'Savings',
      type: AccountType.bankAccount,
      balance: 10000.0,
      icon: 'bank',
      color: '#2196F3',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    ));

    await categoryRepo.insert(CategoryEntity(
      id: 'cat-1',
      name: 'Food',
      type: TransactionType.expense,
      icon: 'restaurant',
      color: '#FF5722',
      sortOrder: 0,
      isDefault: false,
    ));
  });

  tearDown(() => db.close());

  test('insert expense reduces account balance', () async {
    final txn = TransactionEntity(
      id: 'txn-1',
      type: TransactionType.expense,
      amount: 500.0,
      accountId: 'acc-1',
      categoryId: 'cat-1',
      date: Formatters.todayAsString(),
      description: 'Lunch',
    );

    await txnRepo.insert(txn);

    final account = await accountRepo.getById('acc-1');
    expect(account?.balance, 9500.0);
  });

  test('insert income increases account balance', () async {
    await categoryRepo.insert(CategoryEntity(
      id: 'cat-inc',
      name: 'Salary',
      type: TransactionType.income,
      icon: 'payments',
      color: '#4CAF50',
      sortOrder: 0,
      isDefault: false,
    ));

    final txn = TransactionEntity(
      id: 'txn-2',
      type: TransactionType.income,
      amount: 5000.0,
      accountId: 'acc-1',
      categoryId: 'cat-inc',
      date: Formatters.todayAsString(),
    );

    await txnRepo.insert(txn);

    final account = await accountRepo.getById('acc-1');
    expect(account?.balance, 15000.0);
  });

  test('watchAll returns inserted transaction', () async {
    final txn = TransactionEntity(
      id: 'txn-3',
      type: TransactionType.expense,
      amount: 200.0,
      accountId: 'acc-1',
      categoryId: 'cat-1',
      date: Formatters.todayAsString(),
    );

    await txnRepo.insert(txn);

    final txns = await txnRepo.watchAll().first;
    expect(txns.any((t) => t.id == 'txn-3'), true);
  });

  test('delete reverses account balance and removes transaction', () async {
    final txn = TransactionEntity(
      id: 'txn-4',
      type: TransactionType.expense,
      amount: 1000.0,
      accountId: 'acc-1',
      categoryId: 'cat-1',
      date: Formatters.todayAsString(),
    );

    await txnRepo.insert(txn);
    expect((await accountRepo.getById('acc-1'))?.balance, 9000.0);

    await txnRepo.delete('txn-4');
    expect((await accountRepo.getById('acc-1'))?.balance, 10000.0);

    final txns = await txnRepo.watchAll().first;
    expect(txns.any((t) => t.id == 'txn-4'), false);
  });
}
