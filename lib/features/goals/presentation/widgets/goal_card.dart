import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../domain/entities/goal_entity.dart';
import '../../providers/goal_providers.dart';

class GoalCard extends ConsumerWidget {
  final GoalEntity goal;

  const GoalCard({super.key, required this.goal});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Goal'),
        content: const Text('Remove this goal? This cannot be undone.'),
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
      await ref.read(goalRepositoryProvider).delete(goal.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = ref.watch(preferencesProvider).valueOrNull;
    final symbol = prefs?.currencySymbol ?? '₹';

    final percent =
        goal.targetAmount > 0 ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0) : 0.0;
    final goalColor = AppColors.fromHex(goal.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/analytics/goals/${goal.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: goalColor.withValues(alpha: 0.2),
                    child: Icon(Icons.flag_outlined, color: goalColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: AppTextStyles.labelLarge(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        if (goal.targetDate != null)
                          Text(
                            'By ${Formatters.formatDate(goal.targetDate!.toIso8601String().substring(0, 10))}',
                            style: AppTextStyles.bodySmall(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (goal.isCompleted)
                    const Icon(Icons.check_circle, color: AppColors.income),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: AppColors.expense,
                    tooltip: 'Delete goal',
                    onPressed: () => _confirmDelete(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      goal.isCompleted ? AppColors.income : goalColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.formatAmount(goal.currentAmount, symbol),
                    style: AppTextStyles.bodySmall(color: goalColor),
                  ),
                  Text(
                    '${(percent * 100).toStringAsFixed(0)}% of ${Formatters.formatAmount(goal.targetAmount, symbol)}',
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
