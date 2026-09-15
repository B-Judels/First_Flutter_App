import 'expense_page.dart';
import '../models/budget.dart';

class ServicePage extends ExpensePage {
  const ServicePage({super.key, super.database, super.month})
    : super(categories: const [ExpenseCategory.services]);
}
