# Module 01 — Dart Basics

Dart is the programming language Flutter uses. Before touching Flutter widgets, you need to be comfortable with Dart — its type system, functions, classes, and async model.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-variables-and-null-safety.md](01-variables-and-null-safety.md) | Variables, types, `final`, `const`, null safety |
| [02-functions.md](02-functions.md) | Parameters, named args, arrow functions |
| [03-classes-and-objects.md](03-classes-and-objects.md) | Classes, constructors, getters, private members |
| [04-enums.md](04-enums.md) | Enums, rich enums with data |
| [05-async-futures-streams.md](05-async-futures-streams.md) | `async/await`, `Future`, `Stream` |
| [06-dart-special-syntax.md](06-dart-special-syntax.md) | Cascade (`..`), generics, useful operators |

## Project files to read alongside this module

- `lib/core/enums/transaction_type.dart` — rich enum example
- `lib/core/utils/formatters.dart` — static class, string interpolation
- `lib/database/daos/accounts_dao.dart` — `Future` and `Stream` in action

## Exercise for this module

After reading all 6 topics, open `lib/core/utils/formatters.dart` and add a new method:

```dart
/// Formats a double as a percentage string.
/// Example: formatPercent(0.156) → "15.6%"
static String formatPercent(double value) {
  // your implementation here
}
```

Run `flutter analyze` to verify no errors.
