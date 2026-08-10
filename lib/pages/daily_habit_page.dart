import 'package:flutter/material.dart';
import 'package:first_flutter_app/models/DailyHabit.dart';
import 'package:first_flutter_app/models/UserSettings.dart';
import 'package:first_flutter_app/custom_tools/logicTools.dart';
import 'package:first_flutter_app/custom_tools/uiTools.dart';

class DailyHabitPage extends StatefulWidget {
  const DailyHabitPage({super.key});

  @override
  State<DailyHabitPage> createState() => _DailyHabitPage();
}

class _DailyHabitPage extends State<DailyHabitPage> {
  List<DailyHabit> dHabits = [
    DailyHabit(name: "Coffee", costDHabit: 40),
    DailyHabit(name: "Energy Drink", costDHabit: 25),
  ];

  final uiTools = Uitools();

  final List<UserSettings> userSettings = [UserSettings(userIncome: 25000)];

  final TextEditingController dailyHabitNameController =
      TextEditingController();
  final TextEditingController dailyHabitController = TextEditingController();

  int daysInMonth = 30;

  @override
  void dispose() {
    dailyHabitNameController.dispose();
    dailyHabitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Automatically recalculates every time setState() is called
    double calculatedDailyTotal = 0;
    for (int i = 0; i < dHabits.length; i++) {
      calculatedDailyTotal +=
          dHabits[i].costDHabit; // Assumes property name is costDHabit
    }
    double monthlyHabitTotal = calculatedDailyTotal * daysInMonth;

    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            "Monthly Expense Tracker: ",
            style: TextStyle(color: Colors.blueGrey[50]),
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
                        "Daily total: R ${calculatedDailyTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Monthly projection: R ${monthlyHabitTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        children: [
                          TextField(
                            controller: dailyHabitNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Daily Cost Name",
                              hintText: "Enter the name for the item/activity",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: dailyHabitController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Daily Expense",
                              hintText: "Enter the expense amount",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                if (dailyHabitNameController.text.isEmpty ||
                                    dailyHabitController.text.isEmpty)
                                  return;

                                String habitName =
                                    dailyHabitNameController.text;
                                double habitCost =
                                    double.tryParse(
                                      dailyHabitController.text,
                                    ) ??
                                    0.0;

                                DailyHabit hab1 = DailyHabit(
                                  name: habitName,
                                  costDHabit: habitCost,
                                );

                                setState(() {
                                  dHabits.add(hab1);
                                });

                                dailyHabitNameController.clear();
                                dailyHabitController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text("Add Daily Habit"),
                            ),
                          ),
                        ],
                      ),

                      // CONDITIONAL RENDERING: Only inject layout blocks if items exist
                      if (dHabits.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              Colors.teal[700],
                            ),
                            dataRowColor: WidgetStateProperty.all(Colors.cyan),
                            columns: const [
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("Cost")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: dHabits.asMap().entries.map((entry) {
                              int index = entry.key;
                              var hab = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(hab.getName),
                                  ), // Assumes getName getter exists
                                  DataCell(
                                    Text(
                                      "R ${hab.costDHabit.toStringAsFixed(2)}",
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Row(
                                        children: [
                                          uiTools.itemRemoveBtn(() {
                                            setState(() {
                                              dHabits = const LogicTools()
                                                  .dHabitItemRemover(
                                                    dHabits,
                                                    index,
                                                  );
                                            });
                                          }),

                                          SizedBox(width: 4),

                                          uiTools.itemEditBtn(() {
                                            // Add here
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
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
