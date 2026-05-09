/// Enumerates the types of financial transactions.
enum TransactionType {
  expense('expense', 'Expense'),
  income('income', 'Income'),
  investment('investment', 'Investment');

  const TransactionType(this.value, this.label);

  /// The string value stored in the database.
  final String value;

  /// Human-readable label for display in UI.
  final String label;

  /// Creates a [TransactionType] from its database string value.
  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown TransactionType: $value'),
    );
  }
}
