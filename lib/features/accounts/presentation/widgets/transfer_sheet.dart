import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/providers/accounts_providers.dart';
import '../../../transfers/domain/entities/transfer_entity.dart';
import '../../../transfers/providers/transfers_providers.dart';

class TransferSheet extends ConsumerStatefulWidget {
  const TransferSheet({super.key});

  @override
  ConsumerState<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends ConsumerState<TransferSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  AccountEntity? _fromAccount;
  AccountEntity? _toAccount;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save(List<AccountEntity> accounts) async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromAccount == null || _toAccount == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select both accounts')));
      return;
    }
    if (_fromAccount!.id == _toAccount!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select different accounts')));
      return;
    }

    setState(() => _saving = true);

    final transfer = TransferEntity(
      id: const Uuid().v4(),
      fromAccountId: _fromAccount!.id,
      toAccountId: _toAccount!.id,
      amount: double.parse(_amountController.text),
      date: Formatters.dateToString(_date),
      description: _descriptionController.text.trim(),
    );

    try {
      await ref.read(transferRepositoryProvider).insert(transfer);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Transfer failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return accountsAsync.when(
      data: (accounts) => _buildForm(context, accounts),
      loading: () =>
          const Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error loading accounts: $e'),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<AccountEntity> accounts) {
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
                Text('Transfer', style: AppTextStyles.headlineSmall()),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AccountEntity>(
              // ignore: deprecated_member_use
              value: _fromAccount,
              decoration: const InputDecoration(labelText: 'From account'),
              items: accounts
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                  .toList(),
              onChanged: (v) => setState(() => _fromAccount = v),
              validator: (v) => v == null ? 'Select source account' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AccountEntity>(
              // ignore: deprecated_member_use
              value: _toAccount,
              decoration: const InputDecoration(labelText: 'To account'),
              items: accounts
                  .where((a) => a.id != _fromAccount?.id)
                  .map((a) => DropdownMenuItem(value: a, child: Text(a.name)))
                  .toList(),
              onChanged: (v) => setState(() => _toAccount = v),
              validator: (v) => v == null ? 'Select destination account' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final n = double.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Enter a positive amount';
                return null;
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(Formatters.formatDate(Formatters.dateToString(_date))),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : () => _save(accounts),
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
