import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/investment_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/providers/accounts_providers.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/providers/categories_providers.dart';
import '../../domain/entities/goal_entity.dart';
import '../../providers/goal_providers.dart';

class AddContributionSheet extends ConsumerStatefulWidget {
  final GoalEntity goal;

  const AddContributionSheet({super.key, required this.goal});

  @override
  ConsumerState<AddContributionSheet> createState() =>
      _AddContributionSheetState();
}

class _AddContributionSheetState extends ConsumerState<AddContributionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  AccountEntity? _account;
  CategoryEntity? _category;
  late DateTime _date;
  late InvestmentType _investmentType;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _investmentType =
        widget.goal.preferredInvestmentType ?? InvestmentType.mutualFund;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_account == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select an account')));
      return;
    }
    if (_category == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select a category')));
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(goalRepositoryProvider).addContribution(
            goalId: widget.goal.id,
            accountId: _account!.id,
            categoryId: _category!.id,
            amount: double.parse(_amountController.text),
            date: Formatters.dateToString(_date),
            description: _noteController.text.trim(),
            investmentType: _investmentType,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final categoriesAsync = ref.watch(categoriesByTypeProvider('investment'));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add to "${widget.goal.name}"',
                      style: AppTextStyles.headlineSmall(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                    labelText: 'Amount', prefixText: '₹ '),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a positive amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              accountsAsync.when(
                data: (accounts) => DropdownButtonFormField<AccountEntity>(
                  // ignore: deprecated_member_use
                  value: _account,
                  decoration: const InputDecoration(labelText: 'Debit Account'),
                  items: accounts
                      .map((a) =>
                          DropdownMenuItem(value: a, child: Text(a.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _account = v),
                  validator: (v) => v == null ? 'Select an account' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (cats) => DropdownButtonFormField<CategoryEntity>(
                  // ignore: deprecated_member_use
                  value: _category,
                  decoration:
                      const InputDecoration(labelText: 'Investment Category'),
                  items: cats
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v),
                  validator: (v) => v == null ? 'Select a category' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<InvestmentType>(
                // ignore: deprecated_member_use
                value: _investmentType,
                decoration:
                    const InputDecoration(labelText: 'Investment Type'),
                items: InvestmentType.values
                    .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t.label)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _investmentType = v);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title:
                    Text(Formatters.formatDate(Formatters.dateToString(_date))),
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
                controller: _noteController,
                decoration:
                    const InputDecoration(labelText: 'Note (optional)'),
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
                    : const Text('Add Contribution'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
