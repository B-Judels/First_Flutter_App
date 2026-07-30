import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:first_flutter_app/models/DebitOrder.dart';
import 'package:first_flutter_app/models/Service.dart';
import 'package:first_flutter_app/models/MedicalAid.dart';
import 'package:first_flutter_app/models/DailyHabit.dart';

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
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    cost REAL NOT NULL
)
     ''');

    await db.execute('''
      CREATE TABLE daily_habits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    cost REAL NOT NULL
)
''');

    await db.execute('''
      CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    cost REAL NOT NULL

)
''');

    await db.execute('''
      CREATE TABLE medical_aid (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    cost REAL NOT NULL
)
''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> insertDebitOrder(DebitOrder order) async {
    final db = await database;

    return await db.insert('debit_orders', order.toMap());
  }

  Future<List<DebitOrder>> getDebitOrders() async {
    final db = await database;

    final maps = await db.query('debit_orders');

    return maps.map((map) => DebitOrder.fromMap(map)).toList();
  }

  Future<int> insertService(Service service) async {
    final db = await database;

    return await db.insert('services', service.toMap());
  }

  Future<List<Service>> getServices() async {
    final db = await database;

    final maps = await db.query('services');

    return maps.map((map) => Service.fromMap(map)).toList();
  }

  Future<int> insertMedicalAid(MedicalAid medicalAid) async {
    final db = await database;

    return await db.insert('medical_aid', medicalAid.toMap());
  }

  Future<List<MedicalAid>> getMedicalAids() async {
    final db = await database;

    final maps = await db.query('medical_aid');

    return maps.map((map) => MedicalAid.fromMap(map)).toList();
  }

  Future<int> insertDailyHabit(DailyHabit habit) async {
    final db = await database;

    return await db.insert('daily_habits', habit.toMap());
  }

  Future<List<DailyHabit>> getDailyHabits() async {
    final db = await database;

    final maps = await db.query('daily_habits');

    return maps.map((map) => DailyHabit.fromMap(map)).toList();
  }
}
