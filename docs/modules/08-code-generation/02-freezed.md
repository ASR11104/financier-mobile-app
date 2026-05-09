# freezed — Immutable Models

`freezed` generates boilerplate for immutable data classes: `copyWith`, equality (`==`), `hashCode`, and `toString`. It's used for **domain entities** in Finsight.

## The problem it solves

Imagine writing this manually for every entity:

```dart
class Account {
  final String id;
  final String name;
  final double balance;

  Account({required this.id, required this.name, required this.balance});

  // copyWith — creates a modified copy (tedious to write)
  Account copyWith({String? id, String? name, double? balance}) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  // Equality — without this, two Account objects with same data are != 
  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.name == name &&
      other.balance == balance;

  @override
  int get hashCode => Object.hash(id, name, balance);

  @override
  String toString() => 'Account(id: $id, name: $name, balance: $balance)';
}
```

For a class with 10+ fields (like Finsight's Account), this is ~50 lines of boilerplate. `freezed` generates it all.

## Writing a freezed class

```dart
// account.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';  // generated file goes here

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required double balance,
    String? notes,
    @Default(true) bool isActive,  // default value
  }) = _Account;  // ← this underscore class is generated
}
```

After `build_runner`, `account.freezed.dart` is created with all the boilerplate. Your code uses `Account` directly.

## What you get for free

```dart
final account = Account(id: 'abc', name: 'HDFC', balance: 25000);

// copyWith — create a modified copy
final renamed = account.copyWith(name: 'HDFC Savings');

// Equality — compares all fields by value
Account(id: 'abc', name: 'HDFC', balance: 25000) ==
Account(id: 'abc', name: 'HDFC', balance: 25000)  // → true

// toString — readable for debugging
print(account);  // Account(id: abc, name: HDFC, balance: 25000.0)
```

## Nullable fields vs defaults

```dart
const factory Account({
  required String id,
  required String name,
  required double balance,
  String? notes,              // optional — null if not provided
  @Default(0.0) double creditLimit,  // optional — 0.0 if not provided
}) = _Account;
```

- `String? notes` — nullable, null by default
- `@Default(0.0) double creditLimit` — non-nullable, has a default value

## Union types (advanced)

`freezed` also supports sealed classes / union types — a single type that can be one of several shapes. This is useful for modeling states:

```dart
@freezed
sealed class AccountState with _$AccountState {
  const factory AccountState.loading() = _Loading;
  const factory AccountState.loaded(List<Account> accounts) = _Loaded;
  const factory AccountState.error(String message) = _Error;
}

// Usage with pattern matching:
final state = ref.watch(accountStateProvider);
return switch (state) {
  AccountState.loading() => CircularProgressIndicator(),
  AccountState.loaded(:final accounts) => AccountList(accounts: accounts),
  AccountState.error(:final message) => Text(message),
};
```

This is an alternative to `AsyncValue` for more complex state machines.

## When to use freezed

- **Domain entities** (Account, Transaction, Category) — they are pure data that gets passed around
- **State classes** — for Notifiers that need complex state
- **API response models** — when you add server sync later

**Don't use freezed for Drift table data classes** — Drift generates its own row classes automatically.

---

**Next:** [03-other-generators.md](03-other-generators.md)
