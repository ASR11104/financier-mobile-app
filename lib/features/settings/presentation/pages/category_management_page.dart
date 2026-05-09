import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/transaction_type.dart';
import '../../../../core/widgets/color_picker.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/icon_picker.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/providers/categories_providers.dart';

class CategoryManagementPage extends ConsumerWidget {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: AppTextStyles.headlineLarge()),
      ),
      body: categoriesAsync.when(
        data: (cats) {
          if (cats.isEmpty) {
            return const EmptyState(
              icon: Icons.category_outlined,
              title: 'No categories',
              hint: 'Tap + to add your first category',
            );
          }
          final grouped = {
            TransactionType.expense:
                cats.where((c) => c.type == TransactionType.expense).toList(),
            TransactionType.income:
                cats.where((c) => c.type == TransactionType.income).toList(),
            TransactionType.investment: cats
                .where((c) => c.type == TransactionType.investment)
                .toList(),
          };

          return ListView(
            children: grouped.entries.expand((entry) {
              if (entry.value.isEmpty) return <Widget>[];
              return [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    entry.key.label.toUpperCase(),
                    style: AppTextStyles.labelSmall(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ...entry.value.map(
                  (cat) => ListTile(
                    onTap: cat.isDefault
                        ? null
                        : () => _showCategorySheet(context, ref, editing: cat),
                    leading: CircleAvatar(
                      backgroundColor: ColorPicker.colorFor(cat.color)
                          .withValues(alpha: 0.15),
                      child: Icon(
                        IconPicker.iconDataFor(cat.icon),
                        color: ColorPicker.colorFor(cat.color),
                        size: 18,
                      ),
                    ),
                    title: Text(cat.name),
                    trailing: cat.isDefault
                        ? const Icon(Icons.lock_outline,
                            size: 16, color: Colors.grey)
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                onPressed: () => _showCategorySheet(context, ref, editing: cat),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    _deleteCategory(context, ref, cat),
                              ),
                            ],
                          ),
                  ),
                ),
              ];
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategorySheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategorySheet(BuildContext context, WidgetRef ref,
      {CategoryEntity? editing}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CategorySheet(editing: editing),
    );
  }

  Future<void> _deleteCategory(
      BuildContext context, WidgetRef ref, CategoryEntity cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text('Delete "${cat.name}"? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(categoryRepositoryProvider).delete(cat.id);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Cannot delete — category is in use by existing transactions')),
          );
        }
      }
    }
  }
}

class _CategorySheet extends ConsumerStatefulWidget {
  final CategoryEntity? editing;
  const _CategorySheet({this.editing});

  @override
  ConsumerState<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends ConsumerState<_CategorySheet> {
  final _nameController = TextEditingController();
  late TransactionType _type;
  late String _icon;
  late String _color;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _nameController.text = e.name;
      _type = e.type;
      _icon = e.icon;
      _color = e.color;
    } else {
      _type = TransactionType.expense;
      _icon = 'tag';
      _color = '#9E9E9E';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    final cats = ref.read(categoriesProvider).valueOrNull ?? [];
    final maxSort = cats.isEmpty
        ? 0
        : cats.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b);

    final category = CategoryEntity(
      id: widget.editing?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      icon: _icon,
      color: _color,
      sortOrder: widget.editing?.sortOrder ?? maxSort + 1,
      isDefault: widget.editing?.isDefault ?? false,
    );

    try {
      final repo = ref.read(categoryRepositoryProvider);
      if (_isEditing) {
        await repo.update(category);
      } else {
        await repo.insert(category);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save category')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  _isEditing ? 'Edit Category' : 'New Category',
                  style: AppTextStyles.headlineSmall(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Category name'),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: TransactionType.values.map((t) {
                return ChoiceChip(
                  label: Text(t.label),
                  selected: _type == t,
                  onSelected: _isEditing
                      ? null
                      : (_) => setState(() => _type = t),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Icon', style: AppTextStyles.labelMedium()),
            const SizedBox(height: 8),
            IconPicker(
              selected: _icon,
              onChanged: (v) => setState(() => _icon = v),
            ),
            const SizedBox(height: 16),
            Text('Color', style: AppTextStyles.labelMedium()),
            const SizedBox(height: 8),
            ColorPicker(
              selected: _color,
              onChanged: (v) => setState(() => _color = v),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: Text(_isEditing ? 'Save Changes' : 'Add Category'),
            ),
          ],
        ),
      ),
    );
  }
}
