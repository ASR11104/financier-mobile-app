import 'package:drift/drift.dart';

import 'accounts_table.dart';
import 'transactions_table.dart';
import 'transfers_table.dart';

/// Double-entry ledger for ensuring data integrity.
///
/// Every money movement creates entries here:
/// - Expense: 1 × DEBIT on the source account
/// - Income: 1 × CREDIT on the destination account
/// - Investment: 1 × DEBIT on the source account
/// - Transfer: 1 × DEBIT on from_account + 1 × CREDIT on to_account
///
/// Each entry stores [runningBalance] — the account balance immediately
/// after this entry, enabling instant historical balance lookups.
///
/// Either [transactionId] or [transferId] is populated, never both.
class LedgerEntries extends Table {
  /// UUID primary key (client-generated).
  TextColumn get id => text()();

  /// The account affected by this entry.
  TextColumn get accountId =>
      text().references(Accounts, #id)();

  /// Link to the source transaction (nullable).
  TextColumn get transactionId =>
      text().nullable().references(Transactions, #id)();

  /// Link to the source transfer (nullable).
  TextColumn get transferId =>
      text().nullable().references(Transfers, #id)();

  /// Entry type: debit or credit.
  TextColumn get entryType => text()();

  /// Entry amount (always positive).
  RealColumn get amount => real()();

  /// Account balance immediately after this entry.
  RealColumn get runningBalance => real()();

  /// Entry date (YYYY-MM-DD format, matches parent date).
  TextColumn get date => text()();

  /// Description (auto-generated from parent or custom).
  TextColumn get description =>
      text().withDefault(const Constant(''))();

  /// Timestamp when the entry was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
