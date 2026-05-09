# Variables and Null Safety

Dart is a **strongly typed** language — every variable has a type, and the compiler catches type mismatches before you run the app.

## Declaring variables

```dart
// Explicit type
String name = 'Finsight';
int count = 10;
double amount = 1500.50;
bool isActive = true;

// Type inferred by the compiler (you don't write the type)
var title = 'Dashboard';    // Dart infers this is a String

// List (array)
List<String> currencies = ['INR', 'USD', 'EUR'];

// Map (dictionary / object)
Map<String, double> rates = {'USD': 83.5, 'EUR': 90.2};
```

## `final` vs `const` vs `var`

These three are the most important keywords for declaring variables:

```dart
var count = 0;
count = 1;     // OK — var can be reassigned

final name = 'Finsight';
name = 'other'; // ERROR — final cannot be reassigned after first assignment

const pi = 3.14159;
pi = 3;         // ERROR — const is a compile-time constant
```

**When to use which:**
- `const` — for values known at compile time: string literals, numbers, `Color(0xFF...)`. Stored in the binary, never allocated on the heap.
- `final` — for values computed once at runtime: a UUID, a DateTime, a database instance.
- `var` — rarely. Prefer explicit types or `final`.

**In practice**, you'll mostly use `final` for local variables and `const` for widget constructors and color/style definitions.

## Null safety

This is Dart's most important feature. By default, a variable **cannot** be `null`:

```dart
String name = 'hello';
name = null;   // COMPILE ERROR — name cannot be null
```

To allow `null`, add `?` after the type:

```dart
String? nickname = null;   // OK — nullable
nickname = 'Akhil';        // also OK
```

### Working with nullable values

```dart
String? city;

// Option 1: null-aware access (?.)
// Only calls .length if city is not null. Returns null otherwise.
int? len = city?.length;

// Option 2: null coalescing (??)
// Use 'Unknown' if city is null
String display = city ?? 'Unknown';

// Option 3: null assertion (!)
// CRASHES if city is null — only use when you are 100% certain
int len = city!.length;  // dangerous — avoid

// Option 4: if-check
if (city != null) {
  print(city.length);  // inside the if, Dart knows city is not null
}
```

### Why this matters in Finsight

Open `lib/database/tables/accounts_table.dart`:

```dart
RealColumn get creditLimit => real().nullable()();
RealColumn get amountUsed  => real().nullable()();
```

`creditLimit` and `amountUsed` are nullable because only credit card accounts have them. When your code reads an `Account` object, Dart forces you to handle the case where these are `null` before using them.

---

## Exercises

1. In `lib/core/constants/app_constants.dart`, what type is `maxTransactionCount`? Is it `const` or `final`?
2. Open `lib/database/tables/transactions_table.dart`. Which columns are nullable and why does that make sense?
3. Write a small Dart snippet (mentally) that safely reads `account.creditLimit` and displays `'No limit'` if it's null.

**Next:** [02-functions.md](02-functions.md)
