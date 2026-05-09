import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/account_type.dart';
import '../../domain/entities/account_entity.dart';
import '../../providers/accounts_providers.dart';

class AddAccountSheet extends ConsumerStatefulWidget {
  const AddAccountSheet({super.key});

  @override
  ConsumerState<AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends ConsumerState<AddAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController(text: '0');
  final _creditLimitController = TextEditingController();
  final _notesController = TextEditingController();

  AccountType _type = AccountType.bankAccount;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final isCreditCard = _type == AccountType.creditCard;
    final creditLimit =
        isCreditCard ? double.tryParse(_creditLimitController.text) : null;
    final balance =
        isCreditCard ? 0.0 : (double.tryParse(_balanceController.text) ?? 0.0);

    final account = AccountEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      balance: balance,
      creditLimit: creditLimit,
      amountUsed: isCreditCard ? 0.0 : null,
      icon: _type.value,
      color: _typeHex(_type),
      isActive: true,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(accountRepositoryProvider).insert(account);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save account')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCreditCard = _type == AccountType.creditCard;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Add Account', style: AppTextStyles.headlineSmall()),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account name',
                hintText: 'e.g. HDFC Savings',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name required' : null,
            ),
            const SizedBox(height: 16),
            Text('Account type',
                style: AppTextStyles.labelMedium(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: AccountType.values.map((t) {
                final selected = _type == t;
                return ChoiceChip(
                  label: Text(t.label),
                  selected: selected,
                  onSelected: (_) => setState(() => _type = t),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (!isCreditCard)
              TextFormField(
                controller: _balanceController,
                decoration: const InputDecoration(
                  labelText: 'Initial balance',
                  prefixText: '₹ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Enter a number' : null,
              ),
            if (isCreditCard) ...[
              TextFormField(
                controller: _creditLimitController,
                decoration: const InputDecoration(
                  labelText: 'Credit limit',
                  prefixText: '₹ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (isCreditCard &&
                        (v == null ||
                            v.isEmpty ||
                            double.tryParse(v) == null))
                    ? 'Enter credit limit'
                    : null,
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }

  static String _typeHex(AccountType type) {
    return switch (type) {
      AccountType.bankAccount => '#2196F3',
      AccountType.creditCard => '#E91E63',
      AccountType.cash => '#4CAF50',
      AccountType.wallet => '#FF9800',
    };
  }
}
