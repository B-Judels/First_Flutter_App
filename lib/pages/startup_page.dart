import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../database/save_error.dart';
import '../models/user_settings.dart';
import '../models/budget.dart';
import '../widgets/draft_guard.dart';
import '../widgets/expense_section.dart';
import 'home.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key, this.database, this.initialExpenses});
  final DatabaseHelper? database;
  final Map<ExpenseCategory, List<Expense>>? initialExpenses;
  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  final _form = GlobalKey<FormState>();
  final _income = TextEditingController();
  final _items = {
    for (final category in ExpenseCategory.values) category: <Expense>[],
  };
  String _currency = 'R';
  bool _saving = false, _dirty = false;
  bool get _recovering =>
      widget.initialExpenses?.values.any((items) => items.isNotEmpty) ?? false;

  @override
  void initState() {
    super.initState();
    for (final entry
        in widget.initialExpenses?.entries ??
            <MapEntry<ExpenseCategory, List<Expense>>>[]) {
      _items[entry.key] = List.of(entry.value);
    }
  }

  @override
  void dispose() {
    _income.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final error = amountError(_income.text, income: true);
    if (error != null) {
      _form.currentState!.validate();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => _saving = true);
    try {
      await (widget.database ?? DatabaseHelper.instance).saveExpenses(
        _items,
        settings: UserSettings(
          userIncome: double.parse(_income.text.trim()),
          currency: _currency,
        ),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home(database: widget.database)),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(saveErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context) => DraftGuard(
    dirty: _dirty,
    saving: _saving,
    child: Scaffold(
      appBar: AppBar(
        title: Text(_recovering ? 'Restore your budget' : 'Set up your budget'),
      ),
      body: SafeArea(
        top: false,
        child: AbsorbPointer(
          absorbing: _saving,
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  _recovering
                      ? 'Your saved expenses were found, but monthly income is missing. Enter your income to continue; your expenses have been kept.'
                      : 'Plan your recurring monthly expenses. All amounts are entered manually.',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _currency,
                  decoration: const InputDecoration(labelText: 'Currency'),
                  items: const ['R', '\$', '\u20ac', '\u00a3']
                      .map(
                        (currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _currency = value!;
                    _dirty = true;
                  }),
                ),
                TextFormField(
                  controller: _income,
                  decoration: const InputDecoration(
                    labelText: 'Monthly income',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() => _dirty = true),
                  validator: (value) => amountError(value, income: true),
                ),
                const SizedBox(height: 16),
                for (final category in ExpenseCategory.values)
                  ExpenseSection(
                    key: ValueKey(category),
                    category: category,
                    items: _items[category]!,
                    currency: _currency,
                    days: daysInBudgetMonth(DateTime.now()),
                    onChanged: (items) => setState(() {
                      _items[category] = items;
                      _dirty = true;
                    }),
                  ),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving...' : 'Save and Calculate'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
