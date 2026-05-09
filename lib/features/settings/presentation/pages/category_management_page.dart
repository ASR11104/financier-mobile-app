import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/enums/transaction_type.dart';
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
                    leading: CircleAvatar(
                      backgroundColor: _parseColor(cat.color)
                          .withValues(alpha: 0.15),
                      child: Text(cat.icon.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              color: _parseColor(cat.color),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(cat.name),
                    trailing: cat.isDefault
                        ? const Icon(Icons.lock_outline,
                            size: 16, color: Colors.grey)
                        : IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                _deleteCategory(context, ref, cat),
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
        onPressed: () => _showAddCategory(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategory(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddCategorySheet(widgetRef: ref),
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
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(categoryRepositoryProvider).delete(cat.id);
    }
  }

  static Color _parseColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }
}

class _AddCategorySheet extends ConsumerStatefulWidget {
  final WidgetRef widgetRef;
  const _AddCategorySheet({required this.widgetRef});

  @override
  ConsumerState<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends ConsumerState<_AddCategorySheet> {
  final _nameController = TextEditingController();
  TransactionType _type = TransactionType.expense;

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
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _type,
      icon: 'tag',
      color: '#9E9E9E',
      sortOrder: maxSort + 1,
      isDefault: false,
    );
    await ref.read(categoryRepositoryProvider).insert(category);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New Category', style: AppTextStyles.headlineSmall()),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Category name'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: TransactionType.values.map((t) {
              return ChoiceChip(
                label: Text(t.label),
                selected: _type == t,
                onSelected: (_) => setState(() => _type = t),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Add Category')),
        ],
      ),
    );
  }
}
