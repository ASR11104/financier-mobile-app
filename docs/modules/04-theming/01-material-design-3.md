# Material Design 3

Material Design is Google's design system — a set of guidelines for colors, typography, spacing, motion, and component behaviour. Flutter ships with a complete implementation of Material components.

## Enabling Material 3

In `lib/app/theme/app_theme.dart`:

```dart
ThemeData(
  useMaterial3: true,    // opt into Material 3 (newer, recommended)
  // ...
)
```

Without this, Flutter uses Material 2. Finsight uses Material 3 throughout.

## ThemeData

`ThemeData` is the complete visual configuration of an app — colors, fonts, shapes, and component defaults. It is passed to `MaterialApp`:

```dart
// lib/app/app.dart
MaterialApp.router(
  theme: AppTheme.lightTheme,       // used in light mode
  darkTheme: AppTheme.darkTheme,    // used in dark mode
  themeMode: ThemeMode.system,      // follow OS setting
)
```

`ThemeMode.system` means the app automatically switches between light and dark based on the user's OS setting — no extra code needed.

## Light and Dark themes

Finsight defines two complete themes in `AppTheme`:

```dart
class AppTheme {
  AppTheme._();   // private constructor — utility class

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,         // #6C63FF
        secondary: AppColors.secondary,     // #00D9A6
        surface: AppColors.darkSurface,     // card/panel backgrounds
        onSurface: AppColors.darkTextPrimary, // text on those surfaces
        error: AppColors.expense,           // error/delete color
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      // ... component-specific overrides
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.expense,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      // ...
    );
  }
}
```

Both themes use the **same primary color** (`#6C63FF`) — the brand identity stays consistent. Only the background, surface, and text colors differ.

## Component-level theme overrides

`ThemeData` lets you customize every Material component. From `app_theme.dart`:

```dart
ThemeData(
  // Card appearance for the whole app:
  cardTheme: CardThemeData(
    color: AppColors.darkCardColor,
    elevation: 0,                         // flat cards (no shadow)
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),  // rounded corners
      side: BorderSide(color: AppColors.darkDivider.withValues(alpha: 0.5)),
    ),
  ),

  // Input fields:
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,        // no visible border line
    ),
  ),

  // FAB:
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
)
```

Setting these once in `ThemeData` means every `Card`, `TextField`, and `FloatingActionButton` in the app gets the same look without repeating the styling code.

## Checking brightness in widgets

From `accounts_page.dart`:

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary
```

This lets individual widgets adapt to the current theme. However, the better practice (once Riverpod providers are in place) is to use `colorScheme.onSurface` instead of manual dark/light checks — it automatically adjusts.

---

**Next:** [02-colors-and-colorscheme.md](02-colors-and-colorscheme.md)
