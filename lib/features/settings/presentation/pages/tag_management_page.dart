import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/color_picker.dart';
import '../../../../core/widgets/empty_state.dart';
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
            return const EmptyState(
              icon: Icons.label_outlined,
              title: 'No tags yet',
              hint: 'Tap + to create your first tag',
            );
          }
          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, i) {
              final tag = tags[i];
              return ListTile(
                onTap: () => _showTagSheet(context, editing: tag),
                leading: CircleAvatar(
                  backgroundColor:
                      ColorPicker.colorFor(tag.color).withValues(alpha: 0.2),
                  child: Icon(Icons.label_rounded,
                      color: ColorPicker.colorFor(tag.color), size: 18),
                ),
                title: Text(tag.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showTagSheet(context, editing: tag),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteTag(context, ref, tag),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTagSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTagSheet(BuildContext context, {TagEntity? editing}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TagSheet(editing: editing),
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
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref.read(tagRepositoryProvider).delete(tag.id);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete tag')),
          );
        }
      }
    }
  }
}

class _TagSheet extends ConsumerStatefulWidget {
  final TagEntity? editing;
  const _TagSheet({this.editing});

  @override
  ConsumerState<_TagSheet> createState() => _TagSheetState();
}

class _TagSheetState extends ConsumerState<_TagSheet> {
  final _nameController = TextEditingController();
  late String _color;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    if (e != null) {
      _nameController.text = e.name;
      _color = e.color;
    } else {
      _color = '#9C27B0';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    final tag = TagEntity(
      id: widget.editing?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      color: _color,
    );

    try {
      final repo = ref.read(tagRepositoryProvider);
      if (_isEditing) {
        await repo.update(tag);
      } else {
        await repo.insert(tag);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save tag')),
        );
      }
    }
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
          Row(
            children: [
              Text(
                _isEditing ? 'Edit Tag' : 'New Tag',
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
            decoration: const InputDecoration(labelText: 'Tag name'),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
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
            child: Text(_isEditing ? 'Save Changes' : 'Add Tag'),
          ),
        ],
      ),
    );
  }
}
