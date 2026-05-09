import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../providers/accounts_providers.dart';
import '../widgets/account_card.dart';
import '../widgets/add_account_sheet.dart';
import '../widgets/transfer_sheet.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts', style: AppTextStyles.headlineLarge()),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text('No Accounts Yet', style: AppTextStyles.headlineSmall()),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first account',
                    style: AppTextStyles.bodyMedium(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: accounts.length,
            itemBuilder: (context, index) =>
                AccountCard(account: accounts[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showActionChooser(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showActionChooser(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('Add Account'),
              onTap: () {
                Navigator.of(context).pop();
                _showAddAccount(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded),
              title: const Text('Transfer Between Accounts'),
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (_) => const TransferSheet(),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showAddAccount(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const AddAccountSheet(),
    );
  }
}
