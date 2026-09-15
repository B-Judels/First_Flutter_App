import 'package:flutter_test/flutter_test.dart';
import 'package:freeuse_monthly_expense_tracker/models/budget.dart';

void main() {
  test('daily projections follow the selected calendar month', () {
    expect(
      monthlyProjection(
        [10],
        ExpenseCategory.daily,
        daysInBudgetMonth(DateTime(2024, 2)),
      ),
      290,
    );
    expect(
      monthlyProjection(
        [10],
        ExpenseCategory.daily,
        daysInBudgetMonth(DateTime(2025, 2)),
      ),
      280,
    );
    expect(
      monthlyProjection(
        [10],
        ExpenseCategory.daily,
        daysInBudgetMonth(DateTime(2026, 1)),
      ),
      310,
    );
  });
  test('recurring costs do not count running subtotals twice', () {
    expect(monthlyProjection([10, 20], ExpenseCategory.weekly, 31), 120);
    expect(monthlyProjection([10, 20], ExpenseCategory.biweekly, 31), 60);
    expect(monthlyProjection([10, 20], ExpenseCategory.services, 31), 30);
  });
  test(
    'amount validation rejects invalid and nonfinite inputs consistently',
    () {
      for (final value in ['', 'abc', '-1', 'NaN', 'Infinity', '1e999']) {
        expect(amountError(value), isNotNull);
        expect(amountError(value, income: true), isNotNull);
      }
      expect(amountError('0'), isNull);
      expect(amountError('0', income: true), isNotNull);
      expect(amountError(' 12.50 ', income: true), isNull);
    },
  );
}
