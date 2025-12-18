import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ChemStudio/DB/database_helper.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   // 🔴 TEMPORARY – RUN ONCE
  //await DatabaseHelper.instance.resetDatabase();

  // ✅ Use FFI only for desktop (Windows/Linux/Mac)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // ✅ Initialize database before app runs
 await DatabaseHelper.instance.database;

  // ⚠️ Optional: Uncomment below to clear all data every time app starts
  // await DatabaseHelper.instance.clearAllAnswers();

  // ✅ Export the database to Downloads folder (for viewing in DB Browser for SQLite)
  try {
    await DatabaseHelper.instance.exportDatabase();
    print('✅ Database successfully exported to Downloads folder.');
  } catch (e) {
    print('❌ Failed to export database: $e');
  }

  // ✅ Run the app
  runApp(const ChemStudioApp());
}

class ChemStudioApp extends StatelessWidget {
  const ChemStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChemStudio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004C91)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
