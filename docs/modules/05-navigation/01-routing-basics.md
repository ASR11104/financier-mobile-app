# Routing Basics

`go_router` treats navigation like URLs — every screen has a path like `/accounts` or `/accounts/some-id`. This makes navigation predictable and enables deep linking (opening the app directly to a specific screen from a notification).

## GoRouter

The router is defined once and connected to `MaterialApp`:

```dart
// lib/app/router.dart
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',     // start here when the app opens
  routes: [/* ... */],
);

// lib/app/app.dart
MaterialApp.router(
  routerConfig: appRouter,
)
```

## GoRoute — defining a screen

```dart
GoRoute(
  path: '/accounts',           // the URL path
  name: 'accounts',            // optional name — use for named navigation
  builder: (context, state) => const AccountsPage(),
)
```

`builder` receives:
- `context` — the BuildContext
- `state` — information about the current route (parameters, query params, etc.)

## Route parameters

Use `:paramName` in the path to capture dynamic segments:

```dart
GoRoute(
  path: '/accounts/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;  // reads the :id segment
    return AccountDetailPage(accountId: id);
  },
)
```

Navigate to it: `context.go('/accounts/abc-123')` — the `id` parameter becomes `'abc-123'`.

## Query parameters

For optional filters: `/transactions?type=expense&month=2026-05`

```dart
GoRoute(
  path: '/transactions',
  builder: (context, state) {
    final type = state.uri.queryParameters['type'];      // 'expense' or null
    final month = state.uri.queryParameters['month'];    // '2026-05' or null
    return TransactionsPage(type: type, month: month);
  },
)
```

Navigate: `context.go('/transactions?type=expense')`

## Nested routes

Sub-routes are defined by nesting inside a parent `GoRoute`:

```dart
GoRoute(
  path: '/accounts',
  builder: (context, state) => const AccountsPage(),
  routes: [
    GoRoute(
      path: ':id',              // full path becomes /accounts/:id
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AccountDetailPage(accountId: id);
      },
      routes: [
        GoRoute(
          path: 'edit',         // full path becomes /accounts/:id/edit
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EditAccountPage(accountId: id);
          },
        ),
      ],
    ),
  ],
)
```

## Error handling

`go_router` shows an error screen if a route isn't found. You can customize it:

```dart
GoRouter(
  errorBuilder: (context, state) => ErrorPage(error: state.error),
  routes: [/* ... */],
)
```

---

**Next:** [02-tab-navigation.md](02-tab-navigation.md)
