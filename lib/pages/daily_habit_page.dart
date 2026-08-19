import 'package:flutter/material.dart';

import 'package:freeuse_monthly_expense_tracker/models/DailyHabit.dart';

import 'package:freeuse_monthly_expense_tracker/custom_tools/logicTools.dart';

import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';

import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';

class DailyHabitPage extends StatefulWidget {
  const DailyHabitPage({super.key});

  @override
  State<DailyHabitPage> createState() => _DailyHabitPage();
}

class _DailyHabitPage extends State<DailyHabitPage> {
  List<DailyHabit> dHabits = [];

  int editingIndex = -1;

  final uiTools = Uitools();

  bool isLoading = true;

  bool showInfo = false;

  Future<void> _loadDatabaseData() async {
    try {
      final db = DatabaseHelper.instance;

      final loadedDHabits = await db.getDailyHabits();

      if (!mounted) return;

      setState(() {
        dHabits = loadedDHabits;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

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
  void initState() {
    super.initState();

    _loadDatabaseData();
  }

  @override
  Widget build(BuildContext context) {
    double calculatedDailyTotal = 0;

    for (int i = 0; i < dHabits.length; i++) {
      calculatedDailyTotal += dHabits[i].costDHabit;
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
                      // --------------------------------------------------
                      // TITLE + TOTALS + INFO BUTTON
                      // --------------------------------------------------
                      Row(
                        children: [
                          Column(
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
                            ],
                          ),

                          const Spacer(),

                          // INFO BUTTON
                          uiTools.infoButton(
                            showInfo: showInfo,

                            onPressed: () {
                              setState(() {
                                showInfo = !showInfo;
                              });
                            },
                          ),
                        ],
                      ),

                      uiTools.infoContainer(
                        showInfo: showInfo,

                        infoText:
                            "Daily habits are recurring expenses that occur "
                            "on a daily basis. Examples include coffee, "
                            "snacks, transport costs, cigarettes, or other "
                            "small daily purchases. The monthly projection "
                            "is calculated by multiplying the daily total "
                            "by the number of days in the month.",
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
                                    dailyHabitController.text.isEmpty) {
                                  return;
                                }

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
                                  if (editingIndex != -1) {
                                    dHabits.insert(editingIndex, hab1);

                                    editingIndex = -1;
                                  } else {
                                    dHabits.add(hab1);
                                  }

                                  dailyHabitNameController.clear();

                                  dailyHabitController.clear();
                                });
                              },

                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],

                                padding: const EdgeInsets.all(12),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),

                              child: Text(
                                editingIndex != -1
                                    ? "Update Daily Habit"
                                    : "Add Daily Habit",
                              ),
                            ),
                          ),
                        ],
                      ),

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
                              DataColumn(label: Text("Name:")),

                              DataColumn(label: Text("Cost:")),

                              DataColumn(label: Text("Actions:")),
                            ],

                            rows: dHabits.asMap().entries.map((entry) {
                              int index = entry.key;

                              var hab = entry.value;

                              return DataRow(
                                cells: [
                                  DataCell(Text(hab.getName)),

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

                                              if (editingIndex == index) {
                                                editingIndex = -1;

                                                dailyHabitNameController
                                                    .clear();

                                                dailyHabitController.clear();
                                              }
                                            });
                                          }),

                                          const SizedBox(width: 4),

                                          uiTools.itemEditBtn(() {
                                            setState(() {
                                              dailyHabitNameController.text =
                                                  hab.getName;

                                              dailyHabitController.text = hab
                                                  .getCost
                                                  .toString();

                                              editingIndex = index;

                                              dHabits.removeAt(index);
                                            });
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

                const SizedBox(height: 20),

                if (editingIndex == -1)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),

                      child: SizedBox(
                        width: double.infinity,

                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[200],
                          ),

                          onPressed: () async {
                            await DatabaseHelper.instance.replaceDailyHabits(
                              dHabits,
                            );

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Daily habits updated!"),
                              ),
                            );

                            Navigator.pop(context);
                          },

                          child: const Text("Update"),
                        ),
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
