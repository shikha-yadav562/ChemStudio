import 'dart:io';
import 'package:ChemStudio/screens/WET_TEST/C_WET/correct_answers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  // Create all tables
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
      // Wet Tests
      'SaltA_WetTest',
      'SaltB_WetTest',
      'SaltC_WetTest',
      'SaltD_WetTest',
    ];

    for (var table in tables) {
      await db.execute('''
        CREATE TABLE $table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          question_id INTEGER NOT NULL,
          student_answer TEXT,
          correct_answer TEXT
        )
      ''');
    }

    // Table to track present groups for Wet Test
    await db.execute('''
      CREATE TABLE WetTestGroups (
        group_id INTEGER PRIMARY KEY,
        is_present INTEGER DEFAULT 0
      )
    ''');
  }

  // ----------------------
  // Save correct answer
  Future<void> saveCorrectAnswer(String tableName, int questionId, String correctAnswer) async {
    final db = await database;
    await db.insert(
      tableName,
      {'question_id': questionId, 'correct_answer': correctAnswer},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Save student answer
  Future<void> saveStudentAnswer(String tableName, int questionId, String studentAnswer) async {
    final db = await database;
    await db.insert(
      tableName,
      {'question_id': questionId, 'student_answer': studentAnswer},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get student answer
  Future<String?> getStudentAnswer(String tableName, int questionId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      columns: ['student_answer'],
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
    if (result.isNotEmpty) return result.first['student_answer'] as String?;
    return null;
  }

  // Get correct answer
  Future<String?> getCorrectAnswer(String tableName, int questionId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      columns: ['correct_answer'],
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
    if (result.isNotEmpty) return result.first['correct_answer'] as String?;
    return null;
  }

  // Get all answers (for review or final result)
  Future<List<Map<String, dynamic>>> getAnswers(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // ----------------------
  // New methods for Group tracking

  // Mark a group as present
  Future<void> markGroupPresent(int groupNumber) async {
    final db = await database;
    await db.insert(
      'WetTestGroups',
      {'group_id': groupNumber, 'is_present': 1},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all present groups
  Future<List<int>> getPresentGroups() async {
    final db = await database;
    final result = await db.query(
      'WetTestGroups',
      columns: ['group_id'],
      where: 'is_present = ?',
      whereArgs: [1],
    );
    return result.map((row) => row['group_id'] as int).toList();
  }

  // ----------------------
  // Clear specific test table
  Future<void> clearTest(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

  // Clear all tables
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
      'SaltA_WetTest',
      'SaltB_WetTest',
      'SaltC_WetTest',
      'SaltD_WetTest',
      'WetTestGroups',
    ];
    for (var table in tables) {
      await db.delete(table);
    }
    _database = null;
  }

  // Reset database completely
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _database = null;
  }

  // ----------------------
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

// ------------------------
// Extension to prefill correct answers
extension DatabaseHelperCorrectAnswers on DatabaseHelper {
  Future<void> prefillCorrectAnswers() async {
    final db = await database;

    for (var tableEntry in correctAnswers.entries) {
      final tableName = tableEntry.key;
      final questions = tableEntry.value;

      for (var qEntry in questions.entries) {
        final questionId = qEntry.key;
        final answer = qEntry.value;

        await db.insert(
          tableName,
          {
            'question_id': questionId,
            'correct_answer': answer,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    print('✅ Correct answers prefilled in database');
  }
}
