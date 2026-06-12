import '../../../core/storage/database.dart';
import '../domain/ai_model.dart';
import 'model_repository.dart';

/// SQLite-backed [ModelRepository] using the legacy-compatible `model` table.
class SqfliteModelRepository implements ModelRepository {
  SqfliteModelRepository(this._db);

  final PhoenixDatabase _db;

  @override
  Future<int> add(AiModel model) => _db.db.insert('model', model.toRow());

  @override
  Future<List<AiModel>> all() async {
    final rows = await _db.db.query('model', orderBy: 'add_model_time DESC');
    return rows.map(AiModel.fromRow).toList(growable: false);
  }

  @override
  Future<void> setLiked(int id, bool liked) => _db.db.update(
        'model',
        {'isLike': liked ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );

  @override
  Future<void> remove(int id) =>
      _db.db.delete('model', where: 'id = ?', whereArgs: [id]);
}
