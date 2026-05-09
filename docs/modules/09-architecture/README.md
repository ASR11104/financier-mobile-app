# Module 09 — Architecture

Finsight follows Clean Architecture with a feature-first folder structure. This module explains the "why" behind each design choice.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-clean-architecture.md](01-clean-architecture.md) | The layer model, dependency rules, why it matters |
| [02-feature-first-folders.md](02-feature-first-folders.md) | Folder structure, what goes where |
| [03-dependency-injection.md](03-dependency-injection.md) | get_it, injectable, how DI glues layers together |

## Project files to read alongside this module

- `lib/features/` — see the current (incomplete) feature folder structure
- `lib/database/daos/` — these are the data layer's infrastructure
- `CLAUDE.md` in the project root — architecture rules

## Exercise for this module

Scaffold the complete folder structure for the **Transactions** feature. Create the directories and empty files (no implementation yet):

```
lib/features/transactions/
├── domain/
│   ├── entities/transaction.dart      (empty file)
│   └── repositories/i_transaction_repository.dart  (empty file)
├── data/
│   └── repositories/transaction_repository_impl.dart  (empty file)
├── presentation/
│   └── pages/transactions_page.dart  (already exists — leave it)
└── providers/
    └── transactions_providers.dart   (empty file)
```

Use `touch` or just create blank files with a comment inside. The goal is to internalize the folder structure.
