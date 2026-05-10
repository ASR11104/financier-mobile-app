import 'package:drift/drift.dart';

import 'categories_table.dart';

/// Stores per-category spending budgets.
///
/// Budgets can be monthly or yearly and optionally recurring.
/// Spending is calculated live from the [Transactions] table — this row
/// only holds the limit, period, and metadata.
class Budgets extends Table {
  TextColumn get id => text()();

  /// The expense category this budget applies to.
  TextColumn get categoryId => text().references(Categories, #id)();

  /// Budget limit for the chosen period.
  RealColumn get amount => real()();

  /// 'monthly' or 'yearly'.
  TextColumn get period => text().withDefault(const Constant('monthly'))();

  /// If true, the budget resets automatically each period.
  IntColumn get isRecurring =>
      integer().withDefault(const Constant(1))();

  /// Anchor date for the period (first day of the period when created).
  DateTimeColumn get startDate => dateTime()();

  /// Soft-disable without deleting.
  IntColumn get isActive =>
      integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
