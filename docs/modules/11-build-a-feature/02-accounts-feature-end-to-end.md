# Accounts Feature — End-to-End

This is a complete walkthrough of implementing the Accounts feature following the architecture. By the end, `AccountsPage` shows real data from the SQLite database.

## Overview of what we're building

```
AccountsDao (already exists)
    ↓ wrapped by
AccountRepositoryImpl : IAccountRepository
    ↓ accessed via
accountsProvider (StreamProvider)
    ↓ read by
AccountsPage (ConsumerWidget)
    ↓ renders
AccountCard widgets
```

---

## Step 1 — Domain entity

Create `lib/features/accounts/domain/entities/account.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/account_type.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    required double balance,
    double? creditLimit,
    double? amountUsed,
    required String icon,
    required String color,
    required bool isActive,
    required DateTime createdAt,
  }) = _Account;
}
```

Run `build_runner` to generate `account.freezed.dart`.

---

## Step 2 — Repository interface

Create `lib/features/accounts/domain/repositories/i_account_repository.dart`:

```dart
import '../entities/account.dart';

abstract class IAccountRepository {
  Stream<List<Account>> watchAll();
  Future<Account?> getById(String id);
  Future<void> save(AccountFormData data);
  Future<void> archive(String id);
}
```

This is pure Dart — no Drift, no Flutter imports.

---

## Step 3 — Database provider

Before the repository can be created, we need a provider for the database. Add to `lib/database/database_providers.dart` (create this file):

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

// Overridden in main.dart with the real AppDatabase instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('appDatabaseProvider not overridden');
});

final accountsDaoProvider = Provider((ref) {
  return ref.watch(appDatabaseProvider).accountsDao;
});
```

Update `main.dart` to override the provider:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await SeedData.seed(db);

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const FinsightApp(),
    ),
  );
}
```

---

## Step 4 — Repository implementation

Create `lib/features/accounts/data/repositories/account_repository_impl.dart`:

```dart
import 'package:uuid/uuid.dart';
import '../../../../database/daos/accounts_dao.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/i_account_repository.dart';
import '../../../../core/enums/account_type.dart';

class AccountRepositoryImpl implements IAccountRepository {
  final AccountsDao _dao;
  AccountRepositoryImpl(this._dao);

  @override
  Stream<List<Account>> watchAll() {
    return _dao.watchAllActive().map(
      (rows) => rows.map(_fromRow).toList(),
    );
  }

  @override
  Future<Account?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _fromRow(row);
  }

  @override
  Future<void> archive(String id) => _dao.archiveAccount(id);

  Account _fromRow(AccountRow row) => Account(
    id: row.id,
    name: row.name,
    type: AccountType.fromValue(row.type),
    balance: row.balance,
    creditLimit: row.creditLimit,
    amountUsed: row.amountUsed,
    icon: row.icon,
    color: row.color,
    isActive: row.isActive == 1,
    createdAt: row.createdAt,
  );
}
```

---

## Step 5 — Providers

Create `lib/features/accounts/providers/accounts_providers.dart`:

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database_providers.dart';
import '../data/repositories/account_repository_impl.dart';
import '../domain/entities/account.dart';
import '../domain/repositories/i_account_repository.dart';

part 'accounts_providers.g.dart';

final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  final dao = ref.watch(accountsDaoProvider);
  return AccountRepositoryImpl(dao);
});

@riverpod
Stream<List<Account>> accounts(Ref ref) {
  return ref.watch(accountRepositoryProvider).watchAll();
}
```

Run `build_runner` to generate `accounts_providers.g.dart`.

---

## Step 6 — Account card widget

Create `lib/features/accounts/presentation/widgets/account_card.dart`:

```dart
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/enums/account_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({required this.account, super.key});

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(account.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Colored account type indicator
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Account info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(account.type.label,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6))),
                ],
              ),
            ),
            // Balance
            Text(
              Formatters.formatAmount(account.balance, '₹'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: account.balance >= 0
                    ? AppColors.income
                    : AppColors.expense,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForType(AccountType type) => switch (type) {
    AccountType.bankAccount => AppColors.bankAccount,
    AccountType.creditCard  => AppColors.creditCard,
    AccountType.cash        => AppColors.cash,
    AccountType.wallet      => AppColors.wallet,
  };
}
```

---

## Step 7 — Update AccountsPage

Replace `lib/features/accounts/presentation/pages/accounts_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/accounts_providers.dart';
import '../widgets/account_card.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Account coming soon!')),
              );
            },
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) => accounts.isEmpty
            ? const _EmptyState()
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: accounts.length,
                itemBuilder: (ctx, i) => AccountCard(account: accounts[i]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text('No Accounts Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Add your bank accounts, credit cards, or cash',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}
```

---

## Step 8 — Run and test

```bash
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Navigate to the Accounts tab. You should see:
- The empty state (since no accounts have been added yet)
- No errors or crashes

To verify the data flow works: use a database browser (like SQLite Browser or the Drift Inspector in DevTools) to manually insert an account row. The accounts list should update automatically (no restart needed) thanks to the `StreamProvider` + `.watch()` combination.

---

## What you just built

- **Domain layer**: `Account` (freezed entity) + `IAccountRepository` (interface)
- **Data layer**: `AccountRepositoryImpl` (maps Drift rows to domain entities)
- **Providers**: `accountRepositoryProvider` + `accountsProvider` (StreamProvider)
- **Presentation**: `AccountCard` (widget) + updated `AccountsPage` (ConsumerWidget)
- **Infrastructure**: `database_providers.dart` + updated `main.dart`

This is the complete pattern for every feature in Finsight. Transactions, transfers, analytics — all follow the same structure.
