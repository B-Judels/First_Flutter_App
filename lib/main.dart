import 'package:flutter/material.dart';
import 'package:first_flutter_app/uiTools.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  final uiTools = Uitools();

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
            child: Column(
              children: [
                Container(height: 40),

                SizedBox(height: 10),

                Container(
                  // color: Colors.amber[100],
                  width: double.infinity,

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Center(
                                child: uiTools.imgBtnTitleContainer(
                                  "Monthly Debit Orders",
                                  "images/automatic-payment.png",
                                ),
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Monthly Debit Orders"),

                                      SizedBox(height: 20),

                                      OutlinedButton(
                                        onPressed: () {},
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Monthly Debit Orders"),

                                      SizedBox(height: 20),

                                      OutlinedButton(
                                        onPressed: () {},
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.pink[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Text("Monthly Debit Orders"),

                                      SizedBox(height: 20),

                                      OutlinedButton(
                                        onPressed: () {},
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
