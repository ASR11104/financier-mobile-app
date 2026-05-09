# Module 06 — Riverpod

Riverpod is the state management system in Finsight. It connects database streams to the UI and manages app-wide state.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-why-state-management.md](01-why-state-management.md) | The problem Riverpod solves |
| [02-provider-types.md](02-provider-types.md) | Provider, StreamProvider, FutureProvider, NotifierProvider |
| [03-reading-providers.md](03-reading-providers.md) | ref.watch, ref.read, ConsumerWidget |
| [04-async-state.md](04-async-state.md) | AsyncValue, .when(), loading/error handling |

## Project files to read alongside this module

- `lib/app/app.dart` — `FinsightApp` as a `ConsumerWidget`
- `lib/main.dart` — `ProviderScope` at the root

## Exercise for this module

Create your first real provider. In `lib/features/accounts/providers/accounts_providers.dart`:

1. Create a `StreamProvider<List<Account>>` that wraps `AccountsDao.watchAllActive()`
2. Update `AccountsPage` to be a `ConsumerWidget` that reads this provider
3. Display the number of accounts or an empty state

You'll need to also create a provider for `AccountsDao` itself. Check Module 09 (Architecture) after completing this to understand how repositories fit between the DAO and the provider.
