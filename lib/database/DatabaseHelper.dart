import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE debit_orders (
        debitorder_id INTEGER PRIMARY KEY AUTOINCREMENT,
        debitorder_name TEXT NOT NULL,
        debitorder_cost REAL NOT NULL
      )
    ''');

    Future close() async {
      final db = await instance.database;
      db.close();
    }

    await db.execute('''
      CREATE TABLE daily_habits (

        dailyhabit_id INTEGER PRIMARY KEY AUTOINCREMENT,
        dailyhabit_name TEXT NOT NULL,
        dailyhabit_cost REAL NOT NULL

)
''');

    await db.execute('''
      CREATE TABLE services (

        service_id INTEGER PRIMARY KEY AUTOINCREMENT,
        service_name TEXT NOT NULL,
        service_cost REAL NOT NULL

)
''');

    await db.execute('''
      CREATE TABLE medical_aid (

        medicalaid_id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicalaid_name TEXT NOT NULL,
        medicalaid_cost REAL NOT NULL

)
''');
  }
}
