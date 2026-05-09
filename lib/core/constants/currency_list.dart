/// Supported currencies with their codes, symbols, and names.
class CurrencyItem {
  const CurrencyItem({
    required this.code,
    required this.symbol,
    required this.name,
  });

  final String code;
  final String symbol;
  final String name;
}

/// List of commonly used currencies.
const List<CurrencyItem> supportedCurrencies = [
  CurrencyItem(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  CurrencyItem(code: 'USD', symbol: '\$', name: 'US Dollar'),
  CurrencyItem(code: 'EUR', symbol: '€', name: 'Euro'),
  CurrencyItem(code: 'GBP', symbol: '£', name: 'British Pound'),
  CurrencyItem(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  CurrencyItem(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
  CurrencyItem(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
  CurrencyItem(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
  CurrencyItem(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
  CurrencyItem(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
  CurrencyItem(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
  CurrencyItem(code: 'SAR', symbol: '﷼', name: 'Saudi Riyal'),
  CurrencyItem(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
  CurrencyItem(code: 'MXN', symbol: 'Mex\$', name: 'Mexican Peso'),
  CurrencyItem(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
  CurrencyItem(code: 'THB', symbol: '฿', name: 'Thai Baht'),
  CurrencyItem(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
  CurrencyItem(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
  CurrencyItem(code: 'PHP', symbol: '₱', name: 'Philippine Peso'),
  CurrencyItem(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
];
