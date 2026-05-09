# Scaffold

`Scaffold` is the base structure for any screen in a Material app. Every page in Finsight returns a `Scaffold`.

## What Scaffold provides

```dart
Scaffold(
  appBar: AppBar(/* top bar */),
  body: /* main content */,
  bottomNavigationBar: NavigationBar(/* bottom tabs */),
  floatingActionButton: FloatingActionButton(/* FAB */),
  drawer: Drawer(/* side menu */),
  endDrawer: Drawer(/* right side menu */),
  backgroundColor: Colors.white,
)
```

You don't need all of these at once — just the ones your screen needs.

## AppBar

The top bar of the screen:

```dart
AppBar(
  title: Text('Accounts'),
  centerTitle: false,     // left-aligned (Material 3 default)
  actions: [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () { /* ... */ },
    ),
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () { /* ... */ },
    ),
  ],
  leading: IconButton(     // left side (usually back button or menu)
    icon: const Icon(Icons.menu),
    onPressed: () { /* ... */ },
  ),
  backgroundColor: AppColors.darkBackground,
  elevation: 0,            // no shadow
)
```

From Finsight's `accounts_page.dart`:
```dart
appBar: AppBar(
  title: Text(
    'Accounts',
    style: AppTextStyles.headlineLarge(
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add Account coming soon!')),
        );
      },
    ),
  ],
),
```

## Body

The main content area below the AppBar:

```dart
Scaffold(
  appBar: AppBar(title: Text('Home')),
  body: Center(
    child: Text('Hello, World!'),
  ),
)
```

The `body` fills all remaining space after the AppBar and bottomNavigationBar.

## FloatingActionButton (FAB)

A circular button that floats above the content, used for the primary action:

```dart
Scaffold(
  body: /* ... */,
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // primary action — e.g., add a transaction
    },
    child: const Icon(Icons.add),
  ),
  // Position it:
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
)
```

## ScaffoldMessenger — for snackbars

`ScaffoldMessenger` manages snackbars across the app. It's accessed via context:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Transaction saved'),
    duration: Duration(seconds: 2),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () { /* undo */ },
    ),
  ),
);
```

## NavigationBar (Material 3 bottom tabs)

From `lib/app/router.dart`, the `ScaffoldWithNavBar` builds the bottom tabs:

```dart
Scaffold(
  body: navigationShell,      // the current tab's page goes here
  bottomNavigationBar: NavigationBar(
    selectedIndex: navigationShell.currentIndex,
    onDestinationSelected: (index) {
      navigationShell.goBranch(index);
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),  // filled icon when selected
        label: 'Dashboard',
      ),
      // ... more destinations
    ],
  ),
)
```

`NavigationDestination` is the Material 3 component for each tab item. Always provide both `icon` (outlined) and `selectedIcon` (filled) for visual feedback.

---

**Next:** [02-column-and-row.md](02-column-and-row.md)
