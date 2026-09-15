import 'expense_page.dart';
import '../models/budget.dart';

class DailyHabitPage extends ExpensePage {
  const DailyHabitPage({super.key, super.database, super.month})
    : super(
        categories: const [
          ExpenseCategory.daily,
          ExpenseCategory.weekly,
          ExpenseCategory.biweekly,
        ],
      );
}
