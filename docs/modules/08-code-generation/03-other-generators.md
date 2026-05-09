# Other Code Generators

Besides Drift and freezed, Finsight uses three more code generators.

## riverpod_generator

The `@riverpod` annotation generates Riverpod provider declarations from plain functions.

**You write:**
```dart
// accounts_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_providers.g.dart';  // generated file

@riverpod
Stream<List<Account>> accounts(Ref ref) {
  final dao = ref.watch(accountsDaoProvider);
  return dao.watchAllActive();
}
```

**build_runner generates** `accounts_providers.g.dart` containing:
```dart
// Generated — do not edit
final accountsProvider = StreamProvider.autoDispose<List<Account>>((ref) {
  return accounts(ref);
});
```

Now you can use `accountsProvider` in any widget. The generated provider:
- Is `autoDispose` — cleans itself up when no widget is watching it (prevents memory leaks)
- Infers the return type from your function (if function returns `Stream<T>`, it creates `StreamProvider<T>`)

### Family providers — with parameters

For providers that take a parameter (like "get account by ID"):

```dart
@riverpod
Stream<Account?> account(Ref ref, String id) {
  //                              ^^^^^^^^ parameter
  final dao = ref.watch(accountsDaoProvider);
  return dao.watchById(id);
}

// Usage:
final accountAsync = ref.watch(accountProvider('some-id'));
```

## injectable_generator

`injectable` generates the Dependency Injection (DI) wiring from annotations on your classes.

**You write:**
```dart
@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get database => AppDatabase();
}

@lazySingleton
class AccountsDao extends DatabaseAccessor<AppDatabase> with _$AccountsDaoMixin {
  AccountsDao(AppDatabase db) : super(db);
}

@LazySingleton(as: IAccountRepository)
class AccountRepositoryImpl implements IAccountRepository {
  AccountRepositoryImpl(AccountsDao dao);
}
```

**build_runner generates** a `configureDependencies()` function that registers all of these in `GetIt`. You call it once at startup:

```dart
// main.dart
void main() async {
  await configureDependencies();  // wires up all DI registrations
  runApp(/* ... */);
}
```

Then anywhere:
```dart
final repo = GetIt.I<IAccountRepository>();  // returns the registered impl
```

> **Note**: Finsight hasn't set up the full injectable wiring yet. The database is currently created directly in `main.dart`. This is the next infrastructure step to implement.

## json_serializable

For converting Dart objects to/from JSON. Used when you eventually add API sync or import/export features.

**You write:**
```dart
import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountDto {
  final String id;
  final String name;
  @JsonKey(name: 'account_type')  // maps to different JSON key
  final String type;

  AccountDto({required this.id, required this.name, required this.type});

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);  // generated

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);  // generated
}
```

**build_runner generates** `_$AccountDtoFromJson` and `_$AccountDtoToJson` functions.

Usage:
```dart
// Deserialize from JSON
final dto = AccountDto.fromJson({'id': 'abc', 'name': 'HDFC', 'account_type': 'bank_account'});

// Serialize to JSON
final json = dto.toJson();
```

## The generation pipeline

When you run `build_runner build`, it runs all generators in dependency order:

```
Source files (.dart with annotations)
    ↓ Drift generator
app_database.g.dart, *_dao.g.dart

    ↓ freezed generator
*.freezed.dart

    ↓ riverpod_generator
*_providers.g.dart

    ↓ injectable_generator
injectable.config.dart

    ↓ json_serializable
*.g.dart (for DTOs)
```

---

## Exercises

1. In `lib/database/app_database.dart`, the `part 'app_database.g.dart'` line connects to the generated file. Open `app_database.g.dart` if it exists (you may need to run `build_runner` first). What does the generated `_$AppDatabase` class look like?
2. What would happen if you deleted `accounts_dao.g.dart` and tried to run the app without regenerating?
3. Create a simple `@riverpod` function for `categoriesProvider` that watches all categories from `CategoriesDao`. What type would it return?

**You've completed Module 08!** Move on to [Module 09 — Architecture](../09-architecture/README.md).
