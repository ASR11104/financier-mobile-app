# Dart Special Syntax

These are patterns you'll see throughout the Finsight codebase that look unusual at first but become second nature quickly.

## The cascade operator (`..`)

`..` calls a method on an object but returns the **original object**, not the method's return value. This lets you chain multiple operations on the same object.

```dart
// Without cascade — verbose
final query = select(accounts);
query.where((a) => a.isActive.equals(1));
query.orderBy([(a) => OrderingTerm.asc(a.name)]);
return query.get();

// With cascade — clean chaining
return (select(accounts)
      ..where((a) => a.isActive.equals(1))
      ..orderBy([(a) => OrderingTerm.asc(a.name)]))
    .get();
```

You'll see `..` in virtually every DAO query in Finsight. The outer parentheses `(select(accounts)..where(...))` group the cascade so `.get()` is called on the result of `select(accounts)`, not on the return of `where()`.

## Generics

Generics let you write code that works with any type, specified later:

```dart
// T is a type placeholder
class Box<T> {
  final T value;
  Box(this.value);
}

Box<String> nameBox = Box('Finsight');
Box<int> countBox = Box(42);
```

You see generics constantly in Dart:
```dart
List<Account>            // a list of Account objects
Future<List<Account>>    // a future that delivers a list of Accounts
Stream<List<Account>>    // a stream of account lists
Map<String, double>      // a map from String keys to double values
```

In Finsight's DAOs:
```dart
class AccountsDao extends DatabaseAccessor<AppDatabase>
```
`DatabaseAccessor<AppDatabase>` means "a DatabaseAccessor specialized for the AppDatabase type". The generic parameter tells the DAO which database it belongs to.

## Spread operator (`...`)

Spreads the contents of a list into another list:

```dart
final fruits = ['apple', 'banana'];
final all = ['mango', ...fruits, 'grape'];
// → ['mango', 'apple', 'banana', 'grape']
```

Used in Flutter widgets when building lists of children dynamically:

```dart
Column(
  children: [
    const HeaderWidget(),
    ...accounts.map((a) => AccountCard(account: a)).toList(),
    const FooterWidget(),
  ],
)
```

## Collection `if` and `for`

You can use `if` and `for` inside list literals:

```dart
// Collection if — conditionally include a widget
Column(
  children: [
    const TitleWidget(),
    if (isLoggedIn) const UserProfileWidget(),  // only included if true
    const FooterWidget(),
  ],
)

// Collection for — include a widget per item
Column(
  children: [
    for (final account in accounts)
      AccountCard(account: account),
  ],
)
```

This is how Flutter UIs handle conditional rendering without messy ternary chains.

## The `?` ternary operator

Dart has a standard ternary:
```dart
final label = isExpense ? 'Expense' : 'Income';
```

In Finsight's `accounts_page.dart`:
```dart
color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary
```

## Pattern matching with `switch` expressions (Dart 3+)

Modern Dart has `switch` expressions (not just statements) that return a value:

```dart
// switch expression — evaluates to a value
final color = switch (type) {
  TransactionType.expense    => AppColors.expense,
  TransactionType.income     => AppColors.income,
  TransactionType.investment => AppColors.investment,
};
```

The compiler ensures all enum cases are covered — if you add a new `TransactionType` later and forget to handle it here, you get a compile error.

## `.map()` and `.where()` on lists

These are functional-style methods for transforming and filtering lists:

```dart
final amounts = [100.0, 250.0, 50.0, 300.0];

// .map() — transform each element
final formatted = amounts.map((a) => '₹$a').toList();
// → ['₹100.0', '₹250.0', '₹50.0', '₹300.0']

// .where() — filter elements
final large = amounts.where((a) => a > 100).toList();
// → [250.0, 300.0]

// .fold() — reduce to a single value
final total = amounts.fold(0.0, (sum, a) => sum + a);
// → 700.0
```

In Finsight's `ledger_dao.dart`:
```dart
for (final entry in entries) {
  if (entry.entryType == 'credit') {
    balance += entry.amount;
  } else {
    balance -= entry.amount;
  }
}
```

This could be rewritten with `.fold()`:
```dart
final balance = entries.fold(0.0, (sum, e) =>
  e.entryType == 'credit' ? sum + e.amount : sum - e.amount
);
```

## `late` keyword

Declares a variable that will be initialized before first use, but not at declaration time:

```dart
late String userId;

void init() {
  userId = generateUuid();  // initialized here
}

void doWork() {
  print(userId);  // used here — must be initialized before this runs
}
```

If you access a `late` variable before it's initialized, it throws a runtime error. Use `late` sparingly — prefer `final` with immediate initialization.

---

## Exercises

1. In `lib/database/daos/transactions_dao.dart`, find `setTagsForTransaction`. It uses a `for` loop — could you rewrite the loop body using `.map()`?
2. In `lib/database/daos/ledger_dao.dart`, `computeBalanceForAccount` uses a `for` loop. Rewrite it mentally using `.fold()`.
3. Look at `lib/features/accounts/presentation/pages/accounts_page.dart`. It uses a ternary operator for colors. Can you identify it?

**You've completed Module 01!** Move on to [Module 02 — Flutter Widgets](../02-flutter-widgets/README.md).
