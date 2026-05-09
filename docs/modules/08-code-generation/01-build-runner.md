# build_runner

`build_runner` is the tool that runs code generation for all the annotation-based libraries in Finsight. You run it from the terminal; it scans your Dart files and generates `.g.dart` and `.freezed.dart` files.

## When to run it

Run `dart run build_runner build --delete-conflicting-outputs` after any of these:

| Change | What regenerates |
|--------|-----------------|
| Add or modify a Drift `Table` class | `app_database.g.dart`, `*_dao.g.dart` |
| Add or modify a Drift `@DriftAccessor` DAO | `*_dao.g.dart` |
| Add or modify a `@freezed` model | `*.freezed.dart` |
| Add or modify a `@riverpod` annotated function | `*_providers.g.dart` |
| Add or modify an `@injectable` annotated class | `injectable.config.dart` |

If you see a red underline on `_$SomeClass` or `_SomeClassMixin`, it means the generated file is missing or outdated — run `build_runner`.

## Commands

```bash
# One-time build (use after making annotation changes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerates when you save a file)
dart run build_runner watch --delete-conflicting-outputs
```

`--delete-conflicting-outputs` removes any previously generated files that would conflict — always include this flag to avoid errors.

## The `part` directive

Generated files are connected to your source file via `part`:

```dart
// In app_database.dart:
part 'app_database.g.dart';   // tells Dart: this file is part of my library

// In accounts_dao.dart:
part 'accounts_dao.g.dart';
```

The generated file (`app_database.g.dart`) contains Dart code that references things in `app_database.dart` — they share the same library. The `part` declaration makes this possible.

**Never edit files with `.g.dart` or `.freezed.dart` extensions** — `build_runner` overwrites them.

## What gets generated

For a Drift DAO like `AccountsDao`, the generator creates `accounts_dao.g.dart` containing:

```dart
// Generated — do not edit
mixin _$AccountsDaoMixin on DatabaseAccessor<AppDatabase> {
  Accounts get accounts => attachedDatabase.accounts;
  // + helpers for the query builder API
}
```

The `with _$AccountsDaoMixin` in your DAO class mixes this in, giving you access to the `accounts` table variable.

For `@DriftDatabase`, the generator creates the `_$AppDatabase` base class with the `accountsDao`, `transactionsDao` accessors and all the schema creation SQL.

## Common errors

**"Type '_$SomeClass' not found"** — run `build_runner build`.

**"The file '*.g.dart' already exists"** — run with `--delete-conflicting-outputs`.

**"Undefined getter 'accounts'"** inside a DAO — `part 'accounts_dao.g.dart'` is missing from the top of the file, or `build_runner` hasn't been run yet.

**Build runs forever** — use `build` instead of `watch` when you want a one-shot generation.

## The watch command

During active development, use `watch` to regenerate automatically every time you save:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Keep this running in a terminal while you work. Each time you save a Dart file with annotations, it regenerates the affected `.g.dart` files. You'll see output like `[INFO] Done after X seconds`.

---

**Next:** [02-freezed.md](02-freezed.md)
