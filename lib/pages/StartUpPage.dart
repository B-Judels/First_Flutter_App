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
                          const Text(
                            "Monthly Debit Orders",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Column(
                            children: [
                              TextField(
                                controller: debitNameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Debit Order Name",
                                  hintText:
                                      "Enter the name for the debit order",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: 10.0),

                              TextField(
                                controller: debitCostController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Monthly Expense",
                                  hintText:
                                      "Enter the ecpense for the service per month",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: 10.0),

                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.teal[100],
                                    padding: const EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
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
                                      debitOrders.add(order);
                                    });

                                    debitNameController.clear();
                                    debitCostController.clear();
                                  },

                                  child: Text("Add Debit Order"),
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
                                    DataColumn(label: Text("Name:")),
                                    DataColumn(label: Text("Cost:")),
                                    DataColumn(label: Text("Actions:")),
                                  ],
                                  rows: debitOrders.asMap().entries.map((
                                    entry,
                                  ) {
                                    int index = entry.key;
                                    var orderer = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(orderer.getName)),
                                        DataCell(
                                          Text(
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

                                              SizedBox(width: 4),

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
                          const Text(
                            "Monthly Medical Aid",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Column(
                            children: [
                              TextField(
                                controller: medicalAidController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: "Name of Medical Aid",
                                  hintText:
                                      "Enter the name for the Medical Aid",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: 10.0),

                              TextField(
                                controller: medicalAidCostController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Monthly Expence",
                                  hintText:
                                      "Enter the ecpence for the medical aid per month",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: 10.0),

                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.teal[100],
                                    padding: const EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
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
                                    });

                                    medicalAidController.clear();
                                    medicalAidCostController.clear();
                                  },

                                  child: Text("Add Medical Aid"),
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
                                    DataColumn(label: Text("Name:")),
                                    DataColumn(label: Text("Cost:")),
                                    DataColumn(label: Text("Actions:")),
                                  ],
                                  rows: medAids.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    var servicer = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(servicer.getName)),
                                        DataCell(
                                          Text(
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
                      const Text(
                        "Monthly Services",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Column(
                        children: [
                          TextField(
                            controller: serviceNameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Service Name",
                              hintText: "Enter the name of the service",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          TextField(
                            controller: serviceCostController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Monthly Expence",
                              hintText:
                                  "Enter the expence for the service per month",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          SizedBox(height: 10.0),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                String serviceName = serviceNameController.text;
                                double serviceCost = double.parse(
                                  serviceCostController.text,
                                );

                                Service serve = Service(
                                  serviceName: serviceName,
                                  serviceCost: serviceCost,
                                );

                                setState(() {
                                  services.add(serve);
                                });

                                serviceNameController.clear();
                                serviceCostController.clear();
                              },

                              child: Text("Add Service"),
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
                                DataColumn(label: Text("Name:")),
                                DataColumn(label: Text("Cost:")),
                                DataColumn(label: Text("Actions:")),
                              ],
                              rows: services.asMap().entries.map((entry) {
                                int index = entry.key;
                                var servicer = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(servicer.getName)),
                                    DataCell(
                                      Text(
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
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                String habitName =
                                    dailyHabitNameController.text;
                                double habitCost = double.parse(
                                  dailyHabitController.text,
                                );

                                DailyHabit hab = DailyHabit(
                                  name: habitName,
                                  costDHabit: habitCost,
                                );

                                setState(() {
                                  dHabits.add(hab);

                                  dailyTotal = dailyTotal + habitCost;
                                });

                                dailyHabitNameController.clear();
                                dailyHabitController.clear();
                              },

                              child: Text("Add Daily Habit"),
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

                                              if (editingIndex == index) {
                                                editingIndex = -1;
                                                dailyHabitNameController
                                                    .clear();
                                                dailyHabitController.clear();
                                              }
                                            });
                                          }),

                                          SizedBox(width: 4),

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
                        for (DebitOrder order in debitOrders) {
                          await DatabaseHelper.instance.insertDebitOrder(order);
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
                          await DatabaseHelper.instance.insertService(service);
                        }

                        for (DailyHabit habit in dHabits) {
                          await DatabaseHelper.instance.insertDailyHabit(habit);
                        }

                        if (!mounted) return;

                        // Go directly to Home
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
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
