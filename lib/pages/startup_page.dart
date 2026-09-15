import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_settings.dart';
import '../models/budget.dart';
import '../widgets/draft_guard.dart';
import '../widgets/expense_section.dart';
import 'home.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key, this.database});
  final DatabaseHelper? database;
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
  @override
  void dispose() {
    _income.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save. Your budget is still here; please retry.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => DraftGuard(
    dirty: _dirty,
    saving: _saving,
    child: Scaffold(
      appBar: AppBar(title: const Text('Set up your budget')),
      body: AbsorbPointer(
        absorbing: _saving,
        child: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Plan your recurring monthly expenses. All amounts are entered manually.',
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
                decoration: const InputDecoration(labelText: 'Monthly income'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() => _dirty = true),
                validator: (value) => amountError(value, income: true),
              ),
              const SizedBox(height: 16),
              for (final category in ExpenseCategory.values)
                ExpenseSection(
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
  );
}
