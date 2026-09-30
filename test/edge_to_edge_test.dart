import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freeuse_monthly_expense_tracker/models/budget.dart';
import 'package:freeuse_monthly_expense_tracker/pages/expense_page.dart';
import 'package:freeuse_monthly_expense_tracker/pages/startup_page.dart';
import 'widget_test.dart' show FakeDatabase;

void main() {
  for (final setup in [true, false]) {
    for (final keyboard in [false, true]) {
      testWidgets('System insets: setup=$setup keyboard=$keyboard', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 600);
        tester.view.viewPadding = const FakeViewPadding(
          left: 40,
          top: 24,
          right: 32,
          bottom: 48,
        );
        tester.view.padding = FakeViewPadding(
          left: 40,
          top: 24,
          right: 32,
          bottom: keyboard ? 0 : 48,
        );
        tester.view.viewInsets = FakeViewPadding(bottom: keyboard ? 250 : 0);
        addTearDown(tester.view.reset);
        final db = FakeDatabase();
        await tester.pumpWidget(
          MaterialApp(
            home: setup
                ? StartUpPage(database: db)
                : ExpensePage(database: db, categories: ExpenseCategory.values),
          ),
        );
        await tester.pumpAndSettle();
        final button = find.widgetWithText(
          FilledButton,
          setup ? 'Save and Calculate' : 'Update',
        );
        await tester.scrollUntilVisible(
          button,
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        final rect = tester.getRect(button);
        expect(rect.left, greaterThanOrEqualTo(40));
        expect(rect.right, lessThanOrEqualTo(800 - 32));
        expect(rect.bottom, lessThanOrEqualTo(600 - (keyboard ? 250 : 48)));
        expect(button.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
