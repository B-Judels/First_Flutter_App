class UserSettings {
  final int? id;
  final double userIncome;
  final String currency;

  UserSettings({this.id, required this.userIncome, required this.currency});

  int? get getId => id;

  double get getIncome => userIncome;

  String get getCurrency => currency;

  Map<String, dynamic> toMap() {
    return {'id': id, 'income': userIncome, 'currency': currency};
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    final savedCurrency = map['currency'];

    return UserSettings(
      id: map['id'],
      userIncome: (map['income'] as num).toDouble(),
      currency: savedCurrency is String && savedCurrency.isNotEmpty
          ? savedCurrency
          : "R",
    );
  }
}
