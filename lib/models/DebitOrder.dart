import 'package:flutter/material.dart';

class DebitOrdersPage extends StatelessWidget {
  final String name;
  final double costDebit;

  // Changed to named optional parameters inside curly braces {}
  // Added 'required' to ensure the data is passed when navigating
  const DebitOrdersPage({
    super.key, // Standard best practice for Flutter widget keys
    required this.name,
    required this.costDebit,
  });

  double get getDebitCost => costDebit;
  String get getName => name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Debit Orders")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to the Debit Orders page!"),
            const SizedBox(height: 10),
            // Displaying your final constructor variables safely in the UI
            Text("Account Name: $name"),
            Text("Cost: R${costDebit.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
