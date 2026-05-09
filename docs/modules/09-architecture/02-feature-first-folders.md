# Feature-First Folder Structure

Finsight organizes code by **feature** (accounts, transactions, analytics) rather than by **layer** (all entities together, all repositories together). This makes it easy to find everything related to one feature in one place.

## The structure

Each feature has four subdirectories:

```
lib/features/<feature>/
├── domain/
│   ├── entities/
│   │   └── <entity>.dart
│   └── repositories/
│       └── i_<entity>_repository.dart
├── data/
│   └── repositories/
│       └── <entity>_repository_impl.dart
├── presentation/
│   ├── pages/
│   │   └── <feature>_page.dart
│   └── widgets/
│       └── <widget_name>.dart
└── providers/
    └── <feature>_providers.dart
```

## Real example — accounts feature (complete)

```
lib/features/accounts/
├── domain/
│   ├── entities/
│   │   └── account.dart                     ← freezed Account model
│   └── repositories/
│       └── i_account_repository.dart        ← abstract interface
├── data/
│   └── repositories/
│       └── account_repository_impl.dart     ← uses AccountsDao
├── presentation/
│   ├── pages/
│   │   └── accounts_page.dart               ← main page
│   └── widgets/
│       ├── account_card.dart                ← individual account card
│       └── account_list.dart                ← scrollable list of cards
└── providers/
    └── accounts_providers.dart              ← Riverpod providers
```

## Current state of features in Finsight

The features folder currently only has placeholder pages. The full structure needs to be built:

```
lib/features/
├── dashboard/        ← only presentation/pages/dashboard_page.dart
├── transactions/     ← only presentation/pages/transactions_page.dart
├── accounts/         ← only presentation/pages/accounts_page.dart
├── analytics/        ← only presentation/pages/analytics_page.dart
└── settings/         ← only presentation/pages/settings_page.dart
```

## Where shared code lives

Code used by multiple features goes in `lib/core/` (already exists):

```
lib/core/
├── enums/          ← TransactionType, AccountType, etc.
├── constants/      ← AppConstants, CurrencyList
└── utils/          ← Formatters
```

Shared widgets used across features (e.g., a loading indicator, an empty state widget, a currency input field) would go in a `lib/shared/widgets/` directory.

## File naming conventions

From `CLAUDE.md`:
- Pages: `<feature>_page.dart` — `accounts_page.dart`, `dashboard_page.dart`
- Widgets: descriptive — `account_card.dart`, `transaction_tile.dart`
- Providers: `<feature>_providers.dart` — `accounts_providers.dart`
- Entities: singular — `account.dart`, `transaction.dart` (not `accounts.dart`)
- Repository interface: `i_<entity>_repository.dart` — `i_account_repository.dart`
- Repository impl: `<entity>_repository_impl.dart` — `account_repository_impl.dart`

## Why feature-first vs layer-first?

**Layer-first** (the alternative):
```
lib/
├── domain/entities/account.dart
├── domain/entities/transaction.dart
├── data/repositories/account_repository_impl.dart
├── data/repositories/transaction_repository_impl.dart
├── presentation/pages/accounts_page.dart
├── presentation/pages/transactions_page.dart
```

**Feature-first** (what Finsight uses):
```
lib/features/accounts/...
lib/features/transactions/...
```

Feature-first wins for larger apps because:
- Everything for one feature is co-located — you don't jump between distant folders
- You can delete a feature by deleting one folder
- New team members understand one feature without learning the whole codebase
- Layer boundaries are still respected (enforced by import rules, not folder structure)

---

**Next:** [03-dependency-injection.md](03-dependency-injection.md)
