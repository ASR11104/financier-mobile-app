# Functions

Functions are the building blocks of Dart. Understanding how parameters work is essential because Flutter's widget API relies heavily on named parameters.

## Basic function

```dart
// Return type  name      parameters
String          greet(    String name) {
  return 'Hello, $name!';   // string interpolation with $
}

// Call it:
greet('Akhil');   // → 'Hello, Akhil!'
```

## Arrow functions

When the function body is a single expression, you can replace `{ return expr; }` with `=> expr`:

```dart
// Same as above, shorter
String greet(String name) => 'Hello, $name!';

// Works for any single expression
bool isExpense(String type) => type == 'expense';
```

## Named parameters

Positional parameters are fine for one or two args. For more, use **named parameters** with curly braces `{}`:

```dart
// Named parameters — all optional by default
void printAmount({String symbol = '₹', double amount = 0}) {
  print('$symbol$amount');
}

// Call with names:
printAmount(symbol: '₹', amount: 1500);
printAmount(amount: 500);         // symbol uses default
printAmount();                    // both use defaults
```

Make a named parameter required with `required`:

```dart
void printAmount({required String symbol, required double amount}) {
  print('$symbol$amount');
}

// Now you MUST pass both:
printAmount(symbol: '₹', amount: 1500);  // OK
printAmount(amount: 1500);               // COMPILE ERROR — symbol is required
```

### In Finsight

Open `lib/core/utils/formatters.dart`:

```dart
static String formatSignedAmount(
  double amount,        // positional — passed without a name
  String currencySymbol,// positional
  {
    required bool isPositive,  // named and required
  }
) {
  final formatted = formatAmount(amount.abs(), currencySymbol);
  return isPositive ? '+$formatted' : '-$formatted';
}
```

Called as:
```dart
Formatters.formatSignedAmount(1500, '₹', isPositive: true);
// → '+₹1,500.00'
```

The `isPositive:` name makes the call site readable — you immediately know what `true` means here.

## Optional positional parameters

Wrap in `[]` to make positional parameters optional:

```dart
String greet(String name, [String greeting = 'Hello']) {
  return '$greeting, $name!';
}

greet('Akhil');           // → 'Hello, Akhil!'
greet('Akhil', 'Hi');    // → 'Hi, Akhil!'
```

## Functions as values

In Dart, functions are first-class values — you can pass them as arguments. This is used heavily in Flutter for callbacks:

```dart
// A function that takes another function as a parameter
void doTwice(void Function() action) {
  action();
  action();
}

doTwice(() => print('hello'));  // prints 'hello' twice

// Common in Flutter:
ElevatedButton(
  onPressed: () {
    // This anonymous function runs when the button is tapped
    print('tapped');
  },
  child: Text('Tap me'),
)
```

## String interpolation

Dart uses `$` for string interpolation — embedding values inside strings:

```dart
String name = 'Finsight';
int version = 1;

// Simple variable
'App: $name'             // → 'App: Finsight'

// Expression (use ${})
'v$version.0'            // → 'v1.0'
'v${version + 1}'        // → 'v2'
'${amount.toStringAsFixed(2)}'  // → '1500.50'
```

---

## Exercises

1. Open `lib/core/utils/formatters.dart`. What are the parameter types of `formatDate`? Is `dateStr` positional or named?
2. In `lib/database/daos/accounts_dao.dart`, find `getRecent`. It has a named parameter with a default value — what is it?
3. Write a function `formatCurrency(double amount, {String symbol = '₹'})` that returns `'₹1,500.00'` for `amount = 1500`.

**Next:** [03-classes-and-objects.md](03-classes-and-objects.md)
