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
      expect(await (await migrated.database).getVersion(), 3);
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

  // These are the layouts from historical releases, not just today's schema
  // with its version number changed. Older v1 builds had only five tables.
  for (final layout in [
    (version: 1, currency: false, habits: false),
    (version: 1, currency: true, habits: true),
    (version: 2, currency: true, habits: false),
  ]) {
    test(
      'upgrades historical $layout without losing values and can save',
      () async {
        final directory = await Directory.systemTemp.createTemp(
          'budget-old-release-',
        );
        final path = '${directory.path}/expense_tracker.db';
        final old = await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: layout.version,
            onCreate: (db, _) async {
              await db.execute(
                'CREATE TABLE user_settings (id INTEGER PRIMARY KEY AUTOINCREMENT, income REAL NOT NULL${layout.currency ? ', currency TEXT NOT NULL' : ''})',
              );
              await db.insert('user_settings', {
                'id': 9,
                'income': 4321.5,
                if (layout.currency) 'currency': 'GBP',
              });
              for (final category in ExpenseCategory.values) {
                if (!layout.habits &&
                    [
                      ExpenseCategory.weekly,
                      ExpenseCategory.biweekly,
                    ].contains(category)) {
                  continue;
                }
                await db.execute(
                  'CREATE TABLE ${category.table} (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, cost REAL NOT NULL)',
                );
                await db.insert(category.table, {
                  'id': 7,
                  'name': 'Saved ${category.label}',
                  'cost': 20.5,
                });
              }
            },
          ),
        );
        await old.close();
        final upgraded = DatabaseHelper.withFactory(databaseFactoryFfi, path);
        try {
          final settings = (await upgraded.getUserSettings()).single;
          expect(settings.id, 9);
          expect(settings.userIncome, 4321.5);
          expect(settings.currency, layout.currency ? 'GBP' : 'R');
          final expenses = await upgraded.loadExpenses(ExpenseCategory.values);
          for (final category in ExpenseCategory.values) {
            if (!layout.habits &&
                [
                  ExpenseCategory.weekly,
                  ExpenseCategory.biweekly,
                ].contains(category)) {
              expect(expenses[category], isEmpty);
            } else {
              expect(expenses[category]!.single.id, 7);
              expect(
                expenses[category]!.single.name,
                'Saved ${category.label}',
              );
              expect(expenses[category]!.single.cost, 20.5);
            }
          }
          expenses[ExpenseCategory.weekly]!.add(
            const Expense(name: 'New weekly expense', cost: 15),
          );
          await upgraded.saveExpenses(expenses, settings: settings);
          await upgraded.close();
          expect((await upgraded.getUserSettings()).single.userIncome, 4321.5);
          expect(
            (await upgraded.loadExpenses([
              ExpenseCategory.weekly,
            ]))[ExpenseCategory.weekly]!.last.name,
            'New weekly expense',
          );
        } finally {
          await upgraded.close();
          await databaseFactoryFfi.deleteDatabase(path);
          await directory.delete();
        }
      },
    );
  }
}
