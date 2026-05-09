import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tags_table.dart';

part 'tags_dao.g.dart';

/// Data Access Object for the [Tags] table.
@DriftAccessor(tables: [Tags])
class TagsDao extends DatabaseAccessor<AppDatabase>
    with _$TagsDaoMixin {
  TagsDao(super.db);

  /// Watch all tags, ordered by name.
  Stream<List<Tag>> watchAll() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  /// Get all tags.
  Future<List<Tag>> getAll() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  /// Get a single tag by ID.
  Future<Tag?> getById(String id) {
    return (select(tags)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert a new tag.
  Future<void> insertTag(TagsCompanion tag) {
    return into(tags).insert(tag);
  }

  /// Update an existing tag.
  Future<void> updateTag(TagsCompanion tag) {
    return (update(tags)..where((t) => t.id.equals(tag.id.value))).write(tag);
  }

  /// Delete a tag by ID.
  Future<int> deleteTag(String id) {
    return (delete(tags)..where((t) => t.id.equals(id))).go();
  }
}
