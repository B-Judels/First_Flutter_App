import 'package:flutter/material.dart';
import '../models/budget.dart';

class ExpenseSection extends StatefulWidget {
  const ExpenseSection({
    super.key,
    required this.category,
    required this.items,
    required this.currency,
    required this.days,
    required this.onChanged,
  });
  final ExpenseCategory category;
  final List<Expense> items;
  final String currency;
  final int days;
  final ValueChanged<List<Expense>> onChanged;

  @override
  State<ExpenseSection> createState() => _ExpenseSectionState();
}

class _ExpenseSectionState extends State<ExpenseSection> {
  bool _showInfo = false;
  ExpenseCategory get category => widget.category;
  List<Expense> get items => widget.items;
  String get currency => widget.currency;
  int get days => widget.days;
  ValueChanged<List<Expense>> get onChanged => widget.onChanged;

  Future<void> _edit(BuildContext context, [int? index]) async {
    final result = await showDialog<Expense>(
      context: context,
      builder: (_) =>
          _ExpenseDialog(expense: index == null ? null : items[index]),
    );
    if (result == null || !context.mounted) return;
    final next = List<Expense>.of(items);
    if (index == null) {
      next.add(result);
    } else {
      next[index] = result;
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                category.label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              OutlinedButton.icon(
                onPressed: () => setState(() => _showInfo = !_showInfo),
                icon: const Icon(Icons.info_outline),
                label: Text(_showInfo ? 'Hide Info' : 'Info'),
              ),
            ],
          ),
          if (_showInfo)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(category.description),
            ),
          Text(
            'Monthly projection: $currency ${projectedTotal(items, category, days).toStringAsFixed(2)}',
          ),
          if (category == ExpenseCategory.weekly ||
              category == ExpenseCategory.biweekly)
            Text('Estimate: ${category.multiplier(days)} payments per month.'),
          const SizedBox(height: 12),
          Text(
            items.isEmpty
                ? 'No expenses in this category yet.'
                : 'Expenses (${items.length})',
          ),
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    items[i].name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text('$currency ${items[i].cost.toStringAsFixed(2)}'),
                  Wrap(
                    spacing: 8,
                    children: [
                      Tooltip(
                        message: 'Edit ${items[i].name}',
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          onPressed: () => _edit(context, i),
                        ),
                      ),
                      Tooltip(
                        message: 'Delete ${items[i].name}',
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Delete'),
                          onPressed: () {
                            final next = List<Expense>.of(items)..removeAt(i);
                            onChanged(next);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => _edit(context),
            icon: const Icon(Icons.add),
            label: Text('Add ${category.label}'),
          ),
        ],
      ),
    ),
  );
}

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog({this.expense});
  final Expense? expense;
  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.expense?.name);
  late final _cost = TextEditingController(
    text: widget.expense?.cost.toString(),
  );
  @override
  void dispose() {
    _name.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.expense == null ? 'Add expense' : 'Edit expense'),
    content: SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a name.'
                  : null,
            ),
            TextFormField(
              controller: _cost,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: amountError,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (!_form.currentState!.validate()) return;
          Navigator.pop(
            context,
            Expense(
              id: widget.expense?.id,
              name: _name.text.trim(),
              cost: double.parse(_cost.text.trim()),
            ),
          );
        },
        child: const Text('Apply'),
      ),
    ],
  );
}
