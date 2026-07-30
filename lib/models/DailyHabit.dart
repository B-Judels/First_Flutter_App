class DailyHabit {
  final int? id;
  final String name;
  final double costDHabit;

  DailyHabit({this.id, required this.name, required this.costDHabit});

  int? get getId => id;
  String get getName => name;

  double get getCost => costDHabit;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'cost': costDHabit};
  }

  factory DailyHabit.fromMap(Map<String, dynamic> map) {
    return DailyHabit(
      id: map['id'],
      name: map['name'],
      costDHabit: (map['cost'] as num).toDouble(),
    );
  }
}
