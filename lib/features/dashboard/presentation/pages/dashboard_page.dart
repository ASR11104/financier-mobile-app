import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../transactions/presentation/widgets/add_transaction_sheet.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_transactions_list.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finsight', style: AppTextStyles.headlineLarge()),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BalanceCard(),
            RecentTransactionsList(),
            SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => const AddTransactionSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
