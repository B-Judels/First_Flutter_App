import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';
import 'package:freeuse_monthly_expense_tracker/models/budget.dart';
import 'package:freeuse_monthly_expense_tracker/models/user_settings.dart';

void main() {
  sqfliteFfiInit();
  late DatabaseHelper helper;
  setUp(
    () => helper = DatabaseHelper.withFactory(
      databaseFactoryFfi,
      inMemoryDatabasePath,
    ),
  );
  tearDown(() => helper.close());
  final settings = UserSettings(userIncome: 1000, currency: 'R');
  const original = Expense(name: 'Original', cost: 10);

  test('whole-budget save is repeatable and keeps one settings row', () async {
    final draft = {
      for (final c in ExpenseCategory.values) c: [original],
    };
    await helper.saveExpenses(draft, settings: settings);
    await helper.saveExpenses(draft, settings: settings);
    expect(await helper.getUserSettings(), hasLength(1));
    final loaded = await helper.loadExpenses(ExpenseCategory.values);
    for (final rows in loaded.values) {
      expect(rows, hasLength(1));
    }
  });

  test(
    'failure in a later category rolls back every earlier write and settings',
    () async {
      await helper.saveExpenses({
        ExpenseCategory.daily: [original],
      }, settings: settings);
      final db = await helper.database;
      await db.execute(
        "CREATE TRIGGER fail_weekly BEFORE INSERT ON weekly_habits BEGIN SELECT RAISE(ABORT, 'test failure'); END",
      );
      await expectLater(
        helper.saveExpenses({
          ExpenseCategory.daily: [const Expense(name: 'Changed', cost: 99)],
          ExpenseCategory.weekly: [original],
        }, settings: UserSettings(userIncome: 2000, currency: 'â‚¬')),
        throwsA(isA<DatabaseException>()),
      );
      final loaded = await helper.loadExpenses([ExpenseCategory.daily]);
      expect(loaded[ExpenseCategory.daily]!.single.name, 'Original');
      expect((await helper.getUserSettings()).single.userIncome, 1000);
    },
  );

  test('all habit frequencies persist in one save', () async {
    await helper.saveExpenses({
      ExpenseCategory.daily: [original],
      ExpenseCategory.weekly: [original],
      ExpenseCategory.biweekly: [original],
    });
    expect(await helper.getDailyHabits(), hasLength(1));
    expect(await helper.getWeeklyHabits(), hasLength(1));
    expect(await helper.getBiWeeklyHabits(), hasLength(1));
  });

  test('invalid values cannot replace saved data', () async {
    await helper.saveExpenses({
      ExpenseCategory.daily: [original],
    }, settings: settings);
    for (final amount in [-1.0, double.nan, double.infinity]) {
      await expectLater(
        helper.saveExpenses({
          ExpenseCategory.daily: [Expense(name: 'Bad', cost: amount)],
        }),
        throwsArgumentError,
      );
      await expectLater(
        helper.replaceUserSettings([
          UserSettings(userIncome: amount, currency: 'R'),
        ]),
        throwsArgumentError,
      );
    }
    expect((await helper.getDailyHabits()).single.name, 'Original');
    expect((await helper.getUserSettings()).single.userIncome, 1000);
  });

  test('v1 migration preserves budget and adds default currency', () async {
    final directory = await Directory.systemTemp.createTemp(
      'budget-migration-',
    );
    final path = '${directory.path}/budget.db';
    final old = await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) async {
          await db.execute(
            'CREATE TABLE user_settings (id INTEGER PRIMARY KEY AUTOINCREMENT, income REAL NOT NULL)',
          );
          for (final category in ExpenseCategory.values) {
            await db.execute(
              'CREATE TABLE ${category.table} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, cost REAL NOT NULL)',
            );
          }
          await db.insert('user_settings', {'income': 2500});
          await db.insert('debit_orders', {'name': 'Rent', 'cost': 500});
        },
      ),
    );
    await old.close();
    final migrated = DatabaseHelper.withFactory(databaseFactoryFfi, path);
    try {
      expect((await migrated.getUserSettings()).single.currency, 'R');
      expect((await migrated.getUserSettings()).single.userIncome, 2500);
      expect((await migrated.getDebitOrders()).single.cost, 500);
      expect(await (await migrated.database).getVersion(), 2);
    } finally {
      await migrated.close();
      await databaseFactoryFfi.deleteDatabase(path);
      await directory.delete();
    }
  });

  test(
    'concurrent opens share a connection and close permits reopen',
    () async {
      final connections = await Future.wait([helper.database, helper.database]);
      expect(identical(connections.first, connections.last), isTrue);
      await helper.close();
      expect((await helper.database).isOpen, isTrue);
    },
  );
}
