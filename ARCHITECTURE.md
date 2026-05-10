# Finsight — Architecture

## Layered architecture

Each feature follows a strict four-layer hierarchy. Inner layers must not import outer ones.

```
domain/        Pure Dart — NO Flutter, NO Drift, NO get_it imports
               └── entities/      freezed immutable value objects
               └── repositories/  abstract interfaces (I*Repository)

data/          Drift-backed implementations
               └── repositories/  @LazySingleton(as: I*Repository)
                                  wraps DAOs; all balance-changing ops use db.transaction()

providers/     Riverpod 2.x — bridges data → presentation
               └── *_providers.dart   @riverpod annotated functions → generated providers

presentation/  Flutter widgets and pages — consume providers via ref.watch / ref.read
               └── pages/
               └── widgets/
```

Allowed import graph:

- `domain` imports nothing (except `freezed_annotation`, `json_annotation`)
- `data` imports `domain` + `database` DAOs + `injectable`
- `providers` imports `domain` + `data` (the repository interface, not the impl)
- `presentation` imports `providers` + `domain` entities + Flutter

---

## Database & ledger integrity

### Tables (10)

| Table | Purpose |
|---|---|
| `accounts` | Bank accounts, cash wallets, credit cards |
| `transactions` | Individual income / expense / investment entries |
| `transfers` | Between-account movements (two ledger legs each) |
| `ledger_entries` | Double-entry audit trail — source of truth for balances |
| `categories` | Transaction categories (seeded defaults + user-created) |
| `tags` | Free-form labels for transactions |
| `transaction_tags` | Many-to-many join: transaction ↔ tag |
| `user_preferences` | Currency code/symbol, theme mode, app lock flag |
| `budgets` | Per-category spending limits (monthly or yearly period) |
| `goals` | Savings goals with target amount, deadline, and cached progress |

### Ledger rule

`accounts.balance` is a **cache**. The canonical balance is `SUM(ledger_entries)` filtered by account. Every write that touches a balance must:

1. Insert a `LedgerEntry` (debit or credit) in the same `db.transaction()`.
2. Update `accounts.balance`. For credit card debit transactions, also update `accounts.amount_used`.

Violating this produces an inconsistent balance that cannot be recovered without a full ledger replay.

### Credit card accounting

- `accounts.balance` goes negative as expenses are charged (mirrors real credit card debt).
- `accounts.amount_used` tracks outstanding credit — incremented on debit, decremented on reversal, clamped to ≥ 0.
- `totalBalanceProvider` excludes credit card accounts.
- `creditCardLiabilityProvider` sums `amount_used` across all credit card accounts.
- `netWorthProvider = totalBalance − creditCardLiability`.

### Example — expense transaction insert

```dart
await _db.transaction(() async {
  await _transactionsDao.insertTransaction(...);       // row in transactions table
  await _transactionsDao.setTagsForTransaction(...);   // rows in transaction_tags
  await _ledgerDao.insertEntry(... entryType: 'debit', runningBalance: newBalance);
  await _accountsDao.updateBalance(accountId, newBalance);
});
```

### Soft delete

Accounts are never hard-deleted. `accounts.is_active = 0` archives them so historical
ledger entries remain valid. `watchAllActive()` filters to `is_active = 1`.

Default categories (`is_default = 1`) cannot be deleted; the DAO enforces this via
`WHERE is_default = 0`.

---

## Dependency injection

Bootstrap order in `lib/main.dart`:

```dart
await configureDependencies();          // registers everything via get_it
await SeedData.seed(getIt<AppDatabase>());
runApp(ProviderScope(child: FinsightApp()));
```

`lib/core/di/database_module.dart` — `@module abstract class DatabaseModule`:
- `@singleton AppDatabase get appDatabase` — the single SQLite connection.
- Nine `@lazySingleton` DAO accessors (e.g. `AccountsDao accountsDao(AppDatabase db) => db.accountsDao`).

`TransactionLedgerService` (`@lazySingleton`) — shared service injected into both `TransactionRepositoryImpl` and `GoalRepositoryImpl`. Encapsulates all atomic write logic: insert transaction + ledger entry + update `balance` + update `amount_used` (credit cards) + update goal cache. Both repositories call `applyTransaction` / `reverseTransaction` inside `db.transaction()`.

Each repository impl is annotated `@LazySingleton(as: I*Repository)` so get_it resolves
the abstract type everywhere.

Codegen writes `lib/core/di/injection.config.dart` — never edit this file.

---

## State management (Riverpod 2.x)

All providers are generated from `@riverpod` annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Conventions

