# Column and Row

`Column` stacks widgets vertically. `Row` stacks them horizontally. These two are the workhorses of Flutter layout.

## Column

```dart
Column(
  children: [
    Text('First'),
    Text('Second'),
    Text('Third'),
  ],
)
```

By default, a `Column` is as tall as its children combined and as wide as its widest child.

### Alignment

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,   // vertical centering (along the column)
  crossAxisAlignment: CrossAxisAlignment.start,  // left-align (perpendicular to column)
  children: [/* ... */],
)
```

`mainAxis` is the axis the widgets stack along — vertical for Column, horizontal for Row.
`crossAxis` is the perpendicular axis — horizontal for Column, vertical for Row.

| `mainAxisAlignment` | Effect |
|---|---|
| `start` | Pack children at the top (default) |
| `end` | Pack children at the bottom |
| `center` | Center children vertically |
| `spaceBetween` | Equal space between children |
| `spaceAround` | Equal space around children |
| `spaceEvenly` | Equal space everywhere |

| `crossAxisAlignment` | Effect |
|---|---|
| `start` | Left-align children |
| `end` | Right-align children |
| `center` | Center children horizontally (default) |
| `stretch` | Stretch children to fill full width |

### From `accounts_page.dart`

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.account_balance_wallet_rounded, size: 64),
    const SizedBox(height: 16),
    Text('No Accounts Yet'),
    const SizedBox(height: 8),
    Text('Add your bank accounts, credit cards, or cash'),
  ],
)
```

This centers the column vertically on screen and centers children horizontally (default).

## Row

Exactly like Column but horizontal:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text('Balance'),
    Text('₹1,500.00'),
  ],
)
```

Common pattern for a label on the left and a value on the right — used everywhere in finance UIs.

## Spacing between children

Two approaches:

```dart
// SizedBox — explicit spacing
Column(
  children: [
    Text('A'),
    const SizedBox(height: 16),  // 16 logical pixels of space
    Text('B'),
  ],
)

// mainAxisAlignment — distributes space automatically
Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [Text('A'), Text('B'), Text('C')],  // equal space around all
)
```

Use `SizedBox` when you need a specific gap between two particular elements. Use `mainAxisAlignment` when you want the spacing rule to apply to all children uniformly.

The `gap` package (in Finsight's dependencies) provides `Gap(16)` as a shorthand for `SizedBox(height: 16)` inside a Column or `SizedBox(width: 16)` inside a Row:
```dart
Column(
  children: [
    Text('A'),
    const Gap(16),  // automatically uses height for Column, width for Row
    Text('B'),
  ],
)
```

## Expanded and Flexible

Inside a Column or Row, children normally only take as much space as they need. `Expanded` forces a child to take all remaining space:

```dart
Row(
  children: [
    Text('Label'),          // takes only what it needs
    Expanded(               // takes all remaining width
      child: TextField(),
    ),
  ],
)
```

`Flexible` is like `Expanded` but the child can be smaller than the available space:

```dart
Row(
  children: [
    Flexible(flex: 1, child: Container(color: Colors.red)),   // 1/3 width
    Flexible(flex: 2, child: Container(color: Colors.blue)),  // 2/3 width
  ],
)
```

## Nesting

Real UIs combine `Column` and `Row`:

```dart
// An account card:
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('HDFC Savings'),          // account name
            Icon(Icons.account_balance),   // account icon
          ],
        ),
        const SizedBox(height: 8),
        Text('₹25,000.00'),                // balance
        Text('Bank Account'),              // type label
      ],
    ),
  ),
)
```

---

## Exercises

1. In `lib/features/accounts/presentation/pages/accounts_page.dart`, the `Column` uses `MainAxisAlignment.center`. What does this produce visually?
2. How would you create a row that shows "Income" on the left and "+₹5,000" on the right edge?
3. If you have a `Column` inside a `Column`, does the inner Column fill the width of the outer? Try it with `crossAxisAlignment: CrossAxisAlignment.stretch`.

**Next:** [03-container-and-sizing.md](03-container-and-sizing.md)
