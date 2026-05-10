import 'package:drift/drift.dart';

/// Stores savings goals.
///
/// [currentAmount] is a cached sum kept in sync with linked investment
/// transactions (goalId set on the Transactions row). It mirrors the
/// Account.balance pattern: the ledger is truth, this is a fast cache.
class Goals extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get description =>
      text().withDefault(const Constant(''))();

  /// The amount the user wants to accumulate.
  RealColumn get targetAmount => real()();

  /// Cached sum of all linked investment transactions.
  RealColumn get currentAmount =>
      real().withDefault(const Constant(0.0))();

  /// Optional deadline.
  DateTimeColumn get targetDate => dateTime().nullable()();

  /// Default investment type for contributions (e.g. 'mutual_fund', 'fd').
  TextColumn get preferredInvestmentType => text().nullable()();

  /// Icon identifier (matches existing icon picker values).
  TextColumn get icon =>
      text().withDefault(const Constant('star'))();

  /// Hex color (e.g. '#6C63FF').
  TextColumn get color =>
      text().withDefault(const Constant('#6C63FF'))();

  /// 1 when currentAmount >= targetAmount.
  IntColumn get isCompleted =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
