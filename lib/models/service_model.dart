import 'budget.dart';

class Service {
  final int? id;
  final String serviceName;
  final double serviceCost;

  Service({this.id, required this.serviceName, required this.serviceCost});

  int? get getId => id;

  String get getName => serviceName;

  double get getCost => serviceCost;

  Map<String, dynamic> toMap() {
    validateMoney(serviceCost);
    if (serviceName.trim().isEmpty) {
      throw ArgumentError('An expense needs a name.');
    }
    return {'id': id, 'name': serviceName, 'cost': serviceCost};
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'],
      serviceName: map['name'],
      serviceCost: (map['cost'] as num).toDouble(),
    );
  }
}
