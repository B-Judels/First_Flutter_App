import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/budget.dart';

import 'package:freeuse_monthly_expense_tracker/models/debit_order.dart';
import 'package:freeuse_monthly_expense_tracker/models/service_model.dart';
import 'package:freeuse_monthly_expense_tracker/models/medical_aid.dart';
import 'package:freeuse_monthly_expense_tracker/models/daily_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/weekly_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/bi_weekly_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/user_settings.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init() : _factory = null, _path = null;

  DatabaseHelper.withFactory(DatabaseFactory factory, String path)
    : _factory = factory,
      _path = path;

  final DatabaseFactory? _factory;
  final String? _path;

  Database? _database;
  Future<Database>? _opening;

  Future<Database> get database async {
    if (_database != null) return _database!;

    try {
      return _database = await (_opening ??= _initDB('expense_tracker.db'));
    } finally {
      _opening = null;
    }
  }

  Future<Database> _initDB(String fileName) async {
    final factory = _factory ?? databaseFactory;
    final path = _path ?? join(await factory.getDatabasesPath(), fileName);

    return await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      ),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        income REAL NOT NULL,
        currency TEXT NOT NULL
      )
    ''');

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

    await db.execute('''
      CREATE TABLE weekly_habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bi_weekly_habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE user_settings
      ADD COLUMN currency TEXT NOT NULL DEFAULT 'R'
    ''');
    }
  }

  Future<void> close() async {
    final db = _database ?? await _opening;
    await db?.close();
    _database = null;
  }

  Future<int> insertUserSettings(UserSettings settings) async {
    final row = settings.toMap();
    final db = await database;
    return db.transaction((txn) async {
      await txn.delete('user_settings');
      return txn.insert('user_settings', row);
    });
  }

  Future<List<UserSettings>> getUserSettings() async {
    final db = await database;

    final maps = await db.query('user_settings', orderBy: 'id');

    return maps.map((map) => UserSettings.fromMap(map)).toList();
  }

  Future<void> replaceUserSettings(List<UserSettings> settingsList) async {
    if (settingsList.length != 1) {
      throw ArgumentError('Exactly one income setting is required.');
    }
    await insertUserSettings(settingsList.single);
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

  Future<void> replaceDebitOrders(List<DebitOrder> orders) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('debit_orders');

      for (DebitOrder order in orders) {
        await txn.insert('debit_orders', order.toMap());
      }
    });
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

  Future<void> replaceServices(List<Service> services) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('services');

      for (Service service in services) {
        await txn.insert('services', service.toMap());
      }
    });
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

  Future<void> replaceMedicalAids(List<MedicalAid> medicalAids) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('medical_aid');

      for (MedicalAid medicalAid in medicalAids) {
        await txn.insert('medical_aid', medicalAid.toMap());
      }
    });
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

  Future<void> replaceDailyHabits(List<DailyHabit> habits) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('daily_habits');

      for (DailyHabit habit in habits) {
        await txn.insert('daily_habits', habit.toMap());
      }
    });
  }

  Future<int> insertWeeklyHabit(WeeklyHabit habit) async {
    final db = await database;

    return await db.insert('weekly_habits', habit.toMap());
  }

  Future<List<WeeklyHabit>> getWeeklyHabits() async {
    final db = await database;

    final maps = await db.query('weekly_habits');

    return maps.map((map) => WeeklyHabit.fromMap(map)).toList();
  }

  Future<void> replaceWeeklyHabits(List<WeeklyHabit> habits) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('weekly_habits');

      for (WeeklyHabit habit in habits) {
        await txn.insert('weekly_habits', habit.toMap());
      }
    });
  }

  Future<int> insertBiWeeklyHabit(BiWeeklyHabit habit) async {
    final db = await database;

    return await db.insert('bi_weekly_habits', habit.toMap());
  }

  Future<List<BiWeeklyHabit>> getBiWeeklyHabits() async {
    final db = await database;

    final maps = await db.query('bi_weekly_habits');

    return maps.map((map) => BiWeeklyHabit.fromMap(map)).toList();
  }

  Future<void> replaceBiWeeklyHabits(List<BiWeeklyHabit> habits) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('bi_weekly_habits');

      for (BiWeeklyHabit habit in habits) {
        await txn.insert('bi_weekly_habits', habit.toMap());
      }
    });
  }

  Future<void> deleteAllData() async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('user_settings');
      await txn.delete('debit_orders');
      await txn.delete('services');
      await txn.delete('medical_aid');
      await txn.delete('daily_habits');
      await txn.delete('weekly_habits');
      await txn.delete('bi_weekly_habits');
    });
  }

  Future<Map<ExpenseCategory, List<Expense>>> loadExpenses(
    List<ExpenseCategory> categories,
  ) async {
    final db = await database;
    return db.transaction((txn) async {
      final result = <ExpenseCategory, List<Expense>>{};
      for (final category in categories) {
        result[category] = (await txn.query(
          category.table,
          orderBy: 'id',
        )).map(Expense.fromMap).toList();
      }
      return result;
    });
  }

  /// Snapshot and validate before the first await, then commit all categories together.
  Future<void> saveExpenses(
    Map<ExpenseCategory, List<Expense>> categories, {
    UserSettings? settings,
  }) async {
    final rows = categories.map(
      (category, items) =>
          MapEntry(category, items.map((e) => e.toMap()).toList()),
    );
    final settingsRow = settings?.toMap();
    if (settings != null) {
      validateMoney(settings.userIncome, income: true);
      if (settings.currency.trim().isEmpty) {
        throw ArgumentError('Currency is required.');
      }
    }
    final db = await database;
    await db.transaction((txn) async {
      for (final entry in rows.entries) {
        await txn.delete(entry.key.table);
        for (final row in entry.value) {
          await txn.insert(entry.key.table, row);
        }
      }
      if (settingsRow != null) {
        await txn.delete('user_settings');
        await txn.insert('user_settings', settingsRow);
      }
    });
  }
}
