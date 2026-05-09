# Enums

Enums represent a fixed set of named values. In Finsight they are used everywhere to represent types like "expense", "income", or "investment" — things that can only ever be one of a known set of options.

## Basic enum

```dart
enum Color { red, green, blue }

Color myColor = Color.red;

// Comparing
if (myColor == Color.red) {
  print('It is red');
}

// Switch
switch (myColor) {
  case Color.red:   print('red');
  case Color.green: print('green');
  case Color.blue:  print('blue');
}
```

## Rich enums (Dart 2.17+)

Dart enums can carry data and have methods. This is heavily used in Finsight.

Open `lib/core/enums/transaction_type.dart`:

```dart
enum TransactionType {
  expense('expense', 'Expense'),
  income('income', 'Income'),
  investment('investment', 'Investment');

  // Each case has these two values
  const TransactionType(this.value, this.label);

  final String value;   // stored in the database: 'expense'
  final String label;   // shown in UI: 'Expense'

  // A static factory method — creates from a database string
  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown TransactionType: $value'),
    );
  }
}
```

Why is this useful? Without this pattern, you'd need switch statements everywhere:

```dart
// BAD — fragile, verbose, scattered everywhere
String getLabel(String type) {
  switch (type) {
    case 'expense': return 'Expense';
    case 'income':  return 'Income';
    default:        return 'Unknown';
  }
}

// GOOD — use the enum's label property directly
TransactionType.income.label  // → 'Expense'
```

## All four enums in Finsight

| File | Enum | Cases |
|------|------|-------|
| `transaction_type.dart` | `TransactionType` | expense, income, investment |
| `account_type.dart` | `AccountType` | bank_account, credit_card, cash, wallet |
| `investment_type.dart` | `InvestmentType` | mutual_fund, stock, etf, bond, fd, other |
| `ledger_entry_type.dart` | `LedgerEntryType` | debit, credit |

## Using enums in practice

```dart
// Read the label for display
final type = TransactionType.expense;
Text(type.label)   // shows "Expense"

// Convert from a database-stored string to an enum
final dbValue = 'income';  // read from SQLite
final type = TransactionType.fromValue(dbValue);  // → TransactionType.income

// Use in a switch to handle each case differently
Color colorForType(TransactionType type) {
  return switch (type) {
    TransactionType.expense    => AppColors.expense,
    TransactionType.income     => AppColors.income,
    TransactionType.investment => AppColors.investment,
  };
}
```

The `switch` on an enum is **exhaustive** — Dart will give a compile error if you miss any case. This is much safer than switching on a raw `String`.

## `values` and `name`

Every enum automatically has:
```dart
TransactionType.values          // List of all cases: [expense, income, investment]
TransactionType.expense.name    // Built-in name string: 'expense'
TransactionType.expense.index   // Position: 0
```

---

## Exercises

1. Open `lib/core/enums/account_type.dart`. What are all four account types? What `value` does `cash` have?
2. How would you get the label "Credit Card" from the `AccountType` enum?
3. Write a function `iconForAccountType(AccountType type)` using a switch that returns a different `Icons.*` value for each type. (You can look up icon names at [material.io/icons](https://fonts.google.com/icons).)

**Next:** [05-async-futures-streams.md](05-async-futures-streams.md)
