import 'package:freeuse_monthly_expense_tracker/models/DebitOrder.dart';
import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/pages/home.dart';
import 'package:freeuse_monthly_expense_tracker/models/Service.dart';
import 'package:freeuse_monthly_expense_tracker/models/DailyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/WeeklyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/BiWeeklyHabit.dart';
import 'package:freeuse_monthly_expense_tracker/models/MedicalAid.dart';
import 'package:freeuse_monthly_expense_tracker/models/UserSettings.dart';
import 'package:freeuse_monthly_expense_tracker/database/database_helper.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/logicTools.dart';
import 'package:freeuse_monthly_expense_tracker/custom_tools/uiTools.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  double userIncome = 0;

  final uiTools = Uitools();

  bool showInfo = false;
  bool showInfo2 = false;
  bool showInfo3 = false;
  bool showInfo4 = false;

  List<Service> services = [];

  List<DebitOrder> debitOrders = [];

  List<MedicalAid> medAids = [];

  List<DailyHabit> dHabits = [];
  List<WeeklyHabit> wHabits = [];
  List<BiWeeklyHabit> bwHabits = [];

  int habitMode = 1;
  int habitEditingIndex = -1;
  int editingIndex = -1;

  String selectedCurrency = "R";

  final TextEditingController incomeController = TextEditingController();

  final TextEditingController medicalAidController = TextEditingController();
  final TextEditingController medicalAidCostController =
      TextEditingController();

  final TextEditingController dailyHabitNameController =
      TextEditingController();
  final TextEditingController dailyHabitController = TextEditingController();

  final TextEditingController debitNameController = TextEditingController();
  final TextEditingController debitCostController = TextEditingController();

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();

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
      return calculatedHabitTotal * 30;
    } else if (habitMode == 2) {
      return calculatedHabitTotal * 4;
    } else {
      return calculatedHabitTotal * 2;
    }
  }

  String get habitNameLabel {
    if (habitMode == 1) return "Daily Cost Name";
    if (habitMode == 2) return "Weekly Cost Name";
    return "Bi-Weekly Cost Name";
  }

  String get habitExpenseLabel {
    if (habitMode == 1) return "Daily Expense";
    if (habitMode == 2) return "Weekly Expense";
    return "Bi-Weekly Expense";
  }

  String get habitButtonText {
    if (habitEditingIndex != -1) {
      if (habitMode == 1) return "Update Daily Habit";
      if (habitMode == 2) return "Update Weekly Habit";
      return "Update Bi-Weekly Habit";
    }

    if (habitMode == 1) return "Add Daily Habit";
    if (habitMode == 2) return "Add Weekly Habit";
    return "Add Bi-Weekly Habit";
  }

  void _changeHabitMode(int mode) {
    setState(() {
      habitMode = mode;
      habitEditingIndex = -1;
      dailyHabitNameController.clear();
      dailyHabitController.clear();
    });
  }

  void _addHabit() {
    if (dailyHabitNameController.text.isEmpty ||
        dailyHabitController.text.isEmpty) {
      return;
    }

    final String habitName = dailyHabitNameController.text;
    final double habitCost = double.tryParse(dailyHabitController.text) ?? 0.0;

    setState(() {
      if (habitMode == 1) {
        final habit = DailyHabit(name: habitName, costDHabit: habitCost);

        if (habitEditingIndex != -1) {
          dHabits.insert(habitEditingIndex, habit);
          habitEditingIndex = -1;
        } else {
          dHabits.add(habit);
        }
      } else if (habitMode == 2) {
        final habit = WeeklyHabit(name: habitName, costWHabit: habitCost);

        if (habitEditingIndex != -1) {
          wHabits.insert(habitEditingIndex, habit);
          habitEditingIndex = -1;
        } else {
          wHabits.add(habit);
        }
      } else {
        final habit = BiWeeklyHabit(name: habitName, costBWHabit: habitCost);

        if (habitEditingIndex != -1) {
          bwHabits.insert(habitEditingIndex, habit);
          habitEditingIndex = -1;
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

      if (habitEditingIndex == index) {
        habitEditingIndex = -1;
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
        habitEditingIndex = index;
        dHabits.removeAt(index);
      } else if (habitMode == 2) {
        final habit = wHabits[index];
        dailyHabitNameController.text = habit.getName;
        dailyHabitController.text = habit.getCost.toString();
        habitEditingIndex = index;
        wHabits.removeAt(index);
      } else {
        final habit = bwHabits[index];
        dailyHabitNameController.text = habit.getName;
        dailyHabitController.text = habit.getCost.toString();
        habitEditingIndex = index;
        bwHabits.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: uiTools.pageBackgroundColor1(),
      appBar: AppBar(
        title: Center(
          child: Text(
            style: uiTools.appBarTitleStyle(),
            "Monthly Budget Planner",
          ),
        ),
        backgroundColor: uiTools.appBarColor1(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Text(
                    "Insert some values to calculate and track:",
                    style: uiTools.pageIntroStyle(),
                  ),

                  Container(
                    margin: const EdgeInsets.all(10.0),
                    width: double.maxFinite,

                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: uiTools.cardColor1(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 52,
                              child: DropdownButtonFormField<String>(
                                value: selectedCurrency,
                                decoration: InputDecoration(
                                  labelText: "Currency Type:",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "R",
                                    child: Text("R"),
                                  ),
                                  DropdownMenuItem(
                                    value: "\$",
                                    child: Text("\$"),
                                  ),
                                  DropdownMenuItem(
                                    value: "€",
                                    child: Text("€"),
                                  ),
                                  DropdownMenuItem(
                                    value: "£",
                                    child: Text("£"),
                                  ),
                                  DropdownMenuItem(
                                    value: "¥",
                                    child: Text("¥"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedCurrency = value!;
                                  });
                                },
                              ),
                            ),

                            SizedBox(width: 3),

                            Expanded(
                              child: TextField(
                                controller: incomeController,
                                keyboardType: TextInputType.number,
                                decoration: uiTools.inputDecoration(
                                  labelText: "Monthly Income",
                                  hintText: "Enter your monthly income",
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),

                  Column(
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Debit Orders:",
                                      style: uiTools.sectionTitleStyle(),
                                    ),
                                  ],
                                ),

                                const Spacer(),

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
                                  "Debit orders are recurring payments that are "
                                  "automatically deducted from your bank account. "
                                  "Examples include Streaming Services, Loan Repayments, "
                                  "Subscriptions, and other regular payments.",
                            ),

                            const SizedBox(height: 10.0),

                            Column(
                              children: [
                                TextField(
                                  controller: debitNameController,
                                  keyboardType: TextInputType.text,

                                  decoration: uiTools.inputDecoration(
                                    labelText: "Debit Order Name",
                                    hintText:
                                        "Enter the name for the debit order",
                                  ),
                                ),

                                const SizedBox(height: 10.0),

                                TextField(
                                  controller: debitCostController,
                                  keyboardType: TextInputType.number,

                                  decoration: uiTools.inputDecoration(
                                    labelText: "Monthly Expense",
                                    hintText:
                                        "Enter the expense for the service per month",
                                  ),
                                ),

                                const SizedBox(height: 10.0),

                                SizedBox(
                                  width: double.infinity,

                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (debitNameController.text.isEmpty ||
                                          debitCostController.text.isEmpty) {
                                        return;
                                      }

                                      String debitName =
                                          debitNameController.text;

                                      double debitCost =
                                          double.tryParse(
                                            debitCostController.text,
                                          ) ??
                                          0;

                                      DebitOrder order = DebitOrder(
                                        name: debitName,
                                        cost: debitCost,
                                      );

                                      setState(() {
                                        if (editingIndex == -1) {
                                          debitOrders.add(order);
                                        } else {
                                          debitOrders.insert(
                                            editingIndex,
                                            order,
                                          );

                                          editingIndex = -1;
                                        }
                                      });

                                      debitNameController.clear();
                                      debitCostController.clear();
                                    },

                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: uiTools
                                          .pageBackgroundColor1(),
                                      padding: const EdgeInsets.all(12),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),

                                    child: Text(
                                      editingIndex == -1
                                          ? "Add Debit Order"
                                          : "Update Debit Order",
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (debitOrders.isNotEmpty) ...[
                              const SizedBox(height: 15),

                              Center(
                                child: SizedBox(
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
                                            style: uiTools.tableHeaderStyle(),
                                            "Name:",
                                          ),
                                          headingRowAlignment:
                                              MainAxisAlignment.start,
                                        ),

                                        DataColumn(
                                          label: Text(
                                            style: uiTools.tableHeaderStyle(),
                                            "Cost:",
                                          ),
                                          headingRowAlignment:
                                              MainAxisAlignment.start,
                                        ),

                                        DataColumn(
                                          columnWidth: FixedColumnWidth(125),
                                          label: Text(
                                            style: uiTools.tableHeaderStyle(),
                                            "Actions:",
                                          ),
                                          headingRowAlignment:
                                              MainAxisAlignment.start,
                                        ),
                                      ],

                                      rows: debitOrders.asMap().entries.map((
                                        entry,
                                      ) {
                                        int index = entry.key;
                                        var orderer = entry.value;

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                style: uiTools.tableTextStyle(),
                                                orderer.getName,
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                style: uiTools.tableTextStyle(),
                                                "$selectedCurrency ${orderer.getCost.toStringAsFixed(2)}",
                                              ),
                                            ),

                                            DataCell(
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  uiTools.itemRemoveBtn(() {
                                                    setState(() {
                                                      debitOrders =
                                                          const LogicTools()
                                                              .debitOrderItemRemover(
                                                                debitOrders,
                                                                index,
                                                              );

                                                      if (editingIndex ==
                                                          index) {
                                                        editingIndex = -1;

                                                        debitNameController
                                                            .clear();
                                                        debitCostController
                                                            .clear();
                                                      }
                                                    });
                                                  }),

                                                  const SizedBox(width: 4),

                                                  uiTools.itemEditBtn(() {
                                                    setState(() {
                                                      debitNameController.text =
                                                          orderer.getName;

                                                      debitCostController.text =
                                                          orderer.getCost
                                                              .toString();

                                                      editingIndex = index;

                                                      debitOrders.removeAt(
                                                        index,
                                                      );
                                                    });
                                                  }),
                                                ],
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
                          ],
                        ),
                      ),

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
                                Column(
                                  children: [
                                    Text(
                                      "Insurance:",
                                      style: uiTools.sectionTitleStyle(),
                                    ),
                                  ],
                                ),
                                Spacer(),

                                uiTools.infoButton(
                                  showInfo: showInfo2,
                                  onPressed: () {
                                    setState(() {
                                      showInfo2 = !showInfo2;
                                    });
                                  },
                                ),
                              ],
                            ),

                            uiTools.infoContainer(
                              showInfo: showInfo2,
                              infoText:
                                  "Any Insurance, for example\n"
                                  "Health Insurance/Medical Aid, Car Insurance,\n "
                                  "Home Insurance, etc.",
                            ),

                            const SizedBox(height: 10.0),

                            Column(
                              children: [
                                TextField(
                                  controller: medicalAidController,
                                  keyboardType: TextInputType.text,
                                  decoration: uiTools.inputDecoration(
                                    labelText: "Name of Insurance",
                                    hintText:
                                        "Enter the name for the Insurance",
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                TextField(
                                  controller: medicalAidCostController,
                                  keyboardType: TextInputType.number,
                                  decoration: uiTools.inputDecoration(
                                    labelText: "Monthly Expense",
                                    hintText:
                                        "Enter the expense for the insurance per month",
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (medicalAidController.text.isEmpty ||
                                          medicalAidCostController
                                              .text
                                              .isEmpty) {
                                        return;
                                      }

                                      String medAidName =
                                          medicalAidController.text;

                                      double medAidCost =
                                          double.tryParse(
                                            medicalAidCostController.text,
                                          ) ??
                                          0;

                                      MedicalAid medAid = MedicalAid(
                                        name: medAidName,
                                        costMedAid: medAidCost,
                                      );

                                      setState(() {
                                        medAids.add(medAid);

                                        editingIndex = -1;

                                        medicalAidController.clear();
                                        medicalAidCostController.clear();
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: uiTools
                                          .pageBackgroundColor1(),
                                      padding: const EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      editingIndex == -1
                                          ? "Add Insurance"
                                          : "Update Insurance",
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (medAids.isNotEmpty) ...[
                              const SizedBox(height: 15),
                              Center(
                                child: SizedBox(
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
                                            style: uiTools.tableHeaderStyle(),
                                            "Name:",
                                          ),
                                          headingRowAlignment:
                                              MainAxisAlignment.start,
                                        ),

                                        DataColumn(
                                          label: Text(
                                            style: uiTools.tableHeaderStyle(),
                                            "Cost:",
                                          ),
                                          headingRowAlignment:
                                              MainAxisAlignment.start,
                                        ),

                                        DataColumn(
                                          columnWidth: FixedColumnWidth(125),
                                          label: Text(
                                            style: uiTools.tableHeaderStyle(),
                                            "Actions:",
                                          ),
                                          headingRowAlignment:
                                              MainAxisAlignment.start,
                                        ),
                                      ],
                                      rows: medAids.asMap().entries.map((
                                        entry,
                                      ) {
                                        int index = entry.key;
                                        var servicer = entry.value;
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                style: uiTools.tableTextStyle(),
                                                servicer.getName,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                style: uiTools.tableTextStyle(),
                                                "$selectedCurrency ${servicer.getMedAidCost.toStringAsFixed(2)}",
                                              ),
                                            ),
                                            DataCell(
                                              Center(
                                                child: Row(
                                                  children: [
                                                    uiTools.itemRemoveBtn(() {
                                                      setState(() {
                                                        medAids =
                                                            const LogicTools()
                                                                .medAidItemRemover(
                                                                  medAids,
                                                                  index,
                                                                );

                                                        if (editingIndex ==
                                                            index) {
                                                          editingIndex = -1;
                                                          medicalAidController
                                                              .clear();
                                                          medicalAidCostController
                                                              .clear();
                                                        }
                                                      });
                                                    }),

                                                    SizedBox(width: 4),

                                                    uiTools.itemEditBtn(() {
                                                      setState(() {
                                                        medicalAidController
                                                                .text =
                                                            servicer.getName;
                                                        medicalAidCostController
                                                            .text = servicer
                                                            .getMedAidCost
                                                            .toString();
                                                        editingIndex = index;

                                                        medAids.removeAt(index);
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
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

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
                            Column(
                              children: [
                                Text(
                                  "Monthly Services:",
                                  style: uiTools.sectionTitleStyle(),
                                ),
                              ],
                            ),
                            Spacer(),

                            uiTools.infoButton(
                              showInfo: showInfo3,
                              onPressed: () {
                                setState(() {
                                  showInfo3 = !showInfo3;
                                });
                              },
                            ),
                          ],
                        ),

                        uiTools.infoContainer(
                          showInfo: showInfo3,
                          infoText:
                              "Services are recurring monthly expenses such as "
                              "Electricity Bill, Internet Bill, Cellphone Contracts, "
                              "Water Bill, Monthly Class Fees, etc.",
                        ),

                        const SizedBox(height: 10.0),

                        Column(
                          children: [
                            TextField(
                              controller: serviceNameController,
                              keyboardType: TextInputType.text,
                              decoration: uiTools.inputDecoration(
                                labelText: "Service Name",
                                hintText: "Enter the name of the service",
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              controller: serviceCostController,
                              keyboardType: TextInputType.number,
                              decoration: uiTools.inputDecoration(
                                labelText: "Monthly Expense",
                                hintText:
                                    "Enter the expense for the service per month",
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  if (serviceNameController.text.isEmpty ||
                                      serviceCostController.text.isEmpty) {
                                    return;
                                  }

                                  String serviceName =
                                      serviceNameController.text;

                                  double serviceCost =
                                      double.tryParse(
                                        serviceCostController.text,
                                      ) ??
                                      0;

                                  Service serve = Service(
                                    serviceName: serviceName,
                                    serviceCost: serviceCost,
                                  );

                                  setState(() {
                                    if (editingIndex != -1) {
                                      services.insert(editingIndex, serve);

                                      editingIndex = -1;
                                    } else {
                                      services.add(serve);
                                    }
                                  });

                                  serviceNameController.clear();
                                  serviceCostController.clear();
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: uiTools
                                      .pageBackgroundColor1(),
                                  padding: const EdgeInsets.all(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  editingIndex != -1
                                      ? "Update Service"
                                      : "Add Service",
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (services.isNotEmpty) ...[
                          const SizedBox(height: 15),
                          Center(
                            child: SizedBox(
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
                                        style: uiTools.tableHeaderStyle(),
                                        "Name:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),

                                    DataColumn(
                                      label: Text(
                                        style: uiTools.tableHeaderStyle(),
                                        "Cost:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),

                                    DataColumn(
                                      columnWidth: FixedColumnWidth(125),
                                      label: Text(
                                        style: uiTools.tableHeaderStyle(),
                                        "Actions:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),
                                  ],
                                  rows: services.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var servicer = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            style: uiTools.tableTextStyle(),
                                            servicer.getName,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            style: uiTools.tableTextStyle(),
                                            "$selectedCurrency ${servicer.getCost.toStringAsFixed(2)}",
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Row(
                                              children: [
                                                uiTools.itemRemoveBtn(() {
                                                  setState(() {
                                                    services =
                                                        const LogicTools()
                                                            .serviceItemRemover(
                                                              services,
                                                              index,
                                                            );

                                                    if (editingIndex == index) {
                                                      editingIndex = -1;
                                                      serviceNameController
                                                          .clear();
                                                      serviceCostController
                                                          .clear();
                                                    }
                                                  });
                                                }),

                                                SizedBox(width: 4),

                                                uiTools.itemEditBtn(() {
                                                  setState(() {
                                                    serviceNameController.text =
                                                        servicer.getName;
                                                    serviceCostController.text =
                                                        servicer.getCost
                                                            .toString();
                                                    editingIndex = index;

                                                    services.removeAt(index);
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
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

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
                        Text("Habits:", style: uiTools.sectionTitleStyle()),

                        SizedBox(height: 5),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _changeHabitMode(1),
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
                            const SizedBox(width: 3),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _changeHabitMode(2),
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
                            const SizedBox(width: 3),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _changeHabitMode(3),
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
                        const SizedBox(height: 5),
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
                                        habitMode == 1
                                            ? "Daily Habit Costs"
                                            : habitMode == 2
                                            ? "Weekly Habit Costs"
                                            : "Bi-Weekly Habit Costs",
                                        style: uiTools.sectionTitleStyle(),
                                      ),
                                      const Spacer(),
                                      uiTools.infoButton(
                                        showInfo: showInfo4,
                                        onPressed: () {
                                          setState(() {
                                            showInfo4 = !showInfo4;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    habitMode == 1
                                        ? "Daily total: $selectedCurrency ${calculatedHabitTotal.toStringAsFixed(2)}"
                                        : habitMode == 2
                                        ? "Weekly total: $selectedCurrency ${calculatedHabitTotal.toStringAsFixed(2)}"
                                        : "Bi-Weekly total: $selectedCurrency ${calculatedHabitTotal.toStringAsFixed(2)}",
                                    style: uiTools.summaryTextStyle(),
                                  ),
                                  Text(
                                    "Monthly projection: $selectedCurrency ${monthlyHabitTotal.toStringAsFixed(2)}",
                                    style: uiTools.summaryTextStyle(),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        uiTools.infoContainer(
                          showInfo: showInfo4,
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
                                hintText:
                                    "Enter the name for the item/activity",
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
                                  backgroundColor: uiTools
                                      .pageBackgroundColor1(),
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
                                    headingRowAlignment:
                                        MainAxisAlignment.start,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Cost:",
                                      style: uiTools.tableHeaderStyle(),
                                    ),
                                    headingRowAlignment:
                                        MainAxisAlignment.start,
                                  ),
                                  DataColumn(
                                    columnWidth: const FixedColumnWidth(125),
                                    label: Text(
                                      "Actions:",
                                      style: uiTools.tableHeaderStyle(),
                                    ),
                                    headingRowAlignment:
                                        MainAxisAlignment.start,
                                  ),
                                ],
                                rows: habitMode == 1
                                    ? dHabits.asMap().entries.map((entry) {
                                        final int index = entry.key;
                                        final DailyHabit habit = entry.value;
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                habit.getName,
                                                style: uiTools.tableTextStyle(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "$selectedCurrency ${habit.costDHabit.toStringAsFixed(2)}",
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
                                        final int index = entry.key;
                                        final WeeklyHabit habit = entry.value;
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                habit.getName,
                                                style: uiTools.tableTextStyle(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "$selectedCurrency ${habit.costWHabit.toStringAsFixed(2)}",
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
                                        final int index = entry.key;
                                        final BiWeeklyHabit habit = entry.value;
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                habit.getName,
                                                style: uiTools.tableTextStyle(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "$selectedCurrency ${habit.costBWHabit.toStringAsFixed(2)}",
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

                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: uiTools.appBarColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          if (incomeController.text.trim().isEmpty) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter an income to track.",
                                ),
                              ),
                            );

                            return;
                          }

                          double? income = double.tryParse(
                            incomeController.text.trim(),
                          );

                          if (income == null || income <= 0) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter a valid income amount.",
                                ),
                              ),
                            );

                            return;
                          }

                          try {
                            for (DebitOrder order in debitOrders) {
                              await DatabaseHelper.instance.insertDebitOrder(
                                order,
                              );
                            }

                            double income =
                                double.tryParse(incomeController.text) ?? 0;

                            UserSettings settings = UserSettings(
                              userIncome: income,
                              currency: selectedCurrency,
                            );

                            await DatabaseHelper.instance.insertUserSettings(
                              settings,
                            );

                            for (MedicalAid medAid in medAids) {
                              await DatabaseHelper.instance.insertMedicalAid(
                                medAid,
                              );
                            }

                            for (Service service in services) {
                              await DatabaseHelper.instance.insertService(
                                service,
                              );
                            }

                            await DatabaseHelper.instance.replaceDailyHabits(
                              dHabits,
                            );

                            await DatabaseHelper.instance.replaceWeeklyHabits(
                              wHabits,
                            );

                            await DatabaseHelper.instance.replaceBiWeeklyHabits(
                              bwHabits,
                            );

                            if (!mounted) return;

                            Navigator.pushReplacement(
                              context,
                              uiTools.smoothPageRoute(const Home()),
                            );
                          } catch (e, stackTrace) {
                            debugPrint("DATABASE ERROR: $e");
                            debugPrint("STACK TRACE: $stackTrace");

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Database error: $e")),
                            );
                          }
                        },
                        child: const Text(
                          "Save and Calculate",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
