import 'package:drift/drift.dart';

import 'accounts_table.dart';
import 'categories_table.dart';

/// Core table storing all financial transactions (expenses, income, investments).
///
/// Transactions are polymorphic — differentiated by [type]:
/// - expense: Debits amount from the source account
/// - income: Credits amount to the destination account
/// - investment: Debits amount from the source account (tracked separately)
///
/// For investments, [investmentType] specifies the vehicle
/// (mutual_fund, etf, stock, bond, fd, other).
class Transactions extends Table {
  /// UUID primary key (client-generated).
  TextColumn get id => text()();

  /// Transaction type: expense, income, investment.
  TextColumn get type => text()();

  /// Transaction amount (always positive).
  RealColumn get amount => real()();

  /// The account this transaction is associated with.
  TextColumn get accountId =>
      text().references(Accounts, #id)();

  /// The category for this transaction.
  TextColumn get categoryId =>
      text().references(Categories, #id)();

  /// Optional description/note.
  TextColumn get description =>
      text().withDefault(const Constant(''))();

  /// Transaction date (YYYY-MM-DD format).
  TextColumn get date => text()();

  /// Investment vehicle type (only for investment transactions).
  TextColumn get investmentType => text().nullable()();

  /// Timestamp when the transaction was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the transaction was last updated.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
