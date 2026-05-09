import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../../../transactions/providers/transactions_providers.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(recentTransactionsProvider());

    return asyncData.when(
      data: (txns) {
        if (txns.isEmpty) {
          return const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No transactions yet',
            hint: 'Add your first transaction using the + button',
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Recent Transactions',
                  style: AppTextStyles.headlineSmall()),
            ),
            ...txns.map((t) => TransactionTile(transaction: t)),
          ],
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
