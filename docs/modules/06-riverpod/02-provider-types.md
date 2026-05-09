# Provider Types

Riverpod has several provider types, each designed for a specific kind of data. Picking the right one makes your code cleaner.

## Provider — a static value

Holds a value that doesn't change (or changes rarely — replaced by a new provider):

```dart
final appNameProvider = Provider<String>((ref) => 'Finsight');

// Use it:
final name = ref.watch(appNameProvider);  // → 'Finsight'
```

In Finsight, `Provider` is used for objects like the `AppDatabase` instance or DAOs:

```dart
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final accountsDaoProvider = Provider<AccountsDao>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.accountsDao;
});
```

## StreamProvider — live database data

Wraps a `Stream<T>`. Perfect for Drift's `.watch()` methods — gives you a live, updating list:

```dart
final accountsProvider = StreamProvider<List<Account>>((ref) {
  final dao = ref.watch(accountsDaoProvider);
  return dao.watchAllActive();  // Stream that emits new list on every DB change
});
```

The widget using this provider automatically rebuilds whenever the database changes. This is how Finsight makes the UI always show current data.

## FutureProvider — one-time async data

Wraps a `Future<T>`. Loads data once:

```dart
final userPreferencesProvider = FutureProvider<UserPreference>((ref) {
  final dao = ref.watch(preferencesDaoProvider);
  return dao.getPreferences();  // Future — fetches once
});
```

Use `FutureProvider` when you need to load something at startup that won't change (like preferences, or a large dataset that streams would be overkill for).

## NotifierProvider — state with mutation methods

When you need to both read state AND modify it (add, remove, update), `NotifierProvider` is the right choice. It pairs a `Notifier` class (which holds state and has methods) with a provider:

```dart
// The Notifier — holds state and methods to change it
class AccountsNotifier extends Notifier<List<Account>> {
  @override
  List<Account> build() => [];  // initial state

  Future<void> add(Account account) async {
    final repo = ref.read(accountRepositoryProvider);
    await repo.save(account);
    // State updates automatically via StreamProvider watching the DB
  }
}

// The provider
final accountsNotifierProvider =
    NotifierProvider<AccountsNotifier, List<Account>>(AccountsNotifier.new);
```

In Finsight, most mutation operations (add account, add transaction) will use `NotifierProvider` or just call repository methods directly from a button callback via `ref.read`.

## StateProvider — simple mutable value

For a single simple value that can be changed (like a selected filter):

```dart
final selectedTypeProvider = StateProvider<TransactionType?>((ref) => null);

// Change it:
ref.read(selectedTypeProvider.notifier).state = TransactionType.expense;

// Read it:
final selectedType = ref.watch(selectedTypeProvider);
```

Use this for UI state like selected filters, toggle states, current tab index — things that are app-wide but simple.

## @riverpod — code generation (what Finsight uses)

Instead of writing the provider declaration by hand, annotate a function with `@riverpod`:

```dart
// You write:
@riverpod
Stream<List<Account>> accounts(Ref ref) {
  final dao = ref.watch(accountsDaoProvider);
  return dao.watchAllActive();
}

// build_runner generates:
// final accountsProvider = StreamProvider.autoDispose<List<Account>>((ref) { ... });
```

After running `dart run build_runner build`, `accountsProvider` is available. The generated provider is `autoDispose` by default — it cleans up when no widget is watching it.

## Provider dependencies

Providers can watch other providers. Riverpod tracks these dependencies automatically:

```dart
@riverpod
Stream<List<Account>> accounts(Ref ref) {
  // This provider depends on accountsDaoProvider
  // If accountsDaoProvider ever changes, this one recomputes
  final dao = ref.watch(accountsDaoProvider);
  return dao.watchAllActive();
}
```

---

**Next:** [03-reading-providers.md](03-reading-providers.md)