| Pattern | Example |
|---|---|
| Repository provider | `@riverpod IAccountRepository accountRepository(Ref ref)` |
| Stream provider | `@riverpod Stream<List<AccountEntity>> accounts(Ref ref)` |
| Family provider | `@riverpod Stream<AccountEntity?> accountById(Ref ref, String id)` |
| Derived sync provider | `@riverpod double totalBalance(Ref ref)` — computed from `accountsProvider` |

Family providers are called as `accountByIdProvider('acc-1')` in widgets.

### Provider composition

```
accountsProvider           ─┬─► totalBalanceProvider (non-credit sum)
                             ├─► creditCardLiabilityProvider (sum of amount_used)
                             └─► netWorthProvider (totalBalance − liability)

transactionsProvider       ─┬─► monthlyIncomeProvider / monthlyExpenseProvider
                             ├─► recentTransactionsProvider
                             └─► budgetsWithSpendingProvider (O(M+N) spend map)

budgetsProvider            ─┘

goalsProvider              ─► goal cards + goal detail page
```

`budgetsWithSpendingProvider` is a **sync** provider that watches both `budgetsProvider` and `transactionsProvider`. It builds a `categoryId → spent` map once per period (O(M)) then looks up each budget in O(1), giving O(M+N) total instead of O(M×N).

Riverpod caches and invalidates reactively — no manual `setState` or `notifyListeners`.

---

## Routing

`lib/app/router.dart` uses go_router `StatefulShellRoute.indexedStack` for the 5 bottom
tabs, so each tab preserves its scroll position independently.

```
/dashboard
/transactions
/accounts
/analytics
  /analytics/goals/:id       # GoalDetailPage — contribution history + progress
/settings
  /settings/categories
  /settings/tags
```

Navigation between tabs uses `context.go('/route')`. Navigation to sub-pages uses
`context.push('/settings/categories')` (back button works).

---

## Theming

Material 3 throughout. `lib/app/theme/app_colors.dart` defines semantic colors:

| Constant | Meaning |
|---|---|
| `AppColors.income` | Green — credit transactions |
| `AppColors.expense` | Red — debit transactions |
| `AppColors.investment` | Orange — investment transactions |
| `AppColors.transfer` | Blue-grey — neutral transfers |

`AppColors.fromHex(String hex)` — parses a `#RRGGBB` string to a `Color`. Used everywhere a user-chosen category/goal color is displayed; consolidated from per-file `_parseColor` helpers.

`lib/app/app.dart` watches `themeModeProvider` so the theme switches live without a
restart. `PreferencesEntity.themeMode` is stored as a plain string (`'light'`,
`'dark'`, `'system'`) to keep the domain layer free of Flutter imports; the mapping
to `ThemeMode` enum happens in `settings_providers.dart`.

---

## Code generation

| Annotation | Generator | Output |
|---|---|---|
| `@freezed` | `freezed` | `*.freezed.dart` — immutable value objects, `copyWith`, `==` |
| `@riverpod` | `riverpod_generator` | `*.g.dart` — `*Provider` globals |
| `@LazySingleton` / `@module` | `injectable_generator` | `injection.config.dart` |
| `@DriftAccessor` / table classes | `drift_dev` | `app_database.g.dart`, `*_dao.g.dart` |

Never edit `*.g.dart` or `*.freezed.dart`. Regenerate with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Testing strategy

All repository tests use an in-memory SQLite database:

```dart
// test/helpers/test_database.dart
AppDatabase openTestDatabase() => AppDatabase.forTesting(NativeDatabase.memory());
```

`AppDatabase.forTesting(executor)` is a named constructor that bypasses the
platform-specific file path logic and accepts any `QueryExecutor`.

### Linux test setup

The Dart VM on Linux resolves `DynamicLibrary.open('libsqlite3.so')` — the unversioned
symlink. On most distros only `libsqlite3.so.0` is installed (runtime); the `.so`
symlink requires `libsqlite3-dev`. CI installs the package. Locally, create the symlink
once:

```bash
mkdir -p ~/.local/lib
ln -sf /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 ~/.local/lib/libsqlite3.so
LD_LIBRARY_PATH=$HOME/.local/lib flutter test
```

---

## Cross-cutting rules

- **IDs**: UUID v4, generated client-side (`const Uuid().v4()`).
- **Dates**: stored as `TEXT` in `YYYY-MM-DD` format via `Formatters.todayAsString()`.
- **Soft delete only**: never `DELETE` accounts or ledger entries.
- **No Flutter in domain**: domain entities and repository interfaces import only
  `freezed_annotation` and `json_annotation`. Zero `dart:ui` or `package:flutter`.
- **Single quotes** for all string literals (Dart convention).
- **snake_case** for file names; `PascalCase` for classes; `camelCase` for everything else.
- **Trailing commas** on all multi-line argument lists (enforced by `dart format`).
