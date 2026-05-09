# Module 11 — Build a Feature

This module ties everything together. First you'll trace how the entire app boots up, then you'll see the complete pattern for implementing a feature end-to-end.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-boot-sequence.md](01-boot-sequence.md) | How the app starts, line by line through main.dart and app.dart |
| [02-accounts-feature-end-to-end.md](02-accounts-feature-end-to-end.md) | Complete Accounts feature: domain → data → providers → UI |

## Project files to read alongside this module

- `lib/main.dart` — the starting point
- `lib/app/app.dart` — the root widget
- `lib/app/router.dart` — routing setup
- `lib/database/seed_data.dart` — first-launch data
- All database DAOs in `lib/database/daos/`

## Capstone exercise

After reading both topics, implement the complete **Accounts** feature:

1. Create the `Account` domain entity (freezed)
2. Create `IAccountRepository` interface
3. Create `AccountRepositoryImpl` (wraps `AccountsDao`)
4. Create Riverpod providers
5. Update `AccountsPage` to be a `ConsumerWidget` showing real data
6. Create a basic `AccountCard` widget

Use the end-to-end guide in `02-accounts-feature-end-to-end.md` as your reference. When you're done, you'll have your first real working feature — the accounts list reading live from the local database.
