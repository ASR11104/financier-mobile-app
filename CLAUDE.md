# Finsight — Agent Instructions

## Project Overview
Finsight is a personal finance management Android app built with Flutter/Dart.
It uses a **local-first** architecture with SQLite (via Drift ORM) and follows
**Clean Architecture** with a **feature-first** folder structure.

## Tech Stack
- **Framework**: Flutter (latest stable) + Dart
- **Database**: Drift ORM on SQLite (local-only, no backend)
- **State Management**: Riverpod 2.x
- **Navigation**: go_router with StatefulShellRoute for bottom tabs
- **Models**: freezed + json_serializable
- **DI**: get_it + injectable
- **Charts**: fl_chart
- **UI**: Material 3, Google Fonts (Inter), flutter_animate

## Key Commands
```bash
# Get dependencies
flutter pub get

# Code generation (Drift, freezed, injectable, riverpod)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code gen
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## Architecture Rules
1. **Feature-first**: Each feature has `domain/`, `data/`, `presentation/`, `providers/`
2. **Domain layer**: Pure Dart — NO Flutter imports, NO package imports except freezed
3. **Data layer**: Drift DAOs, repository implementations
4. **Presentation layer**: Widgets, pages — consume Riverpod providers
5. **Providers**: Riverpod providers that bridge data and presentation

## Database Rules
1. **Ledger is truth**: Account balances are cached; ledger_entries is the source of truth
2. **Atomic operations**: All balance-affecting operations use DB transactions
3. **UUIDs**: All entities use client-generated UUID v4 as primary key
4. **Soft delete**: Never hard-delete financial data (use is_active flags)

## Coding Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Private members: `_prefixed`
- Constants: `camelCase` (Dart convention)
- Prefer `const` constructors where possible
- Use `final` for local variables
- Single quotes for strings
- Trailing commas for better formatting

## File Naming
- Pages: `*_page.dart`
- Widgets: descriptive name (e.g., `account_card.dart`)
- Providers: `*_providers.dart`
- DAOs: `*_dao.dart`
- Tables: `*_table.dart`
- Entities: singular name (e.g., `account.dart`)
- Repositories: `*_repository.dart` (abstract), `*_repository_impl.dart` (concrete)

## Generated Files
Never manually edit files ending in:
- `.g.dart` (Drift, json_serializable, riverpod_generator, injectable)
- `.freezed.dart` (freezed)

Regenerate with: `dart run build_runner build --delete-conflicting-outputs`

## Current Development State (as of 2026-05-09)

**Done**: Full Drift schema (8 tables, 7 DAOs), GoRouter (5 tabs), Material 3 theme, seed data, all enums, formatters.

**Stubs only**: All 5 feature pages (Dashboard, Transactions, Accounts, Analytics, Settings) are empty placeholder UIs.

**Not yet implemented**: Riverpod providers, domain entities, repository interfaces/impls, DI injectable wiring, tests, CI.

**Implementation order for each feature**: Domain entity (freezed) → Repository interface → Repository impl (uses DAO) → Riverpod providers → Presentation widgets/pages.

## Feature Folder Template

```
lib/features/<feature>/
├── domain/
│   ├── entities/<entity>.dart               # freezed model, pure Dart
│   └── repositories/i_<entity>_repository.dart  # abstract interface
├── data/
│   └── repositories/<entity>_repository_impl.dart
├── presentation/
│   ├── pages/<feature>_page.dart
│   └── widgets/
└── providers/<feature>_providers.dart       # @riverpod annotations
```

## Critical DB Rule

Any operation that changes an account balance **must** use `db.transaction()` and update BOTH `LedgerEntries` AND `Accounts.balance` in the same transaction. The ledger is the source of truth; `balance` is a cache.

