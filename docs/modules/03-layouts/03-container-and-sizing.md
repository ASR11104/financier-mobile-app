# Container, Padding, SizedBox, and Stack

These widgets control sizing, spacing, and decoration without adding content themselves.

## Container

The most flexible layout widget. Combines size, padding, margin, color, and shape in one:

```dart
Container(
  width: 200,
  height: 100,
  padding: const EdgeInsets.all(16),            // space inside the border
  margin: const EdgeInsets.symmetric(vertical: 8), // space outside
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(12),     // rounded corners
    border: Border.all(color: Colors.grey),
    boxShadow: [
      BoxShadow(color: Colors.black26, blurRadius: 8),
    ],
  ),
  child: Text('Hello'),
)
```

`Container` with only `color` is equivalent to `ColoredBox` — prefer `ColoredBox` when you only need a color (it's more efficient).

### EdgeInsets — spacing values

```dart
EdgeInsets.all(16)                         // 16 on all sides
EdgeInsets.symmetric(horizontal: 16, vertical: 8)  // different H and V
EdgeInsets.only(left: 16, top: 8)         // specific sides
EdgeInsets.fromLTRB(16, 8, 16, 0)        // left, top, right, bottom
```

## Padding

Adds padding around a child without the full power of `Container`. Prefer it when you only need padding (simpler and more readable):

```dart
// Instead of:
Container(padding: const EdgeInsets.all(16), child: Text('hello'))

// Prefer:
Padding(
  padding: const EdgeInsets.all(16),
  child: Text('hello'),
)
```

## SizedBox

Forces a specific width and/or height:

```dart
SizedBox(width: 100, height: 50, child: ElevatedButton(...))

// Common use — spacing:
const SizedBox(height: 16)   // 16px vertical gap
const SizedBox(width: 8)     // 8px horizontal gap

// Expand to fill all available space:
const SizedBox.expand(child: Text('fills everything'))
```

`SizedBox` for spacing is idiomatic Flutter — you'll see it in every `Column` and `Row`.

## ClipRRect — rounded corners

Clips its child to a rounded rectangle. Used for image thumbnails, card content:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(8),
  child: Image.asset('avatar.png', width: 48, height: 48),
)
```

## Stack

Overlays widgets on top of each other. Like CSS `position: absolute`:

```dart
Stack(
  children: [
    // Background (rendered first, at the bottom)
    Container(color: AppColors.primary, width: double.infinity, height: 200),

    // Content on top
    Positioned(
      bottom: 16,
      left: 16,
      child: Text('HDFC Savings', style: TextStyle(color: Colors.white)),
    ),

    // Top-right corner badge
    Positioned(
      top: 8,
      right: 8,
      child: Chip(label: Text('Active')),
    ),
  ],
)
```

`Positioned` only works inside a `Stack`. Use it to place children at exact coordinates.

## ConstrainedBox, FractionallySizedBox

For responsive sizing:

```dart
// At most 300px wide, at least 100px tall:
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 300, minHeight: 100),
  child: TextField(),
)

// Take 80% of the available width:
FractionallySizedBox(
  widthFactor: 0.8,
  child: ElevatedButton(/* ... */),
)
```

## The box model mental model

Think of each widget as a box:

```
┌─────────────────────────────┐
│           margin            │
│  ┌───────────────────────┐  │
│  │        border         │  │
│  │  ┌─────────────────┐  │  │
│  │  │    padding      │  │  │
│  │  │  ┌───────────┐  │  │  │
│  │  │  │  content  │  │  │  │
│  │  │  └───────────┘  │  │  │
│  │  └─────────────────┘  │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

- **margin** (outside) = space between this widget and others
- **border** = the visual edge (via `BoxDecoration`)
- **padding** (inside) = space between the border and content
- **content** = the child widget

---

## Exercises

1. How would you create a card with a colored left border, like a category tag? (Hint: `BoxDecoration` with `Border.only(left: ...)`)
2. In `lib/app/router.dart`, `ScaffoldWithNavBar` doesn't use any `Container` or `Padding`. How does content spacing work in Scaffold instead?
3. Build a badge widget: a circle with a colored background and white text in the center, using `Container` with `BoxDecoration(shape: BoxShape.circle)`.

**Next:** [04-lists-and-grids.md](04-lists-and-grids.md)
