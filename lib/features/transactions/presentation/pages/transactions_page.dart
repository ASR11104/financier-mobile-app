import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../transfers/presentation/widgets/transfer_tile.dart';
import '../../../transfers/providers/transfers_providers.dart';
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

  static const _tabs = ['All', 'Expense', 'Income', 'Investment', 'Transfers'];

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
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _TransactionList(type: null),
          const _TransactionList(type: TransactionType.expense),
          const _TransactionList(type: TransactionType.income),
          const _TransactionList(type: TransactionType.investment),
          const _TransferList(),
        ],
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
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            title: type == null
                ? 'No transactions yet'
                : 'No ${type!.label.toLowerCase()} transactions',
            hint: 'Tap + to add your first transaction',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: txns.length,
          itemBuilder: (_, i) => TransactionTile(transaction: txns[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _TransferList extends ConsumerWidget {
  const _TransferList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(transfersProvider);

    return asyncData.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const EmptyState(
            icon: Icons.swap_horiz_outlined,
            title: 'No transfers yet',
            hint: 'Go to Accounts and tap the transfer button',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: transfers.length,
          itemBuilder: (_, i) => TransferTile(transfer: transfers[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
