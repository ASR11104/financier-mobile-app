import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finsight/core/enums/account_type.dart';
import 'package:finsight/core/utils/formatters.dart';
import 'package:finsight/database/app_database.dart';
import 'package:finsight/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:finsight/features/accounts/domain/entities/account_entity.dart';
import 'package:finsight/features/transfers/data/repositories/transfer_repository_impl.dart';
import 'package:finsight/features/transfers/domain/entities/transfer_entity.dart';

void main() {
  late AppDatabase db;
  late TransferRepositoryImpl transferRepo;
  late AccountRepositoryImpl accountRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    transferRepo = TransferRepositoryImpl(
        db, db.transfersDao, db.accountsDao, db.ledgerDao);
    accountRepo = AccountRepositoryImpl(db.accountsDao);

    await accountRepo.insert(AccountEntity(
      id: 'from-acc',
      name: 'Savings',
      type: AccountType.bankAccount,
      balance: 10000.0,
      icon: 'bank',
      color: '#2196F3',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    ));

    await accountRepo.insert(AccountEntity(
      id: 'to-acc',
      name: 'Wallet',
      type: AccountType.cash,
      balance: 500.0,
      icon: 'wallet',
      color: '#FF9800',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    ));
  });

  tearDown(() => db.close());

  test('transfer debits source and credits destination atomically', () async {
    final transfer = TransferEntity(
      id: 'tr-1',
      fromAccountId: 'from-acc',
      toAccountId: 'to-acc',
      amount: 2000.0,
      date: Formatters.todayAsString(),
    );

    await transferRepo.insert(transfer);

    final fromAccount = await accountRepo.getById('from-acc');
    final toAccount = await accountRepo.getById('to-acc');

    expect(fromAccount?.balance, 8000.0);
    expect(toAccount?.balance, 2500.0);
  });

  test('watchAll returns inserted transfer', () async {
    final transfer = TransferEntity(
      id: 'tr-2',
      fromAccountId: 'from-acc',
      toAccountId: 'to-acc',
      amount: 1000.0,
      date: Formatters.todayAsString(),
    );

    await transferRepo.insert(transfer);

    final transfers = await transferRepo.watchAll().first;
    expect(transfers.any((t) => t.id == 'tr-2'), true);
  });

  test('transfer to credit card decreases amountUsed', () async {
    await accountRepo.insert(AccountEntity(
      id: 'cc-1',
      name: 'Credit Card',
      type: AccountType.creditCard,
      balance: 0.0,
      creditLimit: 50000.0,
      amountUsed: 5000.0,
      icon: 'credit_card',
      color: '#E91E63',
      isActive: true,
      notes: '',
      createdAt: DateTime.now(),
    ));

    final transfer = TransferEntity(
      id: 'tr-3',
      fromAccountId: 'from-acc',
      toAccountId: 'cc-1',
      amount: 2000.0,
      date: Formatters.todayAsString(),
    );

    await transferRepo.insert(transfer);

    final cc = await accountRepo.getById('cc-1');
    expect(cc?.amountUsed, 3000.0);
  });
}
