class WeeklyHabit {
  final int? id;

  final String name;

  final double costWHabit;

  WeeklyHabit({this.id, required this.name, required this.costWHabit});

  int? get getId => id;

  String get getName => name;

  double get getCost => costWHabit;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'cost': costWHabit};
  }

  factory WeeklyHabit.fromMap(Map<String, dynamic> map) {
    return WeeklyHabit(
      id: map['id'],
      name: map['name'],
      costWHabit: (map['cost'] as num).toDouble(),
    );
  }
}
