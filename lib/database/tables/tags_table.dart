import 'package:drift/drift.dart';

/// Stores user-created tags for fine-grain transaction labeling.
///
/// Tags provide sub-classification within categories. For example,
/// a "Food & Dining" category transaction can be tagged with
/// "swiggy", "takeout", "restaurant", etc.
class Tags extends Table {
  /// UUID primary key (client-generated).
  TextColumn get id => text()();

  /// Tag name (e.g., "swiggy", "work-lunch", "amazon").
  TextColumn get name => text().withLength(min: 1, max: 50)();

  /// Hex color code for UI display.
  TextColumn get color => text().withDefault(const Constant('#9C27B0'))();

  /// Timestamp when the tag was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
