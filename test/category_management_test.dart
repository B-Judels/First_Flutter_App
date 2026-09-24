import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freeuse_monthly_expense_tracker/models/budget.dart';
import 'package:freeuse_monthly_expense_tracker/pages/debit_order_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/service_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/med_aid_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/daily_habit_page.dart';
import 'widget_test.dart' show FakeDatabase;

void main() {
  for (final category in ExpenseCategory.values) {
    testWidgets(
      '${category.label}: existing expenses have info, edit, delete, and persist changes',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final db = FakeDatabase();
        db.saved = {
          category: [
            const Expense(id: 1, name: 'First expense', cost: 10),
            const Expense(id: 2, name: 'Second expense', cost: 20),
          ],
        };
        Widget page() => switch (category) {
          ExpenseCategory.debitOrders => DebitOrderPage(database: db),
          ExpenseCategory.services => ServicePage(database: db),
          ExpenseCategory.insurance => MedAidPage(database: db),
          _ => DailyHabitPage(database: db),
        };
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => page()),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );

        Future<void> open() async {
          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();
          await tester.scrollUntilVisible(
            find.byKey(ValueKey(category)),
            300,
            scrollable: find.byType(Scrollable).first,
          );
          await tester.pumpAndSettle();
        }

        await open();
        final section = find.byKey(ValueKey(category));
        final info = find.descendant(of: section, matching: find.text('Info'));
        await tester.ensureVisible(info);
        await tester.pumpAndSettle();
        await tester.tap(info);
        await tester.pumpAndSettle();
        expect(find.text(category.description), findsOneWidget);
        await tester.tap(find.text('Hide Info'));
        await tester.pumpAndSettle();
        expect(find.text('First expense'), findsOneWidget);
        expect(find.text('R 20.00'), findsOneWidget);
        final edit = find.byTooltip('Edit Second expense');
        await tester.ensureVisible(edit);
        await tester.pumpAndSettle();
        await tester.tap(edit);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Amount'),
          '45',
        );
        await tester.tap(find.text('Apply'));
        await tester.pumpAndSettle();
        expect(find.text('R 45.00'), findsOneWidget);
        final delete = find.byTooltip('Delete First expense');
        await tester.ensureVisible(delete);
        await tester.pumpAndSettle();
        await tester.tap(delete);
        await tester.pumpAndSettle();
        expect(find.text('First expense'), findsNothing);
        await tester.scrollUntilVisible(
          find.text('Update'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Update'));
        await tester.pumpAndSettle();
        expect(db.saved[category]!.single.id, 2);
        expect(db.saved[category]!.single.cost, 45);
        await open();
        expect(find.text('Second expense'), findsOneWidget);
        expect(find.text('R 45.00'), findsOneWidget);
        expect(find.byTooltip('Edit Second expense'), findsOneWidget);
        expect(find.byTooltip('Delete Second expense'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
