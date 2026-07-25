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
        backgroundColor: Colors.teal[100],
        appBar: AppBar(
          title: const Center(child: Text("Expence Tracker")),
          backgroundColor: Colors.teal[300],
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              color: Colors.amber[100],
              width: 400.0,
              height: 400.0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color: Colors.pink[100],
                          height: 150.0,
                          width: 150.0,
                          padding: EdgeInsets.all(10.0),

                          child: Text("Monthly Debit Orders"),
                        ),

                        Container(
                          color: Colors.pink[100],
                          height: 150.0,
                          width: 150.0,
                          padding: EdgeInsets.all(10.0),

                          child: Text("Monthly Debit Orders"),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          color: Colors.pink[100],
                          height: 150.0,
                          width: 150.0,
                          padding: EdgeInsets.all(10.0),

                          child: Text("Dayly Habit Costs"),
                        ),

                        Container(
                          color: Colors.pink[100],
                          height: 150.0,
                          width: 150.0,
                          padding: EdgeInsets.all(10.0),

                          child: Text("Monthly Debit Orders"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
