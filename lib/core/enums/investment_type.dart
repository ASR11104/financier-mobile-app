/// Enumerates the types of investment vehicles.
enum InvestmentType {
  mutualFund('mutual_fund', 'Mutual Fund'),
  stock('stock', 'Stock'),
  etf('etf', 'ETF'),
  bond('bond', 'Bond'),
  fixedDeposit('fd', 'Fixed Deposit'),
  other('other', 'Other');

  const InvestmentType(this.value, this.label);

  /// The string value stored in the database.
  final String value;

  /// Human-readable label for display in UI.
  final String label;

  /// Creates an [InvestmentType] from its database string value.
  static InvestmentType fromValue(String value) {
    return InvestmentType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown InvestmentType: $value'),
    );
  }
}
