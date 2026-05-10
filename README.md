# Finsight

A local-first personal finance app for Android built with Flutter. Track expenses, income, investments, and account transfers with double-entry ledger integrity — every balance is derived from immutable ledger entries, never stored as a mutable counter.

---

## Features

| Tab | Description |
|---|---|
| **Dashboard** | Net Worth, Cash & Bank, Credit Dues, monthly income/expense summary, recent transactions |
| **Transactions** | Full ledger with All / Expense / Income / Investment / Transfers tabs |
| **Accounts** | Bank accounts, cash wallets, credit cards; transfers via FAB |
| **Analytics** | Monthly income/expense bar chart; spending-by-category pie chart; Budgets; Goals |
| **Settings** | Currency, theme (light/dark/system), category and tag management, App Lock |

---

## Tech stack

| Role | Package | Version |
|---|---|---|
| UI framework | Flutter (Material 3) | stable |
| Database | Drift (SQLite) | ^2.22.1 |
| State management | Riverpod 2.x | ^2.6.1 |
| Navigation | go_router | ^14.8.1 |
| Dependency injection | get_it + injectable | ^8.0.3 / ^2.5.0 |
| Data models | freezed | ^2.5.7 |
| Charts | fl_chart | ^0.70.2 |
| Fonts | Google Fonts (Inter) | ^6.2.1 |
| Animations | flutter_animate | ^4.5.2 |

---

## Getting started

```bash
# 1. Clone and fetch dependencies
git clone https://github.com/ASR11104/financier-mobile-app.git
cd financier-mobile-app
flutter pub get

# 2. Run code generation (Drift, freezed, Riverpod, injectable)
dart run build_runner build --delete-conflicting-outputs

# 3. Run on a connected Android device or emulator
flutter run
```

---

## Project structure

```
lib/
├── app/                      # App entry, router, Material 3 theme
├── core/
│   ├── di/                   # get_it + injectable wiring
│   ├── enums/                # AccountType, TransactionType, InvestmentType, …
│   ├── services/             # TransactionLedgerService (shared atomic write logic)
│   ├── utils/                # Formatters (amounts, dates, month prefix)
│   └── widgets/              # Shared UI: EmptyState, IconPicker, ColorPicker, AppLockScreen
├── database/
│   ├── tables/               # 10 Drift table definitions
│   ├── daos/                 # 9 Data Access Objects
│   ├── app_database.dart     # AppDatabase (entry point for Drift)
│   └── seed_data.dart        # Default categories seeded on first launch
└── features/
    ├── accounts/
    ├── analytics/
    ├── budgets/
    ├── categories/
    ├── dashboard/
    ├── goals/
    ├── settings/
    ├── tags/
    ├── transactions/
    └── transfers/
        # Each feature:
        # ├── domain/entities/        freezed entity
        # ├── domain/repositories/    abstract interface
        # ├── data/repositories/      Drift-backed implementation
        # ├── providers/              @riverpod generated providers
        # └── presentation/           pages + widgets
```

---

## Testing

```bash
# Linux — libsqlite3-dev required (or create the symlink below once):
mkdir -p ~/.local/lib
ln -sf /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 ~/.local/lib/libsqlite3.so

LD_LIBRARY_PATH=$HOME/.local/lib flutter test
```

Tests use an in-memory Drift database (`AppDatabase.forTesting(NativeDatabase.memory())`).
See `test/helpers/test_database.dart`.

---

## CI

GitHub Actions runs on every push and pull request to `main`:

```
flutter pub get → build_runner → flutter analyze → flutter test
```

See [`.github/workflows/flutter.yml`](.github/workflows/flutter.yml).

---

## Status

Phases 0–12 complete (Phase 2 done): full CRUD, edit flows, budgets & goals tracking, credit card liability accounting, Net Worth dashboard, App Lock (biometric/PIN), icon/color pickers, 21 tests, CI green.

For architecture details see [`ARCHITECTURE.md`](ARCHITECTURE.md).  
For agent/contributor conventions see [`CLAUDE.md`](CLAUDE.md).
