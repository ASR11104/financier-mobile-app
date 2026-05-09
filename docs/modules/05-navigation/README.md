# Module 05 — Navigation

Finsight uses `go_router` for navigation — a declarative, URL-based router that handles bottom tabs, deep links, and nested routes cleanly.

## Topics in this module

| File | What it covers |
|------|----------------|
| [01-routing-basics.md](01-routing-basics.md) | How URL-based routing works, GoRouter, GoRoute |
| [02-tab-navigation.md](02-tab-navigation.md) | StatefulShellRoute, bottom tabs, preserving state |
| [03-navigating-programmatically.md](03-navigating-programmatically.md) | context.go, context.push, passing parameters |

## Project files to read alongside this module

- `lib/app/router.dart` — the full router setup

## Exercise for this module

Add a new route `/accounts/:id` that shows a placeholder `AccountDetailPage`. When an account is tapped (once we have account cards), it should navigate to `/accounts/some-uuid`. For now, make the page show a `Text` widget that displays the `id` from the route parameters.
