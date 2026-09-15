import 'expense_page.dart';
import '../models/budget.dart';

class MedAidPage extends ExpensePage {
  const MedAidPage({super.key, super.database, super.month})
    : super(categories: const [ExpenseCategory.insurance]);
}
