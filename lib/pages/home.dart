import 'package:flutter/material.dart';
import 'package:first_flutter_app/uiTools.dart';
import 'package:first_flutter_app/pages/StartUpPage.dart';
import 'package:first_flutter_app/pages/debit_order_page.dart';
import 'package:first_flutter_app/pages/service_page.dart';
import 'package:first_flutter_app/pages/daily_habit_page.dart';
import 'package:first_flutter_app/pages/med_aid_page.dart';
import 'package:first_flutter_app/models/DebitOrder.dart';
import 'package:first_flutter_app/models/Service.dart';
import 'package:first_flutter_app/models/MedicalAid.dart';
import 'package:first_flutter_app/models/DailyHabit.dart';
import 'package:first_flutter_app/models/UserSettings.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final uiTools = Uitools();

  //-----dummy data ----------------------------
  final List<UserSettings> userSettings = [UserSettings(userIncome: 25000)];

  final debitOrders = [
    DebitOrder(name: "Car Insurance", cost: 1200),
    DebitOrder(name: "Netflix", cost: 199),
    DebitOrder(name: "Gym", cost: 450),
  ];

  final services = [
    Service(serviceName: "Spotify", serviceCost: 89),
    Service(serviceName: "iCloud", serviceCost: 49),
  ];

  final medicalAids = [MedicalAid(name: "Discovery", costMedAid: 2500)];

  final dailyHabits = [
    DailyHabit(name: "Coffee", costDHabit: 40),
    DailyHabit(name: "Energy Drink", costDHabit: 25),
  ];

  int daysInMonth = 30;

  //--------------------------------------------
  double currentMonthTotal = 0;

  double debitTotal = 0;
  double serviceTotal = 0;
  double medTotal = 0;
  double habitTotal = 0;

  @override
  Widget build(BuildContext context) {
    double currentMonthTotal = 0;
    double debitTotal = 0;
    double serviceTotal = 0;
    double medTotal = 0;
    double habitTotal = 0;

    for (int i = 0; i < services.length; i++) {
      currentMonthTotal = services[i].getCost + currentMonthTotal;
      serviceTotal = serviceTotal + services[i].getCost;
    }

    for (int i = 0; i < debitOrders.length; i++) {
      currentMonthTotal = debitOrders[i].getCost + currentMonthTotal;
      debitTotal = debitTotal + debitOrders[i].getCost;
    }

    for (int i = 0; i < medicalAids.length; i++) {
      currentMonthTotal = medicalAids[i].getMedAidCost + currentMonthTotal;
      medTotal = medTotal + medicalAids[i].getMedAidCost;
    }

    for (int i = 0; i < dailyHabits.length; i++) {
      currentMonthTotal =
          (dailyHabits[i].getCost * daysInMonth) + currentMonthTotal;
      habitTotal = (dailyHabits[i].getCost * daysInMonth) + habitTotal;
    }

    double totalSpent = debitTotal + serviceTotal + medTotal + habitTotal;
    double endMonthPredict = userSettings[0].getIncome - totalSpent;

    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(2.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      "Current Monthly Income: R ${userSettings[0].getIncome.toStringAsFixed(2)}",
                    ),
                    Text(
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      "Current Monthly Expences: R ${currentMonthTotal.toStringAsFixed(2)}",
                    ),
                    Text(
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      "End of Month Prediction: R ${endMonthPredict.toStringAsFixed(2)}",
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
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DebitOrderPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Daily habit costs",
                                "images/24-hours-service.png",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DailyHabitPage(),
                                    ),
                                  );
                                },
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
                                "Medical Aid",
                                "images/healthcare.png",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MedAidPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Center(
                              child: uiTools.imgBtnTitleContainer(
                                "Monthly Services",
                                "images/attendant.png",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ServicePage(),
                                    ),
                                  );
                                },
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
