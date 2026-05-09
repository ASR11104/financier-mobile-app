# Module 08 — Code Generation

Finsight uses several libraries that generate boilerplate Dart code automatically. This module explains what gets generated, why, and how to work with it.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-build-runner.md](01-build-runner.md) | What build_runner does, when to run it, common errors |
| [02-freezed.md](02-freezed.md) | Immutable models with freezed |
| [03-other-generators.md](03-other-generators.md) | riverpod_generator, injectable_generator, json_serializable |

## Project files to read alongside this module

- `lib/database/app_database.dart` — the `part` directive and `@DriftDatabase` annotation
- `lib/database/daos/accounts_dao.dart` — `part` directive and `@DriftAccessor` annotation
- Any `*.g.dart` file in the project — browse the generated code to understand what was created

## Exercise for this module

Create a simple freezed model for a new domain entity. In `lib/features/accounts/domain/entities/account.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required double balance,
  }) = _Account;
}
```

Run `dart run build_runner build --delete-conflicting-outputs` and verify `account.freezed.dart` is created.
