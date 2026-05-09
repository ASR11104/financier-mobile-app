# Classes and Objects

Dart is object-oriented. Classes are templates for creating objects. Most of the code in Finsight is organized into classes.

## A basic class

```dart
class BankAccount {
  // Fields (instance variables)
  final String id;
  final String name;
  double balance;

  // Constructor
  BankAccount({required this.id, required this.name, this.balance = 0});

  // Method
  void deposit(double amount) {
    balance += amount;
  }

  // Getter (read-only computed property)
  bool get isEmpty => balance == 0;
}

// Creating an object:
final account = BankAccount(id: 'abc', name: 'HDFC Savings');
account.deposit(1000);
print(account.balance);  // 1000.0
print(account.isEmpty);  // false
```

## Constructors

Dart has several constructor forms:

```dart
class Point {
  final double x;
  final double y;

  // Standard constructor — this.x shorthand assigns parameters to fields
  Point(this.x, this.y);

  // Named constructor — a second way to create the object
  Point.origin() : x = 0, y = 0;

  // Factory constructor — can return an existing instance or subtype
  factory Point.fromMap(Map<String, double> map) {
    return Point(map['x']!, map['y']!);
  }
}

final p1 = Point(3, 4);
final p2 = Point.origin();
```

## Private members

In Dart, prefix a name with `_` to make it private to the file (library):

```dart
class Formatters {
  // Private constructor — prevents anyone from creating a Formatters instance
  // Forces use as a static utility class
  Formatters._();

  static String formatAmount(double amount, String symbol) { /* ... */ }
}

// Usage — no instance needed:
Formatters.formatAmount(1500, '₹');
```

Open `lib/core/utils/formatters.dart` — this is exactly what it does. `Formatters._()` is a private constructor. Since you can't create a `Formatters` object, all methods must be `static`.

## Static members

`static` members belong to the class, not to instances:

```dart
class AppConstants {
  static const String appName = 'Finsight';
  static const int recentLimit = 10;
}

// Access without creating an instance:
print(AppConstants.appName);  // 'Finsight'
```

## Inheritance

```dart
class Animal {
  final String name;
  Animal(this.name);

  void speak() => print('...');
}

class Dog extends Animal {
  Dog(String name) : super(name);   // super() calls the parent constructor

  @override  // annotation: this intentionally overrides the parent method
  void speak() => print('Woof!');
}
```

In Flutter, you extend framework classes all the time:
```dart
class AccountsPage extends StatelessWidget { /* ... */ }
class AccountsDao extends DatabaseAccessor<AppDatabase> { /* ... */ }
```

## Abstract classes (interfaces)

Abstract classes define a contract — a set of methods that subclasses must implement:

```dart
abstract class IAccountRepository {
  Stream<List<Account>> watchAll();
  Future<void> save(Account account);
  // No implementation — just the signature
}

class AccountRepositoryImpl implements IAccountRepository {
  @override
  Stream<List<Account>> watchAll() { /* real implementation */ }

  @override
  Future<void> save(Account account) { /* real implementation */ }
}
```

This is the Repository pattern used in Finsight's architecture. The `I` prefix is a convention meaning "Interface".

## Mixins

A mixin is a way to share code between classes without using inheritance. You'll see this in the generated Drift code:

```dart
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
```

`with _$AccountsDaoMixin` means "also mix in this additional code". The mixin gives `AccountsDao` access to the `accounts` table variable and generated query helpers without needing to inherit from another full class.

---

## Exercises

1. Open `lib/app/theme/app_colors.dart`. Why does it have `AppColors._()` as a constructor? What does that prevent?
2. Open `lib/database/daos/accounts_dao.dart`. What class does `AccountsDao` extend? What does `super.db` do in the constructor?
3. Look at `lib/core/enums/account_type.dart`. What is the type of the `value` field on each enum case?

**Next:** [04-enums.md](04-enums.md)
