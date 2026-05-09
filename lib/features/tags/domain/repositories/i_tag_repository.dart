import '../entities/tag_entity.dart';

abstract class ITagRepository {
  Stream<List<TagEntity>> watchAll();
  Future<List<TagEntity>> getAll();
  Future<TagEntity?> getById(String id);
  Future<void> insert(TagEntity tag);
  Future<void> update(TagEntity tag);
  Future<void> delete(String id);
}
