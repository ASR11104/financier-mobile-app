# What is a Widget?

In Flutter, **everything on screen is a widget** — the page itself, a button, some text, an icon, the padding around a button, the color of a box. Even invisible layout helpers are widgets.

## Widgets are descriptions, not the actual UI

A widget is not the rendered pixel. It's a lightweight Dart object that **describes** what should be on screen. Flutter reads that description and renders it using its graphics engine.

Think of it like this:
- **HTML**: `<button>Click me</button>` describes a button. The browser renders it.
- **Flutter**: `ElevatedButton(child: Text('Click me'))` describes a button. Flutter renders it.

Because widgets are just descriptions (immutable Dart objects), creating thousands of them is cheap. Flutter builds, compares, and discards widget objects many times per second.

## The widget tree

Widgets are nested inside each other, forming a tree. The root is `FinsightApp`, which contains `MaterialApp.router`, which contains the current page, which contains a `Scaffold`, which contains an `AppBar` and a `Column`, and so on.

```
FinsightApp
└── MaterialApp.router
    └── ScaffoldWithNavBar
        ├── NavigationBar
        └── AccountsPage
            └── Scaffold
                ├── AppBar
                │   └── Text('Accounts')
                └── Center
                    └── Column
                        ├── Icon(...)
                        ├── SizedBox(height: 16)
                        ├── Text('No Accounts Yet')
                        └── Text('Add your bank accounts...')
```

You can visualize this in Android Studio / VS Code using the **Flutter Widget Inspector** (run the app, then open DevTools).

## Widgets are immutable

Once created, a widget object cannot change. If the data behind it changes, Flutter creates a **new** widget object and rebuilds the relevant part of the tree.

This sounds expensive, but Flutter is very efficient at it — it only rebuilds what changed, and the rebuild process is extremely fast because widget objects are lightweight.

## The three widget types

| Type | Description | When to use |
|------|-------------|-------------|
| `StatelessWidget` | No internal state. Build once. | Pure display widgets with no user interaction state |
| `StatefulWidget` | Holds mutable state. Rebuilds when state changes. | Animations, forms, local UI state |
| `ConsumerWidget` | Like StatelessWidget but can read Riverpod providers. | Any page/widget that needs app-wide state (data from DB) |

In Finsight, most pages will be `ConsumerWidget` because they read from the database via Riverpod.

## Everything is a widget — examples

```dart
// Structural
Scaffold, AppBar, BottomNavigationBar, Drawer

// Layout
Column, Row, Stack, Wrap, Flex
Center, Align, Padding, SizedBox, Expanded, Flexible

// Display
Text, Icon, Image, Card, Divider, CircularProgressIndicator

// Input
TextFormField, ElevatedButton, IconButton, Switch, Checkbox, Slider

// Decoration
Container, DecoratedBox, ClipRRect, ColoredBox, Opacity

// Scroll
ListView, GridView, SingleChildScrollView, CustomScrollView
```

All of these are just Dart classes. You compose them by nesting.

---

**Next:** [02-stateless-vs-stateful.md](02-stateless-vs-stateful.md)
