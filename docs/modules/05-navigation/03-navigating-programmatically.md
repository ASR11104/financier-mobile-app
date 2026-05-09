# Navigating Programmatically

Once routes are defined, you trigger navigation in response to user actions using `context.go()` and `context.push()`.

## `context.go()` — replace history

Goes to a route and **replaces** the current navigation stack with the new destination:

```dart
// Tapping a bottom tab — no back button needed
context.go('/accounts');

// After deleting an item, go back to the list
context.go('/transactions');
```

Use `go` when you don't want the user to be able to go back with the back button.

## `context.push()` — add to history

Pushes a new route on top of the current one. The back button returns to the previous screen:

```dart
// Open account detail — back button returns to the accounts list
context.push('/accounts/some-id');

// Open add transaction form
context.push('/transactions/new');
```

Use `push` for drilling down (list → detail, overview → form).

## `context.pop()` — go back

Equivalent to pressing the back button:

```dart
ElevatedButton(
  onPressed: () => context.pop(),
  child: const Text('Cancel'),
)
```

You can also pop with a result (like returning data from a form):

```dart
// In the form page:
context.pop(result: newAccount);

// In the calling page (using push):
final account = await context.push<Account>('/accounts/new');
if (account != null) {
  // use the returned account
}
```

## Named navigation

Instead of hardcoded path strings, use route names:

```dart
// Define:
GoRoute(path: '/accounts/:id', name: 'account-detail', ...)

// Navigate:
context.goNamed('account-detail', pathParameters: {'id': account.id});
```

Named navigation is safer — if you rename the path `/accounts` to `/my-accounts`, you only change it in one place (the route definition), not everywhere you navigate.

## Passing data to a new screen

### Via path parameters (for entity IDs)
```dart
context.push('/accounts/${account.id}');

// In the route:
final id = state.pathParameters['id']!;
// Then load the account from the database using this id
```

### Via query parameters (for filters)
```dart
context.go('/transactions?type=expense');
```

### Via `extra` (for passing objects directly)
```dart
context.push('/accounts/edit', extra: account);

// In the route:
final account = state.extra as Account;
```

> **Note**: `extra` is not preserved if the user deep-links or the app is killed and restored. For persisted navigation, always use path/query parameters and re-load from the database.

## GoRouterHelper extension (shorthand)

`go_router` provides extension methods on `BuildContext`:

```dart
// These are equivalent:
GoRouter.of(context).go('/accounts');
context.go('/accounts');                // shorthand via extension
```

Always use the shorthand — it's cleaner.

## Back button behavior

On Android, the hardware back button calls `context.pop()` automatically. `go_router` handles this correctly as long as you use `push` for drill-down navigation. If you use `go` everywhere, there's no history to go back to, and the back button exits the app.

Rule of thumb:
- Bottom tab switches: use `go`
- Drill-down (list → detail, tap → form): use `push`

---

## Exercises

1. Open `lib/app/router.dart`. Currently there are 5 routes. Add a new route `/accounts/:id` nested inside the accounts branch. Make it show a `Text` widget with the `id` parameter.
2. In `lib/features/accounts/presentation/pages/accounts_page.dart`, the "Add Account" action currently shows a snackbar. Change it to `context.push('/accounts/new')` (you'll need to define that route first).
3. What would happen if you used `context.go('/transactions')` from the accounts detail page instead of `context.pop()`? Would the back button still work?

**You've completed Module 05!** Move on to [Module 06 — Riverpod](../06-riverpod/README.md).
