import 'package:freeuse_monthly_expense_tracker/models/DebitOrder.dart';
import 'package:flutter/material.dart';
import 'package:freeuse_monthly_expense_tracker/pages/home.dart';
import 'package:freeuse_monthly_expense_tracker/models/Service.dart';
import 'package:freeuse_monthly_expense_tracker/models/DailyHabit.dart';
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

  double dailyTotal = 0;

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

  int editingIndex = -1;

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                const Text(
                  "Insert some values to calculate and track:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: double.maxFinite,

                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.cyan[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      TextField(
                        controller: incomeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Monthly Income",
                          hintText: "Enter your monthly income",
                          border: OutlineInputBorder(),
                        ),
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
                        color: Colors.teal[300],
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
                                  const Text(
                                    "Monthly Debit Orders",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
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

                                decoration: const InputDecoration(
                                  labelText: "Debit Order Name",
                                  hintText:
                                      "Enter the name for the debit order",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 10.0),

                              TextField(
                                controller: debitCostController,
                                keyboardType: TextInputType.number,

                                decoration: const InputDecoration(
                                  labelText: "Monthly Expense",
                                  hintText:
                                      "Enter the expense for the service per month",
                                  border: OutlineInputBorder(),
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

                                    String debitName = debitNameController.text;

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
                                        debitOrders.insert(editingIndex, order);

                                        editingIndex = -1;
                                      }
                                    });

                                    debitNameController.clear();
                                    debitCostController.clear();
                                  },

                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.teal[100],
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

                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    Colors.teal[700],
                                  ),

                                  dataRowColor: WidgetStateProperty.all(
                                    Colors.cyan,
                                  ),

                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        style: TextStyle(fontSize: 12),
                                        "Name:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),

                                    DataColumn(
                                      label: Text(
                                        style: TextStyle(fontSize: 12),
                                        "Cost:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),

                                    DataColumn(
                                      columnWidth: FixedColumnWidth(125),
                                      label: Text(
                                        style: TextStyle(fontSize: 12),
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
                                            style: TextStyle(fontSize: 12),
                                            orderer.getName,
                                          ),
                                        ),

                                        DataCell(
                                          Text(
                                            style: TextStyle(fontSize: 12),
                                            "R ${orderer.getCost.toStringAsFixed(2)}",
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

                                                  if (editingIndex == index) {
                                                    editingIndex = -1;

                                                    debitNameController.clear();
                                                    debitCostController.clear();
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

                                                  debitOrders.removeAt(index);
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
                          ],
                        ],
                      ),
                    ),

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
                          Row(
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Insurance",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                decoration: const InputDecoration(
                                  labelText: "Name of Insurance",
                                  hintText: "Enter the name for the Insurance",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: medicalAidCostController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Monthly Expense",
                                  hintText:
                                      "Enter the expense for the insurance per month",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (medicalAidController.text.isEmpty ||
                                        medicalAidCostController.text.isEmpty) {
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
                                    backgroundColor: Colors.teal[100],
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
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                    Colors.teal[700],
                                  ),
                                  dataRowColor: WidgetStateProperty.all(
                                    Colors.cyan,
                                  ),

                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        style: TextStyle(fontSize: 12),
                                        "Name:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),

                                    DataColumn(
                                      label: Text(
                                        style: TextStyle(fontSize: 12),
                                        "Cost:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),

                                    DataColumn(
                                      columnWidth: FixedColumnWidth(125),
                                      label: Text(
                                        style: TextStyle(fontSize: 12),
                                        "Actions:",
                                      ),
                                      headingRowAlignment:
                                          MainAxisAlignment.start,
                                    ),
                                  ],
                                  rows: medAids.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var servicer = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            style: TextStyle(fontSize: 12),
                                            servicer.getName,
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            style: TextStyle(fontSize: 12),
                                            "R ${servicer.getMedAidCost.toStringAsFixed(2)}",
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Row(
                                              children: [
                                                uiTools.itemRemoveBtn(() {
                                                  setState(() {
                                                    medAids = const LogicTools()
                                                        .medAidItemRemover(
                                                          medAids,
                                                          index,
                                                        );

                                                    if (editingIndex == index) {
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
                                                    medicalAidController.text =
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
                    color: Colors.teal[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Monthly Services",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            decoration: const InputDecoration(
                              labelText: "Service Name",
                              hintText: "Enter the name of the service",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: serviceCostController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Monthly Expense",
                              hintText:
                                  "Enter the expense for the service per month",
                              border: OutlineInputBorder(),
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

                                String serviceName = serviceNameController.text;

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
                                backgroundColor: Colors.teal[100],
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
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(
                                Colors.teal[700],
                              ),
                              dataRowColor: WidgetStateProperty.all(
                                Colors.cyan,
                              ),
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    style: TextStyle(fontSize: 12),
                                    "Name:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  label: Text(
                                    style: TextStyle(fontSize: 12),
                                    "Cost:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),

                                DataColumn(
                                  columnWidth: FixedColumnWidth(125),
                                  label: Text(
                                    style: TextStyle(fontSize: 12),
                                    "Actions:",
                                  ),
                                  headingRowAlignment: MainAxisAlignment.start,
                                ),
                              ],
                              rows: services.asMap().entries.map((entry) {
                                int index = entry.key;
                                var servicer = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        style: TextStyle(fontSize: 12),
                                        servicer.getName,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        style: TextStyle(fontSize: 12),
                                        "R ${servicer.getCost.toStringAsFixed(2)}",
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          children: [
                                            uiTools.itemRemoveBtn(() {
                                              setState(() {
                                                services = const LogicTools()
                                                    .serviceItemRemover(
                                                      services,
                                                      index,
                                                    );

                                                if (editingIndex == index) {
                                                  editingIndex = -1;
                                                  serviceNameController.clear();
                                                  serviceCostController.clear();
                                                }
                                              });
                                            }),

                                            SizedBox(width: 4),

                                            uiTools.itemEditBtn(() {
                                              setState(() {
                                                serviceNameController.text =
                                                    servicer.getName;
                                                serviceCostController.text =
                                                    servicer.getCost.toString();
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
                      ],
                    ],
                  ),
                ),

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
                                "Daily total: R ${dailyTotal.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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

                      uiTools.infoContainer(
                        showInfo: showInfo4,

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
                              DataColumn(
                                label: Text(
                                  style: TextStyle(fontSize: 12),
                                  "Name:",
                                ),
                                headingRowAlignment: MainAxisAlignment.start,
                              ),

                              DataColumn(
                                label: Text(
                                  style: TextStyle(fontSize: 12),
                                  "Cost:",
                                ),
                                headingRowAlignment: MainAxisAlignment.start,
                              ),

                              DataColumn(
                                columnWidth: FixedColumnWidth(125),
                                label: Text(
                                  style: TextStyle(fontSize: 12),
                                  "Actions:",
                                ),
                                headingRowAlignment: MainAxisAlignment.start,
                              ),
                            ],

                            rows: dHabits.asMap().entries.map((entry) {
                              int index = entry.key;

                              var hab = entry.value;

                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      style: TextStyle(fontSize: 12),
                                      hab.getName,
                                    ),
                                  ),

                                  DataCell(
                                    Text(
                                      style: TextStyle(fontSize: 12),
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

                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (incomeController.text.trim().isEmpty) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter an income to track."),
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

                          for (DailyHabit habit in dHabits) {
                            await DatabaseHelper.instance.insertDailyHabit(
                              habit,
                            );
                          }

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
                      child: const Text("Save and Calculate"),
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
