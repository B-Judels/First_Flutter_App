import 'package:flutter/material.dart';

import 'package:freeuse_monthly_expense_tracker/models/DailyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/WeeklyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/BiWeeklyHabit.dart';

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
  List<WeeklyHabit> wHabits = [];
  List<BiWeeklyHabit> bwHabits = [];

  int editingIndex = -1;

  final uiTools = Uitools();

  bool isLoading = true;

  bool showInfo = false;

  // 1 = Daily
  // 2 = Weekly
  // 3 = Bi-Weekly
  int habitMode = 1;

  int daysInMonth = 30;

  final TextEditingController dailyHabitNameController =
      TextEditingController();

  final TextEditingController dailyHabitController = TextEditingController();

  Future<void> _loadDatabaseData() async {
    try {
      final db = DatabaseHelper.instance;

      final loadedDHabits = await db.getDailyHabits();

      final loadedWHabits = await db.getWeeklyHabits();

      final loadedBWHabits = await db.getBiWeeklyHabits();

      if (!mounted) return;

      setState(() {
        dHabits = loadedDHabits;

        wHabits = loadedWHabits;

        bwHabits = loadedBWHabits;

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Database error: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

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

  String get habitNameLabel {
    if (habitMode == 1) {
      return "Daily Cost Name";
    }

    if (habitMode == 2) {
      return "Weekly Cost Name";
    }

    return "Bi-Weekly Cost Name";
  }

  String get habitExpenseLabel {
    if (habitMode == 1) {
      return "Daily Expense";
    }

    if (habitMode == 2) {
      return "Weekly Expense";
    }

    return "Bi-Weekly Expense";
  }

  String get habitNameHint {
    if (habitMode == 1) {
      return "Enter the name for the item/activity";
    }

    if (habitMode == 2) {
      return "Enter the name for the item/activity";
    }

    return "Enter the name for the item/activity";
  }

  String get habitButtonText {
    if (editingIndex != -1) {
      if (habitMode == 1) {
        return "Update Daily Habit";
      }

      if (habitMode == 2) {
        return "Update Weekly Habit";
      }

      return "Update Bi-Weekly Habit";
    }

    if (habitMode == 1) {
      return "Add Daily Habit";
    }

    if (habitMode == 2) {
      return "Add Weekly Habit";
    }

    return "Add Bi-Weekly Habit";
  }

  String get habitTitle {
    if (habitMode == 1) {
      return "Daily Habit Costs";
    }

    if (habitMode == 2) {
      return "Weekly Habit Costs";
    }

    return "Bi-Weekly Habit Costs";
  }

  double get calculatedHabitTotal {
    double total = 0;

    if (habitMode == 1) {
      for (DailyHabit habit in dHabits) {
        total += habit.costDHabit;
      }
    } else if (habitMode == 2) {
      for (WeeklyHabit habit in wHabits) {
        total += habit.costWHabit;
      }
    } else {
      for (BiWeeklyHabit habit in bwHabits) {
        total += habit.costBWHabit;
      }
    }

    return total;
  }

  double get monthlyHabitTotal {
    if (habitMode == 1) {
      return calculatedHabitTotal * daysInMonth;
    } else if (habitMode == 2) {
      return calculatedHabitTotal * 4;
    } else {
      return calculatedHabitTotal * 2;
    }
  }

  void _changeHabitMode(int mode) {
    setState(() {
      habitMode = mode;

      editingIndex = -1;

      dailyHabitNameController.clear();

      dailyHabitController.clear();
    });
  }

  void _addHabit() {
    if (dailyHabitNameController.text.isEmpty ||
        dailyHabitController.text.isEmpty) {
      return;
    }

    String habitName = dailyHabitNameController.text;

    double habitCost = double.tryParse(dailyHabitController.text) ?? 0.0;

    setState(() {
      if (habitMode == 1) {
        DailyHabit habit = DailyHabit(name: habitName, costDHabit: habitCost);

        if (editingIndex != -1) {
          dHabits.insert(editingIndex, habit);

          editingIndex = -1;
        } else {
          dHabits.add(habit);
        }
      } else if (habitMode == 2) {
        WeeklyHabit habit = WeeklyHabit(name: habitName, costWHabit: habitCost);

        if (editingIndex != -1) {
          wHabits.insert(editingIndex, habit);

          editingIndex = -1;
        } else {
          wHabits.add(habit);
        }
      } else {
        BiWeeklyHabit habit = BiWeeklyHabit(
          name: habitName,
          costBWHabit: habitCost,
        );

        if (editingIndex != -1) {
          bwHabits.insert(editingIndex, habit);

          editingIndex = -1;
        } else {
          bwHabits.add(habit);
        }
      }

      dailyHabitNameController.clear();

      dailyHabitController.clear();
    });
  }

  void _deleteHabit(int index) {
    setState(() {
      if (habitMode == 1) {
        dHabits = const LogicTools().dHabitItemRemover(dHabits, index);
      } else if (habitMode == 2) {
        wHabits.removeAt(index);
      } else {
        bwHabits.removeAt(index);
      }

      if (editingIndex == index) {
        editingIndex = -1;

        dailyHabitNameController.clear();

        dailyHabitController.clear();
      }
    });
  }

  void _editHabit(int index) {
    setState(() {
      if (habitMode == 1) {
        final habit = dHabits[index];

        dailyHabitNameController.text = habit.getName;

        dailyHabitController.text = habit.getCost.toString();

        editingIndex = index;

        dHabits.removeAt(index);
      } else if (habitMode == 2) {
        final habit = wHabits[index];

        dailyHabitNameController.text = habit.getName;

        dailyHabitController.text = habit.getCost.toString();

        editingIndex = index;

        wHabits.removeAt(index);
      } else {
        final habit = bwHabits[index];

        dailyHabitNameController.text = habit.getName;

        dailyHabitController.text = habit.getCost.toString();

        editingIndex = index;

        bwHabits.removeAt(index);
      }
    });
  }

  Future<void> _updateDatabase() async {
    final db = DatabaseHelper.instance;

    if (habitMode == 1) {
      await db.replaceDailyHabits(dHabits);
    } else if (habitMode == 2) {
      await db.replaceWeeklyHabits(wHabits);
    } else {
      await db.replaceBiWeeklyHabits(bwHabits);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          habitMode == 1
              ? "Daily habits updated!"
              : habitMode == 2
              ? "Weekly habits updated!"
              : "Bi-Weekly habits updated!",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiTools.pageBackgroundColor1(),

      appBar: AppBar(
        title: Center(
          child: Text(
            "Monthly Budget Planner",

            style: TextStyle(color: uiTools.titleColor1()),
          ),
        ),

        backgroundColor: uiTools.appBarColor1(),
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
                    color: uiTools.sectionHeaderColor1(),

                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _changeHabitMode(1);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: uiTools.appBarColor(),

                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                "Daily",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),

                          SizedBox(width: 3),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _changeHabitMode(2);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: uiTools.appBarColor(),
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                "Weekly",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),

                          SizedBox(width: 3),

                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                _changeHabitMode(3);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: uiTools.appBarColor(),
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                "Bi-Weekly",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      habitTitle,
                                      style: uiTools.sectionTitleStyle(),
                                    ),

                                    Spacer(),

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

                                Text(
                                  habitMode == 1
                                      ? "Daily total: R ${calculatedHabitTotal.toStringAsFixed(2)}"
                                      : habitMode == 2
                                      ? "Weekly total: R ${calculatedHabitTotal.toStringAsFixed(2)}"
                                      : "Bi-Weekly total: R ${calculatedHabitTotal.toStringAsFixed(2)}",
                                  style: uiTools.summaryTextStyle(),
                                ),

                                Text(
                                  "Monthly projection: R ${monthlyHabitTotal.toStringAsFixed(2)}",
                                  style: uiTools.summaryTextStyle(),
                                ),

                                SizedBox(height: 5),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),
                        ],
                      ),

                      uiTools.infoContainer(
                        showInfo: showInfo,

                        infoText: habitMode == 1
                            ? "Daily habits are recurring expenses that occur "
                                  "on a daily basis. Examples include coffee, "
                                  "snacks, transport costs, cigarettes, or other "
                                  "small daily purchases. The monthly projection "
                                  "is calculated by multiplying the daily total "
                                  "by the number of days in the month."
                            : habitMode == 2
                            ? "Weekly habits are recurring expenses that "
                                  "occur on a weekly basis. The monthly "
                                  "projection is calculated by multiplying "
                                  "the weekly total by approximately four "
                                  "weeks in a month."
                            : "Bi-weekly habits are recurring expenses "
                                  "that occur every two weeks. The monthly "
                                  "projection is calculated by multiplying "
                                  "the bi-weekly total by two.",
                      ),

                      const SizedBox(height: 10.0),

                      Column(
                        children: [
                          TextField(
                            controller: dailyHabitNameController,

                            keyboardType: TextInputType.text,

                            decoration: uiTools.inputDecoration(
                              labelText: habitNameLabel,

                              hintText: habitNameHint,
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          TextField(
                            controller: dailyHabitController,

                            keyboardType: TextInputType.number,

                            decoration: uiTools.inputDecoration(
                              labelText: habitExpenseLabel,

                              hintText: "Enter the expense amount",
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          SizedBox(
                            width: double.infinity,

                            child: OutlinedButton(
                              onPressed: _addHabit,

                              style: OutlinedButton.styleFrom(
                                backgroundColor: uiTools.pageBackgroundColor1(),

                                padding: const EdgeInsets.all(12),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),

                              child: Text(habitButtonText),
                            ),
                          ),
                        ],
                      ),

                      if ((habitMode == 1 && dHabits.isNotEmpty) ||
                          (habitMode == 2 && wHabits.isNotEmpty) ||
                          (habitMode == 3 && bwHabits.isNotEmpty)) ...[
                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,

                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,

                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                uiTools.appBarColor1(),
                              ),

                              dataRowColor: WidgetStateProperty.all(
                                uiTools.tableRowColor1(),
                              ),

                              columns: [
                                DataColumn(
                                  label: Text(
                                    "Name:",

                                    style: uiTools.tableHeaderStyle(),
                                  ),

                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  label: Text(
                                    "Cost:",

                                    style: uiTools.tableHeaderStyle(),
                                  ),

                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  columnWidth: const FixedColumnWidth(125),

                                  label: Text(
                                    "Actions:",

                                    style: uiTools.tableHeaderStyle(),
                                  ),

                                  headingRowAlignment: MainAxisAlignment.start,
                                ),
                              ],

                              rows: habitMode == 1
                                  ? dHabits.asMap().entries.map((entry) {
                                      int index = entry.key;

                                      DailyHabit hab = entry.value;

                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              hab.getName,
                                              style: uiTools.tableTextStyle(),
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              "R ${hab.costDHabit.toStringAsFixed(2)}",
                                              style: uiTools.tableTextStyle(),
                                            ),
                                          ),

                                          DataCell(
                                            Center(
                                              child: Row(
                                                children: [
                                                  uiTools.itemRemoveBtn(() {
                                                    _deleteHabit(index);
                                                  }),

                                                  const SizedBox(width: 4),

                                                  uiTools.itemEditBtn(() {
                                                    _editHabit(index);
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList()
                                  : habitMode == 2
                                  ? wHabits.asMap().entries.map((entry) {
                                      int index = entry.key;

                                      WeeklyHabit hab = entry.value;

                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              hab.getName,
                                              style: uiTools.tableTextStyle(),
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              "R ${hab.costWHabit.toStringAsFixed(2)}",
                                              style: uiTools.tableTextStyle(),
                                            ),
                                          ),

                                          DataCell(
                                            Center(
                                              child: Row(
                                                children: [
                                                  uiTools.itemRemoveBtn(() {
                                                    _deleteHabit(index);
                                                  }),

                                                  const SizedBox(width: 4),

                                                  uiTools.itemEditBtn(() {
                                                    _editHabit(index);
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList()
                                  : bwHabits.asMap().entries.map((entry) {
                                      int index = entry.key;

                                      BiWeeklyHabit hab = entry.value;

                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              hab.getName,
                                              style: uiTools.tableTextStyle(),
                                            ),
                                          ),

                                          DataCell(
                                            Text(
                                              "R ${hab.costBWHabit.toStringAsFixed(2)}",
                                              style: uiTools.tableTextStyle(),
                                            ),
                                          ),

                                          DataCell(
                                            Center(
                                              child: Row(
                                                children: [
                                                  uiTools.itemRemoveBtn(() {
                                                    _deleteHabit(index);
                                                  }),

                                                  const SizedBox(width: 4),

                                                  uiTools.itemEditBtn(() {
                                                    _editHabit(index);
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
                            backgroundColor: uiTools.appBarColor(),
                          ),

                          onPressed: _updateDatabase,

                          child: const Text(
                            "Update",

                            style: TextStyle(color: Colors.white),
                          ),
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
