import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../tags/domain/entities/tag_entity.dart';
import '../../../tags/providers/tags_providers.dart';

class TagManagementPage extends ConsumerWidget {
  const TagManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tags', style: AppTextStyles.headlineLarge()),
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.label_outlined,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text('No tags yet', style: AppTextStyles.headlineSmall()),
                  const SizedBox(height: 8),
                  Text('Tap + to create your first tag',
                      style: AppTextStyles.bodyMedium(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant)),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, i) {
              final tag = tags[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _parseColor(tag.color).withValues(alpha: 0.2),
                  child: Icon(Icons.label_rounded,
                      color: _parseColor(tag.color), size: 18),
                ),
                title: Text(tag.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteTag(context, ref, tag),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTag(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTag(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _AddTagSheet(widgetRef: ref),
    );
  }

  Future<void> _deleteTag(
      BuildContext context, WidgetRef ref, TagEntity tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Tag?'),
        content: Text('Delete "${tag.name}"?'),
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
      await ref.read(tagRepositoryProvider).delete(tag.id);
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

class _AddTagSheet extends ConsumerStatefulWidget {
  final WidgetRef widgetRef;
  const _AddTagSheet({required this.widgetRef});

  @override
  ConsumerState<_AddTagSheet> createState() => _AddTagSheetState();
}

class _AddTagSheetState extends ConsumerState<_AddTagSheet> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    final tag = TagEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      color: '#9C27B0',
    );
    await ref.read(tagRepositoryProvider).insert(tag);
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
          Text('New Tag', style: AppTextStyles.headlineSmall()),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Tag name'),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Add Tag')),
        ],
      ),
    );
  }
}
