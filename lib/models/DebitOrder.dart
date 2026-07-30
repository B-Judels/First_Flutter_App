class DebitOrder {
  final int? id;
  final String name;
  final double cost;

  DebitOrder({this.id, required this.name, required this.cost});

  int? get getId => id;

  String get getName => name;

  double get getCost => cost;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'cost': cost};
  }

  factory DebitOrder.fromMap(Map<String, dynamic> map) {
    return DebitOrder(
      id: map['id'],
      name: map['name'],
      cost: (map['cost'] as num).toDouble(),
    );
  }
}
