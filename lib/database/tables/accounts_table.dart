import 'package:drift/drift.dart';

/// Stores bank accounts, credit cards, cash, and digital wallets.
///
/// For non-credit-card types, [balance] holds the current balance.
/// For credit cards, [creditLimit] stores the max credit available
/// and [amountUsed] tracks how much is currently used.
/// Both [balance] and [amountUsed] are denormalized caches —
/// the ledger_entries table is the source of truth.
class Accounts extends Table {
  /// UUID primary key (client-generated).
  TextColumn get id => text()();

  /// Display name (e.g., "HDFC Savings", "ICICI Credit Card").
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Account type: bank_account, credit_card, cash, wallet.
  TextColumn get type => text()();

  /// Current balance for bank_account, cash, wallet types.
  /// Not used for credit_card type.
  RealColumn get balance => real().withDefault(const Constant(0.0))();

  /// Maximum credit available (credit_card type only).
  RealColumn get creditLimit => real().nullable()();

  /// Amount currently used on credit card (credit_card type only).
  /// Available credit = creditLimit - amountUsed.
  RealColumn get amountUsed => real().nullable()();

  /// Icon identifier for UI display.
  TextColumn get icon => text().withDefault(const Constant('wallet'))();

  /// Hex color code for UI display (e.g., "#4CAF50").
  TextColumn get color => text().withDefault(const Constant('#4CAF50'))();

  /// Whether the account is active (1) or archived (0).
  IntColumn get isActive =>
      integer().withDefault(const Constant(1))();

  /// Optional notes about the account.
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// Timestamp when the account was created.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the account was last updated.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
