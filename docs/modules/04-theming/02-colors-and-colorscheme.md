# Colors and ColorScheme

Colors in Flutter are `Color` objects. Finsight centralizes all color definitions in `AppColors` and uses Material's `ColorScheme` to make them available throughout the app.

## The Color class

```dart
const Color(0xFF6C63FF)
//          ^^ alpha (opacity): FF = fully opaque, 00 = transparent
//            ^^^^^^ RGB hex: 6C63FF = purple
```

`Color` takes a 32-bit integer in `0xAARRGGBB` format. Always use `0xFF` for fully opaque colors.

You can also use named colors from Flutter's `Colors` class:
```dart
Colors.white
Colors.black
Colors.blue
Colors.red.shade400   // a lighter shade
```

But in Finsight, always use `AppColors` — never hardcode `Colors.blue` in feature code.

## AppColors

Open `lib/app/theme/app_colors.dart`. All colors are `static const` on the `AppColors` class:

```dart
class AppColors {
  AppColors._();  // private — can't be instantiated

  // Brand
  static const primary = Color(0xFF6C63FF);     // purple — buttons, selected states
  static const secondary = Color(0xFF00D9A6);   // teal — accents

  // Semantic — same in both light and dark themes
  static const income = Color(0xFF00C853);      // green
  static const expense = Color(0xFFFF5252);     // red
  static const investment = Color(0xFFFF9800);  // orange
  static const transfer = Color(0xFF2196F3);    // blue

  // Dark theme surfaces
  static const darkBackground = Color(0xFF0D0D1A);   // page background
  static const darkSurface = Color(0xFF1A1A2E);      // cards, nav bar
  static const darkCardColor = Color(0xFF1E1E35);    // card background

  // Dark theme text
  static const darkTextPrimary = Color(0xFFF5F5F5);
  static const darkTextSecondary = Color(0xFFB0B0C8);

  // Light theme surfaces
  static const lightBackground = Color(0xFFF8F9FE);
  static const lightSurface = Color(0xFFFFFFFF);
  // ...
}
```

### Semantic vs surface colors

**Semantic colors** have meaning — `income` (green) always means money coming in, `expense` (red) always means money going out. They don't change between light and dark.

**Surface colors** change between themes — `darkBackground` is nearly black, `lightBackground` is off-white. They provide appropriate contrast for each mode.

## ColorScheme

`ColorScheme` is Material's structured color system. It defines a set of named roles:

| Role | Used for |
|------|----------|
| `primary` | Buttons, selected items, key actions |
| `onPrimary` | Text/icons on top of primary-colored backgrounds |
| `secondary` | Less prominent actions, floating labels |
| `surface` | Card backgrounds, bottom sheets |
| `onSurface` | Text and icons on surface-colored backgrounds |
| `error` | Error states, destructive actions |
| `onError` | Text on error backgrounds |

From `app_theme.dart`:
```dart
colorScheme: const ColorScheme.dark(
  primary: AppColors.primary,
  onPrimary: Colors.white,        // white text on purple buttons
  secondary: AppColors.secondary,
  onSecondary: Colors.black,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkTextPrimary,
  error: AppColors.expense,       // red for errors
  onError: Colors.white,
),
```

### Using ColorScheme in widgets (preferred)

```dart
// Access via context
final cs = Theme.of(context).colorScheme;

Container(
  color: cs.surface,                          // adapts to light/dark automatically
  child: Text('Hello', style: TextStyle(color: cs.onSurface)),
)

ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: cs.primary,
    foregroundColor: cs.onPrimary,
  ),
  onPressed: () {},
  child: const Text('Save'),
)
```

Using `colorScheme` roles instead of direct `AppColors` constants means your widget works correctly in both light and dark mode automatically.

## Opacity

To make a color partially transparent:

```dart
AppColors.primary.withValues(alpha: 0.2)   // 20% opacity — new API (Flutter 3.27+)
AppColors.primary.withOpacity(0.2)         // older API — same result
```

From `app_theme.dart`:
```dart
indicatorColor: AppColors.primary.withValues(alpha: 0.2),
```

This makes the selected tab indicator a very subtle translucent purple.

## Account type colors

Each account type has its own color in `AppColors`:
```dart
static const bankAccount = Color(0xFF2196F3);  // blue
static const creditCard  = Color(0xFFE91E63);  // pink
static const cash        = Color(0xFF4CAF50);  // green
static const wallet      = Color(0xFFFF9800);  // orange
```

These will be used when rendering account cards.

---

**Next:** [03-typography.md](03-typography.md)
