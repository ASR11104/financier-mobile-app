# ConsumerWidget

`ConsumerWidget` is Riverpod's version of `StatelessWidget`. The only difference is its `build()` method receives a second parameter: `WidgetRef ref`. Through `ref`, you can read Riverpod providers and subscribe to state changes.

## Basic structure

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //                               ^^^^^^^^^^^ this is new vs StatelessWidget
    
    // Read a provider — widget rebuilds when accountsProvider changes
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      body: accountsAsync.when(
        data: (accounts) => Text('${accounts.length} accounts'),
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}
```

## In Finsight — `FinsightApp`

Open `lib/app/app.dart`:

```dart
class FinsightApp extends ConsumerWidget {
  const FinsightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: will watch theme mode from preferences provider here
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
```

Currently `FinsightApp` is a `ConsumerWidget` but doesn't yet call `ref.watch()`. The comment shows where the theme preference will be read from the database in the future.

## `ref.watch` vs `ref.read`

These are the two main ways to access a provider:

### `ref.watch(provider)` — subscribe and rebuild
```dart
// In build() — subscribes to the provider
// Widget rebuilds every time the provider's value changes
final accounts = ref.watch(accountsProvider);
```

Use `ref.watch` in `build()`. Every time the accounts list changes (user adds one), this widget automatically rebuilds with the new list.

### `ref.read(provider)` — read once
```dart
// In a callback — reads the current value without subscribing
ElevatedButton(
  onPressed: () {
    final repo = ref.read(accountRepositoryProvider);
    repo.save(newAccount);   // one-time action — no need to rebuild
  },
  child: const Text('Save'),
)
```

Use `ref.read` inside callbacks (`onPressed`, `onChanged`). Never use `ref.watch` inside a callback — it would throw an error.

**Simple rule**: `ref.watch` in `build()`, `ref.read` everywhere else.

## `Consumer` widget (inline version)

Sometimes you only want to listen to a provider inside a small part of a widget tree, not the whole widget. Use `Consumer`:

```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Page')),
      body: Consumer(
        builder: (context, ref, child) {
          // Only this part rebuilds when the provider changes
          final count = ref.watch(counterProvider);
          return Text('Count: $count');
        },
      ),
    );
  }
}
```

This is useful for performance — if only a small part of a large widget tree needs live data, wrapping just that part in `Consumer` avoids rebuilding everything.

## `ConsumerStatefulWidget`

If you need both Riverpod providers AND local mutable state, use `ConsumerStatefulWidget`:

```dart
class AddAccountPage extends ConsumerStatefulWidget {
  const AddAccountPage({super.key});

  @override
  ConsumerState<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends ConsumerState<AddAccountPage> {
  // Local state (for the form)
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Can use both ref (Riverpod) and setState (local state)
    final categories = ref.watch(categoriesProvider);
    
    return TextField(controller: _nameController);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
```

In Finsight, form pages will use `ConsumerStatefulWidget`.

---

**Next:** [04-build-context.md](04-build-context.md)
