import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/karyawan.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('smartkasir.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE karyawan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_karyawan TEXT NOT NULL,
        pin TEXT NOT NULL,
        peran TEXT NOT NULL,
        created_at TEXT
      )
    ''');

    await db.insert('karyawan', {
      'nama_karyawan': 'Kasir Utama',
      'pin': '1234',
      'peran': 'Kasir',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> insertKaryawan(Karyawan k) async {
    final db = await database;
    return await db.insert('karyawan', k.toMap());
  }

  Future<List<Karyawan>> getAllKaryawan() async {
    final db = await database;

    final result = await db.query('karyawan', orderBy: 'nama_karyawan ASC');

    return result.map((m) => Karyawan.fromMap(m)).toList();
  }

  Future<int> updateKaryawan(Karyawan k) async {
    final db = await database;

    return await db.update(
      'karyawan',
      k.toMap(),
      where: 'id = ?',
      whereArgs: [k.id],
    );
  }

  Future<int> deleteKaryawan(int id) async {
    final db = await database;

    return await db.delete('karyawan', where: 'id = ?', whereArgs: [id]);
  }

  Future<Karyawan?> getKaryawanById(int id) async {
    final db = await database;

    final result = await db.query(
      'karyawan',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Karyawan.fromMap(result.first);
    }

    return null;
  }
}
