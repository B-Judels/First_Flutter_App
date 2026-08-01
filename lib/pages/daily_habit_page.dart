import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/DailyHabit.dart';
import 'package:first_flutter_app/models/UserSettings.dart';

class DailyHabitPage extends StatefulWidget {
  const DailyHabitPage({super.key});

  @override
  State<DailyHabitPage> createState() => _DailyHabitPage();
}

class _DailyHabitPage extends State<DailyHabitPage> {
  final dHabits = [
    DailyHabit(name: "Coffee", costDHabit: 40),
    DailyHabit(name: "Energy Drink", costDHabit: 25),
  ];

  final List<UserSettings> userSettings = [UserSettings(userIncome: 25000)];

  final TextEditingController dailyHabitNameController =
      TextEditingController();
  final TextEditingController dailyHabitController = TextEditingController();

  int daysInMonth = 30;
  double dailyTotal = 0;

  @override
  void dispose() {
    dailyHabitNameController.dispose();
    dailyHabitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double habitTotal = 0;
    double currentDailyTotal = 0;

    for (int i = 0; i < dHabits.length; i++) {
      habitTotal += dHabits[i].getCost * daysInMonth;
      currentDailyTotal += dHabits[i].getCost;
    }

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Daily Habit Costs",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Current daily total: R ${dailyTotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10.0),

                      Text(
                        "Updated daily total: R ${dailyTotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Column(
                        children: [
                          TextField(
                            controller: dailyHabitNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Daily Cost Name",
                              hintText:
                                  "Enter the name for the item/activity you get/do daily",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          TextField(
                            controller: dailyHabitController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Daily Expence",
                              hintText:
                                  "Enter the expence for the item/action that you get/do daily",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                String habitName =
                                    dailyHabitNameController.text;
                                double habitCost = double.parse(
                                  dailyHabitController.text,
                                );

                                DailyHabit hab1 = new DailyHabit(
                                  name: habitName,
                                  costDHabit: habitCost,
                                );

                                setState(() {
                                  dHabits.add(hab1);
                                  dailyTotal = dailyTotal + habitCost;
                                });

                                dailyHabitNameController.clear();
                                dailyHabitController.clear();
                              },

                              child: Text("Add Daily Habit"),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Center(
                        child: Container(
                          width: double.infinity,
                          child: Expanded(
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                Colors.teal[700],
                              ),
                              dataRowColor: WidgetStateProperty.all(
                                Colors.cyan,
                              ),
                              columns: const [
                                DataColumn(label: Text("Daily Habit Name")),
                                DataColumn(label: Text("Daily Habit Cost")),
                              ],
                              rows: dHabits.map((hab) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(hab.getName)),
                                    DataCell(
                                      Text(
                                        "R ${hab.costDHabit.toStringAsFixed(2)}",
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
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
      ),
    );
  }
}
