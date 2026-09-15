import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freeuse_monthly_expense_tracker/models/bi_weekly_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/daily_habit.dart';
import 'package:freeuse_monthly_expense_tracker/models/debit_order.dart';
import 'package:freeuse_monthly_expense_tracker/models/medical_aid.dart';
import 'package:freeuse_monthly_expense_tracker/models/service_model.dart';
import 'package:freeuse_monthly_expense_tracker/models/user_settings.dart';
import 'package:freeuse_monthly_expense_tracker/models/weekly_habit.dart';
import 'package:freeuse_monthly_expense_tracker/pages/home.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/budget_progress_bar.dart';
import 'widget_test.dart' show FakeDatabase;

class HomeDatabase extends FakeDatabase {
  @override
  Future<List<DebitOrder>> getDebitOrders() async => [];
  @override
  Future<List<Service>> getServices() async => [];
  @override
  Future<List<MedicalAid>> getMedicalAids() async => [];
  @override
  Future<List<DailyHabit>> getDailyHabits() async => [];
  @override
  Future<List<WeeklyHabit>> getWeeklyHabits() async => [
    WeeklyHabit(name: 'First', costWHabit: 10),
    WeeklyHabit(name: 'Second', costWHabit: 20),
  ];
  @override
  Future<List<BiWeeklyHabit>> getBiWeeklyHabits() async => [];
  @override
  Future<void> replaceUserSettings(List<UserSettings> settings) async {
    throw StateError('write failure');
  }
}

void main() {
  testWidgets(
    'dashboard chart and spending agree for multiple weekly expenses',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(home: Home(database: HomeDatabase())),
      );
      await tester.pumpAndSettle();
      final chart = tester.widget<PieChart>(find.byType(PieChart));
      final weekly = chart.data.sections.singleWhere(
        (section) => section.value == 120,
      );
      expect(weekly.title, '100%');
      final bar = tester.widget<BudgetProgressBar>(
        find.byType(BudgetProgressBar),
      );
      expect(bar.expenses, 120);
      expect(bar.income, 1000);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('home handles empty settings without a range error', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Home(database: HomeDatabase()..hasSettings = false)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed income update leaves displayed income unchanged', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(home: Home(database: HomeDatabase())));
    await tester.pumpAndSettle();
    final menu = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'images/menu-burger.png',
    );
    await tester.ensureVisible(menu);
    await tester.tap(menu);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    final income = find.byType(TextField);
    await tester.ensureVisible(income);
    await tester.enterText(income, '2000');
    await tester.ensureVisible(find.text('Update'));
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Update'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Unable to save income. Please retry.'), findsOneWidget);
    expect(
      tester.widget<BudgetProgressBar>(find.byType(BudgetProgressBar)).income,
      1000,
    );
  });
}
