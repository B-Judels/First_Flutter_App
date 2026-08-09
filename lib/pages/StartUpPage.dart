import 'package:first_flutter_app/models/DebitOrder.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/pages/home.dart';
import 'package:first_flutter_app/models/Service.dart';
import 'package:first_flutter_app/models/DailyHabit.dart';
import 'package:first_flutter_app/models/MedicalAid.dart';
import 'package:first_flutter_app/models/UserSettings.dart';
import 'package:first_flutter_app/database/database_helper.dart';
import 'package:first_flutter_app/custom_tools/logicTools.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  double userIncome = 0;

  List<Service> services = [];
  final List<Service> servicesStore = [];

  List<DebitOrder> debitOrders = [];
  final List<DebitOrder> debitOrdersStore = [];

  List<MedicalAid> medAids = [];
  final List<MedicalAid> medAidsStore = [];

  List<DailyHabit> dHabits = [];
  final List<DailyHabit> dHabitsStore = [];
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
                                  labelText: "Monthly Expence",
                                  hintText:
                                      "Enter the ecpence for the service per month",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              SizedBox(height: 10.0),

                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    String debitName = debitNameController.text;
                                    double debitCost =
                                        double.tryParse(
                                          debitCostController.text,
                                        ) ??
                                        0;

                                    DebitOrder order = new DebitOrder(
                                      name: debitName,
                                      cost: debitCost,
                                    );
                                    setState(() {
                                      debitOrders.add(order);
                                      debitOrdersStore.add(order);
                                    });

                                    debitNameController.clear();
                                    debitCostController.clear();
                                  },

                                  child: Text("Add Debit Order"),
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
                                    DataColumn(label: Text("Debit Order Name")),
                                    DataColumn(label: Text("Debit Order Cost")),
                                    DataColumn(
                                      label: Text("Remove Debit Order"),
                                    ),
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
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                List<DebitOrder> newList =
                                                    const LogicTools()
                                                        .debitOrderItemRemover(
                                                          debitOrders,
                                                          index,
                                                        );
                                                debitOrders = newList;
                                              });
                                            },
                                            child: const Text("Remove"),
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
                                  onPressed: () {
                                    String medAidName =
                                        medicalAidController.text;
                                    double medAidCost =
                                        double.tryParse(
                                          medicalAidCostController.text,
                                        ) ??
                                        0;

                                    MedicalAid medAid = new MedicalAid(
                                      name: medAidName,
                                      costMedAid: medAidCost,
                                    );
                                    setState(() {
                                      medAids.add(medAid);
                                      medAidsStore.add(medAid);
                                    });

                                    medicalAidController.clear();
                                    medicalAidCostController.clear();
                                  },

                                  child: Text("Add Medical Aid"),
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
                                    DataColumn(label: Text("Medical Aid Name")),
                                    DataColumn(label: Text("Medical Aid Cost")),
                                    DataColumn(label: Text("Action")),
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
                                          OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                List<MedicalAid> newList =
                                                    const LogicTools()
                                                        .medAidItemRemover(
                                                          medAids,
                                                          index,
                                                        );
                                                medAids = newList;
                                              });
                                            },
                                            child: const Text("Remove"),
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
                              onPressed: () {
                                String serviceName = serviceNameController.text;
                                double serviceCost = double.parse(
                                  serviceCostController.text,
                                );

                                Service serve = new Service(
                                  serviceName: serviceName,
                                  serviceCost: serviceCost,
                                );

                                setState(() {
                                  services.add(serve);
                                  servicesStore.add(serve);
                                });

                                serviceNameController.clear();
                                serviceCostController.clear();
                              },

                              child: Text("Add Service"),
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
                                DataColumn(label: Text("Service Name")),
                                DataColumn(label: Text("Service Cost")),
                                DataColumn(label: Text("Remove Service")),
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
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            List<Service> newList =
                                                const LogicTools()
                                                    .serviceItemRemover(
                                                      services,
                                                      index,
                                                    );
                                            services = newList;
                                          });
                                        },
                                        child: const Text("Remove"),
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
                                  dHabitsStore.add(hab1);
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
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          // Mutates list via tools and triggers automatic mathematical UI refresh
                                          dHabits = const LogicTools()
                                              .dHabitItemRemover(
                                                dHabits,
                                                index,
                                              );
                                        });
                                      },
                                      child: const Text("Remove"),
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
                  margin: EdgeInsets.all(10.0),
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

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Data aved!")),
                        );

                        //--------------------------testing console area---------------------------
                        List<DebitOrder> ordersTest = await DatabaseHelper
                            .instance
                            .getDebitOrders();

                        print("========== DEBIT ORDERS ==========");

                        for (var order in ordersTest) {
                          print(
                            "${order.getId} ${order.getName} R${order.getCost}",
                          );
                        }

                        List<Service> servicesTest = await DatabaseHelper
                            .instance
                            .getServices();

                        print("========== SERVICES ==========");

                        for (var service in servicesTest) {
                          print(
                            "${service.getId} ${service.getName} R${service.getCost}",
                          );
                        }

                        List<MedicalAid> medAidsTest = await DatabaseHelper
                            .instance
                            .getMedicalAids();

                        print("========== MED ==========");

                        for (var med in medAidsTest) {
                          print("${med.getName} R${med.getMedAidCost}");
                        }

                        List<DailyHabit> habitsTest = await DatabaseHelper
                            .instance
                            .getDailyHabits();

                        print("========== Habits ==========");

                        for (var habit in habitsTest) {
                          print("${habit.getName} R${habit.getCost}");
                        }

                        List<UserSettings> settingsTest = await DatabaseHelper
                            .instance
                            .getUserSettings();

                        print("========== Habits ==========");

                        for (var setting in settingsTest) {
                          print(setting.getIncome);
                        }

                        //-------------------------------------------------------------------------
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
