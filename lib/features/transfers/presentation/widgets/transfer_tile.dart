import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/providers/accounts_providers.dart';
import '../../../accounts/presentation/widgets/transfer_sheet.dart';
import '../../domain/entities/transfer_entity.dart';
import '../../providers/transfers_providers.dart';

class TransferTile extends ConsumerWidget {
  final TransferEntity transfer;
  final String currencySymbol;

  const TransferTile({
    super.key,
    required this.transfer,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fromAsync = ref.watch(accountByIdProvider(transfer.fromAccountId));
    final toAsync = ref.watch(accountByIdProvider(transfer.toAccountId));

    final fromName = fromAsync.valueOrNull?.name ?? '…';
    final toName = toAsync.valueOrNull?.name ?? '…';
    final subtitle = transfer.description.isNotEmpty
        ? '${Formatters.formatDateShort(transfer.date)} · ${transfer.description}'
        : Formatters.formatDateShort(transfer.date);

    return ListTile(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => TransferSheet(editing: transfer),
      ),
      leading: CircleAvatar(
        backgroundColor: AppColors.transfer.withValues(alpha: 0.15),
        child: const Icon(Icons.swap_horiz_rounded,
            color: AppColors.transfer, size: 20),
      ),
      title: Text(
        '$fromName → $toName',
        style: AppTextStyles.labelLarge(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Formatters.formatAmount(transfer.amount, currencySymbol),
            style: AppTextStyles.amountSmall(color: AppColors.transfer),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.more_vert, size: 18),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) async {
              if (value == 'delete') {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete transfer?'),
                    content: const Text(
                        'This will reverse the balance changes on both accounts.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  try {
                    await ref
                        .read(transferRepositoryProvider)
                        .delete(transfer.id);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to delete transfer')),
                      );
                    }
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
