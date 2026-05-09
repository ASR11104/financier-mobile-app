import 'package:drift/drift.dart';

/// Stores transaction categories (e.g., Food, Transport, Salary).
///
/// Each category is typed (expense, income, investment) to filter
/// appropriately in transaction forms. Pre-seeded categories have
/// [isDefault] set to 1 and cannot be deleted by users.
class Categories extends Table {
  /// UUID primary key (client-generated).
  TextColumn get id => text()();

  /// Category name (e.g., "Food & Dining", "Salary").
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// Category type: expense, income, investment.
  TextColumn get type => text()();

  /// Icon identifier for UI display.
  TextColumn get icon => text().withDefault(const Constant('tag'))();

  /// Hex color code for UI display.
  TextColumn get color => text().withDefault(const Constant('#2196F3'))();

  /// Display ordering (lower numbers appear first).
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether this is a pre-seeded default category (1) or user-created (0).
  IntColumn get isDefault =>
      integer().withDefault(const Constant(0))();

  /// Timestamp when the category was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
