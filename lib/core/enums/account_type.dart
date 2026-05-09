/// Enumerates the types of financial accounts supported by the app.
enum AccountType {
  bankAccount('bank_account', 'Bank Account'),
  creditCard('credit_card', 'Credit Card'),
  cash('cash', 'Cash'),
  wallet('wallet', 'Wallet');

  const AccountType(this.value, this.label);

  /// The string value stored in the database.
  final String value;

  /// Human-readable label for display in UI.
  final String label;

  /// Creates an [AccountType] from its database string value.
  static AccountType fromValue(String value) {
    return AccountType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown AccountType: $value'),
    );
  }
}
