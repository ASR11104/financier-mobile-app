# StatelessWidget vs StatefulWidget

The two base widget types differ in one thing: whether the widget has mutable state that can change over its lifetime.

## StatelessWidget

A widget with no internal mutable state. Given the same inputs (constructor parameters), it always produces the same UI.

```dart
class WelcomeBanner extends StatelessWidget {
  final String name;

  const WelcomeBanner({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Welcome, $name!');
  }
}
```

`build()` is called by Flutter whenever it needs to render this widget. It receives a `BuildContext` and returns a widget tree. The widget itself never changes — if `name` changes, Flutter creates a new `WelcomeBanner` with the new name.

### In Finsight — `AccountsPage`

Open `lib/features/accounts/presentation/pages/accounts_page.dart`:

```dart
class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_rounded, size: 64),
            // ...
          ],
        ),
      ),
    );
  }
}
```

This is a `StatelessWidget` because it currently has no data to track — it just shows an empty state. Once we wire it to Riverpod and the database, it will become a `ConsumerWidget`.

## StatefulWidget

A widget that holds mutable state in a separate `State` object. When the state changes (via `setState()`), Flutter calls `build()` again to update the UI.

```dart
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // This is the mutable state
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _count++;  // setState tells Flutter to rebuild
            });
          },
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

### Why is State separate from the Widget?

`StatefulWidget` itself is still immutable. The `State` object is separate and persists across rebuilds. When Flutter needs to rebuild the widget (because something changed), it creates a new `StatefulWidget` but **reuses the existing `State`** object. This is how state survives rebuilds.

The naming convention: `_WidgetNameState` (private, with underscore prefix).

## When to use each

| Scenario | Use |
|----------|-----|
| Displays fixed content, no interaction | `StatelessWidget` |
| Reads data from Riverpod providers | `ConsumerWidget` (next topic) |
| Has local UI state (expanded/collapsed, form input, tab index) | `StatefulWidget` |
| Runs animations with `AnimationController` | `StatefulWidget` (or use `flutter_animate`) |

### In practice for Finsight

Most of the app's pages will be `ConsumerWidget` (they read database data).
`StatefulWidget` will appear for:
- Forms (tracking current input values before submission)
- Expandable/collapsible UI sections
- Any widget with purely local, temporary state

---

## Exercises

1. Open each page in `lib/features/`. Are they all `StatelessWidget`? Why does that make sense given the app's current state (no data yet)?
2. Write a `ToggleButton` as a `StatefulWidget` that alternates between "ON" and "OFF" text when tapped, using `setState`.
3. When would a `StatelessWidget` in a list of 1000 items be more efficient than a `StatefulWidget`?

**Next:** [03-consumer-widget.md](03-consumer-widget.md)
