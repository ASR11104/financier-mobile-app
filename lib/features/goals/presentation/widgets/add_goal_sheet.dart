import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/investment_type.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/color_picker.dart';
import '../../domain/entities/goal_entity.dart';
import '../../providers/goal_providers.dart';

class AddGoalSheet extends ConsumerStatefulWidget {
  final GoalEntity? editing;

  const AddGoalSheet({super.key, this.editing});

  @override
  ConsumerState<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<AddGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _targetDate;
  InvestmentType? _investmentType;
  late String _color;
  bool _saving = false;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _nameController.text = e.name;
      _descriptionController.text = e.description;
      _amountController.text = e.targetAmount.toString();
      _targetDate = e.targetDate;
      _investmentType = e.preferredInvestmentType;
      _color = e.color;
    } else {
      _color = '#673AB7';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(goalRepositoryProvider);
      final goal = GoalEntity(
        id: widget.editing?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        targetAmount: double.parse(_amountController.text),
        currentAmount: widget.editing?.currentAmount ?? 0,
        targetDate: _targetDate,
        preferredInvestmentType: _investmentType,
        color: _color,
        isCompleted: widget.editing?.isCompleted ?? false,
      );
      if (_isEditing) {
        await repo.update(goal);
      } else {
        await repo.insert(goal);
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
                    _isEditing ? 'Edit Goal' : 'New Goal',
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Goal name'),
                autofocus: true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                    labelText: 'Target Amount', prefixText: '₹ '),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a positive amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_targetDate == null
                    ? 'No target date'
                    : 'By ${Formatters.formatDate(_targetDate!.toIso8601String().substring(0, 10))}'),
                trailing: _targetDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _targetDate = null),
                      )
                    : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        _targetDate ?? DateTime.now().add(const Duration(days: 365)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _targetDate = picked);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<InvestmentType?>(
                // ignore: deprecated_member_use
                value: _investmentType,
                decoration:
                    const InputDecoration(labelText: 'Default investment type'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  ...InvestmentType.values.map(
                    (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                  ),
                ],
                onChanged: (v) => setState(() => _investmentType = v),
              ),
              const SizedBox(height: 16),
              Text('Color', style: AppTextStyles.labelMedium()),
              const SizedBox(height: 8),
              ColorPicker(
                selected: _color,
                onChanged: (c) => setState(() => _color = c),
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
                    : Text(_isEditing ? 'Save Changes' : 'Create Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
