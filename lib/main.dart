import 'package:flutter/material.dart';
import 'package:first_flutter_app/uiTools.dart';
import 'package:first_flutter_app/StartUpPage.dart';

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
          title: Center(
            child: Text(
              style: TextStyle(color: Colors.blueGrey[50]),
              "Monthly Expence Tracker: ",
            ),
          ),
          backgroundColor: Colors.teal[700],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                width: double.maxFinite,

                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          style: TextStyle(color: Colors.black),
                          "Current Monthly Income: ",
                        ),
                        Text("Current Monthly Expences: "),
                        Text("End of Month Prediction: "),
                      ],
                    ),

                    const Spacer(),

                    Container(
                      child: Column(
                        children: [
                          Text("Edit Income"),
                          uiTools.btn1("images/recieve.png"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                // color: Colors.amber[100],
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),

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

                          SizedBox(width: 10),

                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Daily habit costs",
                                "images/24-hours-service.png",
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
                              child: uiTools.imgBtnTitleContainer(
                                "Healthcare",
                                "images/healthcare.png",
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Monthly Services",
                                "images/attendant.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                width: double.maxFinite,

                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [],
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
}
