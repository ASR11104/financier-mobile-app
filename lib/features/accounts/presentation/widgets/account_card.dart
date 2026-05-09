import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/account_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/account_entity.dart';

class AccountCard extends StatelessWidget {
  final AccountEntity account;
  final String currencySymbol;

  const AccountCard({
    super.key,
    required this.account,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = _typeColor(account.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              child: Icon(_typeIcon(account.type), color: accentColor, size: 22),
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
          ],
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
