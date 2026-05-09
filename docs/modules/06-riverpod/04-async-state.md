# Async State — AsyncValue

`StreamProvider` and `FutureProvider` don't give you the value directly. They give you an `AsyncValue<T>` that represents three possible states: loading, data, or error.

## The three states

```dart
final accountsAsync = ref.watch(accountsProvider);
// accountsAsync is AsyncValue<List<Account>>

// State 1: still loading (first time, before stream emits)
accountsAsync.isLoading  // true

// State 2: data available
accountsAsync.hasValue   // true
accountsAsync.value      // List<Account>? — the actual data

// State 3: error occurred
accountsAsync.hasError   // true
accountsAsync.error      // the error object
```

## .when() — the clean way

`.when()` forces you to handle all three states and returns a widget for each:

```dart
final accountsAsync = ref.watch(accountsProvider);

return accountsAsync.when(
  data: (accounts) {
    // accounts is List<Account> — fully loaded
    return accounts.isEmpty
        ? const EmptyState()
        : AccountsList(accounts: accounts);
  },
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stackTrace) => ErrorWidget(message: error.toString()),
);
```

This is the pattern you'll use in every page that shows database data.

## .whenData() — transform only the data

When you only care about the data and want to keep the loading/error states unchanged:

```dart
final accountsAsync = ref.watch(accountsProvider);

// Transform the data (e.g., filter by type) while preserving AsyncValue wrapping
final expenseAccountsAsync = accountsAsync.whenData(
  (accounts) => accounts.where((a) => a.type == AccountType.bankAccount).toList(),
);
```

## .maybeWhen() — selective handling

When you only want to handle some states:

```dart
accountsAsync.maybeWhen(
  data: (accounts) => AccountsList(accounts: accounts),
  orElse: () => const CircularProgressIndicator(),  // loading AND error show spinner
)
```

## Showing previous data while loading

By default, when a `StreamProvider` reloads, it goes back to loading state. To keep showing the previous data while new data loads:

```dart
// skipLoadingOnReload keeps showing the last data instead of a spinner
accountsAsync.when(
  skipLoadingOnReload: true,
  data: (accounts) => AccountsList(accounts: accounts),
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text('Error: $e'),
)
```

## .value — quick access (unsafe)

```dart
// Returns the data if available, null otherwise (no error thrown)
final accounts = ref.watch(accountsProvider).value ?? [];
```

Only use this when you're certain data is already loaded (e.g., in a widget that's only shown after a `.when(data: ...)` check).

## Refreshing a provider

Force a `FutureProvider` to re-run its async function:

```dart
// Refresh — useful for pull-to-refresh
ref.refresh(userPreferencesProvider);

// Invalidate (same effect but different timing)
ref.invalidate(userPreferencesProvider);
```

For `StreamProvider`, there's no need to refresh — it automatically emits new values whenever the underlying stream emits.

## Practical pattern for Finsight pages

Every page that shows live data will follow this structure:

```dart
class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactionsAsync.when(
        data: (transactions) => transactions.isEmpty
            ? const _EmptyState()
            : _TransactionList(transactions: transactions),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Something went wrong: $e')),
      ),
    );
  }
}
```

---

## Exercises

1. If `accountsProvider` is a `StreamProvider` and the database already has 3 accounts, will the `loading` state ever be shown to the user? (Hint: streams emit their first value almost immediately)
2. What happens to the UI if the `StreamProvider` emits an error (e.g., the database is corrupt)?
3. Write the `AsyncValue.when()` call for a `FutureProvider<UserPreference>` that shows a `CircularProgressIndicator` while loading, the currency symbol when loaded, and a `Text('Error')` on failure.

**You've completed Module 06!** Move on to [Module 07 — Database with Drift](../07-database/README.md).
