# Lists and Grids

Most screens in Finsight show lists — accounts, transactions, categories. Flutter has several scrollable list widgets.

## ListView.builder — the workhorse

For any list with dynamic content, use `ListView.builder`. It's **lazy** — only builds the widgets currently visible on screen, making it efficient for long lists:

```dart
ListView.builder(
  itemCount: accounts.length,
  itemBuilder: (context, index) {
    final account = accounts[index];
    return AccountCard(account: account);
  },
)
```

`itemBuilder` is called with the `index` of each item as it becomes visible. For 1000 accounts, only ~10 `AccountCard` widgets exist in memory at once.

### Common options

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (ctx, i) => ItemWidget(item: items[i]),
  padding: const EdgeInsets.all(16),           // outer padding
  separatorBuilder: null,                       // use ListView.separated instead
  reverse: false,                               // top-to-bottom
  physics: const NeverScrollableScrollPhysics(), // disable scrolling (for nested lists)
  shrinkWrap: true,                             // take only needed height (for nested lists)
)
```

## ListView.separated — with dividers

When you want a divider between items:

```dart
ListView.separated(
  itemCount: transactions.length,
  itemBuilder: (ctx, i) => TransactionTile(transaction: transactions[i]),
  separatorBuilder: (ctx, i) => const Divider(height: 1),
)
```

## ListView (direct children)

For short, fixed lists — just put the children directly:

```dart
ListView(
  children: [
    ListTile(title: Text('Currency'), trailing: Text('INR ₹')),
    ListTile(title: Text('Theme'), trailing: Text('System')),
    ListTile(title: Text('About')),
  ],
)
```

## ListTile — standard list item

Material's standard list row: icon + title + subtitle + trailing widget:

```dart
ListTile(
  leading: Icon(Icons.account_balance, color: AppColors.bankAccount),
  title: Text('HDFC Savings'),
  subtitle: Text('Bank Account'),
  trailing: Text('₹25,000', style: TextStyle(fontWeight: FontWeight.bold)),
  onTap: () => context.push('/accounts/hdfc-id'),
)
```

Perfect for transaction lists, settings menus, category lists.

## GridView.builder

For grid layouts (2 or more columns):

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,      // 2 columns
    crossAxisSpacing: 12,   // horizontal gap
    mainAxisSpacing: 12,    // vertical gap
    childAspectRatio: 1.5,  // width / height ratio of each cell
  ),
  itemCount: categories.length,
  itemBuilder: (ctx, i) => CategoryCard(category: categories[i]),
)
```

In Finsight, the category picker (when adding a transaction) will likely use a `GridView`.

## SingleChildScrollView

For a screen that might overflow but doesn't have a dynamic list — scroll a fixed layout:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      SummaryCard(),
      const SizedBox(height: 16),
      RecentTransactionsList(),
      // ...many more fixed widgets
    ],
  ),
)
```

Use this for forms and detail pages. Don't use it with a `ListView` — that creates nested scrolling conflicts.

## CustomScrollView and Slivers

For advanced scrolling (collapsing headers, mixed content types):

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text('Dashboard'),
      floating: true,        // hides when scrolling down
      expandedHeight: 200,   // expands with an image/chart
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => TransactionTile(transaction: transactions[i]),
        childCount: transactions.length,
      ),
    ),
  ],
)
```

The dashboard page will likely use `CustomScrollView` with a `SliverAppBar` that reveals summary charts as you scroll up.

## Pull-to-refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    // re-fetch data
    await ref.refresh(accountsProvider.future);
  },
  child: ListView.builder(/* ... */),
)
```

Wrapping a list in `RefreshIndicator` adds pull-to-refresh with the native platform spinner.

---

## Exercises

1. Look at `lib/features/settings/presentation/pages/settings_page.dart`. What widget would be best for a settings list — `ListView` or `ListView.builder`? Why?
2. Build a transaction tile using `ListTile`: leading colored circle with the category icon, title = description, subtitle = date, trailing = formatted amount with red/green color.
3. Why must you never nest a `ListView` inside a `Column` without setting `shrinkWrap: true` or a fixed height on the ListView?

**You've completed Module 03!** Move on to [Module 04 — Theming](../04-theming/README.md).
