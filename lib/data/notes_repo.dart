import "package:path/path.dart" as p;
import "package:sqflite/sqflite.dart";

import "../models/notes.dart";

class NotesRepo {
  NotesRepo._();

  Database? _db;

  static final NotesRepo instance = NotesRepo._();

  Future<Database> get getDb async {
    if (_db != null) return _db!;

    final path = p.join(await getDatabasesPath(), 'fieldnotes.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
        create table notes (
          id text primary key
          title text not null
          notes text not null
          category text not null
          created_at text not null
        )
        """);
      },
    );

    return _db!;
  }

  Future<void> create(Notes note) async {
    final db = await getDb;

    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Notes>> getAll() async {
    final db = await getDb;

    final rows = await db.query('notes', orderBy: 'created_at desc');

    return rows.map(Notes.fromMap).toList();
  }

  Future<Notes?> getById(String id) async {
    final db = await getDb;

    final out = await db.query(
      'notes',
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (out.isEmpty) return null;

    return Notes.fromMap(out.first);
  }

  Future<void> update(Notes note) async {
    final db = await getDb;

    final count = await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );

    if (count == 0) {
      throw StateError("The note is not found");
    }
  }

  Future<void> delete(String id) async {
    final db = await getDb;

    await db.delete('notes', where: "id = ?", whereArgs: [id]);
  }
}
