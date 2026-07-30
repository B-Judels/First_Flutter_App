import 'package:flutter/material.dart';

class MedicalAid extends StatelessWidget {
  final String name;
  final double costMedAid;

  // Changed to named optional parameters inside curly braces {}
  // Added 'required' to ensure the data is passed when navigating
  const MedicalAid({
    super.key, // Standard best practice for Flutter widget keys
    required this.name,
    required this.costMedAid,
  });

  double get getMedAidCost => costMedAid;
  String get getName => name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Medical Aid")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to the Medical Aid page!"),
            const SizedBox(height: 10),

            // Displaying your final constructor variables safely in the UI
          ],
        ),
      ),
    );
  }
}
