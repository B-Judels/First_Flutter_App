import 'budget.dart';

class BiWeeklyHabit {
  final int? id;

  final String name;

  final double costBWHabit;

  BiWeeklyHabit({this.id, required this.name, required this.costBWHabit});

  int? get getId => id;

  String get getName => name;

  double get getCost => costBWHabit;

  Map<String, dynamic> toMap() {
    validateMoney(costBWHabit);
    if (name.trim().isEmpty) throw ArgumentError('An expense needs a name.');
    return {'id': id, 'name': name, 'cost': costBWHabit};
  }

  factory BiWeeklyHabit.fromMap(Map<String, dynamic> map) {
    return BiWeeklyHabit(
      id: map['id'],
      name: map['name'],
      costBWHabit: (map['cost'] as num).toDouble(),
    );
  }
}
