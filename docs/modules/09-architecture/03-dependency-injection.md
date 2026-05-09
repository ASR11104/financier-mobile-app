# Dependency Injection

Dependency Injection (DI) is the practice of providing objects with their dependencies from the outside, rather than having them create their own.

## The problem

Without DI, classes reach out and create their own dependencies:

```dart
// BAD — tightly coupled
class AccountRepositoryImpl {
  final _dao = AccountsDao(AppDatabase());  // creates its own deps — untestable
}
```

This is hard to test because you can't swap in a fake database. It also means every class that needs a database creates a new one — wasteful.

## With DI

Dependencies are injected via the constructor:

```dart
// GOOD — loosely coupled, testable
class AccountRepositoryImpl {
  final AccountsDao _dao;
  AccountRepositoryImpl(this._dao);   // receives its dependency
}
```

Now in tests:
```dart
final fakeDao = FakeAccountsDao();
final repo = AccountRepositoryImpl(fakeDao);  // inject the fake
```

## get_it — the service locator

`get_it` maintains a global registry of objects. You register objects once and retrieve them anywhere:

```dart
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;  // sl = service locator

// Registration (at app startup):
sl.registerSingleton<AppDatabase>(AppDatabase());
sl.registerLazySingleton<AccountsDao>(() => AccountsDao(sl<AppDatabase>()));
sl.registerLazySingleton<IAccountRepository>(
  () => AccountRepositoryImpl(sl<AccountsDao>()),
);

// Usage anywhere:
final repo = sl<IAccountRepository>();
```

**`registerSingleton`** — creates the object immediately, returns same instance every time.
**`registerLazySingleton`** — creates the object on first access, then caches it.
**`registerFactory`** — creates a new instance every time (for objects with local state).

## injectable — DI via annotations

Writing `GetIt.I.registerLazySingleton(...)` for every class is tedious. `injectable` generates this code from annotations:

```dart
@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get database => AppDatabase();
}

// In AccountsDao (the actual DAO class):
@lazySingleton
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  AccountsDao(AppDatabase db) : super(db);
}

// In the repository implementation:
@LazySingleton(as: IAccountRepository)
class AccountRepositoryImpl implements IAccountRepository {
  final AccountsDao _dao;
  AccountRepositoryImpl(this._dao);
  // ...
}
```

Run `build_runner` → generates `injectable.config.dart` with a `configureDependencies()` function:

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();  // registers everything via get_it
  runApp(/* ... */);
}
```

## Riverpod + DI

Finsight uses Riverpod for UI state, and will use get_it + injectable for the service/repository layer. The bridge between them is a `Provider` that reads from `GetIt`:

```dart
// A provider that gets the registered repository
final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  return GetIt.I<IAccountRepository>();
});
```

Or, without injectable (simpler approach used while the app is early):

```dart
// Create DAO providers that the repository provider depends on
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final accountsDaoProvider = Provider<AccountsDao>((ref) {
  return ref.watch(appDatabaseProvider).accountsDao;
});

final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  final dao = ref.watch(accountsDaoProvider);
  return AccountRepositoryImpl(dao);
});
```

## Current state in Finsight

The app currently creates `AppDatabase` directly in `main.dart`:

```dart
// main.dart — current (simple, but no DI)
final db = AppDatabase();
await SeedData.seed(db);
runApp(const ProviderScope(child: FinsightApp()));
```

The database instance is not yet registered with `get_it` or available as a Riverpod provider. Setting this up is the first infrastructure task before implementing features.

---

**You've completed Module 09!** Move on to [Module 10 — Android Basics](../10-android-basics/README.md).
