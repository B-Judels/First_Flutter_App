class UserSettings {
  final int? id;
  final double userIncome;

  UserSettings({this.id, required this.userIncome});

  int? get getId => id;

  double get getIncome => userIncome;

  Map<String, dynamic> toMap() {
    return {'id': id, 'income': userIncome};
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      id: map['id'],
      userIncome: (map['income'] as num).toDouble(),
    );
  }
}
