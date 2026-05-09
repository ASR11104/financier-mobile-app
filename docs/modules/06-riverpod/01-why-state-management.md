# Why State Management?

Before learning Riverpod's API, it's worth understanding the problem it solves. Without a state management system, Flutter apps have two problems: **prop drilling** and **state synchronization**.

## Problem 1: Prop drilling

Imagine your `AccountsPage` needs the list of accounts from the database. Without Riverpod, you'd have to pass it down through every parent:

```dart
// main.dart passes db to FinsightApp
runApp(FinsightApp(db: db));

// FinsightApp passes db to the router, which passes to ScaffoldWithNavBar
// ScaffoldWithNavBar passes to AccountsPage

// AccountsPage finally uses it
class AccountsPage extends StatelessWidget {
  final AppDatabase db;   // required every time
  // ...
}
```

In a real app with many screens and many pieces of data, this becomes unmanageable. Every intermediate widget must accept and forward data it doesn't use — this is "prop drilling".

## Problem 2: State synchronization

Multiple screens need the same data. If you add an account, both the `AccountsPage` (list) and `DashboardPage` (summary) should update. Without a shared state system, you'd need to manually tell both to refresh — fragile and easy to forget.

## Riverpod's solution: shared state outside the widget tree

Riverpod puts state in **providers** — objects that live outside the widget tree. Any widget anywhere can access them:

```dart
// Define the provider once
final accountsProvider = StreamProvider<List<Account>>((ref) {
  return accountsDao.watchAllActive();  // streams live updates from DB
});

// Use it in AccountsPage
class AccountsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);  // subscribe
    // Widget rebuilds whenever accounts changes
  }
}

// Use it in DashboardPage — same provider, always in sync
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);  // same data, auto-updated
  }
}
```

When the database changes, both widgets automatically receive the new data — no manual synchronization needed.

## Why not just use `setState`?

`setState` is fine for purely local state (e.g., is a dropdown open?). But it only works within one `StatefulWidget` — it can't share state between separate widgets.

## Why Riverpod over other solutions?

Flutter has several state management options (Provider, Bloc, GetX, MobX, Redux). Finsight uses Riverpod because:
- Compile-time safety — providers are typed, can't read wrong type
- No `BuildContext` needed to read a provider (unlike Provider package)
- Works well with async data (Streams and Futures) — perfect for Drift's reactive queries
- `riverpod_generator` removes most boilerplate

---

**Next:** [02-provider-types.md](02-provider-types.md)
