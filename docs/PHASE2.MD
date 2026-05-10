# Phase 2 — Completion Summary

Phase 2 added security, planning, and credit-card awareness on top of the Phase 1 foundation (Phases 0–11).

---

## Features delivered

### App Lock
- Toggle in Settings to enable/disable biometric or PIN lock.
- `BiometricAuthService` wraps `local_auth`; injected via get_it.
- `AppLockScreen` shown on cold start and resume when lock is enabled.
- `kDebugMode` bypass so the emulator (no screen lock enrolled) can still toggle and test the flow.

### Budget tracking
- Create / edit / delete budgets per expense category with a monthly or yearly period.
- `BudgetsView` (Analytics tab) shows each budget as a card: progress bar, amount spent vs limit, days remaining, over-budget warning.
- `budgetsWithSpendingProvider` — sync Riverpod provider that watches both `budgetsProvider` and `transactionsProvider`. Builds a `categoryId → spent` map once per period (O(M)), then looks up each budget in O(1). Total: O(M+N) instead of the naïve O(M×N).

### Goals tracking
- Create / edit / delete savings goals with target amount and optional deadline.
- Goals can be linked to investment transactions (`goalId` FK on transactions); each contribution increments the goal's `currentAmount` cache atomically inside `db.transaction()`.
- `GoalCard` shows a progress ring, current vs target amount, and days remaining.
- `GoalDetailPage` (/analytics/goals/:id) shows a monthly contribution bar chart and a monthly-contribution suggestion ("add ₹X/month to reach your goal on time") updated dynamically as contributions are made.
- Goal auto-completes (`isCompleted = true`) when `currentAmount >= targetAmount`.

### Credit card liability & Net Worth
- Expense transactions charged to a credit card now increment `accounts.amount_used` (outstanding credit used).
- Deleting such a transaction decrements `amount_used` (clamped to ≥ 0).
- Dashboard **Balance Card** redesigned:
  - **Net Worth** (primary, large) = Cash & Bank total − Credit Dues
  - **Cash & Bank** sub-row — sum of non-credit-card account balances
  - **Credit Dues** sub-row — sum of `amount_used` across all credit card accounts
  - Monthly **Income** and **Expenses** chips below the divider

---

## Bugs fixed during Phase 2

| Bug | Root cause | Fix |
|---|---|---|
| `DropdownButtonFormField` assertion crash on add-transaction sheet | Stale `AccountEntity`/`CategoryEntity` reference after stream re-emission; `freezed` structural equality broke the `items.contains(value)` check | Resolve dropdown value from the live list by ID each build |
| `StateError` crash when opening analytics with a budget | `categorySpending` used `firstWhere(orElse: throw)` against an empty category list | Replaced with `expand` + `firstOrNull`; silently skips unmapped categories |
| Budget not appearing after creation | `budgetsWithSpendingProvider` watched only the transaction stream, not the budget stream | Rewrote as sync provider watching both streams |
| App lock toggle always disabled on emulator | `local_auth.canAuthenticate()` returns false without an enrolled screen lock | Added `kDebugMode` bypass on both the toggle and the lock-screen gate |
| Goal detail FAB label overflow | `FloatingActionButton.extended` label exceeded button width on small screens | Replaced with plain `FloatingActionButton` (icon only), consistent with the rest of the app |
| `reverseTransaction` raw string comparison | `row.type == TransactionType.expense.value` compared a raw string to an enum — always false | Fixed to `TransactionType.fromValue(row.type) == TransactionType.expense` |

---

## Code quality improvements (post-Phase 2 /simplify review)

- `AppColors.fromHex(String hex)` — consolidated from three per-file `_parseColor` helpers in `goal_card.dart`, `goal_detail_page.dart`, and `budget_card.dart`.
- `Formatters.currentMonthPrefix()` — consolidated from four hand-rolled `DateFormat('yyyy-MM').format(now)` calls across analytics, dashboard, budget, and goal providers.
- `budgetsWithSpendingProvider` algorithm changed from O(N×M) nested filter to O(M+N) spend-map lookup.
- `categorySpendingProvider` in analytics changed from O(N×M) to the same spend-map pattern.
- `TransactionLedgerService` — shared `@lazySingleton` service that owns all atomic ledger-write logic; both `TransactionRepositoryImpl` and `GoalRepositoryImpl` delegate to it, eliminating duplication.

---

## APK build

```bash
# Single universal APK (larger, works on all architectures):
flutter build apk --release

# Smaller, split per CPU architecture (recommended for distribution):
flutter build apk --release --split-per-abi
```

Output location: `build/app/outputs/flutter-apk/`

The split build produces three APKs:
- `app-armeabi-v7a-release.apk` — 32-bit ARM (older devices)
- `app-arm64-v8a-release.apk`  — 64-bit ARM (most modern Android phones)
- `app-x86_64-release.apk`    — x86-64 (emulators)
