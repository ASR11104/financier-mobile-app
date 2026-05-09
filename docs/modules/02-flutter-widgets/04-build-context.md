# BuildContext

`BuildContext` is passed to every `build()` method. It's a reference to the widget's current position in the widget tree — a handle that lets you look "up" the tree to find inherited data.

## What it is

```dart
@override
Widget build(BuildContext context) {
  //                  ^^^^^^^ handle to this widget's position in the tree
```

Flutter maintains the widget tree as a hierarchy. `BuildContext` is like GPS coordinates — it tells Flutter where this widget lives in the tree, so when you ask "give me the current theme", Flutter walks up from your widget's position to find the nearest `Theme` ancestor.

## Common uses

### 1. Accessing the theme

```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;
final textTheme = theme.textTheme;

// In Finsight (accounts_page.dart):
final isDark = Theme.of(context).brightness == Brightness.dark;
```

### 2. Checking screen size

```dart
final size = MediaQuery.of(context).size;
final width = size.width;
final height = size.height;

// Is this a tablet?
final isTablet = width > 600;
```

### 3. Showing snackbars and dialogs

```dart
// Show a snackbar (from accounts_page.dart):
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Add Account coming soon!')),
);

// Show a dialog:
showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
    title: const Text('Delete account?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(ctx).pop(),
        child: const Text('Cancel'),
      ),
    ],
  ),
);
```

### 4. Navigation

```dart
// With go_router (the Finsight way):
context.go('/accounts');
context.push('/transactions/new');
context.pop();
```

## The `of(context)` pattern

You'll see `Something.of(context)` everywhere in Flutter. This is the **InheritedWidget** pattern — a way to pass data down the widget tree without threading it through every constructor.

```dart
Theme.of(context)            // finds the nearest Theme ancestor
MediaQuery.of(context)       // finds the nearest MediaQuery (screen info)
Navigator.of(context)        // finds the nearest Navigator
ScaffoldMessenger.of(context)// finds the nearest ScaffoldMessenger
```

These all search **up** the tree from the current context position. This is why context matters — the same `Theme.of(context)` call in different positions in the tree might return different themes.

## Context gotchas

### Don't use context across async gaps

```dart
// BAD — context might be invalid after the await
Future<void> saveAndNavigate() async {
  await repository.save(account);
  context.go('/accounts');  // DANGEROUS — widget might be gone
}

// GOOD — check if still mounted
Future<void> saveAndNavigate() async {
  await repository.save(account);
  if (!context.mounted) return;  // check before using context
  context.go('/accounts');
}
```

### Context from a `builder` parameter

Some widgets give you a new context via their `builder` callback. Use that inner context, not the outer one, for operations that must be relative to that widget:

```dart
Builder(
  builder: (innerContext) {
    // Use innerContext here, not the outer context
    return ElevatedButton(
      onPressed: () => ScaffoldMessenger.of(innerContext).showSnackBar(/* */),
      child: const Text('Show snackbar'),
    );
  },
)
```

---

## Exercises

1. Open `lib/features/accounts/presentation/pages/accounts_page.dart`. Find the line that uses `Theme.of(context)`. What specifically is being read from the theme?
2. The accounts page shows a snackbar when the "Add Account" button is pressed. Find that code. What method is used to show it?
3. In your own words: why does `Theme.of(context)` work without you explicitly passing the theme to every widget?

**You've completed Module 02!** Move on to [Module 03 — Layouts](../03-layouts/README.md).
