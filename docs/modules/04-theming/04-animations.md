# Animations with flutter_animate

`flutter_animate` adds smooth entrance animations with a simple chaining API. It wraps any widget and you chain effects onto it.

## Basic usage

Call `.animate()` on any widget, then chain effects:

```dart
Text('Hello')
  .animate()
  .fadeIn(duration: 600.ms)     // fade from transparent to opaque
```

From `lib/features/accounts/presentation/pages/accounts_page.dart`:

```dart
Icon(Icons.account_balance_wallet_rounded, size: 64)
    .animate()
    .fadeIn(duration: 600.ms)
    .scale(begin: const Offset(0.8, 0.8))  // scale from 80% → 100%

Text('No Accounts Yet')
    .animate()
    .fadeIn(delay: 200.ms, duration: 600.ms)  // starts 200ms after the icon

Text('Add your bank accounts...')
    .animate()
    .fadeIn(delay: 400.ms, duration: 600.ms)  // staggered: 400ms delay
```

The stagger (200ms, 400ms delays) makes items appear one after another — a polished UX touch.

## The `.ms` extension

`flutter_animate` adds `.ms` and `.seconds` extensions to numbers:

```dart
600.ms       // Duration(milliseconds: 600)
1.5.seconds  // Duration(milliseconds: 1500)
```

## Common effects

```dart
widget
  .animate()
  .fadeIn()                             // opacity 0 → 1
  .fadeOut()                            // opacity 1 → 0
  .slideX(begin: -1, end: 0)           // slide from left (-1 = full width away)
  .slideY(begin: 1, end: 0)            // slide from bottom
  .scale(begin: Offset(0.5, 0.5))      // scale up from 50%
  .rotate(begin: -0.1)                  // slight rotation
  .blur(begin: Offset(8, 8), end: Offset.zero)  // blur → sharp
  .shimmer(duration: 1200.ms)          // shimmer effect (for loading skeletons)
  .shake()                             // shake animation (for errors)
```

## Chaining effects — they run simultaneously

By default, chained effects run **at the same time**:

```dart
Text('Hello')
  .animate()
  .fadeIn(duration: 400.ms)   // fades in while also scaling up
  .scale(begin: Offset(0.8, 0.8), duration: 400.ms)
```

## Delay — staggered animations

Use `delay` to start an effect after a pause:

```dart
// List items appearing one by one:
for (int i = 0; i < items.length; i++)
  ItemWidget(item: items[i])
    .animate()
    .fadeIn(delay: (100 * i).ms)  // item 0: 0ms, item 1: 100ms, item 2: 200ms...
```

## Repeat and loop

```dart
Icon(Icons.sync)
  .animate(onPlay: (controller) => controller.repeat())
  .rotate(duration: 1.seconds)  // spin forever
```

## Flutter's built-in animation system

`flutter_animate` wraps Flutter's lower-level animation system. You don't need to learn the low-level system at first — use `flutter_animate` for most animations. But when you need custom animations (e.g., a custom graph being drawn), you'll use `AnimationController` + `Tween` + `AnimatedBuilder`. That's covered later when we implement the analytics charts.

## Hero animations — transitions between screens

For images or cards that animate between screens (like tapping a card and it "flies" to the detail page):

```dart
// On the list screen:
Hero(
  tag: 'account-${account.id}',  // unique tag
  child: AccountCard(account: account),
)

// On the detail screen:
Hero(
  tag: 'account-${account.id}',  // same tag
  child: LargeAccountHeader(account: account),
)
```

Flutter automatically animates between these two. The `tag` must match and be unique.

---

## Exercises

1. Open `lib/features/accounts/presentation/pages/accounts_page.dart`. The three elements have staggered delays of 0ms, 200ms, and 400ms. Change them to 0ms, 100ms, 300ms and observe the difference.
2. Add a `.slideY(begin: 0.3)` effect alongside the existing `.fadeIn()` on the icon. This makes it appear to rise from slightly below.
3. Read the `flutter_animate` README (the package page has good examples). What effect would you use for a "loading skeleton" state?

**You've completed Module 04!** Move on to [Module 05 — Navigation](../05-navigation/README.md).
