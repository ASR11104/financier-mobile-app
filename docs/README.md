# Finsight — Learning Guide

Learn Android development, Dart, and Flutter by building a real personal finance app.
Every concept links to actual code you can open and run.

---

## Modules

| # | Module | What you learn |
|---|--------|----------------|
| 01 | [Dart Basics](modules/01-dart-basics/README.md) | Variables, functions, classes, enums, async, streams |
| 02 | [Flutter Widgets](modules/02-flutter-widgets/README.md) | The widget system, StatelessWidget, StatefulWidget, ConsumerWidget |
| 03 | [Layouts](modules/03-layouts/README.md) | Scaffold, Column/Row, Container, lists |
| 04 | [Theming](modules/04-theming/README.md) | Material 3, colors, typography, animations |
| 05 | [Navigation](modules/05-navigation/README.md) | go_router, bottom tabs, navigating between screens |
| 06 | [Riverpod](modules/06-riverpod/README.md) | State management, providers, async state |
| 07 | [Database with Drift](modules/07-database/README.md) | SQLite, tables, DAOs, queries, transactions |
| 08 | [Code Generation](modules/08-code-generation/README.md) | build_runner, freezed, generated files |
| 09 | [Architecture](modules/09-architecture/README.md) | Clean Architecture, feature-first folders, DI |
| 10 | [Android Basics](modules/10-android-basics/README.md) | Android project structure, building and running |
| 11 | [Build a Feature](modules/11-build-a-feature/README.md) | Boot sequence walkthrough, full feature end-to-end |

---

## Suggested Learning Path

### Week 1 — Language and UI basics
1. Module 01 — Dart Basics (read all 6 topics)
2. Module 02 — Flutter Widgets
3. Module 03 — Layouts

### Week 2 — Visuals and navigation
4. Module 04 — Theming
5. Module 05 — Navigation

### Week 3 — Data and state
6. Module 07 — Database with Drift
7. Module 06 — Riverpod

### Week 4 — The full system
8. Module 08 — Code Generation
9. Module 09 — Architecture
10. Module 10 — Android Basics
11. Module 11 — Build a Feature

---

## Quick Reference

### Dart
```dart
final x = value;          // immutable variable
const x = literal;        // compile-time constant
String? nullable;          // nullable type
nullable?.method()         // safe call — skips if null
nullable ?? 'default'      // use default if null
..method()                 // cascade — call and return original object
async / await              // non-blocking operations
Future<T>                  // one async value, delivered later
Stream<T>                  // many values delivered over time
```

### Flutter Widgets
```dart
Scaffold(appBar:, body:)   // screen structure
AppBar(title:, actions:)   // top bar
Column/Row(children:)      // vertical / horizontal stack
Container(padding:, color:)// box with styling
Text('hello', style:)      // text
Icon(Icons.home)           // material icon
SizedBox(height: 16)       // spacing
ListView.builder(...)      // scrollable list
Center(child:)             // center its child
```

### Riverpod
```dart
ref.watch(provider)        // subscribe — rebuilds widget on change
ref.read(provider)         // read once — use in callbacks only
asyncValue.when(data:, loading:, error:)
```

### go_router
```dart
context.go('/path')        // navigate (replace history)
context.push('/path')      // push (adds to history)
context.pop()              // go back
```

### Drift ORM
```dart
select(table).get()        // Future — fetch once
select(table).watch()      // Stream — live updates
into(table).insert(...)    // insert a row
update(table).write(...)   // update rows
db.transaction(() async {})// atomic operation
```

### Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
flutter analyze
dart format lib/
```
