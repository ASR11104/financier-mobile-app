# Module 04 — Theming

Finsight uses Material Design 3 with a custom color palette, Inter typography, and smooth animations. This module explains how the visual system works.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-material-design-3.md](01-material-design-3.md) | What Material 3 is, ThemeData, light/dark modes |
| [02-colors-and-colorscheme.md](02-colors-and-colorscheme.md) | AppColors, ColorScheme, using colors correctly |
| [03-typography.md](03-typography.md) | TextStyle, TextTheme, AppTextStyles, Google Fonts |
| [04-animations.md](04-animations.md) | flutter_animate, entrance animations |

## Project files to read alongside this module

- `lib/app/theme/app_theme.dart` — full ThemeData definitions
- `lib/app/theme/app_colors.dart` — all color constants
- `lib/app/theme/app_text_styles.dart` — typography system
- `lib/features/accounts/presentation/pages/accounts_page.dart` — uses flutter_animate

## Exercise for this module

Add a new semantic color to `AppColors` for "Transfer" operations — use `Color(0xFF2196F3)` (blue). Then update `app_theme.dart` to apply it somewhere (e.g., as the `tertiary` color in the ColorScheme).
