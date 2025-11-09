import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static const _dbName = 'chemstudio.db';
  static const _dbVersion = 1;

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // -------------------- GET DATABASE INSTANCE --------------------
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // -------------------- INITIALIZE DATABASE --------------------
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // -------------------- CREATE TABLES --------------------
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE SaltA_DryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltA_PreliminaryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltB_DryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltB_PreliminaryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltC_DryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltC_PreliminaryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltD_DryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE SaltD_PreliminaryTest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        answer TEXT NOT NULL
      )
    ''');
  }

  // -------------------- SAVE ANSWER --------------------
  Future<void> saveAnswer(String tableName, int questionId, String answer) async {
    final db = await database;
    await db.insert(
      tableName,
      {
        'question_id': questionId,
        'answer': answer,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // -------------------- GET ALL ANSWERS --------------------
  Future<List<Map<String, dynamic>>> getAnswers(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // -------------------- CLEAR TEST DATA --------------------
  Future<void> clearTest(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

  // -------------------- CLEAR ALL USER ANSWERS --------------------
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
  }

  // -------------------- DELETE DATABASE (OPTIONAL RESET) --------------------
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _database = null;
  }

  // -------------------- EXPORT DATABASE TO DOWNLOADS --------------------
  Future<void> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final sourcePath = join(dbPath, _dbName);
      final targetPath = '/storage/emulated/0/Download/$_dbName';

      await File(sourcePath).copy(targetPath);
      print('✅ Database copied to: $targetPath');
    } catch (e) {
      print('❌ Error exporting database: $e');
    }
  }
}
