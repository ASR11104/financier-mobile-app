# Reading Providers

Providers are accessed through `WidgetRef ref` — available in `ConsumerWidget.build()`, `ConsumerStatefulWidget`, and `Consumer`.

## The two methods: watch and read

### `ref.watch` — subscribe and rebuild

```dart
class AccountsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Subscribe — this widget rebuilds whenever accountsProvider changes
    final accountsAsync = ref.watch(accountsProvider);
    
    return /* ... */;
  }
}
```

Every time `accountsProvider` emits a new value (e.g., the DB was updated), this `build()` is called again. The widget always shows the latest data.

**Rule: only use `ref.watch` inside `build()`.**

### `ref.read` — read once, no subscription

```dart
ElevatedButton(
  onPressed: () async {
    // Read without subscribing — just need the repo to call a method
    final repo = ref.read(accountRepositoryProvider);
    await repo.save(newAccount);
  },
  child: const Text('Save Account'),
)
```

`ref.read` doesn't create a subscription. The widget won't rebuild when the provider changes. Use it in callbacks (button taps, form submissions) where you need a one-time value or want to call a method.

**Rule: use `ref.read` inside callbacks (`onPressed`, `onChanged`, etc.), never in `build()`.**

## Common mistake: ref.watch in a callback

```dart
// WRONG — causes runtime error
onPressed: () {
  final accounts = ref.watch(accountsProvider);  // ERROR inside callback
}

// RIGHT
onPressed: () {
  final accounts = ref.read(accountsProvider);   // read once
}
```

## ProviderScope

`ProviderScope` at the top of the widget tree (`lib/main.dart`) creates the container that holds all provider state. It must wrap the entire app:

```dart
runApp(
  const ProviderScope(
    child: FinsightApp(),
  ),
);
```

## Consumer — local subscription

Sometimes you only want a small part of a widget to rebuild, not the whole page. Wrap that part in `Consumer`:

```dart
class ExpensivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This expensive build logic runs only once
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          const StaticHeader(),  // never rebuilds
          Consumer(              // only this rebuilds when accounts change
            builder: (context, ref, child) {
              final accounts = ref.watch(accountsProvider);
              return AccountSummaryWidget(accounts: accounts.value ?? []);
            },
          ),
        ],
      ),
    );
  }
}
```

## ref.listen — react to changes without rebuilding

Sometimes you want to respond to a state change with a side effect (like showing a snackbar) rather than rebuilding:

```dart
class SavePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // When saveState changes, run this callback
    ref.listen(saveAccountProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
      );
    });
    
    return /* build the form */;
  }
}
```

`ref.listen` doesn't rebuild the widget — it just calls the callback when the value changes.

## Overriding providers in tests

One of Riverpod's best features for testing:

```dart
testWidgets('shows accounts', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Replace the real accounts provider with fake data for the test
        accountsProvider.overrideWithValue(
          AsyncValue.data([fakeAccount1, fakeAccount2]),
        ),
      ],
      child: AccountsPage(),
    ),
  );

  expect(find.text('HDFC Savings'), findsOneWidget);
});
```

---

**Next:** [04-async-state.md](04-async-state.md)
