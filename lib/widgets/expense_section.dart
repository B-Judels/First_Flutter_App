import 'package:flutter/material.dart';
import '../models/budget.dart';

/// Editing uses a modal draft; the original list is untouched until confirmation.
class ExpenseSection extends StatelessWidget {
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
          Text(category.label, style: Theme.of(context).textTheme.titleLarge),
          Text(
            'Monthly projection: $currency ${projectedTotal(items, category, days).toStringAsFixed(2)}',
          ),
          if (category == ExpenseCategory.weekly ||
              category == ExpenseCategory.biweekly)
            Text('Estimate: ${category.multiplier(days)} payments per month.'),
          for (var i = 0; i < items.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(items[i].name),
              subtitle: Text('$currency ${items[i].cost.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit ${items[i].name}',
                    icon: const Icon(Icons.edit),
                    onPressed: () => _edit(context, i),
                  ),
                  IconButton(
                    tooltip: 'Delete ${items[i].name}',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      final next = List<Expense>.of(items)..removeAt(i);
                      onChanged(next);
                    },
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
