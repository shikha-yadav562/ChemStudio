import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _dbName = 'chemstudio.db';
  static const _dbVersion = 1;

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final tables = [
      'SaltA_DryTest',
      'SaltA_PreliminaryTest',
      'SaltB_DryTest',
      'SaltB_PreliminaryTest',
      'SaltC_DryTest',
      'SaltC_PreliminaryTest',
      'SaltD_DryTest',
      'SaltD_PreliminaryTest',
    ];

    for (var table in tables) {
      await db.execute('''
        CREATE TABLE $table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          question_id INTEGER NOT NULL,
          answer TEXT NOT NULL
        )
      ''');
    }
  }

  // Save answer
  Future<void> saveAnswer(String tableName, int questionId, String answer) async {
    final db = await database;
    await db.insert(
      tableName,
      {'question_id': questionId, 'answer': answer},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get answers
  Future<List<Map<String, dynamic>>> getAnswers(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // Clear specific test
  Future<void> clearTest(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

  // Clear all answers
  Future<void> clearAllAnswers() async {
    final db = await database;
    final tables = [
      'SaltA_DryTest',
      'SaltA_PreliminaryTest',
      'SaltB_DryTest',
      'SaltB_PreliminaryTest',
      'SaltC_DryTest',
      'SaltC_PreliminaryTest',
      'SaltD_DryTest',
      'SaltD_PreliminaryTest',
    ];
    for (var table in tables) {
      await db.delete(table);
    }
    _database = null;
  }

  // Reset database
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _database = null;
  }

  // Export database
  Future<void> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final sourcePath = join(dbPath, _dbName);
      final sourceFile = File(sourcePath);

      if (!await sourceFile.exists()) {
        print('❌ Database file not found at: $sourcePath');
        return;
      }

      String targetPath;

      if (Platform.isAndroid) {
        targetPath = "/storage/emulated/0/Download/$_dbName";
      } else if (Platform.isWindows) {
        final downloads = "${Platform.environment['USERPROFILE']}\\Downloads";
        targetPath = "$downloads\\$_dbName";
      } else if (Platform.isMacOS || Platform.isLinux) {
        final home = Platform.environment['HOME'];
        targetPath = "$home/Downloads/$_dbName";
      } else {
        throw Exception("❌ Unsupported platform");
      }

      await sourceFile.copy(targetPath);
      print("✅ Database successfully exported to: $targetPath");
    } catch (e) {
      print("❌ Error exporting database: $e");
    }
  }
}
