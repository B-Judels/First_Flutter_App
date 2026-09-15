import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:freeuse_monthly_expense_tracker/main.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';
import 'package:freeuse_monthly_expense_tracker/models/budget.dart';
import 'package:freeuse_monthly_expense_tracker/models/user_settings.dart';
import 'package:freeuse_monthly_expense_tracker/pages/expense_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/startup_page.dart';
import 'package:freeuse_monthly_expense_tracker/widgets/expense_section.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/budget_progress_bar.dart';

class FakeDatabase extends DatabaseHelper {
  FakeDatabase() : super.withFactory(databaseFactoryFfi, inMemoryDatabasePath);
  bool failLoad = false, failSave = false, hasSettings = true;
  Completer<void>? loading, saving;
  int writes = 0;
  Map<ExpenseCategory, List<Expense>> saved = {};
  @override
  Future<List<UserSettings>> getUserSettings() async {
    await loading?.future;
    if (failLoad) throw StateError('load failed');
    return hasSettings ? [UserSettings(userIncome: 1000, currency: 'R')] : [];
  }

  @override
  Future<Map<ExpenseCategory, List<Expense>>> loadExpenses(
    List<ExpenseCategory> categories,
  ) async => {
    for (final category in categories) category: List.of(saved[category] ?? []),
  };
  @override
  Future<void> saveExpenses(
    Map<ExpenseCategory, List<Expense>> categories, {
    UserSettings? settings,
  }) async {
    writes++;
    await saving?.future;
    if (failSave) throw StateError('save failed');
    saved = categories.map((key, value) => MapEntry(key, List.of(value)));
  }
}

void main() {
  Future<void> tallScreen(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  Future<void> addExpense(
    WidgetTester tester,
    String category,
    String name,
  ) async {
    final add = find.text('Add $category');
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), name);
    await tester.enterText(find.widgetWithText(TextFormField, 'Amount'), '10');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
  }

  testWidgets('startup loads onboarding and retries failures', (tester) async {
    final db = FakeDatabase()..failLoad = true;
    await tester.pumpWidget(MyApp(database: db));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    db
      ..failLoad = false
      ..hasSettings = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Set up your budget'), findsOneWidget);
  });

  testWidgets(
    'cancel edit preserves original; applying keeps ID and other rows',
    (tester) async {
      var items = [
        const Expense(id: 1, name: 'First', cost: 10),
        const Expense(id: 2, name: 'Second', cost: 20),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ExpenseSection(
                category: ExpenseCategory.services,
                items: items,
                currency: 'R',
                days: 31,
                onChanged: (next) => setState(() => items = next),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Edit Second'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Name'),
        'Changed',
      );
      expect(items.last.name, 'Second');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(items.map((e) => e.name), ['First', 'Second']);
      await tester.tap(find.byTooltip('Edit Second'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Name'),
        'Changed',
      );
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(items.map((e) => e.name), ['First', 'Changed']);
      expect(items.last.id, 2);
    },
  );

  testWidgets('loading and failed reads cannot expose Update', (tester) async {
    final db = FakeDatabase()
      ..loading = Completer<void>()
      ..failLoad = true;
    await tester.pumpWidget(
      MaterialApp(
        home: ExpensePage(
          database: db,
          categories: const [ExpenseCategory.daily],
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Update'), findsNothing);
    db.loading!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Update'), findsNothing);
    expect(db.writes, 0);
    db.failLoad = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Update'), findsOneWidget);
  });

  testWidgets(
    'failed save retains all frequency drafts and retry persists all',
    (tester) async {
      await tallScreen(tester);
      final db = FakeDatabase()..failSave = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExpensePage(
                      database: db,
                      categories: const [
                        ExpenseCategory.daily,
                        ExpenseCategory.weekly,
                        ExpenseCategory.biweekly,
                      ],
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await addExpense(tester, 'Daily Habits', 'Coffee');
      await addExpense(tester, 'Weekly Habits', 'Train');
      await addExpense(tester, 'Bi-Weekly Habits', 'Lunch');
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Train'), findsOneWidget);
      expect(find.textContaining('Unable to save.'), findsOneWidget);
      db.failSave = false;
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(db.saved.values.every((items) => items.length == 1), isTrue);
      expect(db.saved.keys, hasLength(3));
    },
  );

  testWidgets('onboarding blocks repeat save and retains draft on failure', (
    tester,
  ) async {
    await tallScreen(tester);
    final db = FakeDatabase()
      ..saving = Completer<void>()
      ..failSave = true;
    await tester.pumpWidget(MaterialApp(home: StartUpPage(database: db)));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Monthly income'),
      '1000',
    );
    await tester.ensureVisible(find.text('Save and Calculate'));
    await tester.tap(find.text('Save and Calculate'));
    await tester.tap(find.text('Save and Calculate'));
    await tester.pump();
    expect(db.writes, 1);
    db.saving!.complete();
    await tester.pumpAndSettle();
    expect(find.textContaining('Unable to save.'), findsOneWidget);
    expect(find.text('1000'), findsOneWidget);
  });

  testWidgets('back navigation offers discard and keep editing', (
    tester,
  ) async {
    final db = FakeDatabase();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpensePage(
                    database: db,
                    categories: const [ExpenseCategory.services],
                  ),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await addExpense(tester, 'Services', 'Water');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep editing'));
    await tester.pumpAndSettle();
    expect(find.text('Water'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
    expect(db.writes, 0);
  });

  testWidgets('progress bar uses selected currency and supports overspending', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BudgetProgressBar(income: 100, expenses: 120, currency: 'R'),
        ),
      ),
    );
    expect(find.text('Expenses: R 120.00'), findsOneWidget);
    expect(find.text('Remaining: -R 20.00'), findsOneWidget);
  });
}
