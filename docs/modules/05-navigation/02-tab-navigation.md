# Tab Navigation

Finsight uses `StatefulShellRoute.indexedStack` for the 5-tab bottom navigation. Understanding how it works explains the entire app shell structure.

## The problem with simple bottom tabs

If you naively swap pages when a tab is tapped, each tab loses its scroll position and navigation history when you switch away. `StatefulShellRoute` solves this by keeping all tabs alive simultaneously, just hiding the inactive ones.

## StatefulShellRoute.indexedStack

From `lib/app/router.dart`:

```dart
StatefulShellRoute.indexedStack(
  // This builds the shell — the persistent wrapper around all tabs
  builder: (context, state, navigationShell) {
    return ScaffoldWithNavBar(navigationShell: navigationShell);
  },
  // Each branch is one tab
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsPage(),
        ),
      ],
    ),
    // ... 3 more branches
  ],
),
```

**`indexedStack`**: All tab pages exist in memory simultaneously (like an `IndexedStack` widget — only one is visible at a time, but all are built). Switching tabs is instantaneous.

**`StatefulShellBranch`**: Each branch maintains its own navigation history. If you navigate from `/transactions` to `/transactions/detail/some-id`, then switch to another tab and back — you return to `/transactions/detail/some-id`, not `/transactions`.

## ScaffoldWithNavBar — the shell widget

```dart
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The current tab's page fills the body
      body: navigationShell,

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,  // which tab is active
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            // If tapping the current tab, go to its initial route (scroll-to-top behavior)
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),     // unselected
            selectedIcon: Icon(Icons.dashboard),      // selected (filled)
            label: 'Dashboard',
          ),
          // ...
        ],
      ),
    );
  }
}
```

`navigationShell.goBranch(index)` switches to the tab at that index. The `initialLocation: true` argument means "if I'm already on this tab, go back to the root of this tab's stack" — standard behavior for tapping an already-active tab.

## NavigationDestination vs NavigationBarItem

Material 3 uses `NavigationDestination` inside a `NavigationBar`. Material 2 used `BottomNavigationBarItem` inside `BottomNavigationBar`. Always use the Material 3 versions in Finsight.

## Adding a tab

To add a new tab to Finsight, you need to:
1. Create the new page in `lib/features/<feature>/presentation/pages/`
2. Add a `StatefulShellBranch` to the branches list in `router.dart`
3. Add a `NavigationDestination` to `ScaffoldWithNavBar`

The order of branches and destinations must match.

---

**Next:** [03-navigating-programmatically.md](03-navigating-programmatically.md)
