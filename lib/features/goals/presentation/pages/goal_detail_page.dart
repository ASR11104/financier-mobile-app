import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../../providers/goal_providers.dart';
import '../widgets/add_contribution_sheet.dart';
import '../widgets/add_goal_sheet.dart';

class GoalDetailPage extends ConsumerWidget {
  final String goalId;

  const GoalDetailPage({super.key, required this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = ref.watch(preferencesProvider).valueOrNull;
    final symbol = prefs?.currencySymbol ?? '₹';
    final progress = ref.watch(goalProgressProvider(goalId));
    final goal = progress.goal;
    final contribAsync = ref.watch(goalContributionsProvider(goalId));

    if (goal.id.isEmpty || goal.name.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final goalColor = _parseColor(goal.color);

    return Scaffold(
      appBar: AppBar(
        title: Text(goal.name, style: AppTextStyles.headlineLarge()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (_) => AddGoalSheet(editing: goal),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatAmount(goal.currentAmount, symbol),
                          style: AppTextStyles.amountLarge(color: goalColor),
                        ),
                        Text(
                          'of ${Formatters.formatAmount(goal.targetAmount, symbol)}',
                          style: AppTextStyles.bodyMedium(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.percent,
                        minHeight: 12,
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          goal.isCompleted ? AppColors.income : goalColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (progress.encouragementMessage != null)
                      Text(
                        progress.encouragementMessage!,
                        style: AppTextStyles.bodySmall(
                            color: AppColors.income),
                      ),
                    if (goal.targetDate != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
                          const SizedBox(width: 4),
                          Text(
                            'Target: ${Formatters.formatDate(goal.targetDate!.toIso8601String().substring(0, 10))}',
                            style: AppTextStyles.bodySmall(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          if (progress.monthsLeft != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '(${progress.monthsLeft} months left)',
                              style: AppTextStyles.bodySmall(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (progress.suggestedMonthly != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Save ${Formatters.formatAmount(progress.suggestedMonthly!, symbol)}/month to reach your goal',
                        style: AppTextStyles.bodySmall(
                          color: goalColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cumulative savings chart
            contribAsync.when(
              data: (contribs) {
                if (contribs.isEmpty) return const SizedBox.shrink();
                final spots = _buildChartSpots(contribs);
                if (spots.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Savings Progress',
                        style: AppTextStyles.headlineSmall()),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: goalColor,
                              barWidth: 3,
                              belowBarData: BarAreaData(
                                show: true,
                                color: goalColor.withValues(alpha: 0.15),
                              ),
                              dotData: const FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Contributions list
            Text('Contributions', style: AppTextStyles.headlineSmall()),
            const SizedBox(height: 8),
            contribAsync.when(
              data: (contribs) {
                if (contribs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No contributions yet',
                        style: AppTextStyles.bodyMedium(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contribs.length,
                  itemBuilder: (_, i) =>
                      TransactionTile(transaction: contribs[i]),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: goal.isCompleted
          ? null
          : FloatingActionButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => AddContributionSheet(goal: goal),
              ),
              child: const Icon(Icons.add),
            ),
    );
  }

  List<FlSpot> _buildChartSpots(List<TransactionEntity> contribs) {
    if (contribs.isEmpty) return [];
    final sorted = List.of(contribs)
      ..sort((a, b) => a.date.compareTo(b.date));
    double cumulative = 0;
    final spots = <FlSpot>[];
    for (int i = 0; i < sorted.length; i++) {
      cumulative += sorted[i].amount;
      spots.add(FlSpot(i.toDouble(), cumulative));
    }
    return spots;
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete goal?'),
        content: const Text(
            'All linked contributions (transactions) will be reversed and removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(goalRepositoryProvider).delete(goalId);
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  static Color _parseColor(String hex) {
    try {
      final sanitized = hex.replaceAll('#', '');
      return Color(int.parse('FF$sanitized', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }
}
