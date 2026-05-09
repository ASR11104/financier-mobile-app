import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../providers/transactions_providers.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/transaction_tile.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    (label: 'All', type: null),
    (label: 'Expense', type: TransactionType.expense),
    (label: 'Income', type: TransactionType.income),
    (label: 'Investment', type: TransactionType.investment),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions', style: AppTextStyles.headlineLarge()),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((t) => _TransactionList(type: t.type)).toList(),
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

class _TransactionList extends ConsumerWidget {
  final TransactionType? type;

  const _TransactionList({this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = type == null
        ? ref.watch(transactionsProvider)
        : ref.watch(transactionsByTypeProvider(type!.value));

    return asyncData.when(
      data: (txns) {
        if (txns.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text('No transactions yet',
                    style: AppTextStyles.headlineSmall()),
                const SizedBox(height: 8),
                Text(
                  'Tap + to add your first transaction',
                  style: AppTextStyles.bodyMedium(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: txns.length,
          itemBuilder: (context, i) =>
              TransactionTile(transaction: txns[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
