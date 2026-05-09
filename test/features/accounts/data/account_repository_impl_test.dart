import 'package:flutter_test/flutter_test.dart';
import 'package:finsight/core/enums/account_type.dart';
import 'package:finsight/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finsight/features/accounts/domain/entities/account_entity.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AccountRepositoryImpl repo;

  setUp(() {
    final db = openTestDatabase();
    repo = AccountRepositoryImpl(db.accountsDao);
  });

  test('insert and watchAllActive emits account', () async {
    final account = AccountEntity(
      id: 'acc-1',
      name: 'Test Savings',
      type: AccountType.bankAccount,
      balance: 1000.0,
      icon: 'bank',
      color: '#2196F3',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    );

    await repo.insert(account);

    final accounts = await repo.watchAllActive().first;
    expect(accounts.length, 1);
    expect(accounts.first.id, 'acc-1');
    expect(accounts.first.name, 'Test Savings');
    expect(accounts.first.balance, 1000.0);
  });

  test('updateBalance updates the account balance', () async {
    final account = AccountEntity(
      id: 'acc-2',
      name: 'Wallet',
      type: AccountType.cash,
      balance: 500.0,
      icon: 'wallet',
      color: '#FF9800',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    );

    await repo.insert(account);
    await repo.updateBalance('acc-2', 750.0);

    final updated = await repo.getById('acc-2');
    expect(updated?.balance, 750.0);
  });

  test('archive removes account from watchAllActive', () async {
    final account = AccountEntity(
      id: 'acc-3',
      name: 'Old Account',
      type: AccountType.bankAccount,
      balance: 0.0,
      icon: 'bank',
      color: '#2196F3',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    );

    await repo.insert(account);
    await repo.archive('acc-3');

    final accounts = await repo.watchAllActive().first;
    expect(accounts.where((a) => a.id == 'acc-3').isEmpty, true);
  });

  test('credit card account stores creditLimit and amountUsed', () async {
    final account = AccountEntity(
      id: 'cc-1',
      name: 'Credit Card',
      type: AccountType.creditCard,
      balance: 0.0,
      creditLimit: 50000.0,
      amountUsed: 0.0,
      icon: 'credit_card',
      color: '#E91E63',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    );

    await repo.insert(account);
    final fetched = await repo.getById('cc-1');

    expect(fetched?.creditLimit, 50000.0);
    expect(fetched?.amountUsed, 0.0);
  });
}
