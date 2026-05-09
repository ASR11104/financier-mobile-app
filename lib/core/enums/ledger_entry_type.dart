/// Enumerates the types of ledger entries (double-entry bookkeeping).
enum LedgerEntryType {
  debit('debit', 'Debit'),
  credit('credit', 'Credit');

  const LedgerEntryType(this.value, this.label);

  /// The string value stored in the database.
  final String value;

  /// Human-readable label for display in UI.
  final String label;

  /// Creates a [LedgerEntryType] from its database string value.
  static LedgerEntryType fromValue(String value) {
    return LedgerEntryType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Unknown LedgerEntryType: $value'),
    );
  }
}
