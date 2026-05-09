import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/providers/accounts_providers.dart';
import '../../../categories/providers/categories_providers.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionEntity transaction;
  final String currencySymbol;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoryAsync =
        ref.watch(categoryByIdProvider(transaction.categoryId));
    final accountAsync =
        ref.watch(accountByIdProvider(transaction.accountId));

    final typeColor = _typeColor(transaction.type);
    final isDebit = transaction.type == TransactionType.expense ||
        transaction.type == TransactionType.investment;

    final categoryName = categoryAsync.valueOrNull?.name ?? '…';
    final accountName = accountAsync.valueOrNull?.name ?? '…';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: typeColor.withValues(alpha: 0.15),
        child: Icon(_typeIcon(transaction.type), color: typeColor, size: 20),
      ),
      title: Text(
        transaction.description.isNotEmpty
            ? transaction.description
            : categoryName,
        style: AppTextStyles.labelLarge(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${Formatters.formatDateShort(transaction.date)} · $accountName',
        style: AppTextStyles.bodySmall(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: Text(
        '${isDebit ? '-' : '+'}${Formatters.formatAmount(transaction.amount, currencySymbol)}',
        style: AppTextStyles.amountSmall(color: typeColor),
      ),
    );
  }

  static Color _typeColor(TransactionType type) {
    return switch (type) {
      TransactionType.expense => AppColors.expense,
      TransactionType.income => AppColors.income,
      TransactionType.investment => AppColors.investment,
    };
  }

  static IconData _typeIcon(TransactionType type) {
    return switch (type) {
      TransactionType.expense => Icons.arrow_upward_rounded,
      TransactionType.income => Icons.arrow_downward_rounded,
      TransactionType.investment => Icons.trending_up_rounded,
    };
  }
}
