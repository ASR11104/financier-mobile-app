# Clean Architecture

Clean Architecture organizes code into layers with strict rules about which direction dependencies can point. The goal is that the core business logic (domain) has no dependencies on external details (databases, frameworks, UI).

## The layers

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │  ← Flutter widgets, pages
│         (lib/features/*/presentation)   │
└───────────────────┬─────────────────────┘
                    │ watches
┌───────────────────▼─────────────────────┐
│             Providers Layer             │  ← Riverpod providers
│           (lib/features/*/providers)    │
└───────────────────┬─────────────────────┘
                    │ calls
┌───────────────────▼─────────────────────┐
│              Domain Layer               │  ← Pure Dart: entities, interfaces
│           (lib/features/*/domain)       │
└──────────────┬──────────────────────────┘
               │ implemented by
┌──────────────▼──────────────────────────┐
│               Data Layer                │  ← Drift DAOs, repository impls
│            (lib/features/*/data)        │
└─────────────────────────────────────────┘
```

## The dependency rule

Dependencies only point **inward** (toward the domain). The domain layer knows nothing about any other layer.

- **Presentation** depends on Providers
- **Providers** depend on Domain (interfaces)
- **Data** depends on Domain (implements the interfaces)
- **Domain** depends on nothing (pure Dart only)

This means:
- You can test domain logic without a database, without Flutter
- You can swap SQLite for an API by writing a new Data layer — the domain and presentation layers don't change
- You can change the UI framework without rewriting business logic

## Domain layer — the heart

The domain layer is the most important and most stable. It changes least often.

**What goes here:**
- **Entities**: Pure Dart data models using `freezed` (no Flutter, no Drift)
- **Repository interfaces**: Abstract contracts for data access

```dart
// domain/entities/account.dart
@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    required double balance,
  }) = _Account;
}
```

```dart
// domain/repositories/i_account_repository.dart
abstract class IAccountRepository {
  Stream<List<Account>> watchAll();
  Future<Account?> getById(String id);
  Future<void> save(Account account);
  Future<void> archive(String id);
}
```

**Rule**: No `import 'package:flutter/...'`, no `import 'package:drift/...'` here. Only `package:freezed_annotation`.

## Data layer — talks to the database

Implements the domain interfaces using Drift DAOs:

```dart
// data/repositories/account_repository_impl.dart
class AccountRepositoryImpl implements IAccountRepository {
  final AccountsDao _dao;
  AccountRepositoryImpl(this._dao);

  @override
  Stream<List<Account>> watchAll() {
    // Convert Drift's row type to the domain entity
    return _dao.watchAllActive().map(
      (rows) => rows.map(_toDomain).toList(),
    );
  }

  Account _toDomain(AccountRow row) => Account(
    id: row.id,
    name: row.name,
    type: AccountType.fromValue(row.type),
    balance: row.balance,
  );
}
```

The data layer knows about Drift (it imports it). The domain layer doesn't.

## Providers layer — the bridge

Riverpod providers connect the domain layer to the UI:

```dart
// providers/accounts_providers.dart
@riverpod
Stream<List<Account>> accounts(Ref ref) {
  final repo = ref.watch(accountRepositoryProvider);
  return repo.watchAll();  // calls the domain interface — doesn't know about Drift
}
```

## Presentation layer — the UI

Widgets consume providers. They never import DAOs or repository implementations directly:

```dart
// presentation/pages/accounts_page.dart
class AccountsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);  // from providers layer
    // ...
  }
}
```

## Why this complexity for a local-only app?

Fair question. A simpler app might just call DAOs from widgets. The layering pays off when:
- You add tests — mock the repository interface, not the DAO
- You add server sync — add an `ApiAccountRepositoryImpl`, switch with DI
- The codebase grows — each layer has a clear, limited responsibility

---

**Next:** [02-feature-first-folders.md](02-feature-first-folders.md)
