import 'expense_page.dart';
import '../models/budget.dart';

class DebitOrderPage extends ExpensePage {
  const DebitOrderPage({super.key, super.database, super.month})
    : super(categories: const [ExpenseCategory.debitOrders]);
}
