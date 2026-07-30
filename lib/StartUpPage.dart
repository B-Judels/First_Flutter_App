import 'package:first_flutter_app/DebitOrdersPage.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_app/home.dart';
import 'package:first_flutter_app/uiTools.dart';
import 'package:first_flutter_app/Services.dart';
import 'package:first_flutter_app/DailyHabits.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  final List<Services> services = [];
  final List<DebitOrdersPage> debitOrders = [];
  final List<DailyHabits> dHabits = [];
  double dailyTotal = 0;

  final TextEditingController incomeController = TextEditingController();
  final TextEditingController medicalAidController = TextEditingController();

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
                    color: Colors.teal[300],
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

                      SizedBox(height: 25.0),

                      TextField(
                        controller: medicalAidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Medical Aid",
                          hintText: "Enter your monthly medical aid expences",
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

                                    DebitOrdersPage order = new DebitOrdersPage(
                                      name: debitName,
                                      costDebit: debitCost,
                                    );
                                    setState(() {
                                      debitOrders.add(order);
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

                          const SizedBox(height: 15),

                          Center(
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
                              ],
                              rows: debitOrders.map((orderer) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(orderer.getName)),
                                    DataCell(
                                      Text(
                                        "R ${orderer.getDebitCost.toStringAsFixed(2)}",
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
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

                                Services serve = new Services(
                                  name: serviceName,
                                  costService: serviceCost,
                                );

                                setState(() {
                                  services.add(serve);
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

                      const SizedBox(height: 15),

                      Center(
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.teal[700],
                          ),
                          dataRowColor: WidgetStateProperty.all(Colors.cyan),
                          columns: const [
                            DataColumn(label: Text("Service Name")),
                            DataColumn(label: Text("Service Cost")),
                          ],
                          rows: services.map((service) {
                            return DataRow(
                              cells: [
                                DataCell(Text(service.getName)),
                                DataCell(
                                  Text(
                                    "R ${service.getServiceCost.toStringAsFixed(2)}",
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
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

                                DailyHabits hab1 = new DailyHabits(
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
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            Colors.teal[700],
                          ),
                          dataRowColor: WidgetStateProperty.all(Colors.cyan),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
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
