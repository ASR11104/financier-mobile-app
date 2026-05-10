import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../categories/providers/categories_providers.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../domain/entities/budget_entity.dart';
import '../../providers/budget_providers.dart';
import 'add_budget_sheet.dart';

class BudgetCard extends ConsumerWidget {
  final BudgetWithSpending data;

  const BudgetCard({super.key, required this.data});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text('Remove this budget? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.expense)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(budgetRepositoryProvider).delete(data.budget.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = ref.watch(preferencesProvider).valueOrNull;
    final symbol = prefs?.currencySymbol ?? '₹';
    final categoryAsync =
        ref.watch(categoryByIdProvider(data.budget.categoryId));
    final category = categoryAsync.valueOrNull;

    final percent = data.percentUsed;
    final progressColor = percent >= 1.0
        ? AppColors.expense
        : percent >= 0.75
            ? AppColors.investment
            : AppColors.income;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => AddBudgetSheet(editing: data.budget),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: const Icon(Icons.account_balance_wallet_outlined,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category?.name ?? '…',
                          style: AppTextStyles.labelLarge(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          '${data.budget.period.label}${data.budget.isRecurring ? ' · Recurring' : ''}',
                          style: AppTextStyles.bodySmall(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.formatAmount(data.budget.amount, symbol),
                        style: AppTextStyles.labelLarge(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'budget',
                        style: AppTextStyles.bodySmall(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.expense,
                    tooltip: 'Delete budget',
                    onPressed: () => _confirmDelete(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spent: ${Formatters.formatAmount(data.spent, symbol)}',
                    style: AppTextStyles.bodySmall(color: progressColor),
                  ),
                  if (data.isOverBudget)
                    Text(
                      'Over by ${Formatters.formatAmount(data.overrun, symbol)}',
                      style: AppTextStyles.bodySmall(color: AppColors.expense),
                    )
                  else
                    Text(
                      '${Formatters.formatAmount(data.remaining, symbol)} left',
                      style: AppTextStyles.bodySmall(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
