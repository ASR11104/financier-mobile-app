import 'package:drift/drift.dart';

/// Singleton row storing app-wide user preferences.
///
/// This table always has exactly one row (id = 1).
/// Currency code/symbol stored here are read by all formatting functions.
/// Changing currency only updates the display symbol — no data conversion.
class UserPreferences extends Table {
  /// Always 1 (singleton row).
  IntColumn get id =>
      integer().withDefault(const Constant(1))();

  /// Currency code (e.g., "INR", "USD", "EUR").
  TextColumn get currencyCode =>
      text().withDefault(const Constant('INR'))();

  /// Currency symbol (e.g., "₹", "\$", "€").
  TextColumn get currencySymbol =>
      text().withDefault(const Constant('₹'))();

  /// Theme mode: light, dark, system.
  TextColumn get themeMode =>
      text().withDefault(const Constant('system'))();

  /// Timestamp when preferences were created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when preferences were last updated.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
