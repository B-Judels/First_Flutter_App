import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/budget.dart';
import '../widgets/draft_guard.dart';
import '../widgets/expense_section.dart';
import '../widgets/load_error.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({
    super.key,
    required this.categories,
    this.month,
    this.database,
  });
  final List<ExpenseCategory> categories;
  final DateTime? month;
  final DatabaseHelper? database;
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DatabaseHelper get db => widget.database ?? DatabaseHelper.instance;
  Map<ExpenseCategory, List<Expense>> _items = {};
  String _currency = 'R';
  bool _loading = true, _failed = false, _saving = false, _dirty = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final settings = await db.getUserSettings();
      if (settings.isEmpty) throw StateError('Missing settings');
      final items = await db.loadExpenses(widget.categories);
      if (!mounted) return;
      setState(() {
        _items = items;
        _currency = settings.first.currency;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _save() async {
    if (_saving || _loading || _failed) return;
    setState(() => _saving = true);
    try {
      await db.saveExpenses(_items);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _dirty = false;
      });
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Expenses updated!')));
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save. Your changes are still here; please retry.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_failed) return LoadError(onRetry: _load);
    return DraftGuard(
      dirty: _dirty,
      saving: _saving,
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage expenses')),
        body: AbsorbPointer(
          absorbing: _saving,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final category in widget.categories)
                ExpenseSection(
                  category: category,
                  items: _items[category]!,
                  currency: _currency,
                  days: daysInBudgetMonth(widget.month ?? DateTime.now()),
                  onChanged: (items) => setState(() {
                    _items[category] = items;
                    _dirty = true;
                  }),
                ),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving...' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
