# Boot Sequence — How the App Starts

Tracing the startup sequence is the best way to understand how all the pieces connect. Open `lib/main.dart` as you read this.

## Step 1 — main()

```dart
void main() async {
```

Every Dart program starts at `main()`. The `async` keyword makes it an async function because we need to `await` some startup operations.

## Step 2 — Flutter binding

```dart
WidgetsFlutterBinding.ensureInitialized();
```

Before doing anything async (like opening a file), you must initialize Flutter's binding — the glue between Dart code and the native Android/iOS platform. If you skip this, plugin calls (like file access) will fail.

**Rule**: This must be the first line in `main()` whenever you have async code before `runApp()`.

## Step 3 — Database initialization

```dart
final db = AppDatabase();
```

Creates the database connection. `AppDatabase()` calls `_openConnection()` which calls `driftDatabase(name: 'finsight_db')`. This:
- Looks for `finsight_db.sqlite` in the app's data directory
- Creates it if it doesn't exist (calls `onCreate` migration → `m.createAll()`)
- Opens a connection to it

## Step 4 — Seed data

```dart
await SeedData.seed(db);
```

On first launch, this inserts the default categories (23 categories across expense/income/investment) and the user preferences row. `SeedData.seed()` checks whether categories already exist before inserting — it's idempotent (safe to call multiple times).

## Step 5 — runApp

```dart
runApp(
  const ProviderScope(
    child: FinsightApp(),
  ),
);
```

`runApp()` takes a widget and mounts it as the root. `ProviderScope` wraps the entire app — it must be the outermost widget for Riverpod to work. Every Riverpod provider's state lives inside this `ProviderScope`.

## Step 6 — FinsightApp.build()

Flutter calls `build()` on `FinsightApp` (`lib/app/app.dart`):

```dart
MaterialApp.router(
  title: 'Finsight',
  debugShowCheckedModeBanner: false,
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system,    // reads OS dark/light setting
  routerConfig: appRouter,        // hands navigation to go_router
)
```

`MaterialApp.router` sets up the Material framework, applies the theme, and delegates navigation to `appRouter`.

## Step 7 — GoRouter initialization

`appRouter` (defined in `lib/app/router.dart`) is evaluated:
- `initialLocation: '/dashboard'` sets the starting route
- Routes are registered: `/dashboard`, `/transactions`, `/accounts`, `/analytics`, `/settings`
- `StatefulShellRoute.indexedStack` sets up the 5-tab structure

## Step 8 — First render

go_router navigates to `/dashboard`. The route's builder returns `DashboardPage()`. The widget tree becomes:

```
ProviderScope
└── FinsightApp (ConsumerWidget)
    └── MaterialApp.router
        └── ScaffoldWithNavBar (StatelessWidget)
            ├── NavigationBar (5 destinations)
            └── DashboardPage (currently the active tab body)
                └── Scaffold
                    └── [placeholder content]
```

## Step 9 — Subsequent rebuilds

Any time a Riverpod provider's value changes (e.g., a new account is added to the database), only the widgets that `ref.watch()`ed that provider rebuild — not the entire tree. Flutter efficiently updates only what changed.

## The database instance problem

Notice that `db` is created in `main()` but `FinsightApp` doesn't receive it. Currently, the database is not accessible to providers. The next step in the app's development is to register `db` with a Riverpod `Provider` so any widget can access it:

```dart
// In main.dart (after the fix):
final db = AppDatabase();
await SeedData.seed(db);
runApp(
  ProviderScope(
    overrides: [
      // Override the database provider with the real instance
      appDatabaseProvider.overrideWithValue(db),
    ],
    child: const FinsightApp(),
  ),
);
```

This makes `db` available via `ref.watch(appDatabaseProvider)` anywhere in the app.

---

**Next:** [02-accounts-feature-end-to-end.md](02-accounts-feature-end-to-end.md)
