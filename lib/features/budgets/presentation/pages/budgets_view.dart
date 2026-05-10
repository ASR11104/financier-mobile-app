import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../providers/budget_providers.dart';
import '../widgets/add_budget_sheet.dart';
import '../widgets/budget_card.dart';

class BudgetsView extends ConsumerWidget {
  const BudgetsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(budgetsWithSpendingProvider);

    return Scaffold(
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.savings_outlined,
              title: 'No budgets yet',
              hint: 'Tap + to set a spending limit for a category',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) => BudgetCard(data: items[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => const AddBudgetSheet(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
