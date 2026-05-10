import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../categories/providers/categories_providers.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../../providers/budget_providers.dart';

class AddBudgetSheet extends ConsumerStatefulWidget {
  final BudgetEntity? editing;

  const AddBudgetSheet({super.key, this.editing});

  @override
  ConsumerState<AddBudgetSheet> createState() => _AddBudgetSheetState();
}

class _AddBudgetSheetState extends ConsumerState<AddBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  CategoryEntity? _category;
  late BudgetPeriod _period;
  late bool _isRecurring;
  bool _saving = false;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _amountController.text = e.amount.toString();
      _period = e.period;
      _isRecurring = e.isRecurring;
    } else {
      _period = BudgetPeriod.monthly;
      _isRecurring = true;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null && !_isEditing) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select a category')));
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(budgetRepositoryProvider);
      final budget = BudgetEntity(
        id: widget.editing?.id ?? const Uuid().v4(),
        categoryId: _category?.id ?? widget.editing!.categoryId,
        amount: double.parse(_amountController.text),
        period: _period,
        isRecurring: _isRecurring,
        startDate: widget.editing?.startDate ?? DateTime.now(),
      );
      if (_isEditing) {
        await repo.update(budget);
      } else {
        await repo.insert(budget);
      }
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
    final categoriesAsync =
        ref.watch(categoriesByTypeProvider('expense'));

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
                  Text(
                    _isEditing ? 'Edit Budget' : 'Add Budget',
                    style: AppTextStyles.headlineSmall(),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!_isEditing)
                categoriesAsync.when(
                  data: (cats) => DropdownButtonFormField<CategoryEntity>(
                    // ignore: deprecated_member_use
                    value: _category,
                    decoration:
                        const InputDecoration(labelText: 'Expense Category'),
                    items: cats
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v),
                    validator: (v) => v == null ? 'Select a category' : null,
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration:
                    const InputDecoration(labelText: 'Budget Amount', prefixText: '₹ '),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a positive amount';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Period', style: AppTextStyles.labelMedium()),
              const SizedBox(height: 8),
              SegmentedButton<BudgetPeriod>(
                segments: BudgetPeriod.values
                    .map((p) =>
                        ButtonSegment(value: p, label: Text(p.label)))
                    .toList(),
                selected: {_period},
                onSelectionChanged: (s) =>
                    setState(() => _period = s.first),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Recurring'),
                subtitle: const Text(
                    'Automatically resets each period'),
                value: _isRecurring,
                onChanged: (v) => setState(() => _isRecurring = v),
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
                    : Text(_isEditing ? 'Save Changes' : 'Add Budget'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
