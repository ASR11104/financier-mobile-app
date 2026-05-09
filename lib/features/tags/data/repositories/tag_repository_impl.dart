import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../database/daos/tags_dao.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/i_tag_repository.dart';

@LazySingleton(as: ITagRepository)
class TagRepositoryImpl implements ITagRepository {
  final TagsDao _dao;

  TagRepositoryImpl(this._dao);

  @override
  Stream<List<TagEntity>> watchAll() {
    return _dao.watchAll().map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<List<TagEntity>> getAll() async {
    final rows = await _dao.getAll();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<TagEntity?> getById(String id) async {
    final row = await _dao.getById(id);
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<void> insert(TagEntity tag) {
    return _dao.insertTag(TagsCompanion.insert(
      id: tag.id,
      name: tag.name,
      color: Value(tag.color),
    ));
  }

  @override
  Future<void> update(TagEntity tag) {
    return _dao.updateTag(TagsCompanion(
      id: Value(tag.id),
      name: Value(tag.name),
      color: Value(tag.color),
    ));
  }

  @override
  Future<void> delete(String id) async {
    await _dao.deleteTag(id);
  }

  TagEntity _toEntity(Tag row) {
    return TagEntity(id: row.id, name: row.name, color: row.color);
  }
}
