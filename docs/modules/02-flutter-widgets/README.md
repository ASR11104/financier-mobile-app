# Module 02 — Flutter Widgets

In Flutter, the entire UI is built from **widgets**. Understanding the widget system is the foundation of everything else.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-what-is-a-widget.md](01-what-is-a-widget.md) | What widgets are, the widget tree, immutability |
| [02-stateless-vs-stateful.md](02-stateless-vs-stateful.md) | StatelessWidget, StatefulWidget, when to use each |
| [03-consumer-widget.md](03-consumer-widget.md) | ConsumerWidget from Riverpod — how Finsight widgets work |
| [04-build-context.md](04-build-context.md) | What BuildContext is and how to use it |

## Project files to read alongside this module

- `lib/features/accounts/presentation/pages/accounts_page.dart` — a StatelessWidget page
- `lib/app/app.dart` — a ConsumerWidget
- `lib/app/router.dart` — `ScaffoldWithNavBar` StatelessWidget

## Exercise for this module

After reading all 4 topics, open `lib/features/dashboard/presentation/pages/dashboard_page.dart` and look at its current stub implementation. Try to add a `Text` widget that shows "Total Balance: ₹0.00" centered on the screen. Run the app and verify it appears.
