import 'package:intl/intl.dart';

/// Utility functions for formatting currency and dates.
class Formatters {
  Formatters._();

  /// Formats an amount with the given currency symbol.
  ///
  /// Example: formatAmount(1500.50, '₹') → "₹1,500.50"
  static String formatAmount(double amount, String currencySymbol) {
    final formatter = NumberFormat('#,##0.00');
    return '$currencySymbol${formatter.format(amount)}';
  }

  /// Formats an amount with sign indicator for display.
  ///
  /// Example: formatSignedAmount(1500, '₹', isPositive: true) → "+₹1,500.00"
  static String formatSignedAmount(
    double amount,
    String currencySymbol, {
    required bool isPositive,
  }) {
    final formatted = formatAmount(amount.abs(), currencySymbol);
    return isPositive ? '+$formatted' : '-$formatted';
  }

  /// Formats a date string (YYYY-MM-DD) for display.
  ///
  /// Example: formatDate('2026-04-29') → "29 Apr 2026"
  static String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formats a date string for short display.
  ///
  /// Example: formatDateShort('2026-04-29') → "29 Apr"
  static String formatDateShort(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('dd MMM').format(date);
  }

  /// Returns today's date as a storage-format string (YYYY-MM-DD).
  static String todayAsString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Formats a DateTime as a storage-format string (YYYY-MM-DD).
  static String dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Formats a large number in compact form.
  ///
  /// Example: formatCompact(150000) → "1.5L" (for INR) or "150K"
  static String formatCompact(double amount) {
    final formatter = NumberFormat.compact();
    return formatter.format(amount);
  }
}
