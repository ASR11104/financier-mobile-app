import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/investment_type.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/providers/accounts_providers.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/providers/categories_providers.dart';
import '../../../tags/providers/tags_providers.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../providers/transactions_providers.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  AccountEntity? _account;
  CategoryEntity? _category;
  InvestmentType? _investmentType;
  DateTime _date = DateTime.now();
  final Set<String> _selectedTagIds = {};
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_account == null || _category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select account and category')),
      );
      return;
    }
    if (_type == TransactionType.investment && _investmentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select investment type')),
      );
      return;
    }

    setState(() => _saving = true);

    final txn = TransactionEntity(
      id: const Uuid().v4(),
      type: _type,
      amount: double.parse(_amountController.text),
      accountId: _account!.id,
      categoryId: _category!.id,
      date: Formatters.dateToString(_date),
      description: _descriptionController.text.trim(),
      investmentType: _investmentType,
      tagIds: _selectedTagIds.toList(),
    );

    try {
      await ref.read(transactionRepositoryProvider).insert(txn);
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
    final categoriesAsync =
        ref.watch(categoriesByTypeProvider(_type.value));
    final tagsAsync = ref.watch(tagsProvider);

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
                  Text('Add Transaction',
                      style: AppTextStyles.headlineSmall()),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Type selector
              Row(
                children: TransactionType.values.map((t) {
                  final selected = _type == t;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ChoiceChip(
                        label: Text(t.label),
                        selected: selected,
                        onSelected: (_) => setState(() {
                          _type = t;
                          _category = null;
                          _investmentType = null;
                        }),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                ),
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
              // Account picker
              accountsAsync.when(
                data: (accounts) => DropdownButtonFormField<AccountEntity>(
                  // ignore: deprecated_member_use
                  value: _account,
                  decoration: const InputDecoration(labelText: 'Account'),
                  items: accounts
                      .map((a) =>
                          DropdownMenuItem(value: a, child: Text(a.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _account = v),
                  validator: (v) =>
                      v == null ? 'Select an account' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 12),
              // Category picker
              categoriesAsync.when(
                data: (cats) => DropdownButtonFormField<CategoryEntity>(
                  // ignore: deprecated_member_use
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: cats
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v),
                  validator: (v) =>
                      v == null ? 'Select a category' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              // Investment type (only for investment)
              if (_type == TransactionType.investment) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<InvestmentType>(
                  // ignore: deprecated_member_use
                  value: _investmentType,
                  decoration:
                      const InputDecoration(labelText: 'Investment type'),
                  items: InvestmentType.values
                      .map((t) =>
                          DropdownMenuItem(value: t, child: Text(t.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _investmentType = v),
                  validator: (v) =>
                      _type == TransactionType.investment && v == null
                          ? 'Select investment type'
                          : null,
                ),
              ],
              const SizedBox(height: 12),
              // Date picker
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(
                    Formatters.formatDate(Formatters.dateToString(_date))),
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
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
              ),
              const SizedBox(height: 8),
              // Tags
              tagsAsync.when(
                data: (tags) {
                  if (tags.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Tags',
                          style: AppTextStyles.labelMedium()),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: tags.map((tag) {
                          final selected =
                              _selectedTagIds.contains(tag.id);
                          return FilterChip(
                            label: Text(tag.name),
                            selected: selected,
                            onSelected: (v) => setState(() {
                              if (v) {
                                _selectedTagIds.add(tag.id);
                              } else {
                                _selectedTagIds.remove(tag.id);
                              }
                            }),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
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
                    : const Text('Save Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
