import 'package:flutter/material.dart';

class DebitOrdersPage extends StatelessWidget {
  const DebitOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Debit Orders")),
      body: const Center(child: Text("Welcome to the Debit Orders page!")),
    );
  }
}
