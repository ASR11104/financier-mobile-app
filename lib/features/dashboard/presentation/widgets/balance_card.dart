import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../providers/dashboard_providers.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider).valueOrNull;
    final symbol = prefs?.currencySymbol ?? '₹';

    final netWorth = ref.watch(netWorthProvider);
    final cashAndBank = ref.watch(totalBalanceProvider);
    final creditDues = ref.watch(creditCardLiabilityProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpense = ref.watch(monthlyExpenseProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth',
              style: AppTextStyles.bodyMedium(color: secondaryText),
            ),
            const SizedBox(height: 4),
            Text(
              Formatters.formatAmount(netWorth, symbol),
              style: AppTextStyles.amountLarge(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _SubItem(
                  label: 'Cash & Bank',
                  amount: cashAndBank,
                  color: AppColors.income,
                  symbol: symbol,
                ),
                const SizedBox(width: 12),
                _SubItem(
                  label: 'Credit Dues',
                  amount: creditDues,
                  color: creditDues > 0 ? AppColors.expense : secondaryText,
                  symbol: symbol,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                _MonthlyChip(
                  label: 'Income',
                  amount: monthlyIncome,
                  color: AppColors.income,
                  icon: Icons.arrow_downward_rounded,
                  symbol: symbol,
                ),
                const SizedBox(width: 12),
                _MonthlyChip(
                  label: 'Expenses',
                  amount: monthlyExpense,
                  color: AppColors.expense,
                  icon: Icons.arrow_upward_rounded,
                  symbol: symbol,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SubItem extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String symbol;

  const _SubItem({
    required this.label,
    required this.amount,
    required this.color,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            Formatters.formatAmount(amount, symbol),
            style: AppTextStyles.labelMedium(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MonthlyChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final String symbol;

  const _MonthlyChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelSmall(color: color)),
                  Text(
                    Formatters.formatAmount(amount, symbol),
                    style: AppTextStyles.labelMedium(color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
