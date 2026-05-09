import 'package:drift/drift.dart';

import 'accounts_table.dart';

/// Stores inter-account transfers.
///
/// Each transfer generates exactly 2 ledger entries
/// (debit on source, credit on destination) within a
/// single database transaction for atomicity.
class Transfers extends Table {
  /// UUID primary key (client-generated).
  TextColumn get id => text()();

  /// The account money is transferred from.
  @ReferenceName('transfersFrom')
  TextColumn get fromAccountId =>
      text().references(Accounts, #id)();

  /// The account money is transferred to.
  @ReferenceName('transfersTo')
  TextColumn get toAccountId =>
      text().references(Accounts, #id)();

  /// Transfer amount (always positive).
  RealColumn get amount => real()();

  /// Optional description/note.
  TextColumn get description =>
      text().withDefault(const Constant(''))();

  /// Transfer date (YYYY-MM-DD format).
  TextColumn get date => text()();

  /// Timestamp when the transfer was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
