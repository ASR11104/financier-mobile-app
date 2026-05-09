# Module 03 — Layouts

Layout widgets position and size other widgets. You can't build a screen without them.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-scaffold.md](01-scaffold.md) | Scaffold — the base screen structure |
| [02-column-and-row.md](02-column-and-row.md) | Column, Row — vertical and horizontal stacking |
| [03-container-and-sizing.md](03-container-and-sizing.md) | Container, Padding, SizedBox, Expanded, Stack |
| [04-lists-and-grids.md](04-lists-and-grids.md) | ListView, GridView — scrollable content |

## Project files to read alongside this module

- `lib/features/accounts/presentation/pages/accounts_page.dart` — Scaffold, Column, Icon, Text layout
- `lib/app/router.dart` — `ScaffoldWithNavBar` showing bottom nav layout

## Exercise for this module

Open `lib/features/dashboard/presentation/pages/dashboard_page.dart`. Replace the current placeholder with a screen that has:
1. An `AppBar` with title "Dashboard"
2. A `Column` centered on screen with:
   - A large icon (`Icons.savings`)
   - Text "Total Balance"
   - Bold text "₹0.00"

Use `SizedBox` for spacing between elements.
