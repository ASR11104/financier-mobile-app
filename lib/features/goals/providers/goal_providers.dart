import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../features/transactions/domain/entities/transaction_entity.dart';
import '../domain/entities/goal_entity.dart';
import '../domain/repositories/i_goal_repository.dart';

part 'goal_providers.g.dart';

@riverpod
IGoalRepository goalRepository(Ref ref) => getIt<IGoalRepository>();

@riverpod
Stream<List<GoalEntity>> goals(Ref ref) =>
    ref.watch(goalRepositoryProvider).watchAll();

@riverpod
Stream<List<GoalEntity>> activeGoals(Ref ref) =>
    ref.watch(goalRepositoryProvider).watchActive();

@riverpod
Stream<List<TransactionEntity>> goalContributions(Ref ref, String goalId) =>
    ref.watch(goalRepositoryProvider).watchContributions(goalId);

/// Derived progress data for a single goal.
class GoalProgress {
  final GoalEntity goal;
  final double percent;
  final double remaining;
  final int? monthsLeft;
  final double? suggestedMonthly;
  final bool contributedThisMonth;

  GoalProgress({
    required this.goal,
    required this.percent,
    required this.remaining,
    this.monthsLeft,
    this.suggestedMonthly,
    required this.contributedThisMonth,
  });

  String? get encouragementMessage {
    if (goal.isCompleted) return '🎉 Goal reached!';
    if (!contributedThisMonth) return null;
    if (suggestedMonthly == null || monthsLeft == null) return null;
    return 'Keep it up! You\'re on track to reach your goal.';
  }
}

@riverpod
GoalProgress goalProgress(Ref ref, String goalId) {
  final goalsAsync = ref.watch(goalsProvider);
  final goal = goalsAsync.valueOrNull?.where((g) => g.id == goalId).firstOrNull;
  if (goal == null) {
    return GoalProgress(
      goal: GoalEntity(id: goalId, name: '', targetAmount: 0),
      percent: 0,
      remaining: 0,
      contributedThisMonth: false,
    );
  }

  final percent =
      goal.targetAmount > 0 ? goal.currentAmount / goal.targetAmount : 0.0;
  final remaining = (goal.targetAmount - goal.currentAmount).clamp(0, double.infinity).toDouble();

  int? monthsLeft;
  double? suggestedMonthly;
  if (goal.targetDate != null && !goal.isCompleted) {
    final now = DateTime.now();
    final target = goal.targetDate!;
    final months = (target.year - now.year) * 12 + (target.month - now.month);
    monthsLeft = months.clamp(1, 999);
    suggestedMonthly = remaining / monthsLeft;
  }

  // Check if there's a contribution this month
  final contribAsync = ref.watch(goalContributionsProvider(goalId));
  final contribs = contribAsync.valueOrNull ?? [];
  final now = DateTime.now();
  final prefix = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  final contributedThisMonth =
      contribs.any((t) => t.date.startsWith(prefix));

  return GoalProgress(
    goal: goal,
    percent: percent.clamp(0, 1).toDouble(),
    remaining: remaining,
    monthsLeft: monthsLeft,
    suggestedMonthly: suggestedMonthly,
    contributedThisMonth: contributedThisMonth,
  );
}
