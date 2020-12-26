import 'package:flutter_app_note/repository/local_repository.dart';
import 'package:flutter_app_note/repository/repository.dart';

import 'package:flutter_app_note/ui/views/note/note_model.dart';

class NoteRepository implements Repository<Note> {
  NoteRepository._internal(LocalRepository localRepo) {
    this.localRepo = localRepo;
  }

  static final _cache = <String, NoteRepository>{};

  factory NoteRepository() {
    return _cache.putIfAbsent('NoteRepository',
        () => NoteRepository._internal(LocalRepository.instance));
  }

  @override
  LocalRepository localRepo;

  @override
  Future delete(Note item) async {
    return await localRepo.db().then((db) =>
        db.delete(Note.tableName, where: 'id' + ' = ?', whereArgs: [item.id]));
  }

  @override
  Future insert(Note item) async {
    /// Code cho insetr data
    final db = await localRepo.db();
    return await db.insert(Note.tableName, item.toMap());
  }

  @override
  Future<List<Note>> items() async {
    /// cho get all item Note
    final db = await localRepo.db();
    var maps = await db.query(Note.tableName);
    return Note.fromList(maps);
  }

  @override
  Future update(Note item) async {
    /// Code cho update data
    final db = await localRepo.db();
    return await db.update(Note.tableName, item.toMap(),
        where: 'id' + ' = ? ', whereArgs: [item.id]);
  }
}
