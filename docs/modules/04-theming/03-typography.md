# Typography

Finsight uses the **Inter** typeface via Google Fonts and defines a custom text style system in `AppTextStyles`.

## TextStyle basics

```dart
TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w600,   // w100 (thin) to w900 (black)
  color: Colors.white,
  letterSpacing: 0.5,            // space between letters
  height: 1.5,                   // line height multiplier
  decoration: TextDecoration.underline,
)
```

Apply a style to `Text`:
```dart
Text(
  '₹25,000.00',
  style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.income,
  ),
)
```

## Google Fonts — Inter

Flutter's built-in fonts are generic. Finsight uses **Inter** — a clean, highly readable sans-serif designed for UIs.

In `app_theme.dart`, Inter is applied to the whole app's text theme:
```dart
textTheme: GoogleFonts.interTextTheme(
  ThemeData.dark().textTheme,
),
```

This replaces all default text styles with Inter variants. Every `Text` widget in the app uses Inter automatically.

You can also use it inline for one-off styles:
```dart
style: GoogleFonts.inter(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: AppColors.primary,
)
```

## TextTheme — Material's text scale

Material Design defines a scale of text roles. Access them via the theme:

```dart
final textTheme = Theme.of(context).textTheme;

textTheme.displayLarge    // 57px — very large headlines
textTheme.displayMedium   // 45px
textTheme.headlineLarge   // 32px — page titles
textTheme.headlineMedium  // 28px
textTheme.headlineSmall   // 24px
textTheme.titleLarge      // 22px — dialog titles
textTheme.titleMedium     // 16px
textTheme.bodyLarge       // 16px — body text
textTheme.bodyMedium      // 14px
textTheme.bodySmall       // 12px
textTheme.labelLarge      // 14px — button labels
textTheme.labelSmall      // 11px — captions
```

Usage:
```dart
Text('No Accounts Yet', style: Theme.of(context).textTheme.headlineMedium)
```

## AppTextStyles — Finsight's custom styles

Open `lib/app/theme/app_text_styles.dart`. Finsight defines factory functions for each style, accepting a required `color` parameter:

```dart
// Usage from accounts_page.dart:
Text(
  'No Accounts Yet',
  style: AppTextStyles.headlineMedium(
    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
  ),
)
```

The `AppTextStyles` functions return pre-configured `TextStyle` objects with Inter font and specific sizes/weights. The `color` parameter lets each call site pick the appropriate color for its theme context.

Custom styles for financial amounts:
```dart
// Large balance display (e.g., ₹25,000.00)
AppTextStyles.amountLarge(color: AppColors.income)

// Transaction amount in a list
AppTextStyles.amountMedium(color: AppColors.expense)
```

## FontWeight values

```dart
FontWeight.w100  // Thin
FontWeight.w200  // Extra Light
FontWeight.w300  // Light
FontWeight.w400  // Regular (same as FontWeight.normal)
FontWeight.w500  // Medium
FontWeight.w600  // Semi Bold
FontWeight.w700  // Bold (same as FontWeight.bold)
FontWeight.w800  // Extra Bold
FontWeight.w900  // Black
```

In Finsight:
- Headings use `w600` or `w700`
- Body text uses `w400`
- Captions and labels use `w400`
- Amount values use `w600` or `w700` to stand out

## Rich text

For text with mixed styles (e.g., "Balance: **₹25,000**"):

```dart
RichText(
  text: TextSpan(
    style: DefaultTextStyle.of(context).style,
    children: [
      const TextSpan(text: 'Balance: '),
      TextSpan(
        text: '₹25,000',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.income,
        ),
      ),
    ],
  ),
)
```

---

**Next:** [04-animations.md](04-animations.md)
