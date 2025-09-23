import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class LocalDb {
  static final LocalDb instance = LocalDb._();

  LocalDb._();

  static const _dbName = 'tasks_demo.db';
  static const _dbVersion = 1;
  static const _table = 'tasks';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    print(dir.path);
    final path = p.join(dir.path, _dbName);
    print('SQLite DB path: $path');

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      is_done INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL
      )
      ''');
  }

  // CRUD

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      _table,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final rows = await db.query(_table, orderBy: 'created_at DESC, id DESC');

    return rows.map((row) => Task.fromMap(row)).toList();
  }

  Future<int> updateTitle(int id, String title) async {
    final db = await database;
    return db.update(_table, {'title': title}, where: 'id=?', whereArgs: [id]);
  }

  Future<int> toggleDone(int id, bool isDone) async {
    final db = await database;
    return db.update(
      _table,
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(_table, where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(_table);
  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }
}
