import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Expence Tracker")),
          backgroundColor: Colors.teal[300],
        ),
        body: const Center(child: Text("My first attempt at flutter!")),
        backgroundColor: Colors.teal[100],
      ),
    ),
  );
}
