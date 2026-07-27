import 'package:flutter/material.dart';
import 'package:first_flutter_app/uiTools.dart';

void main() {
  runApp(StartUpPage());
}

final List<String> services = [];

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
        body: Center(
          child: Column(
            children: [
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
                    const Text(
                      "Insert some values to calculate and track:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const TextField(
                      decoration: InputDecoration(
                        labelText: "Monthly Income",
                        hintText: "Enter your monthly income",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const TextField(
                      decoration: InputDecoration(
                        labelText: "Daily Habit Expences",
                        hintText:
                            "Enter your frequent everyday spendage cost. (per day)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
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
                            "Monthly Services",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Expanded(
                            child: Column(
                              children: [
                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Service Name",
                                    hintText: "Enter your monthly income",
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                const TextField(
                                  decoration: InputDecoration(
                                    labelText: "Monthly Expence",
                                    hintText:
                                        "Enter the ecpence for the service per month",
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                Expanded(
                                  child: SizedBox(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.teal[100],
                                        padding: const EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),

                                      onPressed: () {},

                                      child: Text("Add Service"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          Center(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Service Name")),
                              ],
                              rows: services.map((service) {
                                return DataRow(
                                  cells: [DataCell(Text(service))],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
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
