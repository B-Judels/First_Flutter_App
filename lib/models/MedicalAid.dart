class MedicalAid {
  final int? id;
  final String name;
  final double costMedAid;

  MedicalAid({this.id, required this.name, required this.costMedAid});

  int? get getId => id;

  double get getMedAidCost => costMedAid;
  String get getName => name;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'cost': costMedAid};
  }

  factory MedicalAid.fromMap(Map<String, dynamic> map) {
    return MedicalAid(
      id: map['id'],
      name: map['name'],
      costMedAid: (map['cost'] as num).toDouble(),
    );
  }
}
