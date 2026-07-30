import 'package:flutter/material.dart';

class Services extends StatelessWidget {
  final String name;
  final double costService;

  // Changed to named optional parameters inside curly braces {}
  // Added 'required' to ensure the data is passed when navigating
  const Services({
    super.key, // Standard best practice for Flutter widget keys
    required this.name,
    required this.costService,
  });

  double get getServiceCost => costService;
  String get getName => name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Services")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to the Debit Orders page!"),
            const SizedBox(height: 10),
            // Displaying your final constructor variables safely in the UI
            Text("Account Name: $name"),
            Text("Cost: R${costService.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
