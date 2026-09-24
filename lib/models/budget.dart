enum ExpenseCategory {
  debitOrders('debit_orders', 'Debit Orders'),
  services('services', 'Services'),
  insurance('medical_aid', 'Insurance'),
  daily('daily_habits', 'Daily Habits'),
  weekly('weekly_habits', 'Weekly Habits'),
  biweekly('bi_weekly_habits', 'Bi-Weekly Habits');

  const ExpenseCategory(this.table, this.label);
  final String table;
  final String label;

  String get description => switch (this) {
    debitOrders =>
      'Debit orders are recurring monthly payments automatically deducted from your account, such as loan repayments, subscriptions, or rent.',
    services =>
      'Services are recurring monthly expenses such as electricity, internet, cellphone contracts, water, or class fees.',
    insurance =>
      'Insurance includes monthly medical aid and other insurance premiums. Enter the amount you pay each month.',
    daily =>
      'Daily habits are everyday purchases such as snacks, transport, or drinks. Enter the cost per day; the monthly projection uses the number of days in the selected month.',
    weekly =>
      'Weekly habits are purchases or activities paid for each week. Enter the cost per week; the monthly projection estimates four payments.',
    biweekly =>
      'Bi-weekly habits are purchases or activities paid for every two weeks. Enter the cost per payment; the monthly projection estimates two payments.',
  };

  int multiplier(int days) => switch (this) {
    daily => days,
    weekly => 4,
    biweekly => 2,
    _ => 1,
  };
}

int daysInBudgetMonth(DateTime month) =>
    DateTime(month.year, month.month + 1, 0).day;

String? amountError(String? text, {bool income = false}) {
  final amount = double.tryParse(text?.trim() ?? '');
  if (amount == null ||
      !amount.isFinite ||
      amount < 0 ||
      (income && amount == 0)) {
    return income
        ? 'Enter a positive, finite income.'
        : 'Enter a valid amount of zero or more.';
  }
  return null;
}

void validateMoney(num amount, {bool income = false}) {
  if (!amount.isFinite || amount < 0 || (income && amount == 0)) {
    throw ArgumentError('Invalid ${income ? 'income' : 'expense'} amount.');
  }
}

class Expense {
  const Expense({this.id, required this.name, required this.cost});
  final int? id;
  final String name;
  final double cost;

  factory Expense.fromMap(Map<String, Object?> map) => Expense(
    id: map['id'] as int?,
    name: map['name'] as String,
    cost: (map['cost'] as num).toDouble(),
  );

  Map<String, Object?> toMap() {
    validateMoney(cost);
    if (name.trim().isEmpty) throw ArgumentError('An expense needs a name.');
    return {'id': id, 'name': name.trim(), 'cost': cost};
  }
}

double projectedTotal(
  Iterable<Expense> expenses,
  ExpenseCategory category,
  int days,
) => monthlyProjection(expenses.map((expense) => expense.cost), category, days);

double monthlyProjection(
  Iterable<double> costs,
  ExpenseCategory category,
  int days,
) => costs.fold(0.0, (sum, cost) => sum + cost) * category.multiplier(days);
