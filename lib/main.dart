import 'package:flutter/material.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Expence Tracker")),
          backgroundColor: Colors.teal[300],
        ),
        body: const Center(
          child: Image(image: AssetImage('images/automatic-payment.png')),
        ),
        backgroundColor: Colors.teal[100],
      ),
    );
  }
}
