import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../providers/dashboard_providers.dart';

class BalanceCard extends ConsumerWidget {
  final String currencySymbol;

  const BalanceCard({super.key, this.currencySymbol = '₹'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpense = ref.watch(monthlyExpenseProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: AppTextStyles.bodyMedium(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Formatters.formatAmount(totalBalance, currencySymbol),
              style: AppTextStyles.amountLarge(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MonthlyChip(
                  label: 'Income',
                  amount: monthlyIncome,
                  color: AppColors.income,
                  icon: Icons.arrow_downward_rounded,
                  currencySymbol: currencySymbol,
                ),
                const SizedBox(width: 12),
                _MonthlyChip(
                  label: 'Expenses',
                  amount: monthlyExpense,
                  color: AppColors.expense,
                  icon: Icons.arrow_upward_rounded,
                  currencySymbol: currencySymbol,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final String currencySymbol;

  const _MonthlyChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.currencySymbol,
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
                  Text(label,
                      style: AppTextStyles.labelSmall(color: color)),
                  Text(
                    Formatters.formatAmount(amount, currencySymbol),
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
