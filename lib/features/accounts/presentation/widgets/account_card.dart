import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/account_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/account_entity.dart';
import '../../providers/accounts_providers.dart';
import 'add_account_sheet.dart';

class AccountCard extends ConsumerWidget {
  final AccountEntity account;
  final String currencySymbol;

  const AccountCard({
    super.key,
    required this.account,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _typeColor(account.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => AddAccountSheet(editing: account),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(_typeIcon(account.type), color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name, style: AppTextStyles.labelLarge()),
                    const SizedBox(height: 2),
                    Text(
                      account.type.label,
                      style: AppTextStyles.bodySmall(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildAmountSection(context, isDark),
              const SizedBox(width: 4),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 20),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'archive', child: Text('Archive')),
                ],
                onSelected: (value) async {
                  if (value == 'archive') {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Archive account?'),
                        content: Text(
                            '${account.name} will be hidden from your active accounts.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Archive'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      try {
                        await ref
                            .read(accountRepositoryProvider)
                            .archive(account.id);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to archive account')),
                          );
                        }
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context, bool isDark) {
    if (account.type == AccountType.creditCard) {
      final used = account.amountUsed ?? 0;
      final limit = account.creditLimit ?? 0;
      final available = limit - used;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            Formatters.formatAmount(available, currencySymbol),
            style: AppTextStyles.amountSmall(color: AppColors.income),
          ),
          Text(
            'of ${Formatters.formatCompact(limit)} available',
            style: AppTextStyles.bodySmall(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      );
    }
    return Text(
      Formatters.formatAmount(account.balance, currencySymbol),
      style: AppTextStyles.amountSmall(),
    );
  }

  static IconData _typeIcon(AccountType type) {
    return switch (type) {
      AccountType.bankAccount => Icons.account_balance_rounded,
      AccountType.creditCard => Icons.credit_card_rounded,
      AccountType.cash => Icons.payments_rounded,
      AccountType.wallet => Icons.account_balance_wallet_rounded,
    };
  }

  static Color _typeColor(AccountType type) {
    return switch (type) {
      AccountType.bankAccount => AppColors.bankAccount,
      AccountType.creditCard => AppColors.creditCard,
      AccountType.cash => AppColors.cash,
      AccountType.wallet => AppColors.wallet,
    };
  }
}
