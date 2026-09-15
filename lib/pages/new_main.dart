import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/ui_tools.dart';
import 'package:freeuse_monthly_expense_tracker/pages/startup_page.dart';

class Newmain extends StatelessWidget {
  Newmain({super.key});

  final uiTools = Uitools();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            style: TextStyle(color: Colors.blueGrey[50]),
            "Monthly Budget Planner",
          ),
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80.0),

              Container(
                margin: const EdgeInsets.all(10.0),
                width: double.maxFinite,

                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80.0,

                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StartUpPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: Text("Start New"),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80.0,

                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[100],
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: Text("Continue"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //comment to repush
}
